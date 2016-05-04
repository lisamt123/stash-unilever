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


    public Boolean is_agency_user {
        get {
            return Oblix_PermissionHandler.hasAG1permissionSet() || Oblix_PermissionHandler.hasAG2permissionSet();
        }
    }
    

    public String nonCampaignItemToAddJSON {get; set;}




    public Oblix_SOWNonCampaignCreateController() {

        String sowId = ApexPages.currentPage().getParameters().get('sowId');

        if (sowId != null && !String.isEmpty(sowId)) {
            selected_sow = getSOW(sowId, Oblix_Utils.getAllFieldsInFieldsSet('Marketing_SOW__c', 'Oblix_SOW_Main_Detail'), null);
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

        return null;
    }


    public PageReference removeSection() {
        helper.removeSection();

        return null;
    }


    public PageReference finishBasket(){
        PageReference campaignMainDetailPage = Page.oblix_sowmaindetail;
        campaignMainDetailPage.getParameters().put('sowId', selected_sow.Id);
        campaignMainDetailPage.setRedirect(True);
        return campaignMainDetailPage;
    }



/*


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
    public Decimal selected_hours{get;set;}
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


    private  String fYear ;
    private String agency ;
    private id rtCountry ; 
    private String marKObjName= System.Label.Oblix_Lbl_Marketing_Basics_c ;
    private String activityName = System.Label.Oblix_Lbl_Activity;
    public  String ACTIVITY_DEV_NAME { 
        get {
            return Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_DEV_NAME;
        }
    }
    public  String RESOURCE_DEV_NAME { 
        get {
            return Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_DEV_NAME;
        }
    }
    private static final String ACTIVITY_RT_ID = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;
    private static final String RESOURCE_RT_ID = Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_ID;

    private String noRole= System.Label.Oblix_Lbl_Role;
    private static final String NON_CAMPAIGN_ACTIVITY_TYPE = 'activity';
    private static final String NON_CAMPAIGN_RESOURCE_TYPE = 'dedicated resource';

	public Oblix_SOWNonCampaignCreateController() {

        selected_sow = getSOW(sowId, Oblix_Utils.getAllFieldsInFieldsSet('Marketing_SOW__c', 'Oblix_SOW_Main_Detail') , null);
        
		activity = new Oblix_NonCampaignWrapper(ACTIVITY_RT_ID);
        resource = new Oblix_NonCampaignWrapper(RESOURCE_RT_ID);
        activitySelectionMap = new Map<String,Oblix_NonCampaignWrapper>();
        
        selectedActivitiesSize = 0;
        seletedActivity = '';
        setUpdateButton = false;
        setResourceUpdateButton = false;
        //Id idUser = UserInfo.getUserId();
        
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
        }
    }

    public PageReference finishBasket(){
        
        PageReference campaignMainDetailPage = Page.oblix_sowmaindetail;
        campaignMainDetailPage.getParameters().put('sowId', marketing_SOW.Id);
        campaignMainDetailPage.setRedirect(True);
        return campaignMainDetailPage;
    }
    
    public void getSelectedActivitiesByName(String preSelectedName){
        
        System.debug('### preSelectedName: ' + preSelectedName);
        this.selectedName = preSelectedName;
        
        if(this.selectedName == null || this.selectedName.equalsIgnoreCase('')){
            this.selectedName = ACTIVITY_DEV_NAME;
        }

        System.debug('### selectedName: ' + selectedName);

        getSelectedActivitiesByName();
        checkAndSetActivityAttributes();

        System.Debug('### activitySelectionMap : ' + activitySelectionMap);
        System.Debug('### selectedActivitiesSize : ' + selectedActivitiesSize);
    }

    public void getAndSetActivitiesByName(){

        System.debug('### selectedName: ' + selectedName);
        System.debug('### selectedTab: ' + selectedTab);
        
        getSelectedActivitiesByName();
        checkAndSetActivityAttributes();

        System.Debug('### activitySelectionMap : ' + activitySelectionMap);
        System.Debug('### selectedActivitiesSize : ' + selectedActivitiesSize);
    }

    public void getSelectedActivitiesByName(){
        
        selectedActivitiesSize = 0;
        existingKeys.clear();
        getSelectedKeys();

        System.debug('### selectedName: ' + selectedName);
        List<Marketing_Basics__c> selectedActivities =[SELECT Id, Activities__c, Name, No_of_Hours_Required__c, OblixCountry__c, OblixCountry__r.Name , Role_Title__c, Agency_Department__c,
                                                        OblixOtherItemFee__c, Oblix_Hourly_Rate__c, RecordTypeId FROM Marketing_Basics__c WHERE RecordType.Name =: selectedName AND Oblix_SOWMarketing__c =: marketing_SOW.Id ];

        activitySelectionMap.clear();

        system.debug('## selectedActivities: ' + selectedActivities);
        system.debug('## activitySelectionMap: ' + activitySelectionMap);

        for(Marketing_Basics__c eachMarketingBasicRecord : selectedActivities){

            Oblix_NonCampaignWrapper selectedNonCampaignWrapper = new Oblix_NonCampaignWrapper(eachMarketingBasicRecord.RecordTypeId);
            selectedNonCampaignWrapper.name = eachMarketingBasicRecord.name;
            selectedNonCampaignWrapper.selectedActivity = eachMarketingBasicRecord.Activities__c;
            selectedNonCampaignWrapper.selectedCountryname = eachMarketingBasicRecord.OblixCountry__r.Name;
            selectedNonCampaignWrapper.selectedCountry = eachMarketingBasicRecord.OblixCountry__c;
            selectedNonCampaignWrapper.selectedAgencyDepartment = eachMarketingBasicRecord.Agency_Department__c;
            selectedNonCampaignWrapper.selectedRole = eachMarketingBasicRecord.Role_Title__c;
            selectedNonCampaignWrapper.hourlyRate = String.valueOf(eachMarketingBasicRecord.Oblix_Hourly_Rate__c);
            selectedNonCampaignWrapper.roundedRate = String.valueOf(Math.round(Decimal.valueOf(selectedNonCampaignWrapper.hourlyRate)));
            selectedNonCampaignWrapper.hoursSelected = eachMarketingBasicRecord.No_of_Hours_Required__c;
            selectedNonCampaignWrapper.totalAmount = eachMarketingBasicRecord.OblixOtherItemFee__c;
            selectedNonCampaignWrapper.activityId = eachMarketingBasicRecord.Id;
            selectedNonCampaignWrapper.nonCampaignItem = eachMarketingBasicRecord;

            if (eachMarketingBasicRecord.RecordTypeId == ACTIVITY_RT_ID) {
                selectedNonCampaignWrapper.key = marketing_SOW.Id + selectedNonCampaignWrapper.selectedActivity + selectedNonCampaignWrapper.selectedCountryname + selectedNonCampaignWrapper.selectedAgencyDepartment + selectedNonCampaignWrapper.selectedRole;    
            } else {
                selectedNonCampaignWrapper.key = marketing_SOW.Id + selectedNonCampaignWrapper.name + selectedNonCampaignWrapper.selectedCountryname + selectedNonCampaignWrapper.selectedAgencyDepartment + selectedNonCampaignWrapper.selectedRole;    
            }

            System.debug('### debug key: ' + selectedNonCampaignWrapper.key);

            if(activitySelectionMap != null && !activitySelectionMap.containsKey(selectedNonCampaignWrapper.key)){
                activitySelectionMap.put(selectedNonCampaignWrapper.key,selectedNonCampaignWrapper);
            }
        }

        System.Debug('### activitySelectionMap : ' + activitySelectionMap);
        System.Debug('### activitySelectionMap.size() : ' + activitySelectionMap.size());
        
        selectedActivitiesSize = activitySelectionMap.values().size();


    }

    private void checkAndSetActivityAttributes(){
        
        Oblix_NonCampaignWrapper non_campaign_to_pre_select = new Oblix_NonCampaignWrapper(selectedTab == ACTIVITY_DEV_NAME ? ACTIVITY_RT_ID : RESOURCE_RT_ID);

        if (NULL!=activitySelectionMap && !activitySelectionMap.values().isEmpty()){

            non_campaign_to_pre_select = activitySelectionMap.values()[0];
        }

        System.debug('### non_campaign_to_pre_select: ' + non_campaign_to_pre_select);
        System.debug('### selectedActivitiesSize: ' + selectedActivitiesSize);
        System.debug('### selectedName: ' + selectedName);
        System.debug('### selectedTab: ' + selectedTab);

        if (selectedActivitiesSize == 0) {
            if (selectedName == ACTIVITY_DEV_NAME){
                selectedTab = ACTIVITY_DEV_NAME;
            } else {
                selectedTab = RESOURCE_DEV_NAME;
            }
        } else {
            if (non_campaign_to_pre_select != null && non_campaign_to_pre_select.nonCampaignItem.RecordTypeId == ACTIVITY_RT_ID) {
                selectedTab = ACTIVITY_DEV_NAME;
            } else if (non_campaign_to_pre_select != null && non_campaign_to_pre_select.nonCampaignItem.RecordTypeId == RESOURCE_RT_ID){
                selectedTab = RESOURCE_DEV_NAME;
            }
        }

        System.debug('### selectedTab: ' + selectedTab);


        if (selectedTab == ACTIVITY_DEV_NAME){
            setActivityAttributes(null , null, null, null, null, null, false);
        } else {
            setResourceAttributes(null , null, null, null, null, false);
        }


        //// if this is a single selection then pre-populate the page otherwise blank the previously
        //// selected fields
        //if (selectedActivitiesSize == 1){
        //    system.debug('## non_campaign_to_pre_select: ' + non_campaign_to_pre_select);

        //    // check if this is resource vs. activity
        //    if (ACTIVITY_RT_ID == non_campaign_to_pre_select.nonCampaignItem.RecordTypeId){
        //        // this must be a activity prepopulate
        //        setActivityAttributes(non_campaign_to_pre_select.selectedActivity, non_campaign_to_pre_select.selectedCountryname
        //        , non_campaign_to_pre_select.selectedAgencyDepartment, non_campaign_to_pre_select.name, non_campaign_to_pre_select.selectedRole
        //        , non_campaign_to_pre_select.hoursSelected, true);   
        //    } else {
        //        // this must be a resource pre populate
        //        setResourceAttributes(non_campaign_to_pre_select.name, non_campaign_to_pre_select.selectedCountryname
        //        , non_campaign_to_pre_select.selectedAgencyDepartment, non_campaign_to_pre_select.selectedRole, non_campaign_to_pre_select.hoursSelected, true);
                
        //        // don't show activities table
        //        //selectedActivitiesSize = 0;
        //        //activitySelectionMap.clear();

        //    }
        //} else {
        //    if (NULL != non_campaign_to_pre_select.name && ACTIVITY_RT_ID == non_campaign_to_pre_select.nonCampaignItem.RecordTypeId){
        //        // this must be a activity set to blank
        //        setActivityAttributes(null , null, null, null, null, null, false);   
        //    } else if (NULL != non_campaign_to_pre_select.name && RESOURCE_RT_ID == non_campaign_to_pre_select.nonCampaignItem.RecordTypeId) {
        //        // this must be a activity set to blank
        //        setResourceAttributes(null , null, null, null, null, false);   
        //    }
        //}
    }


    public void addToActivitySelectionMap(){
        
        System.DEBUG('Selected Activity : ' + seletedActivity);
        NonCampaignJSONWrapper activityJSONWrapper = new NonCampaignJSONWrapper();
        activityJSONWrapper = (NonCampaignJSONWrapper) JSON.deserialize(seletedActivity, NonCampaignJSONWrapper.class);
        System.DEBUG('activityJSONWrapper :  ' + activityJSONWrapper);
        

        Oblix_NonCampaignWrapper selectedNonCampaignWrapper = populateNonCampaignWrapper(activityJSONWrapper);

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

        //setActivityAttributes(null , null, null, null, null, null, false); 
        if (ACTIVITY_RT_ID == selectedNonCampaignWrapper.nonCampaignItem.RecordTypeId){
            // this must be a activity set to blank
            setActivityAttributes(null , null, null, null, null, null, false);   
        } else {
            // this must be a activity set to blank
            setResourceAttributes(null , null, null, null, null, false);   
        }  
        resource.hoursSelected = null;

    }

    private Oblix_NonCampaignWrapper populateNonCampaignWrapper(NonCampaignJSONWrapper activityJSONWrapper){
        Oblix_NonCampaignWrapper selectedNonCampaignWrapper = new Oblix_NonCampaignWrapper(activityJSONWrapper.isActivity ? ACTIVITY_RT_ID : RESOURCE_RT_ID);

        selectedNonCampaignWrapper.name = activityJSONWrapper.name;
        selectedNonCampaignWrapper.selectedActivity = activityJSONWrapper.selectedActivity;
        selectedNonCampaignWrapper.selectedCountryname = activityJSONWrapper.selectedCountry;
        List<Oblix_Calculator__c> calc = [select OblixCountry__c from Oblix_Calculator__c where RecordTypeId = : rtCountry and Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__r.name =:  activityJSONWrapper.selectedCountry];
        if(!calc.isEmpty()){
            selectedNonCampaignWrapper.selectedCountry = calc[0].OblixCountry__c;
        }
        if(NULL != activityJSONWrapper && NULL != activityJSONWrapper.otherName && !activityJSONWrapper.otherName.equalsIgnoreCase('')){
            selectedNonCampaignWrapper.name = activityJSONWrapper.otherName;
        }
        //selectedNonCampaignWrapper.nonCampaignItem = new Marketing_Basics__c();
        selectedNonCampaignWrapper.selectedAgencyDepartment = activityJSONWrapper.selectedAgencyDepartment;
        selectedNonCampaignWrapper.selectedRole = activityJSONWrapper.selectedRole;
        selectedNonCampaignWrapper.hourlyRate = activityJSONWrapper.hourlyRate;
        selectedNonCampaignWrapper.roundedRate = activityJSONWrapper.hourlyRate;//
        selectedNonCampaignWrapper.hoursSelected = activityJSONWrapper.hoursSelected != null ? Decimal.valueOf(activityJSONWrapper.hoursSelected) : 0;
        selectedNonCampaignWrapper.totalAmount = activityJSONWrapper.totalAmount != null ? Math.round(Decimal.valueof(activityJSONWrapper.totalAmount)) : 0;
        selectedNonCampaignWrapper.key = activityJSONWrapper.key;
        selectedNonCampaignWrapper.activityId = activityJSONWrapper.activityId;

        return selectedNonCampaignWrapper;
    }

    public void removeFromSelectionMap(){

        
        System.debug('Seleted Index : ' + selectedkey);
        System.DEBUG('activitySelectionMap Before : ' + activitySelectionMap);

        String selectedkeyValue = selectedkey;
        System.DEBUG('activitySelectionMap with key : ' + activitySelectionMap.get(selectedkeyValue));
        if(activitySelectionMap != null && activitySelectionMap.get(selectedkeyValue) != null){
            if(activitySelectionMap.get(selectedkeyValue).activityId != null){
                delete [SELECT Id FROM Marketing_Basics__c WHERE Id =: activitySelectionMap.get(selectedkeyValue).activityId ];
            }
            this.activitySelectionMap.remove(selectedkeyValue);
        }
        refreshBasket();
        selectedActivitiesSize = activitySelectionMap.values().size();
        System.DEBUG('activitySelectionMap After  : ' + activitySelectionMap);
    }

    public void removeItemFromBasketList(){
        
        System.DEBUG('Basket Item to Remove : ' + basketItemToRemove);
        if(basketItemToRemove != null){
            delete [SELECT Id FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c =: marketing_SOW.Id AND Name =: basketItemToRemove];
        }
        refreshBasket();
        clearActivitySelectionMap();
        getSelectedKeys();
    }

    public void setActivityInputFieldsForSelectedItem(){
        
        setActivityAttributes(selected_activity, selected_country
        , selected_agent_department, selected_other
        , selected_role, selected_hours, true);

    }

    public void setResourceInputFieldsForSelectedItem(){
        
        setResourceAttributes(selected_activity, selected_country
        , selected_agent_department
        , selected_role, selected_hours, true);

    }

    public void setActivityAttributes(String selected_activity, String selected_country
        , String selected_agent_department, String selected_other
        , String selected_role, Decimal selected_hours, Boolean setUpdateButton){
        
        selectedTab = ACTIVITY_DEV_NAME;

        this.setUpdateButton = setUpdateButton;
        activity.nonCampaignItem.Activities__c = selected_activity;
        activity.selectedCountryName = selected_country;
        fillAgencyDepartment();

        activity.selectedAgencyDepartment = selected_agent_department;
        fillRoleTitle();

        activity.nonCampaignItem.name = selected_other;
        activity.selectedRole = selected_role;
        fillRate();
        activity.hoursSelected  = selected_hours;
    }

    public void setResourceAttributes(String resource_name, String resource_country
        , String resource_agent_department, String selected_role, Decimal resource_hours, Boolean setResourceUpdateButton){
        
        selectedTab = RESOURCE_DEV_NAME;

        this.setResourceUpdateButton = setResourceUpdateButton;
        resource.nonCampaignItem.name = resource_name;
        resource.selectedCountryName = resource_country;
        fillAgencyDepartment();

        resource.selectedAgencyDepartment = resource_agent_department;
        fillRoleTitle();

        resource.selectedRole = selected_role;
        fillRate();
        resource.hoursSelected  = resource_hours;
    }

    public Class NonCampaignJSONWrapper{
        public String selectedCountry;
        public String selectedActivity;
        public String name;
        public String selectedAgencyDepartment;
        public String selectedRole;
        public String hourlyRate;
        public String hoursSelected;
        public Double totalAmount;
        public String key;
        public String activityId;
        public String otherName;
        public Boolean isActivity;
    }
   

    public void insertSelectedActivitiesAndRefreshBasket(){
        
        Map <String, String> abreviationsMap = Oblix_Utils.getAbreViationForCardAssets();
        List<Marketing_Basics__c> marketingBasicRecordList = new List<Marketing_Basics__c>();

        for(Oblix_NonCampaignWrapper eachNonCampaignWrapper : activitySelectionMap.values()){
            Marketing_Basics__c marketingBasicRecord = new Marketing_Basics__c();


            marketingBasicRecord.Non_Campaign_Key__c = eachNonCampaignWrapper.key;
            if(existingKeys != null && existingKeys.containsKey(marketingBasicRecord.Non_Campaign_Key__c)){
                marketingBasicRecord.No_of_Hours_Required__c = existingKeys.get(marketingBasicRecord.Non_Campaign_Key__c).No_of_Hours_Required__c + eachNonCampaignWrapper.hoursSelected;
                marketingBasicRecord.OblixOtherItemFee__c = existingKeys.get(marketingBasicRecord.Non_Campaign_Key__c).OblixOtherItemFee__c + Decimal.valueOf(eachNonCampaignWrapper.totalAmount);
            }else{
                marketingBasicRecord.No_of_Hours_Required__c = eachNonCampaignWrapper.hoursSelected;
                marketingBasicRecord.OblixOtherItemFee__c = Decimal.valueOf(eachNonCampaignWrapper.totalAmount);
            }

            marketingBasicRecord.Activities__c = eachNonCampaignWrapper.selectedActivity;
            marketingBasicRecord.Non_campaign_title__c = eachNonCampaignWrapper.selectedActivity;
            if(eachNonCampaignWrapper.name != null && !eachNonCampaignWrapper.name.equalsIgnoreCase('')){
                marketingBasicRecord.Name = eachNonCampaignWrapper.name;
            }else{
                marketingBasicRecord.Name = eachNonCampaignWrapper.selectedActivity;
            }
            marketingBasicRecord.OblixCountry__c = eachNonCampaignWrapper.selectedCountry;
            marketingBasicRecord.Role_Title__c = eachNonCampaignWrapper.selectedRole;
            marketingBasicRecord.Agency_Department__c = eachNonCampaignWrapper.selectedAgencyDepartment;
            //marketingBasicRecord.recordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get(ActivityName).getRecordTypeId();
            marketingBasicRecord.recordTypeId = eachNonCampaignWrapper.nonCampaignItem.RecordTypeId;
            System.debug('### marketingBasicRecord.recordtypeid: ' +marketingBasicRecord.recordtypeid);
            marketingBasicRecord.Oblix_SOWMarketing__c = marketing_SOW.Id;
            
            if(marketingBasicRecord.Non_Campaign_Key__c != null)
            	marketingBasicRecordList.add(marketingBasicRecord);
        }
        System.debug('!!! marketingBasicRecordList:'+marketingBasicRecordList);
        upsert marketingBasicRecordList Non_Campaign_Key__c;
        refreshBasket();
        //clearActivitySelectionMap();
        selectedActivitiesSize = activitySelectionMap.values().size();
        activity = new Oblix_NonCampaignWrapper(ACTIVITY_RT_ID);
        resource = new Oblix_NonCampaignWrapper(RESOURCE_RT_ID);
    }

    public void upsertSelectedResourceAndRefreshBasket(){
        
        Marketing_Basics__c marketingBasicRecordToInsert = new Marketing_Basics__c();

        //selectedName = resource.nonCampaignItem.name;
        selectedName = RESOURCE_DEV_NAME;
        Boolean isUpsert = false;
        getSelectedActivitiesByName();
        if (NULL!=activitySelectionMap && !activitySelectionMap.values().isEmpty()){
            marketingBasicRecordToInsert.Id = activitySelectionMap.values()[0].nonCampaignItem.Id;
            isUpsert = true;
        }

        system.debug('##1 marketingBasicRecordToInsert: ' + marketingBasicRecordToInsert + ' - isUpsert' + isUpsert + ' - activitySelectionMap: ' + activitySelectionMap + ' - resource: '+ resource);

        marketingBasicRecordToInsert.Name = resource.nonCampaignItem.name;
        marketingBasicRecordToInsert.No_of_Hours_Required__c = resource.hoursSelected;
        marketingBasicRecordToInsert.Agency_Department__c = resource.selectedAgencyDepartment;
        marketingBasicRecordToInsert.OblixOtherItemFee__c = NULL != resource.hourlyRate && NULL != resource.hoursSelected ? Math.round(Decimal.valueof(resource.hourlyRate.trim()) * resource.hoursSelected / 100) : 0;
        marketingBasicRecordToInsert.recordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
        // only set parent if inserting - upsert causes Field is not writeable error
        if (!isUpsert){
            marketingBasicRecordToInsert.Oblix_SOWMarketing__c = marketing_SOW.Id;
        }
        marketingBasicRecordToInsert.Role_Title__c = resource.selectedRole;
        marketingBasicRecordToInsert.FTE__c = resource.hoursSelected;
        marketingBasicRecordToInsert.non_campaign_title__c = resource.nonCampaignItem.name;
        marketingBasicRecordToInsert.OblixCountry__c =  Oblix_Utils.CountrryGetId(resource.selectedCountryName);
        
        system.debug('##2 marketingBasicRecordToInsert: ' + marketingBasicRecordToInsert + ' - isUpsert' + isUpsert + ' - activitySelectionMap: ' + activitySelectionMap + ' - resource: '+ resource);
        
        upsert marketingBasicRecordToInsert ;
        refreshBasket();
        //activitySelectionMap.clear();
        activity = new Oblix_NonCampaignWrapper(ACTIVITY_RT_ID);
        resource = new Oblix_NonCampaignWrapper(RESOURCE_RT_ID);
        //selectedTab = NON_CAMPAIGN_RESOURCE_TYPE;
        setResourceUpdateButton = false;

    }

    public void refreshBasket(){
        
        AggregateResult[] groupedResults = [SELECT RecordType.Name, COUNT(Id)quantity, SUM(OblixOtherItemFee__c)totalAmount FROM Marketing_Basics__c 
                                                WHERE Oblix_SOWMarketing__c = : marketing_SOW.Id GROUP BY RecordType.Name];
        campaignBasketList = new List<CampaignBasket>();
        if(groupedResults.size() > 0){
            for(AggregateResult eachResult : groupedResults){
                campaignBasketList.add(new CampaignBasket(String.valueOf(eachResult.get('Name')),Double.valueOf(eachResult.get('totalAmount')),Integer.valueOf(eachResult.get('quantity'))));
            }
        }
        getBasketTotal(campaignBasketList);
    }

    public void getBasketTotal(List<CampaignBasket> campaignBasketList){
        
        campaignTotalValue = 0;
        for(CampaignBasket eachCampaignBasket : campaignBasketList){
            campaignTotalValue += eachCampaignBasket.totalAmount;
        }
    }

    public void clearActivitySelectionMap(){
        
        activitySelectionMap.clear();
    }

    public Class CampaignBasket{
        public String activityName { get; set; }
        public Double totalAmount { get; set; }
        public Integer quantity { get; set; }

        public CampaignBasket(String activityName, Double totalAmount, Integer quantity){
            this.activityName = activityName;
            this.totalAmount = totalAmount;
            this.quantity = quantity;
        }
    }
       
    // Void Method used to initialise marketing_SOW  
    public void reRenderSOW() {
        
        if (sowId != null) {
            marketing_SOW = [select id, Name, Financial_Year__c, currency__c, Oblix_AgencyEstimate__c, Oblix_AgencyEstimate__r.Name from marketing_SOW__c where id = : sowId];
            fYear = marketing_SOW.Financial_Year__c;
            agency = marketing_SOW.Oblix_AgencyEstimate__c;
            MScurrency = marketing_SOW.currency__c;
            if (MScurrency =='EUR') {MScurrency = '€';  }
            fillCountries();
            refreshBasket();
        }
    
    
    }
    
    public void refreshActivitySelection(){
        fillCountries();
        fillAgencyDepartment();
        fillRoleTitle();
        fillRate();
        resource.hoursSelected = null;
        activity.hoursSelected = null;
    }

    // Description : Method used to update Rate options in Activities form 
    public void fillRate() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillrate =+=+=+=+=+=+=+=+=+============================');
    
        List < Oblix_Calculator__c > Rates = new List < Oblix_Calculator__c > ();
        System.DEBUG(' fYear ' + fYear);
        System.DEBUG(' agency ' + agency);
        System.DEBUG(' activity.selectedCountry ' + activity.selectedCountry);
        System.DEBUG(' activity.selectedAgencyDepartment ' + activity.selectedAgencyDepartment);
        System.DEBUG(' activity.selectedRole ' + activity.selectedRole);

        System.DEBUG(' resource.selectedCountry ' + resource.selectedCountry);
        System.DEBUG(' resource.selectedAgencyDepartment ' + resource.selectedAgencyDepartment);
        System.DEBUG(' resource.selectedRole ' + resource.selectedRole);
        //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        
        if (selectedTab.equalsIgnoreCase(ACTIVITY_DEV_NAME)) {
            Rates = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c, Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  activity.selectedCountry and Agency_Department__c = : activity.selectedAgencyDepartment and Role_Title__c = :  activity.selectedRole];
            System.DEBUG(' query: ' + 'select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c, Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c = \''+fYear+'\' and Oblix_Agency__c = \''+agency+'\' and OblixCountry__c = \''+activity.selectedCountry+'\' and Agency_Department__c = \''+activity.selectedAgencyDepartment+'\' and Role_Title__c = \''+activity.selectedRole+'\'');
        }else{
            Rates = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, FTE__c, Agency_Department__c, Role_Title__c, Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  resource.selectedCountry and Agency_Department__c = : resource.selectedAgencyDepartment and Role_Title__c = :  resource.selectedRole];
            System.DEBUG(' query: ' + 'select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, FTE__c, Agency_Department__c, Role_Title__c, Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c = \''+fYear+'\' and Oblix_Agency__c = \''+agency+'\' and OblixCountry__c = \''+resource.selectedCountry+'\' and Agency_Department__c = \''+resource.selectedAgencyDepartment+'\' and Role_Title__c = \''+resource.selectedRole+'\'');
        }
        if (Rates.size() >= 1) {
            if(selectedTab.equalsIgnoreCase(ACTIVITY_DEV_NAME)){
                activity.hourlyRate = String.valueOf((Rates[0].Role_Daily_Rate_EUR__c));//Math.round
                activity.roundedRate = activity.hourlyRate != null ? String.valueOf(Math.round(Decimal.valueOf(activity.hourlyRate))) : '0';//
            }else{
                resource.hourlyRate = String.valueOf((Rates[0].FTE__c));
                resource.roundedRate = resource.hourlyRate != null ? String.valueOf(Math.round(Decimal.valueOf(resource.hourlyRate))) : '0';//
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
    
     // Description : Method used to update roleTatle options in Activities form 
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
        if (selectedTab.equalsIgnoreCase(ACTIVITY_DEV_NAME)) {
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
            if (selectedTab.equalsIgnoreCase(ACTIVITY_DEV_NAME)) {
                agencyRoleTitle = new List < SelectOption>();
                agencyRoleTitle = populateRoleTitleList(roleTitlesNameMap);
                activity.roleVisible = true;
            } else {
                resourceRoleTitle = new List <SelectOption>();
                resourceRoleTitle = populateRoleTitleList(roleTitlesNameMap);
                resource.roleVisible = true;
                //this.setResourceUpdateButton = false;
            }

        }
        else{
            agencyRoleTitle = new List < SelectOption>();
            resourceRoleTitle = new List <SelectOption>();        
        }
        System.DEBUG(' agencyRoleTitle ' + agencyRoleTitle);
        System.DEBUG(' resourceRoleTitle ' + resourceRoleTitle);
        checkIFButtonISUpdateORAdd();
    }

    public List<SelectOption> populateRoleTitleList(Map<String,String> roleTitlesNameMap) {
        List<SelectOption> roleTitlesToReturn = new List<SelectOption>();
        
        for (String temp: roleTitlesNameMap.keySet()) {
            // if ( activity.selectedRole==null)  activity.selectedRole= temp; //remplir automatiquement par la premiere valeur
            roleTitlesToReturn.add(new SelectOption(temp, roleTitlesNameMap.get(temp)));
        }
        roleTitlesToReturn = Oblix_Utils.selectOptionSortByLabel(roleTitlesToReturn);
        // agencyRoleTitle.add(new SelectOption('', noRole));
        roleTitlesToReturn = Oblix_Utils.setFirstValue(noRole, Oblix_Utils.selectOptionSortByLabel(roleTitlesToReturn));
        //activity.selectedRole = '';
        return roleTitlesToReturn;
        //else add error (there is no rt to select)
    }
 
    
    //Description : Method used to update Agency departements options in Activities form 
    public void fillAgencyDepartment() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillAgencyDepartment=+=+=+=+=+=+=+=+=+============================');
        system.debug('selectedTab : ' + selectedTab);

        
        
        activity.selectedCountry = activity.selectedCountryName;
        resource.selectedCountry = resource.selectedCountryname;
        List < Oblix_Calculator__c > agencyDepartmentNames = new List < Oblix_Calculator__c > ();
        system.debug('activity.selectedCountry : ' + activity.selectedCountry);
        system.debug('resource.selectedCountry : ' + resource.selectedCountry);
        //  agencyDepartmentNames=[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c  from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__r.name=: activity.selectedCountry];

        if (selectedTab.equalsIgnoreCase(ACTIVITY_DEV_NAME)) {
            agencyDepartmentNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c from Oblix_Calculator__c where RecordTypeId = : rtCountry and Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__r.name like: activity.selectedCountry];
        }else{
            agencyDepartmentNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c from Oblix_Calculator__c where RecordTypeId = : rtCountry and Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__r.name like: resource.selectedCountry];
        }
        System.DEBUG('SOQL : ' + 'select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c from Oblix_Calculator__c where RecordTypeId = : '+ rtCountry+' and Financial_Year__c = :'+ fYear + 'and Oblix_Agency__c = : ' + agency +'and OblixCountry__r.name like: activity.selectedCountry]');
        if (!agencyDepartmentNames.isEmpty()) {
            activity.selectedCountry = agencyDepartmentNames[0].OblixCountry__c;
        }
        system.debug('============================zz=agencyDepartmentNames' + agencyDepartmentNames);
        Map < String, String > agencyDepartmentMap = new Map < String, String > ();
        // agencyDepartmentMap.put('', 'Agency Department');
        for (Oblix_Calculator__c c: agencyDepartmentNames) {
            agencyDepartmentMap.put(c.Agency_Department__c, c.Agency_Department__c);
        }
        system.debug('agencyDepartmentMap : ' + agencyDepartmentMap);
        if (selectedTab.equalsIgnoreCase(ACTIVITY_DEV_NAME)) {
            agencyDepartments = new List <SelectOption>();
            agencyDepartments = populateAgencyDepartmentList(agencyDepartmentMap);
            activity.agencyVisible = true;  
        } else {
            resourceAgencyDepartment = new List <SelectOption>();
            resourceAgencyDepartment = populateAgencyDepartmentList(agencyDepartmentMap);
            resource.agencyVisible = true;
            //this.setResourceUpdateButton = false;
        }
        System.DEBUG('resourceAgencyDepartment : ' + resourceAgencyDepartment);
        System.DEBUG('agencyDepartments : ' + agencyDepartments);
        checkIFButtonISUpdateORAdd();

    }

    public List<SelectOption> populateAgencyDepartmentList(Map <String, String> agencyDepartmentMap){
        List<SelectOption> departmentsToReturn = new List<SelectOption>();
        
        if (!agencyDepartmentMap.keyset().isEmpty()) {
            for (String temp: agencyDepartmentMap.keySet()) {
                departmentsToReturn.add(new SelectOption(temp, agencyDepartmentMap.get(temp)));
            }
            departmentsToReturn = Oblix_Utils.selectOptionSortByLabel(departmentsToReturn);
            departmentsToReturn = Oblix_Utils.setFirstValue('-Agency Department-', Oblix_Utils.selectOptionSortByLabel(departmentsToReturn));
        }
        return departmentsToReturn;
    }
    
    
     
    //Description : Method used to update Countries options in Activities and resources form 
    public void fillCountries() {
        
        List <Oblix_Calculator__c> countriesNames = new List <Oblix_Calculator__c>();
        countriesNames =[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency ];
        map<String,String>  countriesMap =new map<String,String> () ;
        for (Oblix_Calculator__c c: countriesNames ){
            if (c.OblixCountry__c !=null)
               { countriesMAp.put(c.OblixCountry__r.name ,c.OblixCountry__r.name );  }
        }
        countries = new List<SelectOption>();
       
        if( !countriesMap.isEmpty()){
            for (String cID: countriesMap.keySet()){
                //if (selectedCountry ==null) {       selectedCountry = cid;  //fill the selectOption  //remplir automatiquement par la premiere valeur
                //        newItem.OblixCountry__c = cid;  } //fill the lookup
                                           
                countries.add(new SelectOption(cID,countriesMap.get(cID)));
            }
        //else add error (there is no country to select)
            
        }
      countries = Oblix_Utils.selectOptionSortByLabel(countries);
      countries = Oblix_Utils.setFirstValue('-Country-', Oblix_Utils.selectOptionSortByLabel(countries ));
      system.debug('###countries : '+countries);
      checkIFButtonISUpdateORAdd();
        
    }
    
    public static Pagereference goToReportsHome(){
        Pagereference goToReportsHome = new Pagereference('/00O/o');
        return goToReportsHome.setRedirect(true);
    }

    public void checkIFButtonISUpdateORAdd(){
        
        String keyToSearch = marketing_SOW.Id + activity.nonCampaignItem.Activities__c + activity.selectedCountryname + activity.selectedAgencyDepartment + activity.selectedRole;
        System.DEBUG(' keyToSearch: '+ keyToSearch);
        System.DEBUG(' activitySelectionMap: '+ activitySelectionMap);
        if(activitySelectionMap.containsKey(keyToSearch)){
            setUpdateButton = true;
        }else{
            setUpdateButton = false;
        }
    }

    */
    
}