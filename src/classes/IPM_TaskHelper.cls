/**
    @Author: Cognizant Technology
    @Name: IPM_TaskHelper
    @CreateDate : Oct 2014
    @Description: Business helper class which processes on Tasks & assignments and also deal with team members etc
    @Version <1.0>
**/

public with sharing class IPM_TaskHelper { 
    
    public static Boolean SKIP_TRIGGER_EXECUTION = false;
    
    
     /**************************************************************
    * @description: Creating Custom Task Name for Assigning to Task  
    * @param1 newtaskObj : incoming Task Obj
    * @param2 newtaskObj : Project Detail Map
    */
    
    public static void prepareCustomTaskName(IPM_Task__c newtaskObj,Map<Id,IPM_Project__c> projectDetailMap) 
    {
      Id recordTypeIdValue = Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectTasks).getRecordTypeId();
      
      if(newTaskObj.IPM_Project__c !=null && projectDetailMap.containsKey(newTaskObj.IPM_Project__c) )
        {
          IPM_Project__c associatedProject = projectDetailMap.get(newTaskObj.IPM_Project__c);   
          String projectName = IPM_ConstantUtils.BLANK;
          if(!String.isBlank(associatedProject.IPM_Project_Name__c))
          {
            projectName = associatedProject.IPM_Project_Name__c;
          }
          else
          {
            projectName = associatedProject.Name;
          }
          
          String taskName = IPM_ConstantUtils.BLANK;
          if(newTaskObj.RecordTypeId == recordTypeIdValue)
          {
              taskName = projectName + '-' + newTaskObj.IPM_Task_Name__c;
            
            if(!String.isBlank(taskName) && taskName.length() >= 80)
            {
                  newTaskObj.Name = taskName.substring(0,79);
            }
            else
            {
                  newTaskObj.Name = taskName;
            }
          }
        }   
    }
     /**************************************************************
    * @description: Assigne due date for task depending upon milestone due date  
    * @param1 newtaskObj : incoming Task Obj
    */
    public static void updateTaskDueDateBasedOnMS(List<IPM_Task__c> taskList)
    {
        
        if(taskList!= null && !taskList.isEmpty())
        {   
           Set<Id> projectIdSet = new Set<Id>();
           for(IPM_Task__c task : taskList)
           {
               projectIdSet.add(task.IPM_Project__c);
           }
               
           List<IPM_Milestone__c> milestoneList = [SELECT Id,IPM_Due_Date__c,IPM_Phase__c,IPM_Project__c FROM IPM_Milestone__c WHERE IPM_Project__c IN : projectIdSet AND IPM_Due_Date__c != null AND IPM_Type_of_Milestone__c=: IPM_Utils.Standard];
           
           if(milestoneList != null && !milestoneList.isEmpty()){  
               for(IPM_Task__c task : taskList){
                   //updating the due date only for task which are not completed
                   if(!task.IPM_Completed__c ){
                       for(IPM_Milestone__c milestone : milestoneList){
                            //assign the task due date as per the milestone due date
                            if(milestone.IPM_Phase__c != null && milestone.IPM_Phase__c.equalsIgnoreCase(task.IPM_Phase__c) && milestone.IPM_Project__c == task.IPM_Project__c){
                                Date dueDate = milestone.IPM_Due_Date__c.addDays(-14);
                                //if milestone having due date which is after 15 days from today
                                if(dueDate != null && dueDate <= System.Today()){
                                    task.IPM_Due_Date1__c = milestone.IPM_Due_Date__c;
                                }//if milestone having due date which is before 15 days from today
                                else{
                                    task.IPM_Due_Date1__c =  dueDate;
                                }
                            }
                        }
                    }
                }
            }
                
        }
    }
    
    /**************************************************************
    * @description: Whenever the team member is assined or reassigned in a team to a project, this method will identify who to be left with the remaning tasks
    * @param1 newProjectResources : THe list of IPM_Project_Resource__c object
    */
    public static void reAssignFunctionalWiseTasks(IPM_Project_Resource__c[] newProjectResources) {
        
            list<IPM_Task__c> tasksToUpdate = new list<IPM_Task__c>();//new tasks which needed update
            Map<String, String> functionalRoleUserMap = new Map<String, String>();//add customised key and store the user who per project & role
            Set<Id> projectIds = new Set<Id>();//extracted project ids
            Set<String> functionalRolesSet = new Set<String>();//intermittend set
            for(IPM_Project_Resource__c eachPR : newProjectResources) {
                functionalRolesSet.add(eachPR.IPM_Role_Type__c);
                projectIds.add(eachPR.IPM_Project__c);
                functionalRoleUserMap.put(eachPR.IPM_Role_Type__c+'-'+eachPR.IPM_Project__c, eachPR.IPM_User__c);
            }
                                
            for(IPM_Task__c eachTask :  [SELECT IPM_Assignee__c, IPM_Function__c, IPM_Project__c FROM IPM_Task__c 
                                                                    WHERE IPM_Project__c IN :projectIds
                                                                    AND IPM_Function__c IN :functionalRolesSet AND IPM_Completed__c != true]) {
                IPM_Task__c tskObj = eachTask;
                tskObj.IPM_Assignee__c = functionalRoleUserMap.get(eachTask.IPM_Function__c+'-'+eachTask.IPM_Project__c);
                tasksToUpdate.add(tskObj);
            }
            if(tasksToUpdate != null && !tasksToUpdate.isEmpty()){
                update tasksToUpdate; //finally perform the update
            }
    }

     /**************************************************************
    * @description: used to create Tasks when project is created.
    * @param1 projectDocToSectionMap : newly Created project Document To Section Map
    * @param2 projectToDocumentMap : project to Project Document Map 
    * @param3 incomingProjects : Trigger.New projects Map
    */
    
    public static void manageTasks(Map<Id,List<IPM_Project_Document_Section__c>> projectDocToSectionMap,Map<Id,Map<String,IPM_Project_Document__c>> projectToDocumentMap, Map<Id,IPM_Project__c> incomingProjects)
    {
        
        List<IPM_Task__c> upsertTaskList = new List<IPM_Task__c>();
        Map<Id,IPM_Task__c> deleteTaskMap = new Map<Id,IPM_Task__c>();
        
        for(IPM_Project__c project : incomingProjects.values()) 
        {
            if(IPM_ProjectHelper.projectMasterMap.containsKey(project.Id) && IPM_ProjectHelper.projectMasterMap.get(project.Id)!=null)
            {
                IPM_Project__c projectDetail = IPM_ProjectHelper.projectMasterMap.get(project.Id);
            
                // Get associated Project Type
                IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(projectDetail);
                
                // Validate whehter Approach is internal.If it is internal then only Manage Tasks for that project.    
                if(associatedProjectType!=null )
                {
                    // Project Current Phase and Gate
                    String projectCurrentPhase = associatedProjectType.IPM_Phase__c;
                    String projectCurrentGate = associatedProjectType.IPM_Gate_Document__c;
                    
                    // Get Previous Phases and validate whether the tasks associated with previous Phases are closed or not.
                    List<IPM_Project_Type__c> previousPhasesList = IPM_Utils.getPreviousPhases(associatedProjectType,true);
                    
                    Set<String> previousPhases = new Set<String>();
                
                    for(IPM_Project_Type__c projectType : previousPhasesList)
                    {
                        previousPhases.add(projectType.IPM_Phase__c);
                    }
                    
                    if(!String.isblank(projectDetail.IPM_Complexity__c) )
                    {
                        IPM_Project_Template__c selectedTemplate = null;
                        
                        IPM_Document_Template__c selectedDocumentTemplate = null;
                        
                        Map<Id,IPM_Section__c> associatedDocumentSectionMap = new Map<Id,IPM_Section__c>();

                        /* Creation of Tasks starts */
                        // Newly inserted sections for Project
                        IPM_Project_Document__c targetProjectDocument = null;
                        List<IPM_Project_Document_Section__c> targetProjectDocSectionList = null;
                        
                        // Master list of Tasks based on template
                        List<IPM_Task__c> masterTaskList = new List<IPM_Task__c>();
                        
                        //Newly created Task List for Project
                        List<IPM_Task__c> newTaskList = new List<IPM_Task__c>();
                        
                        /* Creation of Tasks starts */
                        
                        /* Update of Previous Phase Tasks starts */
                        Map<Id,IPM_Task__c> existingTaskMap = new Map<Id,IPM_Task__c>();
                        
                        
                        /* Update of Previous Phase Tasks ends */
                        for(IPM_Project_Template__c template : IPM_ProjectHelper.complexityTemplateMap.values())
                        {
                            if(template.IPM_Template_Complexity__c.equalsIgnoreCase(projectDetail.IPM_Complexity__c) && 
                                IPM_ProjectHelper.complexitySpecificTaskMap.containsKey(template.Id) && IPM_ProjectHelper.complexitySpecificTaskMap.get(template.Id)!=null && 
                                !String.isBlank(projectDetail.IPM_SourceProjectType__c) && !String.isBlank(template.IPM_Project_Type__c) && projectDetail.IPM_SourceProjectType__c == template.IPM_Project_Type__c && 
                                !String.isBlank(projectDetail.IPM_Category_Text__c) && !String.isBlank(template.IPM_Category__c) &&  template.IPM_Category__c.contains(projectDetail.IPM_Category_Text__c) )
                            {   
                                // Get standard Tasks based on Complexity and Phase. 
                                for(IPM_Task__c task : IPM_ProjectHelper.complexitySpecificTaskMap.get(template.Id))
                                {
                                    // Validate record Types for Template tasks should be equal to master Record Type and Phase should be same.
                                    if(task.RecordTypeId == IPM_ProjectHelper.taskMasterRecordType && !String.isBlank(task.IPM_Phase__c) && task.IPM_Phase__c.equalsIgnoreCase(projectCurrentPhase))
                                    {
                                        masterTaskList.add(task);
                                    }
                                }
                                selectedTemplate = template;
                                break;
                            }   
                        }
                        
                        if(selectedTemplate!= null && IPM_ProjectHelper.complexitySpecificDocumentTemplates.containsKey(selectedTemplate.Id))
                        {
                            for(IPM_Document_Template__c docTemplate : IPM_ProjectHelper.complexitySpecificDocumentTemplates.get(selectedTemplate.Id))
                            {
                                // If project Gate Matches Document Type Gate, Get the corresponding Sections 
                                if(projectCurrentGate == docTemplate.IPM_Document_Type__c)
                                {
                                     selectedDocumentTemplate = docTemplate;
                                     if(IPM_ProjectHelper.documentTemplateSpecificSectionMap.containsKey(selectedDocumentTemplate.Id) && IPM_ProjectHelper.documentTemplateSpecificSectionMap.get(selectedDocumentTemplate.Id)!=null)
                                     {
                                        List<IPM_Section__c> associatedDocumentSections = IPM_ProjectHelper.documentTemplateSpecificSectionMap.get(selectedDocumentTemplate.Id);
                                        
                                        associatedDocumentSectionMap = new Map<Id,IPM_Section__c>(associatedDocumentSections);         
                                     } 
                                     break;
                                }
                            }
                        }
                                    
                        if(projectCurrentGate!=null && String.isNotBlank(projectCurrentGate))
                        {
                            // From the newly Processed List of Project Document Template and Project Document Sections, get the currentPhase Document .
                            if(projectToDocumentMap.containsKey(projectDetail.Id) && projectToDocumentMap.get(projectDetail.Id)!=null)
                            {
                                Map<String,IPM_Project_Document__c> gateSpecificDocumentMap = projectToDocumentMap.get(projectDetail.Id);
                                if(gateSpecificDocumentMap.containsKey(projectCurrentGate) && gateSpecificDocumentMap.get(projectCurrentGate)!=null)
                                {
                                    targetProjectDocument = gateSpecificDocumentMap.get(projectCurrentGate);
                                    if(projectDocToSectionMap.containsKey(targetProjectDocument.Id) && projectDocToSectionMap.get(targetProjectDocument.Id)!=null)
                                    {
                                        targetProjectDocSectionList = projectDocToSectionMap.get(targetProjectDocument.Id); 
                                    }
                                }
                            }
        
                            if(targetProjectDocument!=null)
                            {
                                for(IPM_Task__c masterTask : masterTaskList)
                                {
                                    IPM_Task__c newTask = new IPM_Task__c();
                                    newTask.IPM_Task_Name__c = masterTask.IPM_Task_Name__c;
                                    newTask.IPM_Project_Template__c = selectedTemplate.Id;
                                    newTask.IPM_Active__c = true;
                                    newTask.IPM_Task_Type__c = masterTask.IPM_Task_Type__c;
                                    newTask.IPM_Type_of_Gate__c = masterTask.IPM_Type_of_Gate__c;
                                    newTask.IPM_Phase__c = masterTask.IPM_Phase__c;
                                    newTask.IPM_Function__c = masterTask.IPM_Function__c;
                                    newTask.IPM_Version_Number__c = masterTask.IPM_Version_Number__c;
                                    newTask.IPM_Section__c = masterTask.IPM_Section__c;
                                    newTask.IPM_Master_Task__c = masterTask.Id;
                                    newTask.IPM_Task_Complexity__c = selectedTemplate.IPM_Template_Complexity__c; 
                                    newTask.IsSystemGenerated__c = true;
                                    
                                    for(IPM_Project_Document_Section__c projectDocumentSection : targetProjectDocSectionList)
                                    {
                                         if(masterTask.IPM_Section__c!= null &&
                                            masterTask.IPM_Master_Section_Name__c.equalsIgnoreCase(projectDocumentSection.IPM_Section_Name__c) && 
                                            masterTask.IPM_Master_Section_Sequence__c.equalsIgnoreCase(projectDocumentSection.IPM_Section_Sequence_Number__c))      
                                        {
                                            newTask.IPM_Project_Document_Section__c = projectDocumentSection.Id;        
                                        }
                                    }
                                    
                                    newTask.IPM_Project__c = projectDetail.Id;
                                    
                                    newTask.RecordTypeId = IPM_ProjectHelper.taskProjectRecordType;
                                    
                                    if(projectDetail!=null && IPM_ProjectHelper.DBprojectSpecificResourceMap.containsKey(projectDetail.Id) && 
                                        IPM_ProjectHelper.DBprojectSpecificResourceMap.get(projectDetail.Id)!=null )
                                    {
                                        for(IPM_Project_Resource__c projectResource : IPM_ProjectHelper.DBprojectSpecificResourceMap.get(projectDetail.Id))
                                        {
                                            if(projectResource.IPM_Role_Type__c!=null && projectResource.IPM_Role_Type__c.equalsIgnoreCase(masterTask.IPM_Function__c) && projectResource.IPM_Project_Role_Owner__c)
                                            {
                                                newTask.IPM_Assignee__c = projectResource.IPM_User__c; 
                                                break;
                                            }       
                                        }
                                    }
                                    else if(projectDetail.IPM_Project_Leader__c != null && newTask.IPM_Assignee__c == null)
                                    {
                                        newTask.IPM_Assignee__c = projectDetail.IPM_Project_Leader__c;
                                    }
                                    if(((newTask.IPM_Section__c != null && newTask.IPM_Project_Document_Section__c != null) ||
                                        (newTask.IPM_Section__c == null && newTask.IPM_Project_Document_Section__c == null)) &&
                                        (
                                          masterTask.IPM_Master_Section_Sequence__c != IPM_ConstantUtils.ENVIRONMENTAL_IMPACT_SEQUENCE || 
                                          (
                                            masterTask.IPM_Master_Section_Sequence__c.equalsIgnoreCase(IPM_ConstantUtils.ENVIRONMENTAL_IMPACT_SEQUENCE) &&
                                            project.IPM_Answer_of_Q1__c !=IPM_ConstantUtils.BLG
                                          )
                                        ))
                                    {
                                        newTaskList.add(newTask);
                                    }
                                }
                            }
                        }
                         
                        List<IPM_Task__c> existingTasks = new List<IPM_Task__c>();
                        
                        if(IPM_ProjectHelper.DBprojectSpecificTasksMap.containsKey(projectDetail.Id) &&  
                            IPM_ProjectHelper.DBprojectSpecificTasksMap.get(projectDetail.Id) !=null)
                        {
                            existingTasks = IPM_ProjectHelper.DBprojectSpecificTasksMap.get(projectDetail.Id);
                            
                            for(IPM_Task__c existingTask : existingTasks)
                            {
                                // Check if task phase belongs to an Old Phase and is not complete. If yes update the Complete flag as true;
                                // Check if the project is archieved then mark tasks as complete.
                                // Only mark active tasks as complete. 
                                if( existingTask.IPM_Completed__c !=null && existingTask.IPM_Phase__c!=null && !existingTask.IPM_Completed__c && 
                                existingTask.IPM_Active__c && ( previousPhases.contains(existingTask.IPM_Phase__c) || projectDetail.Is_Archieved__c ) )
                                {
                                    existingTask.IPM_Completed__c = true;
                                    existingTask.IPM_AutoCompletedBySystem__c = true;
                                    existingTaskMap.put(existingTask.id,existingTask);
                                }
                                
                                // Check if project Complexity matches with Tasks. If not mark them as inactive
                                if(String.isNotBlank(existingTask.IPM_Task_Complexity__c) && existingTask.IsSystemGenerated__c &&
                                   projectDetail.IPM_Complexity__c != existingTask.IPM_Task_Complexity__c && projectDetail.IPM_Phase__c == existingTask.IPM_Phase__c)
                                {
                                    existingTask.IPM_Active__c = false;
                                    existingTaskMap.put(existingTask.id,existingTask);
                                }
                                
                                if(existingTask.IPM_Phase__c!=null && !existingTask.IPM_Active__c && previousPhases.contains(existingTask.IPM_Phase__c) )
                                {   
                                    deleteTaskMap.put(existingTask.Id,existingTask);
                                }                                        
                            }
                        }
                        
                        for(IPM_Task__c newTask :newTaskList)
                        {
                            String associatedSectionNumber = IPM_ConstantUtils.BLANK;
                            String newTaskCopyOverKey = IPM_ConstantUtils.BLANK;
                            
                            String associatedExternalId = IPM_TaskHelper.generateTaskExternalId(newTask,projectDetail,associatedDocumentSectionMap);
                            
                            if(!associatedDocumentSectionMap.isEmpty() && associatedDocumentSectionMap.containsKey(newTask.IPM_Section__c) )
                            {
                                associatedSectionNumber = associatedDocumentSectionMap.get(newTask.IPM_Section__c).IPM_Section_Sequence__c;
                            }
                                    
                            if(!String.isBlank(associatedSectionNumber))
                            {
                                newTaskCopyOverKey = newTask.IPM_Phase__c + associatedSectionNumber + newTask.IPM_Function__c + newTask.IPM_Task_Name__c;
                            }
                            else
                            {
                                newTaskCopyOverKey = newTask.IPM_Phase__c + newTask.IPM_Function__c + newTask.IPM_Task_Name__c;
                            }        
                            
                            for(IPM_Task__c existingTask : existingTasks)
                            {
                                // If external Id matches on existing Tasks update the Id on the new to point to the old task.
                                if(existingTask.IsSystemGenerated__c && associatedExternalId == existingTask.ExternalField__c)
                                {
                                    newTask.Id = existingTask.Id;
                                    break;
                                }
                            }
                            
                                
                            for(IPM_Task__c existingTask : existingTaskMap.values())
                            {
                                String existingTaskCopyOverKey = IPM_ConstantUtils.BLANK;
                                
                                if(existingTask.IPM_Section__c!=null)
                                {
                                    existingTaskCopyOverKey = existingTask.IPM_Phase__c + existingTask.IPM_Master_Section_Sequence__c + existingTask.IPM_Function__c + existingTask.IPM_Task_Name__c;
                                }
                                else
                                {
                                    existingTaskCopyOverKey = existingTask.IPM_Phase__c + existingTask.IPM_Function__c + existingTask.IPM_Task_Name__c;
                                }
                                
                                if(newTaskCopyOverKey == existingTaskCopyOverKey)
                                {
                                    if(existingTask.IPM_Due_Date1__c != null)
                                    {
                                       newTask.IPM_Due_Date1__c = existingTask.IPM_Due_Date1__c;
                                    }
                                    
                                    if(existingTask.IPM_Completed__c)
                                    {
                                       newTask.IPM_Completed__c = existingTask.IPM_Completed__c;
                                    }
                                    break;
                                }
                            }
                            upsertTaskList.add(newTask);
                        }
                        upsertTaskList.addAll(existingTaskMap.values());
                    }  
                }
            }
        }
                    
        if(upsertTaskList!=null && !upsertTaskList.isEmpty())
        {
            upsert upsertTaskList ;
        }
        
        if(deleteTaskMap!=null && !deleteTaskMap.isEmpty())
        {
            delete deleteTaskMap.values();
        }
    }
    
    /**************************************************************
    * @description: used to create external id for Tasks when project is created.
    * @param1 newTaskObj : task record
    */
    public static String generateTaskExternalId(IPM_Task__c newTaskObj,IPM_Project__c projectDetail,Map<Id,IPM_Section__c> sectionDetailMap)
    {
        String externalId = '';
       if(projectDetail != null && string.isNotBlank(projectDetail.IPM_Project_Name__c))
       { 
            if(String.isBlank(newTaskObj.IPM_Phase__c) )
            {
                newTaskObj.addError(Label.IPM_Generic_ErrorMessage);
            }
            else
            {
                if(newTaskObj.IsSystemGenerated__c )
                {
                    if(newTaskObj.IPM_Master_Task__c == null  || String.isblank(newTaskObj.IPM_Task_Complexity__c) && Trigger.isExecuting)
                    {
                        newTaskObj.addError(Label.IPM_Generic_ErrorMessage);
                    }
                    if(newTaskObj.IPM_Section__c != null && sectionDetailMap.containsKey(newTaskObj.IPM_Section__c))
                    {
                        externalId = projectDetail.IPM_Project_Name__c + newTaskObj.IPM_Phase__c + newTaskObj.IPM_Task_Complexity__c + newTaskObj.IPM_Section__c + newTaskObj.IPM_Function__c + newTaskObj.IPM_Task_Name__c ;
                    }
                    else
                    {
                        externalId = projectDetail.IPM_Project_Name__c + newTaskObj.IPM_Phase__c + newTaskObj.IPM_Task_Complexity__c + newTaskObj.IPM_Function__c + newTaskObj.IPM_Task_Name__c ;
                    }
                }
                Integer len = SObjectType.IPM_Task__c.Fields.ExternalField__c.Length;
            
                if(String.IsNotBlank(externalId) && externalId.length() > len){
                    externalId = externalId.subString(0,len-1);
                }
                if(string.isBlank(externalId) && Trigger.isExecuting)
                {
                    newTaskObj.addError(Label.IPM_Generic_ErrorMessage);
               }
            }
       }
       return externalId;
    }
   /**************************************************************
    * @description: used to create mapping of funtional role and respective functional owner, default functional owner is project leader
    * @param1 newTaskObj : project record
    */
    public static map<Id,map<String,Id>> createFunctionalRoleUserMapping(list<IPM_Project__c> projectWithResourceList){
        
        //map of project id as Key and value as other map(key-functional role and value-assignee)
        map<Id,map<String,Id>> projIdAssigneeMap = new map<Id,map<String,Id>> ();   
        
        //get task functional role values
        Schema.DescribeFieldResult fieldResult = IPM_Task__c.IPM_Function__c.getDescribe();
        List<Schema.PicklistEntry> functionalRole = fieldResult.getPickListValues();
        
        //project and its resources
        if(projectWithResourceList != null && !projectWithResourceList.isEmpty() )
        {   
            for(IPM_Project__c project : projectWithResourceList)
            { 
                // map as funtional role as key and respectiver user as key
                map<String,Id> funcAssigneeId = new map<String,Id> ();   
                                            
                //assignee default user as project leader for each functional role
                for(Schema.PicklistEntry role :functionalRole)
                {
                    if(project.IPM_Project_Leader__c != null)
                    {
                        funcAssigneeId.put(role.getValue(),project.IPM_Project_Leader__c);
                    }
                }
                
                if(project.IPM_Project_Resources__r != null && !funcAssigneeId.isEmpty())
                {
                    //if functional owner present then assigne owner
                    for(IPM_Project_Resource__c projRes :project.IPM_Project_Resources__r)
                    {
                        if(funcAssigneeId.containsKey(projRes.IPM_Role_Type__c) && projRes.IPM_Project_Role_Owner__c)
                        {
                            funcAssigneeId.put(projRes.IPM_Role_Type__c,projRes.IPM_User__c);
                        }
                    }
                }
                //put project id and all functional role with there respective owners if present
                projIdAssigneeMap.put(project.id,funcAssigneeId);
            }
            
        }
        
        //get project resource
        
        return projIdAssigneeMap;
    }
    /**************************************************************
    * @description: used to assign updated assignee to task
    * @param1 newTaskObj : project record
    */
    public static void assignUserToTask(set<Id> projectIdSet){
        
        // query all the task belonging to thhe project 
        list<IPM_Project__c>projectDetailList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Leader__c,
                                                    (SELECT Id,IPM_User__c,IPM_Role_Type__c,IPM_Project_Role_Owner__c FROM IPM_Project_Resources__r),
                                                    (Select Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Type_of_Gate__c,IPM_Assignee__c,IPM_Active__c,IPM_Completed__c
                                                    from Tasks__r where IPM_Completed__c != true)
                                                from IPM_Project__c where Id IN:projectIdSet];
        
        //create functional role and assignee map for each project
        map<Id,map<String,Id>> projIdWithAssigneeMap = createFunctionalRoleUserMapping(projectDetailList);   
        
        //list of task needs to be updated
        list<IPM_Task__c> tasksToUpdate = new list<IPM_Task__c>();
        
        //if functional role and user map is not 
        if(projIdWithAssigneeMap != null && !projIdWithAssigneeMap.isEmpty() && projectDetailList != null && !projectDetailList.isEmpty())
        {
            for(IPM_Project__c project : projectDetailList)
            { 
                map<String,Id> funcAssigneeIdMap = projIdWithAssigneeMap.get(project.id);     
                                            
                for(IPM_Task__c eachTask :  project.Tasks__r) 
                {
                    // check if the functional owner or project leader has changed then assigne updated user
                    IPM_Task__c tskObj = eachTask;
                    if(funcAssigneeIdMap.containsKey(eachTask.IPM_Function__c) && eachTask.IPM_Assignee__c != funcAssigneeIdMap.get(eachTask.IPM_Function__c) )
                    {
                        tskObj.IPM_Assignee__c = funcAssigneeIdMap.get(eachTask.IPM_Function__c);
                        tasksToUpdate.add(tskObj);
                    }
                }
            }
            if(tasksToUpdate != null && !tasksToUpdate.isEmpty())
            {
                //finally perform the update
                update tasksToUpdate; 
            }
        }
    }
}