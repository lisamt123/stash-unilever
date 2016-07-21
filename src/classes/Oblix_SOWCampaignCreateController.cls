public with sharing class Oblix_SOWCampaignCreateController extends Oblix_SWOPparentController {

    public Oblix_CampaignStageLogic stage_identifier {
        get;
        set;
    }
    public Oblix_CampaignCreateHelper campaignHelper {
        get;
        set;
    }
    public transient String agencyHubSplitWrapperListJSONString {
        get;
        set;
    }
    public transient String selectedMainRegions {
        get;
        set;
    }
    public List < Oblix_Marketing_SOW_Project_Splits__c > agencyHubSplitListToInsertOnEdit {
        get;
        set;
    }
    public List < Oblix_Marketing_SOW_Project_Splits__c > agencyHubSplitListToInsert {
        get;
        set;
    }
    public List < Oblix_Marketing_SOW_Project_Splits__c > agencyHubSplitListToUpdate {
        get;
        set;
    }
    public List < Oblix_Marketing_SOW_Project_Splits__c > agencyHubSplitListToDelete {
        get;
        set;
    }
    public List < AgencyHubSplitWrapper > agencyHubSplitWrapperList {
        get {
            if (agencyHubSplitWrapperList == null) {
                agencyHubSplitWrapperList = new List < AgencyHubSplitWrapper > ();
            }
            return agencyHubSplitWrapperList;
        }
        set;
    }
    
    // **********************************************************************
    // S.M ADDED TO ALLOW VALIDATION PASS FOR QA TEST - NEED TO REMOVE AFTER
    // **********************************************************************
public User userConnected {get; set;}
    public boolean v1 {get; set;} // to show Correct check on buttons V
    public boolean v2 {get; set;}
    public boolean v3 {get; set;}
    public boolean v4 {get; set;}
    public boolean v5 {get; set;}
    public id projectId {get; set;}
    public list<Oblix_Project_Assets__c> lstAssets {get; set;}
    public boolean isEdit {get; set;}
    public Oblix_SOW_Projects__c project {get; set;}
    public set<string> setRecordType  {get; set;}
    public map<string, list<Oblix_Project_Assets__c>> mapRTAssets {get; set;}
    public String updatedAssetInstance { get;set; }
    public Boolean isUpdate { get; set; }
    public String basketKey { get; set; }
    public String selectedAssetId { get; set; }
    public String assetPicklist { get; set; }
    public String assetDescription { get; set; }
    public String assetLocation { get; set; }
    public String assetQuantity { get; set; }
    public map<string, string> mapRTIdCSS {get; set;}
    public map<string, string> mapStageIdCSS {get; set;}
    public string setIdCss {get; set;}
    public string recordType {get; set;}
    public string subCat {get; set;}
    public string complexity {get; set;}
    public list<Oblix_Project_Assets__c> lstAssetsForCard {get; set;}
    public map<string, list<string>> mapRTSUBCat {get; set;}
    public list<RecordType> recordTypes {get; set;}
    public list<string> lstRecordType {get; set;}
    public integer mynumber {get; set;}
    public list<string> lstStage {get; set;}
    public Map<String, Set<String>> mapRelatedCntries {get; set;}
    public Map<String, String> mapRegionCntries {get; set;}
    public Oblix_Project_Assets__c  assetInstance  {get; set;}
    public String lstAjaxCountries {get; set;}
    public set<string> lstRegion {get; set;}
    public map<string, ID> mapIdCSSCountryRegion {get; set;}
    public string lstIdCSSSelected {get; set;}
    public List<Oblix_Marketing_SOW_Project_Splits__c> lstProjectSplitHubs {get; set;}
    public String lstSelectedCountryJSON { get; set; }
    public String lstSelectedRegionJSON { get; set; }
    public String selectedRegion { get; set; }
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
    public String selectedCountry {get; set;}
    public List<SelectOption> countryOptions {get; set;}
    public map<string, string> mapIdCountries {get; set;}
    public string listItems {get; set;}
    public decimal estimateCost {get; set;}
    public Integer countAssetNumberForCampaign  {get;set;}
    public string lstSubCategory {get; set;}
    public map<string, Oblix_Project_Assets__c> mapAssetsPerSubCat {get; set;}
    public map<string, string> mapRTforSubCat {get; set;}
    public map<string, string> mapAbreviation {get; set;}
    public List<SelectOption> innovationOptions {get; set;}
    public List<SelectOption> brandOptions {get; set;}
    public Map<String,String> mapOfAssetBasket { get; set; }
    public Boolean canAdjust {get; set;}
    public Boolean isGlobalCampaign { get; set; }
    public Boolean isGlobal { get; set; }
    public String selectedBrandInnov {get; set;}
    public String selectedBrandBrand {get; set;}
    public boolean isError {get; set;}
    public String mapRelatedCntriesJSON { get; set; }
    public String mapRelatedCntriesJSONMap { get; set; }
    public List<String> mapAllCountries { get; set; }
    public String sowName { get; set; }
    public Marketing_SOW__c selected_sow{get;set;}
    public Integer numberOFSelectedCountries { get; set; }
    public String selectionCountvar{get;set;}
    public Boolean isFirst {get;set;}
    // **********************************************************************
    // S.M ADDED TO ALLOW VALIDATION PASS FOR QA TEST - NEED TO REMOVE AFTER
    // **********************************************************************

    public void init() {
        system.debug('started');
    }

    public Oblix_SOWCampaignCreateController() {
        system.debug('================================================= im the controller here ===');
        campaignHelper = new Oblix_CampaignCreateHelper();
        /*System.DEBUG(' SOWId : ' + campaignHelper.sowId);
        System.DEBUG(' projectId : ' + campaignHelper.projectId);
        System.DEBUG(' isEdit : ' + campaignHelper.isEdit);
        System.DEBUG(' campaignHelper.allCountries : ' + campaignHelper.allCountries);
        System.DEBUG(' campaignHelper.allCountries size : ' + campaignHelper.allCountries.size());
        System.DEBUG(' campaignHelper.countriesWithRegionsMap ' + campaignHelper.countriesWithRegionsMap);

        System.DEBUG(' campaignHelper.countriesWithRegionsMap size :  ' + campaignHelper.countriesWithRegionsMap.keyset().size());
        System.DEBUG( ' Benelux : ' + campaignHelper.countriesWithRegionsMap.get('Benelux'));*/
        if (campaignHelper.isEdit) {
            stage_identifier = new Oblix_CampaignStageLogic(campaignHelper.selectedProject, Oblix_PermissionHandler.canSetProjectedStage(campaignHelper.selectedSow.SOW_Status__c), Oblix_PermissionHandler.canSetCompletionStage(campaignHelper.selectedSow.SOW_Status__c));
        } else {
            stage_identifier = new Oblix_CampaignStageLogic(campaignHelper.selectedSow.Id);
        }
    }

    /*@TestVisible
    private void getErrorClone() {
        String errorClone = '';
        if (ApexPAges.currentPage().getParameters().get('isClone') != null && ApexPAges.currentPage().getParameters().get('isClone') == '1') {
            errorClone = 'Campaign Name need to be changed while cloning';
        }
        if (ApexPAges.currentPage().getParameters().get('duplicateValue') != null && ApexPAges.currentPage().getParameters().get('duplicateValue') == '1') {
            if (errorClone != '') {
                errorClone += ', ';
            }
            errorClone += 'Duplicate Value Found with the same Name ';
        }
        if (errorClone != null && errorClone != '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning, errorClone));
        }
    }*/

    public void addOneMoreProjectSplitInstance() {
        if (campaignHelper.isEdit) {
            Oblix_Marketing_SOW_Project_Splits__c agencySplitInstance = new Oblix_Marketing_SOW_Project_Splits__c();
            agencySplitInstance.Project_Splits__c = campaignHelper.projectId;
            campaignHelper.agencySplitHubs.add(agencySplitInstance);
        } else {
            campaignHelper.agencySplitHubs.add(new Oblix_Marketing_SOW_Project_Splits__c());
        }
        campaignHelper.numberOfAgencyHubSplits = campaignHelper.agencySplitHubs.size();
        System.DEBUG('Hubsplit Size : ' + campaignHelper.agencySplitHubs.size());
    }

    public void setInfoCountries() {
        System.DEBUG('Set Countries : ' + campaignHelper.selectedProject.Campaign_Countries__c);
        System.DEBUG('All Regions : ' + campaignHelper.selectedProject.OblixRegion__c);
        System.DEBUG('Main Regions : ' + selectedMainRegions);
        List < String > regionList = new List < String > ();
        String tempCountries = campaignHelper.selectedProject.Campaign_Countries__c;
        if (selectedMainRegions != null && campaignHelper.selectedProject.Campaign_Countries__c.length() > 0) {
            campaignHelper.selectedProject.Campaign_Countries__c = selectedMainRegions + '/' + campaignHelper.selectedProject.Campaign_Countries__c;
        } else {
            campaignHelper.selectedProject.Campaign_Countries__c = campaignHelper.selectedProject.OblixRegion__c;
        }

        if(campaignHelper.selectedProject.Campaign_Countries__c != null && campaignHelper.selectedProject.Campaign_Countries__c.startsWith('/')){
            campaignHelper.selectedProject.Selected_Countries__c = campaignHelper.selectedProject.Campaign_Countries__c.removeStart('/');
            campaignHelper.selectedProject.Selected_Countries__c = addSpacesInCSV(campaignHelper.selectedProject.Selected_Countries__c);
        }else{
            campaignHelper.selectedProject.Selected_Countries__c = campaignHelper.selectedProject.Campaign_Countries__c;
            campaignHelper.selectedProject.Selected_Countries__c = addSpacesInCSV(campaignHelper.selectedProject.Selected_Countries__c);
        }
        System.DEBUG('Set Changes Countries : ' + campaignHelper.selectedProject.Campaign_Countries__c);
        System.DEBUG('Set Changes Region : ' + campaignHelper.selectedProject.OblixRegion__c);
        setCampaignScaleOne(selectedMainRegions, tempCountries);
    }


    private String addSpacesInCSV(String countriesToAdjust){
        String adjustedString = '';
        if(countriesToAdjust != null){
            for(String toBeAdded : countriesToAdjust.split(',')){
                adjustedString += toBeAdded + ', ';
            }
            adjustedString = adjustedString.trim();
            adjustedString = adjustedString.removeEnd(',');
            System.DEBUG(adjustedString);
        }
        return adjustedString;
    }

    private void setCampaignScaleOne(String selectedMainRegions, String selectedCountriesLoc) {
        String countriesSelected = '';
        List < String > splitRegion = new List < String > ();
        System.DEBUG('###selectedCountriesLoc save : ' + selectedCountriesLoc);
        List < String > lstCountriesString = new List < String > ();
        if (!selectedCountriesLoc.equalsIgnoreCase(''))
            lstCountriesString = selectedCountriesLoc.split(',');
        System.DEBUG('###lsstCountriesString save : ' + lstCountriesString);
        System.DEBUG('lstCountriesString Size : ' + lstCountriesString.size());
        campaignHelper.selectedProject.Project_Scale_1__c = '';
        if (selectedMainRegions != null && !selectedMainRegions.equalsIgnoreCase('')) {
            campaignHelper.selectedProject.Project_Scale_1__c = null;
        } else if (!lstCountriesString.isEmpty()) {
            if (lstCountriesString.size() == 1) {
                campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market1;
            } else if (lstCountriesString.size() > 1 && lstCountriesString.size() <= 5) {
                campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market2;
            } else if (lstCountriesString.size() > 5 && lstCountriesString.size() <= 10) {
                campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market3;
            } else if (lstCountriesString.size() > 10 && lstCountriesString.size() <= 15) {
                campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market4;
            } else if (lstCountriesString.size() > 15) {
                campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market5;
            }
        } else {
            campaignHelper.selectedProject.Project_Scale_1__c = null;
        }
        if (campaignHelper.selectedProject.OblixRegion__c != null && campaignHelper.selectedProject.OblixRegion__c.startsWith('Global')) {
            campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market5;
        }
        System.DEBUG('Project Scale Set : ' + campaignHelper.selectedProject.Project_Scale_1__c);
    }

    public void setCampaignScaleOneGlobal() {
        campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market5;
        campaignHelper.selectedProject.OblixRegion__c = 'Global';
        campaignHelper.selectedProject.Campaign_Countries__c = 'Global';
        campaignHelper.selectedProject.Selected_Countries__c = campaignHelper.selectedProject.Campaign_Countries__c;
    }

    public void setCampaignScale() {
        System.DEBUG('Number of Selected Countries : ' + campaignHelper.numberOFSelectedCountries);
        if (campaignHelper.numberOFSelectedCountries > 0 && campaignHelper.numberOFSelectedCountries <= 1) {
            campaignHelper.selectedProject.Project_Scale_2__c = '1 location';
        } else if (campaignHelper.numberOFSelectedCountries > 1 && campaignHelper.numberOFSelectedCountries <= 2) {
            campaignHelper.selectedProject.Project_Scale_2__c = 'Up to 2 locations';
        } else if (campaignHelper.numberOFSelectedCountries > 2 && campaignHelper.numberOFSelectedCountries <= 3) {
            campaignHelper.selectedProject.Project_Scale_2__c = 'Up to 3 locations';
        } else if (campaignHelper.numberOFSelectedCountries > 3 && campaignHelper.numberOFSelectedCountries <= 4) {
            campaignHelper.selectedProject.Project_Scale_2__c = 'Up to 4 locations';
        } else if (campaignHelper.numberOFSelectedCountries > 4 && campaignHelper.numberOFSelectedCountries <= 5) {
            campaignHelper.selectedProject.Project_Scale_2__c = 'Up to 5 locations';
        } else if (campaignHelper.numberOFSelectedCountries > 5) {
            campaignHelper.selectedProject.Project_Scale_2__c = 'More than 5 locations';
        }
        System.DEBUG('Project Scale : ' + campaignHelper.selectedProject.Project_Scale_2__c);
    }


    /*
    Description: Method called on VF to update project with new infoDrivers
    */
    public void setInfoDrivers() {

        system.debug('###selectedBrandBrand : ' + campaignHelper.selectedBrandBrand);
        system.debug('###selectedBrandInnov : ' + campaignHelper.selectedBrandInnovation);

        if (campaignHelper.isEdit) {
            if (campaignHelper.selectedProject.Innovation_Projects__c == Label.Oblix_Lbl_Innovation_Projects_Innovation) {
                campaignHelper.selectedProject.Brand_Led_Growth__c = campaignHelper.selectedBrandInnovation;
            } else {
                campaignHelper.selectedProject.Brand_Led_Growth__c = campaignHelper.selectedBrandBrand;
            }
            update campaignHelper.selectedProject;
            campaignHelper.selectedProject = [Select Id, Name, Innovation_Projects__c, ProjectTotalAssetscore__c, Jobs_to_be_Done__c, Campaign_Fees_Total__c, Completed_Stage__c, Financial_Year__r.currency__c, Projected_Stage__c, Financial_Year__r.Financial_Year__c, Financial_Year__r.Name, BET_first_release__c, Value_to_be_paid_in_Current_FY__c, Campaign_Status__c, Preview_Date__c, Start_of_TV_production__c, Final_release__c, Live_Date__c, Live_date_Asset_delivery__c, Date_for_Assets_to_be_in_BET__c, Timescale_Notes__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c, Project_Finish_Date__c, Project_Stage__c, Platform__c, CreatedById, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, Campaign_Countries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id = : campaignHelper.selectedProject.Id];

        }
    }

    /*
    Description: Method called on VF to update Split related to Project 
    */
    public pageReference setAgencyHubSplit() {
        agencyHubSplitListToInsertOnEdit = new List < Oblix_Marketing_SOW_Project_Splits__c > ();
        agencyHubSplitListToUpdate = new List < Oblix_Marketing_SOW_Project_Splits__c > ();
        agencyHubSplitListToDelete = new List < Oblix_Marketing_SOW_Project_Splits__c > ();
        agencyHubSplitListToInsert = new List < Oblix_Marketing_SOW_Project_Splits__c > ();
        agencyHubSplitWrapperList = (List < AgencyHubSplitWrapper > ) JSON.deserialize(agencyHubSplitWrapperListJSONString, List < AgencyHubSplitWrapper > .class);

        Oblix_Marketing_SOW_Project_Splits__c agencySplitInstanceJS;
        for (AgencyHubSplitWrapper agencyWrapper: agencyHubSplitWrapperList) {
            agencySplitInstanceJS = new Oblix_Marketing_SOW_Project_Splits__c();
            if (agencyWrapper.countryId != null && agencyWrapper.countryId != '') {
                agencySplitInstanceJS.OblixCountry__c = agencyWrapper.countryId;
            }
            if (agencyWrapper.splitPercentage != null && agencyWrapper.splitPercentage.equalsIgnoreCase('')) {
                agencySplitInstanceJS.Percentage__c = Decimal.valueOf('0');
            } else {
                agencySplitInstanceJS.Percentage__c = Decimal.valueOf(agencyWrapper.splitPercentage);
            }
            if (agencyWrapper.existingId != null && agencyWrapper.existingId != '') {
                agencySplitInstanceJS.Id = Id.valueOf(agencyWrapper.existingId);
                agencyHubSplitListToUpdate.add(agencySplitInstanceJS);
            }
            if ((agencyWrapper.existingId != null && agencyWrapper.existingId != '') && (agencySplitInstanceJS.Percentage__c == 0 || agencySplitInstanceJS.Percentage__c == null)) {
                agencyHubSplitListToDelete.add(agencySplitInstanceJS);
            }
            if (agencyWrapper.existingId == null || agencyWrapper.existingId == '' && campaignHelper.isEdit) {
                agencySplitInstanceJS.Project_Splits__c = campaignHelper.selectedProject.Id;
                agencyHubSplitListToInsertOnEdit.add(agencySplitInstanceJS);
            }
            if (agencyWrapper.existingId == null || agencyWrapper.existingId == '' && !campaignHelper.isEdit) {
                agencyHubSplitListToInsert.add(agencySplitInstanceJS);
            }
        }

        System.DEBUG('agencyHubSplitListToUpdate : ' + agencyHubSplitListToUpdate);
        System.DEBUG('agencyHubSplitListToDelete : ' + agencyHubSplitListToDelete);
        System.DEBUG('agencyHubSplitListToInsertOnEdit : ' + agencyHubSplitListToInsertOnEdit);
        System.DEBUG('agencyHubSplitListToInsert : ' + agencyHubSplitListToInsert);
        return saveProjectAction();
    }

    public void setCampaignStages() {
        campaignHelper.selectedProject.Completed_Stage__c = stage_identifier.s_selected_completed_stage;
        campaignHelper.selectedProject.Projected_Stage__c = stage_identifier.s_selected_projected_stage;
        campaignHelper.selectedProject.Percentage_of_Fee_for_this_FY__c = stage_identifier.sow_project_in_scope.Percentage_of_Fee_for_this_FY__c;

    }

    public void setInvestmentPriority() {
        if (campaignHelper.selectedBrandInnovation != null) {
            campaignHelper.selectedProject.Innovation_Projects__c = Label.Oblix_Lbl_Innovation_Projects_Innovation;
        } else {
            campaignHelper.selectedProject.Innovation_Projects__c = Label.Oblix_Lbl_Innovation_Projects_BrandLedGrowth;
        }
        if (campaignHelper.selectedProject.Innovation_Projects__c == Label.Oblix_Lbl_Innovation_Projects_Innovation) {
            campaignHelper.selectedProject.Brand_Led_Growth__c = campaignHelper.selectedBrandInnovation;
        } else {
            campaignHelper.selectedProject.Brand_Led_Growth__c = campaignHelper.selectedBrandBrand;
        }
        system.debug('### project.Brand_Led_Growth__c : ' + campaignHelper.selectedProject.Brand_Led_Growth__c);
    }

    /*
    Description: Used to Insert/update Project 
    @return : page reference  7 if new ,6 if Edit
    */
    public pageReference saveProjectAction() {
        try {
            // set b_initiated_from_vf_page on trigger to avoid setting Project_Scale_2__c value
            Oblix_SplitHandler.b_initiated_from_vf_page = true;
            //setAgencyHubSplit();
            setCampaignStages();
            //setCountriesRegions();
            setInvestmentPriority();

            if (campaignHelper.isEdit) {
                update campaignHelper.selectedProject;
                System.DEBUG(agencyHubSplitListToDelete);
                if (agencyHubSplitListToDelete != null) {
                    delete agencyHubSplitListToDelete;
                }
                if (agencyHubSplitListToUpdate != null) {
                    update agencyHubSplitListToUpdate;
                }
                if (agencyHubSplitListToInsertOnEdit != null) {
                    insert agencyHubSplitListToInsertOnEdit;
                }
                return reDirectToCampaignSummary();
            } else {
                insert campaignHelper.selectedProject;
                setProjectInAgencyHubSplitList();
                insert agencyHubSplitListToInsert;
                return reDirectToAddAsset();
            }

        } catch (DMLException le) {
            if (le.getMessage().contains('DUPLICATES_DETECTED')) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Duplicate Value Found with the same Campaign Name'));
            }
            System.debug('###Error Occured : ' + le.getMessage());
            return null;
        }

    }

    private void setProjectInAgencyHubSplitList() {
        for (Oblix_Marketing_SOW_Project_Splits__c eachAgencySplit: agencyHubSplitListToInsert) {
            eachAgencySplit.Project_Splits__c = campaignHelper.selectedProject.Id;
        }
    }

    public pageReference BackAction() {
        if (!campaignHelper.isEdit) {
            return new pageReference('/apex/oblix_sowmaindetail?sowId=' + campaignHelper.selectedProject.Financial_Year__c);
        } else {
            return new pageReference('/apex/oblix_campaignsummary?projectId=' + campaignHelper.selectedProject.Id);
        }
        return null;
    }

    public PageReference reDirectToCampaignSummary() {
        PageReference campaignSummaryPage = new PageReference('/apex/oblix_campaignsummary?projectId=' + campaignHelper.selectedProject.Id);
        campaignSummaryPage.setRedirect(true);
        return campaignSummaryPage;
    }

    public PageReference reDirectToAddAsset() {
        PageReference newSOW = new PageReference('/apex/Oblix_CampaignAddAsset?projectId=' + campaignHelper.selectedProject.Id);
        newSOW.setRedirect(true);
        return newSOW;
    }

    public class AgencyHubSplitWrapper {
        String splitPercentage {
            get;
            set;
        }
        String existingId {
            get;
            set;
        }
        String countryId {
            get;
            set;
        }
        Boolean isUpdate {
            get;
            set;
        }
        Boolean isDelete {
            get;
            set;
        }
        Boolean isInsert {
            get;
            set;
        }

        public AgencyHubSplitWrapper(String splitPercentage, String existingId, String countryId) {
            this.splitPercentage = splitPercentage;
            this.existingId = existingId;
            this.countryId = countryId;
        }
    }

}