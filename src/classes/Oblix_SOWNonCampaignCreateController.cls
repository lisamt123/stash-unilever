public with sharing class Oblix_SOWNonCampaignCreateController extends Oblix_SWOPparentController {

    public Oblix_SOWNonCampaignPageHelper helper { get; set; }

    public Boolean can_manage_non_campaign{
        get{
            if(NULL == selected_sow){
                return Oblix_PermissionHandler.hasEditAccess(null);
            } else{
                return Oblix_PermissionHandler.canManageNonCampaign(selected_sow.SOW_Status__c, selected_sow.Id);
            }
        }
    }

<<<<<<< HEAD
	public Oblix_NonCampaignWrapper activity {get;set;} 
    public Oblix_NonCampaignWrapper resource {get;set;}

    public Map<String,Oblix_NonCampaignWrapper> activitySelectionMap { get; set; }
    public String seletedActivity { get; set; }
    public String selectedkey { get; set; }
    public String basketItemToRemove { get; set; }
    public Double campaignTotalValue { get; set; }
    public List<CampaignBasket> campaignBasketList { get; set; }
    public Integer selectedActivitiesSize { get; set; }
    public String selectedTab { get; set; }
    public String selectedName { get; set; }
    public boolean setUpdateButton { get; set; }
    public boolean setResourceUpdateButton { get; set; }
    //public CampaignBasket selectedActivity { get; set; }


    public Map<String, Marketing_Basics__c> existingKeys { get; set; }


    public String selected_activity{get;set;}
    public String selected_country{get;set;}
    public String selected_agent_department{get;set;}
    public String selected_other{get;set;}
    public String selected_role{get;set;}
    public Integer selected_hours{get;set;}
    public Integer selected_hourly_rate{get;set;}

    public String preSelectedName { get; set; }
        
    public List<Marketing_Basics__c> newItems  {get;set;}
    public Marketing_SOW__c marketing_SOW  { get; set; }           

    public String MScurrency {get;set;}
   	public List<SelectOption> countries {get;set;}
    public List<SelectOption> agencyDepartments{get;set;}
    public List<SelectOption> agencyRoleTitle{get;set;}
    public List<SelectOption> resourceAgencyDepartment {get;set;}
    public List<SelectOption> resourceRoleTitle {get;set;}
    public  id rtActivity  {get;set;}

    private id rtResource ;
    private  String fYear ;
    private String agency ;
    private id rtCountry ; 
    private String marKObjName= System.Label.Oblix_Lbl_Marketing_Basics_c ;
    private String ActivityName= System.Label.Oblix_Lbl_Activity;
    private String noRole= System.Label.Oblix_Lbl_Role;
    private static final String NON_CAMPAIGN_ACTIVITY_TYPE = 'activity';
    private static final String NON_CAMPAIGN_RESOURCE_TYPE = 'dedicated resource';

	public Oblix_SOWNonCampaignCreateController() {
        
		activity = new Oblix_NonCampaignWrapper();
        resource = new Oblix_NonCampaignWrapper();
        activitySelectionMap = new Map<String,Oblix_NonCampaignWrapper>();
        
        selectedActivitiesSize = 0;
        seletedActivity = '';
        setUpdateButton = false;
        setResourceUpdateButton = false;
        //Id idUser = UserInfo.getUserId();
        activity.nonCampaignItem = new Marketing_Basics__c();
        activity.nonCampaignItem.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get(ActivityName);
        rtActivity = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get(ActivityName).getRecordTypeId();
        rtResource = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
        rtCountry = Schema.SObjectType.Oblix_Calculator__c.getRecordTypeInfosByName().get('Role Rate').getRecordTypeId();
        
        preSelectedName = ApexPAges.currentPage().getParameters().get('preSelectedName');
        System.DEBUG('preselectedName : ' + preSelectedName);
        reRenderSOW();
        getSelectedKeys();
        getSelectedActivitiesByName(preSelectedName);
  
    
    
	}

    public void getSelectedKeys(){
        
        existingKeys = new Map<String, Marketing_Basics__c>();
        System.debug('!!! basicsList:'+marketing_SOW);
        for(Marketing_Basics__c eachRecord : [SELECT Non_Campaign_Key__c, No_of_Hours_Required__c, OblixOtherItemFee__c FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c =: marketing_SOW.Id LIMIT 10000]){
            //System.debug('!!! eachRecord:'+eachRecord);
            existingKeys.put(eachRecord.Non_Campaign_Key__c, eachRecord);
=======

    public Boolean is_agency_user {
        get {
            return Oblix_PermissionHandler.hasAG1permissionSet() || Oblix_PermissionHandler.hasAG2permissionSet();
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
        }
    }
    
<<<<<<< HEAD
    public void getSelectedActivitiesByName(String preSelectedName){
        
        this.selectedName = preSelectedName;
        
        if(this.selectedName != null && !this.selectedName.equalsIgnoreCase('')){
            getSelectedActivitiesByName();
            System.Debug('activitySelectionMap : ' + activitySelectionMap);
            checkAndSetActivityAttributes();
        }
    }

    public void getAndSetActivitiesByName(){
        
        getSelectedActivitiesByName();
        checkAndSetActivityAttributes();
    }

    public void getSelectedActivitiesByName(){
        
        selectedActivitiesSize = 0;
        existingKeys.clear();
        System.DEBUG('RecordTypeId : ' + rtActivity);
        List<Marketing_Basics__c> selectedActivities =[SELECT Id, Activities__c, Name, No_of_Hours_Required__c, OblixCountry__c, OblixCountry__r.Name , Role_Title__c, Agency_Department__c,
                                                        OblixOtherItemFee__c, Oblix_Hourly_Rate__c, RecordTypeId FROM Marketing_Basics__c WHERE Name =: selectedName AND Oblix_SOWMarketing__c =: marketing_SOW.Id ];
                                                        //AND RecordTypeId =: rtActivity];
        activitySelectionMap.clear();

        system.debug('## selectedActivities: ' + selectedActivities);

        for(Marketing_Basics__c eachMarketingBasicRecord : selectedActivities){

            Oblix_NonCampaignWrapper selectedNonCampaignWrapper = new Oblix_NonCampaignWrapper();
            selectedNonCampaignWrapper.name = eachMarketingBasicRecord.name;
            selectedNonCampaignWrapper.selectedActivity = eachMarketingBasicRecord.Activities__c;
            selectedNonCampaignWrapper.selectedCountryname = eachMarketingBasicRecord.OblixCountry__r.Name;
            selectedNonCampaignWrapper.selectedCountry = eachMarketingBasicRecord.OblixCountry__c;
            selectedNonCampaignWrapper.selectedAgencyDepartment = eachMarketingBasicRecord.Agency_Department__c;
            selectedNonCampaignWrapper.selectedRole = eachMarketingBasicRecord.Role_Title__c;
            selectedNonCampaignWrapper.hourlyRate = String.valueOf(eachMarketingBasicRecord.Oblix_Hourly_Rate__c);
            selectedNonCampaignWrapper.hoursSelected = Integer.valueOf(eachMarketingBasicRecord.No_of_Hours_Required__c);
            selectedNonCampaignWrapper.totalAmount = eachMarketingBasicRecord.OblixOtherItemFee__c;
            selectedNonCampaignWrapper.key = marketing_SOW.Id + selectedNonCampaignWrapper.selectedActivity + selectedNonCampaignWrapper.selectedCountryname + selectedNonCampaignWrapper.selectedAgencyDepartment + selectedNonCampaignWrapper.selectedRole;
            selectedNonCampaignWrapper.nonCampaignItem = new Marketing_Basics__c();
            selectedNonCampaignWrapper.activityId = eachMarketingBasicRecord.Id;
            selectedNonCampaignWrapper.nonCampaignItem = eachMarketingBasicRecord;

            if(activitySelectionMap != null && activitySelectionMap.get(selectedNonCampaignWrapper.key) == null){
                activitySelectionMap.put(selectedNonCampaignWrapper.key,selectedNonCampaignWrapper);
            }
            System.Debug('activitySelectionMap : ' + activitySelectionMap);
        }
        
        selectedActivitiesSize = activitySelectionMap.values().size();


    }

    private void checkAndSetActivityAttributes(){
        
        Oblix_NonCampaignWrapper non_campaign_to_pre_select = new Oblix_NonCampaignWrapper();

        if (NULL!=activitySelectionMap && !activitySelectionMap.values().isEmpty()){

            non_campaign_to_pre_select = activitySelectionMap.values()[0];
        }

        // if this is a single selection then pre-populate the page otherwise blank the previously
        // selected fields
        if (selectedActivitiesSize == 1){
            system.debug('## non_campaign_to_pre_select: ' + non_campaign_to_pre_select);

            // check if this is resource vs. activity
            if (rtActivity == non_campaign_to_pre_select.nonCampaignItem.RecordTypeId){
                // this must be a activity prepopulate
                setActivityAttributes(non_campaign_to_pre_select.selectedActivity, non_campaign_to_pre_select.selectedCountryname
                , non_campaign_to_pre_select.selectedAgencyDepartment, non_campaign_to_pre_select.name, non_campaign_to_pre_select.selectedRole
                , non_campaign_to_pre_select.hoursSelected, true);   
            }
            else{
                // this must be a resource pre populate
                setResourceAttributes(non_campaign_to_pre_select.name, non_campaign_to_pre_select.selectedCountryname
                , non_campaign_to_pre_select.selectedAgencyDepartment, non_campaign_to_pre_select.selectedRole, non_campaign_to_pre_select.hoursSelected, true);
                
                // don't show activities table
                selectedActivitiesSize = 0;
                activitySelectionMap.clear();

            }
        }
        else{
            if (NULL != non_campaign_to_pre_select.name && rtActivity == non_campaign_to_pre_select.nonCampaignItem.RecordTypeId){
                // this must be a activity set to blank
                setActivityAttributes(null , null, null, null, null, null, false);   
            }
        }
    }


    public void addToActivitySelectionMap(){
        
        System.DEBUG('Selected Activity : ' + seletedActivity);
        NonCampaignJSONWrapper activityJSONWrapper = new NonCampaignJSONWrapper();
        Oblix_NonCampaignWrapper selectedNonCampaignWrapper = new Oblix_NonCampaignWrapper();
        activityJSONWrapper = (NonCampaignJSONWrapper) JSON.deserialize(seletedActivity, NonCampaignJSONWrapper.class);
        System.DEBUG('activityJSONWrapper :  ' + activityJSONWrapper);
        selectedNonCampaignWrapper.selectedActivity = activityJSONWrapper.selectedActivity;
        selectedNonCampaignWrapper.selectedCountryname = activityJSONWrapper.selectedCountry;
        List<Oblix_Calculator__c> calc = [select OblixCountry__c from Oblix_Calculator__c where RecordTypeId = : rtCountry and Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__r.name =:  activityJSONWrapper.selectedCountry];
        if(!calc.isEmpty()){
        	selectedNonCampaignWrapper.selectedCountry = calc[0].OblixCountry__c;
        }
        if(NULL != activityJSONWrapper && NULL != activityJSONWrapper.otherName && !activityJSONWrapper.otherName.equalsIgnoreCase('')){
            selectedNonCampaignWrapper.name = activityJSONWrapper.otherName;
        }
        selectedNonCampaignWrapper.nonCampaignItem = new Marketing_Basics__c();
        selectedNonCampaignWrapper.selectedAgencyDepartment = activityJSONWrapper.selectedAgencyDepartment;
        selectedNonCampaignWrapper.selectedRole = activityJSONWrapper.selectedRole;
        selectedNonCampaignWrapper.hourlyRate = activityJSONWrapper.hourlyRate;
        selectedNonCampaignWrapper.hoursSelected = activityJSONWrapper.hoursSelected != null ? Integer.valueOf(activityJSONWrapper.hoursSelected) : 0;
        selectedNonCampaignWrapper.totalAmount = activityJSONWrapper.totalAmount != null ? Math.round(Decimal.valueof(activityJSONWrapper.totalAmount)) : 0;
        selectedNonCampaignWrapper.key = activityJSONWrapper.key;
        selectedNonCampaignWrapper.activityId = activityJSONWrapper.activityId;


        //if(activitySelectionMap != null && activitySelectionMap.get(selectedNonCampaignWrapper.key) == null){
            activitySelectionMap.put(selectedNonCampaignWrapper.key,selectedNonCampaignWrapper);
        //}else{
        //    Oblix_NonCampaignWrapper wrapperToAdjust = activitySelectionMap.get(selectedNonCampaignWrapper.key);
            
        //    // only increment existing if not in edit mode
        //    wrapperToAdjust.hoursSelected = is_selection_for_edit_mode
        //        ? selectedNonCampaignWrapper.hoursSelected
        //        : wrapperToAdjust.hoursSelected + selectedNonCampaignWrapper.hoursSelected;

        //    wrapperToAdjust.totalAmount = is_selection_for_edit_mode
        //        ? selectedNonCampaignWrapper.totalAmount
        //        : wrapperToAdjust.totalAmount + selectedNonCampaignWrapper.totalAmount;

        //    activitySelectionMap.put(selectedNonCampaignWrapper.key,wrapperToAdjust);
        //}
        selectedActivitiesSize = activitySelectionMap.values().size();
        System.Debug('activitySelectionMap : ' + activitySelectionMap);
=======
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

    public String nonCampaignItemToAddJSON {get; set;}


<<<<<<< HEAD
    public void removeFromSelectionMap(){
=======


    public Oblix_SOWNonCampaignCreateController() {
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

        String sowId = ApexPages.currentPage().getParameters().get('sowId');

        if (sowId != null && !String.isEmpty(sowId)) {
            selected_sow = getSOW(sowId, Oblix_Utils.getAllFieldsInFieldsSet('Marketing_SOW__c', 'Oblix_SOW_Main_Detail'), null);
        }

        if (selected_sow != null){
            helper = new Oblix_SOWNonCampaignPageHelper(selected_sow, ApexPages.currentPage().getParameters().get('preSelectedSection'));
        }


        system.debug('HELPER %% ' + helper);
    
    }


    public PageReference addToWorkList() {
        helper.addToWorkList(nonCampaignItemToAddJSON);

        return null;
    }

    public PageReference saveWorkList() {
        helper.saveWorkList();

        selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet('Marketing_SOW__c', 'Oblix_SOW_Main_Detail'), null);

        return null;
    }

    public PageReference openActivityForUpdate() {
        helper.openItemForUpdate(true);

        return null;
    }

    public PageReference openResourceForUpdate() {
        helper.openItemForUpdate(false);

        return null;
    }


    public PageReference removeItem() {
        helper.removeItem();

        selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet('Marketing_SOW__c', 'Oblix_SOW_Main_Detail'), null);

        return null;
    }

<<<<<<< HEAD
    /*
    Description : Method used to update Rate options in Activities form 
    */
    public void fillRate() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillrate =+=+=+=+=+=+=+=+=+============================');
    
        List < Oblix_Calculator__c > Rates = new List < Oblix_Calculator__c > ();
        //System.DEBUG(' fYear ' + fYear);
        //System.DEBUG(' agency ' + agency);
        //System.DEBUG(' activity.selectedCountry ' + activity.selectedCountry);
        //System.DEBUG(' activity.selectedAgencyDepartment ' + activity.selectedAgencyDepartment);
        //System.DEBUG(' activity.selectedRole ' + activity.selectedRole);

        //System.DEBUG(' resource.selectedCountry ' + resource.selectedCountry);
        //System.DEBUG(' resource.selectedAgencyDepartment ' + resource.selectedAgencyDepartment);
        //System.DEBUG(' resource.selectedRole ' + resource.selectedRole);
        //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        String campaignType = NON_CAMPAIGN_ACTIVITY_TYPE;
        
        if (selectedTab.equalsIgnoreCase(campaignType)) {
            Rates = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c, Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  activity.selectedCountry and Agency_Department__c = : activity.selectedAgencyDepartment and Role_Title__c = :  activity.selectedRole];
        }else{
            Rates = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, FTE__c, Agency_Department__c, Role_Title__c, Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  resource.selectedCountry and Agency_Department__c = : resource.selectedAgencyDepartment and Role_Title__c = :  resource.selectedRole];
        }
        if (Rates.size() >= 1) {
            if(selectedTab.equalsIgnoreCase(campaignType)){
                activity.hourlyRate = String.valueOf((Rates[0].Role_Daily_Rate_EUR__c));//Math.round
                activity.roundedRate = String.valueOf(Math.round(Rates[0].Role_Daily_Rate_EUR__c));//
            }else{
                resource.hourlyRate = String.valueOf((Rates[0].FTE__c));
                resource.roundedRate = String.valueOf(Math.round(Rates[0].FTE__c));//
                //this.setResourceUpdateButton = false;
            }
        }
        else{
            activity.hourlyRate = '0';
            activity.roundedRate = '0';
            resource.hourlyRate = '0';
            resource.roundedRate = '0';
        }
        checkIFButtonISUpdateORAdd();

    }
    
     /*
    Description : Method used to update roleTatle options in Activities form 
    */
    public void fillRoleTitle() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillRoleTitle=+=+=+=+=+=+=+=+=+============================');

        
        List < Oblix_Calculator__c > RoleTitleNames = new List < Oblix_Calculator__c > ();
        //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        System.DEBUG(' fYear ' + fYear);
        System.DEBUG(' agency ' + agency);
        System.DEBUG(' activity.selectedCountry ' + activity.selectedCountry);
        System.DEBUG(' activity.selectedAgencyDepartment ' + activity.selectedAgencyDepartment);

        System.DEBUG(' resource.selectedCountry ' + resource.selectedCountry);
        System.DEBUG(' resource.selectedAgencyDepartment ' + resource.selectedAgencyDepartment);
        if (selectedTab.equalsIgnoreCase(NON_CAMPAIGN_ACTIVITY_TYPE)) {
            RoleTitleNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = : activity.selectedCountry and Agency_Department__c = : activity.selectedAgencyDepartment];
        }else{
            resource.selectedCountry = Oblix_Utils.CountrryGetId(resource.selectedCountryName);
            RoleTitleNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = : resource.selectedCountry and Agency_Department__c = : resource.selectedAgencyDepartment];
        }
        System.DEBUG(' RoleTitleNames ' + RoleTitleNames);
        map < String, String > roleTitlesNameMap = new map < String, String > ();
        for (Oblix_Calculator__c c: RoleTitleNames) {
            if (c.Role_Title__c != null) {
                roleTitlesNameMap.put(c.Role_Title__c, c.Role_Title__c);
            }
        }
        if (!roleTitlesNameMap.keyset().isEmpty()) {
            // activity.selectedRole = null;
            if (selectedTab.equalsIgnoreCase(NON_CAMPAIGN_ACTIVITY_TYPE)) {
                agencyRoleTitle = new List < SelectOption>();
                agencyRoleTitle = populateRoleTitleList(roleTitlesNameMap);
                activity.roleVisible = true;
            } else {
                resourceRoleTitle = new List <SelectOption>();
                resourceRoleTitle = populateRoleTitleList(roleTitlesNameMap);
                resource.roleVisible = true;
                //this.setResourceUpdateButton = false;
            }
=======
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

    public PageReference removeSection() {
        helper.removeSection();

        selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet('Marketing_SOW__c', 'Oblix_SOW_Main_Detail'), null);

        return null;
    }


    public PageReference finishBasket(){
        PageReference campaignMainDetailPage = Page.oblix_sowmaindetail;
        campaignMainDetailPage.getParameters().put('sowId', selected_sow.Id);
        campaignMainDetailPage.setRedirect(True);
        return campaignMainDetailPage;
    }
    
}