/**
    About
    -----
    Description: Class Oblix_Ctrl07ProjectEdit_CC
    Created for: OBLIX Project
    Create date: Oct 23, 2015
    Created by Asmae ESSBAI
    Author : @Asmae
    Details
    -------

       Update History
    --------------
*/
public with sharing class Oblix_Ctrl07ProjectEdit_CC {

    public boolean v1 {get; set;} // to show Correct check on buttons V
    public boolean v2 {get; set;}
    public boolean v3 {get; set;}
    public boolean v4 {get; set;}
    public boolean v5 {get; set;}
    public id projectId {get; set;}
    public list<Oblix_Project_Assets__c> lstAssets {get; set;}
    public boolean isEdit {get; set;}
    public User userConnected {get; set;}
    public Oblix_SOW_Projects__c project {get; set;}
    public set<string> setRecordType  {get; set;}
    public map<string, list<Oblix_Project_Assets__c>> mapRTAssets {get; set;}

    public map<string, string> mapRTIdCSS {get; set;}
    public map<string, string> mapStageIdCSS {get; set;}
    public string setIdCss {get; set;}
    public string recordType {get; set;}
    public string subCat {get; set;}
    public string complexity {get; set;}
    public list<Oblix_Project_Assets__c> lstAssetsForCard {get; set;}
    //public map<string,Oblix_Project_Assets__c> mapRTSUBCatAsset {get;set;}
    public map<string, list<string>> mapRTSUBCat {get; set;}
    public list<RecordType> recordTypes {get; set;}
    public list<string> lstRecordType {get; set;}
    //public list<Decimal> lstAES {get;set;}

    public integer mynumber {get; set;}
    public list<string> lstStage {get; set;}
    public Map<String, list<String>> mapRelatedCntries {get; set;}
    public Map<String, String> mapRegionCntries {get; set;}
    public Oblix_Project_Assets__c  assetInstance  {get; set;}
    public String lstAjaxCountries {get; set;}
    public set<string> lstRegion {get; set;}
    public map<string, ID> mapIdCSSCountryRegion {get; set;}
    public string lstIdCSSSelected {get; set;}
    public List<Oblix_Marketing_SOW_Project_Splits__c> lstProjectSplitHubs {get; set;}
    private list<string> lstSelectedRegion ;
    public Oblix_Marketing_SOW_Project_Splits__c agencySplitInstanceJS {get; set;}
    public map<string, integer> feePercentages {get; set;}
    public map<string, string> mapScoreDesc {get; set;}
    public set<string> lstNameCountries {get; set;}
    public Oblix_Marketing_SOW_Project_Splits__c  split {get; set;}
    public list<Oblix_Marketing_SOW_Project_Splits__c> splitToInsert {get; set;}
    public list<Oblix_Marketing_SOW_Project_Splits__c> splitToUpdate {get; set;}
    public list<Oblix_Marketing_SOW_Project_Splits__c> splitToDelete {get; set;}
    public string idSplit {get; set;}
    public integer counterAsset {get; set;}
    public map<string, list<string>> mapSubCategOption {get; set;}
    public map<string, string> mapSubCategOptionDescription {get; set;}
    public map<string, string> mapSubCategOptionDefinition {get; set;}
    public map<string, string> mapRecordTypeDescription {get; set;}
    public Set<Oblix_Project_Assets__c> ClearList {get; set;}
    // the select option for the picklist Country ( Agency Hub )
    public String selectedCountry {get; set;}
    public List<SelectOption> countryOptions {get; set;}
    public map<string, string> mapIdCountries {get; set;}
    public string listItems {get; set;}

    public decimal estimateCost {get; set;}
    public string lstSubCategory {get; set;}
    public map<string, Oblix_Project_Assets__c> mapAssetsPerSubCat {get; set;}
    public map<string, string> mapRTforSubCat {get; set;}
    public map<string, string> mapAbreviation {get; set;}
    public List<SelectOption> innovationOptions {get; set;}
    public List<SelectOption> brandOptions {get; set;}

    //Can Adjust Boolean
    public Boolean canAdjust {get; set;}

    public String selectedBrandInnov {get; set;}
    public String selectedBrandBrand {get; set;}
    public boolean isError {get; set;}
    private static string crossX = ' X ';
    
    
    public Oblix_Ctrl07ProjectEdit_CC() {
        system.debug('================================================= im the controller here ===');
       
        v1 = false;
        v2 = false;
        v3 = false;
        v4 = false;
        v5 = false;
        Id idUser = UserInfo.getUserId();
        userConnected = [Select Name from User where Id = : idUser ];
        lstStage = new list<string>();
        setRecordType  = new set<string>();
        mapRegionCntries = new Map<String, String>();
        setIdCss = '[]';
        isError = false;
        listItems = '';
        //Brand_Led_Growth = '';
        selectedBrandInnov = '';
        selectedBrandBrand = '';
        mapAbreviation = Oblix_Utils.getAbreViationForCardAssets();
        counterAsset = 0;
        estimateCost = 0;
        lstSubCategory = '';
        lstIdCSSSelected = '';
        lstAjaxCountries = '';
        mapIdCountries = new map<string, string>();
        mapSubCategOption = new map<string, list<string>>();
        mapSubCategOptionDescription = new map<string, string>();
        mapSubCategOptionDefinition = new map<string, string>();
        mapRecordTypeDescription = new map<string, string>();
        splitToInsert = new list<Oblix_Marketing_SOW_Project_Splits__c>();
        splitToUpdate = new list<Oblix_Marketing_SOW_Project_Splits__c>();
        splitToDelete = new list<Oblix_Marketing_SOW_Project_Splits__c>();    
        split = new Oblix_Marketing_SOW_Project_Splits__c();
        lstNameCountries = new set<string>();
        lstSelectedRegion = new list<string>();
        mapScoreDesc = new map<string, string>();
        agencySplitInstanceJS = new Oblix_Marketing_SOW_Project_Splits__c();
        feePercentages = new map<string, integer>();
        mapIdCSSCountryRegion = new map<string, ID>();
        mapRelatedCntries = new Map<String, list<String>>();
        lstRecordType = new list<string>();
        //lstAES = new list<Decimal>();
        lstAssetsForCard = new list<Oblix_Project_Assets__c>();
        if (projectId == null) { isEdit = false; }
        if (projectId != null) { isEdit = true;  }
        //mapRTSUBCatAsset = new map<string,Oblix_Project_Assets__c>();
        lstAssets = new list<Oblix_Project_Assets__c>();
        mapRTAssets = new map<string, list<Oblix_Project_Assets__c>>();
        mapRTIdCSS = new map<string, string>();
        mapStageIdCSS = new map<string, string>();
        mapRTSUBCat = new map<string, list<string>>();
        assetInstance = new Oblix_Project_Assets__c();
        mapAssetsPerSubCat = new map<string, Oblix_Project_Assets__c>();
        mapRTforSubCat = new map<string, string>();
        lstRegion = new set<string>();
        mynumber = 6;
        init();
        getCountriesOptions();
        getValueDriversOptions();
        getAgencyHubFiveInsance();
        VerifyChecks();
        
    }
    
    
    private void verifyTimeLine(){
        if ((project.Project_Start_Date__c ==null ) && (project.BET_first_release__c  ==null ) && ( project.Final_release__c ==null ) && (project.Project_Completion_Date__c ==null) && (project.Date_for_Assets_to_be_in_BET__c  ==null ) && (project.Live_Date__c ==null ) && (project.First_Air_Date__c ==null ) && (project.Preview_Date__c ==null ) && (project.Live_date_Asset_delivery__c ==null ) && (project.Production_Completion_Date__c ==null ) && (project.Start_of_TV_production__c  ==null ) &&( project.Timescale_Notes__c == null || project.Timescale_Notes__c == '')&& (project.Project_Priority__c==null || project.Project_Priority__c==''))  {v1=false; } else  {v1=true;}
    }
    private void verifyCountryRegion(){
        if(project.OblixRegion__c==null || project.OblixRegion__c=='' ) {v2=false; } else  {v2=true;}
    }
    private void verifyValueDriver(){
        if((project.Brand_Led_Growth__c ==null || project.Brand_Led_Growth__c =='') && (project.Campaign_Idea__c ==null || project.Campaign_Idea__c =='') && (project.Project_Scale_1__c ==null || project.Project_Scale_1__c =='') && (project.Project_Scale_2__c==null || project.Project_Scale_2__c==''  ) && (selectedBrandInnov==null || selectedBrandInnov=='')&& (selectedBrandBrand==null || selectedBrandBrand=='')) {v4=false; } else  {v4=true;}
    }
    private void verifyStageChecks(){
        if((project.Projected_Stage__c  ==null || project.Projected_Stage__c  =='') && (project.Completed_Stage__c==null || project.Completed_Stage__c=='' )) {v5=false; } else  {v5=true;}
    }
     /*
     *   @Description : this method set v1 v2 v4 v5 true or false , to display the correct check mark valuesButton.
     */
    public void VerifyChecks(){
    
         verifyTimeLine();
         verifyCountryRegion();
        //V3 is  checked from setInfoSplitHub and getAgencyHubFiveInsance
        verifyValueDriver();
        verifyStageChecks();
        
    }
    /*
     *   @Description : this method allows only UL1, SuperUser, Sys Admin, to adjust Fees and view the Adjust Fee Button.
     */
    public void isAllowedToAdjustFee() {
        Id adminProfileId = [Select Id, Name from Profile where Name = 'System Administrator'].Id;
        List<PermissionSetAssignment> lstperrmissions = [Select Id, AssigneeId, PermissionSetId, PermissionSet.Name from PermissionSetAssignment where AssigneeId = : Userinfo.getUserId()];
        system.debug('##lstperrmissions :' + lstperrmissions);
        if (Userinfo.getProfileId() == adminProfileId) {
            canAdjust = true;
        }
        if (!lstperrmissions.isEmpty()) {
            for (PermissionSetAssignment permission : lstperrmissions) {
                system.debug('##permission Name :' + permission.PermissionSet.Name);
                if (permission.PermissionSet.Name == 'Oblix_SWOP_UL_1_V1' || permission.PermissionSet.Name == 'Oblix_SWOP_Super_User_V1') {
                    canAdjust = true;
                    break;
                }
            }
        }
    }
    
     /*
     *   @Description : this method used to initialize form values in VF 
     */
    public void init() {
        projectId = ApexPAges.currentPage().getParameters().get('projectId');
        isAllowedToAdjustFee();
        getErrorClone();
        getMapCountries();
        mapSubCategOption = Oblix_Utils.getMapSubCategOption();
        mapSubCategOptionDescription = Oblix_Utils.getMapSubCategOptionDescription();
        mapRecordTypeDescription = Oblix_Utils.getMapRecordTypeDescription();
        mapSubCategOptionDefinition = Oblix_Utils.getMapSubCategOptionDefinition();
        // Stages part
        lstStage = Oblix_Utils.getStageList();
        feePercentages = Oblix_Utils.getFeePercentages(lstStage);
        for (string stage : lstStage) {
            mapStageIdCSS.put(stage, stage.replaceAll(' & ', '_').replaceAll(' ', '_'));
        }
        // end stage
        if (projectId == null) {
            project = new Oblix_SOW_Projects__c ();
            project.Financial_Year__c = ApexPAges.currentPage().getParameters().get('sowId');
        } else {
            project = [Select Id, Name, Innovation_Projects__c , ProjectTotalAssetscore__c, Jobs_to_be_Done__c , Campaign_Fees_Total__c, Completed_Stage__c, Financial_Year__r.currency__c, Projected_Stage__c, Financial_Year__r.Financial_Year__c, BET_first_release__c, Value_to_be_paid_in_Current_FY__c, Campaign_Status__c, Preview_Date__c, Start_of_TV_production__c, Final_release__c, Live_Date__c, Live_date_Asset_delivery__c, Date_for_Assets_to_be_in_BET__c, Timescale_Notes__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c, Project_Finish_Date__c, Project_Stage__c, Platform__c, CreatedById, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, Campaign_Countries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id = :projectId];
            estimateCost = project.Campaign_Fees_Total__c;
            getAssetCampaign();
            getRecordTypesInfo();
            if (project.Campaign_Countries__c != null) {
                lstSelectedRegion = project.Campaign_Countries__c.split(',');
            }
            if (project.OblixRegion__c != null) {
                lstSelectedRegion.addAll(project.OblixRegion__c.split(','));
            }

            system.debug('### mapIdCSSCountryRegion :' + mapIdCSSCountryRegion);

            for (string slctedRegionOrCountry : lstSelectedRegion) {
                lstIdCSSSelected = lstIdCSSSelected + mapIdCSSCountryRegion.get(slctedRegionOrCountry) + ',';
            }
            if (project.Innovation_Projects__c != null) {
                lstIdCSSSelected = lstIdCSSSelected + project.Innovation_Projects__c.replaceAll(' ', '_') + ',';
            }
            // add the stage checkbox
            lstIdCSSSelected = lstIdCSSSelected + Oblix_Utils.getSelectedStageCheckbox(project.Projected_Stage__c, project.Completed_Stage__c);
            lstIdCSSSelected = lstIdCSSSelected.removeEnd(',');
            system.debug('### lstIdCSSSelected :' + lstIdCSSSelected);

            for (string subCat : Oblix_Utils.getlstSubCat()) {
                lstSubCategory  = lstSubCategory  + subCat.replaceAll('/', '_').replaceAll('-', '__') + ',';
                mapAssetsPerSubCat.put(subCat, new Oblix_Project_Assets__c(Sub_Category__c = subCat, recordTypeId = mapRTforSubCat.get(subCat)));
            }
            lstSubCategory  = lstSubCategory.removeEnd(',');
            //getScoreDescription();

        }
        if (project.Brand_Led_Growth__c != null && project.Brand_Led_Growth__c.contains('€')) {
            system.debug('###project.Brand_Led_Growth__c l194 : ' + project.Brand_Led_Growth__c);
            selectedBrandBrand = project.Brand_Led_Growth__c;
        } else {
            system.debug('###project.Brand_Led_Growth__c l196 : ' + project.Brand_Led_Growth__c);
            selectedBrandInnov = project.Brand_Led_Growth__c;
        }
    }
    @TestVisible
    private void getErrorClone() {
        String errorClone = '';
        if (ApexPAges.currentPage().getParameters().get('isClone') != null && ApexPAges.currentPage().getParameters().get('isClone') == '1') {
            errorClone = 'Campaign Name need to be changed while cloning';
        }
        if (ApexPAges.currentPage().getParameters().get('duplicateValue') != null && ApexPAges.currentPage().getParameters().get('duplicateValue') == '1') {
            if (errorClone != '') { errorClone += ', ';}
            errorClone += 'Duplicate Value Found with the same Name ';
        }
        if (errorClone != null && errorClone != '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning, errorClone));
        }
    }
    @TestVisible
    private void getRecordTypesInfo() {
        recordTypes = [SELECT Name FROM RecordType WHERE sObjectType = 'Oblix_Project_Assets__c' and name != 'Admin' Order by name];
        for (recordType rec : recordTypes) {
            lstRecordType.add(rec.name);
            setRecordType.add(rec.Name);
            if (mapRTIdCSS.get(rec.Name) == null) {
                mapRTIdCSS.put(rec.Name, (rec.Name).replaceAll(' ', ''));
            }

        }
        setIdCss = '';
        for (string x : setRecordType) {
            setIdCss = setIdCss + '"' + x.replaceAll(' ', '') + '",';
        }
        setIdCss = '[' + setIdCss.removeEnd(',') + ']';
        for (string rec : lstRecordType) {
            if (mapRTAssets.get(rec) == null ) {mapRTAssets.put(rec, new list<Oblix_Project_Assets__c>());}
            if (mapRTIdCSS.get(rec) == null ) {mapRTIdCSS.put(rec, (rec).replaceAll(' ', ''));}
            mapRTSUBCat.put(rec, Oblix_Utils.lstSubCatPerRecT(rec));

        }
    }
    @TestVisible
    private void getAssetCampaign() {
        list<Oblix_Project_Assets__c> lstAsset = [select Id, Agency_Projects__r.id, Channels__c, RecordType.Name, Quantity__c , Asset_Picklist__c, Asset_Title__c , Name, RecordTypeId, Sub_Category__c, FULL_Description__c, FULL_Description__r.name from Oblix_Project_Assets__c where Agency_Projects__r.id = :project.id  limit 1000];
        for (Oblix_Project_Assets__c asse : lstAsset) {
            if (asse.FULL_Description__c != null) {
                asse.Asset_Title__c = asse.Quantity__c + crossX + mapAbreviation.get('' + asse.RecordType.Name) + '-' + mapAbreviation.get('' + asse.Sub_Category__c) + '-' + '0' + asse.FULL_Description__r.name.remove('Score ').remove('Full ').remove('Lite ');
            }
            if (asse.Asset_Title__c != null) {
                asse.Asset_Title__c = asse.Asset_Title__c.replaceAll('null', '');
            }
        }
        lstAssetsForCard.addAll(lstAsset);
        if (!lstAsset.isEmpty()) {
            for (Oblix_Project_Assets__c asset : lstAsset) {
                if (!(mapRTAssets).containsKey(asset.RecordType.Name)) { mapRTAssets.put(asset.RecordType.Name, new list<Oblix_Project_Assets__c>()); }
                mapRTAssets.get(asset.RecordType.Name).add(asset);
                mapRTforSubCat.put(asset.Sub_Category__c, asset.RecordTypeId);

            }
        }
    }
    @TestVisible
    private void getAgencyHubFiveInsance() {
        if (projectId != null) {
            lstProjectSplitHubs = [Select Id, Name, OblixCountry__c, Project_Splits__c, OblixCountry__r.name, Percentage__c from Oblix_Marketing_SOW_Project_Splits__c where Project_Splits__c = : projectId];
            System.debug('###lstProjectSplitHubs after sasve :'+lstProjectSplitHubs );
            if (!lstProjectSplitHubs.isEmpty() ) { v3 = true;}
        } else {
            lstProjectSplitHubs = new list<Oblix_Marketing_SOW_Project_Splits__c>();
        }
        if (lstProjectSplitHubs.size() < 5) {
            counterAsset = 5;
        } else {
            counterAsset = lstProjectSplitHubs.size();
        }
        for (integer i = 0; i < 5; i++) {
            if (lstProjectSplitHubs.size() < 5 || lstProjectSplitHubs.isEmpty()) {
                Oblix_Marketing_SOW_Project_Splits__c FiveAgencySplitInstance = new Oblix_Marketing_SOW_Project_Splits__c();
                FiveAgencySplitInstance.Project_Splits__c = projectId;               
                lstProjectSplitHubs.add(FiveAgencySplitInstance);
            }
        }
    }

    @TestVisible
    private void getMapCountries() {
        list<MDO_Geography__c> lstCountries = [Select m.parent_L6__c, m.parent_L5__c, m.parent_L4__c, m.parent_L3__c, m.parent_L2__c,
                                               m.parent_L1__c, m.geography_type__c, m.Name, m.Id, parent_L5__r.Name From MDO_Geography__c m where geography_type__c Like 'Country%' order by name
                                              ];
        for (MDO_Geography__c country : lstCountries) {
            lstRegion.add(country.parent_L5__r.Name);
            mapIdCountries.put(country.name.toUpperCase(), country.id);
            if(!lstAjaxCountries.contains(country.name)) lstAjaxCountries+=(country.name+',');
            if (country.parent_L5__c != null) {
                if (!mapRelatedCntries.containsKey(country.parent_L5__r.Name)) {
                    mapRelatedCntries.put(country.parent_L5__r.Name, new list<string>());
                } else {
                    mapRelatedCntries.get(country.parent_L5__r.Name).add(country.Name);
                }
                mapIdCSSCountryRegion.put(country.name, country.id);
                if (mapIdCSSCountryRegion.get(country.parent_L5__r.Name) == null) {
                    mapIdCSSCountryRegion.put(country.parent_L5__r.Name, country.parent_L5__r.id);
                    mapRegionCntries.put(country.name, country.parent_L5__r.id);
                    lstNameCountries.add(country.name);
                }
            }
        }


    }
    /* The list of Action functions for popups*/

    public void setInfoTimeLine() {
        
        // nothing juste saving the mapping values
        if (projectId != null) {
            update project;
            project = [Select Id, Name, Innovation_Projects__c , ProjectTotalAssetscore__c, Jobs_to_be_Done__c , Campaign_Fees_Total__c, Completed_Stage__c, Financial_Year__r.currency__c, Projected_Stage__c, Financial_Year__r.Financial_Year__c, BET_first_release__c, Value_to_be_paid_in_Current_FY__c, Campaign_Status__c, Preview_Date__c, Start_of_TV_production__c, Final_release__c, Live_Date__c, Live_date_Asset_delivery__c, Date_for_Assets_to_be_in_BET__c, Timescale_Notes__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c, Project_Finish_Date__c, Project_Stage__c, Platform__c, CreatedById, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, Campaign_Countries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id = :projectId];       
        }
         VerifyChecks();
    }
    public void setInfoCountries() {       
      
        if (project.Campaign_Countries__c != null) {
            ValueDriversProject(project.Campaign_Countries__c);
        }         
         if (projectId != null) {
            update project;
            project = [Select Id, Name, Innovation_Projects__c , ProjectTotalAssetscore__c, Jobs_to_be_Done__c , Campaign_Fees_Total__c, Completed_Stage__c, Financial_Year__r.currency__c, Projected_Stage__c, Financial_Year__r.Financial_Year__c, BET_first_release__c, Value_to_be_paid_in_Current_FY__c, Campaign_Status__c, Preview_Date__c, Start_of_TV_production__c, Final_release__c, Live_Date__c, Live_date_Asset_delivery__c, Date_for_Assets_to_be_in_BET__c, Timescale_Notes__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c, Project_Finish_Date__c, Project_Stage__c, Platform__c, CreatedById, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, Campaign_Countries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id = :projectId];       
        }
        VerifyChecks();
    }
   
    /*
    *    Void Method Used for : Updating Project Scale One by the number of countries.
    */
    @TestVisible
    private void ValueDriversProject(String selectedCountriesLoc) {
        
        List<String> lstCountriesString =  selectedCountriesLoc.split(',');
        System.debug('###lsstCountriesString save : ' + lstCountriesString);
        project.Project_Scale_1__c = '';
        if (!lstCountriesString.isEmpty()) {
            if (lstCountriesString.size() == 1) { project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market1;}
            else if (lstCountriesString.size() > 1 && lstCountriesString.size() <= 5) { project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market2;}
            else if (lstCountriesString.size() > 5 && lstCountriesString.size() <= 10) { project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market3;}
            else if (lstCountriesString.size() > 10 && lstCountriesString.size() <= 15) {project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market4;}
            else if (lstCountriesString.size() > 15) { project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market5;}
        }
    }
    /*
    Description: Method called on VF to update project with new infoDrivers
    */
    public void setInfoDrivers() {
        
        system.debug('###selectedBrandBrand : ' + selectedBrandBrand);
        system.debug('###selectedBrandInnov : ' + selectedBrandInnov);
        
        if (projectId != null) {
            if (project.Innovation_Projects__c == Label.Oblix_Lbl_Innovation_Projects_Innovation) {
                project.Brand_Led_Growth__c = selectedBrandInnov;
            } else {
                project.Brand_Led_Growth__c = selectedBrandBrand;
            }
           update project;
           project = [Select Id, Name, Innovation_Projects__c , ProjectTotalAssetscore__c, Jobs_to_be_Done__c , Campaign_Fees_Total__c, Completed_Stage__c, Financial_Year__r.currency__c, Projected_Stage__c, Financial_Year__r.Financial_Year__c, BET_first_release__c, Value_to_be_paid_in_Current_FY__c, Campaign_Status__c, Preview_Date__c, Start_of_TV_production__c, Final_release__c, Live_Date__c, Live_date_Asset_delivery__c, Date_for_Assets_to_be_in_BET__c, Timescale_Notes__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c, Project_Finish_Date__c, Project_Stage__c, Platform__c, CreatedById, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, Campaign_Countries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id = :projectId];
          
        }
        VerifyChecks();
    }
     /*
    Description: Method called on VF to update project field Percentage_of_Fee_for_this_FY__c 
    */
    public void setInfoStages() {
        
        Decimal totalPercentageThisYear = 0;
        if(!String.isEmpty(project.Projected_Stage__c)){
            Set<String> projectedStages = new Set<String>(project.Projected_Stage__c.split(','));
            System.debug('feePercentages: ' + JSON.serialize(feePercentages));
            System.debug('projectedStages: ' + JSON.serialize(projectedStages));
            for(String stageName :projectedStages){
                totalPercentageThisYear += feePercentages.get(stageName) == null ? 0 : feePercentages.get(stageName);
            }
        }
        System.debug('projected stages: ' + project.Projected_Stage__c);
        System.debug('total percentage for this year:' + totalPercentageThisYear);
        
        project.Percentage_of_Fee_for_this_FY__c = totalPercentageThisYear;
        
        if (projectId != null) {
            update project;
            project = [Select Id, Name, Innovation_Projects__c , ProjectTotalAssetscore__c, Jobs_to_be_Done__c , Campaign_Fees_Total__c, Completed_Stage__c, Financial_Year__r.currency__c, Projected_Stage__c, Financial_Year__r.Financial_Year__c, BET_first_release__c, Value_to_be_paid_in_Current_FY__c, Campaign_Status__c, Preview_Date__c, Start_of_TV_production__c, Final_release__c, Live_Date__c, Live_date_Asset_delivery__c, Date_for_Assets_to_be_in_BET__c, Timescale_Notes__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c, Project_Finish_Date__c, Project_Stage__c, Platform__c, CreatedById, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, Campaign_Countries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id = :projectId];
            
        } /* the percentage for this year is set in a workflow, not calculated, sto recalculateFormulas without DML won't work
           else {
            project.recalculateFormulas();
        }*/
        VerifyChecks();
    }
   
     /*
    Description: Method called on VF to update Split related to Project 
    */
    public void setInfoSplitHub() {
        splitToInsert = new list<Oblix_Marketing_SOW_Project_Splits__c>();
        splitToUpdate = new list<Oblix_Marketing_SOW_Project_Splits__c>();
        splitToDelete = new list<Oblix_Marketing_SOW_Project_Splits__c>();    
        getAgencyHubFiveInsance();    
        v3 = false; //achraf      
        if(listItems != '') {
            listItems = listItems.removeEnd(',');
            list<string> items = listItems.split(',');
            System.debug('## items : ' + items );
            for (string it : items) {
                list<string> item = it.split('_');
                System.debug('## item  : ' + item );
                if (item[1] InstanceOf ID ) {
                    agencySplitInstanceJS.OblixCountry__c = item[1];
                }
                if (projectId != null) {
                    agencySplitInstanceJS.Project_Splits__c = projectId;
                }
                agencySplitInstanceJS.Percentage__c  = Decimal.valueOf(item[2]);
                if (item[0] InstanceOf ID) {
                    agencySplitInstanceJS.id = Id.valueOf(item[0]);
                    if (agencySplitInstanceJS.Percentage__c != 0) {
                        splitToUpdate.add(agencySplitInstanceJS);
                        v3 = true; //achraf
                    } else {          
                        splitToDelete.add(agencySplitInstanceJS);
                    }
                }
                if (item[0] == ' ' && agencySplitInstanceJS.Percentage__c != 0) {
                    splitToInsert.add(agencySplitInstanceJS);
                    v3 = true; //achraf
                }
                agencySplitInstanceJS = new Oblix_Marketing_SOW_Project_Splits__c();
            }
        }      
        if (projectId != null) {     
            try{
                delete splitToDelete;
                update splitToUpdate;
                insert splitToInsert;                
                project = [Select Id, Name, Innovation_Projects__c , ProjectTotalAssetscore__c, Jobs_to_be_Done__c , Campaign_Fees_Total__c, Completed_Stage__c, Financial_Year__r.currency__c, Projected_Stage__c, Financial_Year__r.Financial_Year__c, BET_first_release__c, Value_to_be_paid_in_Current_FY__c, Campaign_Status__c, Preview_Date__c, Start_of_TV_production__c, Final_release__c, Live_Date__c, Live_date_Asset_delivery__c, Date_for_Assets_to_be_in_BET__c, Timescale_Notes__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c, Project_Finish_Date__c, Project_Stage__c, Platform__c, CreatedById, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, Campaign_Countries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id = :projectId];         
                //getAgencyHubFiveInsance();
            }catch (DMLException e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Could not save splits: ' + e.getMessage()));
            }                        
        }        
        VerifyChecks();
        
    }
    
    /*
    Description: ============
    */
    public void setMoreDetails() {
        System.debug('###assetInstance.Actual_Delivery_Date__c :' + assetInstance.Actual_Delivery_Date__c );
        System.debug('###assetInstance.Additional_Description__c :' + assetInstance.Additional_Description__c );
    }
    
    /*
    Description: ============
    */
    public void saveSubCatAsset() {
        assetInstance.recordTypeId = Oblix_Utils.MapRecordType('Oblix_Project_Assets__c').get('Audio Visual') ;
        assetInstance.Sub_Category__c = 'Adaptations and Reedits';
    }
    
    /*
    Description: Used to Insert/update Project 
    @return : page reference  7 if new ,6 if Edit
    */
    public pageReference SaveProjectAction() {
        try {
            
            system.debug('###selectedBrandBrand : ' + selectedBrandBrand);
            system.debug('###selectedBrandInnov : ' + selectedBrandInnov);
            if (project.Innovation_Projects__c == Label.Oblix_Lbl_Innovation_Projects_Innovation) {
                project.Brand_Led_Growth__c = selectedBrandInnov;
            } else {
                project.Brand_Led_Growth__c = selectedBrandBrand;
            }
            
            if (projectId != null) {
                if (project.Name == null) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'These fields are required : Name'));
                    return null;
                } else {
                    update project;
                    return new pageReference('/apex/Oblix_VF07_ProjectView?projectId=' + project.Id);
                }

            } else {
                if (project.Name == null) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'These fields are required : Name'));
                    return null;
                } else {
                    insert project;
                    if (!splitToInsert.isEmpty()) {
                        for (Oblix_Marketing_SOW_Project_Splits__c split : splitToInsert) {
                            split.Project_Splits__c = project.Id;
                        }
                        insert splitToInsert;
                    }
                    return new pageReference('/apex/Oblix_VF06_SOWView?sowId=' + project.Financial_Year__c);
                }

            }

        } catch (DMLException le) {
            if (le.getMessage().contains('DUPLICATE_VALUE')) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Duplicate Value Found with the same Name'));
            }
            System.debug('###Error Occured : ' + le.getMessage());
            return null;
        }

    }
    /*public pageReference InsertProjectAction(){
           try{
                insert project;
            }catch(Exception e){
               System.debug('###Error Occured : '+e.getMessage());
            }
            return new pageReference('/apex/Oblix_VF08_ProjectEdit?projectId='+project.Id);
    }*/
    
    /*
    Description: Used to Cancel 
    @return : page reference  7 if new ,6 if Edit
    */
    public pageReference BackAction() {
        if (project.Id == null) {
            return new pageReference('/apex/Oblix_VF06_SOWView?sowId=' + project.Financial_Year__c);
        } else {
            return new pageReference('/apex/Oblix_VF07_ProjectView?projectId=' + project.Id);
        }
        return null;
    }
    
    /*
    Description: update value of isEdit variable
    */
    public void EditAction() {
        isEdit = true;
    }
    
    
    /*
    Description: add agency split
    */
    public void AddAgencySplit() {
        Oblix_Marketing_SOW_Project_Splits__c agencySplitInstance = new Oblix_Marketing_SOW_Project_Splits__c();
        agencySplitInstance.Project_Splits__c = projectId;
        lstProjectSplitHubs.add(agencySplitInstance);
    }
    
    /*
    Description: used to fill countries options
    Return : Select options with countries values
    */
    public List<SelectOption> getCountriesOptions() {
        countryOptions = new List<SelectOption>();
        string financialYear = '';
        system.debug('###project.Financial_Year__r.Financial_Year__c : ' + project.Financial_Year__r.Financial_Year__c);
        IF(projectId == null) {
            Marketing_SOW__c projectSow = [select financial_Year__c from Marketing_SOW__c where id = :project.Financial_Year__c];
            financialYear =  projectSow.financial_Year__c;
        } else {
            financialYear =  project.Financial_Year__r.Financial_Year__c;
        }
        List<Oblix_Calculator__c> calculator = [select Name, OblixCountry__c from Oblix_Calculator__c where recordType.Name = 'Country Box Number' and Financial_Year__c = :financialYear order by name];
        //list<string> nameCountry = new list<string>();
        countryOptions.add(new SelectOption('', '-None-'));
        if (!calculator.isEmpty()) {
            for (Oblix_Calculator__c c : calculator) {
                // if(c.Name == 'France'){countryOptions.add(new SelectOption(c.name,c.Name));}
                if (mapIdCountries.get(c.name.toUpperCase()) != null) {countryOptions.add(new SelectOption(mapIdCountries.get(c.name.toUpperCase()), c.Name.toUpperCase()));}
            }
        }

        return countryOptions;
    }
    
     /*
    Description: used to fill Drivers options
    Return : Select options with Drivers values
    */
    public void getValueDriversOptions() {
        innovationOptions = new List<SelectOption>();
        brandOptions = new List<SelectOption>();
        Schema.DescribeFieldResult lstProjectBV = Oblix_SOW_Projects__c.Brand_Led_Growth__c.getDescribe();
        List<Schema.PicklistEntry> lstProjectBVValues = lstProjectBV.getPicklistValues();
        brandOptions.add(new SelectOption('', ' Business Value Creation - BRAND LED GROWTH  '));
        innovationOptions.add(new SelectOption('', ' Business Value Creation - INNOVATION PROJECTS '));
        for (Schema.PicklistEntry a : lstProjectBVValues ) {
            if (a.getLabel().contains('€')) {
                brandOptions.add(new SelectOption(a.getLabel(), a.getLabel()));
            } else {
                innovationOptions.add(new SelectOption(a.getLabel(), a.getLabel()));
            }
        }
    }
    
    /*
    Description: Add assets to project
    */
    public void AddToProjectAction() {
        complexity = '%' + complexity;
        system.debug('### complexity  : ' + complexity );
        system.debug('### assetInstance.Asset_Type__c: ' + assetInstance.Asset_Type__c);
        system.debug('### assetInstance.Sub_Category__c: ' + assetInstance.Sub_Category__c);

        //assetInstance.Actual_Delivery_Date__c = assetInstanceDate;
        //assetInstance.Additional_Description__c = assetInstanceDescription;
        system.debug('### assetInstance.Additional_Description__c ' + assetInstance.Additional_Description__c );
        system.debug('### assetInstance.Actual_Delivery_Date__c ' + assetInstance.Actual_Delivery_Date__c);
        system.debug('### subCatc ' + subCat);
        system.debug('### mapAssetsPerSubCat ' + mapAssetsPerSubCat);
        mapAssetsPerSubCat.get(subCat).Actual_Delivery_Date__c = assetInstance.Actual_Delivery_Date__c;
        mapAssetsPerSubCat.get(subCat).Additional_Description__c = assetInstance.Additional_Description__c;

        assetInstance = mapAssetsPerSubCat.get(subCat);

        //achraf
        system.debug('============== assetInstance.Asset_Picklist__c: ' + assetInstance.Asset_Picklist__c);
        system.debug('============== assetInstance.Location__c: ' + assetInstance.Location__c);

        if (assetInstance.Asset_Picklist__c == null) {
            return;
        }
        if (assetInstance.Asset_Picklist__c == 'Other' && ( assetInstance.Location__c == '' ||  assetInstance.Location__c == null)) {
            return;
        }
        //end achraf


        RecordType  recordT = [SELECT Name, id FROM RecordType WHERE sObjectType = 'Oblix_Project_Assets__c' and name = : recordType];
        system.debug('### assetInstance.Sub_Category__c : ' +  assetInstance.Sub_Category__c );
        list<Asset_Scoring__c> lstscore = [select id from Asset_Scoring__c where Sub_Category__c = :subCat and Type__c = :recordT.Name and Name like :complexity];
        //assetInstance.Sub_Category__c = subCat;
        system.debug('### mapAbreviation.assetInstance.Sub_Category__c : ' +  mapAbreviation.size());
        system.debug('###mapAbreviation : '+mapAbreviation);
        assetInstance.Asset_Title__c = assetInstance.Quantity__c + crossX + mapAbreviation.get('' + recordT.Name) + '-' + mapAbreviation.get('' + assetInstance.Sub_Category__c) + '-' + '0' + complexity.remove('%');
        assetInstance.Asset_Title__c = assetInstance.Asset_Title__c.replaceAll('null', '');
        if (assetInstance.id == null) {
            assetInstance.Agency_Projects__c = project.id;
        }
        assetInstance.RecordTypeId = recordT.id;
        //assetInstance.Asset_Type__c = recordType;
        system.debug('### lstscore : ' + lstscore);
        if (!lstscore.isEmpty()) {
            assetInstance.FULL_Description__c = lstscore[0].id;
        }
        //Oblix_Project_Assets__c  assetInstanceCopy = new Oblix_Project_Assets__c ();

        if (assetInstance.Id != null) {
            assetInstance.Id = NULL;
        }
        insert assetInstance;

        Oblix_Project_Assets__c getAssetName = [select Name, Quantity__c, Sub_Category__c, Asset_Type__c, Asset_Title__c  from Oblix_Project_Assets__c where id = :assetInstance.id];
        lstAssetsForCard.add(getAssetName);
        system.debug('### project.Campaign_Fees_Total__c : ' + project.Campaign_Fees_Total__c);
        project = [Select Id, Name, Innovation_Projects__c , ProjectTotalAssetscore__c, Jobs_to_be_Done__c , Campaign_Fees_Total__c, Completed_Stage__c, Financial_Year__r.currency__c, Projected_Stage__c, Financial_Year__r.Financial_Year__c, BET_first_release__c, Value_to_be_paid_in_Current_FY__c, Campaign_Status__c, Preview_Date__c, Start_of_TV_production__c, Final_release__c, Live_Date__c, Live_date_Asset_delivery__c, Date_for_Assets_to_be_in_BET__c, Timescale_Notes__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c, Project_Finish_Date__c, Project_Stage__c, Platform__c, CreatedById, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, Campaign_Countries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id = :projectId];
        estimateCost =  project.Campaign_Fees_Total__c;
        assetInstance = new Oblix_Project_Assets__c ();
        assetInstance.clear();
        mapAssetsPerSubCat.put(subCat, new Oblix_Project_Assets__c(Sub_Category__c = subCat, Quantity__c = 1, recordTypeId = mapRTforSubCat.get(subCat)));
    }
    
    
    /*
    Description: ============
    */
    public void ReInitializeInstance() {
        mapAssetsPerSubCat.put(subCat, new Oblix_Project_Assets__c(Sub_Category__c = subCat, Quantity__c = 1, recordTypeId = mapRTforSubCat.get(subCat)));
    }
    /*
    public class assetWrapper {

        public Oblix_Project_Assets__c assetWrapp {get;set;}
        public string keyAsset {get;set;}
        public decimal quantity {get;set;}

        public assetWrapper (){
            assetWrapp = new Oblix_Project_Assets__c();
            keyAsset = '';
            quantity = 0;
        }

    }*/

    /**
     * One button to set Campaign as Global campaign (over 15 countries)
     */
     
    public void setAsGlobal() {
        v2 = true;
        project.Campaign_Countries__c = '';
        project.OblixRegion__c = 'World';
        project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market5;
       
        if(project.id != null){
            try {
    
                update project;
    
            } catch (DMLException e) {
    
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Could not save project: ' + e.getMessage()));
                isError = true;
    
            }
        }

    }
    
    /*
    Description:Remote Action to remove asset by id
    */
    @RemoteAction
    public static void removeAsset(String assetId) {
        try {
            delete [SELECT Id FROM Oblix_Project_Assets__c WHERE Id = : assetId];
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Could not remove asset: ' + e.getMessage()));
        }
    }
    
    
     /*
    Description:Remote Action to refresh assets titles  
    */
    public void refresh() {
        lstAssetsForCard = new List<Oblix_Project_Assets__c>();
        list<Oblix_Project_Assets__c> lstAsset = [select Id, Agency_Projects__r.id, Channels__c, RecordType.Name, Quantity__c , Asset_Picklist__c, Asset_Title__c , Name, RecordTypeId, Sub_Category__c, FULL_Description__c, FULL_Description__r.name from Oblix_Project_Assets__c where Agency_Projects__r.id = :project.id  limit 1000];
        for (Oblix_Project_Assets__c asse : lstAsset) {
            if (asse.FULL_Description__c != null) {
                asse.Asset_Title__c = asse.Quantity__c + crossX + mapAbreviation.get('' + asse.RecordType.Name) + '-' + mapAbreviation.get('' + asse.Sub_Category__c) + '-' + '0' + asse.FULL_Description__r.name.remove('Score ').remove('Full ').remove('Lite ');
            }
            if (asse.Asset_Title__c != null) {
                asse.Asset_Title__c = asse.Asset_Title__c.replaceAll('null', '');
            }
        }
        lstAssetsForCard.addAll(lstAsset);
        project = [Select Id, Name, Innovation_Projects__c , ProjectTotalAssetscore__c, Jobs_to_be_Done__c , Campaign_Fees_Total__c, Completed_Stage__c, Financial_Year__r.currency__c, Projected_Stage__c, Financial_Year__r.Financial_Year__c, BET_first_release__c, Value_to_be_paid_in_Current_FY__c, Campaign_Status__c, Preview_Date__c, Start_of_TV_production__c, Final_release__c, Live_Date__c, Live_date_Asset_delivery__c, Date_for_Assets_to_be_in_BET__c, Timescale_Notes__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c, Project_Finish_Date__c, Project_Stage__c, Platform__c, CreatedById, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, Campaign_Countries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id = :projectId];
        estimateCost =  project.Campaign_Fees_Total__c;
    }
    
    /*
    Description: to get AbreViations map
    */
    @RemoteAction
    public static Map<String, String> getAbreViationByRTBySubCatgForCardAssets() {
        return Oblix_Utils.getAbreViationByRTBySubCatgForCardAssets();
    }
    
    /*
    Description: returning detail asset by ID 
    */
    @RemoteAction
    public static Oblix_Utils.AssetDetailWrapper getAssetDetails(String assetId) {
        return new Oblix_Utils.AssetDetailWrapper([SELECT Id, Quantity__c, Additional_Description__c,
                Actual_Delivery_Date__c, Asset_Picklist__c, Location__c, Asset_Title__c 
                FROM Oblix_Project_Assets__c WHERE Id = : assetId LIMIT 1]);
    }
    
    /*
    Description: update assets
    */
    @RemoteAction
    public static void UpdateProjectAction(String assetId, Map<String, Object> details) {
        Oblix_Project_Assets__c asset = [SELECT Id, Asset_Title__c FROM Oblix_Project_Assets__c WHERE Id = : assetId];
        for (String key : details.keySet()) {
            if (key.equalsIgnoreCase('actual_Delivery_Date')) {
                asset.put(key + '__c', Date.valueOf(String.valueOf(details.get(key))));
            } else if (key.equalsIgnoreCase('quantity')) {
                asset.put(key + '__c', Decimal.valueOf(String.valueOf(details.get(key))));
            } else {
                asset.put(key + '__c', String.valueOf(details.get(key)));
            }
        }

        asset.Asset_Title__c = asset.Quantity__c + crossX + asset.Asset_Title__c.split(crossX)[1];
        System.debug(asset);
        Savepoint sp = Database.setSavepoint();
        try {
            update asset;
        } catch (DMLException e) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Could not update asset: ' + e.getMessage()));
        }
    }
}