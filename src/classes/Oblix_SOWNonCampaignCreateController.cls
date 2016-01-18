public with sharing class Oblix_SOWNonCampaignCreateController {

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
    public Map<String, Marketing_Basics__c> existingKeys { get; set; }

    public String preSelectedName { get; set; }
        
    public  id sowId  {get;set;}
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
    
	public Oblix_SOWNonCampaignCreateController() {
		activity = new Oblix_NonCampaignWrapper();
        resource = new Oblix_NonCampaignWrapper();
        activitySelectionMap = new Map<String,Oblix_NonCampaignWrapper>();
        
        selectedActivitiesSize = 0;
        seletedActivity = '';
    
    
        Id idUser = UserInfo.getUserId();
        activity.nonCampaignItem = new Marketing_Basics__c();
        activity.nonCampaignItem.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get(ActivityName);
        rtActivity = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get(ActivityName).getRecordTypeId();
        rtResource = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
        rtCountry = Schema.SObjectType.Oblix_Calculator__c.getRecordTypeInfosByName().get('Role Rate').getRecordTypeId();
        
        sowId = ApexPAges.currentPage().getParameters().get('sowId');
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
        this.selectedName = preSelectedName;
        if(this.selectedName != null && !this.selectedName.equalsIgnoreCase(''))
            getSelectedActivitiesByName();
            System.Debug('activitySelectionMap : ' + activitySelectionMap);
    }

    public void getSelectedActivitiesByName(){
        existingKeys.clear();
        System.DEBUG('RecordTypeId : ' + rtActivity);
        List<Marketing_Basics__c> selectedActivities =[SELECT Id, Activities__c, Name, No_of_Hours_Required__c, OblixCountry__c, OblixCountry__r.Name , Role_Title__c, Agency_Department__c,
                                                        OblixOtherItemFee__c, Oblix_Hourly_Rate__c FROM Marketing_Basics__c WHERE Name =: selectedName AND Oblix_SOWMarketing__c =: marketing_SOW.Id 
                                                        AND RecordTypeId =: rtActivity];
        activitySelectionMap.clear();
        for(Marketing_Basics__c eachMarketingBasicRecord : selectedActivities){
            Oblix_NonCampaignWrapper selectedNonCampaignWrapper = new Oblix_NonCampaignWrapper();
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
            if(activitySelectionMap != null && activitySelectionMap.get(selectedNonCampaignWrapper.key) == null){
                activitySelectionMap.put(selectedNonCampaignWrapper.key,selectedNonCampaignWrapper);
            }
            selectedActivitiesSize = activitySelectionMap.values().size();
            System.Debug('activitySelectionMap : ' + activitySelectionMap);
        }
    }

    public void addToActivitySelectionMap(){
        System.DEBUG('Selected Activity : ' + seletedActivity);
        NonCampaignJSONWrapper activityJSONWrapper = new NonCampaignJSONWrapper();
        Oblix_NonCampaignWrapper selectedNonCampaignWrapper = new Oblix_NonCampaignWrapper();
        activityJSONWrapper = (NonCampaignJSONWrapper) JSON.deserialize(seletedActivity, NonCampaignJSONWrapper.class);
        selectedNonCampaignWrapper.selectedActivity = activityJSONWrapper.selectedActivity;
        selectedNonCampaignWrapper.selectedCountryname = activityJSONWrapper.selectedCountry;
        List<Oblix_Calculator__c> calc = [select OblixCountry__c from Oblix_Calculator__c where RecordTypeId = : rtCountry and Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__r.name =:  activityJSONWrapper.selectedCountry];
        if(!calc.isEmpty())
        	selectedNonCampaignWrapper.selectedCountry = calc[0].OblixCountry__c;
        selectedNonCampaignWrapper.nonCampaignItem = new Marketing_Basics__c();
        selectedNonCampaignWrapper.selectedAgencyDepartment = activityJSONWrapper.selectedAgencyDepartment;
        selectedNonCampaignWrapper.selectedRole = activityJSONWrapper.selectedRole;
        selectedNonCampaignWrapper.hourlyRate = activityJSONWrapper.hourlyRate;
        selectedNonCampaignWrapper.hoursSelected = activityJSONWrapper.hoursSelected != null ? Integer.valueOf(activityJSONWrapper.hoursSelected) : 0;
        selectedNonCampaignWrapper.totalAmount = activityJSONWrapper.totalAmount != null ? Math.round(Decimal.valueof(activityJSONWrapper.totalAmount)) : 0;
        selectedNonCampaignWrapper.key = activityJSONWrapper.key;
        selectedNonCampaignWrapper.activityId = activityJSONWrapper.activityId;
        if(activitySelectionMap != null && activitySelectionMap.get(selectedNonCampaignWrapper.key) == null){
            activitySelectionMap.put(selectedNonCampaignWrapper.key,selectedNonCampaignWrapper);
        }else{
            Oblix_NonCampaignWrapper wrapperToAdjust = activitySelectionMap.get(selectedNonCampaignWrapper.key);
            wrapperToAdjust.hoursSelected += selectedNonCampaignWrapper.hoursSelected;
            wrapperToAdjust.totalAmount += selectedNonCampaignWrapper.totalAmount;
            activitySelectionMap.put(selectedNonCampaignWrapper.key,wrapperToAdjust);
        }
        selectedActivitiesSize = activitySelectionMap.values().size();
        System.Debug('activitySelectionMap : ' + activitySelectionMap);
    }

    public void removeFromSelectionMap(){
        System.debug('Seleted Index : ' + selectedkey);
        System.DEBUG('activitySelectionMap Before : ' + activitySelectionMap);
        String selectedkeyValue = selectedkey;
        if(activitySelectionMap != null && activitySelectionMap.get(selectedkeyValue) != null){
            if(activitySelectionMap.get(selectedkeyValue).activityId != null){
                delete [SELECT Id FROM Marketing_Basics__c WHERE Id =: activitySelectionMap.get(selectedkeyValue).activityId ];
            }
            activitySelectionMap.remove(selectedkeyValue);
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

    public Class NonCampaignJSONWrapper{
        public String selectedCountry;
        public String selectedActivity;
        public String selectedAgencyDepartment;
        public String selectedRole;
        public String hourlyRate;
        public String hoursSelected;
        public Double totalAmount;
        public String key;
        public String activityId;
    }
   
	public Pagereference exitSwop(){
        Pagereference exitSwopHome = new Pagereference('/');
        return exitSwopHome.setRedirect(true);
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
            marketingBasicRecord.Name = eachNonCampaignWrapper.selectedActivity;
            marketingBasicRecord.OblixCountry__c = eachNonCampaignWrapper.selectedCountry;
            marketingBasicRecord.Role_Title__c = eachNonCampaignWrapper.selectedRole;
            marketingBasicRecord.Agency_Department__c = eachNonCampaignWrapper.selectedAgencyDepartment;
            marketingBasicRecord.recordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get(ActivityName).getRecordTypeId();
            marketingBasicRecord.Oblix_SOWMarketing__c = marketing_SOW.Id;
            if(marketingBasicRecord.Non_Campaign_Key__c != null)
            	marketingBasicRecordList.add(marketingBasicRecord);
        }
        System.debug('!!! marketingBasicRecordList:'+marketingBasicRecordList);
        upsert marketingBasicRecordList Non_Campaign_Key__c;
        refreshBasket();
        clearActivitySelectionMap();
        selectedActivitiesSize = activitySelectionMap.values().size();
    }

    public void insertSelectedResourceAndRefreshBasket(){
        Marketing_Basics__c marketingBasicRecordToInsert = new Marketing_Basics__c();
        marketingBasicRecordToInsert.Name = resource.nonCampaignItem.name;
        marketingBasicRecordToInsert.Agency_Department__c = resource.selectedAgencyDepartment;
        marketingBasicRecordToInsert.OblixOtherItemFee__c = resource.hourlyRate != null ? Math.round(Decimal.valueof(resource.hourlyRate.trim()) * resource.hoursSelected / 100) : 0;
        marketingBasicRecordToInsert.recordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
        marketingBasicRecordToInsert.Oblix_SOWMarketing__c = marketing_SOW.Id;
        marketingBasicRecordToInsert.Role_Title__c = resource.selectedRole;
        marketingBasicRecordToInsert.FTE__c = resource.hoursSelected;
        marketingBasicRecordToInsert.non_campaign_title__c = resource.nonCampaignItem.name;
        marketingBasicRecordToInsert.OblixCountry__c = resource.selectedCountry;
        insert marketingBasicRecordToInsert;
        refreshBasket();

    }

    public void refreshBasket(){
        AggregateResult[] groupedResults = [SELECT Name, SUM(OblixOtherItemFee__c)totalAmount FROM Marketing_Basics__c 
                                                WHERE Oblix_SOWMarketing__c = : marketing_SOW.Id group by Name];
        campaignBasketList = new List<CampaignBasket>();
        if(groupedResults.size() > 0){
            for(AggregateResult eachResult : groupedResults){
                campaignBasketList.add(new CampaignBasket(String.valueOf(eachResult.get('Name')),Double.valueOf(eachResult.get('totalAmount'))));
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

        public CampaignBasket(String activityName, Double totalAmount){
            this.activityName = activityName;
            this.totalAmount = totalAmount;
        }
    }
       
    /* Void Method used to initialise marketing_SOW  
     */
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
    
    /*
    Description : Method used to update Rate options in Activities form 
    */
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
        if (selectedTab.equalsIgnoreCase('activity')) {
            Rates = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c, Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  activity.selectedCountry and Agency_Department__c = : activity.selectedAgencyDepartment and Role_Title__c = :  activity.selectedRole];
        }else{
            Rates = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, FTE__c, Agency_Department__c, Role_Title__c, Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  resource.selectedCountry and Agency_Department__c = : resource.selectedAgencyDepartment and Role_Title__c = :  resource.selectedRole];
        }
        if (Rates.size() >= 1) {
            if(selectedTab.equalsIgnoreCase('activity')){
                activity.hourlyRate = String.valueOf((Rates[0].Role_Daily_Rate_EUR__c));//Math.round
                activity.roundedRate = String.valueOf(Math.round(Rates[0].Role_Daily_Rate_EUR__c));//
            }else{
                resource.hourlyRate = String.valueOf((Rates[0].FTE__c));
                resource.roundedRate = String.valueOf(Math.round(Rates[0].FTE__c));//
            }
        }
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
        if (selectedTab.equalsIgnoreCase('activity')) {
            RoleTitleNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = : activity.selectedCountry and Agency_Department__c = : activity.selectedAgencyDepartment];
        }else{
            resource.selectedCountry = Oblix_Utils.CountrryGetId(resource.selectedCountry);
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
            if (selectedTab.equalsIgnoreCase('activity')) {
                agencyRoleTitle = new List < SelectOption>();
                agencyRoleTitle = populateRoleTitleList(agencyRoleTitle, roleTitlesNameMap);
                activity.roleVisible = true;
            } else {
                resourceRoleTitle = new List <SelectOption>();
                resourceRoleTitle = populateRoleTitleList(resourceRoleTitle, roleTitlesNameMap);
                resource.roleVisible = true;
            }

        }
        System.DEBUG(' agencyRoleTitle ' + agencyRoleTitle);
        System.DEBUG(' resourceRoleTitle ' + resourceRoleTitle);
    }

    public List < SelectOption > populateRoleTitleList(List<SelectOption> roleTitle, Map<String,String> roleTitlesNameMap) {
        for (String temp: roleTitlesNameMap.keySet()) {
            // if ( activity.selectedRole==null)  activity.selectedRole= temp; //remplir automatiquement par la premiere valeur
            roleTitle.add(new SelectOption(temp, roleTitlesNameMap.get(temp)));
        }
        roleTitle = Oblix_Utils.selectOptionSortByLabel(roleTitle);
        // agencyRoleTitle.add(new SelectOption('', noRole));
        roleTitle = Oblix_Utils.setFirstValue(noRole, Oblix_Utils.selectOptionSortByLabel(roleTitle));
        //activity.selectedRole = '';
        return roleTitle;
        //else add error (there is no rt to select)
    }
 
    
    
    /*
    Description : Method used to update Agency departements options in Activities form 
    */
    public void fillAgencyDepartment() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillAgencyDepartment=+=+=+=+=+=+=+=+=+============================');
        system.debug('selectedTab : ' + selectedTab);

        
        
        activity.selectedCountry = activity.selectedCountryName;
        resource.selectedCountry = resource.selectedCountryname;
        List < Oblix_Calculator__c > agencyDepartmentNames = new List < Oblix_Calculator__c > ();
        system.debug('activity.selectedCountry : ' + activity.selectedCountry);
        system.debug('resource.selectedCountry : ' + resource.selectedCountry);
        //  agencyDepartmentNames=[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c  from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__r.name=: activity.selectedCountry];

        if (selectedTab.equalsIgnoreCase('activity')) {
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
        if (selectedTab.equalsIgnoreCase('activity')) {
            agencyDepartments = new List <SelectOption>();
            agencyDepartments = populateAgencyDepartmentList(agencyDepartments, agencyDepartmentMap);
            activity.agencyVisible = true;  
        } else {
            resourceAgencyDepartment = new List <SelectOption>();
            resourceAgencyDepartment = populateAgencyDepartmentList(resourceAgencyDepartment, agencyDepartmentMap);
            resource.agencyVisible = true;
        }
        System.DEBUG('resourceAgencyDepartment : ' + resourceAgencyDepartment);
        System.DEBUG('agencyDepartments : ' + agencyDepartments);

    }

    public List<SelectOption> populateAgencyDepartmentList(List<SelectOption> departments, Map <String, String> agencyDepartmentMap){
        if (!agencyDepartmentMap.keyset().isEmpty()) {
            for (String temp: agencyDepartmentMap.keySet()) {
                departments.add(new SelectOption(temp, agencyDepartmentMap.get(temp)));
            }
            departments = Oblix_Utils.selectOptionSortByLabel(departments);
            departments = Oblix_Utils.setFirstValue('-Agency Department-', Oblix_Utils.selectOptionSortByLabel(departments));
        }
        return departments;
    }
    
    
     
    /*
    Description : Method used to update Countries options in Activities and resources form 
    */
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
        
        
    }
    
    
}