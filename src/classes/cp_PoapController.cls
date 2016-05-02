/*
    Controller for the cp_PoaP Page.
    This controller controls what events are returned to the page
    And handles all filtering methods and logic
*/
public with sharing class cp_PoapController {

    /* Activity Status Constants */
    private static final String AS_TENTATIVE        = 'Tentative';
    private static final String AS_CONFIRMED        = 'Confirmed';
    private static final String AS_DRAFT            = 'Draft';
    private static final String AS_OFFLINE          = 'Offline';
    private static final String EVT_NOT_IN_POAP     = 'I do not want this event on my Plan on a Page';

    /* Colour constants */
    private final String C_GREY = 'grey';
    private final String C_WHITE = 'white';

    /*theme colors*/
    private final String C_BUSINESS_PERFORMANCE     = 'Our Operations';
    private final String C_SUSTAINABLE_LIVING       = 'Sustainable Growth';
    private final String C_BRAND_INNOVATION         = 'Our Brands';
    private final String C_GREAT_PEOPLE_GREAT_PLACE = 'Our People';
    private final String C_PLANNING_MEETING         = 'Functional Activity';
    private final String C_EXTERNAL_EVENTS          = 'Non Unilever Event';

    
    /*ActivityType*/
    private final String C_BIG_MOMENT = 'Tier 1 - Big Moment';
    private final String C_CORPORATE_INTERNAL = 'Tier 1 - Internal';
    private final String C_CORPORATE_EXTERNAL = 'Tier 1 - External';
    private final String C_INTEGRATED_LOCAL = 'Tier 2 - Integrated (external & internal)';
    private final String C_MCO_EXTERNAL ='Tier 2 - External';
    private final String C_MCO_INTERNAL = 'Tier 2 - Internal';
    private final String C_OPERATIONAL_COMMS = 'Enabler - Operational Activity';
    private final String C_FUNCTION_CATEGORY = 'Enabler - Capability Building';
    
    private final String F_EXPERTISE = 'Expertise__c';

    private final Map<String, Schema.SobjectField> EventMap = Schema.getGlobalDescribe().get('cp_Event__c').getDescribe().fields.getMap(); 

    public static cp_PlannerPreference__c defaultPreference
    {
        get
        {
            if (defaultPreference == null)
            {
                defaultPreference = cp_PlannerController.defaultPreference;
            }
            return defaultPreference;
        }
        set;
    }

    public Boolean addGlobal        
    {
        get 
        {
            if (addGlobal == null)
            {
                addGlobal = false;
            }   
            return addGlobal;
        }   
        set;    
    }

    public Boolean globalOnly
    {
        get
        {
            if (globalOnly == null)
            {
                globalOnly = false;
            }
            return globalOnly;
        }
        set;
    }

    public String FirstMonth            {get;set;}
    public String LastMonth             {get;set;}
    public String FirstYear             {get;set;}
    public String LastYear              {get;set;}
    
    //advanced filters
    public String FieldLabel1           {get;set;}
    public String FieldName1            {get;set;}
    public String Operator1             {get;set;}
    public String FieldValue1           {get;set;}
    public String FieldValueDate1       {get;set;}

    public String plannerFilter         {get;set;}
    public String PlannerRendering      {get;set;}
    public String AdvFiltersRendering   {get;set;}

    private Map<Integer,String> monthIntegerToString = new Map<Integer,String>{
        1 => 'January',
        2 => 'February',
        3 => 'March',
        4 => 'April',
        5 => 'May',
        6 => 'June',
        7 => 'July',
        8 => 'August',
        9 => 'September',
        10 => 'October',
        11 => 'November',
        12 => 'December'
    };
    
    private map<String, String> ThemeColors 
    {
        get 
        {
            if (ThemeColors==null) 
            {
                ThemeColors = new map<String, String>();
                ThemeColors.put(C_BUSINESS_PERFORMANCE, '#702F8A');
                ThemeColors.put(C_SUSTAINABLE_LIVING, '#78BE20');
                ThemeColors.put(C_BRAND_INNOVATION, '#00A9E0');
                ThemeColors.put(C_GREAT_PEOPLE_GREAT_PLACE, '#DA291C');
                ThemeColors.put(C_PLANNING_MEETING, '#FFD100');
                ThemeColors.put(C_EXTERNAL_EVENTS, '#004976');
            }
            return ThemeColors;
        }
        set;
    }
    
    public List<SelectOption> getFirstMonthValues() 
    {
        List<SelectOption> options = new List<SelectOption>();
        for (Integer month :monthIntegerToString.keySet())
        {
            options.add(new SelectOption(
                string.valueOf(month),
                monthIntegerToString.get(month))
            );
        }
        return options;
    }

    public List<SelectOption> getLastMonthValues() 
    {
        List<SelectOption> options = new List<SelectOption>();
        for (Integer month :monthIntegerToString.keySet())
        {
            options.add(new SelectOption(
                string.valueOf(month),
                monthIntegerToString.get(month))
            );
        }
        return options;
    }

    public List<SelectOption> getFirstYearValues() 
    {

        List<SelectOption> options = new List<SelectOption>();
        for (Integer i = -5; i <= 5; i++)
        {
            string yearToAdd = string.valueOf(system.today().addYears(i).year());
            options.add(new SelectOption(yearToAdd, yearToAdd));
        }
        return options;
    }

    public List<SelectOption> getLastYearValues() 
    {
        List<SelectOption> options = new List<SelectOption>();
        for (Integer i = -5; i <= 5; i++)
        {
            string yearToAdd = string.valueOf(system.today().addYears(i).year());
            options.add(new SelectOption(yearToAdd, yearToAdd));
        }
        return options;
    }
    
    public cp_PoapController() 
    {
        FirstMonth = '1';
        LastMonth = '12';
        FirstYear = String.valueOf(Date.today().year());
        LastYear = FirstYear;

        LoadingFilters();   
    }
    
    public void LoadingFilters() 
    {
        plannerFilter = defaultPreference.Planner__c;
        plannerRendering = defaultPreference.Planner__r.Name;
    }  

    public void setPlanner()
    {
        if (!globalOnly)
        {
            plannerFilter       = ApexPages.CurrentPage().getParameters().get('plannerFilter');
            plannerRendering    = cp_PlannerController.plannerIdToName.get(plannerFilter);
        }
        else 
        {
            plannerFilter       = '';
            plannerRendering    = '';
        }
        
    }

    public String fillEmptyRowDyn(String Header, Integer NumberOfMonths) 
    {
        String HTMLReturn = '';
        HTMLReturn = '<tr class="otherLines"><td style="text-align:center;" class="standardCell firstCell">'+(Header.contains(' - ')?Header.split(' - ')[1]:Header)+'</td>';
        for (Integer i = 1 ; i<NumberOfMonths + 1 ; i++)
        {
            HTMLReturn += '<td class="standardCell">&nbsp;</td>';
        }
        HTMLReturn += '</tr>';
        return HTMLReturn;
    }

    public list<cp_Event__c> SortEvents(List<cp_Event__c> Events)
    {
        List<Date> DateHelper = new List<Date>();
        for (cp_Event__c ev:Events) 
        {
            DateHelper.add(ev.StartDate__c);
        }
        DateHelper.sort();

        list<cp_Event__c> EventsReturned = new list<cp_Event__c>();
        
        for(Date myDate:DateHelper) 
        {
            for (cp_Event__c ev:Events) 
            {
                if (myDate == ev.StartDate__c) 
                {
                    EventsReturned.add(ev);
                }
            } 
        }
        return EventsReturned;
    }

    public String addHeaderCategory(String HeaderName, Integer NumberOfMonths) 
    {
        String HTMLReturn = '<tr><td class="sub-heading" colspan="'+NumberOfMonths+'">';
        HTMLReturn += HeaderName;
        HTMLReturn += '</td></tr>';
        return HTMLReturn;
    }

    public String AddPossibleHeader(String category, Integer NumberOfMonths) 
    {
        String HTMLReturn = '';
        if (category == C_BIG_MOMENT) 
        {
            HTMLReturn = addHeaderCategory('TIER 1 – FOR ACTION – WE DO IT TOGETHER EVERYWHERE', NumberOfMonths + 1);
        }
        else if (category == C_INTEGRATED_LOCAL) 
        {
            HTMLReturn = addHeaderCategory('TIER 2 – FOR ACTION – WE DO IT WHERE WE CAN MAKE THE BIGGEST BUSINESS IMPACT', NumberOfMonths + 1);
        }
        else if (category == C_OPERATIONAL_COMMS) 
        {
            HTMLReturn = addHeaderCategory('ENABLER - ACTIVITIES TO SUPPORT DELIVERY', NumberOfMonths + 1);
        }
        return HTMLReturn;
    }

    public String addEvent2HTML(map<Integer, list<cp_Event__c>> MyEvents, String Category) 
    {
        //the size of the map represents the size of the category (e.g. Big Moment)
        //the list of events are the events to be displayed on each line.
        String HTMLReturn='';
        HTMLReturn = '<tr class="otherLines">';
        HTMLReturn += '<td style="text-align:center;" class="standardCell firstCell" rowspan="'+MyEvents.size()+'">';
        HTMLReturn += Category.contains(' - ')?Category.split(' - ')[1]:Category ;
        HTMLReturn += '</td>';
        Date startDate = date.newinstance(Integer.valueOf(FirstYear), Integer.valueOf(FirstMonth), 1);
        Date lastDate = date.newinstance(Integer.valueOf(LastYear), Integer.valueOf(LastMonth), 1);
        String colour;
        Integer NumberOfMonths = startDate.monthsBetween(lastDate) + 1;
        Date EventEndDate;

        for (Integer i=0; i<MyEvents.size();i++) 
        {
            //we first sort the events chronologically.
            if (i != 0)
            { //the first tr has already been added for the first line.
                HTMLReturn += '<tr>';
            }

            list<cp_Event__c> RowOfEventsSorted = SortEvents(MyEvents.get(i));

            EventEndDate = startDate;

            for (cp_Event__c event:RowOfEventsSorted) 
            {
                if (ThemeColors.containsKey(event.Narrative__c))
                {
                    colour = ThemeColors.get(event.Narrative__c);
                }
                else
                {
                    colour = 'black';
                }

                Integer colSpan = event.StartDate__c.monthsBetween(event.EndDate__c.addMonths(1));
                Integer monthsFromStartDate = startDate.monthsBetween(event.StartDate__c);
                String backgroundColour ;
                String borderColour = '';
                String borderWidth = '';
                
                if (monthsFromStartDate < 0)
                {
                    colSpan += monthsFromStartDate;
                }

                if(LastDate.monthsBetween(event.EndDate__c) > 0)
                {
                    colSpan -= LastDate.monthsBetween(event.EndDate__c);
                }

                if (event.Activity_Status__c == AS_CONFIRMED)
                {
                    backgroundColour = colour;  
                } 
                else if (event.Activity_Status__c == AS_TENTATIVE)
                {
                    backgroundColour = C_WHITE; 
                    borderColour = colour;
                    borderWidth = '2';

                } 
                else if (event.Activity_Status__c == AS_DRAFT)
                {
                    backgroundColour = C_GREY;
                }

                for (Integer j=1 ; j < EventEndDate.monthsBetween(event.StartDate__c) +1; j++) 
                {
                    HTMLReturn += '<td></td>';
                }

                HTMLReturn += '<td class="standardCell" ' +
                    'colspan="'+ colSpan + '" ' +
                    'style="background-color:'+backgroundColour+ ';'+
                    'border:'+borderWidth+'px '+borderColour+' solid;'+
                    'padding:5px;"><a href="/' + event.Id + '" target="_blank" style="color:' + 
                    ((backgroundColour != null && cp_PlannerController.evtBgColourWithWhiteTxt.contains(backgroundColour) && event.Activity_Status__c != AS_TENTATIVE) 
                        ? 'white' : 'black') + '">'; //darkblue or purple.
                HTMLReturn += event.Name;
                HTMLReturn += '</a></td>';

                startDate = event.StartDate__c;
                EventEndDate = event.EndDate__c.addMonths(1);
            }
            startDate = date.newinstance(Integer.valueOf(FirstYear), Integer.valueOf(FirstMonth), 1);
            //we fill the end with empty months.
            for (Integer j=NumberOfMonths ; j > startDate.monthsBetween(EventEndDate) ; j--) 
            {
                HTMLReturn += '<td></td>';
            }

            HTMLReturn += '</tr>';
        }

        return HTMLReturn;
    }

    public Component.Apex.OutputText getMyTable() 
    {
        String colour;

        Date startDate          = date.newinstance(Integer.valueOf(FirstYear), Integer.valueOf(FirstMonth), 1);
        Integer numberOfDays    = Date.daysInMonth(Integer.valueOf(LastYear), Integer.valueOf(LastMonth));
        Date lastDate           = date.newinstance(Integer.valueOf(LastYear), Integer.valueOf(LastMonth), numberOfDays);
        Integer numberOfMonths  = startDate.monthsBetween(lastDate) + 1;

        Component.Apex.OutputText HTMLTable = new Component.Apex.OutputText(escape = false);
        HTMLTable.value = '<table border="0" id="TableId" cellpadding="0" cellspacing="0" style="border-style:outset;border:1px solid lightblue;">';
        HTMLTable.value += '<tr class="first"><td style="background-color:transparent;">&nbsp;</td>';

        for (Integer i = 1; i <= numberOfMonths; i++)
        {
            // Custom format of the date. Used to use datetime.format, but the datetime conversion
            // was causing issues with time zones.
            String tempDateString = string.valueOf(StartDate.addMonths(i-1));
            Integer monthInteger = integer.valueOf(tempDateString.mid(5,2));
            String dateString =  monthIntegerToString.get(monthInteger) + ' ' + tempDateString.left(4);
            
            // Add month value to header
            HTMLTable.value += '<td>' +  dateString + '</td>';
        }

        HTMLTable.value += '</tr>';

        Date LastDateQuery = LastDate.addMonths(1);

        String advancedFilter = '';

        if (FieldName1 != null && FieldName1 != '')
        {
            AdvFiltersRendering = String.escapeSingleQuotes(FieldLabel1) + ' ' + String.escapeSingleQuotes(Operator1) + ' ' + String.escapeSingleQuotes(FieldValue1) + String.escapeSingleQuotes(FieldValueDate1);
            advancedFilter = addAdvancedFilter(FieldName1, Operator1, FieldValue1, FieldValueDate1);
        }
        else
        {
            AdvFiltersRendering = '';
        }
        
        // Create a map of all events
        List<cp_Event__c> eventList = database.query(buildQuery(startDate, lastDate, advancedFilter));
        Map<Id, cp_Event__c> eventsMap = new Map<Id, cp_Event__c>(eventList);

        String lastSubCategory;
        Set<String> MyCategories = new Set<String>();
        Map<Integer, List<cp_Event__c>> MyEvents = new Map<Integer, List<cp_Event__c>>();
        
        if (StartDate <= LastDate) 
        {
            for (cp_Event__c oEvent :eventList) 
            {

                // Booleans to control visibility for the planner
                Boolean isOptOut            = false;
                Boolean plannerInvited      = false;
                Boolean globalEvent         = oEvent.Local_or_Global__c == 'Global';
                Boolean hostIsDefault       = oEvent.HostPlanner__c == defaultPreference.Planner__c;

                // If the event is Do Not Display or a Non Unilever Event
                if (oEvent.Activity_Type__c == EVT_NOT_IN_POAP)
                {
                    continue;
                }

                // If global only is checked, show all global events, only global
                if (globalOnly)
                {
                    if (!globalEvent)
                    {
                        continue;
                    }
                }
                else 
                {
                    // Work out if the event has been activated by the planner.
                    // If activated, we show the child, not the parent event.
                    Boolean eventActivated = false;

                    // Loop through child events
                    for (cp_Event__c childEvent :oEvent.Related_Events__r)
                    {
                        // If the child event cannot be found in the original list
                        // The event hasn't met the original filter criteria
                        if (eventsMap.get(childEvent.Id) != null)
                        {
                            // Loop through the invited planners on the child event
                            for (cp_PlannerLocation__c plannerLoc :eventsMap.get(childEvent.Id).Planner_Locations__r)
                            {
                                // If the filters include an activated planner
                                if (plannerFilter == plannerLoc.Planner__c && plannerLoc.Activate__c)
                                {
                                    eventActivated = true;
                                }
                            }
                        }
                    }
                    // If the event is activated, skip the record. The child event
                    // will appear in later iterations.
                    if (!addGlobal && eventActivated)
                    {
                        continue;
                    }

                    // Loop through planner locations to determine if user's default planner has opted out
                    // Also, build string of planners that have activated the event
                    for (cp_PlannerLocation__c plannerLoc :oEvent.Planner_Locations__r)
                    {
                        if (plannerFilter == plannerLoc.Planner__c)
                        {
                            plannerInvited = true;
                            if (plannerLoc.OptOut__c)
                            {
                                isOptOut = true;
                            }
                        }

                    }

                    // If global events is checked and the event isn't global, and I'm not invited and host planner isn't user's default preference
                    if (addGlobal && !globalEvent && !plannerInvited && !hostIsDefault)
                    {
                        continue;
                    }

                    // Global checkbox not checked
                    if (!addGlobal)
                    {
                        // If opted out of event, do not show
                        if (isOptOut)
                        {
                            continue;
                        }

                        // If a planner filter or host planner isn't user's default preference
                        if (!plannerInvited && !hostIsDefault)
                        {
                            continue;
                        }

                    }
                }


                String ActivityType = oEvent.Activity_Type__c;
                MyCategories.add(ActivityType);

                //we insert here an empty row if the activity type still does not exist.
                if (lastSubCategory != ActivityType) 
                {
                    // TODO: we transform here the MyEvents in HTML.
                    HTMLTable.value += AddPossibleHeader(lastSubCategory, NumberOfMonths);

                    if (lastSubCategory != null) 
                    {//it happens the first time that it's null
                        HTMLTable.value += addEvent2HTML(MyEvents, lastSubCategory);
                    }

                    lastSubCategory = ActivityType;
                    MyEvents = new map<Integer, list<cp_Event__c>>();
                }

                if((
                    ActivityType == C_CORPORATE_EXTERNAL ||
                    ActivityType == C_CORPORATE_INTERNAL ||
                    ActivityType == C_INTEGRATED_LOCAL ||
                    ActivityType == C_MCO_EXTERNAL ||
                    ActivityType == C_MCO_INTERNAL ||
                    ActivityType == C_OPERATIONAL_COMMS ||
                    ActivityType == C_FUNCTION_CATEGORY )&& !MyCategories.contains(C_BIG_MOMENT)) 
                {
                    HTMLTable.value += AddPossibleHeader(C_BIG_MOMENT, NumberOfMonths);
                    HTMLTable.value += fillEmptyRowDyn(C_BIG_MOMENT, NumberOfMonths);
                    MyCategories.add(C_BIG_MOMENT);
                } 

                if((ActivityType == C_CORPORATE_INTERNAL ||
                    ActivityType == C_INTEGRATED_LOCAL ||
                    ActivityType == C_MCO_EXTERNAL ||
                    ActivityType == C_MCO_INTERNAL ||
                    ActivityType == C_OPERATIONAL_COMMS ||
                    ActivityType == C_FUNCTION_CATEGORY ) && !MyCategories.contains(C_CORPORATE_EXTERNAL)) 
                {
                    HTMLTable.value += fillEmptyRowDyn(C_CORPORATE_EXTERNAL, NumberOfMonths);
                    MyCategories.add(C_CORPORATE_EXTERNAL);
                }

                if ((ActivityType == C_INTEGRATED_LOCAL ||
                    ActivityType == C_MCO_EXTERNAL ||
                    ActivityType == C_MCO_INTERNAL ||
                    ActivityType == C_OPERATIONAL_COMMS ||
                    ActivityType == C_FUNCTION_CATEGORY ) && !MyCategories.contains(C_CORPORATE_INTERNAL)) 
                {
                    HTMLTable.value += fillEmptyRowDyn(C_CORPORATE_INTERNAL, NumberOfMonths);
                    MyCategories.add(C_CORPORATE_INTERNAL);
                }

                if ((ActivityType == C_MCO_EXTERNAL ||
                    ActivityType == C_MCO_INTERNAL ||
                    ActivityType == C_OPERATIONAL_COMMS ||
                    ActivityType == C_FUNCTION_CATEGORY ) && !MyCategories.contains(C_INTEGRATED_LOCAL)) 
                {
                    HTMLTable.value += AddPossibleHeader(C_INTEGRATED_LOCAL, NumberOfMonths);
                    HTMLTable.value += fillEmptyRowDyn(C_INTEGRATED_LOCAL, NumberOfMonths);
                    MyCategories.add(C_INTEGRATED_LOCAL);
                }

                if ((ActivityType == C_MCO_INTERNAL ||
                    ActivityType == C_OPERATIONAL_COMMS ||
                    ActivityType == C_FUNCTION_CATEGORY )  && !MyCategories.contains(C_MCO_EXTERNAL)) 
                {
                    HTMLTable.value += fillEmptyRowDyn(C_MCO_EXTERNAL, NumberOfMonths);
                    MyCategories.add(C_MCO_EXTERNAL);
                }

                if ((ActivityType == C_OPERATIONAL_COMMS ||
                    ActivityType == C_FUNCTION_CATEGORY )  && !MyCategories.contains(C_MCO_INTERNAL)) 
                {
                    HTMLTable.value += fillEmptyRowDyn(C_MCO_INTERNAL, NumberOfMonths);
                    MyCategories.add(C_MCO_INTERNAL);
                }

                if (ActivityType == C_FUNCTION_CATEGORY && !MyCategories.contains(C_OPERATIONAL_COMMS)) 
                {
                    HTMLTable.value += AddPossibleHeader(C_OPERATIONAL_COMMS, NumberOfMonths);
                    HTMLTable.value += fillEmptyRowDyn(C_OPERATIONAL_COMMS, NumberOfMonths);
                    MyCategories.add(C_OPERATIONAL_COMMS);
                }

                if (oEvent.StartDate__c <= oEvent.EndDate__c) 
                {
                    if (MyEvents.isEmpty()) 
                    {
                        MyEvents.put(0, new list<cp_Event__c>{oEvent});
                    } 
                    else 
                    {
                        Boolean isPlacementPossible = true;
                        Integer i=0;
                        for (i=0; i<MyEvents.size();i++) 
                        {
                            isPlacementPossible = true;
                            for (cp_Event__c event:MyEvents.get(i)) 
                            {
                                if (event.StartDate__c.monthsBetween(oEvent.EndDate__c) >= 0 && oEvent.StartDate__c.monthsBetween(event.EndDate__c) >= 0)
                                {
                                   isPlacementPossible = false;
                                   break;
                                }
                            }

                            if (isPlacementPossible) 
                            {
                                break;
                            }
                        }

                        if(isPlacementPossible) 
                        {
                            MyEvents.get(i).add(oEvent);
                        }
                        else
                        {
                            //the event will be displayed in a new row.
                            MyEvents.put(MyEvents.size(), new list<cp_Event__c>{oEvent});
                        }
                    }
                }
            }
        }

        //after the last event.
        if(!MyEvents.isEmpty()) 
        {
            HTMLTable.value += AddPossibleHeader(lastSubCategory, NumberOfMonths);
            HTMLTable.value += addEvent2HTML(MyEvents, lastSubCategory);
        }

        if(!MyCategories.contains(C_BIG_MOMENT)) 
        {
            HTMLTable.value += AddPossibleHeader(C_BIG_MOMENT, NumberOfMonths);
            HTMLTable.value += fillEmptyRowDyn(C_BIG_MOMENT, NumberOfMonths);
        } 

        if(!MyCategories.contains(C_CORPORATE_EXTERNAL)) 
        {
            HTMLTable.value += fillEmptyRowDyn(C_CORPORATE_EXTERNAL, NumberOfMonths);
        }

        if(!MyCategories.contains(C_CORPORATE_INTERNAL)) 
        {
            HTMLTable.value += fillEmptyRowDyn(C_CORPORATE_INTERNAL, NumberOfMonths);
        }

        if(!MyCategories.contains(C_INTEGRATED_LOCAL)) 
        {
            HTMLTable.value += AddPossibleHeader(C_INTEGRATED_LOCAL, NumberOfMonths);
            HTMLTable.value += fillEmptyRowDyn(C_INTEGRATED_LOCAL, NumberOfMonths);
        }

        if(!MyCategories.contains(C_MCO_EXTERNAL)) 
        {
            HTMLTable.value += fillEmptyRowDyn(C_MCO_EXTERNAL, NumberOfMonths);
        }

        if(!MyCategories.contains(C_MCO_INTERNAL)) 
        {
            HTMLTable.value += fillEmptyRowDyn(C_MCO_INTERNAL, NumberOfMonths);
        }

        if(!MyCategories.contains(C_OPERATIONAL_COMMS)) 
        {
            HTMLTable.value += AddPossibleHeader(C_OPERATIONAL_COMMS, NumberOfMonths);
            HTMLTable.value += fillEmptyRowDyn(C_OPERATIONAL_COMMS, NumberOfMonths);
        }

        if(!MyCategories.contains(C_FUNCTION_CATEGORY)) 
        {
            HTMLTable.value += fillEmptyRowDyn(C_FUNCTION_CATEGORY, NumberOfMonths);
        }

        HTMLTable.value += '</table>';
        
        return HTMLTable;
    }

    // Build where clause for the advanced filter
    private String addAdvancedFilter(String FieldName, String Operator, String FieldValue, String FieldValueDate) 
    {
        String queryClause = '';
        if (FieldName != null)
        {
            if (Operator.contains('includes') || Operator.contains('excludes')) 
            {
                if (FieldValue == null) 
                {
                    queryClause += FieldName + ' ' + Operator + ' ' +  '(\'\')';
                }
                else
                {
                    queryClause += '(';
                    for (String s:FieldValue.split(','))
                    {
                        queryClause += FieldName + ' ' + Operator + ' (\'' + String.escapeSingleQuotes(s) + '\') OR ' ;
                    }
                    queryClause = queryClause.substring(0, queryClause.length() - 3);
                    queryClause += ')';
                }
            }
            else 
            {
                if (String.valueOf(EventMap.get(FieldName).getDescribe().getType()) == 'BOOLEAN' ||
                   String.valueOf(EventMap.get(FieldName).getDescribe().getType()) == 'DATETIME' ||
                   String.valueOf(EventMap.get(FieldName).getDescribe().getType()) == 'DATE') 
                {
                    if (String.valueOf(EventMap.get(FieldName).getDescribe().getType()) == 'DATETIME' ||
                        String.valueOf(EventMap.get(FieldName).getDescribe().getType()) == 'DATE')
                    {
                        if (FieldValueDate.contains(' '))
                        {
                            FieldValueDate = FieldValueDate.replace(' ', 'T');
                            FieldValueDate += 'Z';
                        }
                        if (FieldValueDate != null && FieldValueDate != '')
                        {
                            queryClause += FieldName + ' ' + Operator + ' ' + String.escapeSingleQuotes(FieldValueDate) + ' ';
                        }
                    }
                    else
                    {
                        queryClause += FieldName + ' ' + Operator + ' ' + String.escapeSingleQuotes(FieldValue) + ' ';
                    }
                }
                else
                {
                    queryClause += FieldName + ' ' + Operator + ' \'' + String.escapeSingleQuotes(FieldValue) + '\'';
                }
                
            }
        }
        return queryClause;
    }  

    private static String buildQuery(Date startDate, Date endDate, String advancedFilter) 
    {
        String eventQuery = 
            'Select Id ' +
                    ', Parent_Event__c ' +
                    ', Name ' +
                    ', StartDate__c ' +
                    ', EndDate__c ' +
                    ', Track_ULE__c ' +
                    ', Narrative__c ' +
                    ', Activity_Status__c ' +
                    ', Activity_Type__c ' +
                    ', Activity_Code__c ' +
                    ', Project_Lead__r.Name ' +
                    ', Global_Events__c ' +
                    ', Activity_Description__c ' +
                    ', Key_Audience__c ' +
                    ', Key_Audience_Other__c ' +
                    ', OwnerId  ' +
                    ', HostPlanner__c ' + 
                    ', Local_or_Global__c ' +
                    ', (Select Id, Planner__c, Planner__r.Name, OptOut__c, Activate__c From Planner_Locations__r) ' +
                    ', (Select Id From Related_Events__r) ' +
            ' From  cp_Event__c ' +
            ' Where Narrative__c != \'Non Unilever event\'' + 
            '       AND ' +
            '       ( ' +
            '           Activity_Status__c != \'Offline\' AND (Activity_Status__c != \'Draft\' OR OwnerId = \'' + UserInfo.getUserId() + '\' OR HostPlanner__c = \'' + defaultPreference.Planner__c + '\') ' + 
            '       )           ' +
            '       AND         ' +
            '       (           ' + 
            '             (StartDate__c >= '   + string.valueOf(startDate).left(10) + ' AND StartDate__c <= '   + string.valueOf(endDate).left(10) + ') ' + 
            '          OR (EndDate__c   >= '   + string.valueOf(startDate).left(10) + ' AND EndDate__c <= '     + string.valueOf(endDate).left(10)   + ') ' +
            '          OR (StartDate__c <= '   + string.valueOf(startDate).left(10) + ' AND EndDate__c >= '     + string.valueOf(endDate).left(10)   + ') ' +
            '       ) ';
    
        if (advancedFilter != null && advancedFilter != '')
        {
            eventQuery += ' AND ' + advancedFilter;
        }
        eventQuery += ' Order by Activity_Type__c,DurationOfEvent__c desc';
        return eventQuery;
    }
}