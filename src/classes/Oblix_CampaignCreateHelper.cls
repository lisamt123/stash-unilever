public with sharing class Oblix_CampaignCreateHelper extends Oblix_SWOPparentController {

    private final String GLOBAL_REGION = 'Global';
    private transient Schema.DescribeFieldResult lstProjectBV = Oblix_SOW_Projects__c.Brand_Led_Growth__c.getDescribe();
    private transient List < Schema.PickListEntry > projectBrandInnovationOptionsPicklistValues = lstProjectBV.getPickListValues();
    public transient Integer numberOFSelectedCountries {
        get;
        set;
    }

    public String sowId {
        get {
            if (sowId == null) {
                sowId = ApexPages.currentPage().getParameters().get('sowId');
            }
            return sowId;
        }
        set;
    }

    public String projectId {
        get {
            if (projectId == null) {
                projectId = ApexPages.currentPage().getParameters().get('projectId');
            }
            return projectId;
        }
        set;
    }

    public Boolean doClone {
        get{
            if(doClone == null){
                doClone = ApexPages.currentPage().getParameters().containsKey('clone') && ApexPages.currentPage().getParameters().get('clone') == 'true';
            }
            return doClone;
        }
        set;
    }

    public Boolean isEdit {
        get {
            if (projectId == null) {
                isEdit = false;
            } else if (projectId != null) {
                isEdit = true;
            }
            return isEdit;
        }
        private set;
    }

    public Boolean isGlobalCampaign {
        get {
            if (selectedProject.OblixRegion__c != null && selectedProject.OblixRegion__c.startsWith(GLOBAL_REGION)) {
                isGlobalCampaign = true;

            } else {
                isGlobalCampaign = false;
            }
            return isGlobalCampaign;
        }
        private set;
    }

    public Oblix_SOW_Projects__c selectedProject {get;set;}

    public Marketing_SOW__c selectedSow {
        get {
            if (selectedSow == null && sowId != null) {
                selectedSow = [SELECT Id, Name, Financial_Year__c FROM Marketing_SOW__c WHERE ID = : sowId];
            }
            return selectedSow;
        }
        set;
    }

    @testvisible
    private String financialYear {
        get {
            If(selectedSow != null && financialYear == null) {
                financialYear = selectedSow.financial_Year__c;
            } else If(selectedProject != null && financialYear == null) {
                financialYear = selectedProject.Financial_Year__r.Financial_Year__c;
            }
            return financialYear;
        }
        set;
    }

    @testvisible
    private List < Oblix_Calculator__c > countriesByFinancialYear {
        get {
            if (countriesByFinancialYear == null) {
                countriesByFinancialYear = [select Name, OblixCountry__c from Oblix_Calculator__c where recordType.Name = 'Country Box Number'
                    and Financial_Year__c = : financialYear order by name
                ];
            }
            return countriesByFinancialYear;
        }
        set;
    }

    @testvisible
    private Map < Id, MDO_Geography__c > countriesMap {
        get {
            if (countriesMap == null) {
                countriesMap = new Map < Id, MDO_Geography__c > ([Select Id, parent_L4__c, geography_type__c, Name, parent_L4__r.Name, parent_L4__r.geography_type__c From MDO_Geography__c 
                                                                    where geography_type__c = 'Country' OR geography_type__c = 'Country Geography' order by name
                ]);
            }
            return countriesMap;
        }
        set;
    }

    @testvisible
    private Map < String, Set < String >> regionsWithCountriesMap {
        get {
            if (regionsWithCountriesMap == null && countriesMap != null) {
                regionsWithCountriesMap = new Map < String, Set < String >> ();
                for (MDO_Geography__c eachCountry: countriesMap.values()) {
                    if (!regionsWithCountriesMap.containsKey(eachCountry.parent_L4__r.Name)) {
                        regionsWithCountriesMap.put(eachCountry.parent_L4__r.Name, new Set < string > {eachCountry.Name});
                    } else {
                        regionsWithCountriesMap.get(eachCountry.parent_L4__r.Name).add(eachCountry.Name);
                    }
                }
                regionsWithCountriesMap.remove('Not assigned Unilever Cluster');
            }
            return regionsWithCountriesMap;
        }
        set;
    }

    public Map < String, String > countriesWithRegionsMap {
        get {
            if (countriesWithRegionsMap == null && regionsWithCountriesMap != null) {
                countriesWithRegionsMap = new Map < String, String > ();
                for (String eachRegion: regionsWithCountriesMap.keySet()) {
                    for (String eachCountry: regionsWithCountriesMap.get(eachRegion)) {
                        if (!countriesWithRegionsMap.containsKey(eachCountry)) {
                            countriesWithRegionsMap.put(eachCountry, eachRegion);
                        }
                    }
                }
            }
            return countriesWithRegionsMap;
        }
        set;
    }

    public List < String > allCountries {
        get {
            if (allCountries == null) {
                allCountries = new List < String > (countriesWithRegionsMap.keyset());
                allCountries.sort();
            }
            return allCountries;
        }
        set;
    }

    public Set < String > unileverRegions {
        get {
            if (unileverRegions == null) {
                unileverRegions = new Set < String > ();
                unileverRegions = regionsWithCountriesMap.keySet();
            }
            return unileverRegions;
        }
        set;
    }

    public String regionsWithCountriesMapJSON {
        get {
            if (regionsWithCountriesMapJSON == null) {
                regionsWithCountriesMapJSON = JSON.serialize(regionsWithCountriesMap);
            }
            return regionsWithCountriesMapJSON;
        }
        set;
    }

    public String selectedCountriesJSON {
        get {
            if (selectedCountriesJSON == null && isEdit && selectedProject.Campaign_Countries__c != null) {
                List < String > regionSeperatedList = new List < String > ();
                List < String > selectedCountriesList = new List < String > ();
                regionSeperatedList = selectedProject.Campaign_Countries__c.split('/');
                if (regionSeperatedList != null && regionSeperatedList.size() > 1) {
                    selectedCountriesList = regionSeperatedList[1].split(',');
                }
                selectedCountriesJSON = JSON.serialize(selectedCountriesList);
            }
            return selectedCountriesJSON;
        }
        set;
    }

    public String selectedMainRegionJSON {
        get {
            if (selectedMainRegionJSON == null && isEdit && selectedProject.Campaign_Countries__c != null) {
                List < String > regionSeperatedList = new List < String > ();
                List < String > mainRegionsList = new List < String > ();
                regionSeperatedList = selectedProject.Campaign_Countries__c.split('/');
                if (regionSeperatedList[0] != null) {
                    mainRegionsList = regionSeperatedList[0].split(',');
                }
                selectedMainRegionJSON = JSON.serialize(mainRegionsList);
            }
            return selectedMainRegionJSON;
        }
        set;
    }

    public String selectedRegionsJSON {
        get {
            if (selectedRegionsJSON == null && isEdit && selectedProject.OblixRegion__c != null) {
                selectedRegionsJSON = JSON.serialize(selectedProject.OblixRegion__c.split(','));
            }
            return selectedRegionsJSON;
        }
        set;
    }

    @testvisible
    private Map < String, Id > countryIdsMap {
        get {
            if (countryIdsMap == null) {
                countryIdsMap = new Map < String, Id > ();
                for (MDO_Geography__c country: countriesMap.values()) {
                    countryIdsMap.put(country.name.toUpperCase(), country.id);
                }
            }
            return countryIdsMap;
        }
        set;
    }

    /*private List<Schema.PickListEntry> projectBrandInnovationOptionsPicklistValues{
        get{
            if(projectBrandInnovationOptionsPicklistValues == null){
                projectBrandInnovationOptionsPicklistValues = lstProjectBV.getPickListValues();
            }
            return projectBrandInnovationOptionsPicklistValues;
        }
        set;
    }*/

    public List < SelectOption > countryOptions {
        get {
            if (countryOptions == null) {
                countryOptions = new List < SelectOption > ();
                countryOptions.add(new SelectOption('', '-None-'));
                if (!countriesByFinancialYear.isEmpty()) {
                    for (Oblix_Calculator__c eachCountry: countriesByFinancialYear) {
                        if (countryIdsMap.get(eachCountry.name.toUpperCase()) != null) {
                            countryOptions.add(new SelectOption(countryIdsMap.get(eachCountry.name.toUpperCase()), eachCountry.Name.toUpperCase()));
                        }
                    }
                }
            }
            return countryOptions;
        }
        set;
    }

    public List < SelectOption > innovationOptions {
        get {
            if (innovationOptions == null) {
                innovationOptions = new List < SelectOption > ();
                innovationOptions.add(new SelectOption('', ' Business Value Creation - INNOVATION PROJECTS '));
                for (Schema.PickListEntry eachPickListValue: projectBrandInnovationOptionsPicklistValues) {
                    if (!eachPickListValue.getLabel().contains('€')) {
                        innovationOptions.add(new SelectOption(eachPickListValue.getLabel(), eachPickListValue.getLabel()));
                    }
                }
            }
            return innovationOptions;
        }
        set;
    }

    public List < SelectOption > brandOptions {
        get {
            if (brandOptions == null) {
                brandOptions = new List < SelectOption > ();
                brandOptions.add(new SelectOption('', ' Business Value Creation - BRAND LED GROWTH '));
                for (Schema.PickListEntry eachPickListValue: projectBrandInnovationOptionsPicklistValues) {
                    if (eachPickListValue.getLabel().contains('€')) {
                        brandOptions.add(new SelectOption(eachPickListValue.getLabel(), eachPickListValue.getLabel()));
                    }
                }
            }
            return brandOptions;
        }
        set;
    }

    public List < Oblix_Marketing_SOW_Project_Splits__c > agencySplitHubs {
        get {
            if (agencySplitHubs == null && isEdit) {
                agencySplitHubs = new List < Oblix_Marketing_SOW_Project_Splits__c > ();
                agencySplitHubs = [Select Id, Name, OblixCountry__c, Project_Splits__c, OblixCountry__r.name, Percentage__c from Oblix_Marketing_SOW_Project_Splits__c where Project_Splits__c = : selectedProject.Id];
                checkAgencySplitHubSize();
            } else if (agencySplitHubs == null) {
                return createFiveInstancesOFMarketingSplits();
            }
            return agencySplitHubs;
        }
        set;
    }

    public Integer numberOfAgencyHubSplits {
        get {
            if (numberOfAgencyHubSplits == null) {
                numberOfAgencyHubSplits = agencySplitHubs.size();
            }
            return numberOfAgencyHubSplits;
        }
        set;
    }


    public Boolean onlyShowProjectedChevron {
        get {
            return !doClone && is_NFY_campaign_in_the_middle_of_rollover;
        }
    }

    

    public String selectedBrandBrand {get;set;}

    public String selectedBrandInnovation {get;set;}

    public Oblix_CampaignCreateHelper() {
        if (projectId != null) {
            selectedProject = [SELECT ID, Name, Brand_Led_Growth__c, Innovation_Projects__c, Financial_Year__r.Financial_Year__c, Financial_Year__r.Name, Campaign_Idea__c,
                OblixRegion__c, Campaign_Countries__c, Selected_Countries__c, First_3_selected_countries__c, Project_Scale_1__c, Project_Scale_2__c, Project_Priority__c,
                Project_Start_Date__c, Projected_Stage_CFY__c, Completed_Stage_CFY__c, Projected_Stage_PFY__c, Completed_Stage_PFY__c, Value_To_BePaid_Manual_Override__c,
                First_Air_Date__c, Preview_Date__c, Project_Completion_Date__c, BET_first_release__c, Value_to_be_paid_in_Current_FY__c, Campaign_Attributes_Updated__c,
                Final_release__c, Campaign_Total_Fees__c, Description__c, Platform__c, Jobs_to_be_Done__c, Percentage_of_Fee_for_this_FY__c, Campaign_Status__c, Name_Prefix__c, 
                Campaign_PFY__c,Oblix_ProjectBoxNumber_PFY__c, Percentage_of_Fees_PFY__c, Fees_Paid_PFY__c, Fees_PFY_Paid_Using_CFY_Calc__c, Total_Project_Score_PFY__c, Campaign_PFY__r.Financial_Year__r.SOW_Status__c FROM Oblix_SOW_Projects__c WHERE ID = : projectId
            ];

            // if we are cloning, blank out the PFY fields in case the campaign is being cloned from a rolled-over campaign
            if (doClone){
                selectedProject.Box_Number_PFY__c = NULL;
                selectedProject.Box_Number_PFY_Project_Score_CFY_Calc__c = NULL;
                selectedProject.Campaign_PFY__c = NULL;
                selectedProject.Oblix_ProjectBoxNumber_PFY__c = NULL;
                selectedProject.Completed_Stage_PFY__c = NULL;
                
                selectedProject.Completed_Stage_CFY__c = NULL;
                selectedProject.Projected_Stage_CFY__c = Oblix_Utils.CAMPAIGN_STAGES_ALL;
                selectedProject.Percentage_of_Fee_for_this_FY__c = 100;

                selectedProject.Projected_Stage_PFY__c = NULL;
                selectedProject.Total_Project_Score_PFY__c = NULL;
                selectedProject.Percentage_of_Fees_PFY__c = NULL;
                selectedProject.Fees_Paid_PFY__c = NULL;
                selectedProject.Fees_Total_PFY__c = NULL;
                selectedProject.Fees_PFY_Paid_Using_CFY_Calc__c = NULL;
                selectedProject.Fees_PFY_Total_By_CFY_Calculator__c = NULL;

                // make sure we set the campaign attributes updated to true to include in the next batch job
                selectedProject.Campaign_Attributes_Updated__c = true;            
            }

        }else{
            selectedProject = new Oblix_SOW_Projects__c();
            selectedProject.Financial_Year__c = sowId;
        }

        //Update Parent controller link to Campaign to leverage existing methods.
        selected_project = selectedProject;


        if (selectedProject.Innovation_Projects__c == Oblix_Utils.getOblixSettingValueByName('INNOVATION_LABEL')) {
            selectedBrandInnovation = selectedProject.Brand_Led_Growth__c;
        } else {
            selectedBrandBrand = selectedProject.Brand_Led_Growth__c;
        }
    }

    private List < Oblix_Marketing_SOW_Project_Splits__c > createFiveInstancesOFMarketingSplits() {
        agencySplitHubs = new List < Oblix_Marketing_SOW_Project_Splits__c > ();
        for (integer i = 0; i < 5; i++) {
            if (agencySplitHubs.size() < 5 || agencySplitHubs.isEmpty()) {
                Oblix_Marketing_SOW_Project_Splits__c projectSplitInstance = new Oblix_Marketing_SOW_Project_Splits__c();
                projectSplitInstance.Project_Splits__c = projectId;
                agencySplitHubs.add(projectSplitInstance);
            }
        }
        return agencySplitHubs;
    }

    private void checkAgencySplitHubSize() {
        if (agencySplitHubs.size() < 5) {
            for (integer i = agencySplitHubs.size() - 1; i < 5; i++) {
                if (agencySplitHubs.size() < 5 || agencySplitHubs.isEmpty()) {
                    Oblix_Marketing_SOW_Project_Splits__c projectSplitInstance = new Oblix_Marketing_SOW_Project_Splits__c();
                    projectSplitInstance.Project_Splits__c = projectId;
                    agencySplitHubs.add(projectSplitInstance);
                }
            }
        }
    }
}