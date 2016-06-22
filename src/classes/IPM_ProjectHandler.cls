/****************************************************************************************************************************
@Author Cognizant
@name IPM_ProjectHandler
@CreateDate 20/08/2014
@Description Trigger Handler for the IPM_Project__c SObject.
@Version 1.0
@reference Project Job Queue
*/
public with sharing class IPM_ProjectHandler implements ITrigger
{       
    public static final List<String> ProjectMembersAPINames = new List<String>{'IPM_Technical_Project_Leader__c','IPM_Project_Leader__c','IPM_Project_Gatekeeper__c',
                                                                                'IPM_Project_Gatekeeper__c','Deputy_Project_Leader__c','IPM_Finance_Lead__c'};
                                                                                
    public static Map<String, Schema.SObjectField> projectFieldDesc = IPM_Project__c.getSObjectType().getDescribe().fields.getMap();                                                                            
  	public static Boolean stopProjExecute = true;
    public static Boolean SKIP_TRANSACTION_MNG = false;
   
    // Constructor
    public IPM_ProjectHandler() 
    { 
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    
    public Set<Id> phaseChangeProjects = new Set<Id>();
    public Set<Id>changeOwnerProjects=new Set<Id>();
    public Set<id>queueSet=new Set<id>();
    private Map<Id,IPM_Project__c> rolloutTLDChangedProjList = new Map<Id,IPM_Project__c> {};
    private List<IPM_Project__c> tldChangeProjListForMilestones = new List<IPM_Project__c> {};
    
    /***********************************************************************************************************************************
    * bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore()
    {
        List<IPM_Project__c> projectAssociatedWithProjectTypesList = new List<IPM_Project__c>();
        
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            for(IPM_Project__c project : (List<IPM_Project__c>)Trigger.New)
            {
                
                // Check if Project has a  Name, if yes it came from child Projects, else Initial Creation of Global Project.       
                if(Trigger.isInsert &&  project.IPM_Project_Name__c !=null && !String.isBlank(project.IPM_Project_Name__c) && project.IPM_Company_Card__c !=null && project.IPM_ProjectSubType__c !=null && !String.isBlank(project.IPM_ProjectSubType__c) )
                {
                    projectAssociatedWithProjectTypesList.add(project); 
                }
                //Process BET flow
                if(Trigger.isUpdate){
                    //Set default BET value
                    if(String.isBlank(project.IPM_BET_Toolkit__c) && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL){
                        project.IPM_BET_Toolkit__c = IPM_ConstantUtils.CREATE_NEW_BET ;
                    }
                    //Set BET MIlestone Dates as Project Target launch Dates
                    if((project.IPM_BET_Toolkit__c == IPM_ConstantUtils.CREATE_NEW_BET || project.IPM_BET_Toolkit__c == IPM_ConstantUtils.LINK_EXISTING_BET ) && project.IPM_Target_Launch_Dates__c!=null && ((project.BET_TLD_First_Release_Date__c==null || project.BET_TLD_Final_Release_Date__c==null) || project.IPM_Target_Launch_Dates__c!= ((IPM_Project__c) trigger.oldMap.get(project.id)).IPM_Target_Launch_Dates__c)){
                        project.BET_TLD_First_Release_Date__c = BET_BETService.getFirstReleaseDueDate(project.IPM_Target_Launch_Dates__c);
                        project.BET_TLD_Final_Release_Date__c = BET_BETService.getFirstReleaseDueDate(project.IPM_Target_Launch_Dates__c);
                    }
                    //Reset BET Milestones when BET option is selected as No BET
                    if(project.IPM_BET_Toolkit__c == IPM_ConstantUtils.NO_BET && ((IPM_Project__c) trigger.oldmap.get(project.id)).IPM_BET_Toolkit__c != IPM_ConstantUtils.NO_BET){
                        project.BET_TLD_First_Release_Date__c = null;
                        project.BET_TLD_Final_Release_Date__c = null;
                    }
                
                    // Set BET cureent Status on Project Object
                    if( project.BET__c != null && project.BET__c != ((IPM_Project__c) trigger.oldmap.get(project.id)).BET__c)
                    {
                        BET_BETWrapper bwrap = new BET_BETWrapper();
                        bwrap = (BET_BETWrapper)BET_BETService.getBet(project.BET__c);
                        
                        if(bwrap!=null)
                        {
                            project.BETCurrentStatus__c = bwrap.status;
                        }
                    }
                     //Save Last BET detail
                    if(((IPM_Project__c) trigger.oldmap.get(project.id)).BET__c!=null && project.BET__c != ((IPM_Project__c) trigger.oldmap.get(project.id)).BET__c){
                        project.Bulk_BET_Member_Request__c = false;
                        BET_BETWrapper bwrap = new BET_BETWrapper();
                        bwrap = (BET_BETWrapper)BET_BETService.getBet(((IPM_Project__c) trigger.oldmap.get(project.id)).BET__c);
                        if(bwrap!=null){
                            project.BET_Last_BET__c = bwrap.betName;
                        }
                    }
                    //Send Rollout member access request for associated BET if it is already past First Release status
                    if(project.BET__c!= null && (project.BET__c != ((IPM_Project__c) trigger.oldmap.get(project.id)).BET__c)){
                        BET_BETWrapper bwrap = new BET_BETWrapper();
                        bwrap = (BET_BETWrapper)BET_BETService.getBet(project.BET__c);
                        if(bwrap.status == IPM_ConstantUtils.BET_FIRST_RELEASE || bwrap.status == IPM_ConstantUtils.BET_FINAL_RELEASE){
                            IPM_BETHelper.sendBETAccessRequestonFirstRelease(project.BET__c);   
                        }
                    }
                }
            }
        } 
        
        // Check required Attributes for the project.
        if(!projectAssociatedWithProjectTypesList.isEmpty())
        {
            List<IPM_Project_Metadata__mdt> projectMetadataList = IPM_Utils.getProjectTypeMetadata(projectAssociatedWithProjectTypesList);
            List<String> mandatoryFieldArray = new List<String>();
            
            for(Integer counter=0;counter < projectAssociatedWithProjectTypesList.size();counter++)
            {
                IPM_Project_Metadata__mdt projectMetadata = projectMetadataList.get(counter);
                IPM_Project__c project = projectAssociatedWithProjectTypesList.get(counter);   
                if(project.IPM_IsSaved__c){
                    Set<String> projectmandatoryFieldErrorSet = new Set<String>();
                    if(projectMetadata!=null && projectMetadata.IPM_ProjectType__c !=null && !String.isBlank(projectMetadata.IPM_ProjectType__c))
                    {
                        if(projectMetadata.IPM_MandatoryFields__c !=null && !String.isBlank(projectMetadata.IPM_MandatoryFields__c))
                        {
                            mandatoryFieldArray = projectMetadata.IPM_MandatoryFields__c.split(IPM_ConstantUtils.COMMA);
                            for(String fieldAPI : mandatoryFieldArray)
                            {
                                if(project.get(fieldAPI) == null && projectFieldDesc.containsKey(fieldAPI))
                                {
                                    String fieldLabel = projectFieldDesc.get(fieldAPI).getDescribe().getLabel();
                                    projectmandatoryFieldErrorSet.add(fieldLabel);
                                }   
                            }
                            
                            if(!projectmandatoryFieldErrorSet.isEmpty())
                            {
                                 project.addError(String.format(Label.IPM_MandatoryFieldMissing,new List<String>(projectmandatoryFieldErrorSet) ) );
                            }           
                        }
                    }
                    else
                    {
                        project.addError(Label.IPM_ProjecTypeMissing);
                    }
               }
            }
        }
        
    }
    
    /***********************************************************************************************************************************
    * bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter()
    { 
       /* Actual Project specific process starts */
       if( Trigger.isInsert || Trigger.isUpdate)
       {
          Set<Id> lstDeleteProjectId = new Set<Id>(); 
          for(IPM_Project__c project : (List<IPM_Project__c>)Trigger.New)
          {
             if(project.Created_in_error__c) 
             { 
                lstDeleteProjectId.add(project.Id);
             } 
            //Send BET Link Request for requested BET link on phase change from Ideas to Feasibility
            if(Trigger.isUpdate && project.BET_Link_Requested__c!=null && !IPM_ConstantUtils.PHASE_IDEAS.equals(project.IPM_Phase__c) && IPM_ConstantUtils.PHASE_IDEAS.equals(((IPM_Project__c) trigger.oldmap.get(project.id)).IPM_Phase__c)){
                BET_LinkingService.follow(project.id,project.BET_Link_Requested__c,new list<id> {project.IPM_Project_Leader__c,project.Deputy_Project_Leader__c});      
            }
          }
          
          IPM_ProjectHelper.deleteProject(lstDeleteProjectId); 
           
           // Contains Master Project Map
           Map<Id,IPM_Project__c> masterProjectMap = new Map<Id,IPM_Project__c>();
           
           //Phase Change Project Map 
           Map<Id,IPM_Project__c> phaseChangeProjectMap = new Map<Id,IPM_Project__c>();
                
           // Stores information for updating Project document,Document Section,Section content and Questionnaire
           Map<Id,IPM_Project__c> complexityChangeProjectMap = new Map<Id,IPM_Project__c>();
           
           // Stores information for updating current document Status
           Map<Id,IPM_Project__c> updateProjectDocumentStatusMap = new Map<Id,IPM_Project__c>();
           
           // Stores information for Milestone Updates . 
           Map<Id,IPM_Project__c> processMilestonesMap = new Map<Id,IPM_Project__c>();
           
           // Stores information for Tasks Updates .
           Map<Id,IPM_Project__c> processTasksMap = new Map<Id,IPM_Project__c>();
           
           // Stores information for Notification Updates .
           Map<Id,IPM_Project__c> notificationEligibleProjects = new Map<Id,IPM_Project__c>();
           
           // Stores information for financial Updates.
           Map<String,IPM_Project__c> financialYearUpdates = new Map<String,IPM_Project__c>();
           
           //Stores tha updated fast track projects for chatter
           List<IPM_Project__c> fastTrackProjects = new List<IPM_Project__c>();
           
           // Stores information for Chatter Updates.
           Map<Id,IPM_Project__c> chatterFollowProjects = new Map<Id,IPM_Project__c>();
           
           //Stores tha updated TLD projects for chatter
           List<IPM_Project__c> tldChangeProjects = new List<IPM_Project__c>();
           
           // Stores information for Country Feedback Updates.
           Map<Id,IPM_Project__c> countryFeedbackProjects = new Map<Id,IPM_Project__c>();
           
           //EcoDesign
           List<IPM_Project__c> projectsWithPhaseChanged = new List<IPM_Project__c>();
           List<IPM_Project__c> projectsWithChangedExistsAtLeastOneAssmntFlag = new List<IPM_Project__c>();
           
           Set<String> setProjectIds = new Set<String>();
           Set<String> setSustainabilityPeriod = new Set<String>();
           Boolean updateTaskAssignee = false ; 
           
           List<IPM_Project__c> newlyNamedProjectList = new List<IPM_Project__c>();
           
          
           // Initiate the Gate Document Master Copy.
           for(IPM_Project__c incomingProject :(List<IPM_Project__c>)Trigger.New)
           {
                IPM_Project__c oldProject = null;
                
                if(!IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED)
                {
                    if(incomingProject.IPM_Project_Job_Status__c == IPM_ConstantUtils.JOB_STATUS_ELIGIBLE && incomingProject.IPM_Temporary_Phase__c !=null 
                    && incomingProject.IPM_Project_Name__c != null && incomingProject.IPM_Project_Name__c != IPM_ConstantUtils.MASTER_PROJECT_NAME)
                    {   
                        phaseChangeProjects.add(incomingProject.Id);
                    }   
                }
               
                
                if(Trigger.isUpdate)
                {
                    
                    oldProject = ( (Map<Id,IPM_Project__c>)Trigger.OldMap).get(incomingProject.Id);
                    
                    //Notify the project is created
                    if(oldProject.IPM_Project_Name__c == null && String.IsBlank(oldProject.IPM_Project_Name__c) && incomingProject.IPM_Project_Name__c != null && String.IsNotBlank(incomingProject.IPM_Project_Name__c) )
                    {
                         newlyNamedProjectList.add(incomingProject);
                    }   
                    
                    if(oldProject.IPM_Fast_Track_Project__c != incomingProject.IPM_Fast_Track_Project__c)
                    {
                        fastTrackProjects.add(incomingProject);
                    }
                    if((oldProject.IPM_Target_Launch_Dates__c != incomingProject.IPM_Target_Launch_Dates__c) || (oldProject.Rollout_Plan_Target_Launch_Date__c!= incomingProject.Rollout_Plan_Target_Launch_Date__c))
                    {
                        tldChangeProjects.add(incomingProject);
                    }
                    //@@Sharing
                    if(!IPM_ProjectShareJobQueue.PROJECT_QUEUE_CONTEXT_STARTED)
                    {
                        if(incomingProject.Deputy_Project_Leader__c!=null && oldProject.Deputy_Project_Leader__c != incomingProject.Deputy_Project_Leader__c){
                            changeOwnerProjects.add(incomingProject.Id);
                        }
                        if(incomingProject.IPM_Project_Leader__c!=null && oldProject.IPM_Project_Leader__c != incomingProject.IPM_Project_Leader__c){
                            changeOwnerProjects.add(incomingProject.Id);
                        }
                        if(incomingProject.IPM_Technical_Project_Leader__c!=null && oldProject.IPM_Technical_Project_Leader__c != incomingProject.IPM_Technical_Project_Leader__c){
                            changeOwnerProjects.add(incomingProject.Id);
                        }
                        if(incomingProject.IPM_Project_Gatekeeper__c!=null && oldProject.IPM_Project_Gatekeeper__c != incomingProject.IPM_Project_Gatekeeper__c){
                            changeOwnerProjects.add(incomingProject.Id);
                        }
                        
                            
                    }
        
                    // Process Batch Processing for transaction Management starts
                    if(incomingProject.IPM_Phase__c != oldProject.IPM_Phase__c && !String.isBlank(incomingProject.IPM_Phase__c))
                    {
                        projectsWithPhaseChanged.add(incomingProject);
                    
                        if(incomingProject.IPM_Project_Job_Status__c == IPM_ConstantUtils.JOB_STATUS_PROCESSING)
                        {
                            if(IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED)
                            {  
                                masterProjectMap.put(incomingProject.Id,incomingProject);
                                
                                // Phase Change Project Map 
                                phaseChangeProjectMap.put(incomingProject.Id,incomingProject);
                                
                                // Processing for Updating Project document Status on Phase Change.
                                updateProjectDocumentStatusMap.put(incomingProject.Id,incomingProject);
                                
                                // Processing For creating new Project Documents.
                                complexityChangeProjectMap.put(incomingProject.Id,incomingProject); 
                                
                                processTasksMap.put(incomingProject.Id,incomingProject);
                                
                                processMilestonesMap.put(incomingProject.Id,incomingProject);
                                
                                // Follow Unfollow People
                                for(String projectMember : ProjectMembersAPINames)
                                {
                                    if(incomingProject.get(projectMember) !=null)
                                    {
                                        chatterFollowProjects.put(incomingProject.Id,incomingProject);
                                        break;
                                    }
                                }
            
                                if(incomingProject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && 
                                incomingProject.IPM_Phase__c == IPM_ConstantUtils.MARKET_READY_GATE)
                                {
                                    countryFeedbackProjects.put(incomingProject.Id,incomingProject);
                                }                        
                                
                            }
                        }
                    }
                    // Process Batch Processing for transaction Management ends
                        
                    if(String.isNotBlank(incomingProject.IPM_Phase__c) &&  incomingProject.IPM_Current_Document_Status__c != oldProject.IPM_Current_Document_Status__c ||
                           incomingProject.IPM_Document_Update_Date__c != oldProject.IPM_Document_Update_Date__c ||
                           incomingProject.IPM_Document_Update_Comments__c != oldProject.IPM_Document_Update_Comments__c )
                    {
                        if( incomingProject.IPM_Current_Document_Status__c != IPM_ConstantUtils.STATUS_APPROVED || 
                                (IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED && incomingProject.IPM_Current_Document_Status__c == IPM_ConstantUtils.STATUS_APPROVED ) )
                        {   
                            masterProjectMap.put(incomingProject.Id,incomingProject);
                            // Processing for Updating Project document Status on Phase Change. 
                            updateProjectDocumentStatusMap.put(incomingProject.Id,incomingProject);
                        }
                    }
                    
                    if( (incomingProject.Sustainability_Period__c != oldProject.Sustainability_Period__c) )
                    {
                        String projectId = incomingProject.Id;
                        if(projectId.length() > 15)
                        {
                            projectId = projectId.subString(0,15);
                        }
                        financialYearUpdates.put(projectId,incomingProject); 
                    }
                        
                    for(String projectMember : ProjectMembersAPINames) 
                    {
                        if(incomingProject.get(projectMember) !=null && oldProject.get(projectMember) != incomingProject.get(projectMember))
                        {
                            chatterFollowProjects.put(incomingProject.Id,incomingProject);
                            break;
                        }
                    }
                      
                    if(String.isNotBlank(incomingProject.IPM_Phase__c) && incomingProject.IPM_Complexity__c != null && (incomingProject.IPM_Complexity__c != oldProject.IPM_Complexity__c ) )
                    {
                        masterProjectMap.put(incomingProject.Id,incomingProject);
                        
                        complexityChangeProjectMap.put(incomingProject.Id,incomingProject);
                        
                        processTasksMap.put(incomingProject.Id,incomingProject);
                    }
                        
                    
                         
                    if(String.isNotBlank(incomingProject.IPM_Phase__c) &&  incomingProject.IPM_Project_Leader__c != null  && (incomingProject.IPM_Project_Leader__c != oldProject.IPM_Project_Leader__c ) )
                    {   
                        updateTaskAssignee =  true;
                        masterProjectMap.put(incomingProject.Id,incomingProject);
                        processTasksMap.put(incomingProject.Id,incomingProject);
                    } 
                    
                    //Ecodesign Code
                    //code to check if the Functional Input RTF is filled in in section 5.3 and if all EI countries have assessments and then make the section 5.3 filled in 
                    if(incomingProject.IPM_Exists_AtLeast_OneAssmntPerEICountry__c != oldProject.IPM_Exists_AtLeast_OneAssmntPerEICountry__c){
                        projectsWithChangedExistsAtLeastOneAssmntFlag.add(incomingProject);
                        
                    } 
                }
                if(!projectsWithChangedExistsAtLeastOneAssmntFlag.isEmpty()){
                    IPM_ProjectCountryDetails.setEISectionStatus(projectsWithChangedExistsAtLeastOneAssmntFlag);
                }               
           }
           
           
           /* Actual transactional management Project specific process starts */
           if(!masterProjectMap.isEmpty())
           {
                // Reset any Existing Cache if Present. 
                IPM_ProjectHelper.resetMasterData(); 
                
                // Prepare latest Project information based on Master Map  Passed.
                IPM_ProjectHelper.initializeProjectDetail(masterProjectMap); 
                
                // Prepare Administrative Project Master Data 
                IPM_ProjectHelper.initializeProjectMaster();
                
                if(!phaseChangeProjectMap.isEmpty())
                {
                    // Prepare Country and Rollout data  based on Certain conditions
                    IPM_ProjectHelper.intializeProjectCountryNRollouts();
                }
                
                if(!updateProjectDocumentStatusMap.isEmpty() || !complexityChangeProjectMap.isEmpty())
                {
                    
                    // Prepare Project Related Document,Sections.Section content,Questionnaire data based on Certain conditions
                    IPM_ProjectHelper.initializeProjectRelatedData();
                }
                
                // Prepare Project related Tasks for Updates
                if(processTasksMap !=null && !processTasksMap.isEmpty() )
                {
                    IPM_ProjectHelper.initializeTasks();
                }
                 
                // Prepare Project related milestones for Updates 
                if(processMilestonesMap!=null && !processMilestonesMap.isEmpty() )
                {
                    IPM_ProjectHelper.initializeMilestones();
                }
                              
                // Step 1 : Update Project Document Status for previous Phase Document
                if(updateProjectDocumentStatusMap!=null && !updateProjectDocumentStatusMap.isEmpty())
                {
                    IPM_ProjectDocumentHelper.updateProjectDocumentStatus(updateProjectDocumentStatusMap);     
                }
                
                // Step 2 : Update References to Country and Rollouts based on incoming Project.
                if(phaseChangeProjectMap!=null && !phaseChangeProjectMap.isEmpty() )
                {
                    IPM_ProjectHelper.manageProjectCountryNRolloutReferences(phaseChangeProjectMap,(Map<Id,IPM_Project__c>)Trigger.OldMap);  
                    
                    // Step 3: Get Updated Country References.
                    IPM_ProjectHelper.refreshProjectRolloutCountryMapping(phaseChangeProjectMap,(Map<Id,IPM_Project__c>)Trigger.OldMap);    

                    // Step 4 : Update financials based on incoming Project
                    IPM_ProjectHelper.manageProjectFinancials(phaseChangeProjectMap,(Map<Id,IPM_Project__c>)Trigger.OldMap);
                }
                
                // Step 5 : Create Gate Documents and Sections for incoming Project 
                if(!complexityChangeProjectMap.isEmpty() )
                {    
                    IPM_ProjectHelper.manageProjectDocuments(complexityChangeProjectMap); 
                }
                            
               // Step 6 : Process Milestones for incoming Project. Processing before task as Task Due date is calculated based on Milestone Due date 
               if(processMilestonesMap!=null && !processMilestonesMap.isEmpty() )
               {
                   IPM_MilestoneHelper.manageMilestones(processMilestonesMap);   
               }
                
               // Step 7 : Process Tasks for incoming Project.
               if(processTasksMap!=null && !processTasksMap.isEmpty() )
               {    
                    if(!updateTaskAssignee)
                    {
                        IPM_TaskHelper.manageTasks(IPM_ProjectHelper.projectDocumentToSecMap,IPM_ProjectHelper.projectToDocumentMap,processTasksMap);
                    }  
                    else
                    {   
                        IPM_TaskHelper.assignUserToTask(processTasksMap.keySet());
                        updateTaskAssignee = false;
                    } 
               }
           }
           
           /* Actual transactional management Project specific process ends */
           
           if(!financialYearUpdates.isEmpty())
           { 
               IPM_ProjectHelper.updateSustainabilityPeriod(financialYearUpdates); 
           }
           
           if(!chatterFollowProjects.isEmpty())
           {
                IPM_ChatterFeedHelper.manageChatterFollowMembers((Map<Id,IPM_Project__c>)trigger.NewMap, (Map<Id,IPM_Project__c>)trigger.OldMap);
           }
           
           //copy over assessments from one phase to another based on values in custom setting IPM_Project_Type__c
           if(projectsWithPhaseChanged != null && !projectsWithPhaseChanged.isEmpty()){
                
                IPM_AssesmentHandler_Helper.copyOverAssessments(projectsWithPhaseChanged,(Map<Id, IPM_Project__c>)Trigger.oldMap);
           }
           //Chatter project is fast track
           if(fastTrackProjects != null && !fastTrackProjects.isEmpty())
           {
                IPM_ChatterFeedHelper.notifyProjectIsFasttrack(fastTrackProjects); 
           }
       
           //Chatter if TLD is changed
            if(tldChangeProjects != null && !tldChangeProjects.isEmpty())
           {      
                IPM_ChatterFeedHelper.postChatterIfLocalRegionalTLDMisaligned(tldChangeProjects);
                tldChangeProjects = new List<IPM_Project__c>();
           }
           
               if(!newlyNamedProjectList.isEmpty())
               {
                    IPM_ChatterFeedHelper.notifyProjectCreated((List<IPM_Project__c>)Trigger.New);
               }
                 
            
       } 
            
       
       List<IPM_Project__c> projectList=new List<IPM_Project__c>(); //List of Projects
       //IPM_ProjectShare handler=new IPM_ProjectShare(); //Initializing Project Share Class
       IPM_ProjectTriggerHandler PThandler = new IPM_ProjectTriggerHandler();//For Chatter and Processing Financial Records
           
       //When Projects Created
       if(trigger.isInsert)
       {
            Map<Id,Id>regionalRolloutProjectMap=new Map<Id,Id>();//Map of regional rollout project id's and finance user id's
            List<IPM_Project__c> newProjectNotifyList = new List<IPM_Project__c>();
            //Extracting Global and Regional Projects 
            for(IPM_Project__c proj:(List<IPM_Project__c>)trigger.new)
            {
                if(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equals(proj.IPM_Project_Type__c) && proj.IPM_Project_Name__c != null && String.IsNotBlank(proj.IPM_Project_Name__c))
                { 
                    newProjectNotifyList.add(proj);
                }
            
                if((proj.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL || proj.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL) && proj.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT 
                        && proj.IPM_Finance_Lead__c!=null && proj.IPM_Finance_Lead__c!=proj.IPM_Project_Leader__c){
                        regionalRolloutProjectMap.put(proj.Id, proj.IPM_Finance_Lead__c);
                }
            }
            
            //Notify when rollout project is created
            if(!newProjectNotifyList.isEmpty())
            {
                IPM_ChatterFeedHelper.notifyProjectCreated(newProjectNotifyList);
            }
            
            //For create finance user for regional rollout project
            if(regionalRolloutProjectMap != NULL && !regionalRolloutProjectMap.isEmpty()){
                IPM_Resource_Allocation.createfinanceMember(regionalRolloutProjectMap);
            }
            //@@ Data Sharing
            PThandler.onAfterInsert((List<IPM_Project__c>)trigger.new);
            
            //BET related changes
            //For Regional & Local Rollouts that has a BET associated - PL/DPL should be given BET access
            set<id> setRollouts = new set<id>();
            map<id, set<id>> mapProjUserIds = new map<id, set<id>>();
            map<id,id> mapProjBET = new map<id,id>();
            for(IPM_Project__c proj :(List<IPM_Project__c>)Trigger.new){
                if(proj.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT && (proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL || proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)){
                    if(proj.IPM_Parent_Project__c!=null){
                        setRollouts.add(proj.IPM_Parent_Project__c);
                    }
                    if(proj.IPM_Global_Project_Id__c!=null){
                        setRollouts.add(proj.IPM_Global_Project_Id__c); 
                    }
                }
            }
            if(!setRollouts.isEmpty())
            { 
                for(IPM_Project__c ipmProj :[select name ,IPM_Project_Leader__c,Deputy_Project_Leader__c, IPM_Parent_Project__c, IPM_Parent_Project__r.bet__c, IPM_Parent_Project__r.IPM_Parent_Project__r.bet__c,IPM_Parent_Project__r.IPM_Parent_Project__r.name from IPM_Project__c where (IPM_Project_Type__c = :IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT AND IPMProject_Span__c = :IPM_ConstantUtils.PROJECT_SPAN_REGIONAL AND IPM_Parent_Project__c in :setRollouts AND IPM_Parent_Project__r.bet__c!=null) OR (IPM_Project_Type__c = :IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT AND IPMProject_Span__c = :IPM_ConstantUtils.PROJECT_SPAN_LOCAL  AND IPM_Parent_Project__r.IPM_Parent_Project__c in :setRollouts AND IPM_Parent_Project__r.IPM_Parent_Project__r.bet__c!=null) limit 50000])
                {
                    if(string.isNotBlank(ipmProj.IPM_Parent_Project__c) && string.isNotBlank(ipmProj.IPM_Parent_Project__r.bet__c))
                    {
                        if(!mapProjUserIds.containsKey(ipmProj.IPM_Parent_Project__c))
                        {
                            set<id> PLs = new set<id>();
                            PLs.add(ipmProj.IPM_Project_Leader__c);
                            PLs.add(ipmProj.Deputy_Project_Leader__c);
                            mapProjUserIds.put(ipmProj.IPM_Parent_Project__c, PLs);
                            mapProjBET.put(ipmProj.IPM_Parent_Project__c,ipmProj.IPM_Parent_Project__r.bet__c); 
                        }   
                        else
                        {
                            mapProjUserIds.get(ipmProj.IPM_Parent_Project__c).add(ipmProj.IPM_Project_Leader__c);
                            mapProjUserIds.get(ipmProj.IPM_Parent_Project__c).add(ipmProj.Deputy_Project_Leader__c); 
                        } 
                    }
                    else if(string.isNotBlank(ipmProj.IPM_Parent_Project__r.IPM_Parent_Project__c) && string.isNotBlank(ipmProj.IPM_Parent_Project__r.IPM_Parent_Project__r.bet__c))
                    {        
                        if(!mapProjUserIds.containsKey(ipmProj.IPM_Parent_Project__r.IPM_Parent_Project__c))
                        {
                            set<id> PLs = new set<id>();
                            PLs.add(ipmProj.IPM_Project_Leader__c);
                            PLs.add(ipmProj.Deputy_Project_Leader__c);
                            mapProjUserIds.put(ipmProj.IPM_Parent_Project__r.IPM_Parent_Project__c, PLs);
                            mapProjBET.put(ipmProj.IPM_Parent_Project__r.IPM_Parent_Project__c,ipmProj.IPM_Parent_Project__r.IPM_Parent_Project__r.bet__c);                         
                        }   
                        else
                        {
                            mapProjUserIds.get(ipmProj.IPM_Parent_Project__r.IPM_Parent_Project__c).add(ipmProj.IPM_Project_Leader__c);
                            mapProjUserIds.get(ipmProj.IPM_Parent_Project__r.IPM_Parent_Project__c).add(ipmProj.Deputy_Project_Leader__c); 
                        }   
                    }
                }
                //Send BET Access for BETs post First Release
                if(!mapProjUserIds.isEmpty())
                {
                    for(id pid :mapProjUserIds.keySet())
                    { 
                        if(((BET_BETWrapper)BET_BETService.getBet(mapProjBET.get(pid))).status == IPM_ConstantUtils.BET_FIRST_RELEASE ||  ((BET_BETWrapper) BET_BETService.getBet(mapProjBET.get(pid))).status == IPM_ConstantUtils.BET_FINAL_RELEASE)
                        {
                            list<id> lstIds = new list<id>();
                            lstIds.addAll(mapProjUserIds.get(pid));
                            IPM_BETHelper.sendBETAccessRequest(lstIds, mapProjBET.get(pid), pid); 
                        }   
                    }
                }
            }
            
       }
        
        //When Projects Updated
       if(trigger.isUpdate)
       {
            //For Creating Project Document Sections
            Map<Id,Id>localRolloutProjectMap=new Map<Id,Id>();//Map of local rollout project id's and finance user id's
            Map<Id,Id>deleteLocalRolloutProjectMap=new Map<Id,Id>();//Map of local rollout project id's and finance user id's
            Map<Id,String>updateNewProNameMap=new Map<Id,String>();//Map of Project id to Project Name
            Map<Id,String>oldprojectnameMap=new Map<Id,String>();//Map project id with old project name
            List<IPM_Project__c> changedNameProjectList = new List<IPM_Project__c>();
            //IPM BET related changes
            set<id> setBETProjects = new set<id>(); //Set of IPM Project Id's for which all BET Milestones should be deleted
            list<IPM_Milestone__c> lstBETMilestones = new list<IPM_Milestone__c>(); //List of BET related IPM Milestones which should be upserted.
            map<string, ipm_project__c> mapProjBETupdate = new map<string, ipm_project__c>();
            
            Map<Id, IPM_Project__c> ipmFastTrackProjectMap = new Map<Id, IPM_Project__c>(); // Fast Track Marked project Map 
            Map<Id, String> stoppedProjectMap = new Map<Id, String>(); // Fast Track Marked project Map 
            
			
            for(IPM_Project__c p:(List<IPM_Project__c>)Trigger.New)
            {
                    IPM_Project__c proj=(IPM_Project__c)Trigger.oldMap.get(p.Id);
                   
                   if(p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && p.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && 
                        p.IPM_Fast_Track_Project__c != proj.IPM_Fast_Track_Project__c){
                        ipmFastTrackProjectMap.put(p.Id, p);    
                   }
                   
                   
                   if(p.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL && p.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT 
                       && p.IPM_Finance_Lead__c!=null && p.IPM_Finance_Lead__c!=p.IPM_Project_Leader__c && p.IPM_Finance_Lead__c!=proj.IPM_Finance_Lead__c)
                   {
                       localRolloutProjectMap.put(p.Id, p.IPM_Finance_Lead__c);
                       if(proj.IPM_Finance_Lead__c!=null)
                       {
                           deleteLocalRolloutProjectMap.put(proj.Id, proj.IPM_Finance_Lead__c);
                       }
                    }
                    
                    if(p.IPM_Project_Name__c!=null && Proj.IPM_Project_Name__c!=null && !String.isBlank(p.IPM_Project_Name__c) && !String.isBlank(Proj.IPM_Project_Name__c)  && 
                        p.IPM_Project_Name__c!= Proj.IPM_Project_Name__c && String.isNotBlank(p.IPM_Phase__c) && !p.IPM_Phase__c.equals(IPM_ConstantUtils.PHASE_PLE))
                    {
                        updateNewProNameMap.put(p.id,p.IPM_Project_Name__c);
                        oldprojectnameMap.put(p.id,Proj.IPM_Project_Name__c);
                        changedNameProjectList.add(p);
                    }
                    //BET related changes
                    // Set of IPM Project Id's for which list of BET Milestones should be deleted.
                    if(string.isNotBlank(proj.IPM_BET_Toolkit__c) && p.IPM_BET_Toolkit__c.equalsIgnoreCase(Label.IPM_BET_NoBET) && !proj.IPM_BET_Toolkit__c.equalsIgnoreCase(Label.IPM_BET_NoBET)) {
                        setBETProjects.add(p.id);   
                    }
                    // List of BET Milestones to be upserted
                    if(p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && (string.isBlank(proj.IPM_BET_Toolkit__c) || (string.isNotBlank(proj.IPM_BET_Toolkit__c) && !proj.IPM_BET_Toolkit__c.equalsIgnoreCase(Label.IPM_CreateNewBET) && !proj.IPM_BET_Toolkit__c.equalsIgnoreCase(Label.IPM_BET_Link_Existing))) && string.isBlank(p.BET__c) && (p.IPM_BET_Toolkit__c.equalsIgnoreCase(Label.IPM_CreateNewBET) || p.IPM_BET_Toolkit__c.equalsIgnoreCase(Label.IPM_BET_Link_Existing))){
                        lstBETMilestones.add(new IPM_Milestone__c(Name = IPM_ConstantUtils.BET_MS_FIRST_RELEASE, IPM_Name__c = IPM_ConstantUtils.BET_MS_FIRST_RELEASE , IPM_Project__c = p.id, IPM_Type_of_Milestone__c = IPM_ConstantUtils.STRING_BET, RecordTypeId =  Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.milePMRecordType).getRecordTypeId(), IPM_Due_Date__c = BET_BETService.getFirstReleaseDueDate(p.IPM_Target_Launch_Dates__c) , ExternalField__c=p.id+IPM_ConstantUtils.BET_MS_FIRST_RELEASE, IPM_Active__c = true));
                        lstBETMilestones.add(new IPM_Milestone__c(Name = IPM_ConstantUtils.BET_MS_FINAL_RELEASE , IPM_Name__c = IPM_ConstantUtils.BET_MS_FINAL_RELEASE , IPM_Project__c = p.id, IPM_Type_of_Milestone__c = IPM_ConstantUtils.STRING_BET, RecordTypeId =  Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.milePMRecordType).getRecordTypeId(), IPM_Due_Date__c = BET_BETService.getFinalReleaseDueDate(p.IPM_Target_Launch_Dates__c) , ExternalField__c=p.id+IPM_ConstantUtils.BET_MS_FINAL_RELEASE, IPM_Active__c = true));
                    }
                    //BET Milestone Due Dates to be updated
                    if((p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && string.isNotBlank(p.BET__c) && proj.BET__c!= p.BET__c) || (p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && String.isBlank(p.BET__c) && (proj.IPM_Target_Launch_Dates__c !=p.IPM_Target_Launch_Dates__c || string.isNotBlank(proj.BET__c)) && (p.IPM_BET_Toolkit__c != null && (p.IPM_BET_Toolkit__c.equalsIgnoreCase(Label.IPM_CreateNewBET) || p.IPM_BET_Toolkit__c.equalsIgnoreCase(Label.IPM_BET_Link_Existing)))) ){
                        mapProjBETupdate.put(p.id, p);  
                    }  
                    //New PL/DPL, for requesting BET access 
                    list<id> lstBETaccessIds = new list<id>();
                    if(string.isNotBlank(p.BET__c) && p.BET__c==proj.BET__c){
                        if(string.isNotBlank(p.IPM_Project_Leader__c) && proj.IPM_Project_Leader__c != p.IPM_Project_Leader__c){
                            lstBETaccessIds.add(p.IPM_Project_Leader__c);   
                        }
                        if(string.isNotBlank(p.Deputy_Project_Leader__c) && proj.Deputy_Project_Leader__c != p.Deputy_Project_Leader__c){
                            lstBETaccessIds.add(p.Deputy_Project_Leader__c);    
                        }
                    }                    
                     //Call BET access service for access request for new PL/DPL
                    if(!lstBETaccessIds.isEmpty())
                    {
                        IPM_BETHelper.sendBETAccessRequest(lstBETaccessIds, p.BET__c, p.id);
                    }  
                    
                    if(String.isNotBlank(p.IPM_Phase__c) && (p.Is_Archieved__c != proj.Is_Archieved__c ) && stopProjExecute)
                    {   
                        
                        if(p.Is_Archieved__c  )
                        {
                            stoppedProjectMap.put(p.id,p.IPM_Stopped_Comments__c);
                        }
                        else
                        {
                            stoppedProjectMap.put(p.id,IPM_ConstantUtils.BLANK);
                        }
                   }  
                    
                         
                }
               
                 // Fast Track Global Original Project 
                if(!ipmFastTrackProjectMap.isEmpty())
                {
                    IPM_ProjectHelper.processFastTrackProjects(ipmFastTrackProjectMap);
                }
                
                if(!stoppedProjectMap.isEmpty()) 
                {
                   IPM_ProjectHelper.updateStoppedProject(stoppedProjectMap);
                }
                
                      
           //call update project name in all objects records
            if(!updateNewProNameMap.IsEmpty()){
                IPM_UpdateGlobalProjectName.updateProjectName(updateNewProNameMap,oldprojectnameMap);
                IPM_ChatterFeedHelper.notifyProjectNameChange(changedNameProjectList);
            }
            //For create finance user for local rollout project resource
            if(localRolloutProjectMap != NULL && !localRolloutProjectMap.isEmpty()){
                IPM_Resource_Allocation.createfinanceMember(localRolloutProjectMap);
            }
            if(deleteLocalRolloutProjectMap != NULL && !deleteLocalRolloutProjectMap.isEmpty()){
               IPM_Resource_Allocation.deletefinanceMember(deleteLocalRolloutProjectMap);
            }            

       //BET related changes
            if(!setBETProjects.isEmpty()){
                list<IPM_Milestone__c> lstDelMS = [select id from IPM_Milestone__c where IPM_Project__c in :setBETProjects and IPM_Type_of_Milestone__c=:IPM_ConstantUtils.STRING_BET limit 50000];
                if(lstDelMS!=null && !lstDelMS.isEmpty()){
                    delete lstDelMS;    
                }
            }
            //Insert BET Milestones
            if(!lstBETMilestones.isEmpty()){
                upsert lstBETMilestones ExternalField__c;
            }
            
            // Call IPM BET Helper to update  BET Milestone dates
            if(!mapProjBETupdate.isEmpty()){
                IPM_BETHelper.updateBETmilestones(mapProjBETupdate); 
            }
            
            // Call IPM BET Helper method to send IPM updates to BET
            IPM_BETHelper.sendIPMupdatetoBET((List<IPM_Project__c>)Trigger.New, (List<IPM_Project__c>)Trigger.Old);
           // EPIC172 implementation start
           
           
            Map<ID,IPM_Project__c> updatedProjects = new Map<ID,IPM_Project__c>();
            Map<Id,IPM_Project__c> mapNewProjects = (Map<Id,IPM_Project__c>)Trigger.newMap;
            Map<Id,IPM_Project__c> mapOldProjects = (Map<Id,IPM_Project__c>)Trigger.oldMap;
            for(IPM_Project__c project: mapNewProjects.values()) {
                if ( project.IPM_Target_Launch_Dates__c != mapOldProjects.get(project.Id).IPM_Target_Launch_Dates__c ) {
                    updatedProjects.put(project.Id,project);
                }
            }
            if(!updatedProjects.isEmpty()) {
                IPM_SyncFinanceTableTLD syncFinanceTableTLD = new IPM_SyncFinanceTableTLD();
                syncFinanceTableTLD.syncProjectFinancialTLD(updatedProjects);
            }
            // EPIC172 implementation end
            
              
    }
    
   } 
   
    public void beforeInsert(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
        IPM_Project__c insertedProject = (IPM_Project__c)so; 

        // Set Data in Temporary Phase and make original Phase as Blank. Also only do that when Job Status is not processing.
        if(insertedProject.IPM_Phase__c!=null)
        {
            // Set Temporary Phase for processing for the Queue
            insertedProject.IPM_Temporary_Phase__c = insertedProject.IPM_Phase__c;
            
            // This is project with Phase change request. Mark the project as Eligible for Status change.
            insertedProject.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
            insertedProject.IPM_Phase__c = null;
            
            if(String.isBlank(insertedProject.IPM_ProjectJobType__c))
            {
                insertedProject.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION;
            }
        }

        if(insertedProject.IPM_Project_Name__c !=null && !String.isBlank(insertedProject.IPM_Project_Name__c))
        {
            insertedProject.Name = insertedProject.IPM_Project_Name__c;
            if(insertedProject.IPM_Category_Text__c != null && customSettingCategory != null && customSettingCategory.containsKey(insertedProject.IPM_Category_Text__c))
            {
                insertedProject.IPM_Category_Group__c = customSettingCategory.get(insertedProject.IPM_Category_Text__c).IPM_Category_Group__c;
            } 
            
            if(insertedProject.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
            {
            	//Setting the default answer for the charter question in case of Global Original project
            	if(insertedProject.IPMProject_Span__c == IPM_ConstantUtils.IPMGLOBAL && insertedProject.IPM_Approver_of_Charter__c == null){
	            	insertedProject.IPM_Approver_of_Charter__c  = IPM_ConstantUtils.GATEKEEPING_MODEL_GCLT;
	            }
	            
	            //Setting the default answer of contract or market ready question in case of Regional Original Project
	            if(insertedProject.IPMProject_Span__c == IPM_ConstantUtils.IPMREGIONAL && insertedProject.IPM_GateKeeping_Model__c == null){
	            	insertedProject.IPM_GateKeeping_Model__c  = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
	            }	
            }
        }
        }
        
        if(insertedProject.Exempt_from_Threshold__c !=null)
        {
            if(insertedProject.Exempt_from_Threshold__c)
            {
                insertedProject.IPM_Threshold_Value__c = IPM_ConstantUtils.YES;
            }
            else
            {
                insertedProject.IPM_Threshold_Value__c = IPM_ConstantUtils.NO;
            }
        }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {   
        //This method has been included as the class implements the ITrigger interface
        IPM_Project__c incomingProject = (IPM_Project__c)so;
        IPM_Project__c oldProject = (IPM_Project__c)oldSo;
 
        if(incomingProject.IPM_Project_Name__c !=null && !String.isBlank(incomingProject.IPM_Project_Name__c) && 
        incomingProject.IPM_Project_Name__c != oldProject.IPM_Project_Name__c)
        {
            incomingProject.Name = incomingProject.IPM_Project_Name__c;
        }
        
        //update the previous TLD value in the previous TLD field
        if(oldProject.IPM_Target_Launch_Dates__c != null && oldProject.IPM_Target_Launch_Dates__c != incomingProject.IPM_Target_Launch_Dates__c)
        {
            incomingProject.Previous_Target_Launch_Date__c = oldProject.IPM_Target_Launch_Dates__c;
        }
        
        // Get next phase for the project and based on that identify whther phase change is valid.
        if(oldProject.IPM_Phase__c != incomingProject.IPM_Phase__c &&  !IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED && incomingProject.IPM_Project_Job_Status__c != IPM_ConstantUtils.JOB_STATUS_PROCESSING)
        {
            //Create a temporary Project instance and get the Project Type based on Current incoming Data except Phase information.
            IPM_Project_Type__c currentProjectType = null;
            IPM_Project_Type__c nextPhaseProjectType = null;
            
            if(oldProject.IPM_Phase__c != null)
            {
                currentProjectType = IPM_Utils.retrieveProjectType(oldProject);   
                nextPhaseProjectType = IPM_Utils.getNextPhase(currentProjectType,false);  
            }
            
            //Only check for next Phase if existing Phase is not blank.
            if(oldProject.IPM_Phase__c == null || (nextPhaseProjectType != null && incomingProject.IPM_Phase__c == nextPhaseProjectType.IPM_Phase__c) )
            { 
                // Reset the incoming Phase with existing Phase. Phase change has to be in a single trasaction.
                incomingProject.IPM_Temporary_Phase__c = incomingProject.IPM_Phase__c;
                incomingProject.IPM_Current_Document_Status__c = oldProject.IPM_Current_Document_Status__c;
                incomingProject.IPM_Phase__c = oldProject.IPM_Phase__c;
                // This is project with Phase change request. Mark the project as Eligible for Status change.
                incomingProject.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                // If it is the First Phase
                if(oldProject.IPM_Phase__c == null)
                {
                    incomingProject.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION;
                }
                else
                {
                    incomingProject.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PHASECHANGE;
                }
            }
            else
            {
                incomingProject.addError(string.format( Label.IPM_PROJECT_PHASE_VALIDATION,new String[]{nextPhaseProjectType.IPM_Phase__c,incomingProject.IPM_Phase__c}) );
            }       
        }
        if(incomingProject.IPM_Category_Text__c !=null && customSettingCategory!=null && customSettingCategory.containsKey(incomingProject.IPM_Category_Text__c))
        {
            //To add which category group the project belongs.
            incomingProject.IPM_Category_Group__c = customSettingCategory.get(incomingProject.IPM_Category_Text__c).IPM_Category_Group__c;
        }
        
        if(incomingProject.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
        {
        	//Setting the default answer for the charter question in case of Global Original project
        	if(incomingProject.IPMProject_Span__c == IPM_ConstantUtils.IPMGLOBAL && incomingProject.IPM_Approver_of_Charter__c == null){
            	incomingProject.IPM_Approver_of_Charter__c  = IPM_ConstantUtils.GATEKEEPING_MODEL_GCLT;
            }
            
            //Setting the default answer of contract or market ready question in case of Regional Original Project
            if(incomingProject.IPMProject_Span__c == IPM_ConstantUtils.IPMREGIONAL && incomingProject.IPM_GateKeeping_Model__c == null){
            	incomingProject.IPM_GateKeeping_Model__c  = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
            }	
        }
        
        if(incomingProject.Is_Archieved__c !=null && incomingProject.Is_Archieved__c && incomingProject.Is_Archieved__c != oldProject.Is_Archieved__c)
        {
            incomingProject.IPM_Project_Stopped_By__c   = UserInfo.getName();
            incomingProject.IPM_Stopped_Date_Time__c = System.now();        
        }
        
        if(incomingProject.Exempt_from_Threshold__c !=null && incomingProject.Exempt_from_Threshold__c != oldProject.Exempt_from_Threshold__c)
        {
            if(incomingProject.Exempt_from_Threshold__c)
            {
                incomingProject.IPM_Threshold_Value__c = IPM_ConstantUtils.YES;
            }
            else
            {
                incomingProject.IPM_Threshold_Value__c = IPM_ConstantUtils.NO;  
            }
        }
        
        
        if(!oldProject.BET_Update__c && incomingProject.BET_Update__c && incomingProject.BET_Link_Requested__c != null)
        {
            incomingProject = IPM_Utils.updateProjBETApproved(incomingProject);
        } 
        
        //Identify if the fields on the project have changed and marked the project to be synced with ecodesign
        for (FieldSetMember fsm : Schema.SObjectType.IPM_Project__c.fieldSets.IPM_Project_Fields_EcoDesign.getFields()) {
            if (oldProject.get(fsm.getFieldPath()) != incomingProject.get(fsm.getFieldPath()) && oldProject.First_Sync_To_EcoDesign__c && IPM_ProjectCountryDetails.isProjectReadyToSyncToEcoDesign(incomingProject) && String.isNotBlank(incomingProject.Project_Countries__c) ) {
                  incomingProject.EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY;
                  break;
            }
        }
        
        if(oldProject.IPM_Target_Launch_Dates__c != incomingProject.IPM_Target_Launch_Dates__c)
        {
            incomingProject.MisAligned_Confirmed_By_Finance_Leader__c = false;
        }        
        
        //process incoming project status
        IPM_ProjectHelper.handleEcoDesignSyncProcess(incomingProject,oldProject);
   		if(!IPM_ProjectCountryDetails.checkAtLeastOneAssmntPerEICountryVar && oldProject.IPM_Exists_AtLeast_OneAssmntPerEICountry__c != incomingProject.IPM_Exists_AtLeast_OneAssmntPerEICountry__c){
   			incomingProject.IPM_Exists_AtLeast_OneAssmntPerEICountry__c = oldProject.IPM_Exists_AtLeast_OneAssmntPerEICountry__c;	
   		}
    }
    
    /***********************************************************************************************************************************
    * beforeDelete
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){      
        //This method has been included as the class implements the ITrigger interface 
        IPM_Project__c newProject = (IPM_Project__c) so;
        if(newProject.IPM_Golbal_Project_OwnerId__c!=null){
            queueSet.add(newProject.IPM_Golbal_Project_OwnerId__c);
        }
        IPM_GroupManagement.deleteQueue(queueSet);
    }
     
    
    public void afterInsert(SObject so)
    {
        IPM_Project__c incomingProject = (IPM_Project__c)so; 
         //Track field history of Pl into Project Resource History custom object when PL gets assigned to project. 
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {    
        //This method has been included as the class implements the ITrigger interface
        IPM_Project__c oldProject = (IPM_Project__c) oldSo;
        IPM_Project__c newProject = (IPM_Project__c) so;

        //To update Rollout TLD date on Rollout Projet Object
        if((oldProject.Rollout_Plan_Target_Launch_Date__c != null && oldProject.Rollout_Plan_Target_Launch_Date__c!= newProject.Rollout_Plan_Target_Launch_Date__c) || (oldProject.IPM_Target_Launch_Dates__c != newProject.IPM_Target_Launch_Dates__c))
        {
            rolloutTLDChangedProjList.put(newProject.IPM_Project_Rollout__c,newProject);
        }
        if(oldProject.IPM_Target_Launch_Dates__c != newProject.IPM_Target_Launch_Dates__c)
        {
            tldChangeProjListForMilestones.add(newProject);
        }
        
    }
    
    public void afterDelete(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    
    /***********************************************************************************************************************************
    * andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */    
    public void andFinally()
    {
        if( (Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter && !SKIP_TRANSACTION_MNG)
        {
            if(!phaseChangeProjects.isEmpty())
            {
                IPM_ProjectJob_Queue phaseChangeAsyncHandler = new IPM_ProjectJob_Queue(); 
                phaseChangeAsyncHandler.initializeProjectData(phaseChangeProjects); 
                Id asyncJobId = System.enqueueJob(phaseChangeAsyncHandler); 
                IPM_ProjectHelper.udpateAsyncJobId(phaseChangeProjects,asyncJobId);
                SKIP_TRANSACTION_MNG = true;
            }           
        }
        
        if(!changeOwnerProjects.isEmpty() && phaseChangeProjects.isEmpty() && Trigger.isUpdate  && Trigger.isAfter) 
        {
                IPM_ProjectShareJobQueue changeOwnerHandler = new IPM_ProjectShareJobQueue(); 
                changeOwnerHandler.initializeProjectData(changeOwnerProjects); 
                System.enqueueJob(changeOwnerHandler);      
        }
        
        
        if(!tldChangeProjListForMilestones.isEmpty()){
            IPM_RolloutPlanTLDSync rolloutPlanTLDSync = new IPM_RolloutPlanTLDSync();
            rolloutPlanTLDSync.updatedMilestoneTLD(tldChangeProjListForMilestones);     
        }
        
        if(!rolloutTLDChangedProjList.isEmpty()){
            IPM_RolloutPlanTLDSync rolloutPlanTLDSync = new IPM_RolloutPlanTLDSync();
            rolloutPlanTLDSync.syncTLDDates(rolloutTLDChangedProjList,null);
        }
        
        ExceptionLoggingHelper.insertLogRecordList();
    }
}
