//******************************************************************************************************
//      THE CONTENT OF THIS CLASS HAS BEEN COMMENT OUT AS THIS CLASS IS NO LONGER USED
//      AS PART OF CODE REFACTORING, NEW CLASSES HAVE REPLACED THESE
//      S.M. 2016-03-30
//****************************************************************************************************** 

/**
    About
    -----
    Description: Class Oblix_Ctrl09_nonCampaignEdit
    Created for: OBLIX Project
    Create date: Nov 2, 2015
    Created by Achraf ELHITARY
    updated by  : Jrida 15 Nov 2015
    Details
    -------
    
       Update History
    --------------    
*/
    public with sharing class Oblix_Ctrl09_nonCampaignEdit{
    
        //public Oblix_wrapper_NonCamp myAct {get;set;} 
        //public Oblix_wrapper_NonCamp myRes {get;set;}
        
    
        //public User userConnected {get;set;}
        
        //public  id MSid  {get;set;}
        //public List<Marketing_Basics__c> newItems  {get;set;}
        //public boolean errMsg  {get;set;}
        //public boolean myMessages {get;set;}
        //public boolean errMsg1  {get;set;}
        //public boolean myMessages1 {get;set;}
        
        //public boolean   selectResource {get;set;}    //true to render a js code who trigger  resource tab                
        
        //public Boolean TitleEdit {get;set;}
        //public String MScurrency {get;set;}
        //public String saveStatus {get;set;}
        //Public Integer ElemToDel  {get;set;}     
        //Public Integer ElemToEdit  {get;set;}
        //Public boolean edit1{get;set;}
        //Public boolean edit2{get;set;}
        //   public List<SelectOption> countries {get;set;}
        
        //public List<SelectOption> AgencyDepartments{get;set;}
        //public List<SelectOption> RoleTitles{get;set;}
        
        //public List<SelectOption> AgencyDepartments1 {get;set;}
        //public List<SelectOption> RoleTitles1 {get;set;}
        
        
        //public  id rtActivity  {get;set;}
        //private id rtResource ;
        
        //private Marketing_SOW__c Marketing_SOW  ;
        //private Marketing_Basics__c newItem  ;
        //private  Marketing_Basics__c newItem1 ;
        //private List<Marketing_Basics__c > XItems ;
        
        
        
        
        
        //private  String fYear ;
        //private String agency ;
        
      
        
     
        
        //private id rtCountry ; 
        
        //private String marKObjName= System.Label.Oblix_Lbl_Marketing_Basics_c ;
        //private String ActivityName= System.Label.Oblix_Lbl_Activity;
        
        //private String noRole= System.Label.Oblix_Lbl_Role;
        
       
        //public Integer somme ;
        
        ///* Constructor
        // */
        //public Oblix_Ctrl09_nonCampaignEdit() {
        //    myAct = new Oblix_wrapper_NonCamp();
        //    myAct.clear();
        //    myRes = new Oblix_wrapper_NonCamp();
        //    myRes.clear();
        //    selectResource = false;
        //    TitleEdit = false;
        
        //    errMsg = false;
        //    myMessages = false;
        //    errMsg1 = false;
        //    myMessages1 = false;
        
        
        //    Id idUser = UserInfo.getUserId();
        //    userConnected = [Select Name from User where Id = : idUser];
        //    newItems = new List < Marketing_Basics__c > ();
        //    XItems = new List < Marketing_Basics__c > ();
        //    newItem = new Marketing_Basics__c();
        //    newItem1 = new Marketing_Basics__c();
        //     myAct.lookupActivity = new Marketing_Basics__c();
        //     myAct.lookupActivity.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get(ActivityName);
            
        //    MSid = ApexPAges.currentPage().getParameters().get('MSid');
        //    reRenderSOW();
        
        //    saveStatus = '';
        //    myAct = new Oblix_wrapper_NonCamp();
        //    myAct.agencyVisible = false;
        //    myAct.roleVisible = false;
        //    myAct.valVisible = false;
        //    //myAct.rateVisible =false;
        //    myAct.resultVisible = false;
        //    myAct.addVisible = false;
        
        //    ElemToEdit = -1;
        //    edit1 = false;
        //    edit2 = false;
        
        //    rtActivity = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get(ActivityName).getRecordTypeId();
        //    rtResource = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
        //    rtCountry = Schema.SObjectType.Oblix_Calculator__c.getRecordTypeInfosByName().get('Role Rate').getRecordTypeId();
        
        //    initialiseOptions();
        //    initialiseOptions1();
        
        
        //    id EditId = ApexPAges.currentPage().getParameters().get('itm');
        //    if (EditId != null) {
        //        TitleEdit = true;
        //        elemToEdit = 0;
        //        Marketing_Basics__c editItem = [select id, name, non_campaign_title__c, FTE__c, recordTypeId, OblixOtherItemFee__c, Agency_Department__c, Role_Title__c, Activities__c, Other_Activities__c, No_of_Hours_Required__c, OblixCountry__c, Oblix_SOWMarketing__c from Marketing_Basics__c where id = : EditId];
        //        MSid = editItem.Oblix_SOWMarketing__c;
        //        reRenderSOW();
        //        newItems.add(editItem);
        //        fillData(editItem);
        //    }
        
        //}
        ///*
        //*   @Description : Method used to fill all related Data : Country, Agency Department, Role, Record Id, Selected
        //*           Tab if it's edit mode.
        //*   @param : Non Campaign Item
        //*   @return: void
        //*/
        //private void fillData(Marketing_Basics__c eeditItem) {
        //   // MDO_Geography__c g;
        //    if (eeditItem.recordTypeId == rtActivity) {
        //        myAct.agencyVisible = true;
        //        myAct.roleVisible = true;
        //        myAct.valVisible = true;
        //        //myAct.rateVisible =true;
        //        myAct.resultVisible = true;
        //        myAct.addVisible = true;
        //        myAct.val = Integer.valueof(eeditItem.No_of_Hours_Required__c);
        
        //        fillCountries();
        //        //g = [select id, name from MDO_Geography__c where id = : eeditItem.OblixCountry__c];
        //        List<MDO_Geography__c> lstGeoTmp = [select id, name from MDO_Geography__c where id = : eeditItem.OblixCountry__c];
        //        if(!lstGeoTmp.isEmpty()){
        //             myAct.selectedCountryname = lstGeoTmp[0].name;
        //        }
        //        // myAct.selectedCountryname =  g.name ;   //.toUpperCase(); //'FRANCE' ;
        //        fillAgencyDepartment();
        //        myAct.selectedAgencyDepartment = eeditItem.Agency_Department__c;
        //        fillRoleTitle();
        //         myAct.selectedRoleTitle = eeditItem.Role_Title__c;
        //        fillRate();
        //        edit1 = true;
        
        //        myAct.name = eeditItem.name;
        //        //itemID = eeditItem.id;
        //         myAct.lookupActivity.Activities__c = eeditItem.Activities__c;
        //         myAct.lookupActivity.Other_Activities__c = eeditItem.Other_Activities__c;
        //        myAct.result = String.valueof(eeditItem.OblixOtherItemFee__c);
        // } else {
        //        selectResource = true;
        //        myRes.agencyVisible = true;
        //        myRes.roleVisible = true;
        //        myRes.valVisible = true;
        //        myRes.val = Integer.valueof(eeditItem.FTE__c);
        //        //myAct.rateVisible =true;
        //        myRes.resultVisible = true;
        //        myRes.addVisible = true;
        //        if(eeditItem.OblixCountry__c == null && myRes.selectedCountry != ''){
        //            eeditItem.OblixCountry__c =  myRes.selectedCountry;
        //        }
        //        system.debug('### myRes.selectedCountry : '+ myRes.selectedCountry);
        //        system.debug('###eeditItem : '+eeditItem);        
        //        fillCountries();
        //        system.debug('###eeditItem.OblixCountry__c : '+eeditItem.OblixCountry__c);   
        //       // g = [select id, name from MDO_Geography__c where id = : eeditItem.OblixCountry__c];
        //         List<MDO_Geography__c> lstGeoTmp1 = [select id, name from MDO_Geography__c where id = : eeditItem.OblixCountry__c];
        //        if(!lstGeoTmp1.isEmpty()){
        //             myRes.selectedCountryname = lstGeoTmp1[0].name;
        //        }
        //      //   myRes.selectedCountryname =   g.name ; //.toUpperCase(); //'FRANCE' ;
        //        fillAgencyDepartment1();
        //        myRes.selectedAgencyDepartment = eeditItem.Agency_Department__c;
        //        fillRoleTitle1();
        //         myRes.selectedRoleTitle = eeditItem.Role_Title__c;
        //        fillRate1();
        //        edit2 = true;
        //          myRes.name = eeditItem.name;
        //     //   itemID1 = eeditItem.id;
        //        myRes.result = String.valueof(eeditItem.OblixOtherItemFee__c);
        
        
        //    }
        //}
        
        ///*
        //*   @Description : Void Method used to initialise SelectOptions
        //*   @param : none
        //*   @return: void
        //*/
        //private void initialiseOptions() {
        //    AgencyDepartments = new List < SelectOption > ();
        //    AgencyDepartments.add(new SelectOption('', '-Agency Department-'));
        //    RoleTitles = new List < SelectOption > ();
        //    RoleTitles.add(new SelectOption('', noRole));
        //}
        ///*
        //*   @Description : Void Method used to initialise SelectOptions
        //*   @param : none
        //*   @return: void
        //*/
        //private void initialiseOptions1() {
        //    AgencyDepartments1 = new List < SelectOption > ();
        //    AgencyDepartments1.add(new SelectOption('', '-Agency Department-'));
        //    RoleTitles1 = new List < SelectOption > ();
        //    RoleTitles1.add(new SelectOption('', noRole));
        
        //}
        
        ///* Void Method used to initialise Marketing_SOW  
        // */
        //public void reRenderSOW() {
        
        //    if (MSid != null) {
        //        Marketing_SOW = [select id, Financial_Year__c, currency__c, Oblix_AgencyEstimate__c, Oblix_AgencyEstimate__r.Name from Marketing_SOW__c where id = : MSid];
        //        fYear = Marketing_SOW.Financial_Year__c;
        //        agency = Marketing_SOW.Oblix_AgencyEstimate__c;
        //        MScurrency = Marketing_SOW.currency__c;
        //        if (MScurrency =='EUR') {MScurrency = '€';  }
        //        fillCountries();
        //    }
        
        
        //}
      
        ///* Method used to save current List (upsert)
        // * @Void 
        // */
        //public pagereference saveList() {
        //    try {
        //        upsert newItems;
        //        delete Xitems;
        //        myMessages = false;
        //        myMessages1 = false;
        //    } catch (DmlException e) {
        //        System.debug('###Exception Occured :' + e.getMessage());
        //        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Error Occured during save please review data entry'));
        //        myMessages = true;
        //        myMessages1 = true;
        //    }
        
        
        //    Xitems = new List < Marketing_Basics__c > ();
        //    saveStatus = 'Saved';
        //    return null;
        //}
        
        // /*
        //Description : this action is called from button remove, its used to delete one item from the list  
        //*/
        //public void delElm() {
        //    if (newItems[elemToDel].id != null) {Xitems.add(newItems[elemToDel]);  }
        //    newItems.remove(elemToDel);
        //    saveStatus = 'Unsaved';
        //}
        
        // /*
        //Description : this action is called from button edit, its used to fill the form with correct values 
        //*/
        //public void editItem() {
        //    fillData(newItems[elemToEdit]);
        //}
        
        // /*
        //Description : used to update List of non campaigns Activities by Adding new item or update existing Item 
        //*/
        //public void addToNew() {
        //    saveStatus = 'Unsaved';
        //    myMessages = false;
            
        //    if (myAct.name == null || myAct.name == '') {
        //        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Name value is required.'));
        //        myMessages = true;
        //        return;
        //    }
            
        //    Id devRecordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get(ActivityName).getRecordTypeId();
        //    //recordtype
        //    if (edit1) { // c'est un update
        
        //        newItem = newItems[ElemToEdit];
        //    } else {
        //        newItem = new Marketing_Basics__c();
        //        newItem.Oblix_SOWMarketing__c = Marketing_SOW.id;
        //    }
        //    newItem.name = myAct.name;
        //    newItem.Activities__c =  myAct.lookupActivity.Activities__c;
        //    newItem.Other_Activities__c =  myAct.lookupActivity.Other_Activities__c;
        
        //    Map < String, String > abrev = Oblix_Utils.getAbreViationForCardAssets();
        //    string abr = abrev.get( myAct.lookupActivity.Activities__c);
        //    if (abr == null) {  abr = '';   }
        //    newItem.non_campaign_title__c = 'ACT-' + abr;
        //    // myAct.lookupActivity.Activities__c
        //    //    newItem.id =itemID ;
        //    newItem.recordTypeId = devRecordTypeId;
        
        //    newItem.No_of_Hours_Required__c = myAct.val;
        //    newItem.OblixCountry__c =  myAct.selectedCountry;
        //    newItem.Role_Title__c =  myAct.selectedRoleTitle;
        //    newItem.Agency_Department__c = myAct.selectedAgencyDepartment;
        //    calculResult();
        //    newItem.OblixOtherItemFee__c = Math.round(Decimal.valueof(myAct.result));//.setScale(0); // myAct.result =myAct.result.setScale(2);
        //    Marketing_Basics__c x = newItem;
        //    if (edit1) { // c'est un update
        //        newItems[ElemToEdit] = x;
        //        edit1 = false;
        
        //    } else {newItems.add(x);} // cest un ajout
        
        //    myAct.clear();
           
        
        //}
        
        ///*
        //Description : Method used to update List of non campaigns Resources by Adding new item or update existing Item 
        //*/
        //public void addToNew1() {
        //    saveStatus = 'Unsaved';
        //     myMessages1 = false;
             
        //    if (myRes.name == null || myRes.name == '') {
        //        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Name value is required.'));
        //        myMessages1 = true;
        //        return;
        //    }
           
        
        //    Id devRecordTypeId = rtResource ;// Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
        //    //recordtype
            
        //     if (edit2) { // c'est un update
        
        //        newItem1 = newItems[ElemToEdit];
        //    } else {
        //        newItem1 = new Marketing_Basics__c();
        //        newItem1.Oblix_SOWMarketing__c = Marketing_SOW.id;
        //    }
            
            
        
        //    newItem1.name = myRes.name;
        //    newItem1.non_campaign_title__c = myRes.name;
        //    newItem1.recordTypeId = devRecordTypeId;
        //  //  newItem1.Oblix_SOWMarketing__c = Marketing_SOW.id;
        //    newItem1.FTE__c = myRes.val;
        //    newItem1.OblixCountry__c =  myRes.selectedCountry;
        //    newItem1.Role_Title__c =  myRes.selectedRoleTitle;
        //   // newItem1.id = itemID1;
        //    newItem1.Agency_Department__c = myRes.selectedAgencyDepartment;
        //    calculResult1();
        // //   newItem1.OblixOtherItemFee__c = Integer.valueof(myRes.result);//.setScale(0); // result =result.setScale(2)
        //    newItem1.OblixOtherItemFee__c = Math.round(Decimal.valueof(myRes.result));//.setScale(0); // result =result.setScale(2)
         
        //    if (edit2) { // c'est un Edit
        //        newItems[ElemToEdit] = newItem1;
        //        edit2 = false;
        //    } else { newItems.add(newItem1);  }
        
        //    newItem1 = new Marketing_Basics__c();
        //    myRes.clear();
        //    myRes.name='';
        //}
        
        // /*
        //Description : Method used to calculate result for Activity 
        //*/
        //public void calculResult() {
        //    system.debug('============+=+=+=+=+=+=+=+=+= calculResult=+=+=+=+=+=+=+=+=+============================');
        //    myAct.result = String.valueof(Math.round(Decimal.valueof(myAct.Rate.trim()) * myAct.val));//.setScale(0));
        //    //  result =result;
        //}
        
        //  /*
        //Description : Method used to calculate result for Resource
        //*/
        //public void calculResult1() {
        //    system.debug('============+=+=+=+=+=+=+=+=+= calculResult1=+=+=+=+=+=+=+=+=+============================');
        //    myRes.result = String.valueof(Math.round(Decimal.valueof(myRes.Rate.trim()) * myRes.val / 100));//.setScale(0));
        //    //result1 =result1;       
        //}
        
        ///*
        //Description : Method used to update Rate options in Resource form 
        //*/
        //public void fillRate1() {
        //    system.debug('============+=+=+=+=+=+=+=+=+= fillrate1 =+=+=+=+=+=+=+=+=+============================');
        
        //    myRes.rateVisible = false;
        //    myRes.valVisible = false;
        //    myRes.resultVisible = false;
        //    myRes.addVisible = false;
        //    List < Oblix_Calculator__c > Rates = new List < Oblix_Calculator__c > ();
        //    //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        //    Rates = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c, FTE__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  myRes.selectedCountry and Agency_Department__c = : myRes.selectedAgencyDepartment and Role_Title__c = :  myRes.selectedRoleTitle];
        //    if (Rates.size() >= 1) {
        //        myRes.rateVisible = true;
        //        myRes.valVisible = true;
        //        myRes.resultVisible = true;
        //        myRes.addVisible = true;
        //        myRes.Rate = String.valueOf((Rates[0].FTE__c));//Integer.valueOf  Math.round
        //        myRes.RateRounded = String.valueOf( Math.round(Rates[0].FTE__c));//Integer.valueOf 
        //        errMsg1 = false;
        //    }
        ///*    if (Rates.size() > 1) {
        //        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning, 'There are duplicate records with the selected values'));
        //        errMsg1 = true;
        //    } */
        //    //else there is more than 1 or 0 => error 
        //}
        
        ///*
        //Description : Method used to update Rate options in Activities form 
        //*/
        //public void fillRate() {
        //    system.debug('============+=+=+=+=+=+=+=+=+= fillrate =+=+=+=+=+=+=+=+=+============================');
        
        //    //   if ( myAct.selectedRoleTitle ==noRole ||  myAct.selectedRoleTitle ==null){return ;}
        //    myAct.rateVisible = false;
        //    myAct.valVisible = false;
        //    myAct.resultVisible = false;
        //    myAct.addVisible = false;
        //    List < Oblix_Calculator__c > Rates = new List < Oblix_Calculator__c > ();
        //    //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        //    Rates = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c, Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  myAct.selectedCountry and Agency_Department__c = : myAct.selectedAgencyDepartment and Role_Title__c = :  myAct.selectedRoleTitle];
        //    if (Rates.size() >= 1) {
        //        myAct.rateVisible = true;
        //        myAct.valVisible = true;
        //        myAct.resultVisible = true;
        //        myAct.addVisible = true;
        //        myAct.Rate = String.valueOf((Rates[0].Role_Daily_Rate_EUR__c));//Math.round
        //        myAct.RateRounded = String.valueOf(Math.round(Rates[0].Role_Daily_Rate_EUR__c));//
        //        errMsg = false;
        //    }
        //   /*  if (Rates.size() > 1) {
        //       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning, 'There are duplicate records with the selected values'));
        //        errMsg = true;
        //    } */
        //    //else there is more than 1 or 0 => error 
        //}
        
        // /*
        //Description : Method used to update roleTatle options in Activities form 
        //*/
        //public void fillRoleTitle() {
        //    system.debug('============+=+=+=+=+=+=+=+=+= fillRoleTitle=+=+=+=+=+=+=+=+=+============================');
        //    System.DEBUG(' fYear ' + fYear);
        //System.DEBUG(' agency ' + agency);
        //System.DEBUG(' activity.selectedCountry ' + myAct.selectedCountry);
        //System.DEBUG(' activity.selectedAgencyDepartment ' + myAct.selectedAgencyDepartment);

        
        //    //   if (myAct.selectedAgencyDepartment=='' || myAct.selectedAgencyDepartment==null){return ;}
        //    myAct.roleVisible = false;
        //    //   myAct.rateVisible =false;
        //    myAct.valVisible = false;
        //    myAct.resultVisible = false;
        //    myAct.addVisible = false;
        //    List < Oblix_Calculator__c > RoleTitleNames = new List < Oblix_Calculator__c > ();
        //    //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        //    RoleTitleNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  myAct.selectedCountry and Agency_Department__c = : myAct.selectedAgencyDepartment];
        //    map < String, String > RoleTitleNamesMap = new map < String, String > ();
        //    for (Oblix_Calculator__c c: RoleTitleNames) {
        //        if (c.Role_Title__c != null)
        //            { RoleTitleNamesMap.put(c.Role_Title__c, c.Role_Title__c); }
        //    } 
        //    RoleTitles = new List < SelectOption > ();
        //    if (!RoleTitleNamesMap.keyset().isEmpty() ) {
        //        myAct.roleVisible = true;
        //         myAct.selectedRoleTitle = null;
        //        for (String temp: RoleTitleNamesMap.keySet()) {
        //            // if ( myAct.selectedRoleTitle==null)  myAct.selectedRoleTitle= temp; //remplir automatiquement par la premiere valeur
        //            RoleTitles.add(new SelectOption(temp, RoleTitleNamesMap.get(temp)));
        //        }
        //        RoleTitles = Oblix_Utils.selectOptionSortByLabel(RoleTitles);
        //        // RoleTitles.add(new SelectOption('', noRole));
        //        RoleTitles= Oblix_Utils.setFirstValue(noRole, Oblix_Utils.selectOptionSortByLabel(RoleTitles));
        //         myAct.selectedRoleTitle = '';
        //        //else add error (there is no rt to select)
        //    }
        //}
     
        ///*
        //Description : Method used to update roleTatle options in resource form 
        //*/
        //public void fillRoleTitle1() {
        
        //    system.debug('============+=+=+=+=+=+=+=+=+= fillRoleTitle1=+=+=+=+=+=+=+=+=+============================');
        
        //    myRes.roleVisible = false;
        //    //   myRes.rateVisible =false;
        //    myRes.valVisible = false;
        //    myRes.resultVisible = false;
        //    myRes.addVisible = false;
        //    List < Oblix_Calculator__c > RoleTitleNames = new List < Oblix_Calculator__c > ();
        //    //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        //    RoleTitleNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c from Oblix_Calculator__c where Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__c = :  myRes.selectedCountry and Agency_Department__c = : myRes.selectedAgencyDepartment];
        //    map < String, String > RoleTitleNamesMap = new map < String, String > ();
        //    for (Oblix_Calculator__c c: RoleTitleNames) {
        //        if (c.Role_Title__c != null)
        //          {  RoleTitleNamesMap.put(c.Role_Title__c, c.Role_Title__c); }
        //    }
        //    RoleTitles1 = new List < SelectOption > ();
         
        //    if (!RoleTitleNamesMap.keyset().isEmpty()) {
        //        myRes.roleVisible = true;
        //         myRes.selectedRoleTitle = null;
        //        for (String temp: RoleTitleNamesMap.keySet()) {
        //            // if ( myAct.selectedRoleTitle==null)  myAct.selectedRoleTitle= temp; //remplir automatiquement par la premiere valeur
        //            RoleTitles1.add(new SelectOption(temp, RoleTitleNamesMap.get(temp)));
        //        }
        
        //        RoleTitles1 = Oblix_Utils.selectOptionSortByLabel(RoleTitles1);
        //         //  RoleTitles1.add(new SelectOption('', noRole));
        //        RoleTitles1= Oblix_Utils.setFirstValue(noRole, Oblix_Utils.selectOptionSortByLabel(RoleTitles1));
                 
        //         myRes.selectedRoleTitle = '';
        //        //else add error (there is no rt to select)
        //    }
        //}
        
        ///*
        //Description : Method used to update Agency departements options in Activities form 
        //*/
        //public void fillAgencyDepartment() {
        //    system.debug('============+=+=+=+=+=+=+=+=+= fillAgencyDepartment=+=+=+=+=+=+=+=+=+============================');
        //    RoleTitles = new List < SelectOption > ();
        //    RoleTitles.add(new SelectOption('', noRole));
        //     myAct.selectedRoleTitle = '';
        
        //   // myAct.selectedCountry = Oblix_UTils.CountrryGetId( myAct.selectedCountryname);
        //    myAct.selectedCountry =  myAct.selectedCountryname;            
        //    myAct.agencyVisible = false;
        //    myAct.roleVisible = false;
        //    myAct.rateVisible = false;
        //    myAct.valVisible = false;
        //    myAct.resultVisible = false;
        //    myAct.addVisible = false;
        
        
        //    //newItem.OblixCountry__c =  myAct.selectedCountry;
        
        //    List < Oblix_Calculator__c > Agency_DepartmentNames = new List < Oblix_Calculator__c > ();
        //    system.debug('===========newItem.OblixCountry__c' + newItem.OblixCountry__c);
        //    //  Agency_DepartmentNames=[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c  from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__r.name=: myAct.selectedCountryname];
        //    Agency_DepartmentNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c from Oblix_Calculator__c where RecordTypeId = : rtCountry and Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__r.name like:  myAct.selectedCountryname];
        //    if (!Agency_DepartmentNames.isEmpty() ){
        //         myAct.selectedCountry = Agency_DepartmentNames[0].OblixCountry__c;
        //         }
        //    map < String, String > Agency_DepartmentMap = new map < String, String > ();
        //   // Agency_DepartmentMap.put('', 'Agency Department');
        //    for (Oblix_Calculator__c c: Agency_DepartmentNames) {
        //        Agency_DepartmentMap.put(c.Agency_Department__c, c.Agency_Department__c);
        //    }
        //    AgencyDepartments = new List < SelectOption > ();
        //    if (!Agency_DepartmentMap.keyset().isEmpty() ) {
        //        myAct.agencyVisible = true;
        //        myAct.selectedAgencyDepartment = null;
        //        for (String temp: Agency_DepartmentMap.keySet()) {
        //            if (myAct.selectedAgencyDepartment == null) {myAct.selectedAgencyDepartment = temp;}
        //            AgencyDepartments.add(new SelectOption(temp, Agency_DepartmentMap.get(temp)));
        //        }
        //        AgencyDepartments = Oblix_Utils.selectOptionSortByLabel(AgencyDepartments);
        //        AgencyDepartments = Oblix_Utils.setFirstValue('-Agency Department-', Oblix_Utils.selectOptionSortByLabel(AgencyDepartments ));

        //        myAct.selectedAgencyDepartment = '';
                                
        //        //else add error (there is no to select)
        //    } else {
        //        myAct.agencyVisible = false;
        //        myAct.roleVisible = false;
        //        //myAct.rateVisible =false;
        //        myAct.valVisible = false;
        //        myAct.resultVisible = false;
        //        myAct.addVisible = false;
        //    }
        
        //}
        
        ///*
        //Description : Method used to update Agency departements options in resources form 
        //*/
        //public void fillAgencyDepartment1() {
        //    system.debug('============+=+=+=+=+=+=+=+=+= fillAgencyDepartment1=+=+=+=+=+=+=+=+=+============================');
        
        //  //   myRes.selectedCountry = Oblix_UTils.CountrryGetId( myRes.selectedCountryname);
        //    myRes.selectedCountry =  myRes.selectedCountryname;
        //    newItem1.OblixCountry__c =  Oblix_UTils.CountrryGetId(myRes.selectedCountry);
        //    myRes.agencyVisible = false;
        //    myRes.roleVisible = false;
        //    myRes.valVisible = false;
        //    myRes.resultVisible = false;
        //    myRes.addVisible = false;
        
        //    List < Oblix_Calculator__c > Agency_DepartmentNames = new List < Oblix_Calculator__c > ();
        //    system.debug('===========newItem.OblixCountry__c' + newItem.OblixCountry__c);
        
        //    Agency_DepartmentNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c from Oblix_Calculator__c where RecordTypeId = : rtCountry and Financial_Year__c = : fYear and Oblix_Agency__c = : agency and OblixCountry__r.name like:  myRes.selectedCountryname];
        //    if (!Agency_DepartmentNames.isEmpty()){
        //         myRes.selectedCountry = Agency_DepartmentNames[0].OblixCountry__c;
        //    }
        //    system.debug('============================zz=Agency_DepartmentNames' + Agency_DepartmentNames);
        
        //    map < String, String > Agency_DepartmentMap = new map < String, String > ();
        //    //Agency_DepartmentMap.put('', 'Agency Department');
        //    for (Oblix_Calculator__c c: Agency_DepartmentNames) {
        //        //    if (c.Agency_Department__c  !=null) //remplir automatiquement par la premiere valeur
        //        Agency_DepartmentMap.put(c.Agency_Department__c, c.Agency_Department__c);
        //    }
        //    AgencyDepartments1 = new List < SelectOption > ();
        //    if (!Agency_DepartmentMap.keyset().isEmpty()) {
        //        myRes.agencyVisible = true;
        //        myRes.selectedAgencyDepartment = null;
        //        for (String temp: Agency_DepartmentMap.keySet()) {
        //            if (myAct.selectedAgencyDepartment == null) {myAct.selectedAgencyDepartment = temp;}
        //            AgencyDepartments1.add(new SelectOption(temp, Agency_DepartmentMap.get(temp)));
        //        }
        //        AgencyDepartments1 = Oblix_Utils.selectOptionSortByLabel(AgencyDepartments1);
        //        AgencyDepartments1 = Oblix_Utils.setFirstValue('-Agency Department-', Oblix_Utils.selectOptionSortByLabel(AgencyDepartments1 ));
                
        //        myRes.selectedAgencyDepartment = '';

        //    } //else add error (there is no to select) 
        //    //  fillRoleTitle();
        //}
        
        
        ///*
        // * @Name : getCountry
        // * @PAram : None
        // *  @reference : CountriesByFYear(Fyea)
        // * @return SelectOption of Countries
         
        //public List < SelectOption > getCountry() {
        //    set < String > setCountry = new Set < String > ();
        //    setCountry = Oblix_Utils.CountriesByFYear(fYear);
        //    List < SelectOption > options = new List < SelectOption > ();
        // //   options.add(new SelectOption('', 'Country'));
        //    if (setCountry != null && !setCountry.isEmpty()) {
        //        for (String country: setCountry) {
        //            if (country != null) {
        //                options.add(new SelectOption(country, country));
        //            }
        //        }
        //    }
        
        //    return options;
        //}
        //*/
        ///*
        // * @Name : fillCountries
        // * @Param : None
        // *  @reference : getCountry(), Oblix_Utils.selectOptionSortByLabel(countries)
        // * @return void
        // */
         
        ///*
        //Description : Method used to update Countries options in Activities and resources form 
        //*/
        //public void fillCountries() {/*
        //    system.debug('============+=+=+=+=+=+=+=+=+= fillCountries =+=+=+=+=+=+=+=+=+============================');
        //    countries = getCountry();
        //    countries = Oblix_Utils.selectOptionSortByLabel(countries);
        //    countries = Oblix_Utils.setFirstValue('-Country-', Oblix_Utils.selectOptionSortByLabel(countries ));

        //    system.debug('###countries : '+countries);
        //    */
            
        //    List <Oblix_Calculator__c> countriesNames = new List <Oblix_Calculator__c>();
        //    countriesNames =[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency ];
        //    map<String,String>  countriesMap =new map<String,String> () ;
        //    for (Oblix_Calculator__c c: countriesNames ){
        //        if (c.OblixCountry__c !=null)
        //           { countriesMAp.put(c.OblixCountry__r.name ,c.OblixCountry__r.name );  }
        //    }
        //    countries = new List<SelectOption>();
           
        //    if( !countriesMap.isEmpty()){
        //        for (String cID: countriesMap.keySet()){
        //            //if (selectedCountry ==null) {       selectedCountry = cid;  //fill the selectOption  //remplir automatiquement par la premiere valeur
        //            //        newItem.OblixCountry__c = cid;  } //fill the lookup
                                               
        //            countries.add(new SelectOption(cID,countriesMap.get(cID)));
        //        }
        //    //else add error (there is no country to select)
                
        //    }
        //  countries = Oblix_Utils.selectOptionSortByLabel(countries);
        //  countries = Oblix_Utils.setFirstValue('-Country-', Oblix_Utils.selectOptionSortByLabel(countries ));
        //  system.debug('###countries : '+countries);
            
            
        //}
        
        ///*
        // * @Name : getsomme
        // * @Param : None
        // *  @reference : newITems
        // * @return Decimal : Smme OItem FEE
        // */
        //public Integer getsomme() {
        //    Integer somme = 0;
        //    for (Marketing_Basics__c a: newitems) {
        //        somme += Integer.valueOf(a.OblixOtherItemFee__c);
        //    }
        //    return somme;//.setScale(0);
        //}
        ///*
        // * @Name : back
        // * @Param : None
        // *  @reference : none
        // * @return  : Page Reference
        // */
        //public pagereference back() {
        //    Pagereference meNewPage = Page.Oblix_VF10_nonCampaignView;
        //        meNewPage.getParameters().put('MSid', MSid);
        //        meNewPage.setRedirect(True);
        //    return meNewPage;
        //    return null;
        //} 
        //public pagereference backtoSow(){
        // Pagereference meNewPage = Page.Oblix_VF06_SOWView;
        //        meNewPage.getParameters().put('sowId', MSid);
        //        meNewPage.setRedirect(True);
        //   return meNewPage;
        
        //}
    }