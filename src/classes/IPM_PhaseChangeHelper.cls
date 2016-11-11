/****************************************************************************************************************************
@Author Cognizant
@name IPM_ProjectChangeHelper
@CreateDate 14/09/2016
@Version 1.0
@reference Project Job Queue
*/
/* This class would initially run in System mode to make sure that it can view all project associations.However internal 
    invocations for Helpers are 'With sharing'.

    This class is responsible for changing phase across various levels based on GKM Models.
*/
public class IPM_PhaseChangeHelper 
{
 
    /**************************************************************
    * @description: Process Project information. Used for Setting Phases of various Projects, which internally invoke Related DMLs.
    * @param1 currentProjectType : associated Project Type which is used for identifying various attributes.
    * @param2 incomingProjectDetail : Incoming Project in Context
    * @param3 regionalProject : Regional Project associated with local Project 
    * @param4 qContext : Queueable Context.
    */

    public static void checkRegionalImpactFromLocal(IPM_Project_Type__c currentProjectType,IPM_Project__c incomingProjectDetail,IPM_Project__c regionalProject,QueueableContext qContext)
    {
        Boolean phaseChange = false;
        // Get Regional Project Phase and validate whether GateSequence is already ahead of Current Project Sequence.If yes no need to Update.
        if(currentProjectType.IPM_CopyPhase2Regional__c && regionalProject.IPM_Phase__c != incomingProjectDetail.IPM_Phase__c  && 
            IPM_ConstantUtils.phaseSequence.get(regionalProject.IPM_Phase__c) < IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Phase__c) )
        {
            regionalProject.IPM_Temporary_Phase__c = regionalProject.IPM_Phase__c = incomingProjectDetail.IPM_Phase__c;
            phaseChange = true;
        } 
        
        // If local Project is ahead of Regional Project and Fast Forward is true, upgrade Regional Project to same Phase as local
        IPM_Project_Type__c regionalProjectType =  IPM_Utils.retrieveProjectType(regionalProject);
        
        if(regionalProjectType.IPM_Fast_Forward_Phase_Change__c && regionalProject.IPM_Phase__c != incomingProjectDetail.IPM_Phase__c && 
            IPM_ConstantUtils.phaseSequence.get(regionalProject.IPM_Phase__c) < IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Phase__c))
        {
            regionalProject.IPM_Temporary_Phase__c = regionalProject.IPM_Phase__c = incomingProjectDetail.IPM_Phase__c;
            phaseChange = true;
        } 
         
        if(phaseChange) 
        {
            regionalProject.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PHASECHANGE;
            regionalProject.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_PROCESSING;
            if(qContext!=null)
            {
                regionalProject.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
            }     
            IPM_ProjectJobHelper.processingProjectMap.put(regionalProject.Id,regionalProject);
        } 
        
    }

    /**************************************************************
    * @description: Process Project information. Used for Setting Phases of various Projects, which internally invoke Related DMLs.
    * @param1 currentProjectType : associated Project Type which is used for identifying various attributes.
    * @param2 incomingProjectDetail : Incoming Project in Context
    * @param3 regionalProject : Regional Project associated with local Project 
    * @param4 qContext : Queueable Context.
    */

    public static void checkGlobalImpactFromLocal(IPM_Project_Type__c currentProjectType,IPM_Project__c incomingProjectDetail,IPM_Project__c globalProject,QueueableContext qContext)
    {
        Boolean phaseChange = false;
        // Get Global Project Phase and validate whether GateSequence is already ahead of Current Project Sequence.If yes no need to Update.                            
        if(currentProjectType.IPM_CopyPhase2Global__c && globalProject.IPM_Phase__c != incomingProjectDetail.IPM_Phase__c && 
            IPM_ConstantUtils.phaseSequence.get(globalProject.IPM_Phase__c) < IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Phase__c)  )
        {
            globalProject.IPM_Temporary_Phase__c = globalProject.IPM_Phase__c = incomingProjectDetail.IPM_Phase__c;
            phaseChange = true;
        }
        
        // If local Project is Ahead of Global Project and Fast Forward is true, upgrade Global to same Phase
        IPM_Project_Type__c globalProjectType =  IPM_Utils.retrieveProjectType(globalProject);
        
        if(globalProjectType.IPM_Fast_Forward_Phase_Change__c && globalProject.IPM_Phase__c != incomingProjectDetail.IPM_Phase__c && 
            IPM_ConstantUtils.phaseSequence.get(globalProject.IPM_Phase__c) < IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Phase__c))
        {
            globalProject.IPM_Temporary_Phase__c = globalProject.IPM_Phase__c = incomingProjectDetail.IPM_Phase__c;
            phaseChange = true; 
        }
        
        if(phaseChange)
        {
            globalProject.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PHASECHANGE;
            globalProject.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_PROCESSING;        
            if(qContext!=null)
            {
                globalProject.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
            }
            IPM_ProjectJobHelper.processingProjectMap.put(globalProject.Id,globalProject);
        } 
    }

    /**************************************************************
    * @description: Check Phase Change Dependency of Local Projects based on Regional Project. 
    * @param1 currentProjectType : associated Project Type which is used for identifying various attributes.
    * @param2 incomingProjectDetail : Incoming Project in Context
    * @param3 localProjectMap : related Local Project Map of Regional Project
    * @param4 qContext : Queueable Context.
    */
    

    public static void checkLocalImpactFromRegional(IPM_Project_Type__c currentProjectType,IPM_Project__c incomingProjectDetail,Map<Id,IPM_Project__c> localProjectMap,QueueableContext qContext)
    {
        for(IPM_Project__c localProject : localProjectMap.values())
        {
            Boolean phaseChanged = false;
            if(currentProjectType.IPM_CreateLocalProjects__c)
            {
                // If the Phase is Blank - It means it is a newly created Project and Temporary Phase should have the latest Phase.
                if(String.isBlank(localProject.IPM_Phase__c) &&  !String.isBlank(localProject.IPM_Temporary_Phase__c))
                {
                    localProject.IPM_Phase__c = localProject.IPM_Temporary_Phase__c;
                    localProject.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION;
                    phaseChanged = true;   
                }
            }
            
            if(currentProjectType.IPM_CopyPhase2Local__c)
            {
                if(localProject.IPM_Phase__c != incomingProjectDetail.IPM_Phase__c && 
                       IPM_ConstantUtils.phaseSequence.get(localProject.IPM_Phase__c) < IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Phase__c) )
                {
                    
                    localProject.IPM_Temporary_Phase__c = incomingProjectDetail.IPM_Phase__c;
                    localProject.IPM_Phase__c = incomingProjectDetail.IPM_Phase__c;
                    localProject.IPM_Phase__c = incomingProjectDetail.IPM_Phase__c;
                    localProject.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PHASECHANGE;
                    phaseChanged = true;
                }
            }
            
            if(phaseChanged)
            {
                localProject.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_PROCESSING;
                if(qContext!=null)
                {
                    localProject.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
                }
                IPM_ProjectJobHelper.processingProjectMap.put(localProject.Id,localProject);
            }
        }
    }

     /**************************************************************
    * @description: Check Phase Change Dependency of  Global Project  based on Regional Project. 
    * @param1 currentProjectType : associated Project Type which is used for identifying various attributes.
    * @param2 incomingProjectDetail : Incoming Project in Context
    * @param3 localProjectMap : related Local Project Map of Regional Project
    * @param4 qContext : Queueable Context.
    */
    

    public static void checkGlobalImpactFromRegional(IPM_Project_Type__c currentProjectType,IPM_Project__c incomingProjectDetail,IPM_Project__c globalProject,QueueableContext qContext)
    {
        Boolean phaseChange = false;
        // Get Global Project Phase and validate whether GateSequence is already ahead of Current Project Sequence.If yes no need to Update.
        if(currentProjectType.IPM_CopyPhase2Global__c && globalProject.IPM_Phase__c != incomingProjectDetail.IPM_Phase__c &&  
            IPM_ConstantUtils.phaseSequence.get(globalProject.IPM_Phase__c) < IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Phase__c) )  
        {
            globalProject.IPM_Temporary_Phase__c = globalProject.IPM_Phase__c = incomingProjectDetail.IPM_Phase__c;
            phaseChange = true;
        }
        
        // If regional Project is Ahead of Global Project and Fast Forward is true, upgrade Global to same Phase
        IPM_Project_Type__c globalProjectType =  IPM_Utils.retrieveProjectType(globalProject);
        
        if(globalProjectType.IPM_Fast_Forward_Phase_Change__c && globalProject.IPM_Phase__c != incomingProjectDetail.IPM_Phase__c && 
            IPM_ConstantUtils.phaseSequence.get(globalProject.IPM_Phase__c) < IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Phase__c))
        {
            globalProject.IPM_Temporary_Phase__c = incomingProjectDetail.IPM_Phase__c = incomingProjectDetail.IPM_Phase__c;
        } 
        
        if(phaseChange)
        {
            globalProject.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PHASECHANGE;
            globalProject.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_PROCESSING;
            if(qContext!=null)
            {
                globalProject.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
            }
            IPM_ProjectJobHelper.processingProjectMap.put(globalProject.Id,globalProject);
        } 
    }
    

     /**************************************************************
    * @description: Check Phase Change Dependency of Regional Project  based on Global Project. 
    * @param1 currentProjectType : associated Project Type which is used for identifying various attributes.
    * @param2 incomingProjectDetail : Incoming Project in Context
    * @param3 regionalProjectMap : related Regional Project Map of Regional Project
    * @param4 qContext : Queueable Context.
    */

    public static void checkRegionalImpactFromGlobal(IPM_Project_Type__c currentProjectType,IPM_Project__c incomingProjectDetail,Map<Id,IPM_Project__c> regionalProjectMap,QueueableContext qContext)
    {
        for(IPM_Project__c tempRegionalProject : regionalProjectMap.values())
        {
            Boolean phaseChanged = false;
            if(currentProjectType.IPM_CreateRegionalProjects__c)
            {
                // If the Phase is Blank - It means it is a newly created Project and Temporary Phase should have the latest Phase.
                if(String.isBlank(tempRegionalProject.IPM_Phase__c) &&  !String.isBlank(tempRegionalProject.IPM_Temporary_Phase__c))
                {
                    tempRegionalProject.IPM_Phase__c = tempRegionalProject.IPM_Temporary_Phase__c;
                    tempRegionalProject.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION;
                    phaseChanged = true;
                }   
            }
            
            if(currentProjectType.IPM_CopyPhase2Regional__c)
            {
                // Get Global Project Phase and validate whether GateSequence is already ahead of Current Project Sequence.If yes no need to Update.
                if( tempRegionalProject.IPM_Phase__c != incomingProjectDetail.IPM_Phase__c &&
                    IPM_ConstantUtils.phaseSequence.get(tempRegionalProject.IPM_Phase__c) < IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Phase__c) )
                {
                   tempRegionalProject.IPM_Temporary_Phase__c = incomingProjectDetail.IPM_Phase__c;
                   tempRegionalProject.IPM_Phase__c = incomingProjectDetail.IPM_Phase__c;
                   tempRegionalProject.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PHASECHANGE;
                   phaseChanged = true;  
                }
            }
            
            if(phaseChanged)
            {
                tempRegionalProject.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_PROCESSING;
                if(qContext!=null)
                {
                    tempRegionalProject.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
                }
                IPM_ProjectJobHelper.processingProjectMap.put(tempRegionalProject.Id,tempRegionalProject);
            }
        }       
    }
    
     /**************************************************************
    * @description: Check Phase Change Dependency of Local Project  based on Global Project. 
    * @param1 currentProjectType : associated Project Type which is used for identifying various attributes.
    * @param2 incomingProjectDetail : Incoming Project in Context
    * @param3 localProjectMap : related local Project Map of Regional Project
    * @param4 qContext : Queueable Context.
    */

    public static void checkLocalImpactFromGlobal(IPM_Project_Type__c currentProjectType,IPM_Project__c incomingProjectDetail,Map<Id,IPM_Project__c> localProjectMap,QueueableContext qContext)
    {
        for(IPM_Project__c localProject : localProjectMap.values())
        { 
            Boolean phaseChanged = false;
            if(currentProjectType.IPM_CreateLocalProjects__c)
            {    
                 
                // If the Phase is Blank - It means it is a newly created Project and Temporary Phase should have the latest Phase.
                if(String.isBlank(localProject.IPM_Phase__c) &&  !String.isBlank(localProject.IPM_Temporary_Phase__c))
                {    
                    localProject.IPM_Phase__c = localProject.IPM_Temporary_Phase__c;
                    localProject.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION;
                    phaseChanged = true;
                }   
            }
            
            if(currentProjectType.IPM_CopyPhase2Local__c)
            {
                if( localProject.IPM_Phase__c != incomingProjectDetail.IPM_Phase__c && 
                    IPM_ConstantUtils.phaseSequence.get(localProject.IPM_Phase__c) < IPM_ConstantUtils.phaseSequence.get(incomingProjectDetail.IPM_Phase__c))
                {
                    
                    localProject.IPM_Phase__c = incomingProjectDetail.IPM_Phase__c;
                    localProject.IPM_ProjectJobType__c = IPM_ConstantUtils.JOBTYPE_PHASECHANGE;
                    phaseChanged = true;   
                }
            }
            
            if(phaseChanged)
            {   
                localProject.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_PROCESSING;
                if(qContext!=null)
                {
                    localProject.IPM_PhaseChangeQueueJobId__c = qContext.getJobId();
                }
                IPM_ProjectJobHelper.processingProjectMap.put(localProject.Id,localProject);  
            }
        }
    } 
    
     /**************************************************************
    * @description: Check Fast forward functionality where System checks if Local Projects are ahead of parent projects. If yes we fast forward the parent project
    * @param1 currentProjectType : associated Project Type which is used for identifying various attributes.
    * @param2 incomingProjectDetail : Incoming Project in Context
    * @param3 nextPhaseSet : Set of Next Phases
    * @param4 qContext : Queueable Context.
    */

    public static void checkGlobalFastForward(Id projectId,IPM_Project_Type__c currentProjectType,IPM_Project__c incomingProjectDetail,Set<String> nextPhaseSet,QueueableContext qContext)
    {
        Map<Id,IPM_Project__c> grandChildProjectMap = IPM_ProjectJobHelper.projectToGrandChildMapping.get(projectId);
        // Get current Project Sequence
        Integer maxPhaseCounter = Integer.valueOf(currentProjectType.IPM_Gate_Sequence__c);
        String maxPhase = incomingProjectDetail.IPM_Phase__c;
        for(IPM_Project__c grandChildProject : grandChildProjectMap.values())
        {
           // Validate if the child project phase is forward than current Project Phase.
           if(grandChildProject.IPM_Phase__c !=null && nextPhaseSet.contains(grandChildProject.IPM_Phase__c))
           {
               IPM_Project_Type__c grandChildCurrentProjectType =  IPM_Utils.retrieveProjectType(grandChildProject);
               
               Integer grandChildPhaseCounter = Integer.valueOf(grandChildCurrentProjectType.IPM_Gate_Sequence__c);
               if(maxPhaseCounter < grandChildPhaseCounter)
               {
                    maxPhaseCounter = grandChildPhaseCounter;
                    maxPhase = grandChildCurrentProjectType.IPM_Phase__c;     
               }
           }
        }
        // Update the Parent to the child latest Phase.
        incomingProjectDetail.IPM_Temporary_Phase__c = maxPhase;
        incomingProjectDetail.IPM_Phase__c = maxPhase;
    }
    

    /**************************************************************
    * @description: Check Fast forward functionality where System checks if Local Projects are ahead of parent projects. If yes we fast forward the parent project
    * @param1 currentProjectType : associated Project Type which is used for identifying various attributes.
    * @param2 incomingProjectDetail : Incoming Project in Context
    * @param3 nextPhaseSet : Set of Next Phases
    * @param4 qContext : Queueable Context.
    */

    public static void checkRegionalFastForward(Id projectId,IPM_Project_Type__c currentProjectType,IPM_Project__c incomingProjectDetail,Set<String> nextPhaseSet,QueueableContext qContext)
    {
        Map<Id,IPM_Project__c> childProjectMap = IPM_ProjectJobHelper.projectToChildMapping.get(projectId);
        Integer maxPhaseCounter = Integer.valueOf(currentProjectType.IPM_Gate_Sequence__c);
        String maxPhase = incomingProjectDetail.IPM_Phase__c;
        for(IPM_Project__c childProject : childProjectMap.values())
        {
           if(childProject.IPM_Phase__c !=null && nextPhaseSet.contains(childProject.IPM_Phase__c))
           {
               IPM_Project_Type__c childCurrentProjectType =  IPM_Utils.retrieveProjectType(childProject);
               
               Integer childPhaseCounter = Integer.valueOf(childCurrentProjectType.IPM_Gate_Sequence__c);
               if(maxPhaseCounter < childPhaseCounter)
               {
                    maxPhaseCounter = childPhaseCounter;
                    maxPhase = childCurrentProjectType.IPM_Phase__c;     
               }
           }
        }
        incomingProjectDetail.IPM_Temporary_Phase__c = maxPhase;
        incomingProjectDetail.IPM_Phase__c = maxPhase;
    }
}