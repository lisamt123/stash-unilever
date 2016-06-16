/**
@Author Cognizant
@Name IPM_ProjectRolloutHandler
@CreateDate 06/05/2015
@Description This class is used as Trigger Handler for the IPM_Project_Document_Section__c SObject.
@Version 1.0
@reference TriggerFactory class
*/
public with sharing class IPM_ProjectRolloutHandler implements ITrigger{   
        
    //@description:Constructor
    public IPM_ProjectRolloutHandler (){
        //making boolean to true to identify while insertion of exception logs
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    
    public static String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId(); 
    public static String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId(); 
    public Set<Id> phaseChangeProjects = new Set<Id>();
    public Set<Id> phaseChangeRolloutSet = new Set<Id>();
    
    private Map<Id,IPM_Project_Rollout__c> rolloutProjectTLDChanged = new Map<Id,IPM_Project_Rollout__c> {};
    private Map<Id,IPM_Project_Rollout__c> globalProjIdRollout = new Map<Id,IPM_Project_Rollout__c> {};     
    
    /**
    * @description:bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore()
    {
        IPM_RolloutTriggerHandler handler = new IPM_RolloutTriggerHandler();
        
        if(System.Trigger.isDelete)
        {           
            handler.processDelete((List<IPM_Project_Rollout__c>) Trigger.old);
            handler.deleteRegionalFinancialActionStandards((List<IPM_Project_Rollout__c>) Trigger.old);
        } 
        
        //@@Design Review - Data Sharing Change - Update ownerid of rollouts to project ownerid
        
        if(System.Trigger.isInsert){
            
            handler.OnBeforeInsert((List<IPM_Project_Rollout__c>) Trigger.new);
           handler.assignCompanyCard((List<IPM_Project_Rollout__c>) Trigger.new);
            
        }
        
        
            
               
       
    }
    /**
    * @description:bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter()
    {    
        IPM_RolloutTriggerHandler handler = new IPM_RolloutTriggerHandler();
        
        if(Trigger.isInsert)
        {
            handler.processInsert((List<IPM_Project_Rollout__c>) Trigger.new); 
            handler.createRegionalFinancialActionStandards((List<IPM_Project_Rollout__c>) Trigger.new);
        }
        
        if(Trigger.isUpdate)
        {
            handler.processUpdate((Map<Id,IPM_Project_Rollout__c>) Trigger.newMap, (Map<Id,IPM_Project_Rollout__c>) Trigger.oldMap);
            
             //Chatter to post when finance member added to a rollout
            List<IPM_Project_Rollout__c> financeMemberAddedToRolloutProj = new List<IPM_Project_Rollout__c>();
            for(IPM_Project_Rollout__c incomingRollouts :(List<IPM_Project_Rollout__c>)Trigger.New)
            {
               IPM_Project_Rollout__c oldRollouts = null;
               oldRollouts = ( (Map<Id,IPM_Project_Rollout__c>)Trigger.OldMap).get(incomingRollouts.Id);
               if(incomingRollouts.Finance_Member__c != null && incomingRollouts.Finance_Member__c != oldRollouts.Finance_Member__c)
               {
                   financeMemberAddedToRolloutProj.add(incomingRollouts);
               }
            }
            IPM_ChatterFeedHelper.notifyFinanceMemberAddedToRollout(financeMemberAddedToRolloutProj);
        }
    }
    
    /**
    * @description:beforeInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void beforeInsert(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
           
    }
    /**
    * @description:beforeUpdate
    * This method is called iteratively for each record to be update during a BEFORE
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void beforeUpdate(SObject oldSo, SObject so)
    {   
        //This method has been included as the class implements the ITrigger interface   

        IPM_Project_Rollout__c oldRollout = (IPM_Project_Rollout__c)oldSo; 
        IPM_Project_Rollout__c newRollout = (IPM_Project_Rollout__c)so;   
              
        if( oldRollout.Target_Launch_Date__c != newRollout.Target_Launch_Date__c )
        {
            newRollout.MisAligned_Confirmed_By_Finance_Leader__c = false;     
            newRollout.Previous_Target_Launch_Date__c = oldRollout.Target_Launch_Date__c;                   
        }
        
        if(!newRollout.isActive__c && oldRollout.isActive__c != newRollout.isActive__c)
        {
            newRollout.IPM_Status__c = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
            newRollout.IPM_Regional_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_FOLLOWER;                       
        }               
    }
    
    /**
    * @description:beforeDelete
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so)
    {    
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterInsert(SObject so)
    {
        IPM_Project_Rollout__c newRollout = (IPM_Project_Rollout__c)so;
        
        if(IPM_ConstantUtils.JOB_STATUS_ELIGIBLE == newRollout.IPM_Project_Job_Status__c && !IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED &&  
            IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC == newRollout.IPM_RolloutJobType__c)  
        {
            if(REGIONAL_ROLLOUT_RECORDTYPE == newRollout.RecordTypeId && newRollout.IPM_Project__c !=null)
            {   
                phaseChangeProjects.add(newRollout.IPM_Project__c);
                phaseChangeRolloutSet.add(newRollout.Id);
            }
            
            if(LOCAL_ROLLOUT_RECORDTYPE == newRollout.RecordTypeId && newRollout.Regional_Project__c !=null)
            {   
                phaseChangeProjects.add(newRollout.Regional_Project__c);
                phaseChangeRolloutSet.add(newRollout.Id);
            }
        } 
    }
    /**
    * @description:afterUpdate
    * This method is called iteratively for each record to be update during a AFTER
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void afterUpdate(SObject oldSo, SObject so)
    {    
        
        IPM_Project_Rollout__c oldRollout = (IPM_Project_Rollout__c)oldSo; 
        IPM_Project_Rollout__c newRollout = (IPM_Project_Rollout__c)so; 
        
        if( oldRollout.IPM_Project_Job_Status__c != newRollout.IPM_Project_Job_Status__c && !IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED &&  
                newRollout.IPM_Project_Job_Status__c == IPM_ConstantUtils.JOB_STATUS_ELIGIBLE && 
                newRollout.IPM_RolloutJobType__c == IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC)
        {
            if( REGIONAL_ROLLOUT_RECORDTYPE == newRollout.RecordTypeId && newRollout.IPM_Project__c !=null )
            {   
                phaseChangeProjects.add(newRollout.IPM_Project__c);
                phaseChangeRolloutSet.add(newRollout.Id);
            }
        
            if( LOCAL_ROLLOUT_RECORDTYPE == newRollout.RecordTypeId && newRollout.Regional_Project__c !=null )
            {   
                phaseChangeProjects.add(newRollout.Regional_Project__c);
                phaseChangeRolloutSet.add(newRollout.Id);
            }
        }
        if( oldRollout.Target_Launch_Date__c != newRollout.Target_Launch_Date__c ||  oldRollout.isActive__c != newRollout.isActive__c){
            rolloutProjectTLDChanged.put(oldRollout.Id,newRollout);
            if(!globalProjIdRollout.containskey(newRollout.IPM_Project__c) && !globalProjIdRollout.containskey(newRollout.Regional_Project__c)  && oldRollout.Target_Launch_Date__c != newRollout.Target_Launch_Date__c){
                if(newRollout.Regional_Project__c != null){
                    globalProjIdRollout.put(newRollout.Regional_Project__c,newRollout);  
                } else if(newRollout.IPM_Project__c != null){
                    globalProjIdRollout.put(newRollout.IPM_Project__c,newRollout); 
                }
            }            
        }        

    }
    /**
    * @description:afterDelete
    * This method is use for skip trigger execution
    * trigger.
    * @para:sobject record
    */
    public void afterDelete(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
        //recalculate TLD when rollout is deleted
        IPM_Project_Rollout__c newRollout = (IPM_Project_Rollout__c)so; 
        rolloutProjectTLDChanged.put(newRollout.Id,newRollout);
          
    }
    
    /**
    * @description:andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally()
    {
        //call method to insert all exception logs got while excecution of trigger
        
        if( (Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter)
        {
            if(!phaseChangeProjects.isEmpty())
            {
                IPM_ProjectJob_Queue phaseChangeAsyncHandler = new IPM_ProjectJob_Queue(); 
                phaseChangeAsyncHandler.initializeRolloutProjectData(phaseChangeProjects,phaseChangeRolloutSet); 
                Id asyncJobId = System.enqueueJob(phaseChangeAsyncHandler);
                IPM_RolloutTriggerHandler.udpateAsyncJobId(phaseChangeRolloutSet,asyncJobId);
            }
        }
        
        if(!rolloutProjectTLDChanged.isEmpty()){
            IPM_RolloutPlanTLDSync rolloutPlanTLDSync = new IPM_RolloutPlanTLDSync();
            rolloutPlanTLDSync.syncTLDDates(null,rolloutProjectTLDChanged);
            rolloutPlanTLDSync.notifyGlobalProjectFinanceLeader(globalProjIdRollout);                      
        }
        ExceptionLoggingHelper.insertLogRecordList();
    }
}