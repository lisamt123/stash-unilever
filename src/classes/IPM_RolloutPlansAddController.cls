/**
@Author Cognizant 
@Name IPM_RolloutPlansAddController
@CreateDate 27/04/2015
@Description    This class is used for adding new rollouts to the project. It is used for displaying MDO Specific Geographies and Countries. 
                User selects MCO and Countries from the Page and are send for rollout Processing.
                Handles building of core Rollout Data, creating relationships between rollouts, countries and regional Rollouts.
                Adds and removes Rollouts/Countries based on user selection.
                Switching of rolloutType is handled in this class.
@Version 1.0
@reference IPM_RolloutPlansAdd VF page, IPM_RolloutPlansRegional VF page
*/
public with sharing class IPM_RolloutPlansAddController extends IPM_ProjectIntermediateController
{    
    public String projectId {get; set;} //project id of the current project
    // public IPM_Project__c project {get; set;} //The project record for which the rollouts are being viewed
    
    public Boolean isCompleted{get; set;} 
    @TestVisible private Set<String> setCountryCodesGlobal; //Set of selected Global Country codes generated from passed Visualforce sring
    @TestVisible private Set<String> setCountryCodesGlobalUnselected; //Set of unselected Global Country codes generated from passed Visualforce sring
    @TestVisible private Set<String> setCountryCodesMCOs; //Set of selected Regional MCO Country codes generated from passed Visualforce sring
    @TestVisible private Set<String> setCountryCodesMCOsUnselected; //Set of unselected Regional MCO Country codes generated from passed Visualforce sring
    @TestVisible private Set<String> setCountryCodes; //Set of selected Regional Country codes generated from passed Visualforce sring
    @TestVisible private Set<String> setCountryCodesUnselected; //Set of unselected Regional Country codes generated from passed Visualforce sring
    @TestVisible private Set<String> setCountryNoRolls; //Set of selected Regional No Rollouts Country codes generated from passed Visualforce sring
    @TestVisible private Set<String> setCountryNoRollsUnselected; //Set of unselected Regional No Rollouts Country codes generated from passed Visualforce sring
    
    public String globalCountries{get; set;} //Collection of (comma seperated) selected global country codes passed from Visualforce
    public String globalUnselectedCountries{get; set;} //Collection of (comma seperated) unselected global country codes passed from Visualforce
    public String regionalMco{get; set;} //Collection of (comma seperated) selected regional mco country codes passed from Visualforce
    public String regionalUnselectedMco{get; set;} //Collection of (comma seperated) unselected regional mco country codes passed from Visualforce
    public String regionalCountry{get; set;} //Collection of (comma seperated) selected regional country codes passed from Visualforce
    public String regionalUnselectedCountry{get; set;} //Collection of (comma seperated) unselected regional country codes passed from Visualforce
    public String regionalNoRoll{get; set;} //Collection of (comma seperated) selected regional no rollouts country codes passed from Visualforce
    public String regionalUnselectedNoRoll{get; set;} //Collection of (comma seperated) unselected regional no rollouts country codes passed from Visualforce
    
    @TestVisible private Map<String, MDO_Geography__c> mapUnileverCountries; //Map of Unilever Countries - generated from mdm_Geography__c object //change-1
    public Map<String, IPM_Country__c> mapIPMCountries{get;set;} //Map of counries that have already been added to this project
    
    @TestVisible private Map<String, GeographyWrapper> mapClusterWrappers; //Map of Market Cluster Wrappers
    public Map<String, GeographyWrapper> mapMCOWrappers {get; set;} //Map of MCO Wrappers
    @TestVisible private Map<String, GeographyWrapper> mapCountryWrappers; //Map of Country Wrappers
    
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
    
    @TestVisible private Map<String,IPM_Project_Rollout__c> mapExistingRollouts; //Map of Existing Rollouts
    @TestVisible private Map<String,IPM_Country__c> mapExistingCountries; //Map of existing counttries
    @TestVisible private Set<String> setExistingCountriesRegionalProject; //Set of Existing countries for the regional project
    
    @TestVisible private Map<String, IPM_Project_Rollout__c> mapUpsertRegionalRollouts; //Map of Regional Rollouts that need to be upserted
    @TestVisible private Map<String, IPM_Project_Rollout__c> mapUpsertRollouts; //Map of Local Rollouts that need to be upserted
    @TestVisible private Map<String,IPM_Country__c> mapUpsertCountries; //List of countries that need to be upserted
    
    @TestVisible private Map<String,IPM_Project_Rollout__c> deleteRolloutsMap; //List of Rollouts that need to be deleted
    
    @TestVisible private Map<String,IPM_Country__c> deleteCountriesMap; //List of countries that need o be deleted 
    @TestVisible private static String REGIONAL_ROLLOUT_RECORDTYPE = IPM_ConstantUtils.EMPTY_STRING_INITIAL; //Recordtype Id for Regional Rollouts on IPM_Project_Rollout__c object
    @TestVisible private static String LOCAL_ROLLOUT_RECORDTYPE = IPM_ConstantUtils.EMPTY_STRING_INITIAL; //Recordtype Id for Local Rollouts on IPM_Project_Rollout__c object
    
    @TestVisible private static String NOT_ASSIGNED_CLUSTER_CODE = 'GEO0071'; //Cluster Code not to be used for display (Not Assigned values)
    
    //private static final String CLASS_NAME = 'IPM_RolloutPlansAddController'; //Class Name for Exception Logging
    @TestVisible private static final String CLASS_NAME = IPM_RolloutPlansAddController.class.getName();
    @TestVisible private static final String SEARCH_ROLLOUT_COUNTRY = 'searchRolloutCountry'; //Method Name for Exception Logging
    @TestVisible private static final String CHANGE_MCO = 'changeMCO'; //Method Name for Exception Logging
    @TestVisible private static final String GENERATE_ROLLOUTS = 'generateRollouts'; //Method Name for Exception Logging
    @TestVisible private static final String CANCEL = 'cancel'; //Method Name for Exception Logging    
    @TestVisible private static final String GET_UNILEVER_COUNTRIES = 'getUnileverCountries'; //Method Name for Exception Logging  
    @TestVisible private static final String GENERATE_SUBWRAPPERS = 'generateSubWrappers'; //Method Name for Exception Logging 
    @TestVisible private static final String GET_REGIONAL_ROLLOUT_NAME = 'getRegionalRolloutName'; //Method Name for Exception Logging
    @TestVisible private static final String GET_KEY_MCO_ROLLOUT_NAME = 'getKeyMCORolloutName'; //Method Name for Exception Logging
    @TestVisible private static final String SelectQueryString ='Id,parent_L2__r.name,parent_L2__r.mdm_id__c,parent_L2__r.geography_type__c,parent_L2__r.parent_L2__c,parent_L2__r.parent_L2__r.Name,parent_L2__r.parent_L2__r.mdm_id__c,parent_L2__r.parent_L2__r.geography_type__c FROM MDO_Geography__c';
    public String searchCountry{get;set;}// Hold country name to search
    public Boolean isNoResult{get;set;}//checking for rollout search
	private Set<String> existingPrjList =new Set <String>(); //list of ids of existing   projects associated with rollouts 
	public Boolean updateRollouts{get;set;}
    
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
                for (String field : Schema.SObjectType.MDO_Geography__c.fields.getMap().KeySet())
                {
                    if (field != IPM_ConstantUtils.SF_ID)
                    {
                        queryString+= field + ', ';
                    }
                } // change-3  query changes required following bottom up approach like from country to cluster /country group (parent_L2__r.name) / cluster parent_L2__r.parent_L2__r.name
                queryString+= SelectQueryString+' WHERE (Name LIKE \'' + String.escapeSingleQuotes(searchCountry) + likePerStr + '\' OR parent_L2__r.name LIKE \'' + String.escapeSingleQuotes(searchCountry) + likePerStr + '\') AND(Name!=null OR parent_L2__r.Name!=null OR parent_L2__r.parent_L2__r.Name!=null)';
                queryString+= ' AND geography_type__c = \''+IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRY+'\' AND parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRYGROUP+'\' AND Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_UNILEVERCLUSTER+'\' ORDER BY parent_L2__r.parent_L2__r.name,parent_L2__r.name,Name';
                queryString+= ' LIMIT 10000';
                mapUnileverCountries = new Map<String, MDO_Geography__c>(); 
              
                for(MDO_Geography__c geography : Database.query(queryString))
                {
                      mapUnileverCountries.put(geography.ISO_3166_1_Code__c, geography);
                }
                if(!mapUnileverCountries.isEmpty())
                {
                    generateWrappers();
                    generateSubWrappersForSearch(); 
                    changeCluster();
                    isNoResult=false;
                    
                }
                else
                {
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
    @TestVisible private void getUnileverCountries(){
        
        
        //GET A LIST OF ALL IPM COUNTRIES
        String queryString = 'SELECT ';
        //MDM Geography  MDO
        For (String field : Schema.SObjectType.MDO_Geography__c.fields.getMap().KeySet())
        { //change-3
            if (field != IPM_ConstantUtils.SF_ID)
            {
                queryString+= field + ', ';
            }
        }
        queryString+= SelectQueryString; // change-13
        queryString+= ' WHERE geography_type__c = \''+IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRY+'\' AND parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRYGROUP+'\' AND Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_UNILEVERCLUSTER+'\' ORDER BY parent_L2__r.parent_L2__r.name,parent_L2__r.name,Name';
        queryString+= ' LIMIT 10000';
            
        try{
            
            mapUnileverCountries = new Map<String, MDO_Geography__c>(); //change-5
            
            for(MDO_Geography__c geography : Database.query(queryString)) 
            {
                 mapUnileverCountries.put(geography.ISO_3166_1_Code__c, geography);
            }
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,GET_UNILEVER_COUNTRIES,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            isError = TRUE;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
        
    }
    
    /**
    *  @Description Method to Used for creating Wrapper which contains MCO related information and corresponding Countries.This wrapper is fetcing MCO based on
    * 				the project type having isActive flag true.It will fecth respective cluster,MCO and country from Geography wrapper.Then prepare a map for rollout generation for selected Geography. 
       The selected geogrpahy is updated in formula field of country object.This will check for already selected MCO or new MCO for wrapper generation.
        Used for displaying selected countries and Whether MCO needs to be enabled or disabled based on various conditions.
    *  @name generateWrappers
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    @TestVisible private void generateWrappers(){
    
    
        //GET A LIST OF ALL IPM COUNTRIES
       
            String queryString = 'SELECT ';
            //IPM Country
            for (String field : Schema.SObjectType.IPM_Country__c.fields.getMap().KeySet())
            {
                if (field != IPM_ConstantUtils.SF_ID)
                {
                    queryString+= field + ', ';
                }
            }
            queryString+= 'Local_Rollout__r.KeyMCO__c, Local_Rollout__r.Market_Cluster__c, Local_Rollout__r.MCO__c, ';
            queryString+= 'Id FROM IPM_Country__c ';
            
            if(project.IPMProject_Span__c.equalsIgnoreCase(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL))
            {
                queryString+= 'WHERE IPM_Regional_Project__c=:projectId AND IsActive__c = true LIMIT 50000';
            }
            else 
            {
                queryString+= 'WHERE IPM_Project__c =: projectId AND IsActive__c = true LIMIT 50000';
            }
           
            
            mapIPMCountries = new Map<String, IPM_Country__c>();
            
            for(IPM_Country__c ipmCountry : Database.query(queryString))
            {
                mapIPMCountries.put(ipmCountry.Country_Code__c, ipmCountry);
            }

            mapClusterWrappers = new Map<String, GeographyWrapper>();
            mapMCOWrappers = new Map<String, GeographyWrapper>();
            mapCountryWrappers = new Map<String, GeographyWrapper>();
            
            lstClusterWrappers = new List<GeographyWrapper>();
            
            Set<String> setDisabledClusterCodes = new Set<String>();
            Set<String> setDisabledMCOCodes = new Set<String>();
            
            setCountryCodesGlobal = new Set<String>();
            
            for (MDO_Geography__c country : mapUnileverCountries.values())
            { //change-4
            
             if(country.parent_L2__r.parent_L2__r.mdm_id__c != null && country.parent_L2__r.parent_L2__r.name!= null)
             {  
             	String MDOClusterCode = country.parent_L2__r.parent_L2__r.mdm_id__c;
             	String MDOMCOCode = country.parent_L2__r.mdm_id__c;
                if (MDOClusterCode != NOT_ASSIGNED_CLUSTER_CODE)
                { 
                    //cluster code 
                    //Cluster
                    GeographyWrapper clusterWrapper = new GeographyWrapper(MDOClusterCode, country.parent_L2__r.parent_L2__r.name, IPM_ConstantUtils.EMPTY_STRING_INITIAL);
                    if (mapClusterWrappers.containsKey(MDOClusterCode))
                    {
                        clusterWrapper = mapClusterWrappers.get(MDOClusterCode);
                    }
                   
                    //MCO Country_Group_Code__c --> L2 mdm id ,Country_Group_c L2 name
                    
                    GeographyWrapper mcoWrapper = new GeographyWrapper(MDOMCOCode, country.parent_L2__r.name, country.parent_L2__r.parent_L2__r.mdm_id__c);
                    if (mapMCOWrappers.containsKey(MDOMCOCode))
                    {
                        mcoWrapper = mapMCOWrappers.get(MDOMCOCode);
                    }
                    
                    //Country
                    GeographyWrapper countryWrapper = new GeographyWrapper(country.ISO_3166_1_Code__c, country.Name, MDOMCOCode);
                    
                    
                    if(mapIPMCountries.containsKey(country.ISO_3166_1_Code__c))
                    {
                        //Key MCO
                        IPM_Country__c countryObj = mapIPMCountries.get(country.ISO_3166_1_Code__c);
                        String countryClusterCode = countryObj.Local_Rollout__r.Market_Cluster__c;
                        String countryMCOCode = countryObj.Local_Rollout__r.MCO__c;
                        if(countryClusterCode == MDOClusterCode)
                        {
                        	clusterWrapper.rolloutPresentAtCluster = true;
                        }
                        if(countryMCOCode == MDOMCOCode)
                        {
                        	mcoWrapper.rolloutPresentAtMCO = true;
                        	updateRollouts = true;
                        }
                        mcoWrapper.key = countryObj.Local_Rollout__r.KeyMCO__c;
                        countryWrapper.selected = TRUE; // selected country -------------------------------------------
                        countryWrapper.rolloutStatus = countryObj.IPM_Rollout_Status__c;
                        setCountryCodesGlobal.add(country.ISO_3166_1_Code__c);
                        
                        
                        //Existing Regional Rollouts for Global Projects
                        if(countryObj.IPM_Regional_Project__c != null && project.IPMProject_Span__c.equalsIgnoreCase(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL))
                        {
                            setDisabledClusterCodes.add(MDOClusterCode);  
                        }
                    }
                    
                    if(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(project.IPM_Project_Type__c) && IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
                    {
                        if(MDOClusterCode.equalsIgnoreCase(project.Market_Cluster__c))
                        {
                            mapClusterWrappers.put(MDOClusterCode, clusterWrapper);
                        }
                    } 
                    else
                    {
                        mapClusterWrappers.put(MDOClusterCode, clusterWrapper);
                    }
                
                    mapMCOWrappers.put(MDOMCOCode, mcoWrapper);
                    mapCountryWrappers.put(country.ISO_3166_1_Code__c, countryWrapper);
                }
              }// null check    
            }
            
           
             
            For(GeographyWrapper clusterWrapper : mapClusterWrappers.values())
            {
                if(setDisabledClusterCodes.contains(clusterWrapper.code))
                {
                    clusterWrapper.clusterDisabled = true;
                    mapClusterWrappers.put(clusterWrapper.code, clusterWrapper);
                }
            }
            For(GeographyWrapper mcoWrapper : mapMCOWrappers.values())
            {
                if(setDisabledClusterCodes.contains(mcoWrapper.parentCode))
                {
                    mcoWrapper.mcoDisabled = true;
                    mapMCOWrappers.put(mcoWrapper.code, mcoWrapper);
                    setDisabledMCOCodes.add(mcoWrapper.code);
                }
            }
            For (GeographyWrapper countryWrapper : mapCountryWrappers.values())
            {
                if(setDisabledMCOCodes.contains(countryWrapper.parentCode))
                {
                    countryWrapper.countryDisabled = true;
                    mapCountryWrappers.put(countryWrapper.code, countryWrapper);
                }
            }
            lstClusterWrappers = sortWrappersByName(mapClusterWrappers.values());
            
            //SELECT FIRST SELECTED CLUSTER
            
            if(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equalsIgnoreCase(project.IPM_Project_Type__c) && IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)){
                List<IPM_Project_Rollout__c> lstRegionalRollout = new List<IPM_Project_Rollout__c>();
                lstRegionalRollout = [SELECT Id, MCO__c, Market_Cluster__c, IPM_Project__c 
                                                          FROM IPM_Project_Rollout__c 
                                                          WHERE Regional_Project__c=:project.Id AND isActive__c = true 
                                                          LIMIT 10000];
                if(lstRegionalRollout != null && !lstRegionalRollout.isempty())
                {
                    selectedCluster = lstRegionalRollout [0].Market_Cluster__c;
                }               
                
            } 
            else 
            {
                
                for(GeographyWrapper clusterWrapper : lstClusterWrappers)
                {
                    if (((selectedCluster == null) || (IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(selectedCluster)))&&(!clusterWrapper.clusterDisabled))
                    {
                        selectedCluster = clusterWrapper.code;
                    }
                }                
                if (((selectedCluster == NULL) || (IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(selectedCluster))) && (lstClusterWrappers!=null && !lstClusterWrappers.isEmpty() ))
                {
                    selectedCluster = lstClusterWrappers[0].code;
                }
            }
         
    }
    
    /**
    *  @Description Method to generate various sub wrappers used for display
    *  @name generateSubWrappersForSearch
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    @TestVisible private void generateSubWrappersForSearch(){
      
            lstMCOWrappers = new List<GeographyWrapper>();
            lstCountryWrappers = new List<GeographyWrapper>();
            
            //MCO SUB WRAPPERS
            
            if(lstClusterWrappers != NULL && !lstClusterWrappers.isEmpty())
            {
                selectedCluster = lstClusterWrappers[0].code;
            }
            
            for(GeographyWrapper mcoWrapper : mapMCOWrappers.values())
            {
                lstMCOWrappers.add(mcoWrapper);
            }
            if(!lstMCOWrappers.isEmpty())
            {
                lstMCOWrappers = sortWrappersByName(lstMCOWrappers);
                
                if ((lstMCOWrappers[0].code != NULL) || (lstMCOWrappers[0].code !=IPM_ConstantUtils.EMPTY_STRING_INITIAL))
                {
                    selectedMCO = lstMCOWrappers[0].code;
                    previouselectedMCO = lstMCOWrappers[0].code;
                } 
            }
            
            //COUNTRY SUB WRAPPERS
            
            for(GeographyWrapper countryWrapper : mapCountryWrappers.values())
            {
                if(setCountryCodesGlobal.contains(countryWrapper.code))
                {
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
    @TestVisible private void generateSubWrappers(){
        try{
            lstMCOWrappers = new List<GeographyWrapper>();
            lstCountryWrappers = new List<GeographyWrapper>();
            
            //MCO SUB WRAPPERS
            for(GeographyWrapper mcoWrapper : mapMCOWrappers.values()){
                if(mcoWrapper.parentCode.equalsIgnoreCase(selectedCluster))
                {
                    lstMCOWrappers.add(mcoWrapper);
                }
            }
            lstMCOWrappers = sortWrappersByName(lstMCOWrappers);
            
            if (!lstMCOWrappers.isEmpty() && (selectedMCO == NULL) || (IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(selectedMCO)))
            {
                selectedMCO = lstMCOWrappers[0].code;
                
                previouselectedMCO = lstMCOWrappers[0].code;
                
            }
            //COUNTRY SUB WRAPPERS
            
            for(GeographyWrapper countryWrapper : mapCountryWrappers.values())
            {
                
                if(countryWrapper.parentCode.equalsIgnoreCase(selectedMCO))
                {
                    if(setCountryCodesGlobal.contains(countryWrapper.code))
                    {
                        countryWrapper.selected = true;
                    }
                        
                    lstCountryWrappers.add(countryWrapper);
                    
                }
            }
            
            
            lstCountryWrappers = sortWrappersByName(lstCountryWrappers);
            if(selectedMCO!=null)
            {
                selectedKey = mapMCOWrappers.get(selectedMCO).key; 
            }
            
            
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,GENERATE_SUBWRAPPERS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
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
      
            if(project.IPMProject_Span__c != IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
            {
                mapMCOWrappers.get(previouselectedMCO).key = selectedKey; 
            }
            selectedMCO = null;
            selectedKey = false;
            processCountryCodeLists();
            generateSubWrappers();
            
        
    }
    
    /**
    *  @Description Method invoked when the various MCO tabs on the visualforce page are clicked
    *  @name changeMCO
    *  @param NONE
    *  @return NONE
    *  @throws Exception
    */
    public void changeMCO(){
        try 
        {
            if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c) || (IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(project.IPM_Project_Type__c) && IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)))
            {
                mapMCOWrappers.get(previouselectedMCO).key = selectedKey;
            } 
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
            isError = TRUE;
            errorMessage = Label.IPM_Generic_ErrorMessage;
        }
    }
    
    /*******************************************************************************************************
    * @description  Method to redirect page
    * @param        NONE
    * @return       Page Reference
    */
    public PageReference redirectPage()
    {
        try 
        {
            PageReference rolloutPlans = Page.IPM_RolloutPlans;
            rolloutPlans.getParameters().put(IPM_ConstantUtils.SF_ID, projectId); 
            rolloutPlans.getParameters().put(IPM_ConstantUtils.EDITMODE, IPM_ConstantUtils.EDITMODE_FALSE );               
            rolloutPlans.setRedirect(true);
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
    *  @Description Method to process various country codes selected as part of User operation.
         setCountryCodesGlobal - Contains information about selected MCO's at global level.
         setCountryCodesMCOs - Contains selection of Countries selected by user in VF Page.
         Eventually we will have the list which contains selections for MCO, Countries from User.
    *  @name processCountryCodeLists
    *  @param NONE
    *  @return NONE
    */
    @TestVisible private void processCountryCodeLists()
    {
          //INITIALISE
            //Global
            
            if(setCountryCodesGlobal == null)
            {
                setCountryCodesGlobal = new Set<String>();
            }
            
            if(setCountryCodesGlobalUnselected == null)
            {
                setCountryCodesGlobalUnselected = new Set<String>();
            }
            
            //REGIONAL - MCO
            if(setCountryCodesMCOs == null)
            {
                setCountryCodesMCOs = new Set<String>();
            }
            
            if(setCountryCodesMCOsUnselected == null)
            {
                setCountryCodesMCOsUnselected = new Set<String>();
            }
            
            //REGIONAL - Country
            if(setCountryCodes == null)
            {
                setCountryCodes = new Set<String>();
            }
            
            if(setCountryCodesUnselected == null)
            {
                setCountryCodesUnselected = new Set<String>();
            }
            
            //REGIONAL - No ROllouts
            if(setCountryNoRolls == null)
            {
                setCountryNoRolls = new Set<String>();
            }
            
            if(setCountryNoRollsUnselected == null)
            {
                setCountryNoRollsUnselected = new Set<String>();
            }
            
            
            //PROCESS GLOBAL - ADD the values to the existing list
            if(globalCountries!=null && globalCountries!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = globalCountries.split(IPM_ConstantUtils.COMMA); 
                setCountryCodesGlobal.addAll(lstTemp);
            }
            
            if(globalUnselectedCountries!=null && globalUnselectedCountries!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = globalUnselectedCountries.split(IPM_ConstantUtils.COMMA); 
                setCountryCodesGlobalUnselected.addAll(lstTemp);
            }
            
            setCountryCodesGlobal.removeAll(setCountryCodesGlobalUnselected);

           // MCO LEVEL ROLLOUT PROCESS
            if(regionalMco!=null && regionalMco!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = regionalMco.split(IPM_ConstantUtils.COMMA);   
                setCountryCodesMCOs.addAll(lstTemp);  
            }
            
            // Get non selected MCO Country Codes  
            if(regionalUnselectedMco!=null && regionalUnselectedMco!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = regionalUnselectedMco.split(IPM_ConstantUtils.COMMA); 
                setCountryCodesMCOsUnselected.addAll(lstTemp);    
            }
            
            setCountryCodesMCOs.removeAll(setCountryCodesMCOsUnselected);
            
            // COUNTRY LEVEL ROLLOUT PROCESS 
            if(regionalCountry!=null && regionalCountry!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = regionalCountry.split(IPM_ConstantUtils.COMMA); 
                setCountryCodes.addAll(lstTemp);
            }
            
            if(regionalUnselectedCountry!=null && regionalUnselectedCountry!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = regionalUnselectedCountry.split(IPM_ConstantUtils.COMMA); 
                setCountryCodesUnselected.addAll(lstTemp);
            }
            
            setCountryCodes.removeAll(setCountryCodesUnselected);
            
            // NO ROLLOUT LIST PROCESS 
            if(regionalNoRoll!=null && regionalNoRoll!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = regionalNoRoll.split(IPM_ConstantUtils.COMMA); 
                setCountryNoRolls.addAll(lstTemp);
            }
            
            if(regionalUnselectedNoRoll!=null && regionalUnselectedNoRoll!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = regionalUnselectedNoRoll.split(IPM_ConstantUtils.COMMA); 
                setCountryNoRollsUnselected.addAll(lstTemp);
            }
            
            setCountryNoRolls.removeAll(setCountryNoRollsUnselected);       
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
    @TestVisible private void processRollouts()
    { 
        REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId();
        LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
        
        mapExistingRollouts = new Map<String,IPM_Project_Rollout__c>();
        mapExistingCountries = new Map<String,IPM_Country__c>();
        setExistingCountriesRegionalProject = new Set<String>();
        mapUpsertRegionalRollouts = new Map<String, IPM_Project_Rollout__c>();
        mapUpsertRollouts = new Map<String, IPM_Project_Rollout__c>();
        mapUpsertCountries = new Map<String,IPM_Country__c>();
        deleteRolloutsMap = new Map<String,IPM_Project_Rollout__c>();
        deleteCountriesMap = new Map<String,IPM_Country__c>();
        
        //Existing Rollouts
        String queryString = 'SELECT Id,Local_Project__c, IPM_Rollout_Project__c,Regional_Project__c,Type__c,Added_At_Stage__c,isActive__c,KeyMCO__c,IPM_CharterApproved__c,';
        queryString+= '(SELECT Id, Country_Code__c, Country_Name__c,AddedAtStage__c,IPM_CharterApproved__c,isActive__c,Project_Country__c, IPM_Rollout_Status__c, IPM_Regional_Project__c,Local_Rollout_Charter__c FROM IPM_Countries_Local__r) ';
        queryString+= 'FROM IPM_Project_Rollout__c ';
        if (IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            queryString+= ' WHERE IPM_Project__c =: projectId LIMIT 10000';
        }
        else if (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            queryString+= ' WHERE Regional_Project__c =: projectId LIMIT 10000';
        }

        for(IPM_Project_Rollout__c ipmRollout : Database.query(queryString))
        {
            mapExistingRollouts.put(ipmRollout.IPM_Rollout_Project__c, ipmRollout);
			existingPrjList.add(ipmRollout.Local_Project__c);
        }
        
        //Countries
        queryString = null;
        queryString = 'SELECT Id, Country_Code__c, Country_Name__c,AddedAtStage__c,IPM_CharterApproved__c,isActive__c,Project_Country__c, IPM_Rollout_Status__c, IPM_Regional_Project__c,Local_Rollout_Charter__c FROM IPM_Country__c ';
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
                mapExistingCountries.put(country.Project_Country__c, country);
            }
        }
       
        
        if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c) || ( ( IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c ) ) && ( IPM_ConstantUtils.PHASE_IDEAS.equalsIgnoreCase(project.IPM_phase__c) ) ) )
        { 
        	processUnSelectedCountries(setCountryCodesGlobalUnselected,IPM_ConstantUtils.ROLLOUT_TYPE_MCO);
        
        	processGlobalMCORollouts();
        } 
        else if (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)) 
        {      
        		processUnSelectedCountries(setCountryCodesMCOsUnselected,IPM_ConstantUtils.ROLLOUT_TYPE_MCO);
        		processUnSelectedCountries(setCountryCodesUnselected,IPM_ConstantUtils.ROLLOUT_TYPE_COUNTRY);
            	processUnSelectedCountries(setCountryNoRolls,IPM_ConstantUtils.ROLLOUT_TYPE_COUNTRY);
                
                processRegionalMCORollouts();
                processRegionalCountryRollouts(); 
        }
        

        if(!mapUpsertRegionalRollouts.isEmpty())
        {
            // Remove Id from Upsert call in case it is an insert that might happen for record which got deleted as part of above operation
            for(IPM_Project_Rollout__c regionalRollout : mapUpsertRegionalRollouts.values())
            {
                regionalRollout.Id = null;
            }
            upsert mapUpsertRegionalRollouts.values() IPM_Rollout_Project__c;
        }
        if(!deleteRolloutsMap.isEmpty())
        {
            Set<Id> localRolloutProjectIds = new Set<Id>();
            
            Map<Id,IPM_Project_Rollout__c> filteredDeleteRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
            // Rollouts that might have deleted as part of Trigger Logic of updating Key Rollouts To Non Keys.
            List<IPM_Project_Rollout__c> rolloutListToDelete = [Select Id,Name,Local_Project__c,IPM_Rollout_Project__c,IPM_CharterApproved__c,isActive__c from IPM_Project_Rollout__c where IPM_Rollout_Project__c  in :deleteRolloutsMap.KeySet() AND isActive__c = true  ];
            
            for(IPM_Project_Rollout__c rollout : rolloutListToDelete)
            {
                if(rollout.IPM_CharterApproved__c || rollout.Local_Project__c!=null)
                 {
                    localRolloutProjectIds.add( rollout.Local_Project__c);
                    rollout.isActive__c = false;
                    mapUpsertRollouts.put(rollout.IPM_Rollout_Project__c,rollout);
                 }
                 else
                 {
                    filteredDeleteRolloutMap.put(rollout.Id,rollout);
                 }
                 
            }
            
            
            List<IPM_Project__c> toBeArchievedRolloutProjects =[Select Id,Is_Archieved__c,Name from IPM_Project__c where  Id IN :localRolloutProjectIds];
            
            
            if(toBeArchievedRolloutProjects!=null && !toBeArchievedRolloutProjects.isEmpty())
            {
              	
              for(IPM_Project__c rollOutProj : toBeArchievedRolloutProjects) 
              {
                rollOutProj.Is_Archieved__c=true; 
              }
             
            update   toBeArchievedRolloutProjects ;
              
            }
            delete filteredDeleteRolloutMap.values(); 
        }
        if(!deleteCountriesMap.isEmpty())
        {   
            Map<Id,IPM_Country__c> filteredDeleteCountryMap = new Map<Id,IPM_Country__c>();
            // Before deleting Query the Countries again to validate whether certain countries got deleted as part of Rollout Deletion.
            List<IPM_Country__c> countryListToDelete = [Select Id,Project_Country__c,IPM_CharterApproved__c,isActive__c from IPM_Country__c where Project_Country__c in :deleteCountriesMap.KeySet() AND isActive__c = true ];
            for(IPM_Country__c country : countryListToDelete)
            {
                if(country.IPM_CharterApproved__c)
                {
                    country.isActive__c = false;
                    mapUpsertCountries.put(country.Project_Country__c,country);
                }
                else
                {
                    filteredDeleteCountryMap.put(country.Id,country);
                }
            }                  
            delete filteredDeleteCountryMap.values();
        }
        
        if(!mapUpsertRollouts.isEmpty())
        {
        	Set<String> unarchPrjIds =new  Set<String>(); // list of ids of projects to be unarchieved
            // Remove Id from Upsert call in case it is an insert that might happen for record which got deleted as part of above operation
            for(IPM_Project_Rollout__c localRollout : mapUpsertRollouts.values())
            {
                localRollout.Id = null;
            }
            upsert mapUpsertRollouts.values() IPM_Rollout_Project__c;
			for(IPM_Project_Rollout__c  rollout : mapUpsertRollouts.values())
			{
				if(rollout.isActive__c)
				{
					if(rollout.Local_Project__c != null && existingPrjList.contains(rollout.Local_Project__c))
					{
						unarchPrjIds.add(rollout.Local_Project__c);
					}
				}
			} 
			List<IPM_Project__c> tobeStrtdPrjcts =[Select Id,Is_Archieved__c,Name from IPM_Project__c where  Id IN :unarchPrjIds and Is_Archieved__c=true];
			if(tobeStrtdPrjcts!=null && !tobeStrtdPrjcts.isEmpty())
            {
              for(IPM_Project__c strtPrj : tobeStrtdPrjcts) 
              {
                strtPrj.Is_Archieved__c=false; 
              }
            update   tobeStrtdPrjcts ;
            }
        }
        
        if(!mapUpsertCountries.isEmpty())
        { 
            // Remove Id from Upsert call in case it is an insert that might happen for record which got deleted as part of above operation
            for(IPM_Country__c country : mapUpsertCountries.values())
            {
                country.Id = null;
            }
            upsert mapUpsertCountries.values() Project_Country__c;
        }
        
            
            
                
            
        
            
    }
    
    /**
    *  @Description Method to process Global MCO Rollouts. This specifies the Top Level Project MCO Selection where we process selected and unselected MCO List.
        Creates regional Rollouts based on User Selected MCO's. Also local Rollouts are created based on User Selection. 
        Neccessary data and relationships between rollout,country and Projects are created here.
        Deletion of Unselected MCO and countries are performed as well.
    *  @name processGlobalMCORollouts
    *  @param NONE
    *  @return NONE
    */
    @TestVisible private void processGlobalMCORollouts()
    {    
        //MCO Rollouts
        for (String countryCodeGlobal : setCountryCodesGlobal)
        {
            MDO_Geography__c geography = mapUnileverCountries.get(countryCodeGlobal);
            
            // Get Local Rollout Name.
            String mcoRolloutName = getKeyMCORolloutName(countryCodeGlobal);
            Boolean KeyMCO = mapMCOWrappers.get(geography.parent_L2__r.mdm_id__c).key;
            
            // Get Regional Rollout Name.
            String regionalRolloutName = getRegionalRolloutName(countryCodeGlobal); 
            
            String countryExternalId = getCountryExternalId(countryCodeGlobal);
           
            IPM_Project_Rollout__c regionalRollout = null;
            IPM_Project_Rollout__c mcoRollout = null;
            IPM_Country__c ipmCountry = null;
           
            // Check if it is an existing Regional Rollout. If yes check if it inactive, make it active.
            if(mapExistingRollouts.containsKey(regionalRolloutName) )
            {
                regionalRollout = mapExistingRollouts.get(regionalRolloutName);
            }
            else 
            {  
                if(mapUpsertRegionalRollouts.containsKey(regionalRolloutName))
                {
                    regionalRollout = mapExistingRollouts.get(regionalRolloutName);
                }
                else
                {   
                    // Only add Regional Rollouts for Global Original Projects.Dont create Regional Rollouts for Regional Original 
                   if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
                   {
                       	regionalRollout = new IPM_Project_Rollout__c(
                        RecordTypeId=REGIONAL_ROLLOUT_RECORDTYPE,
                        IPM_Rollout_Span__c = IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL,
                        Name = regionalRolloutName,
                        IPM_Rollout_Project__c = regionalRolloutName,
                        Added_At_Stage__c = project.IPM_Phase__c,
                        Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c
                        );  
                   } 
                }
            }
            
            if(regionalRollout!=null)
            {
            	regionalRollout.IPM_Project__c = project.Id;
                regionalRollout.Market_Cluster__c = geography.parent_L2__r.parent_L2__r.mdm_id__c;
                regionalRollout.Market_Cluster_Name__c = geography.parent_L2__r.parent_L2__r.name;
            	if(!regionalRollout.isActive__c || deleteRolloutsMap.containsKey(regionalRollout.IPM_Rollout_Project__c))
            	{
            	    // Udpate TLD only if it is a new Rollout or InActive Rollout.
            	    if(!regionalRollout.isActive__c)
            	    {
            	        regionalRollout.Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c;
            	    }
            	if(deleteRolloutsMap.containsKey(regionalRollout.IPM_Rollout_Project__c))
            	{
            		deleteRolloutsMap.remove(regionalRollout.IPM_Rollout_Project__c);
            	}
            	
                	regionalRollout.isActive__c = true;
            		
            		regionalRollout.Added_At_Stage__c = project.IPM_Phase__c;
            		mapUpsertRegionalRollouts.put(regionalRolloutName, regionalRollout);
            	}
            	
            }
            
            // Check if there is an existing Local Rollout.
            if (mapExistingRollouts.containsKey(mcoRolloutName) ) 
            {
                mcoRollout = mapExistingRollouts.get(mcoRolloutName);
            }
            else
            {
                if(mapUpsertRollouts.containsKey(mcoRolloutName))
                {
                    mcoRollout = mapUpsertRollouts.get(mcoRolloutName);
                }
                else
                {
                    mcoRollout = new IPM_Project_Rollout__c
                    ( 
                        RecordTypeId=LOCAL_ROLLOUT_RECORDTYPE,
                        Name = mcoRolloutName, 
                        Added_At_Stage__c = project.IPM_Phase__c,
                        Type__c = IPM_ConstantUtils.ROLLOUT_TYPE_MCO,                
                        IPM_Rollout_Span__c = IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL,               
                        IPM_Rollout_Project__c = mcoRolloutName,
                        Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c
                    );
                }
            }
            
           
            if(mcoRollout!=NULL)
            {
            	
            	
            	
                mcoRollout.Name = mcoRolloutName;
                mcoRollout.MCO__c = geography.parent_L2__r.mdm_id__c;
                mcoRollout.MCO_Name__c = geography.parent_L2__r.name;
                mcoRollout.Market_Cluster__c = geography.parent_L2__r.parent_L2__r.mdm_id__c;
                mcoRollout.Market_Cluster_Name__c = geography.parent_L2__r.parent_L2__r.name;
                
                
                if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
                {
                    mcoRollout.IPM_Project__c = project.Id;
                    mcoRollout.Regional_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = regionalRolloutName);
                }
                else
                {
                    mcoRollout.Regional_Project__c = project.Id;
                }
            	if(!mcoRollout.isActive__c || deleteRolloutsMap.containsKey(mcoRollout.IPM_Rollout_Project__c))
            	{
            	    if(!mcoRollout.isActive__c)
            	    {
            	        mcoRollout.Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c;
            	    }
            	    if(deleteRolloutsMap.containsKey(mcoRollout.IPM_Rollout_Project__c))
            	    {
            	        deleteRolloutsMap.remove(mcoRollout.IPM_Rollout_Project__c);
            	    }
                	mcoRollout.isActive__c = true;
                	mcoRollout.Added_At_Stage__c = project.IPM_Phase__c;
            		mapUpsertRollouts.put(mcoRolloutName, mcoRollout);
            	}
            	if(mcoRollout.KeyMCO__c == null || (mcoRollout.KeyMCO__c != KeyMCO) )
            	{
            		mcoRollout.KeyMCO__c = mapMCOWrappers.get(geography.parent_L2__r.mdm_id__c).key;
            		mapUpsertRollouts.put(mcoRolloutName, mcoRollout);	
                }
            }
            
            
            if(mapExistingCountries.containsKey(countryExternalId))
            {
                ipmCountry = mapExistingCountries.get(countryExternalId);
            }
            else
            {
                if(mapUpsertCountries.containsKey(countryExternalId))
                {
                    ipmCountry = mapUpsertCountries.get(countryExternalId);
                }
                else
                {
                    //Add new country to existing MCO rollout
                    ipmCountry = new IPM_Country__c
                    (
                        Project_Country__c = countryExternalId,
                        AddedAtStage__c = project.IPM_Phase__c,
                        Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoRolloutName)
                    );
                }
            }
            
            if(ipmCountry !=null)
            {
            	
        			ipmCountry.isActive__c = true;	 
            	
                ipmCountry.MDO_Geography__c = geography.Id;
                ipmCountry.IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO;
              
                if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
                {
                    ipmCountry.IPM_Project__c = project.Id;
                }
                else
                {
                    ipmCountry.IPM_Regional_Project__c = project.Id;
                }
            	if(deleteCountriesMap.containsKey(ipmCountry.Project_Country__c))
            	{
            		deleteCountriesMap.remove(ipmCountry.Project_Country__c);
            	}
            	if(!ipmCountry.isActive__c)
        		{
        			ipmCountry.AddedAtStage__c = project.IPM_Phase__c;
        		}
                mapUpsertCountries.put(ipmCountry.Project_Country__c,ipmCountry);
            }                
        }
    }
    
    /**
    *  @Description Used for creating MCO rollouts at regional Level based on user selected and unselected MCO List.
        Creates local Rollouts based on User Selected MCO's. Checks if there was a switch made between 'Country specific', 'No Rollout' to 'Part of MCO Rollout' 
        Neccessary data and relationships between rollout,country and Projects are created here.
        Deletion of Unselected MCO and countries are performed as well.
    *  @name processRegionalMCORollouts
    *  @param NONE
    *  @return NONE
    */
    @TestVisible private void processRegionalMCORollouts()
    {
        for (String countryCodeMCO : setCountryCodesMCOs)
        { 
            MDO_Geography__c geography = mapUnileverCountries.get(countryCodeMCO);
            
            // Get Rollout Name.
            String mcoRolloutName = getKeyMCORolloutName(countryCodeMCO);
            String countryExternalId = getCountryExternalId(countryCodeMCO);
            
            
            IPM_Country__c ipmCountry = null;
            IPM_Project_Rollout__c newMCORollout = null; 

            // Check if rollout Already Exists. If yes check whether it is active or not.
            if(mapExistingRollouts.containsKey(mcoRolloutName))
            {
                newMCORollout = mapExistingRollouts.get(mcoRolloutName);
            }
            else 
            {
                if(mapUpsertRollouts.containsKey(mcoRolloutName))
                {
                    newMCORollout = mapUpsertRollouts.get(mcoRolloutName);
                }
                else
                {
                    newMCORollout = new IPM_Project_Rollout__c
                    (
                        RecordTypeId = LOCAL_ROLLOUT_RECORDTYPE,
                        Name = mcoRolloutName,
                        IPM_Rollout_Project__c = mcoRolloutName,
                        Added_At_Stage__c = project.IPM_Phase__c,
                        Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c
                    );
                    
                    if(project.IPM_phase__c != IPM_ConstantUtils.PHASE_IDEAS)
                    {
                    	newMCORollout.KeyMCO__c = true;	
                    }
                }
            }
            
            if(newMCORollout!=null)
            {
                newMCORollout.IPM_Rollout_Span__c = IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL;
                newMCORollout.Type__c = IPM_ConstantUtils.ROLLOUT_TYPE_MCO;
                newMCORollout.MCO__c = geography.parent_L2__r.mdm_id__c;
                newMCORollout.MCO_Name__c = geography.parent_L2__r.name;
                newMCORollout.Market_Cluster__c = geography.parent_L2__r.parent_L2__r.mdm_id__c;
                newMCORollout.Market_Cluster_Name__c = geography.parent_L2__r.parent_L2__r.name;
                newMCORollout.Regional_Project__c = project.Id;
                
                
                if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)
                {
                	newMCORollout.IPM_Project__c = project.IPM_Parent_Project__c;
                }
                
                if(deleteRolloutsMap.containsKey(newMCORollout.IPM_Rollout_Project__c) || !newMCORollout.isActive__c)
                {
                    if(!newMCORollout.isActive__c)
                    {
                        newMCORollout.Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c;
                    }
                    if(deleteRolloutsMap.containsKey(newMCORollout.IPM_Rollout_Project__c))
                    {
                        deleteRolloutsMap.remove(newMCORollout.IPM_Rollout_Project__c);
                    }
                	newMCORollout.isActive__c = true;
                	newMCORollout.Added_At_Stage__c = project.IPM_Phase__c;
                	if(project.IPM_phase__c != IPM_ConstantUtils.PHASE_IDEAS)
                    {
                    	newMCORollout.KeyMCO__c = true;	
                    }
                    mapUpsertRollouts.put(mcoRolloutName, newMCORollout);
                }
                mapUpsertRollouts.put(mcoRolloutName, newMCORollout);
            }
            // Check if Country Exists. If yes validate whether it is associated with country Rollout
            if(mapExistingCountries.containsKey(countryExternalId))
            {
                ipmCountry = mapExistingCountries.get(countryExternalId);
            }
            else
            {
                if(mapUpsertCountries.containsKey(countryExternalId))
                {
                    ipmCountry = mapUpsertCountries.get(countryExternalId);
                }
                else
                {
                    //Add new country to existing MCO rollout
                    ipmCountry = new IPM_Country__c
                    (
                        Project_Country__c = countryExternalId,
                        AddedAtStage__c = project.IPM_Phase__c
                    );
                }
            }
            
            if(ipmCountry!=null)
            {
                ipmCountry.isActive__c = true;
                ipmCountry.MDO_Geography__c = geography.Id;
                ipmCountry.IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO;
                ipmCountry.IPM_Regional_Project__c = project.Id;
                ipmCountry.Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoRolloutName);
                ipmCountry.IPM_Project__c = project.IPM_Parent_Project__c;
                
                if(deleteCountriesMap.containsKey(ipmCountry.Project_Country__c))
                {
                    deleteCountriesMap.remove(ipmCountry.Project_Country__c);
                }
                
                if(!ipmCountry.isActive__c)
                {
                    ipmCountry.AddedAtStage__c = project.IPM_Phase__c;   
                }
                mapUpsertCountries.put(ipmCountry.Project_Country__c,ipmCountry);
            }
        }
    }
    
    /**
    *  @Description Used for creating Country specific rollouts at regional Level based on user selected and unselected Country List.
        Creates local Rollouts based on User Selected Country. Invoked when user switches from 'Part of MCO' or 'No Rollout' to 'Country'. 
        Neccessary data and relationships between rollout,country and Projects are created here.
        Deletion of Unselected old Rollouts and countries are performed as well.
    *  @name processRegionalCountryRollouts
    *  @param NONE
    *  @return NONE
    */
    @TestVisible private void processRegionalCountryRollouts()
    {
        //Local Country Rollouts
        for(string countryCode : setCountryCodes)
        { 
            MDO_Geography__c geography = mapUnileverCountries.get(countryCode); 
            String countryRolloutName = getCountryExternalId(countryCode);
                
            IPM_Country__c ipmCountry = null;
            IPM_Project_Rollout__c newCountryRollout = null;
			
            // Check if Country Rollout exists for this Country. If yes update it else insert it.
            if(mapExistingRollouts.containsKey(countryRolloutName))
            {
                newCountryRollout = mapExistingRollouts.get(countryRolloutName);
            } 
            else
            {
                if(mapUpsertRollouts.containsKey(countryRolloutName))
                {
                    newCountryRollout = mapUpsertRollouts.get(countryRolloutName);
                }
                else
                {
                   newCountryRollout = new IPM_Project_Rollout__c
                   (
                        RecordTypeId=LOCAL_ROLLOUT_RECORDTYPE,
                        Name = countryRolloutName,
                        IPM_Rollout_Project__c = countryRolloutName,
                        Added_At_Stage__c = project.IPM_Phase__c,
                        Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c
                    );
                    
                    if(project.IPM_phase__c != IPM_ConstantUtils.PHASE_IDEAS)
                    {
                    	newCountryRollout.KeyMCO__c = true;	
                    } 
                }
            }
			
            if(newCountryRollout!=null)
            {

                newCountryRollout.IPM_Rollout_Span__c = IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL;
                newCountryRollout.Type__c = IPM_ConstantUtils.ROLLOUT_TYPE_COUNTRY;
                newCountryRollout.MCO__c = geography.parent_L2__r.mdm_id__c;
                newCountryRollout.MCO_Name__c = geography.parent_L2__r.name;
                newCountryRollout.Market_Cluster__c = geography.parent_L2__r.parent_L2__r.mdm_id__c;
                newCountryRollout.Market_Cluster_Name__c = geography.parent_L2__r.parent_L2__r.name;
                newCountryRollout.Regional_Project__c = project.Id;
                 
                
                if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT) 
                {
                	newCountryRollout.IPM_Project__c = project.IPM_Parent_Project__c;
                }
                
            	if(!newCountryRollout.isActive__c || deleteRolloutsMap.containsKey(newCountryRollout.IPM_Rollout_Project__c))
                {
                    if(!newCountryRollout.isActive__c)
                    {
                        newCountryRollout.Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c;
                    }
                    if(deleteRolloutsMap.containsKey(newCountryRollout.IPM_Rollout_Project__c))
                    {
                        deleteRolloutsMap.remove(newCountryRollout.IPM_Rollout_Project__c);    
                    }
                	newCountryRollout.isActive__c = true;
                	newCountryRollout.Added_At_Stage__c = project.IPM_Phase__c;
                
                	if(project.IPM_phase__c != IPM_ConstantUtils.PHASE_IDEAS)
                    {
                        newCountryRollout.KeyMCO__c = true; 
                    } 
                mapUpsertRollouts.put(countryRolloutName, newCountryRollout);
                }
                
            }
            
            //Check if Country exists. If it already exists update Status and reference of Local Rollout as separate Country Rollout.
            if(mapExistingCountries.containsKey(countryRolloutName))
            {
                ipmCountry = mapExistingCountries.get(countryRolloutName);
            }
            else 
            {
               if(mapUpsertCountries.containsKey(countryRolloutName))
               {
                  ipmCountry =  mapUpsertCountries.get(countryRolloutName);
               } 
               else
               { 
                    ipmCountry = new IPM_Country__c
                    (
                        Project_Country__c = countryRolloutName,
                        AddedAtStage__c = project.IPM_Phase__c
                    );
               }
            }
            
           if(ipmCountry !=null)
           {
                ipmCountry.isActive__c = true;
                ipmCountry.MDO_Geography__c = geography.Id;
                ipmCountry.IPM_Regional_Project__c = project.Id;
                ipmCountry.Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = countryRolloutName);
                ipmCountry.IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_SEPERATE;
                ipmCountry.IPM_Local_Project__c=null;//added to cover the source data for DEF3821
                
                if(project.IPM_Project_Type__c != IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
                {
                    ipmCountry.IPM_Project__c = project.IPM_Parent_Project__c;
                }
                
                if(deleteCountriesMap.containsKey(ipmCountry.Project_Country__c))
                {
                    deleteCountriesMap.remove(ipmCountry.Project_Country__c);
                }
                if(!ipmCountry.isActive__c)
                {
                    ipmCountry.AddedAtStage__c = project.IPM_Phase__c;
                }
                mapUpsertCountries.put(ipmCountry.Project_Country__c,ipmCountry);
           }
            
            
        }   
    }
    
    /**
    *  @Description Method to get Regional Rollout Name
    *  @name getRegionalRolloutName
    *  @param countryCode    Country code for which the regional rollout name needs o be generated
    *  @return Regional Rollout Name
    */
    
    @TestVisible private String getRegionalRolloutName(String countryCode)
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
                return project.IPM_Project_Name__c + IPM_ConstantUtils.UNDERSCORE + shortName;                
            }
        }
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,GET_REGIONAL_ROLLOUT_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
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
    */
    @TestVisible private String getKeyMCORolloutName(String countryCode)
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
    */
    @TestVisible private String getCountryExternalId(String countryCode){        
        return getRegionalRolloutName(countryCode) + IPM_ConstantUtils.UNDERSCORE + countryCode;
    }
    
    /**
    *  @Description Method to sort the list of geography wrappers alphabetically
    *  @name sortWrappersByName
    *  @param wrappersToSort     List of unsorted Wrappers
    *  @return List of Sorted Wrappers
    *  @throws Exception
    */
    @TestVisible private List<GeographyWrapper> sortWrappersByName(List<GeographyWrapper> wrappersToSort) {
      
            if(wrappersToSort == null || wrappersToSort.size() <= 1)
            {
                return wrappersToSort;
            }
            
            List<GeographyWrapper> lessWrappers = new List<GeographyWrapper>();
            List<GeographyWrapper> greaterWrappers = new List<GeographyWrapper>();
            
            integer pivot = wrappersToSort.size() / 2;
            
            //save the pivot and remove it from the selectOption list
            GeographyWrapper pivotWrapper = wrappersToSort[pivot];
            wrappersToSort.remove(pivot);
            
            for(GeographyWrapper wrapper : wrappersToSort)
            {
                if(wrapper.name <= pivotWrapper.name)
                {
                    lessWrappers.add(wrapper);
                }
                else if(wrapper.name > pivotWrapper.name)
                {
                    greaterWrappers.add(wrapper);
                }
            }
            
            List<GeographyWrapper> sortedWrappers = new list<GeographyWrapper>(); 
            
            sortedWrappers.addAll(sortWrappersByName(lessWrappers));
            sortedWrappers.add(pivotWrapper);
            sortedWrappers.addAll(sortWrappersByName(greaterWrappers));
            
            return sortedWrappers;
                
    }
    
    /**
    *  @Description Method to deleted unselected Countries and Rollouts which earlier existed and now are removed as part of user selection.
    *  @name sortWrappersByName
    *  @param unselectedCountryCodes  unselected Country Codes which are used for create rollout specific names
    *  @return rolloutType - Indicates what type of rollouts need to be checked for deletion.
    */
    @TestVisible private void processUnSelectedCountries(Set<String> unselectedCountryCodes,String rolloutType)
    {
        Map<String,Set<String>> mcoRollNameToCountryCodeMap = new Map<String,Set<String>>();
        Map<String,Set<String>> countryRollNameToCountryCodeMap = new Map<String,Set<String>>();
        
        // Prepare the List of incoming Mco Name To Country Code.
        for (String countryCode : unselectedCountryCodes)
        {
            String mcoRolloutName = getKeyMCORolloutName(countryCode);
            
            if(!mcoRollNameToCountryCodeMap.containsKey(mcoRolloutName))
            {
                mcoRollNameToCountryCodeMap.put(mcoRolloutName,new Set<String>());
            }
            mcoRollNameToCountryCodeMap.get(mcoRolloutName).add(countryCode);
        }
        
        for (String countryCode : unselectedCountryCodes)
        {
            String countryRolloutName = getCountryExternalId(countryCode);
            
            if(!countryRollNameToCountryCodeMap.containsKey(countryRolloutName))
            {
                countryRollNameToCountryCodeMap.put(countryRolloutName,new Set<String>());
            }
            countryRollNameToCountryCodeMap.get(countryRolloutName).add(countryCode);
        }
        
        //Check to delete MCO Rollout if all selected Countries are removed.
        
        for(IPM_Project_Rollout__c ipmRollout : mapExistingRollouts.values())
        {

            if(IPM_ConstantUtils.ROLLOUT_TYPE_MCO.equalsIgnoreCase(rolloutType) && !mcoRollNameToCountryCodeMap.isEmpty())
            {
                removeReferences(mcoRollNameToCountryCodeMap,ipmRollout);
            }
            else if(IPM_ConstantUtils.ROLLOUT_TYPE_COUNTRY.equalsIgnoreCase(rolloutType) && !countryRollNameToCountryCodeMap.isEmpty())
            {
                removeReferences(countryRollNameToCountryCodeMap,ipmRollout);
            } 
        }     
    }
    
     /**
    *  @Description This is a helper method which does the actual deletion of unselected MCO and Country specific rollouts.
    *  @name sortWrappersByName
    *  @param unselectedCountryCodes  unselected Country Codes which are used for create rollout specific names
    *  @return rolloutType - Indicates what type of rollouts need to be checked for deletion.
    */
    
    @TestVisible private void removeReferences(Map<String,Set<String>> rolloutToCountryMap,IPM_Project_Rollout__c ipmRollout)
    {
        String ipmRolloutExternalId = ipmRollout.IPM_Rollout_Project__c;
        
        if(rolloutToCountryMap.containsKey(ipmRolloutExternalId))
        {
            Set<String> unselectedCountryCodes = rolloutToCountryMap.get(ipmRolloutExternalId);
            
            Map<Id,IPM_Country__c> completeRolloutCountryMap = new Map<Id,IPM_Country__c> ((List<IPM_Country__c>) ipmRollout.IPM_Countries_Local__r);
            Map<Id,IPM_Country__c> removedRolloutCountryMap = new Map<Id,IPM_Country__c>();
            
            for(IPM_Country__c ipmCountry : completeRolloutCountryMap.values())
            {
                if(unselectedCountryCodes.contains(ipmCountry.Country_Code__c))
                {
                        removedRolloutCountryMap.put(ipmCountry.Id,ipmCountry);
                        deleteCountriesMap.put(ipmCountry.Project_Country__c,ipmCountry);
                } 
            }
                
          
                       
            Set<Id> completeRolloutCountrySet = completeRolloutCountryMap.keySet();
            Set<Id> removedRolloutCountrySet = removedRolloutCountryMap.keySet();
            
            // Validate whether there are any countries under this Rollout. 
            // If no, check if it is charter Approved.If yes make it inactive else delete the rollout. 
            if(removedRolloutCountrySet.containsAll(completeRolloutCountrySet))
            {
                    
                    deleteRolloutsMap.put(ipmRollout.IPM_Rollout_Project__c,ipmRollout);
            }
            else
            {
                // there are active countries associated with Rollout.Get Remaining countries after removing removed countries.
                for(Id removedCountry : removedRolloutCountrySet)
                {
                    completeRolloutCountryMap.remove(removedCountry);
                }
                
                // Check if there are inactive Countries. If there is an active country do nothing.
                Boolean activeCountryFound = false;
                for(IPM_Country__c country : completeRolloutCountryMap.values())
                {
                    if(country.isActive__c)
                    {
                       activeCountryFound = true;
                       break; 
                    }
                    
                    // If there are no active countries,it means it has inactive countries which are charter approved.
                    if(!activeCountryFound)
                    {
                       deleteRolloutsMap.put(ipmRollout.IPM_Rollout_Project__c,ipmRollout);
                    }
                }
            } 
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
        public boolean rolloutPresentAtCluster{get;set;} 
        public Boolean mcoDisabled {get; set;}
        public boolean rolloutPresentAtMCO{get;set;}
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
            this.rolloutPresentAtCluster = false;
            this.rolloutPresentAtMCO = false;
        }
    }
}