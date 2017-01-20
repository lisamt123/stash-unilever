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
    public String retainedCountries{get; set;}
    
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
    
    @TestVisible private Map<String, IPM_Project_Rollout__c> mapUpsertRegionalRollouts; //Map of Regional Rollouts that need to be upserted
    @TestVisible private Map<String, IPM_Project_Rollout__c> mapUpsertRollouts; //Map of Local Rollouts that need to be upserted
    @TestVisible private Map<String, IPM_Project_Rollout__c> mapUpsertKeyNKRollouts; //Map of Local Rollouts Key/Non-Key to be updated for GKM3
    @TestVisible private Map<String,IPM_Country__c> mapUpsertCountries; //List of countries that need to be upserted
    
    @TestVisible private Map<String,IPM_Project_Rollout__c> deleteRolloutsMap; //List of Rollouts that need to be deleted
    @TestVisible private Map<Id,IPM_Project_Rollout__c> actualDeleteRolloutMap;
    @TestVisible private Set<Id> checkRolloutsForProjects;
    
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
    @TestVisible private static final Map<String, Schema.SObjectField> rolloutFieldMap = Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap();
    private static final String STR_ROLLOUT = 'Rollout';
    private static final String STR_COUNTRY = 'Country';
    public String searchCountry{get;set;}// Hold country name to search
    public Boolean isNoResult{get;set;}//checking for rollout search
    private Set<String> existingPrjList =new Set <String>(); //list of ids of existing   projects associated with rollouts 
    public Boolean updateRollouts{get;set;}
    public IPM_Country__c countryProj;
    public integer localProjCnt{get;set;}
    public boolean removeCountryFeasiCap {get;set;}
    public boolean removeCountryOtherFeasiCap {get;set;}
    public boolean countryRelatedProj {get;set;}
    public boolean invokedFromRollouts{get;set;}
    public boolean allRolloutFromSameMCO{get;set;}
    private Set<String > noRolloutDisabledCountrycodeSet = new Set<String >();
    private Set<Id> localRolloutProjectIds;
    public Set<Id> projPurgeIdSet = new Set<Id>();
    public Map<String,IPM_Country__c> existingRelatedCountriesMap;
    public Map<String,Set<String>> relatedMCOAndCountry;
    public String projectCategory{get;set;}
    public String UFS = 'UFS';
    Set<String> phaseTobeIncluded = new Set<String>{IPM_ConstantUtils.PHASE_IDEAS, IPM_ConstantUtils.PHASE_FEASIBILITY, IPM_ConstantUtils.PHASE_CAPABILITY};
    public Boolean isProjectGKM3{get {
            if(project.IPM_ProjectGKM__c == IPM_ConstantUtils.GKM_3) {
                return true;
            } else{ 
                return false; 
            }
        } set;}
    public String strMCOKeyHelp{get {
            if(project.IPM_ProjectGKM__c == IPM_ConstantUtils.GKM_3) {
                if(phaseTobeIncluded.contains(project.IPM_Phase__c)){
                    return Label.IPM_KEY_MCO_NEEDS_GKM3;
                }else{
                    return '';
                }
                 
            }else{ 
                return Label.IPM_KEY_MCO_NEEDS;
            }
        }
        set;
    }
    // Boolean used to disable the MCO selection- Currently It has been used only for GKM3
    public Boolean disableMCOSelection{get; set;}
    
    public String marketClusterName{get {
            if(project.Market_Cluster_Name__c != '') {
                return project.Market_Cluster_Name__c;
            } else{ 
                return null;
            }
        } set;}
	    
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
        localProjCnt = 0;
        invokedFromRollouts = false;
        initializeRollouts();
        // To disable the MCO selection on Add/Manage Rollout Screen
        IPM_Project_Type__c currentProjecttype = IPM_Utils.retrieveProjectType(project);
        
        if(currentProjecttype != null && currentProjecttype.IPM_Disable_Key_NonKey__c){
        	disableMCOSelection = true;
        }else {
        	disableMCOSelection = false; 
        }
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
        projectCategory = project.IPM_Category_Text__c;
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
            if(searchCountry!=null && searchCountry!='')
            {
                //GET A LIST OF ALL IPM COUNTRIES
                String likePerStr='%';
                String queryString = 'SELECT ';
                //MDM Geography . //change-2
                for (String field : Schema.SObjectType.MDO_Geography__c.fields.getMap().KeySet())
                {
                    if (!field.equalsIgnoreCase(IPM_ConstantUtils.SF_ID))
                    {
                        queryString+= field + ', ';
                    }
                } // change-3  query changes required following bottom up approach like from country to cluster /country group (parent_L2__r.name) / cluster parent_L2__r.parent_L2__r.name
	        queryString+= SelectQueryString+' WHERE (Name LIKE \'' + String.escapeSingleQuotes(searchCountry) + likePerStr + '\' OR parent_L2__r.name LIKE \'' + String.escapeSingleQuotes(searchCountry) + likePerStr + '\') AND(Name!=null OR parent_L2__r.Name!=null OR parent_L2__r.parent_L2__r.Name!=null)';
                // change for UFS country search
                if(projectCategory.contains(UFS)){
		   queryString+= ' AND geography_type__c = \''+IPM_ConstantUtils.IPM_GEOGRAPHY_UFS_COUNTRY+'\' AND parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_UFS_COUNTRYGROUP+'\' AND Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+'  AND parent_L2__r.parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_UFS_UNILEVERCLUSTER+'\' AND Excluded_Apps__c EXCLUDES ( \''+ IPM_ConstantUtils.IPM_Excluded_Apps+'\') ORDER BY parent_L2__r.parent_L2__r.name,parent_L2__r.name,Name';
                             	
               }
                else{
		      queryString+= ' AND geography_type__c = \''+IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRY+'\' AND parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRYGROUP+'\' AND Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+'  AND parent_L2__r.parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_UNILEVERCLUSTER+'\' AND Excluded_Apps__c EXCLUDES ( \''+ IPM_ConstantUtils.IPM_Excluded_Apps+'\') ORDER BY parent_L2__r.parent_L2__r.name,parent_L2__r.name,Name';
                	 
                }
                queryString+= ' LIMIT 10000';
                mapUnileverCountries = new Map<String, MDO_Geography__c>(); 
              
                for(MDO_Geography__c geography : Database.query(queryString))
                {
                    if(((marketClusterName==geography.Name || marketClusterName==geography.parent_L2__r.Name || 
                        marketClusterName==geography.parent_L2__r.parent_L2__r.Name) && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
                        || project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
                    {
                        mapUnileverCountries.put(geography.ISO_3166_1_Code__c, geography);
                    }
                    else
                    {
                        continue;
                    }
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
                    
                    lstClusterWrappers = new List<GeographyWrapper>();
                    lstMCOWrappers = new List<GeographyWrapper>();
                    lstCountryWrappers = new List<GeographyWrapper>();
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
            
            lstClusterWrappers = new List<GeographyWrapper>();
            lstMCOWrappers = new List<GeographyWrapper>();
            lstCountryWrappers = new List<GeographyWrapper>();
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
            if (!field.equalsIgnoreCase(IPM_ConstantUtils.SF_ID))
            {
                queryString+= field + ', ';
            }
        }
        queryString+= SelectQueryString; // change-13
        // changes for food solutions
        if(projectCategory.contains(UFS)){
	    queryString+= ' WHERE geography_type__c = \''+IPM_ConstantUtils.IPM_GEOGRAPHY_UFS_COUNTRY+'\' AND parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_UFS_COUNTRYGROUP+'\' AND Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_UFS_UNILEVERCLUSTER+'\' AND Excluded_Apps__c EXCLUDES ( \''+ IPM_ConstantUtils.IPM_Excluded_Apps+'\') ORDER BY parent_L2__r.parent_L2__r.name,parent_L2__r.name,Name';
        }
        else{
	     queryString+= ' WHERE geography_type__c = \''+IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRY+'\' AND parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRYGROUP+'\' AND Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+' AND parent_L2__r.Status__c ='+IPM_ConstantUtils.ACTIVE_STRING+'  AND parent_L2__r.parent_L2__r.geography_type__c =\''+IPM_ConstantUtils.IPM_GEOGRAPHY_UNILEVERCLUSTER+'\' AND Excluded_Apps__c EXCLUDES ( \''+ IPM_ConstantUtils.IPM_Excluded_Apps+'\') ORDER BY parent_L2__r.parent_L2__r.name,parent_L2__r.name,Name';
        }
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
    *               the project type having isActive flag true.It will fecth respective cluster,MCO and country from Geography wrapper.Then prepare a map for rollout generation for selected Geography. 
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
                if (!field.equalsIgnoreCase(IPM_ConstantUtils.SF_ID))
                {
                    queryString+= field + ', ';
                }
            }
            queryString+= 'IPM_Local_Project__r.IPM_No_Rollout_Disabled__c,Local_Rollout__r.KeyMCO__c,Local_Rollout__r.IPM_Project_Job_Status__c, Local_Rollout__r.Market_Cluster__c, Local_Rollout__r.MCO__c, ';
            queryString+= 'Id FROM IPM_Country__c ';
            
            if(project.IPMProject_Span__c != null && project.IPMProject_Span__c.equalsIgnoreCase(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL))
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
        
	        if(ipmCountry.IPM_Local_Project__r.IPM_No_Rollout_Disabled__c)
	        {
	          noRolloutDisabledCountrycodeSet.add(ipmCountry.Country_Code__c);
	        }
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
	private void generateWrapperHelper()
	{
            mapClusterWrappers = new Map<String, GeographyWrapper>();
            mapMCOWrappers = new Map<String, GeographyWrapper>();
            mapCountryWrappers = new Map<String, GeographyWrapper>();
            
            lstClusterWrappers = new List<GeographyWrapper>();
            
            Set<String> setDisabledClusterCodes = new Set<String>();
            Map<String,String> mapClusterToMCOCode = new map<String,String>();
            
            setCountryCodesGlobal = new Set<String>();
            setCountryCodes = new Set<String>();
            setCountryCodesMCOs = new Set<String>();
            setCountryNoRolls = new Set<String>(); 
            
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
                // call the function
                setDisabledClusterCodes = updateWrapperListOnCountrySelection(clusterWrapper,mcoWrapper,countryWrapper,country,MDOClusterCode,MDOMCOCode,mapClusterToMCOCode);


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
		 prepareGeographyWrappeprData(mapClusterToMCOCode,setDisabledClusterCodes);
		

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
	private Set<String> updateWrapperListOnCountrySelection(GeographyWrapper clusterWrapper, GeographyWrapper mcoWrapper, GeographyWrapper countryWrapper,MDO_Geography__c country,String MDOClusterCode,String MDOMCOCode,Map<String,String> mapClusterToMCOCode)
	{
		Set<String> setDisabledClusterCodes = new Set<String>(); 
        Set<String> underProcessingMCOCodes = new Set<String>();
                    // If country has been selected update the wrapper list
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
                        countryWrapper.selected = TRUE; // selected country 
                        countryWrapper.rolloutStatus = countryObj.IPM_Rollout_Status__c;
                        setCountryCodesGlobal.add(country.ISO_3166_1_Code__c);
                        
                        
                        //Existing Regional Rollouts for Global Projects
                        if(countryObj.IPM_Regional_Project__c != null && project.IPMProject_Span__c.equalsIgnoreCase(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL))
                        {
                        	setDisabledClusterCodes.add(MDOClusterCode);
                        }
                        else if(countryObj.Local_Rollout__c !=null && (countryObj.Local_Rollout__r.IPM_Project_Job_Status__c == IPM_ConstantUtils.JOB_STATUS_ELIGIBLE || countryObj.Local_Rollout__r.IPM_Project_Job_Status__c == IPM_ConstantUtils.JOB_STATUS_PROCESSING) )
                        {
                        	underProcessingMCOCodes.add(countryObj.MCO_Code__c);
                        }
                        if(countryObj.IPM_Local_Project__c!=null && project.IPM_ProjectGKM__c=='GKM3' )
                        {
                        	mapClusterToMCOCode.put(countryObj.MCO_Code__c,countryObj.Market_Cluster_Name__c);
                        }
                    }
                    
        return setDisabledClusterCodes;
	}
	
	 private void prepareGeographyWrappeprData( Map<String,String> mapClusterToMCOCode, Set<String> setDisabledClusterCodes)
	{   
        //Set<String> setDisabledClusterCodes = new Set<String>();
		Set<String> underProcessingMCOCodes = new Set<String>();
		Set<String> setDisabledMCOCodes = new Set<String>();
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
                if(!mapClusterToMCOCode.isEmpty() && mapClusterToMCOCode.containskey(mcoWrapper.code))
                {
                	mcoWrapper.mcoDisabled = true;
                	mapMCOWrappers.put(mcoWrapper.code, mcoWrapper);
                	setDisabledMCOCodes.addAll(mapClusterToMCOCode.values());
                }
                if(underProcessingMCOCodes.contains(mcoWrapper.code))
                {
                	mcoWrapper.mcoDisabled = true;
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
		selectFirstSelectedCluster();

	}
	/**
    *  @Description Method to Used for selection of first selected cluster and set the value for selected cluster
    *  @name updateWrapperListOnCountrySelection
    *  @param None
    */	 
	private void selectFirstSelectedCluster()
	{
            if(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equalsIgnoreCase(project.IPM_Project_Type__c) && IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)){
                List<IPM_Project_Rollout__c> lstRegionalRollout = new List<IPM_Project_Rollout__c>();
                lstRegionalRollout = [SELECT Id, MCO__c, Market_Cluster__c, IPM_Project__c 
                                                          FROM IPM_Project_Rollout__c 
                                                          WHERE Regional_Project__c=:project.Id  
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
        
	        if(noRolloutDisabledCountrycodeSet.Contains(countryWrapper.code))
	        {
	          countryWrapper.noRolloutDisabled = true;
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
            
            selectMCO(lstMCOWrappers);
            
            //COUNTRY SUB WRAPPERS
            
            for(GeographyWrapper countryWrapper : mapCountryWrappers.values())
            {
                
                if(countryWrapper.parentCode.equalsIgnoreCase(selectedMCO))
                {
                    if(setCountryCodesGlobal.contains(countryWrapper.code))
                    {
                        countryWrapper.selected = true;
                    }
          
                    if(noRolloutDisabledCountrycodeSet.Contains(countryWrapper.code))
                    {
                        countryWrapper.noRolloutDisabled = true;
                    }
                    
                    Map<String,String> rolloutStatusMap = new Map<String,String>();
                    
                    for(String selectedCountryCode : setCountryCodes)
                    {
                        rolloutStatusMap.put(selectedCountryCode,IPM_ConstantUtils.ROLLOUT_STATUS_SEPERATE);  
                    }
                    
                    for(String selectedCountryCode : setCountryCodesMCOs)
                    {
                        rolloutStatusMap.put(selectedCountryCode,IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO);
                    }
                    
                    for(String selectedCountryCode : setCountryNoRolls)
                    {
                        rolloutStatusMap.put(selectedCountryCode,IPM_ConstantUtils.NO_ROLLOUT);
                    }
                    
                    rolloutStatusMap.remove(null);
                    
                    
                    if(rolloutStatusMap.containsKey(countryWrapper.code))
                    {
                        countryWrapper.selected = true;
                        countryWrapper.rolloutStatus =  rolloutStatusMap.get(countryWrapper.code);
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
    *  @Description Method get selected and previously selected MCO
    *  @name selectedMCO
    *  @param lstMCOWrappers
    *  @return NONE
    */
    private void selectMCO(List<GeographyWrapper> lstMCOWrappers){
    	
    	if (!lstMCOWrappers.isEmpty() && (selectedMCO == NULL) || (IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(selectedMCO)))
        {
            selectedMCO = lstMCOWrappers[0].code;
            
            previouselectedMCO = lstMCOWrappers[0].code;
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
            
	    invokedFromRollouts = false;	            
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
	private void processCountryCodeListHelper()
	{
            //PROCESS GLOBAL - ADD the values to the existing list
            if(globalUnselectedCountries!=null && globalUnselectedCountries!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = globalUnselectedCountries.split(IPM_ConstantUtils.COMMA); 
                setCountryCodesGlobalUnselected.addAll(lstTemp);
            }
            if(globalCountries!=null && globalCountries!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
            {
                List<String> lstTemp = globalCountries.split(IPM_ConstantUtils.COMMA); 
                setCountryCodesGlobal.addAll(lstTemp);
                
                if(!lstTemp.isEmpty())
                {
                	setCountryCodesGlobal.addAll(lstTemp);
                	for(String countryCode : lstTemp)
                	{                	
                		if(setCountryCodesGlobalUnselected.contains(countryCode))
                		{
                			setCountryCodesGlobalUnselected.remove(countryCode);	
                		}	
                	}
                }
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
          // Call function which will process the rollout for country code 
		  processRolloutForCountryCode();
	}
	/**
    *  @Description Method to process various country codes selected as part of User operation.
         Process the rollout for country code.
         Eventually we will have the list which contains selections for MCO, Countries from User.
    *  @name processCountryCodeListsHelper
    *  @param NONE
    *  @return NONE
    */
	private void processRolloutForCountryCode()
	{
            
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
        mapUpsertRegionalRollouts = new Map<String, IPM_Project_Rollout__c>();
        mapUpsertRollouts = new Map<String, IPM_Project_Rollout__c>();
        mapUpsertKeyNKRollouts = new Map<String, IPM_Project_Rollout__c>();
        mapUpsertCountries = new Map<String,IPM_Country__c>();
        deleteRolloutsMap = new Map<String,IPM_Project_Rollout__c>();
        actualDeleteRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        checkRolloutsForProjects = new Set<Id>(); 
        deleteCountriesMap = new Map<String,IPM_Country__c>();
        localRolloutProjectIds = new Set<Id>();
        
        //Existing Rollouts
      String rolloutQuery = ' SELECT ';        
        for(String rolloutFieldAPIName  : rolloutFieldMap.keySet())
        {
            Schema.DescribeFieldResult fieldDescribe = rolloutFieldMap.get(rolloutFieldAPIName).getDescribe();
            if(fieldDescribe.isCustom()  && rolloutFieldAPIName != 'Id')
            {
                rolloutQuery += ' '+rolloutFieldAPIName+',';
            }
        }
        rolloutQuery += 'Id,Name,RecordTypeId,';
        rolloutQuery+= '(SELECT Id, Country_Code__c, Country_Name__c,AddedAtStage__c,IPM_CharterApproved__c,isActive__c,Project_Country__c, IPM_Rollout_Status__c, IPM_Regional_Project__c,Local_Rollout_Charter__c FROM IPM_Countries_Local__r) ';
        rolloutQuery+= 'FROM IPM_Project_Rollout__c ';
        rolloutQuery+= filterCondition(project.IPMProject_Span__c, STR_ROLLOUT);
        
        Set<String> regionalLocalRegional = new Set<String>();
        for(IPM_Project_Rollout__c ipmRollout : Database.query(rolloutQuery))
        {
        	
        	// To update the Key/Non-Key for all the local rollouts under MCO
        	if(isProjectGKM3 && ipmRollout.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE && project.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS){
        		Boolean KeyMCO = mapMCOWrappers.get(ipmRollout.MCO__c).key;
        		ipmRollout.KeyMCO__c = KeyMCO;
        		mapUpsertKeyNKRollouts.put(ipmRollout.IPM_Rollout_Project__c,ipmRollout);
        		
        	}
            mapExistingRollouts.put(ipmRollout.IPM_Rollout_Project__c, ipmRollout);
            regionalLocalRegional.add(ipmRollout.name);
            existingPrjList.add(ipmRollout.Local_Project__c);
        }
        
        //Countries
        String queryString = 'SELECT Id, IPM_Local_Project__c, Country_Code__c, Country_Name__c,AddedAtStage__c,IPM_CharterApproved__c,isActive__c,Project_Country__c, IPM_Rollout_Status__c, IPM_Regional_Project__c,Local_Rollout_Charter__c FROM IPM_Country__c ';
        queryString+= filterCondition(project.IPMProject_Span__c, STR_COUNTRY);
          
        for (IPM_Country__c country : Database.query(queryString))
        {
            if(IPM_ConstantUtils.EMPTY_STRING_INITIAL.equalsIgnoreCase(searchCountry))
            {
                mapExistingCountries.put(country.Project_Country__c, country);
            }
        }
       
        if(project.IPM_ProjectGKM__c != IPM_ConstantUtils.GKM_3)
        {
        	if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c) || 
        		( ( IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c ) ) && ( IPM_ConstantUtils.PHASE_IDEAS.equalsIgnoreCase(project.IPM_phase__c) ) ) )
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
        }
        else
        {
            if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c) && IPM_ConstantUtils.PHASE_IDEAS.equalsIgnoreCase(project.IPM_phase__c)) 
            {
            	processUnSelectedCountries(setCountryCodesGlobalUnselected,IPM_ConstantUtils.ROLLOUT_TYPE_MCO);
	            processGlobalMCORollouts();
            }
            else
            {
	            processUnSelectedCountries(setCountryCodesMCOsUnselected,IPM_ConstantUtils.ROLLOUT_TYPE_MCO);
	            processUnSelectedCountries(setCountryCodesUnselected,IPM_ConstantUtils.ROLLOUT_TYPE_COUNTRY);
	            processUnSelectedCountries(setCountryNoRolls,IPM_ConstantUtils.ROLLOUT_TYPE_COUNTRY);
	  			
	        	processGlobalMCORollouts();
	            processRegionalMCORollouts();
	            processRegionalCountryRollouts(); 
            }
        }
       
        filterRollouts();
        //Call Your method to check if there are projects available which are already stopped.
        processPurgeFunctionality();
        processRegionalRollouts();
        archiveProjects();
        processLocalRollouts();
        processCountry();
        deleteRollout();
    }
    
    /**
    *  @Description This helper method provides filter condition for Global or Regional projects
    *  @name filterCondition
    *  @param NONE
    *  @return NONE
    **/
    private string filterCondition(string span, string strObj){
        string addCondition = IPM_ConstantUtils.BLANK;
        if (IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(span))
        {
            addCondition = 'WHERE IPM_Project__c =: projectId AND isActive__c = true LIMIT 10000'; 
        }
        else if (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(span))
        {
        	if(strObj == STR_ROLLOUT)
        	{
            addCondition = 'WHERE Regional_Project__c =: projectId AND isActive__c = true LIMIT 10000';  
        	}else if(strObj == STR_COUNTRY){
            addCondition = 'WHERE IPM_Regional_Project__c =: projectId AND isActive__c = true LIMIT 10000';
        	}
                    
        }
        return addCondition;        
    }
    
    /**
    *  @Description This is a helper method which filters Rollouts depends on whether it has been attached in Charter document(Ideas) phase or not
    *  @name filterRollouts
    *  @param NONE
    *  @return NONE
    */ 
    @TestVisible private void filterRollouts()
    {
        // Rollouts that might have deleted as part of Trigger Logic of updating Key Rollouts To Non Keys.
        
        Set<String> deleteRolloutSet = deleteRolloutsMap.KeySet();
        String rolloutQuery = ' SELECT ';        
        for(String rolloutFieldAPIName  : rolloutFieldMap.keySet())
        {
            Schema.DescribeFieldResult fieldDescribe = rolloutFieldMap.get(rolloutFieldAPIName).getDescribe();
            
            if(fieldDescribe.isCustom()  && rolloutFieldAPIName != 'Id')
            {
                rolloutQuery += ' '+rolloutFieldAPIName+',';
            }
        }
        rolloutQuery += 'Id,Name,RecordTypeId from IPM_Project_Rollout__c where IPM_Rollout_Project__c  in :deleteRolloutSet AND isActive__c = true';
        for(IPM_Project_Rollout__c rollout : database.query(rolloutQuery))
        {
            if(rollout.IPM_CharterApproved__c || rollout.Local_Project__c!=null)
             {
                checkRolloutsForProjects.add( rollout.Local_Project__c);
                rollout.isActive__c = false;
                localRolloutProjectIds.add( rollout.Local_Project__c);
                if(rollout.IPM_Rollout_Project__c != null )
                {
                  mapUpsertRollouts.put(rollout.IPM_Rollout_Project__c,rollout);
                }
             }
             else
             {
                actualDeleteRolloutMap.put(rollout.Id,rollout);
             }
        }
    }
    
    /**
    *  @Description This is a helper method which does actual purging of the Regional or Local Project if Stpped Rollout is selected in Rollout Plans
    *  @name processPurgeFunctionality
    *  @param NONE
    *  @return NONE
    */     
    @TestVisible private void processPurgeFunctionality()
    {
    	List<IPM_Project__c>  purgeProjList = new List<IPM_Project__c>();
    	Map<String,IPM_Project__c> purgeProjMap = new Map<String,IPM_Project__c>();
    	Set<String> purgeProjNameSet = new Set<String>();
    	for(IPM_Project_Rollout__c rolloutProj : mapUpsertRollouts.values())
    	{
    		if(rolloutProj.Regional_Project__c != null && project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
    		{
    			projPurgeIdSet.add(rolloutProj.Regional_Project__c);
    		}
    		if(rolloutProj.Local_Project__c != null && ( project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL || isProjectGKM3 ))
    		{
    			projPurgeIdSet.add(rolloutProj.Local_Project__c);
    		}		
    	}	

    	for(IPM_Project__c purgeProj : [Select id,IPM_Project_Name__c From IPM_Project__c Where id =:projPurgeIdSet AND Is_Archieved__c = true])
    	{
    		purgeProjMap.put(purgeProj.id,purgeProj);	
    		purgeProjList.add(purgeProj);
    		purgeProjNameSet.add(purgeProj.IPM_Project_Name__c);	
    	}
    	for(IPM_Project_Rollout__c rollout :  mapUpsertRollouts.values())
    	{
			if(purgeProjMap.containsKey(rollout.Regional_Project__c))
    		{
    			rollout.put('Regional_Project__c',null);
    		}
    		else if(purgeProjMap.containsKey(rollout.Local_Project__c))
    		{
    			rollout.put('Local_Project__c',null);
    			//rollout.put('Target_Launch_Date__c',null);
    			rollout.put('IPM_Regional_PL__c',null);
    			rollout.put('IPM_Regional_PL_Text__c',null);
	    		rollout.put('IPM_StoppedByProject__c',null);
	    		rollout.put('Added_At_Stage__c',null);	
    		}   		
    	}
		  processPurgeFunctionalityHelper(purgeProjNameSet,purgeProjMap,purgeProjList);

   }  
         /**
    *  @Description This is a helper method which does actual purging of the Regional or Local Project if Stpped Rollout is selected in Rollout Plans
    *  @name processPurgeFunctionalityHelper
    *  @param purgeProjNameSet,purgeProjMap,purgeProjList
    *  @return NONE
    */ 
    private void processPurgeFunctionalityHelper(Set<String> purgeProjNameSet,Map<String,IPM_Project__c> purgeProjMap,List<IPM_Project__c>  purgeProjList)
    {
        List<IPM_Financial__c> finList = new List<IPM_Financial__c>();
        Set<Id> finIdSet = new Set<Id>();
        Map<String, Schema.SobjectField> finFldMap = Schema.SObjectType.IPM_Financial__c.fields.getMap();
        Map<String, Schema.SobjectField> finYearFldMap = Schema.SObjectType.IPM_Financial_Year__c.fields.getMap();
        List<IPM_Financial_Year__c> finYearList = new List<IPM_Financial_Year__c>();
        
    	for(IPM_Project_Rollout__c rolloutReg :  mapUpsertRegionalRollouts.values())
    	{
			if(purgeProjNameSet.contains(rolloutReg.IPM_Rollout_Project__c))
    		{
	    		rolloutReg.put('IPM_Regional_PL_Text__c',null);
	    		rolloutReg.put('IPM_Regional_PL__c',null);
	    		rolloutReg.put('Previous_Target_Launch_Date__c',null);
	    		rolloutReg.put('Target_Launch_Date__c',null);
	    		rolloutReg.put('IPM_StoppedByProject__c',null);
	    		rolloutReg.put('Added_At_Stage__c',null);	
    		}
    	}

    	for(IPM_Financial__c fin : [Select id,IRR_Global__c From IPM_Financial__c Where Regional_Project__c =:purgeProjMap.keySet() OR 	Local_Project__c =:purgeProjMap.keySet()])
    	{
			for( String finFld : finFldMap.keySet())
			{
			    if(finFldMap.get(finFld).getDescribe().isUpdateable() && (finFldMap.get(finFld).getDescribe().getType() == Schema.DisplayType.Currency || finFldMap.get(finFld).getDescribe().getType() == Schema.DisplayType.Percent 
			    	|| finFldMap.get(finFld).getDescribe().getType() == Schema.DisplayType.Double || finFldMap.get(finFld).getDescribe().getType() == Schema.DisplayType.Integer) && (finFld.ContainsIgnoreCase('global') || finFld.ContainsIgnoreCase('regional') || finFld.ContainsIgnoreCase('local')))
			    {
			         fin.put(finFld,0);     
			         fin.Regional_Project__c = null; 
			    }
			}
			finIdSet.add(fin.id);
			finList.add(fin);	
    	}

    	for(IPM_Financial_Year__c finYear : [Select id From IPM_Financial_Year__c Where IPM_Financial__c IN: finIdSet])
    	{
			for( String finYrFld : finYearFldMap.keySet())
			{
			    if(finYearFldMap.get(finYrFld).getDescribe().isUpdateable() && (finYearFldMap.get(finYrFld).getDescribe().getType() == Schema.DisplayType.Currency || finYearFldMap.get(finYrFld).getDescribe().getType() == Schema.DisplayType.Percent 
			    	|| finYearFldMap.get(finYrFld).getDescribe().getType() == Schema.DisplayType.Double || finYearFldMap.get(finYrFld).getDescribe().getType() == Schema.DisplayType.Integer) && (finYrFld.ContainsIgnoreCase('global') || finYrFld.ContainsIgnoreCase('regional') || finYrFld.ContainsIgnoreCase('local')))
			    {
			         finYear.put(finYrFld,0);     
			    }
			}
			finYearList.add(finYear);	
    	}
        updateFinYearFinListPurgeProjList(finYearList,finList,purgeProjList);
        
    }
	         /**
    *  @Description UPdate the financial year list for purge functionality 
    *  @name updateFinYearFinListPurgeProjList
    *  @param finYearList,finList,purgeProjList
    *  @return NONE
    */
	private void updateFinYearFinListPurgeProjList(List<IPM_Financial_Year__c> finYearList,List<IPM_Financial__c> finList,List<IPM_Project__c> purgeProjList)
	{
    	if(!finYearList.isEmpty())
    	{
    		update finYearList;
    	}
    	
    	if(!finList.isEmpty())
    	{
    		update finList;
    	}
    	
    	if(!purgeProjList.isEmpty())
    	{
    		IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
    		delete purgeProjList;
    		IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
    	}
    }
	
	/**
    *  @Description This is a helper method which deletes the non selected Rollouts
    *  @name deleteRollout
    *  @param NONE
    *  @return NONE
    */
    @TestVisible private void deleteRollout()
    {
        if(!actualDeleteRolloutMap.isEmpty())
        {
            List<IPM_Project_Rollout__c> deleteRolloutList = [SELECT ID FROM IPM_Project_Rollout__c where Id in :actualDeleteRolloutMap.values()]; 
            delete deleteRolloutList;
        }
    }
    
    /**
    *  @Description This is a helper method which processes Regional Rollout and upserts with external id IPM_Rollout_Project__c
    *  @name processRegionalRollouts
    *  @param NONE
    *  @return NONE
    */
    @TestVisible private void processRegionalRollouts()
    {
    	if(!mapUpsertRegionalRollouts.isEmpty())
        {
            // Remove Id from Upsert call in case it is an insert that might happen for record which got deleted as part of above operation
            for(IPM_Project_Rollout__c regionalRollout : mapUpsertRegionalRollouts.values())
            {
                regionalRollout.Id = null;
            }
            try
            {
              checkForRolloutChanges(mapUpsertRegionalRollouts);
            	upsert mapUpsertRegionalRollouts.values() IPM_Rollout_Project__c;	
            }
            catch (Exception ex) 
	        {
	            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,GET_KEY_MCO_ROLLOUT_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
	            isError = TRUE;
	            errorMessage = Label.IPM_Generic_ErrorMessage;
	        }
        }
    }
  
  /**
    *  @Description This is a helper method which processes Local Rollout and upserts with external id IPM_Rollout_Project__c
    *  @name processLocalRollouts
    *  @param NONE
    *  @return NONE
    */
    @TestVisible private void processLocalRollouts()
    { 
	 	if(!mapUpsertRollouts.isEmpty())
        {
            
            if(isProjectGKM3 && !mapUpsertKeyNKRollouts.isEmpty()){
              for(IPM_Project_Rollout__c localRollout : mapUpsertKeyNKRollouts.values())
              {
	                if(!mapUpsertRollouts.containsKey(localRollout.IPM_Rollout_Project__c))
	                {
            			mapUpsertRollouts.put(localRollout.IPM_Rollout_Project__c, localRollout);
            		}
            	}
            }
             
            // Remove Id from Upsert call in case it is an insert that might happen for record which got deleted as part of above operation
            for(IPM_Project_Rollout__c localRollout : mapUpsertRollouts.values())
            {
                localRollout.Id = null;
                if(localRollout.Regional_Rollout__c != null){
                  localRollout.Regional_Rollout__r = null;
                }
            }
            try
		{
		      checkForRolloutChanges(mapUpsertRollouts);
			upsert mapUpsertRollouts.values() IPM_Rollout_Project__c;
		}
		catch (Exception ex) 
		{
			ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,GET_REGIONAL_ROLLOUT_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
			isError = TRUE;
			errorMessage = Label.IPM_Generic_ErrorMessage; 
		} 
        } 
    }
    @TestVisible private void  checkForRolloutChanges(Map<String, IPM_Project_Rollout__c> mapUpsertRollouts)
    {
      Set<String> customRolloutFieldSet = new Set<String>();  
      Map<String,IPM_Project_Rollout__c> DBRolloutMap = new Map<String,IPM_Project_Rollout__c>();
      List<String> rolloutUniqueKey = new List<String>(mapUpsertRollouts.keySet());
      String rolloutQuery = ' SELECT ';        
        for(String rolloutFieldAPIName  : rolloutFieldMap.keySet())
        {
            Schema.DescribeFieldResult fieldDescribe = rolloutFieldMap.get(rolloutFieldAPIName).getDescribe();
            if(fieldDescribe.isCustom()  && rolloutFieldAPIName != 'Id')
            {
              customRolloutFieldSet.add(rolloutFieldAPIName);
                rolloutQuery += ' '+rolloutFieldAPIName+',';
            }
        }
        rolloutQuery += 'Id,Name FROM IPM_Project_Rollout__c where IPM_Rollout_Project__c in :rolloutUniqueKey LIMIT 50000';
      for(IPM_Project_Rollout__c  DBprojectRollout : database.query(rolloutQuery))
      {
        DBRolloutMap.put(DBprojectRollout.IPM_Rollout_Project__c,DBprojectRollout);
      }  
      for(IPM_Project_Rollout__c incomingRollout : mapUpsertRollouts.values())
      {
        if(DBRolloutMap.containsKey(incomingRollout.IPM_Rollout_Project__c))
        {
          IPM_Project_Rollout__c DBrollout = DBRolloutMap.get(incomingRollout.IPM_Rollout_Project__c);
          Boolean isChanged = false;
          for (String fieldAPIName : customRolloutFieldSet)
          {
            if(DBrollout.get(fieldAPIName) != incomingRollout.get(fieldAPIName))
            {
              isChanged = true;
              break;
            }
          }
          if(!isChanged)
          {
            mapUpsertRollouts.remove(incomingRollout.IPM_Rollout_Project__c);
          }
        }
      }
    }
    
    /**
    *  @Description This is a helper method which unlinks the Countries processed in the Purge Operation 
    *  @name processCountry
    *  @param NONE
    *  @return NONE
    */
    @TestVisible private void processCountry()
    {
	    if(!deleteCountriesMap.isEmpty())
	    {   
	        Map<Id,IPM_Country__c> filteredDeleteCountryMap = new Map<Id,IPM_Country__c>();
	        // Before deleting Query the Countries again to validate whether certain countries got deleted as part of Rollout Deletion.
	        List<IPM_Country__c> countryListToDelete = [Select Id,Project_Country__c,IPM_Local_Project__c,IPM_Local_Project__r.IPM_PrepareForArchival__c,IPM_CharterApproved__c,isActive__c from IPM_Country__c where Project_Country__c in :deleteCountriesMap.KeySet() AND isActive__c = true ];
	        for(IPM_Country__c country : countryListToDelete)
	        {
                if(country.IPM_Local_Project__c !=null && country.IPM_Local_Project__r.IPM_PrepareForArchival__c)
                {
                	country.isActive__c = true;
                	mapUpsertCountries.put(country.Project_Country__c,country);
                }
                else if(country.IPM_CharterApproved__c)
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
        if(!mapUpsertCountries.isEmpty())
        { 
            // Remove Id from Upsert call in case it is an insert that might happen for record which got deleted as part of above operation
            for(IPM_Country__c country : mapUpsertCountries.values())
            {
                country.Id = null;
                if(projPurgeIdSet.contains(country.IPM_Regional_Project__c))
                {
                	country.IPM_Regional_Project__c = null;	
                }
                if(projPurgeIdSet.contains(country.IPM_Local_Project__c))
                {
                	country.IPM_Local_Project__c = null;	
                }
            }
            upsert mapUpsertCountries.values() Project_Country__c;
        }
    }
    
    /**
    *  @Description This is a helper method which processes Local Rollout and upserts with external id IPM_Rollout_Project__c
    *  @name archiveProjects
    *  @param NONE
    *  @return NONE
    */
    @TestVisible private void archiveProjects()
    {
	 	String childProjectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null,true);
      	String childProjectWhereClause = ' WHERE Id in :localRolloutProjectIds LIMIT 5000';
      	childProjectQuery = childProjectQuery + childProjectWhereClause; 
          	
    	List<IPM_Project__c> toBeArchievedRolloutProjects =  database.query(childProjectQuery);

	// checking if the stopped/achieved has an associated gate doc, if it is make rollout active
        if(toBeArchievedRolloutProjects!=null && !toBeArchievedRolloutProjects.isEmpty())
        {
       		for(IPM_Project__c rollOutProj : toBeArchievedRolloutProjects) 
            {  
              	IPM_Project_Type__c currentProjecttype = IPM_Utils.retrieveProjectType(rollOutProj);
              
              	if(currentProjecttype != null && String.isNotBlank(currentProjecttype.IPM_Gate_Document__c) )
              	{
                	rollOutProj.IPM_Is_Invoked_From_Rollout__c =true; 
                	rollOutProj.Is_Archieved__c = false;
               	 	rollOutProj.IPM_PrepareForArchival__c = true;
                    // checking if the corresponding rollout for this project is inactive, if it is make it active to give a window of 72 hours for stopping project.
                    if(mapUpsertRollouts.containsKey(rollOutProj.IPM_Project_Name__c))
                    {                   	
                	 	mapUpsertRollouts.get(rollOutProj.IPM_Project_Name__c).isActive__c = true;
                    } 
              	}
              	else
              	{
                	rollOutProj.IPM_Is_Invoked_From_Rollout__c =true; 
                	rollOutProj.Is_Archieved__c=true;
              	}
			}
          	update   toBeArchievedRolloutProjects ;
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
    	Set<String> allSelectionExceptNoRollout = new Set<String>();
    	
    	if(isProjectGKM3 && project.IPM_phase__c != IPM_ConstantUtils.PHASE_IDEAS)
    	{
	    	allSelectionExceptNoRollout.addAll(setCountryCodesMCOs);
	    	allSelectionExceptNoRollout.addAll(setCountryCodes);	
    	}
    	else
    	{
    		allSelectionExceptNoRollout.addAll(setCountryCodesGlobal);
    	}
    	for (String countryCodeGlobal : allSelectionExceptNoRollout)
        {
            MDO_Geography__c geography = mapUnileverCountries.get(countryCodeGlobal);
            
            // Get Local Rollout Name.
            String mcoExternalId = getKeyMCORolloutName(countryCodeGlobal);
            String mcoRolloutName = mcoExternalId;
            if(isProjectGKM3)
            {
            	mcoRolloutName = getGKM3KeyMCOName(countryCodeGlobal);
            }
            Boolean KeyMCO = mapMCOWrappers.get(geography.parent_L2__r.mdm_id__c).key;
            
            // Get Regional Rollout Name.
            String regionalRolloutName = getRegionalRolloutName(countryCodeGlobal); 
            
            String countryExternalId = getCountryExternalId(countryCodeGlobal);
           
            IPM_Project_Rollout__c regionalRollout = null;

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
            processGlobalMCORolloutsHelper(mcoExternalId,countryCodeGlobal,countryExternalId,mcoRolloutName,geography,regionalRolloutName,keyMCO);

         }
    }
	 /**
    *  @Description Method to process Global MCO Rollouts. This specifies the Top Level Project MCO Selection where we process selected and unselected MCO List.
        Creates regional Rollouts based on User Selected MCO's. Also local Rollouts are created based on User Selection. 
        Neccessary data and relationships between rollout,country and Projects are created here.
        Deletion of Unselected MCO and countries are performed as well.
    *  @name processGlobalMCORolloutsHelper
    *  @param mcoExternalId,mcoRolloutName,geography,regionalRolloutName
    *  @return NONE
    */
  private void processGlobalMCORolloutsHelper(String mcoExternalId,String countryCodeGlobal,String countryExternalId,String mcoRolloutName,MDO_Geography__c geography,String regionalRolloutName, Boolean keyMCO)
    {
	    IPM_Project_Rollout__c mcoRollout = null;
            // Check if there is an existing Local Rollout.
      	if(!setCountryCodes.contains(countryCodeGlobal))
      	{	
            if (mapExistingRollouts.containsKey(mcoExternalId) ) 
            {
                mcoRollout = mapExistingRollouts.get(mcoExternalId);
            }
            else
            {
                if(mapUpsertRollouts.containsKey(mcoExternalId))
                {
                    mcoRollout = mapUpsertRollouts.get(mcoExternalId);
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
                        IPM_Rollout_Project__c = mcoExternalId,
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
                    mapUpsertRollouts.put(mcoExternalId, mcoRollout); 
                }
                
                if(mcoRollout.KeyMCO__c != KeyMCO)
                {
                    mcoRollout.KeyMCO__c = KeyMCO;
                    mapUpsertRollouts.put(mcoExternalId, mcoRollout);  
                }
                
            }
            associateCountryAndRolloutInGlobalMCORollouts(countryExternalId,mcoExternalId,geography);
      		}
        }
    	 /**
    *  @Description Neccessary data and relationships between rollout,country and Projects are created here.
        Deletion of Unselected MCO and countries are performed as well.
    *  @name associateCountryAndRolloutInGlobalMCORollouts
    *  @param countryExternalId, mcoExternalId,geography
    *  @return NONE
    */
    private void associateCountryAndRolloutInGlobalMCORollouts(String countryExternalId,String mcoExternalId,MDO_Geography__c geography)
	{
		IPM_Country__c ipmCountry = null;
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
                        Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoExternalId)
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
            
            String regionalRolloutName = getRegionalRolloutName(countryCodeMCO); 
            String mcoExternalId = getKeyMCORolloutName(countryCodeMCO);
            String mcoRolloutName = mcoExternalId;
            
            if(isProjectGKM3)
            {
            	mcoRolloutName = getGKM3KeyMCOName(countryCodeMCO);
            }
            String countryExternalId = getCountryExternalId(countryCodeMCO);
            
            Boolean KeyMCO = mapMCOWrappers.get(geography.parent_L2__r.mdm_id__c).key;
            
            IPM_Project_Rollout__c newMCORollout = null; 

            // Check if rollout Already Exists. If yes check whether it is active or not.
            if(!mapExistingRollouts.isEmpty() && mapExistingRollouts.containsKey(mcoExternalId))
            {
                newMCORollout = mapExistingRollouts.get(mcoExternalId);
            }
            else 
            {
                if(!mapUpsertRollouts.isEmpty() && mapUpsertRollouts.containsKey(mcoExternalId))
                {
                    newMCORollout = mapUpsertRollouts.get(mcoExternalId);
                }
                else
                {
                    newMCORollout = new IPM_Project_Rollout__c
                    (
                        RecordTypeId = LOCAL_ROLLOUT_RECORDTYPE,
                        Name = mcoRolloutName,
                        IPM_Rollout_Project__c = mcoExternalId,
                        Added_At_Stage__c = project.IPM_Phase__c,
                        Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c
                    );
                    
                    newMCORollout.KeyMCO__c = KeyMCO;
                    if(project.IPM_phase__c != IPM_ConstantUtils.PHASE_IDEAS && !isProjectGKM3)
                    {
                        newMCORollout.KeyMCO__c = true; 
                    }
                }
            }
			processRegionalMCORolloutsHelper(newMCORollout,mcoExternalId,countryExternalId,geography,regionalRolloutName,newMCORollout.KeyMCO__c);

           }
    }
	 /**
    *  @Description Helper method for processregionalRollouts method.
     	Used for creating MCO rollouts at regional Level based on user selected and unselected MCO List.
        Creates local Rollouts based on User Selected MCO's. Checks if there was a switch made between 'Country specific', 'No Rollout' to 'Part of MCO Rollout' 
        Neccessary data and relationships between rollout,country and Projects are created here.
    *  @name processRegionalMCORolloutsHelper
    *  @param newMCORollout,mcoExternalId,countryExternalId,geography,regionalRolloutName,keyMCO
    *  @return NONE
    */
	private void processRegionalMCORolloutsHelper(IPM_Project_Rollout__c newMCORollout,String mcoExternalId, String countryExternalId,MDO_Geography__c geography,String regionalRolloutName,Boolean KeyMCO)
	{
	    IPM_Country__c ipmCountry = null;
	    if(newMCORollout!=null)
            {
                newMCORollout.IPM_Rollout_Span__c = IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL;
                newMCORollout.Type__c = IPM_ConstantUtils.ROLLOUT_TYPE_MCO;
                newMCORollout.MCO__c = geography.parent_L2__r.mdm_id__c;
                newMCORollout.MCO_Name__c = geography.parent_L2__r.name;
                newMCORollout.Market_Cluster__c = geography.parent_L2__r.parent_L2__r.mdm_id__c;
                newMCORollout.Market_Cluster_Name__c = geography.parent_L2__r.parent_L2__r.name;
              	if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
                {
                	newMCORollout.Regional_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = regionalRolloutName);
                }
                
                newMCORollout.KeyMCO__c = KeyMCO;	
                
                
                if(!isProjectGKM3)
                {
                	newMCORollout.Regional_Project__c = project.Id;
                }
                else{
                	newMCORollout.IPM_Project__c = project.Id;
                }
                
                if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT && !isProjectGKM3)
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
                    
                    mapUpsertRollouts.put(mcoExternalId, newMCORollout);
                }
                mapUpsertRollouts.put(mcoExternalId, newMCORollout);
            }
             // call function to Associate the country with rollout
			 associateCountryWithRollout(mcoExternalId,countryExternalId,geography);

	}
		 /**
    *  @Description Helper method for processregionalRollouts method.
     	Checks if there was a switch made between 'Country specific', 'No Rollout' to 'Part of MCO Rollout' 
        Neccessary data and relationships between rollout,country and Projects are created here.
        Deletion of Unselected MCO and countries are performed as well.
    *  @name associateCountryWithRollout
    *  @param mcoExternalId,countryExternalId,geography
    *  @return NONE
    */
    private void associateCountryWithRollout(String mcoExternalId, String countryExternalId,MDO_Geography__c geography)
    {
        IPM_Country__c ipmCountry = null;
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
                if(!isProjectGKM3){
                	ipmCountry.IPM_Regional_Project__c = project.Id;
                }else{
                	ipmCountry.IPM_Project__c = project.Id;
                }
                
                ipmCountry.Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoExternalId);
                if(!isProjectGKM3){
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
            String countryExternalId = getCountryExternalId(countryCode);            
            String countryRolloutName  = countryExternalId;
            if(isProjectGKM3)
            {
            	countryRolloutName = project.IPM_Project_Name__c + IPM_ConstantUtils.UNDERSCORE + countryCode;
            }
            
            String regionalRolloutName = getRegionalRolloutName(countryCode);  
            Boolean KeyMCO = mapMCOWrappers.get(geography.parent_L2__r.mdm_id__c).key;
            
            IPM_Project_Rollout__c newCountryRollout = null;
            
            // Check if Country Rollout exists for this Country. If yes update it else insert it.
            if(mapExistingRollouts.containsKey(countryExternalId))
            {
                newCountryRollout = mapExistingRollouts.get(countryExternalId);
            } 
            else
            {
                if(mapUpsertRollouts.containsKey(countryExternalId))
                {
                    newCountryRollout = mapUpsertRollouts.get(countryExternalId);
                }
                else
                {
                   newCountryRollout = new IPM_Project_Rollout__c
                   (
                        RecordTypeId=LOCAL_ROLLOUT_RECORDTYPE,
                        Name = countryRolloutName,
                        IPM_Rollout_Project__c = countryExternalId,
                        Added_At_Stage__c = project.IPM_Phase__c,
                        Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c
                    );
                    
                    if(project.IPM_phase__c != IPM_ConstantUtils.PHASE_IDEAS && !isProjectGKM3)
                    {
                        newCountryRollout.KeyMCO__c = true; 
                    } 
                }
            }
             processRegionalCountryRolloutsHelper(newCountryRollout,countryExternalId,regionalRolloutName,geography,KeyMCO);
       }   
     }
    /**
    *  @Description Helper method for processRegionalCountryRollouts method.It is creating the country rollout and deleting
    *               the country rollout.
    *  @name processRegionalCountryRolloutsHelper
    *  @param newCountryRollout,countryExternalId,regionalRolloutName,geography,KeyMCO
    *  @return Regional Rollout Name
    */
	 private void processRegionalCountryRolloutsHelper(IPM_Project_Rollout__c newCountryRollout,String countryExternalId,String regionalRolloutName,MDO_Geography__c geography,Boolean KeyMCO)
	 {
            if(newCountryRollout!=null)
            {

                newCountryRollout.IPM_Rollout_Span__c = IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL;
                newCountryRollout.Type__c = IPM_ConstantUtils.ROLLOUT_TYPE_COUNTRY;
                newCountryRollout.MCO__c = geography.parent_L2__r.mdm_id__c;
                newCountryRollout.MCO_Name__c = geography.parent_L2__r.name;
                newCountryRollout.Market_Cluster__c = geography.parent_L2__r.parent_L2__r.mdm_id__c;
                newCountryRollout.Market_Cluster_Name__c = geography.parent_L2__r.parent_L2__r.name;
                if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
                {
                	newCountryRollout.Regional_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = regionalRolloutName);
                }
                
                if(!isProjectGKM3){
                	newCountryRollout.Regional_Project__c = project.Id;	
                }else{
                	newCountryRollout.IPM_Project__c = project.Id;
                }
                
                newCountryRollout.KeyMCO__c = KeyMCO;
                
                if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT && !isProjectGKM3) 
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
                
                    
                    mapUpsertRollouts.put(countryExternalId, newCountryRollout);
                }
                
            }
		  mapRegionalCountryRolloutsWithCountry(countryExternalId,geography);
		  	
	}
	 /**
    *  @Description Method to map the rollout with country, and assign the values from rollout into the country.
    *  @name mapRegionalCountryRolloutsWithCountry
    *  @param countryExternalId,geography
    *  @return Regional Rollout Name
    */
	private void mapRegionalCountryRolloutsWithCountry(String countryExternalId,MDO_Geography__c geography)
    {

		IPM_Country__c ipmCountry = null;
            //Check if Country exists. If it already exists update Status and reference of Local Rollout as separate Country Rollout.
            if(mapExistingCountries.containsKey(countryExternalId))
            {
                ipmCountry = mapExistingCountries.get(countryExternalId);
            }
            else 
            {
               if(mapUpsertCountries.containsKey(countryExternalId))
               {
                  ipmCountry =  mapUpsertCountries.get(countryExternalId);
               } 
               else
               { 
                    ipmCountry = new IPM_Country__c
                    (
                        Project_Country__c = countryExternalId,
                        AddedAtStage__c = project.IPM_Phase__c
                    );
               }
            }
            
           if(ipmCountry !=null)
           {
                ipmCountry.isActive__c = true;
                ipmCountry.MDO_Geography__c = geography.Id;
                if(!isProjectGKM3){
                	ipmCountry.IPM_Regional_Project__c = project.Id;
                }else{
                	ipmCountry.IPM_Project__c = project.Id;
                }
                ipmCountry.Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = countryExternalId);
                ipmCountry.IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_SEPERATE;
                ipmCountry.IPM_Local_Project__c=null;//added to cover the source data for DEF3821
                
                if(project.IPM_Project_Type__c != IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && !isProjectGKM3) 
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
            
            String rolloutName = '';
            
            
            rolloutName = getRegionalRolloutName(countryCode); 
            
            
            return rolloutName + IPM_ConstantUtils.UNDERSCORE + shortName;
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
    *  @Description Method to get key MCO Rollout Name
    *  @name getKeyMCORolloutName
    *  @param countryCode    Country code for which the key MCO rollout name needs o be generated
    *  @return key MCO Rollout Name
    */
    @TestVisible private String getGKM3KeyMCOName(String countryCode)
    { 
        try
        {
            MDO_Geography__c geography = mapUnileverCountries.get(countryCode);
            String shortName = IPM_MCO_Short_Names__c.getValues(geography.parent_L2__r.mdm_id__c).Short_Name__c;
            return project.IPM_Project_Name__c + IPM_ConstantUtils.UNDERSCORE + shortName;
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
        String externalId = '';
            externalId = getRegionalRolloutName(countryCode) + IPM_ConstantUtils.UNDERSCORE + countryCode; 
        return externalId;   
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

            if(IPM_ConstantUtils.ROLLOUT_TYPE_MCO.equalsIgnoreCase(rolloutType))
            {
                removeReferences(mcoRollNameToCountryCodeMap,ipmRollout);
            }
            else if(IPM_ConstantUtils.ROLLOUT_TYPE_COUNTRY.equalsIgnoreCase(rolloutType))
            {
                removeReferences(countryRollNameToCountryCodeMap,ipmRollout);
            } 
        }     
    }
    
    /**
    *  @Description This is a helper method which checks whether the local Project is associated to the Local Rollout or not
    *  @name checkLocalProjectAssociatedOrNot
    *  @param NONE
    *  @return rolloutType - Indicates what type of rollouts need to be checked for deletion.
    */
    public void checkLocalProjectAssociatedOrNot()
    { //mapExistingCountries
      localProjCnt = 0;
      String queryString = null;
      removeCountryFeasiCap = false;
      removeCountryOtherFeasiCap = false;
      countryRelatedProj = false;
      invokedFromRollouts = true;
      allRolloutFromSameMCO = false ;
      existingRelatedCountriesMap = new Map<String,IPM_Country__c>();
      relatedMCOAndCountry = new Map<String,Set<String>>();
      List<String> regionalNoRollList = new List<String>();
        queryString = 'SELECT Id, IPM_Local_Project__c, Country_Code__c,Local_Rollout__c, Country_Name__c,AddedAtStage__c,IPM_CharterApproved__c,isActive__c,Project_Country__c, IPM_Rollout_Status__c, IPM_Regional_Project__c,Local_Rollout_Charter__c FROM IPM_Country__c ';
        if (IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            queryString+= 'WHERE IPM_Project__c =: projectId LIMIT 10000';
        }
        else if (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            queryString+= 'WHERE IPM_Regional_Project__c =: projectId LIMIT 10000';        
        }
		//Getting the Countries related to the existing Project or not
        getRelatedCountries(queryString);
		
        if(regionalNoRoll!=null && regionalNoRoll!=IPM_ConstantUtils.EMPTY_STRING_INITIAL)
        {
			regionalNoRollList = regionalNoRoll.split(IPM_ConstantUtils.COMMA); 
        }
		
		//Checking the Associated Projects or not
		checkRelatedLocalProjectOrNot(regionalNoRollList);
		
        for(String relMCO : relatedMCOAndCountry.keySet())
        {
          if(relatedMCOAndCountry.get(relMCO).size() == 0)
          { 
            allRolloutFromSameMCO = true;      
          } 
        }
        if(project.IPMProject_Span__c == IPM_Utils.Regional && (project.IPM_Phase__c == IPM_Utils.Feasibility || project.IPM_Phase__c == IPM_Utils.Capability))
        {
              removeCountryFeasiCap = true;
        }
        else
        {
           removeCountryOtherFeasiCap = true;
        }
    }
	
	/**
    *  @Description This is a helper method which checks the selected No Rollout related to Local Projects or not 
    *  @name getRelatedCountries
    *  @param queryStringCountries :  List of all selected countries
    *  @return NONE
    */
	public void getRelatedCountries(String queryStringCountries)
	{
		for (IPM_Country__c country : Database.query(queryStringCountries))
        {
            if(country.Local_Rollout__c != null)
            {
                existingRelatedCountriesMap.put(country.Project_Country__c, country);
                if(relatedMCOAndCountry.containsKey(country.Local_Rollout__c)){
                  relatedMCOAndCountry.get(country.Local_Rollout__c).add(country.Country_Code__c);
                }
                else{
                  relatedMCOAndCountry.put(country.Local_Rollout__c,new Set<String>{country.Country_Code__c});
                }
            }
        }
    }
	
	/**
    *  @Description This is a helper method which checks the selected No Rollout related to Local Projects or not 
    *  @name checkRelatedLocalProjectOrNot
    *  @param regionalNoRollListStr :  List of selecte Countries with No Rollout
    *  @return NONE
    */
	public void checkRelatedLocalProjectOrNot(List<String> regionalNoRollListStr)
	{	
		for (String countryCode : regionalNoRollListStr)
        {
            String countryRolloutName = getCountryExternalId(countryCode);
            if(existingRelatedCountriesMap.containsKey(countryRolloutName))
            {
              countryProj = existingRelatedCountriesMap.get(countryRolloutName);
              if(relatedMCOAndCountry.containsKey(countryProj.Local_Rollout__c)){
                relatedMCOAndCountry.get(countryProj.Local_Rollout__c).remove(countryCode);
              }
              if(countryProj.IPM_Local_Project__c != null)
          	  {
              	localProjCnt++;
                countryRelatedProj = true;
              }
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