/**
@Author Cognizant 
@Name IPM_RolloutPlansAddController
@CreateDate 27/04/2015
@Description This class is used for adding new rollouts to the project
@Version 1.0
@reference IPM_RolloutPlansAdd VF page, IPM_RolloutPlansRegional VF page
*/
public with sharing class IPM_RolloutPlansAddController extends IPM_ProjectIntermediateController
{    
    public String projectId {get; set;} //project id of the current project
    // public IPM_Project__c project {get; set;} //The project record for which the rollouts are being viewed
    
    public Boolean isCompleted{get; set;}
    private Set<String> setCountryCodesGlobal; //Set of selected Global Country codes generated from passed Visualforce sring
    private Set<String> setCountryCodesGlobalUnselected; //Set of unselected Global Country codes generated from passed Visualforce sring
    private Set<String> setCountryCodesMCOs; //Set of selected Regional MCO Country codes generated from passed Visualforce sring
    private Set<String> setCountryCodesMCOsUnselected; //Set of unselected Regional MCO Country codes generated from passed Visualforce sring
    private Set<String> setCountryCodes; //Set of selected Regional Country codes generated from passed Visualforce sring
    private Set<String> setCountryCodesUnselected; //Set of unselected Regional Country codes generated from passed Visualforce sring
    private Set<String> setCountryNoRolls; //Set of selected Regional No Rollouts Country codes generated from passed Visualforce sring
    private Set<String> setCountryNoRollsUnselected; //Set of unselected Regional No Rollouts Country codes generated from passed Visualforce sring
    
    public String globalCountries{get; set;} //Collection of (comma seperated) selected global country codes passed from Visualforce
    public String globalUnselectedCountries{get; set;} //Collection of (comma seperated) unselected global country codes passed from Visualforce
    public String regionalMco{get; set;} //Collection of (comma seperated) selected regional mco country codes passed from Visualforce
    public String regionalUnselectedMco{get; set;} //Collection of (comma seperated) unselected regional mco country codes passed from Visualforce
    public String regionalCountry{get; set;} //Collection of (comma seperated) selected regional country codes passed from Visualforce
    public String regionalUselectedCountry{get; set;} //Collection of (comma seperated) unselected regional country codes passed from Visualforce
    public String regionalNoRoll{get; set;} //Collection of (comma seperated) selected regional no rollouts country codes passed from Visualforce
    public String regionalUnselectedNoRoll{get; set;} //Collection of (comma seperated) unselected regional no rollouts country codes passed from Visualforce
    
    private Map<String, MDO_Geography__c> mapUnileverCountries; //Map of Unilever Countries - generated from mdm_Geography__c object //change-1
    public Map<String, IPM_Country__c> mapIPMCountries{get;set;} //Map of counries that have already been added to this project
    
    private Map<String, GeographyWrapper> mapClusterWrappers; //Map of Market Cluster Wrappers
    public Map<String, GeographyWrapper> mapMCOWrappers {get; set;} //Map of MCO Wrappers
    private Map<String, GeographyWrapper> mapCountryWrappers; //Map of Country Wrappers
    
    public List<GeographyWrapper> lstClusterWrappers {get; set;} //List of Market Cluster Wrappers to be displayed
    public List<GeographyWrapper> lstMCOWrappers {get; set;} //List of MCO Wrappers to be displayed
    public List<GeographyWrapper> lstCountryWrappers {get; set;} //List of Counry Wrappers to be displayed 
    
    public String selectedCluster {get; set;} //Selected Market Cluster Code
    public String previouselectedMCO {get; set;} //Previous Selected Market Clustter Code
    public String selectedMCO {get; set;} //Selected MCO Code
    public String selectedCountry {get; set;} //Selected Country Code
    
    public Boolean selectedKey {get; set;} //Selected Key MCO
    
    public Boolean isEditable{get;set;} //Boolean Variable to define if the record is editable by the current logged in user
    public Boolean disableMCO{get;set;}
    public Boolean isError {get; set;} //Boolean variable to indicate error on page
    public String errorMessage {get; set;} //Error Message to be displayed on the page
    
    private Map<String,IPM_Project_Rollout__c> mapExistingRollouts; //Map of Existing Rollouts
    private Map<String,IPM_Country__c> mapExistingCountries; //Map of existing counttries
    private Set<String> setExistingCountriesRegionalProject; //Set of Existing countries for the regional project
    
    private Map<String, IPM_Project_Rollout__c> mapUpsertRegionalRollouts; //Map of Regional Rollouts that need to be upserted
    private Map<String, IPM_Project_Rollout__c> mapUpsertRollouts; //Map of Local Rollouts that need to be upserted
    private List<IPM_Country__c> lstUpsertCountries; //List of countries that need to be upserted
    private Map<Id,IPM_Project_Rollout__c> deleteRolloutsMap; //List of Rollouts that need to be deleted
    private Map<Id,IPM_Country__c> deleteCountriesMap; //List of countries that need o be deleted 
    private static String REGIONAL_ROLLOUT_RECORDTYPE = IPM_ConstantUtils.EMPTY_STRING_INITIAL; //Recordtype Id for Regional Rollouts on IPM_Project_Rollout__c object
    private static String LOCAL_ROLLOUT_RECORDTYPE = IPM_ConstantUtils.EMPTY_STRING_INITIAL; //Recordtype Id for Local Rollouts on IPM_Project_Rollout__c object
    
    private static String NOT_ASSIGNED_CLUSTER_CODE = 'GEO0071'; //Cluster Code not to be used for display (Not Assigned values)
    
    //private static final String CLASS_NAME = 'IPM_RolloutPlansAddController'; //Class Name for Exception Logging
    private static final String CLASS_NAME = IPM_RolloutPlansAddController.class.getName();
    private static final String SEARCH_ROLLOUT_COUNTRY = 'searchRolloutCountry'; //Method Name for Exception Logging
    private static final String CHANGE_CLUSTER = 'changeCluster'; //Method Name for Exception Logging
    private static final String CHANGE_MCO = 'changeMCO'; //Method Name for Exception Logging
    private static final String GENERATE_ROLLOUTS = 'generateRollouts'; //Method Name for Exception Logging
    private static final String CANCEL = 'cancel'; //Method Name for Exception Logging    
    private static final String GET_UNILEVER_COUNTRIES = 'getUnileverCountries'; //Method Name for Exception Logging  
    private static final String GENERATE_WRAPPERS = 'generateWrappers'; //Method Name for Exception Logging 
    private static final String GENERATE_SUBWRAPPERS_FOR_SEARCH = 'generateSubWrappersForSearch'; //Method Name for Exception Logging
    private static final String GENERATE_SUBWRAPPERS = 'generateSubWrappers'; //Method Name for Exception Logging 
    private static final String PROCESS_COUNTRY_CODE_LISTS = 'processCountryCodeLists'; //Method Name for Exception Logging 
    private static final String PROCESS_REGIONAL_NO_ROLLOUTS = 'processRegionalNoRollouts'; //Method Name for Exception Logging
    private static final String GET_REGIONAL_ROLLOUT_NAME = 'getRegionalRolloutName'; //Method Name for Exception Logging
    private static final String GET_KEY_MCO_ROLLOUT_NAME = 'getKeyMCORolloutName'; //Method Name for Exception Logging
    private static final String SORT_WRAPPERS_BY_NAME = 'sortWrappersByName'; //Method Name for Exception Logging
    private static final String SelectQueryString ='Id,parent_L2__r.name,parent_L2__r.mdm_id__c,parent_L2__r.geography_type__c,parent_L2__r.parent_L2__c,parent_L2__r.parent_L2__r.Name,parent_L2__r.parent_L2__r.mdm_id__c,parent_L2__r.parent_L2__r.geography_type__c FROM MDO_Geography__c';
    public String searchCountry{get;set;}// Hold country name to search
    public Boolean isNoResult{get;set;}//checking for rollout search
    
    /**
    *  @Description Constructor of the class 
    *  @name IPM_RolloutPlansAddController
    *  @param NONE
    *  @return NONE
    *  @throws NONE
    */
    public IPM_RolloutPlansAddController()
    {
        IPM_IECompatible.ieFix();//For IE Compatibility
        isCompleted = false;
        selectedMCO = null;
        initializeRollouts();
    }
    /**
    *  @Description Method invoked from class constructor
    *  @name initializeRollouts
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    public void initializeRollouts()
    {
        searchCountry=null;
        isNoResult=false;
        projectId = ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
        System.debug(LoggingLevel.ERROR,'@@@ project id -->>'+projectId);
        if (projectId != null)
        {
            isEditable = IPM_Utils.getIPMRollOutUser(projectId);
            if(!isEditable)
            {
                errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            }
            getUnileverCountries();
            generateWrappers();
            generateSubWrappers();
               
     }
     
     //System.debug(LoggingLevel.ERROR,'@@@ selectedMCO -->>'+selectedMCO);
   
     
  }  
    /**
    *  @Description Method to search Unilever Geographies countries for rollout
    *  @name searchRolloutCountry
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    public void searchRolloutCountry()
    {    
        try
        {
            if(searchCountry!=null)
            {
                //GET A LIST OF ALL IPM COUNTRIES
                String likePerStr='%';
                String queryString = 'SELECT ';
                //MDM Geography . //change-2
                For (String field : Schema.SObjectType.MDO_Geography__c.fields.getMap().KeySet()){
                    if (field != IPM_ConstantUtils.SF_ID)
                        queryString+= field + ', ';
                } // change-3  query changes required following bottom up approach like from country to cluster /country group (parent_L2__r.name) / cluster parent_L2__r.parent_L2__r.name
                queryString+= SelectQueryString+' WHERE (Name LIKE \'' + String.escapeSingleQuotes(searchCountry) + likePerStr + '\' OR parent_L2__r.name LIKE \'' + String.escapeSingleQuotes(searchCountry) + likePerStr + '\') AND(Name!=null OR parent_L2__r.Name!=null OR parent_L2__r.parent_L2__r.Name!=null)';
                queryString+= ' AND geography_type__c = \''+IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRY+'\' AND parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRYGROUP+'\' AND Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_UNILEVERCLUSTER+'\' ORDER BY parent_L2__r.parent_L2__r.name,parent_L2__r.name,Name';
                queryString+= ' LIMIT 10000';
                mapUnileverCountries = new Map<String, MDO_Geography__c>(); 
              
                For(MDO_Geography__c geography : Database.query(queryString)){


                    mapUnileverCountries.put(geography.ISO_3166_1_Code__c, geography);
                
                }
                if(!mapUnileverCountries.isEmpty()){
                    generateWrappers();
                    generateSubWrappersForSearch(); 
                    changeCluster();
                    isNoResult=false;
                    
                }else{
                    lstClusterWrappers.clear();
                    lstMCOWrappers.clear();
                    lstCountryWrappers.clear();
                    isNoResult=true;
                }
            }
            else
            {
                initializeRollouts(); 
            }    
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,SEARCH_ROLLOUT_COUNTRY,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            lstClusterWrappers.clear();
            lstMCOWrappers.clear();
            lstCountryWrappers.clear();
            isNoResult=true;
        }
    }
    
    /**
    *  @Description Method to generate map of Unilever Geographies
    *  @name getUnileverCountries
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    private void getUnileverCountries(){
        
        
        //GET A LIST OF ALL IPM COUNTRIES
        String queryString = 'SELECT ';
        //MDM Geography  MDO
        For (String field : Schema.SObjectType.MDO_Geography__c.fields.getMap().KeySet()){ //change-3
            if (field != IPM_ConstantUtils.SF_ID)
                queryString+= field + ', ';
        }
        queryString+= SelectQueryString; // change-13
        queryString+= ' WHERE geography_type__c = \''+IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRY+'\' AND parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRYGROUP+'\' AND Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_UNILEVERCLUSTER+'\' ORDER BY parent_L2__r.parent_L2__r.name,parent_L2__r.name,Name';
        queryString+= ' LIMIT 10000';
            
        try{
            
            mapUnileverCountries = new Map<String, MDO_Geography__c>(); //change-5
            
            //System.debug(LoggingLevel.ERROR,'queryString-->>'+queryString);
            
            for(MDO_Geography__c geography : Database.query(queryString)) {
                 mapUnileverCountries.put(geography.ISO_3166_1_Code__c, geography);
            }
            
            System.debug(LoggingLevel.ERROR,'mapUnileverCountries-->>'+mapUnileverCountries);
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,GET_UNILEVER_COUNTRIES,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            isError = TRUE;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
        
    }
    
    /**
    *  @Description Method to generate various wrappers
    *  @name generateWrappers
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    private void generateWrappers(){
    
    
        //GET A LIST OF ALL IPM COUNTRIES
        try{
            String queryString = 'SELECT ';
            //IPM Country
            For (String field : Schema.SObjectType.IPM_Country__c.fields.getMap().KeySet()){
                if (field != IPM_ConstantUtils.SF_ID)
                    queryString+= field + ', ';
            }
            queryString+= 'Local_Rollout__r.KeyMCO__c, ';
            queryString+= 'Id FROM IPM_Country__c ';
            
            if(project.IPMProject_Span__c.equalsIgnoreCase(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL))
                queryString+= 'WHERE IPM_Regional_Project__c=:projectId LIMIT 50000';
            else 
                queryString+= 'WHERE IPM_Project__c =: projectId LIMIT 50000';
           
            
            mapIPMCountries = new Map<String, IPM_Country__c>();
            //System.debug(LoggingLevel.ERROR,'@@@ map ipm country from regional rollout '+queryString);
            
            For(IPM_Country__c ipmCountry : Database.query(queryString)){
                mapIPMCountries.put(ipmCountry.Country_Code__c, ipmCountry);
            }
            System.debug(LoggingLevel.ERROR,'@@@ map IPM country --->>>'+mapIPMCountries);
            
            mapClusterWrappers = new Map<String, GeographyWrapper>();
            mapMCOWrappers = new Map<String, GeographyWrapper>();
            mapCountryWrappers = new Map<String, GeographyWrapper>();
            
            lstClusterWrappers = new List<GeographyWrapper>();
            
            Set<String> setDisabledClusterCodes = new Set<String>();
            Set<String> setDisabledMCOCodes = new Set<String>();
            
            setCountryCodesGlobal = new Set<String>();
            
            System.debug(LoggingLevel.ERROR,'mapUnileverCountries-->>'+mapUnileverCountries);
            
            For (MDO_Geography__c country : mapUnileverCountries.values()){ //change-4
            
             if(country.parent_L2__r.parent_L2__r.mdm_id__c != null && country.parent_L2__r.parent_L2__r.name!= null){  
                if (country.parent_L2__r.parent_L2__r.mdm_id__c != NOT_ASSIGNED_CLUSTER_CODE)
                { 
                    //cluster code 
                    //Cluster
                    GeographyWrapper clusterWrapper = new GeographyWrapper(country.parent_L2__r.parent_L2__r.mdm_id__c, country.parent_L2__r.parent_L2__r.name, IPM_ConstantUtils.EMPTY_STRING_INITIAL);
                    if (mapClusterWrappers.containsKey(country.parent_L2__r.parent_L2__r.mdm_id__c))
                        clusterWrapper = mapClusterWrappers.get(country.parent_L2__r.parent_L2__r.mdm_id__c);
                    
                    
                    //MCO Country_Group_Code__c --> L2 mdm id ,Country_Group_c L2 name
                    
                    GeographyWrapper mcoWrapper = new GeographyWrapper(country.parent_L2__r.mdm_id__c, country.parent_L2__r.name, country.parent_L2__r.parent_L2__r.mdm_id__c);
                    if (mapMCOWrappers.containsKey(country.parent_L2__r.mdm_id__c))
                        mcoWrapper = mapMCOWrappers.get(country.parent_L2__r.mdm_id__c);
                    
                    //Country
                    GeographyWrapper countryWrapper = new GeographyWrapper(country.ISO_3166_1_Code__c, country.Name, country.parent_L2__r.mdm_id__c);
                    
                    
                    if(mapIPMCountries.containsKey(country.ISO_3166_1_Code__c))
                    {
                        //Key MCO
                        mcoWrapper.key = mapIPMCountries.get(country.ISO_3166_1_Code__c).Local_Rollout__r.KeyMCO__c;
                        countryWrapper.selected = TRUE; // selected country -------------------------------------------
                        countryWrapper.rolloutStatus = mapIPMCountries.get(country.ISO_3166_1_Code__c).IPM_Rollout_Status__c;
                        setCountryCodesGlobal.add(country.ISO_3166_1_Code__c);
                        
                        
                        //Existing Regional/Local Rollouts
                        if(mapIPMCountries.get(country.ISO_3166_1_Code__c).IPM_Local_Project__c != null){
                            countryWrapper.noRolloutDisabled = true;
                            if(mapIPMCountries.get(country.ISO_3166_1_Code__c).IPM_Rollout_Status__c.equalsIgnoreCase(IPM_ConstantUtils.ROLLOUT_STATUS_SEPERATE))
                                countryWrapper.mcoDisabled = true;
                            else if(mapIPMCountries.get(country.ISO_3166_1_Code__c).IPM_Rollout_Status__c.equalsIgnoreCase(IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO))
                                countryWrapper.countryDisabled = true;
                        }else{System.debug(LoggingLevel.ERROR,'***Regional/Local Rollouts dont Exist');}
                        
                        //Existing Regional Rollouts for Global Projects
                        if(mapIPMCountries.get(country.ISO_3166_1_Code__c).IPM_Regional_Project__c != null && project.IPMProject_Span__c.equalsIgnoreCase(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL))
                        {
                            setDisabledClusterCodes.add(country.parent_L2__r.parent_L2__r.mdm_id__c);  
                        }
                    }
                    
                    if(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(project.IPM_Project_Type__c) && IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
                    {
                        if(country.parent_L2__r.parent_L2__r.mdm_id__c.equalsIgnoreCase(project.Market_Cluster__c))
                            mapClusterWrappers.put(country.parent_L2__r.parent_L2__r.mdm_id__c, clusterWrapper);
                    } else
                        mapClusterWrappers.put(country.parent_L2__r.parent_L2__r.mdm_id__c, clusterWrapper);
                    
                    mapMCOWrappers.put(country.parent_L2__r.mdm_id__c, mcoWrapper);
                    mapCountryWrappers.put(country.ISO_3166_1_Code__c, countryWrapper);
                }
              }// null check    
            }
            System.debug(LoggingLevel.ERROR,'@@@ mapClusterWrappers'+mapClusterWrappers+'@@@ mapClusterWrappers'+mapMCOWrappers+'@@@ mapClusterWrappers'+mapCountryWrappers);
           
             
            For(GeographyWrapper clusterWrapper : mapClusterWrappers.values())
            {
                if(setDisabledClusterCodes.contains(clusterWrapper.code))
                {
                    clusterWrapper.clusterDisabled = true;
                    mapClusterWrappers.put(clusterWrapper.code, clusterWrapper);
                }
            }
            //System.debug(LoggingLevel.ERROR,'@@@ mapClusterWrappers2'+mapClusterWrappers);
            For(GeographyWrapper mcoWrapper : mapMCOWrappers.values())
            {
                if(setDisabledClusterCodes.contains(mcoWrapper.parentCode))
                {
                    mcoWrapper.mcoDisabled = true;
                    mapMCOWrappers.put(mcoWrapper.code, mcoWrapper);
                    setDisabledMCOCodes.add(mcoWrapper.code);
                }
            }
            //System.debug(LoggingLevel.ERROR,'@@@ mapMCOWrappers2'+mapMCOWrappers);
            For (GeographyWrapper countryWrapper : mapCountryWrappers.values())
            {
                if(setDisabledMCOCodes.contains(countryWrapper.parentCode))
                {
                    countryWrapper.countryDisabled = true;
                    mapCountryWrappers.put(countryWrapper.code, countryWrapper);
                }
            }
            //System.debug(LoggingLevel.ERROR,'@@@ mapCountryWrappers2'+mapCountryWrappers);
            lstClusterWrappers = sortWrappersByName(mapClusterWrappers.values());
            
            //SELECT FIRST SELECTED CLUSTER
            
            if(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equalsIgnoreCase(project.IPM_Project_Type__c) && IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)){
                List<IPM_Project_Rollout__c> lstRegionalRollout = new List<IPM_Project_Rollout__c>();
                lstRegionalRollout = [SELECT Id, MCO__c, Market_Cluster__c, IPM_Project__c 
                                                          FROM IPM_Project_Rollout__c 
                                                          WHERE Regional_Project__c=:project.Id 
                                                          LIMIT 10000];
                //System.debug(LoggingLevel.ERROR,'@@@ inside if lstRegionalRollout '+lstRegionalRollout );
                if(lstRegionalRollout != null){   
                                                       
                    selectedCluster = lstRegionalRollout [0].Market_Cluster__c;
                    //System.debug(LoggingLevel.ERROR,'@@@ selectedCluster '+selectedCluster );
                }               
                
            } else {
                
                for(GeographyWrapper clusterWrapper : lstClusterWrappers){
                    if (((selectedCluster == null) || (IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(selectedCluster)))&&(!clusterWrapper.clusterDisabled)){
                        selectedCluster = clusterWrapper.code;
                    }
                }                
                if (((selectedCluster == NULL) || (IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(selectedCluster))) && (lstClusterWrappers!=null && !lstClusterWrappers.isEmpty() )){
                    selectedCluster = lstClusterWrappers[0].code;
                }
                //System.debug(LoggingLevel.ERROR,'@@@ inside else selectedCluster '+selectedCluster );
            }
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,GENERATE_WRAPPERS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);    
            
            //System.debug(LoggingLevel.ERROR,'@@@ debug message -->>>'+ex.getMessage());
            isError = TRUE;
            errorMessage = ex.getMessage() + IPM_ConstantUtils.NEXT_LINE_STRING + ex.getStackTraceString();   
        }       
    }
    
    /**
    *  @Description Method to generate various sub wrappers used for display
    *  @name generateSubWrappersForSearch
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    private void generateSubWrappersForSearch(){
        try{
            lstMCOWrappers = new List<GeographyWrapper>();
            lstCountryWrappers = new List<GeographyWrapper>();
            
            //MCO SUB WRAPPERS
            
            if(lstClusterWrappers != NULL && !lstClusterWrappers.isEmpty()){
                selectedCluster = lstClusterWrappers[0].code;
            }
            
            For(GeographyWrapper mcoWrapper : mapMCOWrappers.values()){
                lstMCOWrappers.add(mcoWrapper);
            }
            if(!lstMCOWrappers.isEmpty()){
                lstMCOWrappers = sortWrappersByName(lstMCOWrappers);
                
                if ((lstMCOWrappers[0].code != NULL) || (lstMCOWrappers[0].code !=IPM_ConstantUtils.EMPTY_STRING_INITIAL)){
                    selectedMCO = lstMCOWrappers[0].code;
                    previouselectedMCO = lstMCOWrappers[0].code;
                } 
            }
            
            //COUNTRY SUB WRAPPERS
            
            For(GeographyWrapper countryWrapper : mapCountryWrappers.values()){
                
                if(setCountryCodesGlobal.contains(countryWrapper.code))
                    countryWrapper.selected = true;
                lstCountryWrappers.add(countryWrapper);
            }

            lstCountryWrappers = sortWrappersByName(lstCountryWrappers);
            selectedKey = mapMCOWrappers.get(selectedMCO).key;
            mapMCOWrappers.get(previouselectedMCO).key = selectedKey;  
            
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,GENERATE_SUBWRAPPERS_FOR_SEARCH,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            System.debug(LoggingLevel.ERROR,'generateSubWrappersForSearch Exception -->'+ex.getMessage());
            isError = TRUE;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }        
    }
    
    /**
    *  @Description Method to generate various sub wrappers used for display
    *  @name generateSubWrappers
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    private void generateSubWrappers(){
        try{
            lstMCOWrappers = new List<GeographyWrapper>();
            lstCountryWrappers = new List<GeographyWrapper>();
            
            //MCO SUB WRAPPERS
            For(GeographyWrapper mcoWrapper : mapMCOWrappers.values()){
                if(mcoWrapper.parentCode.equalsIgnoreCase(selectedCluster))
                    lstMCOWrappers.add(mcoWrapper);
            }
            lstMCOWrappers = sortWrappersByName(lstMCOWrappers);
            
            if (!lstMCOWrappers.isEmpty() && (selectedMCO == NULL) || (IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(selectedMCO))){
                selectedMCO = lstMCOWrappers[0].code;
                
                previouselectedMCO = lstMCOWrappers[0].code;
                
            }
            //COUNTRY SUB WRAPPERS
            
            For(GeographyWrapper countryWrapper : mapCountryWrappers.values()){
                
                if(countryWrapper.parentCode.equalsIgnoreCase(selectedMCO)){
                    if(setCountryCodesGlobal.contains(countryWrapper.code))
                        countryWrapper.selected = true;
                        
                    lstCountryWrappers.add(countryWrapper);
                    
                }
            }
            
            
            lstCountryWrappers = sortWrappersByName(lstCountryWrappers);
                if(selectedMCO!=null)
            selectedKey = mapMCOWrappers.get(selectedMCO).key; 
            
            
            
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,GENERATE_SUBWRAPPERS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            System.debug(LoggingLevel.ERROR,'generateSubWrappers exception -->'+ex.getMessage());
            isError = TRUE;
            errorMessage = Label.IPM_PLEASE_CONTACT_ADMINISTRATOR;
        }           
    }
    
    /**
    *  @Description Method invoked when the various market cluster tabs on the visualforce page are clicked
    *  @name changeCluster
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    public void changeCluster(){
        try{
            if(project.IPMProject_Span__c != IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){

                mapMCOWrappers.get(previouselectedMCO).key = selectedKey; 
                  
                
            }
            selectedMCO = null;
            selectedKey = false;
            processCountryCodeLists();
            generateSubWrappers();
            
        } 
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,CHANGE_CLUSTER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            isError = TRUE;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR)); 
        }
    }
    
    /**
    *  @Description Method invoked when the various MCO tabs on the visualforce page are clicked
    *  @name changeMCO
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    public void changeMCO(){
        try {
            if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c) || (IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(project.IPM_Project_Type__c) && IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)))
                mapMCOWrappers.get(previouselectedMCO).key = selectedKey; 
               selectedKey = false;
               processCountryCodeLists();
               generateSubWrappers();
            
        } 
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,CHANGE_MCO,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            isError = TRUE;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }
    
    /**
    *  @Description Method to generate and save rollout records
    *  @name generateRollouts
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    public void generateRollouts()
    { 
        System.SavePoint rollOutSavepoint = Database.setSavePoint();
        try 
        {
            System.debug(LoggingLevel.ERROR,'previouselectedMCO-->>>'+previouselectedMCO+'previouselectedMCO-->>>'+mapMCOWrappers.get(previouselectedMCO)+'selectedKey-->>>'+selectedKey);
           
            
            if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL || (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && project.IPM_Project_Type__c!='Rollout'))
            {   
                mapMCOWrappers.get(previouselectedMCO).key = selectedKey; 
            }
                     
            processCountryCodeLists();
            
            processRollouts();
            
            initializeRollouts();
            
            isCompleted = true;
        } 
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,GENERATE_ROLLOUTS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            Database.Rollback(rollOutSavepoint);
            System.debug(LoggingLevel.ERROR,'generateRollouts exe'+ex.getMessage());
            isError = TRUE;
            errorMessage = Label.IPM_Generic_ErrorMessage;
        }
    }
    
    /*******************************************************************************************************
    * @description  Method to redirect page
    * @param        NONE
    * @return       Page Reference
    */
    public PageReference redirectPage(){
        //System.debug(LoggingLevel.ERROR,'@@@redirectPage');

        try 
        {
            PageReference rolloutPlans = Page.IPM_RolloutPlans;
            rolloutPlans.getParameters().put(IPM_ConstantUtils.SF_ID, projectId); 
            rolloutPlans.getParameters().put(IPM_ConstantUtils.EDITMODE, IPM_ConstantUtils.EDITMODE_FALSE );               
            rolloutPlans.setRedirect(true);
            System.debug(LoggingLevel.ERROR,'@@@redirecting...'+rolloutPlans);
            return rolloutPlans;
        } 
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,'redirectPage',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            isError = TRUE;
            errorMessage = Label.IPM_Generic_ErrorMessage;  
            return null;
        }
    }
    
    
   /**
    *  @Description Method to redirect back to the rollouts page
    *  @name cancel
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    public PageReference cancel(){
        try 
        {
            PageReference rolloutPlans = Page.IPM_RolloutPlans;
            rolloutPlans.getParameters().put(IPM_ConstantUtils.SF_ID, projectId);                
            rolloutPlans.getParameters().put('cancelRedirect', 'true');                
            rolloutPlans.setRedirect(true);
            return rolloutPlans;
            
        } 
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,CANCEL,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            isError = TRUE;
            errorMessage = Label.IPM_Generic_ErrorMessage;  
            return null;
        }
    }
    
    /**
    *  @Description Method to process various country codes passed on from the visualforce page
    *  @name processCountryCodeLists
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    private void processCountryCodeLists()
    {
        try
        {
            //INITIALISE
            //Global
            
            if(setCountryCodesGlobal == null)
                setCountryCodesGlobal = new Set<String>();
            
            if(setCountryCodesGlobalUnselected == null)
                setCountryCodesGlobalUnselected = new Set<String>();
            
            //REGIONAL - MCO
            if(setCountryCodesMCOs == null)
                setCountryCodesMCOs = new Set<String>();
            
            if(setCountryCodesMCOsUnselected == null)
                setCountryCodesMCOsUnselected = new Set<String>();
            
            //REGIONAL - Country
            if(setCountryCodes == null)
                setCountryCodes = new Set<String>();
            
            if(setCountryCodesUnselected == null)
                setCountryCodesUnselected = new Set<String>();
            
            //REGIONAL - No ROllouts
            if(setCountryNoRolls == null)
                setCountryNoRolls = new Set<String>();
            
            if(setCountryNoRollsUnselected == null)
                setCountryNoRollsUnselected = new Set<String>();
            
            
            //PROCESS GLOBAL - ADD the values to the existing list
            if(globalCountries!=null && globalCountries!=IPM_ConstantUtils.EMPTY_STRING_INITIAL){
                List<String> lstTemp = globalCountries.split(IPM_ConstantUtils.COMMA); 
                setCountryCodesGlobal.addAll(lstTemp);
                
            }
            
            if(globalUnselectedCountries!=null && globalUnselectedCountries!=IPM_ConstantUtils.EMPTY_STRING_INITIAL){
                List<String> lstTemp = globalUnselectedCountries.split(IPM_ConstantUtils.COMMA); 
                setCountryCodesGlobalUnselected.addAll(lstTemp);
                
            }
            
            setCountryCodesGlobal.removeAll(setCountryCodesGlobalUnselected);
            setCountryCodesGlobalUnselected.clear();
            
            
            
           // MCO LEVEL ROLLOUT PROCESS
            if(regionalMco!=null && regionalMco!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = regionalMco.split(IPM_ConstantUtils.COMMA);   
                setCountryCodesMCOs.addAll(lstTemp); 
                //System.debug(LoggingLevel.ERROR,'@@@ setCountryCodesMCOs'+setCountryCodesMCOs); 
            }
            
            // Get non selected MCO Country Codes  
            if(regionalUnselectedMco!=null && regionalUnselectedMco!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = regionalUnselectedMco.split(IPM_ConstantUtils.COMMA); 
                setCountryCodesMCOsUnselected.addAll(lstTemp);    
            }
            
            setCountryCodesMCOs.removeAll(setCountryCodesMCOsUnselected);
            setCountryCodesMCOsUnselected.clear();
            
            // COUNTRY LEVEL ROLLOUT PROCESS 
            if(regionalCountry!=null && regionalCountry!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = regionalCountry.split(IPM_ConstantUtils.COMMA); 
                setCountryCodes.addAll(lstTemp);
            }
            
            if(regionalUselectedCountry!=null && regionalUselectedCountry!=IPM_ConstantUtils.EMPTY_STRING_INITIAL){
                List<String> lstTemp = regionalUselectedCountry.split(IPM_ConstantUtils.COMMA); 
                setCountryCodesUnselected.addAll(lstTemp);
            }
            
            setCountryCodes.removeAll(setCountryCodesUnselected);
            setCountryCodesUnselected.clear();
            
            // NO ROLLOUT LIST PROCESS 
            if(regionalNoRoll!=null && regionalNoRoll!=IPM_ConstantUtils.EMPTY_STRING_INITIAL){
                List<String> lstTemp = regionalNoRoll.split(IPM_ConstantUtils.COMMA); 
                setCountryNoRolls.addAll(lstTemp);
                
            }
            
            if(regionalUnselectedNoRoll!=null && regionalUnselectedNoRoll!=IPM_ConstantUtils.EMPTY_STRING_INITIAL){
                List<String> lstTemp = regionalUnselectedNoRoll.split(IPM_ConstantUtils.COMMA); 
                setCountryNoRollsUnselected.addAll(lstTemp);
                
            }
            
            setCountryNoRolls.removeAll(setCountryNoRollsUnselected);
            setCountryNoRollsUnselected.clear();
            
        }
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),PROCESS_COUNTRY_CODE_LISTS,CANCEL,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);

            isError = TRUE;
            errorMessage = Label.IPM_Generic_ErrorMessage;
        }
    }
    
    /**
    *  @Description Method to generate and save rollout records
    *  @name processRollouts
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    private void processRollouts()
    {
        REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId();
        LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
        
        mapExistingRollouts = new Map<String,IPM_Project_Rollout__c>();
        mapExistingCountries = new Map<String,IPM_Country__c>();
        setExistingCountriesRegionalProject = new Set<String>();
        mapUpsertRegionalRollouts = new Map<String, IPM_Project_Rollout__c>();
        mapUpsertRollouts = new Map<String, IPM_Project_Rollout__c>();
        lstUpsertCountries = new List<IPM_Country__c>();
        deleteRolloutsMap = new Map<Id,IPM_Project_Rollout__c>();
        deleteCountriesMap = new Map<Id,IPM_Country__c>();
        
        //Existing Rollouts
        String queryString = 'SELECT Id, IPM_Rollout_Project__c,Regional_Project__c,Type__c, ';
        queryString+= '(SELECT Id, Country_Code__c FROM IPM_Countries_Local__r) ';
        queryString+= 'FROM IPM_Project_Rollout__c ';
        if (IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            queryString+= 'WHERE IPM_Project__c =: projectId LIMIT 10000';
        }
        else if (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            queryString+= 'WHERE Regional_Project__c =: projectId LIMIT 10000';
        }

        for(IPM_Project_Rollout__c ipmRollout : Database.query(queryString))
        {
            mapExistingRollouts.put(ipmRollout.IPM_Rollout_Project__c, ipmRollout);
        }
        
        //Countries
        queryString = null;
        queryString = 'SELECT Id, Country_Code__c, Country_Name__c, Project_Country__c, IPM_Rollout_Status__c, IPM_Regional_Project__c,Local_Rollout_Charter__c FROM IPM_Country__c ';
        if (IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            queryString+= 'WHERE IPM_Project__c =: projectId LIMIT 10000';
        }
        else if (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            queryString+= 'WHERE IPM_Regional_Project__c =: projectId LIMIT 10000';        
        }
          
        for (IPM_Country__c country : Database.query(queryString))
        {
            if(IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(searchCountry))
            {
                mapExistingCountries.put(country.Country_Code__c, country);
            }
        }
       
        
        if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c) || ( ( IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c ) ) && ( IPM_ConstantUtils.PHASE_IDEAS.equalsIgnoreCase(project.IPM_phase__c) ) ) )
        {
            processGlobalMCORollouts();
        } 
        else if (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)) 
        {      
                processRegionalMCORollouts();
                processRegionalCountryRollouts();
                processRegionalNoRollouts();
        }
        
        //System.debug(LoggingLevel.ERROR,'@@@mapUpsertRegionalRollouts:'+mapUpsertRollouts);
        
        if(!mapUpsertRegionalRollouts.isEmpty())
        {
            upsert mapUpsertRegionalRollouts.values() IPM_Project_Rollout__c.IPM_Rollout_Project__c;
        }
        
        //System.debug(LoggingLevel.ERROR,'@@@mapUpsertRollouts:'+mapUpsertRollouts);
        
        if(!mapUpsertRollouts.isEmpty())
        {
            upsert mapUpsertRollouts.values() IPM_Project_Rollout__c.IPM_Rollout_Project__c;
        }
        
        //System.debug(LoggingLevel.ERROR,'@@@lstUpsertCountries:'+lstUpsertCountries);
        
        if(!lstUpsertCountries.isEmpty())
        {
            upsert lstUpsertCountries IPM_Country__c.Project_Country__c;
        }
        
        //System.debug(LoggingLevel.ERROR,'@@@deleteRolloutsMap:'+deleteRolloutsMap);
        if(!deleteRolloutsMap.isEmpty())
        {
            // Rollouts that might have deleted as part of Trigger Logic of updating Key Rollouts To Non Keys.
            List<IPM_Project_Rollout__c> rolloutListToDelete = [Select Id from IPM_Project_Rollout__c where Id in :deleteRolloutsMap.values()];
            delete rolloutListToDelete;
        }
        
        //System.debug(LoggingLevel.ERROR,'@@@deleteCountriesMap:'+deleteCountriesMap);
        if(!deleteCountriesMap.isEmpty())
        {   
            // Before deleting Query the Countries again to validate whether certain countries got deleted as part of Rollout Deletion.
            List<IPM_Country__c> countryListToDelete = [Select Id from IPM_Country__c where Id in :deleteCountriesMap.values()];                  
            delete countryListToDelete;
        }
        
        
        
        
    }
    
    /**
    *  @Description Method to process Global MCO Rollouts
    *  @name processGlobalMCORollouts
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    private void processGlobalMCORollouts()
    {
        //MCO Rollouts
        for (String countryCodeGlobal : setCountryCodesGlobal)
        {
            MDO_Geography__c geography = mapUnileverCountries.get(countryCodeGlobal);
            //System.debug(LoggingLevel.ERROR,'-->>>'+geography.parent_L2__r.mdm_id__c);
            
            String mcoRolloutName = getKeyMCORolloutName(countryCodeGlobal);
            String regionalRolloutName = getRegionalRolloutName(countryCodeGlobal);
            
            IPM_Project_Rollout__c regionalRollout = null;
            IPM_Project_Rollout__c mcoRollout = null;
            IPM_Country__c ipmCountry = null;
            
            
            if(mapExistingRollouts.containsKey(regionalRolloutName) || mapUpsertRegionalRollouts.containsKey(regionalRolloutName))
            {
                regionalRollout = mapExistingRollouts.get(regionalRolloutName);
                if(regionalRollout == null)
                {
                    regionalRollout = mapUpsertRegionalRollouts.get(mcoRolloutName);
                }
            }
            else
            {
               // Only add Regional Rollouts for Global Original Projects.Dont create Regional Rollouts for Regional Original 
               if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
               {
                   regionalRollout = new IPM_Project_Rollout__c(
                        RecordTypeId=REGIONAL_ROLLOUT_RECORDTYPE,
                        Name = regionalRolloutName,
                        IPM_Rollout_Project__c = regionalRolloutName,
                        IPM_Project__c = project.Id,
                        Market_Cluster__c = geography.parent_L2__r.parent_L2__r.mdm_id__c,
                        Market_Cluster_Name__c = geography.parent_L2__r.parent_L2__r.name,
                        Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c,
                        IPM_Rollout_Span__c='Regional',
                        Added_At_Stage__c = project.IPM_Phase__c
                    ); 
                    mapUpsertRegionalRollouts.put(regionalRolloutName, regionalRollout);
               }
            }
            
            System.debug(LoggingLevel.ERROR,'Rollout --->>>'+regionalRollout);
            
            if (mapExistingRollouts.containsKey(mcoRolloutName) || mapUpsertRollouts.containsKey(mcoRolloutName))
            {
                mcoRollout = mapExistingRollouts.get(mcoRolloutName);
                if(mcoRollout == null)
                {
                    mcoRollout = mapUpsertRollouts.get(mcoRolloutName);
                }
            }
            else
            {
                mcoRollout = new IPM_Project_Rollout__c( //change-7
                    RecordTypeId=LOCAL_ROLLOUT_RECORDTYPE,
                    Name = mcoRolloutName,
                    IPM_Rollout_Project__c = mcoRolloutName,
                    Type__c = IPM_ConstantUtils.ROLLOUT_TYPE_MCO,
                    KeyMCO__c = mapMCOWrappers.get(geography.parent_L2__r.mdm_id__c).key,
                    MCO__c = geography.parent_L2__r.mdm_id__c,
                    MCO_Name__c = geography.parent_L2__r.name,
                    Market_Cluster__c = geography.parent_L2__r.parent_L2__r.mdm_id__c,
                    Market_Cluster_Name__c = geography.parent_L2__r.parent_L2__r.name,
                    Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c,
                    Added_At_Stage__c = project.IPM_Phase__c
                );
            }
            
            if(mcoRollout!=NULL)
            {
                if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
                {
                    mcoRollout.IPM_Project__c = project.Id;
                    mcoRollout.Regional_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = regionalRolloutName);
                }
                else
                {
                    mcoRollout.Regional_Project__c = project.Id;
                }                    
                mcoRollout.IPM_Rollout_Project__c = mcoRolloutName;
                //System.debug(LoggingLevel.ERROR,'-->>>'+mapMCOWrappers.get(geography.parent_L2__r.mdm_id__c));
                System.debug(LoggingLevel.ERROR,'-->>>'+mapMCOWrappers.get(geography.parent_L2__r.mdm_id__c).key);
                mcoRollout.KeyMCO__c = mapMCOWrappers.get(geography.parent_L2__r.mdm_id__c).key;
                mapUpsertRollouts.put(mcoRolloutName, mcoRollout);
            }
            
            //System.debug(LoggingLevel.ERROR,'Rollout --->>>'+mcoRollout);
            
            if(mapExistingCountries.containsKey(countryCodeGlobal))
            {
                ipmCountry = mapExistingCountries.get(countryCodeGlobal);
            }
            else
            {
                //Add new country to existing MCO rollout
                ipmCountry = new IPM_Country__c(
                    Project_Country__c = getCountryExternalId(countryCodeGlobal),
                    MDO_Geography__c = geography.Id, //change-5
                    IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                    Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoRolloutName),
                    Local_Rollout_Charter__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoRolloutName) //Required to ensure that the data consistency is maintained after charter is approved
                );
                
                lstUpsertCountries.add(ipmCountry);
            }
            
            if(ipmCountry !=null)
            {
                if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
                {
                    ipmCountry.IPM_Project__c = project.Id;
                }
                else
                {
                    ipmCountry.IPM_Regional_Project__c = project.Id;
                }
            }
            
            System.debug(LoggingLevel.ERROR,'Rollout --->>>'+mcoRollout);                
        }
                        
        Set<String> setDeleteCountryCodes = new Set<String>();
        //Delete unselected countries
        if(mapExistingCountries != NULL && !mapExistingCountries.isEmpty())
        {
            for(IPM_Country__c existingCountry : mapExistingCountries.values())
            {
                if(existingCountry.Country_Code__c != NULL && !setCountryCodesGlobal.contains(existingCountry.Country_Code__c))
                {
                    //Country exists but is not selected
                    String countryRolloutName = getCountryExternalId(existingCountry.Country_Code__c);
                    deleteCountriesMap.put(existingCountry.Id,existingCountry);
                    setDeleteCountryCodes.add(existingCountry.Country_Code__c);
                    //Country Rollout ALREADY exist
                    if (mapExistingRollouts.containsKey(countryRolloutName))
                    {
                        //Delete Rollout
                        deleteRolloutsMap.put(mapExistingRollouts.get(countryRolloutName).Id,mapExistingRollouts.get(countryRolloutName));
                    }            
                }
            }
        }
            
            //Check to delete MCO Rollout
        for(IPM_Project_Rollout__c ipmRollout : mapExistingRollouts.values()){
            if(IPM_ConstantUtils.ROLLOUT_TYPE_MCO.equalsIgnoreCase(ipmRollout.Type__c)){
                Integer remainingCountryCount = 0;
                For(IPM_Country__c ipmCountry : ipmRollout.IPM_Countries_Local__r){
                    if(!setDeleteCountryCodes.contains(ipmCountry.Country_Code__c)){
                        remainingCountryCount++;
                    }
                }
                
                if(remainingCountryCount == 0){
                    deleteRolloutsMap.put(ipmRollout.Id,ipmRollout);
                }
            }
        }   
    }
    
    /**
    *  @Description Method to process Regional MCO Rollouts
    *  @name processRegionalMCORollouts
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    private void processRegionalMCORollouts()
    {
        // List of Countries selected to be associated with MCO.
        for (String countryCodeMCO : setCountryCodesMCOs)
        { 
            MDO_Geography__c geography = mapUnileverCountries.get(countryCodeMCO);
            
            // Get Rollout Name.
            String mcoRolloutName = getKeyMCORolloutName(countryCodeMCO);
           
            IPM_Country__c ipmCountry = null;
            IPM_Project_Rollout__c newMCORollout = null;
            
            if(!mapExistingRollouts.containsKey(mcoRolloutName) && !mapUpsertRollouts.containsKey(mcoRolloutName) )
            {
                newMCORollout = new IPM_Project_Rollout__c
                (
                    RecordTypeId = LOCAL_ROLLOUT_RECORDTYPE,
                    Name = mcoRolloutName,
                    IPM_Rollout_Project__c = mcoRolloutName,
                    Type__c = IPM_ConstantUtils.ROLLOUT_TYPE_MCO,
                    MCO__c = geography.parent_L2__r.mdm_id__c,
                    MCO_Name__c = geography.parent_L2__r.name,
                    Market_Cluster__c = geography.parent_L2__r.parent_L2__r.mdm_id__c,
                    Market_Cluster_Name__c = geography.parent_L2__r.parent_L2__r.name,
                    Regional_Project__c = project.Id,
                    Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c,
                    Added_At_Stage__c = project.IPM_Phase__c,
                    IPM_Rollout_Span__c='Local'
                );
                mapUpsertRollouts.put(mcoRolloutName, newMCORollout);   
            }
             
            // Check if Country Exists
            if(mapExistingCountries.containsKey(countryCodeMCO))
            {
                ipmCountry = mapExistingCountries.get(countryCodeMCO);
            }
            else 
            {
                //Add new country to existing MCO rollout
                ipmCountry = new IPM_Country__c(
                                Project_Country__c = project.IPM_Project_Name__c + IPM_ConstantUtils.UNDERSCORE + countryCodeMCO,
                                MDO_Geography__c = geography.Id,
                                IPM_Regional_Project__c = project.Id,
                                IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                                Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoRolloutName),
                                IPM_Project__c = project.IPM_Parent_Project__c
                );
            }
            
            // If it is an existing country and has status Not equal to MCO, update status as MCO and delete correponding Country Rollout. 
            if(ipmCountry.IPM_Rollout_Status__c != IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO)
            {
                // Update the Status as Related to MCO.
                ipmCountry.IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO;
                
                // Update the Local Rollout to point to MCO Rollout
                ipmCountry.Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoRolloutName);
                
                // Add Country specific Rollout to the deleted List for Processing.
                if(mapExistingRollouts.containsKey(ipmCountry.Project_Country__c)) 
                {
                    IPM_Project_Rollout__c projectRollout = mapExistingRollouts.get(ipmCountry.Project_Country__c);   
                    deleteRolloutsMap.put(projectRollout.Id,projectRollout);  
                }
            }
            lstUpsertCountries.add(ipmCountry);
        }
        
        System.debug(LoggingLevel.ERROR,'mapUpsertRollouts-->>>'+mapUpsertRollouts+'lstUpsertCountries-->>>'+lstUpsertCountries);
        //System.debug(LoggingLevel.ERROR,'lstUpsertCountries-->>>'+lstUpsertCountries);
    }
    
    /**
    *  @Description Method to process Regional Country Rollouts
    *  @name processRegionalCountryRollouts
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    private void processRegionalCountryRollouts()
    {
        //Local Country Rollouts
        for(string countryCode : setCountryCodes)
        { 
            MDO_Geography__c geography = mapUnileverCountries.get(countryCode); 
            String countryRolloutName = getCountryExternalId(countryCode);
                
            IPM_Country__c ipmCountry = null;
            IPM_Project_Rollout__c newCountryRollout = null;
            
            // Add Country Rollout if it doesnt Exist 
            if(!mapExistingRollouts.containsKey(countryRolloutName) && ! mapUpsertRollouts.containsKey(countryRolloutName))
            {
                newCountryRollout = new IPM_Project_Rollout__c(
                    RecordTypeId=LOCAL_ROLLOUT_RECORDTYPE,
                    Name = countryRolloutName,
                    IPM_Rollout_Project__c = countryRolloutName,
                    Type__c = IPM_ConstantUtils.ROLLOUT_TYPE_COUNTRY,
                    MCO__c = geography.parent_L2__r.mdm_id__c,
                    MCO_Name__c = geography.parent_L2__r.name,
                    Market_Cluster__c = geography.parent_L2__r.parent_L2__r.mdm_id__c,
                    Market_Cluster_Name__c = geography.parent_L2__r.parent_L2__r.name,
                    Regional_Project__c = project.Id,
                    Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c,
                    Added_At_Stage__c = project.IPM_Phase__c,
                    IPM_Rollout_Span__c='Local'
                );
                mapUpsertRollouts.put(countryRolloutName, newCountryRollout);
            }

            //Check if Country exists. If it already exists update Status and reference of Local Rollout as separate Country Rollout.
            if(mapExistingCountries.containsKey(countryCode))
            {
                ipmCountry = mapExistingCountries.get(countryCode);
            }
            else 
            {
                //New Country //change-15
                ipmCountry = new IPM_Country__c(
                    Project_Country__c = project.IPM_Project_Name__c + IPM_ConstantUtils.UNDERSCORE + countryCode,
                    MDO_Geography__c = geography.Id,
                    IPM_Regional_Project__c = project.Id
                );
                
                if(project.IPM_Project_Type__c != IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
                    ipmCountry.IPM_Project__c = project.IPM_Parent_Project__c;
            }
            
            ipmCountry.Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = countryRolloutName);
            ipmCountry.IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_SEPERATE;
            lstUpsertCountries.add(ipmCountry);
        }
        
        //System.debug(LoggingLevel.ERROR,'mapUpsertRollouts-->>>'+mapUpsertRollouts);
        //System.debug(LoggingLevel.ERROR,'lstUpsertCountries-->>>'+lstUpsertCountries);
                 
    }
    
    /**
    *  @Description Method to process Regional No Rollouts
    *  @name processRegionalNoRollouts
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    private void processRegionalNoRollouts()
    {
        try
        {
            Set<String> setDeleteCountryCodes = new Set<String>();
            
            //Delete Country Rollouts
            for(string noRolloutCode : setCountryNoRolls)
            {     
                //If the country exists
                if(mapExistingCountries.containsKey(noRolloutCode))
                {
                    IPM_Country__c country = mapExistingCountries.get(noRolloutCode);
                       
                    //Check if country was added at Ideas phase
                    if(country.Local_Rollout_Charter__c != null)
                    {
                        country.Local_Rollout__c = null;
                        country.IPM_Rollout_Status__c=IPM_ConstantUtils.NO_ROLLOUT;
                        lstUpsertCountries.add(country);
                    } 
                    else 
                    {
                        
                        //Delete Country
                        deleteCountriesMap.put(country.Id,country);
                        setDeleteCountryCodes.add(country.Country_Code__c);
                        
                         // Country Rollout Name
                        String countryRolloutName = getCountryExternalId(noRolloutCode);
                        
                        //Country Rollout ALREADY exist
                        if (mapExistingRollouts.containsKey(countryRolloutName))
                        {
                            //Delete Rollout
                            IPM_Project_Rollout__c associatedCountryRollout = mapExistingRollouts.get(countryRolloutName);
                            deleteRolloutsMap.put(associatedCountryRollout.Id,associatedCountryRollout);
                        }   
                    }
                    
                }
            }
            
            //Check to delete MCO Rollout
            for(IPM_Project_Rollout__c ipmRollout : mapExistingRollouts.values())
            {
                if(IPM_ConstantUtils.ROLLOUT_TYPE_MCO.equalsIgnoreCase(ipmRollout.Type__c))
                {
                    Integer remainingCountryCount = 0;
                    for(IPM_Country__c ipmCountry : ipmRollout.IPM_Countries_Local__r)
                    {
                        if(!setDeleteCountryCodes.contains(ipmCountry.Country_Code__c))
                        {
                            remainingCountryCount++;
                        }
                    }
                    
                    if(remainingCountryCount == 0)
                    {
                        deleteRolloutsMap.put(ipmRollout.Id,ipmRollout);
                    }
                }
            }
            
            //System.debug(LoggingLevel.ERROR,'mapUpsertRollouts-->>>'+mapUpsertRollouts);
            //System.debug(LoggingLevel.ERROR,'lstUpsertCountries-->>>'+lstUpsertCountries);
        }
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,PROCESS_REGIONAL_NO_ROLLOUTS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            isError = TRUE;
            errorMessage = Label.IPM_Generic_ErrorMessage;
        }           
    }
    
    /**
    *  @Description Method to get Regional Rollout Name
    *  @name getRegionalRolloutName
    *  @param countryCode    Country code for which the regional rollout name needs o be generated
    *  @return Regional Rollout Name
    *  @throws Exception
    */
    
    private String getRegionalRolloutName(String countryCode)
    { 
        try
        {
            MDO_Geography__c geography = mapUnileverCountries.get(countryCode);
            
            if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
            {
                return project.IPM_Project_Name__c;
            }
            else
            {
                String shortName = IPM_Market_Cluster_Short_Names__c.getValues(geography.parent_L2__r.parent_L2__r.mdm_id__c).Short_Name__c;                
                //System.debug(LoggingLevel.ERROR,'IPM_Market_Cluster_Short_Names__c short name -->'+shortName);
                return project.IPM_Project_Name__c + IPM_ConstantUtils.UNDERSCORE + shortName;                
            }
        }
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,GET_REGIONAL_ROLLOUT_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            System.debug(LoggingLevel.ERROR,'getRegionalRolloutName'+ex.getMessage());
            isError = TRUE;
            errorMessage = Label.IPM_Generic_ErrorMessage; 
            return null;
        }    
    }
    
    /**
    *  @Description Method to get key MCO Rollout Name
    *  @name getKeyMCORolloutName
    *  @param countryCode    Country code for which the key MCO rollout name needs o be generated
    *  @return key MCO Rollout Name
    *  @throws Exception
    */
    private String getKeyMCORolloutName(String countryCode)
    { 
        try
        {
            MDO_Geography__c geography = mapUnileverCountries.get(countryCode);
            
            String shortName = IPM_MCO_Short_Names__c.getValues(geography.parent_L2__r.mdm_id__c).Short_Name__c;
            
            return getRegionalRolloutName(countryCode) + IPM_ConstantUtils.UNDERSCORE + shortName;
        }
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,GET_KEY_MCO_ROLLOUT_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            isError = TRUE;
            errorMessage = Label.IPM_Generic_ErrorMessage;
            return null;
        }           
    }
    
    /**
    *  @Description Method to get Country External Id
    *  @name getCountryExternalId
    *  @param countryCode    Country code for which the Country External Id needs o be generated
    *  @return Country External Id
    *  @throws Exception
    */
    private String getCountryExternalId(String countryCode){        
        return getRegionalRolloutName(countryCode) + IPM_ConstantUtils.UNDERSCORE + countryCode;
    }
    
    /**
    *  @Description Method to sort the list of geography wrappers alphabetically
    *  @name sortWrappersByName
    *  @param wrappersToSort     List of unsorted Wrappers
    *  @return List of Sorted Wrappers
    *  @throws Exception
    */
    private List<GeographyWrapper> sortWrappersByName(List<GeographyWrapper> wrappersToSort) {
        try{
            if(wrappersToSort == null || wrappersToSort.size() <= 1){
                return wrappersToSort;
            }
            
            List<GeographyWrapper> lessWrappers = new List<GeographyWrapper>();
            List<GeographyWrapper> greaterWrappers = new List<GeographyWrapper>();
            
            integer pivot = wrappersToSort.size() / 2;
            
            //save the pivot and remove it from the selectOption list
            GeographyWrapper pivotWrapper = wrappersToSort[pivot];
            wrappersToSort.remove(pivot);
            
            for(GeographyWrapper wrapper : wrappersToSort){
                if(wrapper.name <= pivotWrapper.name)
                    lessWrappers.add(wrapper);
                else if(wrapper.name > pivotWrapper.name)
                    greaterWrappers.add(wrapper);
            }
            
            List<GeographyWrapper> sortedWrappers = new list<GeographyWrapper>(); 
            
            sortedWrappers.addAll(sortWrappersByName(lessWrappers));
            sortedWrappers.add(pivotWrapper);
            sortedWrappers.addAll(sortWrappersByName(greaterWrappers));
            
            return sortedWrappers;
        }
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,SORT_WRAPPERS_BY_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
                
            System.debug(LoggingLevel.ERROR,'sortWrappersByName exception -->'+ex.getMessage());
            isError = TRUE;
            errorMessage = Label.IPM_Generic_ErrorMessage;  
            return null;
        }           
    }
    
    /** 
    * @Description Wrapper class for Geography
    */
    public class GeographyWrapper{
        public String code {get; set;}
        public String name {get; set;}
        public String parentCode {get; set;}
        public String rolloutStatus {get; set;}
        
        public Boolean key {get; set;}
        public Boolean selected {get; set;}
        public Boolean clusterDisabled {get; set;}
        public Boolean mcoDisabled {get; set;}
        public Boolean countryDisabled {get; set;}
        public Boolean noRolloutDisabled {get; set;}
        
        public GeographyWrapper(String code, String name, String parentCode){
            this.code = code;
            this.name = name;
            this.parentCode = parentCode;
            this.key = false;
            this.selected = false;
            this.clusterDisabled = false;
            this.mcoDisabled = false;
            this.countryDisabled = false;
            this.noRolloutDisabled = false;
        }
    }
}