global with sharing class cp_PlannerController {

    // CONSTRUCTOR
	public cp_PlannerController() {}


    //    =========================
    //          PAGE VARIABLES 
    //    =========================

	// The planner preference of the logged in user. If no preference exists, take the preference
    // where no user is assigned
    public static cp_PlannerPreference__c defaultPreference
    {
        get
        {
            if (defaultPreference == null)
            {
                try
                {
                    defaultPreference = [SELECT  Id
                                                , User__c
                                                , Planner__c
                                                , Planner__r.Name
                                                , Planner__r.SubType__c
                                     FROM       cp_PlannerPreference__c 
                                     WHERE      User__c = :Userinfo.getUserId() limit 1];
                }
                catch (Exception ex)
                {
                    defaultPreference = [SELECT  Id
                                                , User__c
                                                , Planner__c
                                                , Planner__r.Name
                                                , Planner__r.SubType__c
                                     FROM       cp_PlannerPreference__c 
                                     WHERE      User__c = null Limit 1];
                }
                
            }
            return defaultPreference;
        }
        set;
    }

    /**
        Date selection vars 
    **/
    public String month
    {
        get
        {
            if (month == null)
            {
                month = Date.today().addMonths(-1).month().format(); // JS months start at 0
            }
            return month;
        }
        set;
    }

    public String year
    {
        get
        {
            if (year == null)
            {
                year = String.valueOf(Date.today().year()); 
            }
            return year;
        }
        set;
    }

    // Date methods 
    public List<SelectOption> getMonthValues() 
    {
        List<SelectOption> options = new List<SelectOption>();
        // JS Dates start at 0 so we keep this in mind for hte select options
        options.add(new SelectOption('0','January'));
        options.add(new SelectOption('1','February'));
        options.add(new SelectOption('2','March'));
        options.add(new SelectOption('3','April'));
        options.add(new SelectOption('4','May'));
        options.add(new SelectOption('5','June'));
        options.add(new SelectOption('6','July'));
        options.add(new SelectOption('7','August'));
        options.add(new SelectOption('8','September'));
        options.add(new SelectOption('9','October'));
        options.add(new SelectOption('10','November'));
        options.add(new SelectOption('11','December'));
        return options;
    }

    public List<SelectOption> getYearValues() 
    {
        List<SelectOption> options = new List<SelectOption>();
        for (Integer i = -5; i <= 5; i++)
        {
            string yearToAdd = string.valueOf(system.today().addYears(i).year());
            options.add(new SelectOption(yearToAdd, yearToAdd));
        }
        return options;
    }   

    

    //    =================================
    //          PAGE REMOTE ACTIONS 
    //    =================================

    // Get the Pop Up Url when the User Clicks on Calendar
    // to Create a New Event
    @RemoteAction
    public static String getNewActionUrl()
    {
        return '/' + Schema.getGlobalDescribe().get('cp_Event__c').getDescribe().getKeyPrefix() + '/e?isdtp=vw'; 
    }

    // Get all the Records retrieved in Json Format 
    @RemoteAction
    public static calendarData getMyObjectAsJson(
        String startDate,
        String endDate,
        String advancedFilter, 
        Boolean hasGlobal, 
        List<String> PlannerFiltersTemp,
        List<String> filteruleULETemp) 
    {
        
        // Variables used to find events. Convert List string to set
        Set<String> FilterPlanners  = new Set<String>(PlannerFiltersTemp);
        Set<String> FilterULEs      = new Set<String>(filteruleULETemp);   

        // Get all Corresponding Color Records
        Map<String,String> recordPillarToColour = getRecordColours();

        // Instantiate calendar data variables
        CalendarData cData = new calendarData();
        String jsonString = '';
        
        // Instantiate JSON generator to build array of events
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();

        // Create a map of all events
        List<cp_Event__c> eventList = database.query(buildQuery(startDate, endDate, advancedFilter));
        Map<Id, cp_Event__c> eventMap = new Map<Id, cp_Event__c>(eventList);

        // Loop through events to build array
        for (cp_Event__c event :eventMap.values())
        {
            // Booleans to control visibility for the planner
            Boolean isOptOut            = false;
            Boolean plannerInvited      = false;
            Boolean uleInvited          = false;
            Boolean globalEvent         = event.Local_or_Global__c == 'Global';
            Boolean hostIsDefault       = event.HostPlanner__c == defaultPreference.Planner__c;
            String appendedPlanners     = '';
            String plannerVisibility    = '';

            // Work out if the event has been activated by the planner.
            // If activated, we show the child, not the parent event.
            Boolean allPlannersActivated = false;
            Integer countActivated = 0;

            // Loop through child events
            if (FilterPlanners.size() > 0)
            {
                for (cp_Event__c childEvent :event.Related_Events__r)
                {
                    if (eventMap.get(childEvent.Id) != null)
                    {
                        // Loop through the invited planners on the child event
                        for (cp_PlannerLocation__c plannerLoc :eventMap.get(childEvent.Id).Planner_Locations__r)
                        {
                            // If the filters include an activated planner
                            if (FilterPlanners.contains(plannerLoc.Planner__c) && plannerLoc.Activate__c)
                            {
                                countActivated++;
                            }
                        }

                        // Count to see if all selected planners have activated it or not
                        if (countActivated == FilterPlanners.size())
                        {
                            allPlannersActivated = true;
                        }
                    }
                }
                // If within the selected planners they have all activated the global, don't show the event
                // The locally activated will appear in later iterations
                if (allPlannersActivated)
                {
                    continue;
                }
            }

            // Loop through planner locations to determine if user's default planner has opted out
            // Also, build string of planners that have activated the event
            plannerVisibility = '<table>';
            for (cp_PlannerLocation__c plannerLoc :event.Planner_Locations__r)
            {
                appendedPlanners += plannerLoc.Planner__c + ';';
                
                if (plannerLoc.Planner__c == defaultPreference.Planner__c)
                {
                    if (plannerLoc.OptOut__c)
                    {
                        isOptOut = true;
                    }
                }

                if (FilterPlanners.contains(plannerLoc.Planner__c))
                {
                    plannerInvited = true;

                    plannerVisibility += '<tr><td width="150">' + plannerLoc.Planner__r.Name + '</td><td>';
                    if (plannerLoc.Activate__c)
                    {
                        //plannerVisibility += '&#10003;';
                        plannerVisibility += 'Activated';
                    }
                    if (plannerLoc.OptOut__c)
                    {
                        plannerVisibility += 'Opted-Out';
                    }
                    plannerVisibility += '</td></tr>';
                }
            }
            plannerVisibility += '</table>';

            // Create string of appended ULEs
            String appendedULEs = '';
            for (cp_ULE__c ule: event.ULE_Event_Reps__r) 
            {
                appendedULEs += ule.UnileverLeadershipExecutive__r.Full_Name__c + ';';
                if (FilterULEs.contains(ule.UnileverLeadershipExecutive__c))
                {
                    uleInvited = true;
                }
            }

            // If the global checkbox is checked
            if (hasGlobal)
            {
                // If the event is local, planner isn't invited and host planner isn't default preference
                // OR planner filters is empty (cleared) and the event is local, then skip
                if ((!globalEvent && !plannerInvited && !hostIsDefault) || (FilterPlanners.isEmpty() && !globalEvent))
                {
                    continue;
                }
            }
            // Global checkbox not checked
            else
            {
                // If opted out of event, do not show
                if (isOptOut)
                {
                    continue;
                }

                // If a planner filter and ule filter is not met, and the host planner on the event doens't match the user's planner preference
                if (!plannerInvited && !uleInvited && !hostIsDefault)
                {
                    continue;
                }

            }

            gen.writeStartObject();
            gen.writeStringField('id', event.Id);

            String eventTitle = event.Name;
            gen.writeStringField('eventName', eventTitle);
            gen.writeBooleanField('isGlobalEventOptional', isIIconBeDisplayed(event));
           
            // If local event, build event title to add planner names and ULEs
            if (event.Local_or_Global__c == 'Local')
            {
                String PreHeader = '';
                
                for (String s : appendedPlanners.split(';'))
                {
                    if (FilterPlanners != null && FilterPlanners.contains(s)) 
                    {
                        PreHeader += plannerIdToName.get(s) + '/';
                    }
                }
                  
                if (appendedULEs != '')
                {
                    for (String s: appendedULEs.split(';'))
                    {
                        if (FilterULEs != null && FilterULEs.contains(s))
                        {
                            PreHeader += uleIdToName.get(s).Full_Name__c + '/';
                        }
                    }
                }
        
                if (PreHeader.endsWith('/'))
                {
                    PreHeader = PreHeader.substring(0, PreHeader.length() -1 );
                    PreHeader += ' - ';                    
                }
        
                eventTitle = PreHeader + EventTitle; 
            }
    
            gen.writeStringField('title', eventTitle);
            gen.writeDateField('start', event.StartDate__c);
            gen.writeDateField('end', event.EndDate__c);

            // Retrieve additional data for each event
            String activityDescriptionInt = event.ActivityDescriptionInternal__c == null    ? 'undefined' : event.ActivityDescriptionInternal__c;
            String activityDescriptionExt = event.ActivityDescriptionExternal__c == null    ? 'undefined' : event.ActivityDescriptionExternal__c;
            String importance =             event.Activity_Type__c == null                  ? 'undefined' : event.Activity_Type__c;
            String code =                   event.Activity_Code__c == null                  ? 'undefined' : event.Activity_Code__c;
            String keyAudienceInt =         event.KeyAudienceInternal__c == null            ? 'undefined' : event.KeyAudienceInternal__c;
            String keyAudienceExt =         event.KeyAudienceExternal__c == null            ? 'undefined' : event.KeyAudienceExternal__c;
            String keyAudienceOther =       event.Key_Audience_Other__c == null             ? 'undefined' : event.Key_Audience_Other__c;
            String project =                event.Project_Lead__r.Name == null              ? 'undefined' : event.Project_Lead__r.Name;

            gen.writeStringField('ActivityDescriptionInternal__c', activityDescriptionInt);
            gen.writeStringField('ActivityDescriptionExternal__c', activityDescriptionExt);
            gen.writeStringField('Activity_Type__c', importance);
            gen.writeStringField('Activity_Code__c', code);
            gen.writeStringField('KeyAudienceInternal__c', keyAudienceInt);
            gen.writeStringField('KeyAudienceExternal__c', keyAudienceExt);
            gen.writeStringField('Key_Audience_Other__c', keyAudienceOther);
            gen.writeStringField('Project_Lead__c', project);
            gen.writeStringField('plannerVisibility', plannerVisibility);

            gen.writeBooleanField('isOptOut', isOptOut);
            
            // Adding Global event class if required
            if (globalEvent)
            {
                gen.writeStringField('className', 'global');
            }
                               
            // Get the List of ULE Records according to the given Criteria
            gen.writeFieldName('ULEs');
            gen.writeStartArray();
            
            for (cp_ULE__c ule: event.ULE_Event_Reps__r) 
            {
                gen.writeString(ule.UnileverLeadershipExecutive__r.Full_Name__c);
            }

            gen.writeEndArray(); 
            
            if (event.Activity_Status__c == 'Tentative')
            {
                gen.writeStringField('backgroundColor', 'white');
            }                   

            // For records for which Colour records dont exist yet
            // Use Orange as Default Colour
            String pillar = event.Narrative__c;
            String colour = event.Activity_Status__c == 'Draft'
                ? 'grey'
                : (pillar != null) ? recordPillarToColour.get(pillar) : 'orange';
                
            String textColor = (colour != null && evtBgColourWithWhiteTxt.contains(colour) && event.Activity_Status__c != 'Tentative') 
                ? 'white' 
                : 'black';
            
            gen.writeStringField('textColor', textColor);

            if (colour!=null)
            {
                gen.writeStringField('color', colour);  
            }                          
            gen.writeEndObject();

        }

        
        gen.writeEndArray();
        jsonString = gen.getAsString();
        
        // Set event Data
        cdata.eventData = jsonString;
        
        return cdata;
    }

    // Get the Cluster/MCO records
    @RemoteAction
    public static List<DropDownItem> getPlannerOptions()
    {
        List<DropDownItem> plannerOptionList = new List<DropDownItem>();
        for (cp_Planner__c planner :plannerOptions)
        {
            DropDownItem option = new DropDownItem(planner.Name, planner.Id, planner.SubType__c);
            plannerOptionList.add(option);
        }
        return plannerOptionList;
    }  

    // Parse the Given Json into Salesforce Objects and Save them to Salesforce
    @RemoteAction
    public static SaveReport saveEventObject(String jsonString){

        // JSON String
        JSONParser parser = JSON.createParser(jsonString);

        // Fields to update
        Id eventId;
        Date startDate;
        Date endDate;

        // SaveReport to return
        SaveReport sr = new SaveReport();

        // Begin parsing of JSON
        try 
        {
            while (parser.nextToken() != System.JSONToken.END_ARRAY)
            {    
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME)
                {
                    if (parser.getText() == 'id') 
                    {
                        parser.nextToken();                               
                        eventId = parser.getText();                  
                    }
                    else if (parser.getText() == 'start')
                    {
                        parser.nextToken();                     
                        startDate = Date.valueOf(parser.getText());
                    }
                    else if (parser.getText() == 'end')
                    {
                        parser.nextToken();                                      
                        endDate = Date.valueOf(parser.getText());
                    }
                }
            } 

            if (eventId != null)
            {
                update new cp_Event__c(
                    Id           = eventId,
                    StartDate__c = startDate,
                    EndDate__c   = endDate
                );
            }
                
        } 
        catch (Exception e)
        {
            sr.isSaved = false;
            sr.saveException = 'You don\'t have permission to modify this record.';
            return sr;
        }

        sr.isSaved = true;
        return sr;
    }

    //Get ActiveULE
    @RemoteAction
    public static List<cp_ULE_Contact__c> getActiveULE()
    {
        return [Select   Id
                         , Name
                         , Full_Name__c
                From     cp_ULE_Contact__c 
                Where    Active_ULE__c = True 
                Order By Full_Name__c];
    }

    // Get the Field Type of given Field for the Given Object
    @RemoteAction
    public static String getFieldType(String fieldName)
    {
        Schema.DescribeFieldResult f = getFieldMap().get(fieldName).getDescribe();
        // Get the type of the field for filter
        if ((f.getType() == Schema.DisplayType.String) 
            || (f.getType() == Schema.DisplayType.DATE) 
            || (f.getType() == Schema.DisplayType.DateTime) 
            || (f.getTYpe() == Schema.DisplayType.Integer) 
            || (f.getType() == Schema.DisplayType.Boolean)
            || (f.getType() == Schema.DisplayType.Currency) 
            || (f.getType() == Schema.DisplayType.MultiPicklist)
            || (f.getType() == Schema.DisplayType.Picklist))
        {        
            return f.getType().name();
        }
        return null;
    }

    // Get the Picklist values for the Given Object and Field Name
    @RemoteAction
    public static String getPicklistValuesAsString(String fieldName){

        final String OPT = '<option value="::v">::l</option>';
        String optionString = '';

        Schema.DescribeFieldResult f = getFieldMap().get(fieldName).getDescribe();
        
        for (Schema.PicklistEntry ple: f.getPicklistValues())
        {
            optionString += OPT.replace('::v',ple.getValue()).replace('::l', ple.getLabel());
        }

        return optionString;
    }

    // Get the list of Salesforce fields available on the advanced search for Event__c
    @RemoteAction
    public static List<CSelect> getAllFieldList(Boolean allFields){
        
        // Updated Version - Use Field Set to select available fields - Carmine Barbuto 05/02/2013
        List<cSelect> cOptions = new List<cSelect>();
        List<Schema.FieldSetMember> fieldSet = SObjectType.cp_Event__c.FieldSets.AdvancedSearchFields.getFields();
        for (Schema.FieldSetMember curr : fieldSet) {
            cSelect cs  = new cSelect();
            cs.value    = curr.getFieldPath();
            cs.label    = curr.getLabel();
            cOptions.add(cs); 
        }
        return cOptions;
    }



    //    =====================================
    //          PRIVATE UTILITY METHODS
    //    =====================================

    //Get the Field Map for the Given Object
    private static Map<String, Schema.SObjectField> getFieldMap(){

        // Get the SObject describe info
        Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>();
        Schema.SObjectType t = Schema.getGlobalDescribe().get('cp_Event__c');
        Schema.DescribeSObjectResult r = t.getDescribe();
        
        Map<String, Map<String, Schema.SObjectField>> objectFieldDescribeMap = new Map<String, Map<String, Schema.SObjectField>>();
        
        if (objectFieldDescribeMap.get('cp_Event__c') == null) 
        {
            fieldMap = r.fields.getMap();
            objectFieldDescribeMap.put('cp_Event__c', fieldMap);
                
        } 
        else 
        {
            fieldMap = objectFieldDescribeMap.get('cp_Event__c');
        }
        
        return fieldMap;
    }

    // Full list of available planner options
    private static List<cp_Planner__c> plannerOptions
    {
        get
        {
            if (plannerOptions == null)
            {
                plannerOptions = [Select Id, Name, Type__c, SubType__c From cp_Planner__c Order by Name LIMIT 5000];
            }
            return plannerOptions;
        }
        set;
    }

    // Map of planner id to planner name
    public static Map<Id, String> plannerIdToName
    {
        get
        {
            if (plannerIdToName == null)
            {
                plannerIdToName = new Map<Id, String>();
                for (cp_Planner__c planner :plannerOptions)
                {
                    plannerIdToName.put(planner.Id, planner.Name);
                }
            }
            return plannerIdToName;
        }
        set;
    }

    // Map of ULE Ids to name
    private static Map<Id, cp_ULE_Contact__c> uleIdToName
    {
        get
        {
            if (uleIdToName == null)
            {
                uleIdToName = new Map<Id, cp_ULE_Contact__c>([Select Id, Full_Name__c From cp_ULE_Contact__c LIMIT 7000]);
            }
            return uleIdToName;
        }
        set;
    }

    // return should partical event have (i) icon displayed
    // logic - true will be return only if all following conditions on the event are true
    // 1) is global (Local_or_Global__c = Label.Planner_Code_AT_I_Global)
    // 2) is approved (Activity_Status__c in label.Planner_Code_AT_I_Approced_Statuses)
    // 3) Activity_Type__c (Plan on a Page Layout) has one of values from Planner_Code_AT_I_Statuses label ()
    // 4) event is not in user market (there is no event location record existing which matches 
    //   user  country, cluster or mco)
    public static boolean isIIconBeDisplayed(cp_Event__c ev)
    {
        
        Boolean displayIIcon = false;
        
        // prepare are variables for conditions check
        String strGlobal                = Label.cp_Planner_Code_AT_I_Global;
        String strApprovedStatus        = Label.cp_Planner_Code_AT_I_Approced_Statuses;
        String strActivityTypes         = Label.cp_Planner_Code_AT_I_Statuses;
        Set<String> setApprovedStatuses = new Set<String>();
        Set<String> setActivityTypes    = new Set<String>();

        if (!String.isBlank(strApprovedStatus))
        {
            setApprovedStatuses.addAll(strApprovedStatus.split(','));
        }

        if (!String.isBlank(strActivityTypes))
        {
            setActivityTypes.addAll(strActivityTypes.split(','));
        }

        // check conditions 1,2,3
        if (ev.Local_or_Global__c == strGlobal && setApprovedStatuses.contains(ev.Activity_Status__c) && setActivityTypes.contains(ev.Activity_Type__c))
        { 
            Boolean defaultPlannerInvited = false;
            for (cp_PlannerLocation__c plannerLoc :ev.Planner_Locations__r)
            {
                if (plannerLoc.Planner__c == defaultPreference.Planner__c)
                {
                    defaultPlannerInvited = true;
                    break;
                }
            }

            if (!defaultPlannerInvited)
            {
                displayIIcon = true;
            }
        }

        return displayIIcon;
    }

    /* Get the chosen colours for the records */
    private static Map<String, String> getRecordColours()
    {
        /* used to set the colours of events on the calendar at load time */
        Map<String,String> recordPillarToColour = new Map<String,String>();
        
        recordPillarToColour.put('Sustainable Growth', '#78BE20');
        recordPillarToColour.put('Our Operations', '#702F8A');
        recordPillarToColour.put('Our Brands', '#00A9E0');
        recordPillarToColour.put('Our People', '#DA291C');
        recordPillarToColour.put('Functional Activity', '#FFD100');
        recordPillarToColour.put('Non Unilever event', '#004976');

        return recordPillarToColour;
    }

    private static String buildQuery(String startDate, String endDate, String advancedFilter) 
    {
        String eventQuery = 
            'Select Id ' +
                    ', Parent_Event__c ' +
                    ', Name ' +
                    ', StartDate__c ' +
                    ', EndDate__c ' +
                    ', Narrative__c ' +
                    ', ActivityDescriptionInternal__c ' + 
                    ', ActivityDescriptionExternal__c ' + 
                    ', Activity_Status__c ' +
                    ', Activity_Type__c ' +
                    ', Activity_Code__c ' +
                    ', Project_Lead__r.Name ' +
                    ', Global_Events__c ' +
                    ', KeyAudienceInternal__c ' +
                    ', KeyAudienceExternal__c ' +
                    ', Key_Audience_Other__c ' +
                    ', OwnerId  ' +
                    ', HostPlanner__c ' + 
                    ', Local_or_Global__c ' +
                    ', (Select Name, UnileverLeadershipExecutive__r.Full_Name__c from ULE_Event_Reps__r) ' +
                    ', (Select Id, Planner__c, Planner__r.Name, OptOut__c, Activate__c From Planner_Locations__r Order by Planner__r.Name) ' +
                    ', (Select Id From Related_Events__r) ' +
            ' From  cp_Event__c ' +
            ' Where (                                                                                                   ' +
            '           Activity_Status__c != \'Offline\' AND (Activity_Status__c != \'Draft\' OR OwnerId = \'' + UserInfo.getUserId() + '\' OR HostPlanner__c = \'' + defaultPreference.Planner__c + '\') ' + 
            '       )           ' +
            '       AND         ' +
            '       (           ' + 
            '             (StartDate__c >= '   + startDate + ' AND StartDate__c <= '   + endDate + ') ' + 
            '          OR (EndDate__c   >= '   + startDate + ' AND EndDate__c <= '     + endDate   + ') ' +
            '          OR (StartDate__c <= '   + startDate + ' AND EndDate__c >= '     + endDate   + ') ' +
            '       ) ';

        if (advancedFilter != null && advancedFilter != '')
        {
            eventQuery += ' AND ' + advancedFilter;
        }
        return eventQuery;
    }

    public static Set<String> evtBgColourWithWhiteTxt =
        new Set<String>{
            'grey', 
            'black',
            '#702F8A',
            '#004976',
            '#3366CC'
        };

    //    =========================
    //          WRAPPER OBJECTS
    //    =========================

    // Wrapper created for sending save report to client
    public class SaveReport 
    {
        public Boolean isSaved;
        public String saveException;
        public SaveReport () 
        {
            isSaved = true;
            saveException = '';
        }
    }
    
    // Wrapper created to feed option values and Labels into Javascript 
    public class CSelect 
    {
        public String label {get;set;}
        public String value {get;set;}
    }
    
    // Wrapper for indicating whether records contained null values 
    // Or Start Date value is greater than End Date Value (Contradiction)
    public class RecordStatus 
    {
        public Boolean nullValues;
        public Boolean contradictions;
        public Boolean isUpdatable;
        public RecordStatus () 
        {
            nullValues = false;
            contradictions = false;
            isUpdatable = true;
        }
    }
    
    //Wrapper containing Json Event Data and Stus Flag
    public class calendarData 
    {
        public String eventData;
        public RecordStatus status;
        public calendarData ()
        {
            status = new RecordStatus();
        }
    }

    public class DropDownItem 
    {
        public String Label;
        public String Value;
        public String plannerSubType;

        public DropDownItem(String l, String v, String t) 
        {
            this.Label = l;
            this.Value = v;
            this.plannerSubType = t;
        }
    }
}