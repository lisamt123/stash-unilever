public with sharing class Oblix_SOWNonCampaignCreateController {

	public Oblix_NonCampaignWrapper activity {get;set;} 
    public Oblix_NonCampaignWrapper resource {get;set;}

    public Map<Integer,Oblix_NonCampaignWrapper> activitySelectionMap { get; set; }
    public String seletedActivity { get; set; }
    public User userConnected {get;set;}
    public Integer selectedIndex { get; set; }
    public String basketItemToRemove { get; set; }
    public Double campaignTotalValue { get; set; }
    public List<CampaignBasket> campaignBasketList { get; set; }
    public Integer selectedActivitiesSize { get; set; }
        
    public  id sowId  {get;set;}
    public List<Marketing_Basics__c> newItems  {get;set;}
    public marketing_SOW__c marketing_SOW  { get; set; }
    public boolean errMsg  {get;set;}
    public boolean myMessages {get;set;}
    public boolean errMsg1  {get;set;}
    public boolean myMessages1 {get;set;}
    
    public boolean   selectResource {get;set;}    //true to render a js code who trigger  resource tab                
    
    public Boolean TitleEdit {get;set;}
    public String MScurrency {get;set;}
    public String saveStatus {get;set;}
    Public Integer ElemToDel  {get;set;}     
    Public Integer ElemToEdit  {get;set;}
    Public boolean edit1{get;set;}
    Public boolean edit2{get;set;}
   	public List<SelectOption> countries {get;set;}
    
    public List<SelectOption> AgencyDepartments{get;set;}
    public List<SelectOption> RoleTitles{get;set;}
    
    public List<SelectOption> AgencyDepartments1 {get;set;}
    public List<SelectOption> RoleTitles1 {get;set;}
    
    
    public  id rtActivity  {get;set;}
    private id rtResource ;
    
    
    private Marketing_Basics__c newItem  ;
    private  Marketing_Basics__c newItem1 ;
    private List<Marketing_Basics__c > XItems ;
    
    
    
    
    
    private  String fYear ;
    private String agency ;
    
  
    
 
    
    private id rtCountry ; 
    
    private String marKObjName= System.Label.Oblix_Lbl_Marketing_Basics_c ;
    private String ActivityName= System.Label.Oblix_Lbl_Activity;
    
    private String noRole= System.Label.Oblix_Lbl_Role;
    
   
    public Integer somme ;

	public Oblix_SOWNonCampaignCreateController() {
		activity = new Oblix_NonCampaignWrapper();
        //activity.clear();
        resource = new Oblix_NonCampaignWrapper();
        activitySelectionMap = new Map<Integer,Oblix_NonCampaignWrapper>();
        selectedActivitiesSize = 0;
        //populateDummy();
        //fillCountries();
        //resource.clear();
        selectResource = false;
        TitleEdit = false;
    
        errMsg = false;
        myMessages = false;
        errMsg1 = false;
        myMessages1 = false;
        seletedActivity = '';
    
    
        Id idUser = UserInfo.getUserId();
        userConnected = [Select Name from User where Id = : idUser];
        newItems = new List < Marketing_Basics__c > ();
        XItems = new List < Marketing_Basics__c > ();
        newItem = new Marketing_Basics__c();
        newItem1 = new Marketing_Basics__c();
        activity.nonCampaignItem = new Marketing_Basics__c();
        activity.nonCampaignItem.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get(ActivityName);
        
        sowId = ApexPAges.currentPage().getParameters().get('sowId');
        reRenderSOW();
    
        saveStatus = '';
        activity = new Oblix_NonCampaignWrapper();
        //activity.agencyVisible = false;
        //activity.roleVisible = false;
        //activity.valVisible = false;
        ////activity.rateVisible =false;
        //activity.resultVisible = false;
        //activity.addVisible = false;
    
        ElemToEdit = -1;
        edit1 = false;
        edit2 = false;
    
        rtActivity = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get(ActivityName).getRecordTypeId();
        rtResource = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
        rtCountry = Schema.SObjectType.Oblix_Calculator__c.getRecordTypeInfosByName().get('Role Rate').getRecordTypeId();
    
        initialiseOptions();
        initialiseOptions1();
    
    
        id EditId = ApexPAges.currentPage().getParameters().get('itm');
        if (EditId != null) {
            TitleEdit = true;
            elemToEdit = 0;
            Marketing_Basics__c editItem = [select id, name, non_campaign_title__c, FTE__c, recordTypeId, OblixOtherItemFee__c, Agency_Department__c, Role_Title__c, Activities__c, Other_Activities__c, No_of_Hours_Required__c, OblixCountry__c, Oblix_SOWMarketing__c from Marketing_Basics__c where id = : EditId];
            sowId = editItem.Oblix_SOWMarketing__c;
            reRenderSOW();
            newItems.add(editItem);
            fillData(editItem);
        }
	}


    public void addToActivitySelectionMap(){
        System.DEBUG('Selected Activity : ' + seletedActivity);
        NonCampaignJSONWrapper activityJSONWrapper = new NonCampaignJSONWrapper();
        Oblix_NonCampaignWrapper selectedNonCampaignWrapper = new Oblix_NonCampaignWrapper();
        activityJSONWrapper = (NonCampaignJSONWrapper) JSON.deserialize(seletedActivity, NonCampaignJSONWrapper.class);
        selectedNonCampaignWrapper.selectedActivity = activityJSONWrapper.selectedActivity;
        selectedNonCampaignWrapper.selectedCountryname = activityJSONWrapper.selectedCountry;
        selectedNonCampaignWrapper.selectedCountry = [select OblixCountry__c from Oblix_Calculator__c where RecordTypeId = : rtCountry and Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__r.name =:  activityJSONWrapper.selectedCountry][0].OblixCountry__c;
        selectedNonCampaignWrapper.nonCampaignItem = new Marketing_Basics__c();
        selectedNonCampaignWrapper.selectedAgencyDepartment = activityJSONWrapper.selectedAgencyDepartment;
        selectedNonCampaignWrapper.selectedRole = activityJSONWrapper.selectedRole;
        selectedNonCampaignWrapper.hourlyRate = activityJSONWrapper.hourlyRate;
        selectedNonCampaignWrapper.hoursSelected = Integer.valueOf(activityJSONWrapper.hoursSelected);
        selectedNonCampaignWrapper.totalAmount = String.valueof(Math.round(Decimal.valueof(activityJSONWrapper.totalAmount)));
        selectedNonCampaignWrapper.index = Integer.valueOf(activityJSONWrapper.index);
        if(activitySelectionMap != null && activitySelectionMap.get(selectedNonCampaignWrapper.index) == null){
            activitySelectionMap.put(selectedNonCampaignWrapper.index,selectedNonCampaignWrapper);
        }
        selectedActivitiesSize = activitySelectionMap.values().size();
        System.Debug('activitySelectionMap : ' + activitySelectionMap);
    }

    public void removeFromSelectionMap(){
        System.debug('Seleted Index : ' + selectedIndex);
        System.DEBUG('activitySelectionMap Before : ' + activitySelectionMap);
        Integer selectedIndexValue = Integer.valueOf(selectedIndex);
        if(activitySelectionMap != null && activitySelectionMap.get(selectedIndexValue) != null){
            activitySelectionMap.remove(selectedIndexValue);
        }
        System.DEBUG('activitySelectionMap After  : ' + activitySelectionMap);
    }

    public void removeItemFromBasketList(){
        System.DEBUG('Basket Item to Remove : ' + basketItemToRemove);
        if(basketItemToRemove != null){
            delete [SELECT Id FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c =: marketing_SOW.Id AND Name =: basketItemToRemove];
        }
        refreshBasket();
    }


    

    public Class NonCampaignJSONWrapper{
        public String selectedCountry;
        public String selectedActivity;
        public String selectedAgencyDepartment;
        public String selectedRole;
        public String hourlyRate;
        public String hoursSelected;
        public String totalAmount;
        public Integer index;
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
            marketingBasicRecord.Activities__c = eachNonCampaignWrapper.selectedActivity;
            marketingBasicRecord.Non_campaign_title__c = eachNonCampaignWrapper.selectedActivity;
            marketingBasicRecord.Name = eachNonCampaignWrapper.selectedActivity;
            marketingBasicRecord.No_of_Hours_Required__c = eachNonCampaignWrapper.hoursSelected;
            marketingBasicRecord.OblixCountry__c = eachNonCampaignWrapper.selectedCountry;
            marketingBasicRecord.Role_Title__c = eachNonCampaignWrapper.selectedRole;
            marketingBasicRecord.Agency_Department__c = eachNonCampaignWrapper.selectedAgencyDepartment;
            marketingBasicRecord.OblixOtherItemFee__c = Decimal.valueOf(eachNonCampaignWrapper.totalAmount);
            marketingBasicRecord.recordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get(ActivityName).getRecordTypeId();
            marketingBasicRecord.Oblix_SOWMarketing__c = marketing_SOW.Id;
            marketingBasicRecordList.add(marketingBasicRecord);
        }
        insert marketingBasicRecordList;
        refreshBasket();
        clearActivitySelectionMap();
        selectedActivitiesSize = activitySelectionMap.values().size();
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
    /*
    *   @Description : Method used to fill all related Data : Country, Agency Department, Role, Record Id, Selected
    *           Tab if it's edit mode.
    *   @param : Non Campaign Item
    *   @return: void
    */
    private void fillData(Marketing_Basics__c eeditItem) {
       // MDO_Geography__c g;
        if (eeditItem.recordTypeId == rtActivity) {
            //activity.agencyVisible = true;
            //activity.roleVisible = true;
            //activity.valVisible = true;
            ////activity.rateVisible =true;
            //activity.resultVisible = true;
            //activity.addVisible = true;
            activity.hoursSelected = Integer.valueof(eeditItem.No_of_Hours_Required__c);
    
            fillCountries();
            //g = [select id, name from MDO_Geography__c where id = : eeditItem.OblixCountry__c];
            List<MDO_Geography__c> lstGeoTmp = [select id, name from MDO_Geography__c where id = : eeditItem.OblixCountry__c];
            if(!lstGeoTmp.isEmpty()){
                 activity.selectedCountryName = lstGeoTmp[0].name;
            }
            // activity.selectedCountry =  g.name ;   //.toUpperCase(); //'FRANCE' ;
            fillAgencyDepartment();
            activity.selectedAgencyDepartment = eeditItem.Agency_Department__c;
            fillRoleTitle();
            activity.selectedRole = eeditItem.Role_Title__c;
            fillRate();
            edit1 = true;
    
            //activity.name = eeditItem.name;
            //itemID = eeditItem.id;
            activity.nonCampaignItem.Activities__c = eeditItem.Activities__c;
            activity.nonCampaignItem.Other_Activities__c = eeditItem.Other_Activities__c;
            activity.result = String.valueof(eeditItem.OblixOtherItemFee__c);
     } else {
            selectResource = true;
            //resource.agencyVisible = true;
            //resource.roleVisible = true;
            //resource.valVisible = true;
            //resource.val = Integer.valueof(eeditItem.FTE__c);
            ////activity.rateVisible =true;
            //resource.resultVisible = true;
            //resource.addVisible = true;
            if(eeditItem.OblixCountry__c == null && resource.selectedCountry != ''){
                eeditItem.OblixCountry__c =  resource.selectedCountry;
            }
            system.debug('### resource.selectedCountry : '+ resource.selectedCountry);
            system.debug('###eeditItem : '+eeditItem);        
            fillCountries();
            system.debug('###eeditItem.OblixCountry__c : '+eeditItem.OblixCountry__c);   
           // g = [select id, name from MDO_Geography__c where id = : eeditItem.OblixCountry__c];
             List<MDO_Geography__c> lstGeoTmp1 = [select id, name from MDO_Geography__c where id = : eeditItem.OblixCountry__c];
            if(!lstGeoTmp1.isEmpty()){
                 resource.selectedCountryName = lstGeoTmp1[0].name;
            }
          //   resource.selectedCountry =   g.name ; //.toUpperCase(); //'FRANCE' ;
            fillAgencyDepartment1();
            resource.selectedAgencyDepartment = eeditItem.Agency_Department__c;
            fillRoleTitle1();
             resource.selectedRole = eeditItem.Role_Title__c;
            fillRate1();
            edit2 = true;
            //resource.name = eeditItem.name;
         //   itemID1 = eeditItem.id;
            resource.result = String.valueof(eeditItem.OblixOtherItemFee__c);
    
    
        }
    }
    
    /*
    *   @Description : Void Method used to initialise SelectOptions
    *   @param : none
    *   @return: void
    */
    private void initialiseOptions() {
        AgencyDepartments = new List < SelectOption > ();
        AgencyDepartments.add(new SelectOption('', '-Agency Department-'));
        RoleTitles = new List < SelectOption > ();
        RoleTitles.add(new SelectOption('', noRole));
    }
    /*
    *   @Description : Void Method used to initialise SelectOptions
    *   @param : none
    *   @return: void
    */
    private void initialiseOptions1() {
        AgencyDepartments1 = new List < SelectOption > ();
        AgencyDepartments1.add(new SelectOption('', '-Agency Department-'));
        RoleTitles1 = new List < SelectOption > ();
        RoleTitles1.add(new SelectOption('', noRole));
    
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
  
    /* Method used to save current List (upsert)
     * @Void 
     */
    public pagereference saveList() {
        try {
            upsert newItems;
            delete Xitems;
            myMessages = false;
            myMessages1 = false;
        } catch (DmlException e) {
            System.debug('###Exception Occured :' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Error Occured during save please review data entry'));
            myMessages = true;
            myMessages1 = true;
        }
    
    
        Xitems = new List < Marketing_Basics__c > ();
        saveStatus = 'Saved';
        return null;
    }
    
     /*
    Description : this action is called from button remove, its used to delete one item from the list  
    */
    public void delElm() {
        if (newItems[elemToDel].id != null) {Xitems.add(newItems[elemToDel]);  }
        newItems.remove(elemToDel);
        saveStatus = 'Unsaved';
    }
    
     /*
    Description : this action is called from button edit, its used to fill the form with correct values 
    */
    public void editItem() {
        fillData(newItems[elemToEdit]);
    }
    
     /*
    Description : used to update List of non campaigns Activities by Adding new item or update existing Item 
    */
    public void addToNew() {
        saveStatus = 'Unsaved';
        myMessages = false;
        
        //if (activity.name == null || activity.name == '') {
        //    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Name value is required.'));
        //    myMessages = true;
        //    return;
        //}
        
        Id devRecordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get(ActivityName).getRecordTypeId();
        //recordtype
        if (edit1) { // c'est un update
    
            newItem = newItems[ElemToEdit];
        } else {
            newItem = new Marketing_Basics__c();
            newItem.Oblix_SOWMarketing__c = marketing_SOW.id;
        }
        //newItem.name = activity.name;
        newItem.Activities__c =  activity.nonCampaignItem.Activities__c;
        newItem.Other_Activities__c =  activity.nonCampaignItem.Other_Activities__c;
    
        Map < String, String > abrev = Oblix_Utils.getAbreViationForCardAssets();
        string abr = abrev.get( activity.nonCampaignItem.Activities__c);
        if (abr == null) {  abr = '';   }
        newItem.non_campaign_title__c = 'ACT-' + abr;
        // activity.nonCampaignItem.Activities__c
        //    newItem.id =itemID ;
        newItem.recordTypeId = devRecordTypeId;
    
        newItem.No_of_Hours_Required__c = activity.hoursSelected;
        newItem.OblixCountry__c =  activity.selectedCountry;
        newItem.Role_Title__c =  activity.selectedRole;
        newItem.Agency_Department__c = activity.selectedAgencyDepartment;
        calculResult();
        newItem.OblixOtherItemFee__c = Math.round(Decimal.valueof(activity.result));//.setScale(0); // activity.result =activity.result.setScale(2);
        Marketing_Basics__c x = newItem;
        if (edit1) { // c'est un update
            newItems[ElemToEdit] = x;
            edit1 = false;
    
        } else {newItems.add(x);} // cest un ajout
    
        //activity.clear();
       
    
    }
    
    /*
    Description : Method used to update List of non campaigns Resources by Adding new item or update existing Item 
    */
    public void addToNew1() {
        saveStatus = 'Unsaved';
         myMessages1 = false;
         
        //if (resource.name == null || resource.name == '') {
        //    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Name value is required.'));
        //    myMessages1 = true;
        //    return;
        //}
       
    
        Id devRecordTypeId = rtResource ;// Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
        //recordtype
        
         if (edit2) { // c'est un update
    
            newItem1 = newItems[ElemToEdit];
        } else {
            newItem1 = new Marketing_Basics__c();
            newItem1.Oblix_SOWMarketing__c = marketing_SOW.id;
        }
        
        
    
        newItem1.name = resource.name;
        newItem1.non_campaign_title__c = resource.name;
        newItem1.recordTypeId = devRecordTypeId;
      //  newItem1.Oblix_SOWMarketing__c = marketing_SOW.id;
        newItem1.FTE__c = resource.hoursSelected;
        newItem1.OblixCountry__c =  resource.selectedCountry;
        newItem1.Role_Title__c =  resource.selectedRole;
       // newItem1.id = itemID1;
        newItem1.Agency_Department__c = resource.selectedAgencyDepartment;
        calculResult1();
     //   newItem1.OblixOtherItemFee__c = Integer.valueof(resource.result);//.setScale(0); // result =result.setScale(2)
        newItem1.OblixOtherItemFee__c = Math.round(Decimal.valueof(resource.result));//.setScale(0); // result =result.setScale(2)
     
        if (edit2) { // c'est un Edit
            newItems[ElemToEdit] = newItem1;
            edit2 = false;
        } else { newItems.add(newItem1);  }
    
        newItem1 = new Marketing_Basics__c();
        //resource.clear();
        resource.name='';
    }
    
     /*
    Description : Method used to calculate result for Activity 
    */
    public void calculResult() {
        system.debug('============+=+=+=+=+=+=+=+=+= calculResult=+=+=+=+=+=+=+=+=+============================');
        activity.result = String.valueof(Math.round(Decimal.valueof(activity.hourlyRate.trim()) * activity.hoursSelected));//.setScale(0));
        //  result =result;
    }
    
      /*
    Description : Method used to calculate result for Resource
    */
    public void calculResult1() {
        system.debug('============+=+=+=+=+=+=+=+=+= calculResult1=+=+=+=+=+=+=+=+=+============================');
        resource.result = String.valueof(Math.round(Decimal.valueof(resource.hourlyRate.trim()) * resource.hoursSelected / 100));//.setScale(0));
        //result1 =result1;       
    }
    
    /*
    Description : Method used to update Rate options in Resource form 
    */
    public void fillRate1() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillrate1 =+=+=+=+=+=+=+=+=+============================');
    
        //resource.rateVisible = false;
        //resource.valVisible = false;
        //resource.resultVisible = false;
        //resource.addVisible = false;
        List < Oblix_Calculator__c > Rates = new List < Oblix_Calculator__c > ();
        //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        Rates = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c, FTE__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  resource.selectedCountry and Agency_Department__c = : resource.selectedAgencyDepartment and Role_Title__c = :  resource.selectedRole];
        if (Rates.size() >= 1) {
            //resource.rateVisible = true;
            //resource.valVisible = true;
            //resource.resultVisible = true;
            //resource.addVisible = true;
            resource.hourlyRate = String.valueOf((Rates[0].FTE__c));//Integer.valueOf  Math.round
            resource.roundedRate = String.valueOf( Math.round(Rates[0].FTE__c));//Integer.valueOf 
            errMsg1 = false;
        }
    /*    if (Rates.size() > 1) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning, 'There are duplicate records with the selected values'));
            errMsg1 = true;
        } */
        //else there is more than 1 or 0 => error 
    }
    
    /*
    Description : Method used to update Rate options in Activities form 
    */
    public void fillRate() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillrate =+=+=+=+=+=+=+=+=+============================');
    
        //   if ( activity.selectedRole ==noRole ||  activity.selectedRole ==null){return ;}
        //activity.rateVisible = false;
        //activity.valVisible = false;
        //activity.resultVisible = false;
        //activity.addVisible = false;
        List < Oblix_Calculator__c > Rates = new List < Oblix_Calculator__c > ();
        //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        Rates = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c, Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  activity.selectedCountry and Agency_Department__c = : activity.selectedAgencyDepartment and Role_Title__c = :  activity.selectedRole];
        if (Rates.size() >= 1) {
            //activity.rateVisible = true;
            //activity.valVisible = true;
            //activity.resultVisible = true;
            //activity.addVisible = true;
            activity.hourlyRate = String.valueOf((Rates[0].Role_Daily_Rate_EUR__c));//Math.round
            activity.roundedRate = String.valueOf(Math.round(Rates[0].Role_Daily_Rate_EUR__c));//
            errMsg = false;
        }
       /*  if (Rates.size() > 1) {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning, 'There are duplicate records with the selected values'));
            errMsg = true;
        } */
        //else there is more than 1 or 0 => error 
    }
    
     /*
    Description : Method used to update roleTatle options in Activities form 
    */
    public void fillRoleTitle() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillRoleTitle=+=+=+=+=+=+=+=+=+============================');
    
        //   if (activity.selectedAgencyDepartment=='' || activity.selectedAgencyDepartment==null){return ;}
        //activity.roleVisible = false;
        ////   activity.rateVisible =false;
        //activity.valVisible = false;
        //activity.resultVisible = false;
        //activity.addVisible = false;
        List < Oblix_Calculator__c > RoleTitleNames = new List < Oblix_Calculator__c > ();
        //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        System.DEBUG(' fYear ' + fYear);
        System.DEBUG(' agency ' + agency);
        System.DEBUG(' activity.selectedCountry ' + activity.selectedCountry);
        System.DEBUG(' activity.selectedAgencyDepartment ' + activity.selectedAgencyDepartment);

        RoleTitleNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  activity.selectedCountry and Agency_Department__c = : activity.selectedAgencyDepartment];
        System.DEBUG(' RoleTitleNames ' + RoleTitleNames);
        map < String, String > RoleTitleNamesMap = new map < String, String > ();
        for (Oblix_Calculator__c c: RoleTitleNames) {
            if (c.Role_Title__c != null)
                { RoleTitleNamesMap.put(c.Role_Title__c, c.Role_Title__c); }
        } 
        RoleTitles = new List < SelectOption > ();
        if (!RoleTitleNamesMap.keyset().isEmpty() ) {
            activity.roleVisible = true;
            // activity.selectedRole = null;
            for (String temp: RoleTitleNamesMap.keySet()) {
                // if ( activity.selectedRole==null)  activity.selectedRole= temp; //remplir automatiquement par la premiere valeur
                RoleTitles.add(new SelectOption(temp, RoleTitleNamesMap.get(temp)));
            }
            RoleTitles = Oblix_Utils.selectOptionSortByLabel(RoleTitles);
            // RoleTitles.add(new SelectOption('', noRole));
            RoleTitles= Oblix_Utils.setFirstValue(noRole, Oblix_Utils.selectOptionSortByLabel(RoleTitles));
             activity.selectedRole = '';
            //else add error (there is no rt to select)
        }
        System.DEBUG(' RoleTitles ' + RoleTitles);
    }
 
    /*
    Description : Method used to update roleTatle options in resource form 
    */
    public void fillRoleTitle1() {
    
        system.debug('============+=+=+=+=+=+=+=+=+= fillRoleTitle1=+=+=+=+=+=+=+=+=+============================');
    
        //resource.roleVisible = false;
        ////   resource.rateVisible =false;
        //resource.valVisible = false;
        //resource.resultVisible = false;
        //resource.addVisible = false;
        List < Oblix_Calculator__c > RoleTitleNames = new List < Oblix_Calculator__c > ();
        //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        RoleTitleNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  resource.selectedCountry and Agency_Department__c = : resource.selectedAgencyDepartment];
        map < String, String > RoleTitleNamesMap = new map < String, String > ();
        for (Oblix_Calculator__c c: RoleTitleNames) {
            if (c.Role_Title__c != null)
              {  RoleTitleNamesMap.put(c.Role_Title__c, c.Role_Title__c); }
        }
        RoleTitles1 = new List < SelectOption > ();
     
        if (!RoleTitleNamesMap.keyset().isEmpty()) {
            //resource.roleVisible = true;
            // resource.selectedRole = null;
            for (String temp: RoleTitleNamesMap.keySet()) {
                // if ( activity.selectedRole==null)  activity.selectedRole= temp; //remplir automatiquement par la premiere valeur
                RoleTitles1.add(new SelectOption(temp, RoleTitleNamesMap.get(temp)));
            }
    
            RoleTitles1 = Oblix_Utils.selectOptionSortByLabel(RoleTitles1);
             //  RoleTitles1.add(new SelectOption('', noRole));
            RoleTitles1= Oblix_Utils.setFirstValue(noRole, Oblix_Utils.selectOptionSortByLabel(RoleTitles1));
             
             resource.selectedRole = '';
            //else add error (there is no rt to select)
        }
    }
    
    /*
    Description : Method used to update Agency departements options in Activities form 
    */
    public void fillAgencyDepartment() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillAgencyDepartment=+=+=+=+=+=+=+=+=+============================');
        RoleTitles = new List < SelectOption > ();
        RoleTitles.add(new SelectOption('', noRole));
         activity.selectedRole = '';
    
       // activity.selectedCountry = Oblix_UTils.CountrryGetId( activity.selectedCountry);
        activity.selectedCountry =  activity.selectedCountryName;            
        //activity.agencyVisible = false;
        //activity.roleVisible = false;
        //activity.rateVisible = false;
        //activity.valVisible = false;
        //activity.resultVisible = false;
        //activity.addVisible = false;
    
    
        //newItem.OblixCountry__c =  activity.selectedCountry;
    
        List < Oblix_Calculator__c > Agency_DepartmentNames = new List < Oblix_Calculator__c > ();
        system.debug('===========newItem.OblixCountry__c' + newItem.OblixCountry__c);
        //  Agency_DepartmentNames=[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c  from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__r.name=: activity.selectedCountry];
        Agency_DepartmentNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c from Oblix_Calculator__c where RecordTypeId = : rtCountry and Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__r.name like:  activity.selectedCountry];
        if (!Agency_DepartmentNames.isEmpty() ){
             activity.selectedCountry = Agency_DepartmentNames[0].OblixCountry__c;
             }
        map < String, String > Agency_DepartmentMap = new map < String, String > ();
       // Agency_DepartmentMap.put('', 'Agency Department');
        for (Oblix_Calculator__c c: Agency_DepartmentNames) {
            Agency_DepartmentMap.put(c.Agency_Department__c, c.Agency_Department__c);
        }
        AgencyDepartments = new List < SelectOption > ();
        if (!Agency_DepartmentMap.keyset().isEmpty() ) {
            activity.agencyVisible = true;
            activity.selectedAgencyDepartment = null;
            for (String temp: Agency_DepartmentMap.keySet()) {
                if (activity.selectedAgencyDepartment == null) {activity.selectedAgencyDepartment = temp;}
                AgencyDepartments.add(new SelectOption(temp, Agency_DepartmentMap.get(temp)));
            }
            AgencyDepartments = Oblix_Utils.selectOptionSortByLabel(AgencyDepartments);
            AgencyDepartments = Oblix_Utils.setFirstValue('-Agency Department-', Oblix_Utils.selectOptionSortByLabel(AgencyDepartments ));

            activity.selectedAgencyDepartment = '';
                            
            //else add error (there is no to select)
        } else {
            //activity.agencyVisible = false;
            //activity.roleVisible = false;
            ////activity.rateVisible =false;
            //activity.valVisible = false;
            //activity.resultVisible = false;
            //activity.addVisible = false;
        }
    
    }
    
    /*
    Description : Method used to update Agency departements options in resources form 
    */
    public void fillAgencyDepartment1() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillAgencyDepartment1=+=+=+=+=+=+=+=+=+============================');
    
      //   resource.selectedCountry = Oblix_UTils.CountrryGetId( resource.selectedCountry);
        resource.selectedCountry =  resource.selectedCountryName;
        newItem1.OblixCountry__c =  Oblix_UTils.CountrryGetId(resource.selectedCountry);
        //resource.agencyVisible = false;
        //resource.roleVisible = false;
        //resource.valVisible = false;
        //resource.resultVisible = false;
        //resource.addVisible = false;
    
        List < Oblix_Calculator__c > Agency_DepartmentNames = new List < Oblix_Calculator__c > ();
        system.debug('===========newItem.OblixCountry__c' + newItem.OblixCountry__c);
    
        Agency_DepartmentNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c from Oblix_Calculator__c where RecordTypeId = : rtCountry and Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__r.name like:  resource.selectedCountry];
        if (!Agency_DepartmentNames.isEmpty()){
             resource.selectedCountry = Agency_DepartmentNames[0].OblixCountry__c;
        }
        system.debug('============================zz=Agency_DepartmentNames' + Agency_DepartmentNames);
    
        map < String, String > Agency_DepartmentMap = new map < String, String > ();
        //Agency_DepartmentMap.put('', 'Agency Department');
        for (Oblix_Calculator__c c: Agency_DepartmentNames) {
            //    if (c.Agency_Department__c  !=null) //remplir automatiquement par la premiere valeur
            Agency_DepartmentMap.put(c.Agency_Department__c, c.Agency_Department__c);
        }
        AgencyDepartments1 = new List < SelectOption > ();
        if (!Agency_DepartmentMap.keyset().isEmpty()) {
            //resource.agencyVisible = true;
            //resource.selectedAgencyDepartment = null;
            for (String temp: Agency_DepartmentMap.keySet()) {
                if (activity.selectedAgencyDepartment == null) {activity.selectedAgencyDepartment = temp;}
                AgencyDepartments1.add(new SelectOption(temp, Agency_DepartmentMap.get(temp)));
            }
            AgencyDepartments1 = Oblix_Utils.selectOptionSortByLabel(AgencyDepartments1);
            AgencyDepartments1 = Oblix_Utils.setFirstValue('-Agency Department-', Oblix_Utils.selectOptionSortByLabel(AgencyDepartments1 ));
            
            resource.selectedAgencyDepartment = '';

        } //else add error (there is no to select) 
        //  fillRoleTitle();
    }
    
    
    /*
     * @Name : getCountry
     * @PAram : None
     *  @reference : CountriesByFYear(Fyea)
     * @return SelectOption of Countries
     
    public List < SelectOption > getCountry() {
        set < String > setCountry = new Set < String > ();
        setCountry = Oblix_Utils.CountriesByFYear(fYear);
        List < SelectOption > options = new List < SelectOption > ();
     //   options.add(new SelectOption('', 'Country'));
        if (setCountry != null && !setCountry.isEmpty()) {
            for (String country: setCountry) {
                if (country != null) {
                    options.add(new SelectOption(country, country));
                }
            }
        }
    
        return options;
    }
    */
    /*
     * @Name : fillCountries
     * @Param : None
     *  @reference : getCountry(), Oblix_Utils.selectOptionSortByLabel(countries)
     * @return void
     */
     
    /*
    Description : Method used to update Countries options in Activities and resources form 
    */
    public void fillCountries() {/*
        system.debug('============+=+=+=+=+=+=+=+=+= fillCountries =+=+=+=+=+=+=+=+=+============================');
        countries = getCountry();
        countries = Oblix_Utils.selectOptionSortByLabel(countries);
        countries = Oblix_Utils.setFirstValue('-Country-', Oblix_Utils.selectOptionSortByLabel(countries ));

        system.debug('###countries : '+countries);
        */
                
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
    
    /*
     * @Name : getsomme
     * @Param : None
     *  @reference : newITems
     * @return Decimal : Smme OItem FEE
     */
    public Integer getsomme() {
        Integer somme = 0;
        for (Marketing_Basics__c a: newitems) {
            somme += Integer.valueOf(a.OblixOtherItemFee__c);
        }
        return somme;//.setScale(0);
    }
    /*
     * @Name : back
     * @Param : None
     *  @reference : none
     * @return  : Page Reference
     */
    public pagereference back() {
        Pagereference meNewPage = Page.Oblix_VF10_nonCampaignView;
            meNewPage.getParameters().put('sowId', sowId);
            meNewPage.setRedirect(True);
        return meNewPage;
        return null;
    } 
    public pagereference backtoSow(){
     Pagereference meNewPage = Page.Oblix_VF06_SOWView;
            meNewPage.getParameters().put('sowId', sowId);
            meNewPage.setRedirect(True);
       return meNewPage;
    
    }
}