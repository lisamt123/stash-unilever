/**
@Author Cognizant 
@Name IPM_RolloutPlansAddLocalController
@CreateDate 27/04/2015
@Description    This class is used for adding new rollouts to the project. It is used for displaying MDO Specific Geographies and Countries. 
                User selects MCO and Countries from the Page and are send for rollout Processing.
                Handles building of core Rollout Data, creating relationships between rollouts, countries and regional Rollouts.
                Adds and removes Rollouts/Countries based on user selection.
                Switching of rolloutType is handled in this class.
@Version 1.0
@reference IPM_RolloutPlansAdd VF page, IPM_RolloutPlansRegional VF page
*/
public with sharing class IPM_RolloutPlansAddLocalController extends IPM_ProjectIntermediateController {
    public String projectId {get; set;} //project id of the current project
    public Boolean isCompleted{get; set;} 
    public String globalCountries{get; set;} //Collection of (comma seperated) selected global country codes passed from Visualforce
    public String globalUnselectedCountries{get; set;} //Collection of (comma seperated) unselected global country codes passed from Visualforce
    public Boolean NO_COUNTRY_SELECTED{get;set;}
    public Map<String, IPM_Country__c> mapIPMCountries{get;set;} //Map of counries that have already been added to this project
    public Map<String, GeographyWrapper> mapMCOWrappers {get; set;} //Map of MCO Wrappers
    public List<GeographyWrapper> lstClusterWrappers {get; set;} //List of Market Cluster Wrappers to be displayed
    public List<GeographyWrapper> lstMCOWrappers {get; set;} //List of MCO Wrappers to be displayed
    public List<GeographyWrapper> lstCountryWrappers {get; set;} //List of Counry Wrappers to be displayed 
    public String selectedCluster {get; set;} //Selected Market Cluster Code
    public String previouselectedMCO {get; set;} //Previous Selected Market Clustter Code
    public String selectedMCO {get; set;} //Selected MCO Code
    public Boolean selectedKey {get; set;} //Selected Key MCO
    public Boolean isEditable{get;set;} //Boolean Variable to define if the record is editable by the current logged in user
    public Boolean isError {get; set;} //Boolean variable to indicate error on page
    public String errorMessage {get; set;} //Error Message to be displayed on the page
    public String searchCountry{get;set;}// Hold country name to search
    public Boolean isNoResult{get;set;}//checking for rollout search
    public Boolean updateRollouts{get;set;}
    public IPM_Country__c countryProj;   
    public Set<Id> projPurgeIdSet = new Set<Id>();
    public Map<String,IPM_Country__c> existingRelatedCountriesMap;
    public Map<String,Set<String>> relatedMCOAndCountry;
    public String projectCategory{get;set;}
    public String UFS = 'UFS';
    @TestVisible private Map<String, GeographyWrapper> mapCountryWrappers; //Map of Country Wrappers
    @TestVisible private Map<String, GeographyWrapper> mapClusterWrappers; //Map of Market Cluster Wrappers
    @TestVisible private Map<String, MDO_Geography__c> mapUnileverCountries; //Map of Unilever Countries - generated from mdm_Geography__c object //change-1
    @TestVisible private Set<String> setCountryCodesGlobal; //Set of selected Global Country codes generated from passed Visualforce sring
    @TestVisible private Set<String> setCountryCodesGlobalUnselected; //Set of unselected Global Country codes generated from passed Visualforce sring
    @TestVisible private Map<String,IPM_Country__c> mapExistingCountries; //Map of existing counttries
    @TestVisible private Map<String,IPM_Country__c> mapUpsertCountries; //List of countries that need to be upserted
    @TestVisible private Map<String,IPM_Country__c> deleteCountriesMap; //List of countries that need o be deleted 
    @TestVisible private static String NOT_ASSIGNED_CLUSTER_CODE = 'GEO0071'; //Cluster Code not to be used for display (Not Assigned values)
    @TestVisible private static final String CLASS_NAME = IPM_RolloutPlansAddLocalController.class.getName();
    @TestVisible private static final String SEARCH_ROLLOUT_COUNTRY = 'searchRolloutCountry'; //Method Name for Exception Logging
    @TestVisible private static final String GENERATE_ROLLOUTS = 'generateRollouts'; //Method Name for Exception Logging
    @TestVisible private static final String CANCEL = 'cancel'; //Method Name for Exception Logging    
    @TestVisible private static final String GET_UNILEVER_COUNTRIES = 'getUnileverCountries'; //Method Name for Exception Logging  
    @TestVisible private static final String GENERATE_SUBWRAPPERS = 'generateSubWrappers'; //Method Name for Exception Logging 
    @TestVisible private static final String SelectQueryString ='Id,parent_L2__r.name,parent_L2__r.mdm_id__c,parent_L2__r.geography_type__c,parent_L2__r.parent_L2__c,parent_L2__r.parent_L2__r.Name,parent_L2__r.parent_L2__r.mdm_id__c,parent_L2__r.parent_L2__r.geography_type__c FROM MDO_Geography__c';
    Set<String> phaseTobeIncluded = new Set<String>{IPM_ConstantUtils.PHASE_IDEAS, IPM_ConstantUtils.PHASE_FEASIBILITY, IPM_ConstantUtils.PHASE_CAPABILITY};
   
    public String strMCOKeyHelp {
        get {
                return Label.IPM_KEY_MCO_NEEDS;
        }
        set;
    }
    /**
     *  @Description Constructor of the class 
     *  @name IPM_RolloutPlansAddLocalController
     *  @param NONE
     *  @return NONE
     *  @throws NONE
     */
    public IPM_RolloutPlansAddLocalController() {
        IPM_IECompatible.ieFix(); //For IE Compatibility
        isCompleted = false;
        selectedMCO = null;
        initializeRollouts();
        // To disable the MCO selection on Add/Manage Rollout Screen
        IPM_Project_Type__c currentProjecttype = IPM_Utils.retrieveProjectType(project);

        
    }
    /**
     *  @Description Method invoked from class constructor
     *  @name initializeRollouts
     *  @param NONE
     *  @return NONE
     *  @throws Exception
     */
    public void initializeRollouts() {
        searchCountry = null;
        isNoResult = false;
        projectCategory = project.IPM_Category_Text__c;
        projectId = ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
        if (projectId != null) {
            isEditable = IPM_Utils.getIPMRollOutUser(projectId);
            if (!isEditable) {
                errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO, Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            }
            getUnileverCountries();
            generateWrappers();
            generateSubWrappers();

        }
    }
    /**
     *  @Description Method to search Unilever Geographies countries for rollout
     *  @name searchRolloutCountry
     *  @param NONE
     *  @return NONE
     *  @throws Exception
     */
    public void searchRolloutCountry() {
        try {
            if (searchCountry != null && searchCountry != '') {
                //GET A LIST OF ALL IPM COUNTRIES
                String likePerStr = '%';
                String queryString = 'SELECT ';
                //MDM Geography . //change-2
                for (String field: Schema.SObjectType.MDO_Geography__c.fields.getMap().KeySet()) {
                    if (!field.equalsIgnoreCase(IPM_ConstantUtils.SF_ID)) {
                        queryString += field + ', ';
                    }
                } // query changes required following bottom up approach like from country to cluster /country group (parent_L2__r.name) / cluster parent_L2__r.parent_L2__r.name
                queryString += SelectQueryString + ' WHERE (Name LIKE \'' + String.escapeSingleQuotes(searchCountry) + likePerStr + '\' OR parent_L2__r.name LIKE \'' + String.escapeSingleQuotes(searchCountry) + likePerStr + '\') AND(Name!=null OR parent_L2__r.Name!=null OR parent_L2__r.parent_L2__r.Name!=null)';
                // change for UFS country search
                if (projectCategory.contains(UFS)) {
                    queryString += ' AND geography_type__c = \'' + IPM_ConstantUtils.IPM_GEOGRAPHY_UFS_COUNTRY + '\' AND parent_L2__r.geography_type__c =\'' + IPM_ConstantUtils.IPM_GEOGRAPHY_UFS_COUNTRYGROUP + '\' AND parent_L2__r.Name =\'' + project.IPM_Company_Card__r.IPM_MCO__c + '\' AND Status__c =' + IPM_ConstantUtils.ACTIVE_STRING + ' AND parent_L2__r.parent_L2__r.Status__c =' + IPM_ConstantUtils.ACTIVE_STRING + ' AND parent_L2__r.Status__c =' + IPM_ConstantUtils.ACTIVE_STRING + '  AND parent_L2__r.parent_L2__r.geography_type__c =\'' + IPM_ConstantUtils.IPM_GEOGRAPHY_UFS_UNILEVERCLUSTER + '\'  AND parent_L2__r.parent_L2__r.Name =\'' + project.IPM_Company_Card__r.IPM_Market_Cluster__c + '\' AND Excluded_Apps__c EXCLUDES ( \'' + IPM_ConstantUtils.IPM_Excluded_Apps + '\') ORDER BY parent_L2__r.parent_L2__r.name,parent_L2__r.name,Name';

                } else {
                    queryString += ' AND geography_type__c = \'' + IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRY + '\' AND parent_L2__r.geography_type__c =\'' + IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRYGROUP + '\' AND parent_L2__r.Name =\'' + project.IPM_Company_Card__r.IPM_MCO__c + '\' AND Status__c =' + IPM_ConstantUtils.ACTIVE_STRING + ' AND parent_L2__r.parent_L2__r.Status__c =' + IPM_ConstantUtils.ACTIVE_STRING + ' AND parent_L2__r.Status__c =' + IPM_ConstantUtils.ACTIVE_STRING + '  AND parent_L2__r.parent_L2__r.geography_type__c =\'' + IPM_ConstantUtils.IPM_GEOGRAPHY_UNILEVERCLUSTER + '\'  AND parent_L2__r.parent_L2__r.Name =\'' + project.IPM_Company_Card__r.IPM_Market_Cluster__c + '\' AND Excluded_Apps__c EXCLUDES ( \'' + IPM_ConstantUtils.IPM_Excluded_Apps + '\') ORDER BY parent_L2__r.parent_L2__r.name,parent_L2__r.name,Name';

                }
                queryString+= ' LIMIT 10000';
                mapUnileverCountries = new Map<String, MDO_Geography__c>(); 
              
                for(MDO_Geography__c geography : Database.query(queryString))
                {
                    if(((project.IPM_Company_Card__r.IPM_Market_Cluster__c==geography.Name || project.IPM_Company_Card__r.IPM_Market_Cluster__c==geography.parent_L2__r.Name || 
                        project.IPM_Company_Card__r.IPM_Market_Cluster__c==geography.parent_L2__r.parent_L2__r.Name) && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL))
                    {
                        mapUnileverCountries.put(geography.ISO_3166_1_Code__c, geography);
                    } 
                    else {
                        continue;
                    }
                }
                if (!mapUnileverCountries.isEmpty()) {
                    generateWrappers();
                    generateSubWrappersForSearch();
                    isNoResult = false;

                } else {

                    lstClusterWrappers = new List < GeographyWrapper > ();
                    lstMCOWrappers = new List < GeographyWrapper > ();
                    lstCountryWrappers = new List < GeographyWrapper > ();
                    isNoResult = true;
                }
            } else {
                initializeRollouts();
            }
        } catch (Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), CLASS_NAME, SEARCH_ROLLOUT_COUNTRY, ex.getMessage(), ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);

            lstClusterWrappers = new List < GeographyWrapper > ();
            lstMCOWrappers = new List < GeographyWrapper > ();
            lstCountryWrappers = new List < GeographyWrapper > ();
            isNoResult = true;
        }
    }

    /**
     *  @Description Method to generate map of Unilever Geographies
     *  @name getUnileverCountries
     *  @param NONE
     *  @return NONE
     *  @throws Exception
     */
    @TestVisible private void getUnileverCountries() {

        //GET A LIST OF ALL IPM COUNTRIES
        String queryString = 'SELECT ';
        //MDM Geography  MDO
        For(String field: Schema.SObjectType.MDO_Geography__c.fields.getMap().KeySet()) { 
            if (!field.equalsIgnoreCase(IPM_ConstantUtils.SF_ID)) {
                queryString += field + ', ';
            }
        }
        queryString += SelectQueryString; // change-13
        // changes for food solutions
        if (projectCategory.contains(UFS)) {
            queryString += ' WHERE geography_type__c = \'' + IPM_ConstantUtils.IPM_GEOGRAPHY_UFS_COUNTRY + '\' AND parent_L2__r.geography_type__c =\'' + IPM_ConstantUtils.IPM_GEOGRAPHY_UFS_COUNTRYGROUP + '\' AND parent_L2__r.Name =\'' + project.IPM_Company_Card__r.IPM_MCO__c + '\' AND Status__c =' + IPM_ConstantUtils.ACTIVE_STRING + ' AND parent_L2__r.parent_L2__r.Status__c =' + IPM_ConstantUtils.ACTIVE_STRING + ' AND parent_L2__r.Status__c =' + IPM_ConstantUtils.ACTIVE_STRING + ' AND parent_L2__r.parent_L2__r.geography_type__c =\'' + IPM_ConstantUtils.IPM_GEOGRAPHY_UFS_UNILEVERCLUSTER + '\'  AND parent_L2__r.parent_L2__r.Name =\'' + project.IPM_Company_Card__r.IPM_Market_Cluster__c + '\' AND Excluded_Apps__c EXCLUDES ( \'' + IPM_ConstantUtils.IPM_Excluded_Apps + '\') ORDER BY parent_L2__r.parent_L2__r.name,parent_L2__r.name,Name';
        } else {
            queryString += ' WHERE geography_type__c = \'' + IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRY + '\' AND parent_L2__r.geography_type__c =\'' + IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRYGROUP + '\' AND parent_L2__r.Name =\'' + project.IPM_Company_Card__r.IPM_MCO__c + '\' AND Status__c =' + IPM_ConstantUtils.ACTIVE_STRING + ' AND parent_L2__r.parent_L2__r.Status__c =' + IPM_ConstantUtils.ACTIVE_STRING + ' AND parent_L2__r.Status__c =' + IPM_ConstantUtils.ACTIVE_STRING + '  AND parent_L2__r.parent_L2__r.geography_type__c =\'' + IPM_ConstantUtils.IPM_GEOGRAPHY_UNILEVERCLUSTER + '\'  AND parent_L2__r.parent_L2__r.Name =\'' + project.IPM_Company_Card__r.IPM_Market_Cluster__c + '\' AND Excluded_Apps__c EXCLUDES ( \'' + IPM_ConstantUtils.IPM_Excluded_Apps + '\') ORDER BY parent_L2__r.parent_L2__r.name,parent_L2__r.name,Name';
        }
        queryString += ' LIMIT 10000';
        
        try {

            mapUnileverCountries = new Map < String, MDO_Geography__c > (); //change-

            for (MDO_Geography__c geography: Database.query(queryString)) {
                mapUnileverCountries.put(geography.ISO_3166_1_Code__c, geography);

            }
        } catch (Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), CLASS_NAME, GET_UNILEVER_COUNTRIES, ex.getMessage(), ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);

            isError = TRUE;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO, Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }

    }

    /**
    *  @Description Method to Used for creating Wrapper which contains MCO related information and corresponding Countries.This wrapper is fetcing MCO based on
    *               the project type having isActive flag true.It will fecth respective cluster,MCO and country from Geography wrapper.Then prepare a map for rollout generation for selected Geography. 
       The selected geogrpahy is updated in formula field of country object.This will check for already selected MCO or new MCO for wrapper generation.
        Used for displaying selected countries and Whether MCO needs to be enabled or disabled based on various conditions.
    *  @name generateWrappers
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    @TestVisible private void generateWrappers() {
        //GET A LIST OF ALL IPM COUNTRIES
        String queryString = 'SELECT ';
        //IPM Country
        for (String field: Schema.SObjectType.IPM_Country__c.fields.getMap().KeySet()) {
            if (!field.equalsIgnoreCase(IPM_ConstantUtils.SF_ID)) {
                queryString += field + ', ';
            }
        }
        queryString += 'IPM_Local_Project__r.IPM_No_Rollout_Disabled__c,Local_Rollout__r.KeyMCO__c,Local_Rollout__r.IPM_Project_Job_Status__c, Local_Rollout__r.Market_Cluster__c, Local_Rollout__r.MCO__c,Id FROM IPM_Country__c WHERE IPM_Local_Project__c =: projectId AND IsActive__c = true LIMIT 50000 ';

        mapIPMCountries = new Map < String, IPM_Country__c > (); 

        for (IPM_Country__c ipmCountry: Database.query(queryString)) {
            mapIPMCountries.put(ipmCountry.Country_Code__c, ipmCountry);
        }
        generateWrapperHelper();
    }
    /**
    *  @Description Method to Used for creating Wrapper which contains MCO related information and corresponding Countries.This wrapper is fetcing MCO based on
    *               the project type having isActive flag true.It will fecth respective cluster,MCO and country from Geography wrapper.Then prepare a map for rollout generation for selected Geography. 
       The selected geogrpahy is updated in formula field of country object.This will check for already selected MCO or new MCO for wrapper generation.
        Used for displaying selected countries and Whether MCO needs to be enabled or disabled based on various conditions.
    *  @name generateWrappersHelper
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    private void generateWrapperHelper() {
        
        mapClusterWrappers = new Map < String, GeographyWrapper > ();
        mapMCOWrappers = new Map < String, GeographyWrapper > ();
        mapCountryWrappers = new Map < String, GeographyWrapper > ();

        lstClusterWrappers = new List < GeographyWrapper > ();

        Map < String, String > mapClusterToMCOCode = new map < String, String > ();
        
        setCountryCodesGlobal = new Set < String > ();
        
        for (MDO_Geography__c country: mapUnileverCountries.values()) { 
            if (country.parent_L2__r.parent_L2__r.mdm_id__c != null && country.parent_L2__r.parent_L2__r.name != null) {
                String MDOClusterCode = country.parent_L2__r.parent_L2__r.mdm_id__c;
                String MDOMCOCode = country.parent_L2__r.mdm_id__c;

                if (MDOClusterCode != NOT_ASSIGNED_CLUSTER_CODE) {
                    //cluster code 
                    //Cluster
                    GeographyWrapper clusterWrapper = new GeographyWrapper(MDOClusterCode, country.parent_L2__r.parent_L2__r.name, IPM_ConstantUtils.EMPTY_STRING_INITIAL);
                    if (mapClusterWrappers.containsKey(MDOClusterCode)) {
                        clusterWrapper = mapClusterWrappers.get(MDOClusterCode);
                    }

                    GeographyWrapper mcoWrapper = new GeographyWrapper(MDOMCOCode, country.parent_L2__r.name, country.parent_L2__r.parent_L2__r.mdm_id__c);

                    if (mapMCOWrappers.containsKey(MDOMCOCode)) {
                        mcoWrapper = mapMCOWrappers.get(MDOMCOCode);
                    }

                    //Country
                    GeographyWrapper countryWrapper = new GeographyWrapper(country.ISO_3166_1_Code__c, country.Name, MDOMCOCode);
                    // call the function
                    
                    updateWrapperListOnCountrySelection(clusterWrapper, mcoWrapper, countryWrapper, country, MDOClusterCode, MDOMCOCode);
          
                    mapClusterWrappers.put(MDOClusterCode, clusterWrapper);

                    mapMCOWrappers.put(MDOMCOCode, mcoWrapper);
                    mapCountryWrappers.put(country.ISO_3166_1_Code__c, countryWrapper);
                }
            }    
        }
        prepareGeographyWrappeprData(); 


    }
    /**
    *  @Description Method to Used for creating Wrapper which contains MCO related information and corresponding Countries.This wrapper is fetcing MCO based on
    *               the project type having isActive flag true.It will fecth respective cluster,MCO and country from Geography wrapper.Then prepare a map for rollout generation for selected Geography. 
       The selected geogrpahy is updated in formula field of country object.This will check for already selected MCO or new MCO for wrapper generation.
        Used for displaying selected countries and Whether MCO needs to be enabled or disabled based on various conditions.
    *  @name updateWrapperListOnCountrySelection
    *  @param  clusterWrapper,mcoWrapper,countryWrapper,country,MDOClusterCode,MDOMCOCode, mapClusterToMCOCode
    *  @return Set<String>
    *  @throws Exception
    */
    private void updateWrapperListOnCountrySelection(GeographyWrapper clusterWrapper, GeographyWrapper mcoWrapper, GeographyWrapper countryWrapper, MDO_Geography__c country, String MDOClusterCode, String MDOMCOCode) {
        // If country has been selected update the wrapper list
        if (mapIPMCountries.containsKey(country.ISO_3166_1_Code__c)) {
            //Key MCO
            IPM_Country__c countryObj = mapIPMCountries.get(country.ISO_3166_1_Code__c);

            String countryClusterCode = countryObj.Market_Cluster_Code__c;
            String countryMCOCode = countryObj.MCO_Code__c;

            if (countryClusterCode == MDOClusterCode) {
                clusterWrapper.rolloutPresentAtCluster = true;
            }

            if (countryMCOCode == MDOMCOCode) {
                mcoWrapper.rolloutPresentAtMCO = true;
                updateRollouts = true;
            }
            if((project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL))
            {
              updateRollouts = true;
            }
      //system.debug('inside updateWrapperListOnCountrySelection');
            countryWrapper.selected = TRUE; // selected country 
            setCountryCodesGlobal.add(country.ISO_3166_1_Code__c);

        }

    }
  
  /**
     *  @Description Method to Used for selection of first selected cluster and set the value for lstclusterWrapper
     *  @name prepareGeographyWrappeprData
     *  @param None
     */
    private void prepareGeographyWrappeprData() {
        lstClusterWrappers = sortWrappersByName(mapClusterWrappers.values()); 
        selectFirstSelectedCluster();

    }
    /**
     *  @Description Method to Used for selection of first selected cluster and set the value for selected cluster
     *  @name updateWrapperListOnCountrySelection
     *  @param None
     */
    private void selectFirstSelectedCluster() {
        
        for (GeographyWrapper clusterWrapper: lstClusterWrappers) {
            if (((selectedCluster == null) || (IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(selectedCluster))) && (!clusterWrapper.clusterDisabled)) {
                selectedCluster = clusterWrapper.code;
            }
        }
        if (((selectedCluster == NULL) || (IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(selectedCluster))) && (lstClusterWrappers != null && !lstClusterWrappers.isEmpty())) {
            selectedCluster = lstClusterWrappers[0].code;
        }

    }

    /**
     *  @Description Method to generate various sub wrappers used for display
     *  @name generateSubWrappersForSearch
     *  @param NONE
     *  @return NONE
     *  @throws Exception
     */
    @TestVisible private void generateSubWrappersForSearch() {

        lstMCOWrappers = new List < GeographyWrapper > ();
        lstCountryWrappers = new List < GeographyWrapper > ();

        //MCO SUB WRAPPERS

        if (lstClusterWrappers != NULL && !lstClusterWrappers.isEmpty()) {
            selectedCluster = lstClusterWrappers[0].code;
        }

        for (GeographyWrapper mcoWrapper: mapMCOWrappers.values()) {
            lstMCOWrappers.add(mcoWrapper);
        }
        if (!lstMCOWrappers.isEmpty()) {
            lstMCOWrappers = sortWrappersByName(lstMCOWrappers);

            if ((lstMCOWrappers[0].code != NULL) || (lstMCOWrappers[0].code != IPM_ConstantUtils.EMPTY_STRING_INITIAL)) {
                selectedMCO = lstMCOWrappers[0].code;
                previouselectedMCO = lstMCOWrappers[0].code;
            }
        }

        //COUNTRY SUB WRAPPERS
        for (GeographyWrapper countryWrapper: mapCountryWrappers.values()) {
            if (setCountryCodesGlobal.contains(countryWrapper.code)) {
              system.debug('inside generateSubWrappersForSearch');
                countryWrapper.selected = true;
            }
  
          lstCountryWrappers.add(countryWrapper);
        }
        lstCountryWrappers = sortWrappersByName(lstCountryWrappers);
        selectedKey = mapMCOWrappers.get(selectedMCO).key;
        mapMCOWrappers.get(previouselectedMCO).key = selectedKey;


    }

    /**
     *  @Description Method to generate various sub wrappers used for display
     *  @name generateSubWrappers
     *  @param NONE
     *  @return NONE
     *  @throws Exception
     */
    @TestVisible private void generateSubWrappers() {
        try {
            lstMCOWrappers = new List < GeographyWrapper > ();
            lstCountryWrappers = new List < GeographyWrapper > ();

            //MCO SUB WRAPPERS
            for (GeographyWrapper mcoWrapper: mapMCOWrappers.values()) {
                if (mcoWrapper.parentCode.equalsIgnoreCase(selectedCluster)) {
                    lstMCOWrappers.add(mcoWrapper);
                }
            }
            lstMCOWrappers = sortWrappersByName(lstMCOWrappers);

            selectMCO(lstMCOWrappers);

            //COUNTRY SUB WRAPPERS

            for (GeographyWrapper countryWrapper: mapCountryWrappers.values()) {

                if (countryWrapper.parentCode.equalsIgnoreCase(selectedMCO)) {
                    if (setCountryCodesGlobal.contains(countryWrapper.code)) {
                      system.debug('inside generatesubwrapper');
                        countryWrapper.selected = true;
                    }
                    lstCountryWrappers.add(countryWrapper);
                }
            }


            lstCountryWrappers = sortWrappersByName(lstCountryWrappers);
            if (selectedMCO != null) {
                selectedKey = mapMCOWrappers.get(selectedMCO).key;
            }


        } catch (Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), CLASS_NAME, GENERATE_SUBWRAPPERS, ex.getMessage(), ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            isError = TRUE;
            errorMessage = Label.IPM_PLEASE_CONTACT_ADMINISTRATOR;
        }
    }

    /**
     *  @Description Method get selected and previously selected MCO
     *  @name selectedMCO
     *  @param lstMCOWrappers
     *  @return NONE
     */
    private void selectMCO(List < GeographyWrapper > lstMCOWrappers) {

        if (!lstMCOWrappers.isEmpty() && (selectedMCO == NULL) || (IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(selectedMCO))) {
            selectedMCO = lstMCOWrappers[0].code;

            previouselectedMCO = lstMCOWrappers[0].code;
        }
    }

    
    /**
    *  @Description Method to generate and save rollout records
    *  @name generateRollouts
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    public void generateRollouts() {
        System.SavePoint rollOutSavepoint = Database.setSavePoint();
        try {

            processCountryCodeLists();

            processRollouts();

            initializeRollouts();
            isCompleted = true;
        } 
        catch (Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), CLASS_NAME, GENERATE_ROLLOUTS, ex.getMessage(), ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            Database.Rollback(rollOutSavepoint);
            isError = TRUE;
            errorMessage = Label.IPM_Generic_ErrorMessage;
        }
    }

    /**
     *  @Description Method to redirect back to the rollouts page
     *  @name cancel
     *  @param NONE
     *  @return NONE
     *  @throws Exception
     */
    public PageReference cancel() {
        try {
            PageReference rolloutPlans = Page.IPM_RolloutPlans;
            rolloutPlans.getParameters().put(IPM_ConstantUtils.SF_ID, projectId);
            rolloutPlans.getParameters().put('cancelRedirect', 'true');
            rolloutPlans.setRedirect(true);
            return rolloutPlans;

        } catch (Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), CLASS_NAME, CANCEL, ex.getMessage(), ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);

            isError = TRUE;
            errorMessage = Label.IPM_Generic_ErrorMessage;
            return null;
        }
    }

    /**
    *  @Description Method to process various country codes selected as part of User operation.
         setCountryCodesGlobal - Contains information about selected MCO's at global level.
         setCountryCodesMCOs - Contains selection of Countries selected by user in VF Page.
         Eventually we will have the list which contains selections for MCO, Countries from User.
    *  @name processCountryCodeLists
    *  @param NONE
    *  @return NONE
    */
    @TestVisible private void processCountryCodeLists() {
        //INITIALISE
        //Global

        if (setCountryCodesGlobal == null) {
            setCountryCodesGlobal = new Set < String > ();
        }

        if (setCountryCodesGlobalUnselected == null) {
            setCountryCodesGlobalUnselected = new Set < String > ();
        }

     processCountryCodeListHelper();

    }
    /**
      *  @Description Method to process various country codes selected as part of User operation.
           setCountryCodesGlobal - Contains information about selected MCO's at global level.
           setCountryCodesMCOs - Contains selection of Countries selected by user in VF Page.
           Eventually we will have the list which contains selections for MCO, Countries from User.
      *  @name processCountryCodeListsHelper
      *  @param NONE
      *  @return NONE
      */
    private void processCountryCodeListHelper() {
        //PROCESS GLOBAL - ADD the values to the existing list
        if (globalUnselectedCountries != null && globalUnselectedCountries != IPM_ConstantUtils.EMPTY_STRING_INITIAL) {
            List < String > lstTemp = globalUnselectedCountries.split(IPM_ConstantUtils.COMMA);
            setCountryCodesGlobalUnselected.addAll(lstTemp);
        }
        if (globalCountries != null && globalCountries != IPM_ConstantUtils.EMPTY_STRING_INITIAL) 
        {
            NO_COUNTRY_SELECTED = false;
            List < String > lstTemp = globalCountries.split(IPM_ConstantUtils.COMMA);
            setCountryCodesGlobal.addAll(lstTemp);

            if (!lstTemp.isEmpty()) {
                setCountryCodesGlobal.addAll(lstTemp);
                for (String countryCode: lstTemp) {
                    if (setCountryCodesGlobalUnselected.contains(countryCode)) {
                        setCountryCodesGlobalUnselected.remove(countryCode);
                    }
                }
            }
        }
        
        setCountryCodesGlobal.removeAll(setCountryCodesGlobalUnselected);
    }
    
    /**
    *  @Description Method to generate and save rollout records.
        This method creates MCO and Country Specific rollouts based on User selection. 
        Also it is responsible for Creating Core data for MCO and county specific rollouts like TLD's, key,Non Key, Rollout Name and relationships.
        Also unselected MCO and Countries are evaluated whether there are corresponding MCO or country rollouts and performs deletion of such rollouts.
    *  @name processRollouts
    *  @param NONE
    *  @return NONE
    */
    @TestVisible private void processRollouts() {
        
        mapExistingCountries = new Map < String, IPM_Country__c > ();
        mapUpsertCountries = new Map < String, IPM_Country__c > (); 
        deleteCountriesMap = new Map < String, IPM_Country__c > (); 
        
        //Countries
        String queryString = 'SELECT Id, IPM_Local_Project__c, Country_Code__c, Country_Name__c,AddedAtStage__c,IPM_CharterApproved__c,isActive__c,Project_Country__c, IPM_Rollout_Status__c, IPM_Regional_Project__c,Local_Rollout_Charter__c FROM IPM_Country__c WHERE IPM_Local_Project__c =: projectId AND isActive__c = true LIMIT 10000';
       // queryString += 'WHERE IPM_Local_Project__c =: projectId AND isActive__c = true LIMIT 10000';
        
        for (IPM_Country__c country: Database.query(queryString)) {
            if (IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(searchCountry)) {
                mapExistingCountries.put(country.Project_Country__c, country);
            }
            
            //putting map for delete unselected countries
            if(!setCountryCodesGlobal.contains(country.Country_Code__c)){
              deleteCountriesMap.put(country.Project_Country__c, country);
            }
        }
        associateCountry();
    
    if(mapUpsertCountries.isEmpty()){
          NO_COUNTRY_SELECTED = true;
        }
        else{
        processCountry();
      }
    }
    
    /**
    *  @Description Method to generate mapUpsertCountryMap based on values of selected countries in countryWrapper.       
    *  @name associateCountry
    *  @param NONE
    *  @return NONE
    */
        
    private void associateCountry() {
      //Iterate over setCountryCodesGlobal
      for(String countryCode : setCountryCodesGlobal){
        String countryExternalId = project.IPM_Project_Name__c + IPM_ConstantUtils.UNDERSCORE + countryCode;
        MDO_Geography__c geography = mapUnileverCountries.get(countryCode);
        IPM_Country__c ipmCountry = null;
        if (mapExistingCountries.containsKey(countryExternalId)) {
            ipmCountry = mapExistingCountries.get(countryExternalId); 
        }
        else {
          
      if (mapUpsertCountries.containsKey(countryExternalId)) {
                ipmCountry = mapUpsertCountries.get(countryExternalId);
            } else {
                //Add new country to existing MCO rollout
                ipmCountry = new IPM_Country__c(
                    Project_Country__c = countryExternalId,
                    AddedAtStage__c = project.IPM_Phase__c,
                    IPM_Local_Project__c = Project.Id
                );
            }
        }
    
        if (ipmCountry != null) {
    
            ipmCountry.isActive__c = true;
    
            ipmCountry.MDO_Geography__c = geography.Id;
            ipmCountry.IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO;
    
    
            ipmCountry.IPM_Local_Project__c = project.Id;
    
            if (deleteCountriesMap.containsKey(ipmCountry.Project_Country__c)) {
                deleteCountriesMap.remove(ipmCountry.Project_Country__c);
            }
            if (!ipmCountry.isActive__c) {
                ipmCountry.AddedAtStage__c = project.IPM_Phase__c;
            }
            mapUpsertCountries.put(ipmCountry.Project_Country__c, ipmCountry);
        }
      }
  
  }
  /**
    *  @Description Method to upsert mapUpsertCountryMap and prepare deletecountrymap based on values of selected countries in countryWrapper.       
    *  @name processCountry
    *  @param NONE
    *  @return NONE
    */
    
    @TestVisible private void processCountry() {
        if (!deleteCountriesMap.isEmpty()) {
            Map < Id, IPM_Country__c > filteredDeleteCountryMap = new Map < Id, IPM_Country__c > ();
            // Before deleting Query the Countries again to validate whether certain countries got deleted as part of Rollout Deletion.
            List < IPM_Country__c > countryListToDelete = [Select Id, Project_Country__c, IPM_Local_Project__c, IPM_Local_Project__r.IPM_PrepareForArchival__c, IPM_CharterApproved__c, isActive__c from IPM_Country__c where Project_Country__c in: deleteCountriesMap.KeySet() AND isActive__c = true];
            for (IPM_Country__c country: countryListToDelete) {
                if (country.IPM_Local_Project__c != null && country.IPM_Local_Project__r.IPM_PrepareForArchival__c) {
                    country.isActive__c = true;
                    mapUpsertCountries.put(country.Project_Country__c, country);
                } else if (country.IPM_CharterApproved__c) {
                    country.isActive__c = false;
                    mapUpsertCountries.put(country.Project_Country__c, country);
                } else {
                    filteredDeleteCountryMap.put(country.Id, country);
                }
            }
            delete filteredDeleteCountryMap.values();
        }
        
        if (!mapUpsertCountries.isEmpty()) {
   
            upsert mapUpsertCountries.values() Project_Country__c;
        }
    }

   
    /**
     *  @Description Method to sort the list of geography wrappers alphabetically
     *  @name sortWrappersByName
     *  @param wrappersToSort     List of unsorted Wrappers
     *  @return List of Sorted Wrappers
     *  @throws Exception
     */
    @TestVisible private List < GeographyWrapper > sortWrappersByName(List < GeographyWrapper > wrappersToSort) {

        if (wrappersToSort == null || wrappersToSort.size() <= 1) {
            return wrappersToSort;
        }

        List < GeographyWrapper > lessWrappers = new List < GeographyWrapper > ();
        List < GeographyWrapper > greaterWrappers = new List < GeographyWrapper > ();

        integer pivot = wrappersToSort.size() / 2;

        //save the pivot and remove it from the selectOption list
        GeographyWrapper pivotWrapper = wrappersToSort[pivot];
        wrappersToSort.remove(pivot);

        for (GeographyWrapper wrapper: wrappersToSort) {
            if (wrapper.name <= pivotWrapper.name) {
                lessWrappers.add(wrapper);
            } else if (wrapper.name > pivotWrapper.name) {
                greaterWrappers.add(wrapper);
            }
        }

        List < GeographyWrapper > sortedWrappers = new list < GeographyWrapper > ();

        sortedWrappers.addAll(sortWrappersByName(lessWrappers));
        sortedWrappers.add(pivotWrapper);
        sortedWrappers.addAll(sortWrappersByName(greaterWrappers));

        return sortedWrappers;

    }

   
    /** 
     * @Description Wrapper class for Geography
     */
    public class GeographyWrapper {
        public String code {get; set;}
        public String name {get; set;}
        public String parentCode {get; set;}
        public String rolloutStatus {get; set;}        
        public Boolean key {get; set;}
        public Boolean selected {get; set;}
        public Boolean clusterDisabled {get; set;}
        public boolean rolloutPresentAtCluster{get;set;} 
        public Boolean mcoDisabled {get; set;}
        public boolean rolloutPresentAtMCO{get;set;}
        public Boolean countryDisabled {get; set;}
        public Boolean noRolloutDisabled {get; set;}

        public GeographyWrapper(String code, String name, String parentCode) {
            this.code = code;
            this.name = name;
            this.parentCode = parentCode;
            this.key = false;
            this.selected = false;
            this.clusterDisabled = false;
            this.mcoDisabled = false;
            this.countryDisabled = false;
            this.noRolloutDisabled = false;
            this.rolloutPresentAtCluster = false;
            this.rolloutPresentAtMCO = false;
        }
    }
}