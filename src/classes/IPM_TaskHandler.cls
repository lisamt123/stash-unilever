/**
   @Author:Cognizant
   @name:IPM_TaskHandler
   @CreateDate:06/05/2015
   @Description:Trigger Handler for the IPM_Task__c SObject. This class implements the ITrigger interface to help ensure the trigger code is bulkified and all in one place.
   @Version <1.0>
*/
public with sharing class IPM_TaskHandler implements ITrigger{   
    
    private Set<Id> sectionIds = new Set<Id>();//identify if the tasks are associated with ny sections add them
    private Map<Id, Set<String>> projectTasksMap = new Map<Id, Set<String>>();//sort the project tasks project wise
    public Set<Id> projectIdSet = new Set<Id>();//project ids set  
    public Set<Id> taskSectionIdSet = new Set<Id>();//project ids set  
    public Map<Id,IPM_Project__c> projectDetailMap = new Map<Id,IPM_Project__c>();
    public Map<Id,IPM_Section__c> sectionDetailMap = new Map<Id,IPM_Section__c>();    
    public Id projectTask = Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectTasks).getRecordTypeId();
    
   //@description:Constructor
    public IPM_TaskHandler (){
        ExceptionLoggingHelper.initializeExceptionLog();
    }
    /**
    * @Description :This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    * @name:bulkBefore
    * @param:none
    */
    public void bulkBefore()
    {
        if(Trigger.isInsert || Trigger.isUpdate)
        {    
            List<IPM_Task__c> taskList =  (List<IPM_Task__c>)Trigger.new ;
            for (IPM_Task__c newTask : taskList) 
            {   //get project ids in set
                if(newTask.IPM_Project__c != null)
                {
                    projectIdSet.add(newTask.IPM_Project__c);
                }
                if(newTask.IPM_Section__c != null)
                {
                    taskSectionIdSet.add(newTask.IPM_Section__c);
                }
            }
            //get project details 
            if(!projectIdSet.isEmpty())
            {
                String projectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null,true);
                String projectWhereClause = ' WHERE Id in :projectIdSet AND IPM_Project_Leader__c != NULL LIMIT 50000';
                projectQuery = projectQuery + projectWhereClause;
                projectDetailMap = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>) database.query(projectQuery));
            }
            //get task section details
            if(!taskSectionIdSet.isEmpty())
            {
                String sectionQuery = IPM_Utils.prepareSOQLQuery('IPM_Section__c',false,null,true);
                String sectionWhereClause = ' WHERE Id in :taskSectionIdSet  LIMIT 50000';
                sectionQuery = sectionQuery + sectionWhereClause;
                sectionDetailMap = new Map<Id,IPM_Section__c>( (List<IPM_Section__c>) database.query(sectionQuery));
            }
   
            //To assign default task owner as PL
            if(Trigger.isInsert)
            {
                List<IPM_Task__c> taskWithoutDueDate = new List<IPM_Task__c>();
                
                if(!taskList.isEmpty())
                {
                    for (IPM_Task__c newTask : taskList) 
                    {   //get project ids in set
                        if(newTask.IPM_Assignee__c == NULL && projectDetailMap.containsKey(newTask.IPM_Project__c) && projectDetailMap.get(newTask.IPM_Project__c)!=null && projectTask == newTask.RecordTypeId)
                        {
                            newTask.IPM_Assignee__c = projectDetailMap.get(newTask.IPM_Project__c).IPM_Project_Leader__c;
                        }
                        
                        if(newTask.IPM_Due_Date1__c == null && projectTask == newTask.RecordTypeId)
                        {
                            taskWithoutDueDate.add(newTask);
                        }   
                    }
                }
                
                if(!taskWithoutDueDate.isEmpty()){
                    IPM_TaskHelper.updateTaskDueDateBasedOnMS(taskWithoutDueDate); // Task list to update based on Milestone Due Date 
                }
            }
            
            if(Trigger.isUpdate)
            {
            	if(!taskList.isEmpty())
            	{
            		for (IPM_Task__c newTask : taskList) 
                    { 
                     if(String.isBlank(newTask.IPM_Type_of_Task__c) || !IPM_ConstantUtils.TEMPLATE_TASKS.equalsIgnoreCase(newTask.IPM_Type_of_Task__c))
                     {
                    	if(newTask.IsSystemGenerated__c)
                    	{
                    		newTask.IPM_Type_of_Task__c = IPM_ConstantUtils.STANDARD;
                    	}
                    	else
                    	{
                    		newTask.IPM_Type_of_Task__c = IPM_ConstantUtils.ADHOC;
                    	}
                      }	
                    }
            	}
            }
        }
    }
    /**
    * @Description:This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    * @name : bulkAfter
    */
    public void bulkAfter(){
        
        //Will use the preparation data form bulkBefore temporarily until we have another member function UnDelete 
        if(Trigger.isUnDelete) {
            for(IPM_Task__c eachTask : (list<IPM_Task__c>)Trigger.new) {
                if(eachTask.IPM_Project_Document_Section__c != null) {
                    sectionIds.add(eachTask.IPM_Project_Document_Section__c);
                }
            }
        }
        if(Trigger.isInsert){
            list<IPM_Task__c> taskList = new list<IPM_Task__c>();
            for(IPM_Task__c tsk :(List<IPM_Task__c>)Trigger.new)
            {
                if(projectTask == tsk.RecordTypeId)
                {
                    taskList.add(tsk);
                }
            }
            IPM_ChatterFeedHelper.notifyAssigneeTaskAssigned((List<IPM_Task__c>)Trigger.New);
        }
    }
    /**
    * @description:This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @name: beforeInsert
    * @param:sobject record
    */
    public void beforeInsert(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface
        IPM_task__c newTaskObj = (IPM_Task__c)so;
        
        IPM_TaskHelper.prepareCustomTaskName(newTaskObj,projectDetailMap);
        
        /*Assignes the external id field value*/
        if(newTaskObj != null && string.isBlank(newTaskObj.ExternalField__c) && projectDetailMap.containsKey(newTaskObj.IPM_Project__c) && newTaskObj.IsSystemGenerated__c)
        {
           newTaskObj.ExternalField__c = IPM_TaskHelper.generateTaskExternalId(newTaskObj,projectDetailMap.get(newTaskObj.IPM_Project__c),sectionDetailMap);
        } 
        
        if(newTaskObj.IPM_Completed__c)
        {
            newTaskObj.IPM_Completed_Date__c = system.today();
        }
        
        if(!newTaskObj.IPM_Completed__c)
        {
            newTaskObj.IPM_Completed_Date__c = null;
        }

        
    }
    /**
    * @description:This method is called iteratively for each record to be update during a BEFORE
    * trigger.
    * @name : beforeUpdate
    * @param:old sobject record
    * @param:new sobject record
    */
    public void beforeUpdate(SObject oldSo, SObject so){   
        //This method has been included as the class implements the ITrigger interface
        IPM_task__c newTaskObj = (IPM_Task__c)so;
        IPM_task__c oldTaskObj = (IPM_Task__c)oldSo;
        
        IPM_TaskHelper.prepareCustomTaskName(newTaskObj,projectDetailMap);
        
        if( projectDetailMap.containsKey(newTaskObj.IPM_Project__c) && newTaskObj.IsSystemGenerated__c)
        {
            /*Assignes the updated external id field value */
            newTaskObj.ExternalField__c = IPM_TaskHelper.generateTaskExternalId(newTaskObj,projectDetailMap.get(newTaskObj.IPM_Project__c),sectionDetailMap);
        }
        if(!oldTaskObj.IPM_Completed__c && newTaskObj.IPM_Completed__c)
        {
            newTaskObj.IPM_Completed_Date__c = system.today();
        }
        
        if(oldTaskObj.IPM_Completed__c && !newTaskObj.IPM_Completed__c)
        {
            newTaskObj.IPM_Completed_Date__c = null;
        }
        
    }
    
    /**
    * @description:This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    * @param: sobject record
    */
    public void beforeDelete(SObject so){      
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @name: afterInsert
    * @param:sobject record
    */
    public void afterInsert(SObject so){
        IPM_Task__c eachTask = (IPM_Task__c)so;
        if(eachTask.IPM_Project_Document_Section__c != null) {
            sectionIds.add(eachTask.IPM_Project_Document_Section__c);
        }
    }
    /**
    * @description:This method is called iteratively for each record to be update during a AFTER
    * trigger.
    * @name: afterupdate
    * @param:old sobject record
    * @param:new sobject record
    */
    public void afterUpdate(SObject oldSo, SObject so) {
        
        IPM_Task__c oldTask = (IPM_Task__c)oldSo;
        IPM_Task__c eachTask = (IPM_Task__c)so;
        if(eachTask.IPM_Project__c != null && eachTask.IPM_Completed__c && 
                   eachTask.IPM_Completed__c != oldTask.IPM_Completed__c && projectTask == eachTask.RecordTypeId) {//if never done previously but now
           if(!projectTasksMap.containsKey(eachTask.IPM_Project__c)) {
                Set<String> tmpStr = new Set<String>();
                tmpStr.add(eachTask.IPM_Task_Name__c);
                projectTasksMap.put(eachTask.IPM_Project__c, tmpStr);
           }else {
               projectTasksMap.get(eachTask.IPM_Project__c).add(eachTask.IPM_Task_Name__c);
           }
        }
    }
    /**
    * @description:This method is called iteratively for each record to be delete during a AFTER
    * trigger.
    * @name:afterDelete
    * @param:sobject record
    */
    public void afterDelete(SObject so){
        IPM_Task__c eachTask = (IPM_Task__c)so;
        if(eachTask.IPM_Project_Document_Section__c != null) {
            sectionIds.add(eachTask.IPM_Project_Document_Section__c);
        }
    }
    
    /**
    * @description:andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
       Map<Id, String> subjectIdMessageMap = new Map<Id, String>();
        if(Trigger.isAfter && Trigger.isUpdate) {
            //Chatter that tasks are now COMPLETE!
            for(Id eachProject : projectTasksMap.keySet()) {
           String postText = IPM_Utils.convertSetToString(projectTasksMap.get(eachProject)) +IPM_ConstantUtils.IPM_SPACE+ Label.IPM_Task_Completion_Text;
           subjectIdMessageMap.put(eachProject,postText);
          }
          IPM_ChatterUtils.postChatterFeedWithMention(projectTasksMap.keySet(),subjectIdMessageMap,null); 
        }
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger 
        ExceptionLoggingHelper.insertLogRecordList();
    }
}