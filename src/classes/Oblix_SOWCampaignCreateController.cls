public with sharing class Oblix_SOWCampaignCreateController extends Oblix_SWOPparentController {

    public Oblix_CampaignStageLogic stage_identifier {get; set;}
    public Oblix_CampaignCreateHelper campaignHelper {get; set;}
    public transient String agencyHubSplitWrapperListJSONString {get; set;}
    public transient String selectedMainRegions {get; set;}
    public String cloneName {get; set;}

    public List <AgencyHubSplitWrapper > agencyHubSplitWrapperList {
        get {
            if (agencyHubSplitWrapperList == null) {
                agencyHubSplitWrapperList = new List < AgencyHubSplitWrapper > ();
            }
            return agencyHubSplitWrapperList;
        }
        set;
    }

    @TestVisible private List <Oblix_Marketing_SOW_Project_Splits__c> agencyHubSplitListToInsert;
    @TestVisible private List <Oblix_Marketing_SOW_Project_Splits__c> agencyHubSplitListToUpdate;
    @TestVisible private List <Oblix_Marketing_SOW_Project_Splits__c> agencyHubSplitListToDelete;

    public Oblix_SOWCampaignCreateController() {
        
        campaignHelper = new Oblix_CampaignCreateHelper();
        
        if (campaignHelper.isEdit) {
            stage_identifier = new Oblix_CampaignStageLogic(campaignHelper.selectedProject, Oblix_PermissionHandler.canSetProjectedStage(campaignHelper.selectedSow.SOW_Status__c), Oblix_PermissionHandler.canSetCompletionStage(campaignHelper.selectedSow.SOW_Status__c));
        } else {
            stage_identifier = new Oblix_CampaignStageLogic(campaignHelper.selectedSow.Id);
        }
    }

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

        campaignHelper.selectedProject.First_3_selected_countries__c = getFirst3Countries(campaignHelper.selectedProject.Selected_Countries__c);
        
        System.debug('First 3 Selected Countries: ' + campaignHelper.selectedProject.First_3_selected_countries__c);

        System.DEBUG('Set Changes Countries : ' + campaignHelper.selectedProject.Campaign_Countries__c);
        System.DEBUG('Set Changes Region : ' + campaignHelper.selectedProject.OblixRegion__c);
        setCampaignScaleOne(selectedMainRegions, tempCountries);
    }


    private String getFirst3Countries(String selectedCountries) {
        String result = '';

        Integer clusterCount = -1;
        if (selectedCountries.contains('/')) {
            String clusterString = selectedCountries.split('/')[0];
            clusterCount = clusterString.split(',').size();
        }

        //Prepare a list of up to 3 first clusters and/or countries
        List<String> first3Countries = new List<String>();
        Integer countryCounter = 0;
        System.debug('Selected Countries: ' + selectedCountries);
        for(String country : selectedCountries.split('[/,]')){
            if (countryCounter == clusterCount) {
                result += '/';
            } else if (countryCounter > 0) {
                result += ', ';
            }
            result += country.trim();
            countryCounter++;
            if (countryCounter >= 3) {
                break;
            }
        }

        return result;
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
                campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Utils.getOblixSettingLabel('SCORE_INNOVATION_PROJECT_MARKET_1');    
                //campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market1;
            } else if (lstCountriesString.size() > 1 && lstCountriesString.size() <= 5) {
                campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Utils.getOblixSettingLabel('SCORE_INNOVATION_PROJECT_MARKET_2');
                //campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market2;
            } else if (lstCountriesString.size() > 5 && lstCountriesString.size() <= 10) {
                campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Utils.getOblixSettingLabel('SCORE_INNOVATION_PROJECT_MARKET_3');
                //campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market3;
            } else if (lstCountriesString.size() > 10 && lstCountriesString.size() <= 15) {
                campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Utils.getOblixSettingLabel('SCORE_INNOVATION_PROJECT_MARKET_4');
                //campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market4;
            } else if (lstCountriesString.size() > 15) {
                campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Utils.getOblixSettingLabel('SCORE_INNOVATION_PROJECT_MARKET_5');
                //campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market5;
            }
        } else {
            campaignHelper.selectedProject.Project_Scale_1__c = null;
        }
        if (campaignHelper.selectedProject.OblixRegion__c != null && campaignHelper.selectedProject.OblixRegion__c.startsWith('Global')) {
            campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Utils.getOblixSettingLabel('SCORE_INNOVATION_PROJECT_MARKET_5');
            //campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market5;
        }
        System.DEBUG('Project Scale Set : ' + campaignHelper.selectedProject.Project_Scale_1__c);
    }

    public void setCampaignScaleOneGlobal() {
        campaignHelper.selectedProject.Project_Scale_1__c = Oblix_Utils.getOblixSettingLabel('SCORE_INNOVATION_PROJECT_MARKET_5');
        campaignHelper.selectedProject.OblixRegion__c = 'Global';
        campaignHelper.selectedProject.Campaign_Countries__c = 'Global';
        campaignHelper.selectedProject.Selected_Countries__c = campaignHelper.selectedProject.Campaign_Countries__c;

        campaignHelper.selectedProject.First_3_selected_countries__c = getFirst3Countries(campaignHelper.selectedProject.Selected_Countries__c);
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
        } else {// if (campaignHelper.numberOFSelectedCountries > 4 && campaignHelper.numberOFSelectedCountries <= 5) {
            campaignHelper.selectedProject.Project_Scale_2__c = 'Up to 5 locations';
        } //} else if (campaignHelper.numberOFSelectedCountries > 5) {
        //    campaignHelper.selectedProject.Project_Scale_2__c = 'More than 5 locations';
        //}
        System.DEBUG('Project Scale : ' + campaignHelper.selectedProject.Project_Scale_2__c);
    }


    /*
    Description: Method called on VF to update project with new infoDrivers
    */
    //public void setInfoDrivers() {

    //    system.debug('###selectedBrandBrand : ' + campaignHelper.selectedBrandBrand);
    //    system.debug('###selectedBrandInnov : ' + campaignHelper.selectedBrandInnovation);

    //    if (campaignHelper.isEdit) {
    //        if (campaignHelper.selectedProject.Innovation_Projects__c == Label.Oblix_Lbl_Innovation_Projects_Innovation) {
    //            campaignHelper.selectedProject.Brand_Led_Growth__c = campaignHelper.selectedBrandInnovation;
    //        } else {
    //            campaignHelper.selectedProject.Brand_Led_Growth__c = campaignHelper.selectedBrandBrand;
    //        }
    //        update campaignHelper.selectedProject;
    //        campaignHelper.selectedProject = [Select Id, Name, Innovation_Projects__c, ProjectTotalAssetscore__c, Jobs_to_be_Done__c, Campaign_Fees_Total__c, Completed_Stage__c, Financial_Year__r.currency__c, Projected_Stage__c, Financial_Year__r.Financial_Year__c, Financial_Year__r.Name, BET_first_release__c, Value_to_be_paid_in_Current_FY__c, Campaign_Status__c, Preview_Date__c, Start_of_TV_production__c, Final_release__c, Live_Date__c, Live_date_Asset_delivery__c, Date_for_Assets_to_be_in_BET__c, Timescale_Notes__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c, Project_Finish_Date__c, Project_Stage__c, Platform__c, CreatedById, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, Campaign_Countries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id = : campaignHelper.selectedProject.Id];

    //    }
    //}

    /*
    Description: Method called on VF to update Split related to Project 
    */
    public pageReference setAgencyHubSplit() {
        agencyHubSplitListToUpdate = new List <Oblix_Marketing_SOW_Project_Splits__c>();
        agencyHubSplitListToDelete = new List <Oblix_Marketing_SOW_Project_Splits__c>();
        agencyHubSplitListToInsert = new List <Oblix_Marketing_SOW_Project_Splits__c>();
        agencyHubSplitWrapperList = (List < AgencyHubSplitWrapper > ) JSON.deserialize(agencyHubSplitWrapperListJSONString, List < AgencyHubSplitWrapper > .class);

        Oblix_Marketing_SOW_Project_Splits__c agencySplitInstanceJS;
        for (AgencyHubSplitWrapper agencyWrapper: agencyHubSplitWrapperList) {
            // populate sobject
            agencySplitInstanceJS = new Oblix_Marketing_SOW_Project_Splits__c();
            agencySplitInstanceJS.Id = String.isEmpty(agencyWrapper.existingId) ? null : Id.valueOf(agencyWrapper.existingId);
            agencySplitInstanceJS.OblixCountry__c = String.isEmpty(agencyWrapper.countryId) ? null : agencyWrapper.countryId;
            agencySplitInstanceJS.Percentage__c = String.isEmpty(agencyWrapper.splitPercentage) ? 0 : Decimal.valueOf(agencyWrapper.splitPercentage);

            // sort in the appropriate list
            if(agencySplitInstanceJS.Id == null && agencySplitInstanceJS.OblixCountry__c != null && agencySplitInstanceJS.Percentage__c != 0){
                agencyHubSplitListToInsert.add(agencySplitInstanceJS);
            } else if(agencySplitInstanceJS.Id != null && agencySplitInstanceJS.OblixCountry__c != null && agencySplitInstanceJS.Percentage__c != 0){
                agencyHubSplitListToUpdate.add(agencySplitInstanceJS);
            } else if(agencySplitInstanceJS.Id != null){
                agencyHubSplitListToDelete.add(agencySplitInstanceJS);
            }

            

            /*if (agencyWrapper.countryId != null && agencyWrapper.countryId != '') {
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
            if (agencyWrapper.existingId == null || agencyWrapper.existingId == '') {
                agencyHubSplitListToInsert.add(agencySplitInstanceJS);
            }*/
        }

        System.DEBUG('agencyHubSplitListToUpdate : ' + agencyHubSplitListToUpdate);
        System.DEBUG('agencyHubSplitListToDelete : ' + agencyHubSplitListToDelete);
        System.DEBUG('agencyHubSplitListToInsert : ' + agencyHubSplitListToInsert);
        return saveProjectAction();
    }

    public void setCampaignStages() {
        campaignHelper.selectedProject.Completed_Stage_CFY__c = stage_identifier.s_selected_completed_stage;
        campaignHelper.selectedProject.Projected_Stage_CFY__c = stage_identifier.s_selected_projected_stage;
        campaignHelper.selectedProject.Percentage_of_Fee_for_this_FY__c = stage_identifier.sow_project_in_scope.Percentage_of_Fee_for_this_FY__c;

    }

    public void setInvestmentPriority() {
        
        if (campaignHelper.selectedBrandInnovation != null) {
            campaignHelper.selectedProject.Innovation_Projects__c = Oblix_Utils.getOblixSettingValueByName('INNOVATION_LABEL');
        } else {
            campaignHelper.selectedProject.Innovation_Projects__c = Oblix_Utils.getOblixSettingValueByName('BRAND_LED_GROWTH_LABEL');
        }

        if (campaignHelper.selectedProject.Innovation_Projects__c == Oblix_Utils.getOblixSettingValueByName('INNOVATION_LABEL')) {
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
        Savepoint sp;
        try {
            sp = Database.setSavepoint();
            // set b_initiated_from_vf_page on trigger to avoid setting Project_Scale_2__c value
            Oblix_SplitHandler.b_initiated_from_vf_page = true;
            //setAgencyHubSplit();
            setCampaignStages();
            //setCountriesRegions();

            //Skip setting investment priority if this campaign is for NFY and in the middle of rollover
            //because then only Projected Chevron is editable and no other fields appear on the page
            //Should still execute if that cmapaign is cloned!
            if (!campaignHelper.onlyShowProjectedChevron) {
                setInvestmentPriority();
            }

            System.debug('### saveProjectAction');
            System.debug('### campaignHelper.isEdit: ' + campaignHelper.isEdit);
            System.debug('### campaignHelper.doClone: ' + campaignHelper.doClone);
            System.debug('### campaignHelper.is_NFY_campaign_in_the_middle_of_rollover: ' + campaignHelper.is_NFY_campaign_in_the_middle_of_rollover);

            campaignHelper.selectedProject.Campaign_Attributes_Updated__c = true;

            if (campaignHelper.isEdit && !campaignHelper.doClone && !campaignHelper.is_NFY_campaign_in_the_middle_of_rollover) { //Editing campaign that is not NFY and in the middle of Roll Over

                setProjectInAgencyHubSplitList(campaignHelper.selectedProject.Id);
                if (agencyHubSplitListToDelete != null && !agencyHubSplitListToDelete.isEmpty()) delete agencyHubSplitListToDelete;
                if (agencyHubSplitListToUpdate != null && !agencyHubSplitListToUpdate.isEmpty()) update agencyHubSplitListToUpdate;
                if (agencyHubSplitListToInsert != null && !agencyHubSplitListToInsert.isEmpty()) insert agencyHubSplitListToInsert;

                update campaignHelper.selectedProject;
                return reDirectToCampaignSummary();

            } else if(!campaignHelper.doClone && !campaignHelper.is_NFY_campaign_in_the_middle_of_rollover){ //New campaign
                System.debug('### New campaign');

                insert campaignHelper.selectedProject;

                setProjectInAgencyHubSplitList(campaignHelper.selectedProject.Id);
                insert agencyHubSplitListToInsert;

                return reDirectToAddAsset();

            } else if (campaignHelper.doClone) { //Clone
                System.debug('### Clone');

                if(campaignHelper.selectedProject.Name.equals(cloneName.trim())){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter a new unique name for campaign'));
                    return null;
                }
                Oblix_SOW_Projects__c projectClone = campaignHelper.selectedProject.clone(false, true, false, false);
                projectClone.Name_Prefix__c = cloneName;
                insert projectClone;

                setProjectInAgencyHubSplitList(projectClone.Id);
                System.DEBUG('clonedAgencyHubSplitListToInsert : ' + agencyHubSplitListToInsert);
                insert agencyHubSplitListToInsert;

                List<Oblix_Project_Assets__c> assets = cloneCampaignAssets(projectClone.Id);
                insert assets;
                campaignHelper.selectedProject = projectClone;
                return reDirectToCampaignSummary();

            } else { //Editing NFY campaign in the middle of Roll Over
                System.debug('### Editing NFY campaign in the middle of Roll Over');

                update campaignHelper.selectedProject;
                return reDirectToCampaignSummary();
            }

        } catch (DMLException le) {
            if (le.getMessage().contains('DUPLICATES_DETECTED') || le.getMessage().contains('DUPLICATE_VALUE')) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Duplicate Value Found with the same Campaign Name'));
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, le.getMessage()));
            }
            System.debug('###Error Occured : ' + le.getMessage());

            if(sp != null) Database.rollback(sp);
            return null;
        }

    }

    private List<Oblix_Project_Assets__c> cloneCampaignAssets(Id projectCloneId){
        List<Oblix_Project_Assets__c> assets = [SELECT Actual_Delivery_Date__c,Additional_Description__c,Agency_Projects__c,Asset_Description__c,Asset_name__c,Asset_Picklist__c,Asset_Scoring_Number__c
                            ,Asset_Title__c,Asset_Total_Score__c,Asset_Type__c,Calculator_Question__c,Category__c,Channels__c,FULL_Description__c,Location__c,Name, Description__c
                            ,OblixClonedFromParentAsset__c,Option_Name__c,Quantity__c,RecordTypeId,Sub_Category__c,SystemModstamp,Target_Delivery_Date__c,MDM_id__c,Asset_Score__c
                        FROM Oblix_Project_Assets__c WHERE Agency_Projects__c =: campaignHelper.selectedProject.Id];
        List<Oblix_Project_Assets__c> assetClones = new List<Oblix_Project_Assets__c>();
        for(Oblix_Project_Assets__c asset : assets){
            Oblix_Project_Assets__c assetClone = asset.clone(false, true, false, false);
            assetClone.Agency_Projects__c = projectCloneId;
            assetClones.add(assetClone);
        }
        return assetClones;
    }

    private void setProjectInAgencyHubSplitList(Id projectId) {
        for (Oblix_Marketing_SOW_Project_Splits__c eachAgencySplit: agencyHubSplitListToInsert) {
            eachAgencySplit.Project_Splits__c = projectId;
        }
        if(campaignHelper.doClone){
            for (Oblix_Marketing_SOW_Project_Splits__c eachAgencySplit: agencyHubSplitListToUpdate) {
                Oblix_Marketing_SOW_Project_Splits__c agencyHubSplitClone = eachAgencySplit.clone(false, true, false, false);
                agencyHubSplitClone.Project_Splits__c = projectId;
                agencyHubSplitListToInsert.add(agencyHubSplitClone);
            }
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


    // Wrapper class for agency hub splits on VF page
    public class AgencyHubSplitWrapper {
        String splitPercentage {get; set;}
        String existingId {get; set;}
        String countryId {get; set;}
        Boolean isUpdate {get; set;}
        Boolean isDelete {get; set;}
        Boolean isInsert {get; set;}

        public AgencyHubSplitWrapper(String splitPercentage, String existingId, String countryId) {
            this.splitPercentage = splitPercentage;
            this.existingId = existingId;
            this.countryId = countryId;
        }
    }

}