/**
   @Author Cognizant
   @Name IPM_RolloutPlansTableController
   @CreateDate 27/04/2015
   @Description This class is used for managing the view and edit mode of the rollouts
   @Version 1.0
   @reference IPM_RolloutPlans VF page, IPM_LocalRolloutPlansTable component, IPM_RolloutPlansTable component
  */
public with sharing class IPM_RolloutPlansTableController extends IPM_ProjectIntermediateController
{
    public String projectId {get; set;} //project id of the current project
    public IPM_Project__c project {get; set;} //The project record for which the rollouts are being viewed   
    public IPM_Project_Type__c projectType {get;set;}
  
    
    @TestVisible private Set<String> setRegionalProjectNames {get; set;} //Set of Regional Projects which have already been created for this project hierarchy
    @TestVisible private Set<String> setLocalProjectNames {get; set;} //Set of Local Projects which have already been created for this project hierarchy
    @TestVisible private String[] MCOfilters;
    
  
    public Map<Id,Map<Id,List<IPM_Country__c>>> projectTolocalRolloutToCountryMap{get;set;}
    public Map<Id,Map<Id,List<IPM_Country__c>>> rolloutTolocalRolloutToCountryMap{get;set;}
    public List<IPM_Company_Card__c> lstUserLocalCompanyCards{get;set;} // local company card
    public List<IPM_Company_Card__c> lstUserRegionalCompanyCards{get;set;} // reginal company card
    // contains Regional Plus Local Project as well as Rollout List
    public Map<Id,IPM_Project__c> lstcompleteProjects {get; set;} //List of Regional Rollouts after they have been converted to Projects  
    public Map<Id,IPM_Project_Rollout__c> lstcompleteRollout {get; set;} //List of local Rollouts after they have been converted to Projects  
    public String selectedMCORollout {get; set;} //Selected MCO Rollout - used for deletion
    public String cancelRedirect;
    public Boolean isPLAllocated {get; set;} //Boolean variable to define if PL is allocated for regional rollout
    public Boolean doShowPLName {get; set;} //Boolean variable to define if PL is name should be shown for regional rollout
    public Boolean isFLAllocated {get; set;} //Boolean variable to define if PL is allocated for regional rollout
    public Boolean doShowFLName {get; set;} //Boolean variable to define if PL is name should be shown for regional rollout
    
    public Boolean isSpanGlobal {get; set;} //Boolean variable to define if project span is Global
    public Boolean isSpanRegional {get; set;} //Boolean variable to define if project span is Regional
    public Boolean isEditMode {get; set;} //Boolean variable to define if the page is in edit mode
    public Boolean isEditable{get;set;} //Boolean Variable to define if the record is editable by the current logged in user
    public Boolean isStatusEditable {get; set;} //If the Rollout Status can be edited
    @TestVisible private Integer leaderCount {get; set;} //Total count of the rollouts with Leader Status
    public Integer rolloutCount{get; set;} // To calculate the count of rollouts to show on the page
    public Boolean isRolloutEditable{get;set;} ////If the Rollout can be edited
    public Boolean isEligibleToAddRollout {get;set;} //If the user is eligible to add Rollout
    public Map<String,Boolean> nonKeyMcoTLDMisalignedMap {get;set;} // CR0355 - Map to capture non-key mco TLD misalignment.
    
    public Boolean isError {get; set;} //Boolean variable to indicate error on page
    public String errorMessage {get; set;} //Error Message to be displayed on the page  
    public String validationError{get;set;}
    private Map<Id,Date> localProjIdTLDMap = new Map<Id,Date> {};
    public static final String CANCEL_REDIRECT = 'cancelRedirect';
    public static final String BOOLEAN_TRUE = 'true';
    public static final String CHECK_ROLLOUTS = 'checkRollouts';
    public Boolean isArchiveFalse = false;
	public Boolean changeDateVal {get;set;}
    public String showEntity{get;set;}
    @TestVisible private static final String ID_PARAMETER = 'Id';
    @TestVisible private static final String ADD_ROLLOUT= 'addRollout';
    @TestVisible private static final String SAVE_ROLLOUT = 'saveRollout';
    @TestVisible private static final String regionalSpan = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
    @TestVisible private static final String REGIONAL_ROLLOUT_RECORDTYPE =Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId(); //Recordtype Id for Regional Rollouts on IPM_Project_Rollout__c object cant delete it using in the query below
    @TestVisible private static final String LOCAL_ROLLOUT_RECORDTYPE =Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId(); //Recordtype Id for Local Rollouts on IPM_Project_Rollout__c object cant delete it using in the query below
    @TestVisible private static final String LOCAL_COMPANYCARD_RECORDTYPE =Schema.SObjectType.IPM_Company_Card__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_LOCAL).getRecordTypeId(); //Recordtype Id for Local Company card on IPM_Company_Card__c object cant delete it using in the query below
    @TestVisible private static final String REGIONAL_COMPANYCARD_RECORDTYPE =Schema.SObjectType.IPM_Company_Card__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_REGIONAL).getRecordTypeId(); //Recordtype Id for Regional Company card on IPM_Company_Card__c object cant delete it using in the query below
    @TestVisible private static final String CLASS_NAME = IPM_RolloutPlansTableController.class.getName();//Class Name for Exception Logging
    public map<id,IPM_Project_Rollout__c>localRolloutBrandMap{get;set;}//map for local rollout with list of brand 
    public boolean isBrandEditable{get;set;}//set true for rollout project with feasibility/capability phase
    public string localRolloutIdBrand{get;set;}
    public string localRolloutBrand{get;set;}
    @TestVisible private Map<id,IPM_Project_Rollout__c> rolloutToUpdateBrand;
    public map<id,set<string>> holdRolloutidBrandMap{get;set;}//map of local rollout id and set of brands
    @TestVisible private Map<string,IPM_Country__c> rolloutCountryMap;//map for country name and country details
    /*******************************************************************************************************
    * @description  Constructor
    * @param        NONE
    * @return       NONE
    */
    public IPM_RolloutPlansTableController()
    {
        IPM_IECompatible.ieFix();//Added for compatibility fix
       
        showEntity = IPM_ConstantUtils.BLANK;
        initialise();
        
    }
   
    /*******************************************************************************************************
* @description  Method to check if any rollouts exist and if not, redirect to the appropriate 
*               page for adding rollouts
* @param        NONE
* @return       Page Reference to the appropriate page
*/
    public PageReference checkRollouts()
    {
        try
        {
            cancelRedirect = ApexPages.currentPage().getParameters().get(CANCEL_REDIRECT);
 
            if( (lstcompleteProjects.isEmpty() && lstcompleteRollout.isEmpty())  && (cancelRedirect != BOOLEAN_TRUE))
            {
                if( !( project.IPM_PrepareForArchival__c || project.Is_Archieved__c ) )
                {
                return addRollout();
                }
            }
            return null;
        } 
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,CHECK_ROLLOUTS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            isError = TRUE;
            errorMessage = Label.IPM_PLEASE_CONTACT_ADMINISTRATOR;
            return null;
        }
    }
    
    /*******************************************************************************************************
    * @description  Method to initialise data points to be displayed on the page
    * @param        NONE
    * @return       NONE
    */
    private void initialise()
    {
    	isPLAllocated = false; 
        isEditMode = false;
        isFLAllocated=false;
		changeDateVal = false;
        // initialisation
		isBrandEditable = false;
        rolloutToUpdateBrand = new map<id,IPM_Project_Rollout__c>();
		rolloutCountryMap = new Map<string,IPM_Country__c>(); 
       	nonKeyMcoTLDMisalignedMap = new Map<String, Boolean>();
       	if(projectTolocalRolloutToCountryMap!=null)
       	{
       		projectTolocalRolloutToCountryMap.clear();
       		rolloutTolocalRolloutToCountryMap.clear();
       	}
       	
        projectTolocalRolloutToCountryMap = new Map<Id,Map<Id,List<IPM_Country__c>>>();
        rolloutTolocalRolloutToCountryMap = new Map<Id,Map<Id,List<IPM_Country__c>>>();

        lstcompleteProjects = new Map<Id,IPM_Project__c>();   
        lstcompleteRollout = new Map<Id,IPM_Project_Rollout__c>();
        
        try
        {
            String editMode='';
            projectId = ApexPages.currentPage().getParameters().get(ID_PARAMETER);
            if (projectId != null)
            {
                List<IPM_Project__c> projectList  = [SELECT Id, IPM_CompanyCardText__c,IPM_White_Space_Project__c, IPM_Child_Complexity__c, Deputy_Project_Leader__c, 
                           IPMCompany__c, IPM_Clustering__c, IPMPlatform__c, IPMProject_Span__c, IPMProject_Type__c, IPMRegion__c, IPM_Answer_of_Q1__c, 
                           IPM_Answer_of_Q2__c, IPM_Answer_of_Q3__c, IPM_Approver_of_Charter__c, IPM_Approver_of_Contract_Market_Ready__c, 
                           IPM_Bosscard_Status__c, IPM_Bosscard__c, IPM_Brand_Positioning__c, IPM_Brand__c, IPM_Category_Group__c,IPM_SourceProjectType__c, 
                           IPM_Category_Icon__c,IPM_Category_Text__c,IPM_Category__c,IPM_Company_Card__c,IPM_Complexity__c,IPM_Core_Parameters__c,
                           IPM_CPP_Change_Reason__c,IPM_CPP__c,IPM_Fast_Track_Project__c,IPM_FilledIn_Percentage__c,IPM_Finance_Lead__c,IPM_Project_Leader__r.SmallPhotoUrl,
                           IPM_GateKeeping_Model__c,IPM_Gate_Keeping_Module__c,IPM_IsCompleted__c,IPM_Market_Type__c,IPM_Market__c, IPM_Finance_Lead__r.SmallPhotoUrl,
                           IPM_Parent_Project__c,IPM_Parent_Project__r.Name,IPM_Parent_Project__r.IPM_Project_Name__c,IPM_Phase__c,IPM_PM_Approach__c,IPM_Project_Description__c,
                           IPM_Project_Gatekeeper__c,IPM_Project_Leader__c,IPM_Project_Logo_Id__c,IPM_Project_Logo__c,IPM_Project_Name__c,
                           IPM_Project_Type__c,IPM_Sector__c,IPM_Strategic_Intent__c,IPM_Sub_Category__c,IPM_Target_Launch_Dates__c,Rollout_Plan_Target_Launch_Date__c,
                           IPM_Target_Launch_Date__c,IPM_Technical_Project_Leader__c,IPM_UserCategory__c,IPM_PrepareForArchival__c,Is_Archieved__c,Name,Sustainability_Period__c,IPM_ProjectSubType__c,IPM_Data_Migrated_Gate__c,  
                           (SELECT Id, Is_Archieved__c,IPM_Project_Name__c FROM IPM_Projects__r),
                           (SELECT Id, IPM_Document_Status__c, IPM_GateDocuments__c, IPM_Project__c, IPM_Project_Template__c, IPM_Contract_GateKeeper_Model__c, IPM_Project__r.IPMProject_Span__c, IPM_Project__r.IPM_Project_Name__c FROM Project_Documents__r)
                           FROM IPM_Project__c 
                           WHERE Id=:projectId LIMIT 1];
                
                if(!projectList.isEmpty())
                {
                    project = projectList[0];
                }
                
                showEntity = String.format(Label.IPM_ShowEntity,new String[]{project.IPMProject_Span__c});
                isEditable = IPM_Utils.getIPMRollOutUser(projectId);
                
                if(isEditable)
                {
                    isEditable = !(project.IPM_PrepareForArchival__c || project.Is_Archieved__c);
                } 

                if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
                {
                    isSpanGlobal = true;
                }
                else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
                {
                    isSpanRegional = true;
                }
                
                getProjectRollouts();
                
                getUserList(); 
                
                editMode=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.EDITMODE);
                
                if(IPM_ConstantUtils.EDITMODE_TRUE.equalsIgnoreCase(editMode)) 
                {
                    isEditMode = true;
                }
                else
                {
                    isEditMode = false;
                }
                
                Id currLoggedinUserId = UserInfo.getUserId();
                
                List<IPM_User_Profile__c> lstIPMCurrentUserProfile = [SELECT IPM_User__c, IPM_User__r.Name, IPM_User__r.UserRole.Name, ipm_user__r.smallphotourl, ipm_user__r.Email, IPM_User_Function__c,IPM_User_Role__c, IPM_Region__c, IPM_Company_Card__c 
                                                            FROM IPM_User_Profile__c 
                                                            WHERE IPM_User__c =: currLoggedinUserId AND IPM_User__r.IsActive = true AND IPM_User_Role__c =: IPM_ConstantUtils.PROJECT_LEADER LIMIT 1];
                                               
                if(lstIPMCurrentUserProfile != NULL && !lstIPMCurrentUserProfile.isEmpty() && isEditMode )
                {
                    isEligibleToAddRollout = true;
                }
                else
                {
                    isEligibleToAddRollout = false;
                }
                
                rolloutCount = 0;
                
                projectType = IPM_Utils.retrieveProjectType(project);
                
                //check for isRolloutEditable
                if(!isEditMode && isEditable)
                {
                    isRolloutEditable = true;     
                }
                else
                {
                    isRolloutEditable = false; 
                }
                if(isPLAllocated && isEditMode)
                {
                    doShowPLName = true;     
                }
                if(isFLAllocated && isEditMode)
                {
                    doShowFLName = true;   
                }
				getAllbrands();
            }
        } 
        catch (Exception ex) 
        {
            isError = TRUE;
            errorMessage = Label.IPM_PLEASE_CONTACT_ADMINISTRATOR;
        }          
    }           
    
    /*******************************************************************************************************
    * @description  Method to get the list of users to be used when assigning Project Leaders and 
    *               Finance Members
    * @param        NONE
    * @return       NONE
    */
    private void getUserList()
    {
        Map<Id,String> marketClusterRolloutMap = new Map<Id,String>();
        //Logic to create map(rolloutCountryNamesMap) of regional rollout and the list of countries to associate Company card of the matching geographical scope, when PL is assigned for the rollout             
        
        
        Map<Id, List<IPM_Country__c>> rolloutCountryNamesMap = new Map<Id, List<IPM_Country__c>>();
        if(rolloutTolocalRolloutToCountryMap != Null && !rolloutTolocalRolloutToCountryMap.isEmpty()) //checking regional rollout or local rollout in based on span
        {
            for(Id regionalId : rolloutTolocalRolloutToCountryMap.keySet())
            {
                Map<Id,List<IPM_Country__c>> localrolloutCountryMap = rolloutTolocalRolloutToCountryMap.get(regionalId);
                if(!localrolloutCountryMap.isEmpty())
                {
                    rolloutCountryNamesMap.putAll(localrolloutCountryMap);
                }
                
                //Add Unique Names
                if(!marketClusterRolloutMap.containsKey(regionalId) && lstcompleteRollout.containsKey(regionalId))
                {
                    marketClusterRolloutMap.put(regionalId, lstcompleteRollout.get(regionalId).Market_Cluster_Name__c);
                }
            }
        }
            
          
        //Logic to create map(rolloutCCMap) local rollout and its company card matching geographical scope, when PL is assigned for the rollout            
        String[] filters = new String[]{};
        
        for(Id localRolloutId : rolloutCountryNamesMap.KeySet()) 
        {
            List<IPM_country__c> associatedCountryList  = rolloutCountryNamesMap.get(localRolloutId);
            for(IPM_Country__c country : associatedCountryList)
            { 
                if(!String.isBlank(country.Country_Name__c))
                {
                    filters.add(IPM_ConstantUtils.PERCENTAGE + country.Country_Name__c + IPM_ConstantUtils.PERCENTAGE); 
                }
            }
        }             
            
        MCOfilters = new String[]{};
            
        if(!marketClusterRolloutMap.isEmpty())
        {   
            //changes  user 
            for(String marketCluster : marketClusterRolloutMap.values())
            { 
                MCOfilters.add(IPM_ConstantUtils.PERCENTAGE + marketCluster + IPM_ConstantUtils.PERCENTAGE);
            }           
        }

        lstUserLocalCompanyCards = new List<IPM_Company_Card__c>();
        lstUserLocalCompanyCards = [SELECT Id, name, IPM_TxtGeographical_Scope__c, IPM_Managed_Category__c,IPM_Market_Cluster__c  
                               FROM IPM_Company_Card__c 
                               WHERE RecordTypeId =:LOCAL_COMPANYCARD_RECORDTYPE AND IPM_TxtGeographical_Scope__c like :filters 
                               AND IPM_Managed_Category__c INCLUDES(:project.IPM_Category_Text__c) LIMIT 50000];           
        
        lstUserRegionalCompanyCards = new List<IPM_Company_Card__c>();
        lstUserRegionalCompanyCards = [SELECT Id, name, IPM_TxtGeographical_Scope__c, IPM_Managed_Category__c,IPM_Market_Cluster__c  
                               FROM IPM_Company_Card__c 
                               WHERE RecordTypeId =:REGIONAL_COMPANYCARD_RECORDTYPE AND IPM_TxtGeographical_Scope__c like :MCOfilters
                               AND IPM_Managed_Category__c INCLUDES(:project.IPM_Category_Text__c) LIMIT 50000];
            
        

        
    }
    
    /*******************************************************************************************************
    * @description  Method to get the list of rollouts
    * @param        NONE
    * @return       NONE
    */
    private void getProjectRollouts()
    {
        projectTolocalRolloutToCountryMap = new Map<Id,Map<Id,List<IPM_Country__c>>>();
        rolloutTolocalRolloutToCountryMap = new Map<Id,Map<Id,List<IPM_Country__c>>>();

        lstcompleteProjects = new Map<Id,IPM_Project__c>();   
        lstcompleteRollout = new Map<Id,IPM_Project_Rollout__c>();
        isStatusEditable = false;
        leaderCount = 0;
        
        getRegionalProjectsGlobal(); // List of child Project(inclding Local Rollouts) based on Span
        getRegionalRollouts(); // List of Child Rollouts(inclding Local Rollouts) which have not been converted to Projects.
        
        for(IPM_Project_Rollout__c rollout : lstcompleteRollout.values())
        {
            if(rollout.recordTypeId  == LOCAL_ROLLOUT_RECORDTYPE)
            {
                leaderCount++;  
            }
        }
        
        if(leaderCount > 1)
        {
            isStatusEditable = true;
        }
     }
    
    /*******************************************************************************************************
    * @description  Method to get the list of regional projects to be displayed
    * @param        NONE
    * @return       NONE
    */
    private void getRegionalProjectsGlobal()
    {
        setRegionalProjectNames = new Set<String>();
        setLocalProjectNames = new Set<String>();
        
        Set<Id> localRolloutIdSet = new Set<Id>();
        
        Map<Id,IPM_Project__c> associatedProjectMap = new Map<Id,IPM_Project__c>(); 
            
        if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
        { // If it is a Global Project, get regional Projects and associated Rollouts against regional Projects.
                
            String queryString = 'SELECT Id,IPM_Rollout_Status__c,IPM_RolloutStatus__c,Name,IPM_Project_Leader__r.SmallPhotoUrl,IPM_Finance_Lead__r.SmallPhotoUrl,IPM_Project_Name__c,IPM_Phase__c,IPM_Target_Launch_Dates__c, IPM_Project_Leader__c,IPM_Finance_Lead__c, Rollout_Plan_Target_Launch_Date__c, ';
            
            queryString+= ' (SELECT ';
            
            for (String field : Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap().KeySet())
            {
                if (!(field.equalsignoreCase(ID_PARAMETER)))
                {
                    queryString+= field + ', ';
                }
            }
            queryString+= ' Id, Local_Project__r.IPM_Project_Leader__c, Local_Project__r.IPM_Finance_Lead__c,Local_Project__r.IPM_Project_Leader__r.SmallPhotoUrl, Local_Project__r.IPM_Finance_Lead__r.SmallPhotoUrl,IPM_Regional_PL__r.smallphotourl,Finance_Member__r.smallphotourl FROM Regional_Project_Rollout__r  where ( isActive__c = true OR '+ showEntity + ' = true )' ;
            queryString+= ' ORDER BY IPM_Rollout_Project__c), ';
            
            queryString+= ' (SELECT ';
            for (String field : Schema.SObjectType.IPM_Project__c.fields.getMap().KeySet())
            {
                if (!(field.equalsignoreCase(ID_PARAMETER)))
                {
                    queryString+= field + ', ';
                }
            }
            queryString+= ' Id from IPM_Projects__r ';
            if(project.Is_Archieved__c)
            {
                queryString+= ' where Is_Archieved__c = true AND IPM_StoppedByProject__c = :projectId ';      
            } 
            else
            {
                queryString+= ' where Is_Archieved__c =: isArchiveFalse '; 
            } 
            queryString+= ' ORDER BY IPM_Project_Name__c) ';
          
            queryString+= ' FROM IPM_Project__c WHERE IPM_Parent_Project__c =: projectId AND IPMProject_Span__c =: regionalSpan';
            if(project.Is_Archieved__c)
            {
                queryString+= '  AND Is_Archieved__c = true AND IPM_StoppedByProject__c = :projectId ';      
            } 
            else
            {
                queryString+= '  AND Is_Archieved__c =: isArchiveFalse '; 
            } 
            queryString+= ' ORDER BY IPM_Project_Name__c LIMIT 50000';
            
            associatedProjectMap = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>)Database.query(queryString) );

            for(IPM_Project__c regionalProject : associatedProjectMap.values())
            {
                setRegionalProjectNames.add(regionalProject.IPM_Project_Name__c);
                //Check Leader Status
                for(IPM_Project_Rollout__c localRollout : regionalProject.Regional_Project_Rollout__r)
                {
                    localRolloutIdSet.add(localRollout.Id);
                    lstcompleteRollout.put(localRollout.Id,localRollout); // Add Local Rollouts to the composite Map                         
                }
            }
               
            for(IPM_Project__c regionalProject : associatedProjectMap.values())
            {
                lstcompleteProjects.put(regionalProject.Id,regionalProject); // Add Regional Projects to the composite Map
                localProjIdTLDMap.put(regionalProject.Id,regionalProject.Rollout_Plan_Target_Launch_Date__c);
                setRegionalProjectNames.add(regionalProject.IPM_Project_Name__c);
                //Check Leader Status
                for(IPM_Project__c localProject : regionalProject.IPM_Projects__r)
                {
                    lstcompleteProjects.put(localProject.Id,localProject); // Add Local Rollouts to the composite Map      
                    localProjIdTLDMap.put(localProject.Id,localProject.Rollout_Plan_Target_Launch_Date__c);                 
                }
           }
        } 
        else if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            String localSpan = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;//used in the query below
            
            String queryString = ' SELECT Id,Is_Archieved__c ,Name,IPM_Rollout_Status__c,IPM_RolloutStatus__c,IPM_Finance_Lead__r.SmallPhotoUrl,IPM_Project_Leader__r.SmallPhotoUrl,IPM_Project_Name__c, IPM_Target_Launch_Dates__c, IPM_Project_Leader__c, IPM_Finance_Lead__c,IPM_Project_Rollout__c,Rollout_Plan_Target_Launch_Date__c ';
            queryString+= ' FROM IPM_Project__c WHERE IPM_Parent_Project__c =: projectId AND IPMProject_Span__c =: localSpan AND Is_Archieved__c =: isArchiveFalse';
            if(project.Is_Archieved__c) 
            {
                queryString+= ' AND Is_Archieved__c = true AND IPM_StoppedByProject__c = :projectId ';      
            } 
            else
            {
                queryString+= ' AND Is_Archieved__c =: isArchiveFalse '; 
            } 
            queryString+= ' ORDER BY IPM_Project_Name__c';
            
            associatedProjectMap = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>)Database.query(queryString));
            
            lstcompleteProjects.putAll(associatedProjectMap); // Add Local Projects to the composite Map
            
            Set<Id> localProjectAssociatedRollouts = new Set<Id>();
            
            for(IPM_Project__c localProject : associatedProjectMap.values())
            {
                setLocalProjectNames.add(localProject.IPM_Project_Name__c); 
                localProjectAssociatedRollouts.add(localProject.IPM_Project_Rollout__c);
                localProjIdTLDMap.put(localProject.Id,localProject.Rollout_Plan_Target_Launch_Date__c);                 
            }
            
            // Add to composite List for Country checking 
            localRolloutIdSet.addAll(localProjectAssociatedRollouts);
            
            // Get the List of Local Rollouts from Source Rollouts of Local Projects.
            
            String queryLocalRolloutString = 'SELECT ';
            
            for (String field : Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap().KeySet())
            {
                if (!(field.equalsignoreCase(ID_PARAMETER)))
                {
                    queryLocalRolloutString += field + ', ';
                }
            }
            
            queryLocalRolloutString+= 'Id,Local_Project__r.IPM_No_Rollout_Disabled__c,IPM_Regional_PL__r.SmallPhotoUrl,Finance_Member__r.SmallPhotoUrl,Local_Project__r.IPM_Project_Leader__c, Local_Project__r.IPM_Finance_Lead__c,Local_Project__r.IPM_Project_Leader__r.SmallPhotoUrl, Local_Project__r.IPM_Finance_Lead__r.SmallPhotoUrl FROM IPM_Project_Rollout__c WHERE Id in:localProjectAssociatedRollouts and ( isActive__c = true OR '+ showEntity + ' = true ) ORDER BY IPM_Rollout_Project__c '; 
           
            Map<Id,IPM_Project_Rollout__c> associatedLocalRolloutMap = new Map<Id,IPM_Project_Rollout__c>( (List<IPM_Project_Rollout__c>)Database.query(queryLocalRolloutString) );
            
            if(!associatedLocalRolloutMap.isEmpty())
            {
                lstcompleteRollout.putAll(associatedLocalRolloutMap);
            }
            
        }
            
            
        // Map of Local Rollouts against corresponding Countries. It would only contain Local Rollouts which have associated Countries.
        Map<Id,List<IPM_Country__c>> localRolloutToCountryMap = getLocalRolloutToCountryMapping(localRolloutIdSet);
        
        // Prepare Mapping Between Regional Project and Local Projects, based on Whether local projects have an associated Country.

        // If it is a Regional Project, Get the List of Local Rollouts from the relationship
        if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c) && !associatedProjectMap.isEmpty())
        {
             
            for(IPM_Project__c project : associatedProjectMap.values())
            {
                projectTolocalRolloutToCountryMap.put(project.Id, new Map<Id,List<IPM_Country__c>>());
                
                // List of all Local Projects associated to Regional Project 
                List<IPM_Project_Rollout__c> localRolloutList = project.Regional_Project_Rollout__r;
                // Iterate throught the Logic Rollout and identify whether countries are associated with it or not.
                for(IPM_Project_Rollout__c localRollout : localRolloutList)
                {
                    if(localRolloutToCountryMap.containsKey(localRollout.Id))
                    {
                        projectTolocalRolloutToCountryMap.get(project.Id).put(localRollout.Id,localRolloutToCountryMap.get(localRollout.Id));
                    }
                }   
            }
        }
        else if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c) && !associatedProjectMap.isEmpty())
        {
            // If it is a Local Project, get Corresponding Local rollouts and validate whether it has countries 
            for(IPM_Project__c project : associatedProjectMap.values())
            {
                projectTolocalRolloutToCountryMap.put(project.Id, new Map<Id,List<IPM_Country__c>>());
                
                Id localRolloutId = project.IPM_Project_Rollout__c;
            
                if(localRolloutToCountryMap.containsKey(localRolloutId))
                {
                    projectTolocalRolloutToCountryMap.get(project.Id).put(localRolloutId,localRolloutToCountryMap.get(localRolloutId));
                }   
            }
        }  
    }
    
    private Map<Id,List<IPM_Country__c>> getLocalRolloutToCountryMapping(Set<Id> localRolloutIdSet)
    {
        Map<Id,List<IPM_Country__c>> localRolloutToCountryMap = new Map<Id,List<IPM_Country__c>>();
        
        if(!localRolloutIdSet.isEmpty())
        {
            String localRolloutQuery = 'SELECT ';
            
            for (String field : Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap().KeySet())
            {
                if (!(field.equalsignoreCase(ID_PARAMETER)))
                {
                    localRolloutQuery += field + ', ';
                }
            }
            localRolloutQuery+= ' Id,(SELECT   ';
            
            for (String field : Schema.SObjectType.IPM_Country__c.fields.getMap().KeySet())
            {
                if (!(field.equalsignoreCase(ID_PARAMETER)))
                {
                    localRolloutQuery += field + ', ';
                }
            }
            
            localRolloutQuery += 'Id FROM IPM_Countries_Local__r where ( isActive__c = true OR '+ showEntity + ' = true ) ) ,Finance_Member__r.SmallPhotoUrl,IPM_Regional_PL__r.SmallPhotoUrl FROM IPM_Project_Rollout__c where ( isActive__c = true OR '+ showEntity + ' = true ) AND  Id in :localRolloutIdSet LIMIT 50000 ';
            
            Map<Id,IPM_Project_Rollout__c> localRolloutMap = new Map<Id,IPM_Project_Rollout__c>( (List<IPM_Project_Rollout__c>)database.query(localRolloutQuery) );
            
            for(IPM_Project_Rollout__c  localRollout : localRolloutMap.values())
            {
                if(!localRollout.IPM_Countries_Local__r.IsEmpty() )
                {
                    localRolloutToCountryMap.put(localRollout.Id,localRollout.IPM_Countries_Local__r);
                }
				for(IPM_Country__c country  :localRollout.IPM_Countries_Local__r)  
                {
                    rolloutCountryMap.put(country.Country_Name__c,country);
                }  
            }
        }
        
        return localRolloutToCountryMap;
    }
    
    /*******************************************************************************************************
    * @description  Method to get the list of regional rollouts to be displayed
    * @param        NONE
    * @return       NONE
    */
    private void getRegionalRollouts()
    {
        String nullRegionalProject = null;//used in the query below
        String queryString = 'SELECT ';
        
        Map<Id,IPM_Project_Rollout__c> projectRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        Set<Id> localRolloutIdSet = new Set<Id>();
            
        if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            //IPM PROJECT ROLLOUT
            
            for (String field : Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap().KeySet())
            {
                queryString+= field + ', ';
            }
            queryString+= 'IPM_Regional_PL__r.Name,Finance_Member__r.Name,Finance_Member__r.SmallPhotoUrl, (SELECT ';
            
            for (String field : Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap().KeySet())
            {
                if (!(field.equalsignoreCase(ID_PARAMETER)))
                {
                    queryString+= field + ', ';
                }
            }
            queryString+= ' Id FROM Local_Rollouts__r';
            queryString+= ' WHERE Regional_Project__c =: nullRegionalProject AND ( isActive__c = true OR '+ showEntity + ' = true ) ';
            queryString+= ' ORDER BY IPM_Rollout_Project__c),';
            queryString+= ' IPM_Project__r.IPM_Phase__c, IPM_Regional_PL__r.SmallPhotoUrl FROM IPM_Project_Rollout__c WHERE IPM_Project__c =: projectId AND RecordTypeId =: REGIONAL_ROLLOUT_RECORDTYPE AND (NOT IPM_Rollout_Project__c IN: setRegionalProjectNames) AND ( isActive__c = true OR '+ showEntity + ' = true ) ';
            
        } 
        else if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            //IPM PROJECT ROLLOUT
            for (String field : Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap().KeySet())
            {
                if (!(field.equalsignoreCase(ID_PARAMETER))) 
                {
                    queryString+= field + ', ';
                }
            }
            queryString+= ' Id,Local_Project__r.IPM_No_Rollout_Disabled__c,IPM_Regional_PL__r.Name,Finance_Member__r.Name,IPM_Regional_PL__r.SmallPhotoUrl,Finance_Member__r.SmallPhotoUrl FROM IPM_Project_Rollout__c WHERE Regional_Project__c =: projectId AND RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE AND (NOT IPM_Rollout_Project__c IN: setLocalProjectNames) AND ( isActive__c = true OR '+ showEntity + ' = true )'; 
        }       
        
        queryString+= ' ORDER BY IPM_Rollout_Project__c LIMIT 50000';
            
        projectRolloutMap = new Map<Id,IPM_Project_Rollout__c>( (List<IPM_Project_Rollout__c>)Database.query(queryString));

        lstcompleteRollout.putAll(projectRolloutMap);
           
        if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            for(IPM_Project_Rollout__c regionalRollOut : projectRolloutMap.values())
            {
                for(IPM_Project_Rollout__c localRollout : regionalRollOut.Local_Rollouts__r)
                {
                    lstcompleteRollout.put(localRollout.Id,localRollout); // Add Local Rollouts to the Compltete List
                    localRolloutIdSet.add(localRollout.Id);
                }
                lstcompleteRollout.put(regionalRollOut.Id,regionalRollOut); // Add Regional Rollouts to the Compltete List    
            }
        } 
        else
        {
            for(IPM_Project_Rollout__c localRollout : projectRolloutMap.values())
            {
                localRolloutIdSet.add(localRollout.Id);
                lstcompleteRollout.put(localRollout.Id,localRollout); // Add Local Rollouts to the Compltete List
            }
        }
        // CR0355 - populate 'nonKeyMcoTLDMisalignedMap' with default values to avoid element not found exception
         for (IPM_Project_Rollout__c localRollout : lstcompleteRollout.values()) {
                if( nonKeyMcoTLDMisalignedMap.isEmpty() || !nonKeyMcoTLDMisalignedMap.keySet().contains(localRollout.Regional_Rollout_External_Id__c) ) {
                	nonKeyMcoTLDMisalignedMap.put(localRollout.Regional_Rollout_External_Id__c,false);
                }
        }   
            
        Map<Id,List<IPM_Country__c>> localRolloutToCountryMap = getLocalRolloutToCountryMapping(localRolloutIdSet);
                  
        if(!projectRolloutMap.isEmpty())
        {
            if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
            {
                // This contains Regional Rollouts.
                for(IPM_Project_Rollout__c regionalRollout : projectRolloutMap.values())
                {
                    rolloutTolocalRolloutToCountryMap.put(regionalRollout.Id,new Map<Id,List<IPM_Country__c>>());
                    
                    List<IPM_Project_Rollout__c> localRollouts = regionalRollout.Local_Rollouts__r;
                   
                    for(IPM_Project_Rollout__c localRollout : localRollouts)
                    {
                        if(localRolloutToCountryMap.containsKey(localRollout.Id))
                        {
                            rolloutTolocalRolloutToCountryMap.get(regionalRollout.Id).put(localRollout.Id,localRolloutToCountryMap.get(localRollout.Id));
                        }
                    }   
                }   
            }
            else if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
            {
                for(IPM_Project_Rollout__c localRollout : projectRolloutMap.values())
                {
                    if(localRolloutToCountryMap.containsKey(localRollout.Id))
                    {
                        rolloutTolocalRolloutToCountryMap.put(localRollout.Id,new Map<Id,List<IPM_Country__c>>());
                        rolloutTolocalRolloutToCountryMap.get(localRollout.Id).put(localRollout.Id,localRolloutToCountryMap.get(localRollout.Id));
                    }       
                } 
            }   
        }
    }
    
    /*******************************************************************************************************
* @description  Method to redirect the user to appropriate add rollout page
* @param        NONE
* @return       NONE
*/
    public PageReference addRollout()
    {
            PageReference addRollouts = null;
            if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c))
            {
                addRollouts = Page.IPM_RolloutPlansAdd;
                addRollouts.getParameters().put(ID_PARAMETER, projectId);                
                addRollouts.setRedirect(true);
            }
            else if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c) && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)
            {   //For Regional Original Updated
                addRollouts = Page.IPM_RolloutPlansRegional;
                addRollouts.getParameters().put(ID_PARAMETER, projectId);                
                addRollouts.setRedirect(true);
            }
            else if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c) && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS )
            {   //For Regional Original Updated
                addRollouts = Page.IPM_RolloutPlansAdd;
                addRollouts.getParameters().put(ID_PARAMETER, projectId);                
                addRollouts.setRedirect(true);
            }
            else if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c) && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && project.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS)
            {   //For Regional Original Updated
                addRollouts = Page.IPM_RolloutPlansRegional;
                addRollouts.getParameters().put(ID_PARAMETER, projectId);                
                addRollouts.setRedirect(true);
            }           
            
            return addRollouts;
    }
    
    /*******************************************************************************************************
    * @description  Method to edit Rollouts
    * @param        NONE
    * @return       NONE
    */
    public PageReference editRollout()
    {
        //Method invoked in IPM_LocalRolloutPlansTable component PageReference
        PageReference rolloutPlans;
        rolloutPlans = Page.IPM_RolloutPlans;
        rolloutPlans.getParameters().put(ID_PARAMETER, projectId); 
        rolloutPlans.getParameters().put(IPM_ConstantUtils.EDITMODE, IPM_ConstantUtils.EDITMODE_TRUE );               
        rolloutPlans.setRedirect(true);

        return rolloutPlans;
    }
        
    
    /*******************************************************************************************************
    * @description  Method to save the rollouts
    * @param        NONE
    * @return       NONE
    */
    public PageReference saveRollout()
    {
       // CR0355 - clear 'nonKeyMcoTLDMisalignedMap'
       for(String key: nonKeyMcoTLDMisalignedMap.keySet()) {
       		nonKeyMcoTLDMisalignedMap.put(key,false);
       }
       
       	try
        {   
            Map<Id,IPM_Project_Rollout__c> updaterolloutsMap = new Map<Id,IPM_Project_Rollout__c>();
                         
            if(rolloutTolocalRolloutToCountryMap!= null && !rolloutTolocalRolloutToCountryMap.isEmpty())
            { 
                for(id rolloutId :rolloutTolocalRolloutToCountryMap.keySet())
                {
                    //  This contains Local Rollout Object for Regional Project rollout assignment and Regional Rollout, 
                    //  in case of Global Project Rollout assignment.
                    IPM_Project_Rollout__c rollout = lstcompleteRollout.get(rolloutId);
                
                    if(projectType!=null && projectType.IPM_CreateRegionalProjects__c || projectType!=null && projectType.IPM_CreateLocalProjects__c)
                    {
                        rollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                        rollout.IPM_RolloutJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                         
                    }
                    
                    
                    Date minimalDate = null;
                    // Check for child Rollouts if any. In case of regional Rollout Assignment, you will get local Projects.
                    if(rollOut.Local_Rollouts__r!=null && !rollOut.Local_Rollouts__r.isEmpty())  
                    {
                        for(IPM_Project_Rollout__c tempLocalRollout : rollOut.Local_Rollouts__r)
                        {
                            Id localRolloutId = tempLocalRollout.Id;
                            IPM_Project_Rollout__c localRollout = lstcompleteRollout.get(localRolloutId);
                            
                            if(projectType!=null && projectType.IPM_CreateLocalProjects__c)
                            {
                                localRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                                localRollout.IPM_RolloutJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                            } 
                            
                            
                        
                            // No Date has been set. Set the first Date.
                            if(minimalDate == null || localRollout.Target_Launch_Date__c < minimalDate)
                            {
                                minimalDate = localRollout.Target_Launch_Date__c;
                            }  
                        
                            updaterolloutsMap.put(localRollout.Id,localRollout);
                        }   
                    }
                    
                    if(minimalDate !=null)
                    {
                        rollout.Target_Launch_Date__c = minimalDate;
                        
                    }
                    
                    
                                    
                    updaterolloutsMap.put(rolloutId,rollout); 
                }
            }     
            List<IPM_Project__c> updateLocalProjTLDList = new List<IPM_Project__c>{};
            for(IPM_Project__c localRolloutProj :lstcompleteProjects.values()){
                Date oldTLD = localProjIdTLDMap.get(localRolloutProj.Id);
                if(oldTLD != localRolloutProj.Rollout_Plan_Target_Launch_Date__c){
                    updateLocalProjTLDList.add(localRolloutProj);
                }
            }

                      
            validationError = IPM_ConstantUtils.BLANK;
            
            if((updaterolloutsMap != NULL && !updaterolloutsMap.isEmpty()) || (updateLocalProjTLDList != NULL && !updateLocalProjTLDList.isEmpty()))
            {
                if(updaterolloutsMap != NULL && !updaterolloutsMap.isEmpty()){
                    Date dateToCompare = getLeastProjectMilestonesDate();
                    for(IPM_Project_Rollout__c rollout : updaterolloutsMap.values())
                    {
                        if(String.isBlank(String.valueOf(rollout.Target_Launch_Date__c)) || rollout.Target_Launch_Date__c <= System.today())
                        {
                            validationError = Label.IPM_Target_Launch_Date_Error;
                            break;
                        } 
                        if(rollOut.Target_Launch_Date__c < dateToCompare)
                        {
                            validationError = Label.TLD_After_Charter_Contract_and_Market_Ready_Milestone_Dates;
                          
                            break;
                        }       
                    } 
                    // CR0355 implementation starts
                    validateNonKeyMcoTLDMisalignment(updaterolloutsMap);
                    // CR0355 implementation ends
                    
                    for(IPM_Project_Rollout__c rollout : updaterolloutsMap.values())
                    {
                        if(String.isBlank(String.valueOf(rollout.Target_Launch_Date__c)) ||rollout.Target_Launch_Date__c <= System.today())
                        {
                            validationError = Label.IPM_Target_Launch_Date_Error;
                            break;
                        }    
                    }
                }
                if(updateLocalProjTLDList != NULL && !updateLocalProjTLDList.isEmpty()){
                    Date dateToCompare = getLeastProjectMilestonesDate();
                    for(IPM_Project__c localProject : updateLocalProjTLDList)
                    {
                        if(String.isBlank(String.valueOf(localProject.Rollout_Plan_Target_Launch_Date__c)) || localProject.Rollout_Plan_Target_Launch_Date__c <= System.today())
                        {
                            validationError = Label.IPM_Target_Launch_Date_Error;
                            break;
                        } 
                        if(localProject.Rollout_Plan_Target_Launch_Date__c < dateToCompare)
                        {
                            validationError = Label.TLD_After_Charter_Contract_and_Market_Ready_Milestone_Dates;
                            break;
                        }   
                    }               
                }              
                if(String.isBlank(validationError))
                {                         
                    if(!updaterolloutsMap.isEmpty())
                    {
                    	update updaterolloutsMap.values();
                    }
                    
                    if(!updateLocalProjTLDList.isEmpty())
                    {
                        update updateLocalProjTLDList;
                    }
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.IPM_PROCESSING_REQUEST));
					if(!changeDateVal)
                    {
                    	isEditMode=false ;

                    }else if(changeDateVal){
                        isEditMode=true;
                    }
                    saveLocalRolloutBrand();
					string editVal = string.valueOf(isEditMode);
                    PageReference rolloutPlans = Page.IPM_RolloutPlans;
		            rolloutPlans.getParameters().put(ID_PARAMETER, projectId);   
		            rolloutPlans.getParameters().put(IPM_ConstantUtils.EDITMODE, editVal);               
		            rolloutPlans.setRedirect(true);
		            return rolloutPlans;
                } 
                else
                {
                    isEditMode = true;
                }
            }
        }
        catch (Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,SAVE_ROLLOUT,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            isError = TRUE;
            errorMessage = Label.IPM_PLEASE_CONTACT_ADMINISTRATOR;
        }
        return null;
    }

    /*******************************************************************************************************
    * @description  Method to Validate Non-Key TLD misalignment
    * @param        Updated Project rollouts
    * @return       None
    */
   
    private void validateNonKeyMcoTLDMisalignment( Map<Id,IPM_Project_Rollout__c> updaterolloutsMap ) {
            // The TLD misalignment check is only for Global/Regional original projects in Ideas phase
            if( project.IPM_Phase__c==IPM_ConstantUtils.PHASE_IDEAS && project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && (project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL||project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)) {
                Map<String,Date> mcoTLDMap = new Map<String,Date>();
                Date mcoTDL;
                // iterate through rollouts
                for(IPM_Project_Rollout__c rollout : updaterolloutsMap.values()) {
                    // we are interested only in non-key local rollouts
                    if(!rollout.KeyMCO__c && rollout.IPM_Rollout_Span__c  ==IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL) {
                    	// get the non-key local rollouts TLDs into Map with its regional external id as key
                    	mcoTDL = mcoTLDMap.get(rollout.Regional_Rollout_External_Id__c);
                    	if(mcoTDL==null) {
                    		// for the first time 'mcoTLDMap' will be empty, fill it with first mco TLD
                    		mcoTLDMap.put(rollout.Regional_Rollout_External_Id__c,rollout.Target_Launch_Date__c);
                    		continue;
                    	}
                    	if(mcoTLDMap.get(rollout.Regional_Rollout_External_Id__c)!=rollout.Target_Launch_Date__c) {
                    		// if any of the non-key local rollout TLDs are not same, raise validation error 
                    	    nonKeyMcoTLDMisalignedMap.put(rollout.Regional_Rollout_External_Id__c,true);
                    		validationError = Label.IPM_NonMCO_TLD_Misaligned;
                    	}
                    }       
                }
            }

    }
    
    /*******************************************************************************************************
    * @description  Method to refresh the page to keep proper edit mode
    * @param        NONE
    * @return       PageReference of the page
    */
    private PageReference refreshPage()
    {
        PageReference rolloutPlans;
        rolloutPlans = Page.IPM_RolloutPlans;
        rolloutPlans.getParameters().put(ID_PARAMETER, projectId);                
        rolloutPlans.setRedirect(true);
        
        return rolloutPlans;
    }
    
    /*******************************************************************************************************
    * @description  Method to cancel without performing any DML actions
    * @param        NONE
    * @return       NONE
    */
    public PageReference cancelRollout()
    {
        //Method invoked in IPM_LocalRolloutPlansTable component
		isEditMode=false;
        return refreshPage();
    }
    
  
    /*******************************************************************************************************
    * @description  Method to delete MCO Rollout (Global)
    * @param        NONE
    * @return       NONE
    */
    public PageReference deleteMCORollout()
    {
        try
        {
            List<IPM_Project_Rollout__c> deleteRolloutList = [Select Id,Local_Project__c,IPM_CharterApproved__c,Regional_Project__c,IPM_Project__c,Target_Launch_Date__c from IPM_Project_Rollout__c where Id = :selectedMCORollout ];
            
            if(!deleteRolloutList.isEmpty())
            {
                IPM_Project_Rollout__c deleteRollout = deleteRolloutList[0];
                if(deleteRollout.Local_Project__c!=null)
                {
                    Id associatedLocalProjectId = deleteRollout.Local_Project__c;
                    String projectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null,true);
                    String projectWhereClause = ' WHERE Id = :associatedLocalProjectId LIMIT 5000';
                    projectQuery = projectQuery + projectWhereClause; 
                    List<IPM_Project__c> toBeArchievedRolloutProjects =  database.query(projectQuery);
                    
                    if(!toBeArchievedRolloutProjects.isEmpty())
                    {
                        IPM_Project__c rollOutProj = toBeArchievedRolloutProjects[0];
                        IPM_Project_Type__c currentProjectType = IPM_Utils.retrieveProjectType(rollOutProj);
                        if(currentProjectType != null && String.isNotBlank(currentProjectType.IPM_Gate_Document__c) )
                        {
                            rollOutProj.IPM_Is_Invoked_From_Rollout__c =true; 
                            rollOutProj.Is_Archieved__c = false;
                            rollOutProj.IPM_PrepareForArchival__c = true;
                            update rollOutProj;
                        }
                        else
                        {
                            rollOutProj.IPM_Is_Invoked_From_Rollout__c =true; 
                            rollOutProj.Is_Archieved__c=true;
                            update rollOutProj;
                        }
                    }
                    //recalculate TLD when rollout is inactive
                    Map<Id,IPM_Project_Rollout__c> rolloutProjectTLDChanged = new Map<Id,IPM_Project_Rollout__c> ();
                    rolloutProjectTLDChanged.put(deleteRolloutList[0].id,deleteRolloutList[0]);
                    IPM_RolloutPlanTLDSync rolloutPlanTLDSync = new IPM_RolloutPlanTLDSync();
                    rolloutPlanTLDSync.syncTLDDates(null,rolloutProjectTLDChanged);
                }
                else if(deleteRolloutList[0].IPM_CharterApproved__c)
                {
                    deleteRolloutList[0].isActive__c = false; 
                    update deleteRolloutList[0];
                }
                else
                {
                    delete deleteRolloutList[0];
                } 
            }
            //For CRUD
            initialise();
            
            PageReference rolloutPlans = Page.IPM_RolloutPlans;
            rolloutPlans.getParameters().put(ID_PARAMETER, projectId);   
            rolloutPlans.getParameters().put(IPM_ConstantUtils.EDITMODE, IPM_ConstantUtils.EDITMODE_TRUE);               
            rolloutPlans.setRedirect(true);
            return rolloutPlans;
            
                        
        } 
        catch (Exception ex) 
        { 
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,SAVE_ROLLOUT,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            isError = TRUE; 
            errorMessage = Label.IPM_PLEASE_CONTACT_ADMINISTRATOR;
            return null;
        }
    }
    /*******************************************************************************************************
    * @description  Method to get a date prior to any of mandatory project Milestones (except PLE and Target Launch Date).
    * @param        NONE
    * @return       Date
    */
    private Date getLeastProjectMilestonesDate(){
        //Method invoked in IPM_LocalRolloutPlansTable component
        List<String> milestoneNames = new List<String>{IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE,IPM_ConstantUtils.CONTRACT_GATE_APPROVAL_MILESTONE,IPM_ConstantUtils.MARKET_READY_GATE_APPROVAL_MILESTONE};
        List<IPM_Milestone__c> milestones = [Select Id,IPM_Active__c, IPM_Due_Date__c from IPM_Milestone__c where IPM_Project__c =: project.Id and IPM_Active__c = true and IPM_Due_Date_isNull__c = :IPM_ConstantUtils.IPM_false and IPM_Name__c in: milestoneNames limit 50000];
        Date leastProjectMilestonesDate = null;
        for(IPM_Milestone__c i :milestones){
            if(leastProjectMilestonesDate == null){
                leastProjectMilestonesDate = i.IPM_Due_Date__c;
            } else if(leastProjectMilestonesDate < i.IPM_Due_Date__c){
                leastProjectMilestonesDate = i.IPM_Due_Date__c;
            } 
        }
        return leastProjectMilestonesDate;
    } 
	/*************************************************************************************************
    *@Description:get all rollout with brands
    *************************************************************************************************/
    public void getAllbrands(){
        //get brand values
        holdRolloutidBrandMap = new map<id,set<string>>();//hold rollout id's with set of brand names
        List<MDO_BrandPositions__c>brandPosList = New list<MDO_BrandPositions__c>();
        brandPosList=[SELECT id,brand_position_id__r.Name,geo_id__r.Name,brand_id__r.Name FROM MDO_BrandPositions__c where 
                         brand_position_id__r.Name =: project.IPM_Brand_Positioning__c AND geo_id__r.Name IN :rolloutCountryMap.keyset() ORDER BY brand_id__r.Name ASC LIMIT 10000];
        for(IPM_Country__c country: rolloutCountryMap.Values())
        {
            if(!holdRolloutidBrandMap.containskey(country.Local_Rollout__c))
            {
                holdRolloutidBrandMap.put(country.Local_Rollout__c,new set<string>());
            }
            for(MDO_BrandPositions__c  brandPos:brandPosList)
            {
                if(brandPos.brand_id__r.Name !=null && country.Country_Name__c!=null && country.Country_Name__c.equals(brandPos.geo_id__r.Name) && country.IPM_Brand_Position__c!=null 
                    && country.IPM_Brand_Position__c.equals(brandPos.brand_position_id__r.Name) && !holdRolloutidBrandMap.get(country.Local_Rollout__c).contains(brandPos.brand_id__r.Name))
                {
                    holdRolloutidBrandMap.get(country.Local_Rollout__c).add(brandPos.brand_id__r.Name);
                 }
                
            }
        }
        //get all local rollouts with brand value 
        localRolloutBrandMap = new Map<Id,IPM_Project_Rollout__c>( [SELECT Id,IPM_Brand__c FROM IPM_Project_Rollout__c WHERE id IN :holdRolloutidBrandMap.keyset() LIMIT 10000]);
        for(IPM_Project_Rollout__c rollout: localRolloutBrandMap.values())
        {
            if(IPM_ConstantUtils.BRAND_NOT_FOUND.equals(rollout.IPM_Brand__c)){
                holdRolloutidBrandMap.get(rollout.id).add(system.label.IPM_Brand_Not_Found);
            }
			if(holdRolloutidBrandMap.get(rollout.id).isEmpty())
	        {
	        	holdRolloutidBrandMap.get(rollout.id).add(system.label.IPM_Brand_Not_Found);
	        } 
        }
        //enable edit access on brand when current project is reginal rollout and phase is feasibility/capability
        if( (IPM_ConstantUtils.PHASE_FEASIBILITY.Equals(project.IPM_Phase__c) || IPM_ConstantUtils.PHASE_CAPABILITY.Equals(project.IPM_Phase__c)) && 
            IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
           {
                isBrandEditable = true;
           }
           brandPosList.clear(); 
           
    } 
    /**************************************************************************************************************************
    @description:save local rollout brand
    **************************************************************************************************************************/
    public void saveLocalRolloutBrand(){
        if(!rolloutToUpdateBrand.isEmpty())
        {
	    	 IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true; // for skipping trigger execution
	    	 update rolloutToUpdateBrand.values();
	    	 IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = false;
        }
        
    }
    /**************************************************************************************************************************
    @description:map local rollout id's and brand values.values are coming from vf page.
    **************************************************************************************************************************/
    public void holdLocalRolloutBrandVal(){
        try
        { 
	        IPM_Project_Rollout__c updatedRollout =new IPM_Project_Rollout__c();
	        updatedRollout.id = localRolloutIdBrand;
	        updatedRollout.IPM_Brand__c = localRolloutBrand;
	        rolloutToUpdateBrand.put(localRolloutIdBrand,updatedRollout);
        }
        catch (Exception ex) 
        { 
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,SAVE_ROLLOUT,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            errorMessage = Label.IPM_PLEASE_CONTACT_ADMINISTRATOR;
            
        }
    }   
}