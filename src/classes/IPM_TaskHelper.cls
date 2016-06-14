/**
    @Author: Cognizant Technology
    @Name: IPM_TaskHelper
    @CreateDate : Oct 2014
    @Description: Business helper class which processes on Tasks & assignments and also deal with team members etc
    @Version <1.0>
**/

public with sharing class IPM_TaskHelper { 
    
    public static Boolean SKIP_TRIGGER_EXECUTION = false;
    
    public static Id standardTaskId = Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(IPM_Utils.IPM_STANDARD_TASKS).getRecordTypeId();
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
       
        Map<Id,IPM_Project__c> incomingProjectMap = new Map<Id,IPM_Project__c>(incomingProjects);
        
        Map<Id,IPM_Project_Template__c> projectToProjectTemplateMap = new Map<Id,IPM_Project_Template__c>();
        Map<Id,Map<Id,IPM_Section__c>>  projectToTemplateSectionMap = new Map<Id,Map<Id,IPM_Section__c>>();
        
        Map<Id,IPM_Project_Document__c> projectTargetDocumentMap = new Map<Id,IPM_Project_Document__c>();
        Map<Id,List<IPM_Project_Document_Section__c>> projectDocumentToTargetSectionMap = new Map<Id,List<IPM_Project_Document_Section__c>>();
        Map<Id,list<IPM_Project_Resource__c>> projIdProjResListMap = new Map<Id,list<IPM_Project_Resource__c>>();
        
        Map<Id,List<IPM_Task__c>> currentProjectGateExistingTaskMap = new Map<Id,List<IPM_Task__c>>();
        Map<Id,List<IPM_Task__c>> previousProjectGateExistingTaskMap = new Map<Id,List<IPM_Task__c>>();
		
		Map<Id,List<IPM_Task__c>> projectToMasterTaskList = new  Map<Id,List<IPM_Task__c>>();
		Map<Id,List<IPM_Task__c>> projectToMasterFutureTasks = new Map<Id,List<IPM_Task__c>>();
		
		
		Map<Id,List<IPM_Task__c>> projectToNewTaskList = new Map<Id,List<IPM_Task__c>>();
		Map<Id,List<IPM_Task__c>> projectToNewFutureTaskList = new Map<Id,List<IPM_Task__c>>(); 
		
		// Get the Project and Document Template Based on the Gate Document.
		getStandardTaskTemplate(incomingProjectMap,projectToProjectTemplateMap,projectToTemplateSectionMap);
		
		getCurrentGateProjectDocumentInfo(incomingProjectMap,projectToDocumentMap,projectDocToSectionMap,projectTargetDocumentMap,projectDocumentToTargetSectionMap,projIdProjResListMap);
        
        // Get the Current and Previous Gate Specific tasks.
        getGateSpecificExistingTasks(incomingProjectMap,IPM_ProjectHelper.DBprojectSpecificTasksMap,currentProjectGateExistingTaskMap,previousProjectGateExistingTaskMap);
        
        /*Previous Gate Document Tasks Starts*/
        managePreviousGateExistingTasks(incomingProjectMap,previousProjectGateExistingTaskMap,deleteTaskMap);
        /*Previous Gate Document Tasks Ends*/
    
        /*Current Gate Document Tasks Starts*/
        manageCurrentGateTasks(incomingProjectMap,projectTargetDocumentMap,projectDocumentToTargetSectionMap,currentProjectGateExistingTaskMap);
        
        /*Current Gate Document Tasks Ends*/
        
        /* Current Gate Standard Task Starts */
        getTemplateSpecificTasks(incomingProjectMap,projectToProjectTemplateMap,projectToMasterTaskList);
        
        createNewTasksFromTemplates(incomingProjects,projectToMasterTaskList,projectTargetDocumentMap,projectDocumentToTargetSectionMap,projIdProjResListMap,IPM_ConstantUtils.STANDARD_TASKS,projectToNewTaskList);
        /* Current Gate Standard Task ends */
        
        
        /*Future Tasks Starts*/ 
        manageFutureAdhocTasks(incomingProjects,projectTargetDocumentMap,projectDocumentToTargetSectionMap,projIdProjResListMap,projectToMasterFutureTasks);
        
        createNewTasksFromTemplates(incomingProjects,projectToMasterFutureTasks,projectTargetDocumentMap,projectDocumentToTargetSectionMap,projIdProjResListMap,IPM_ConstantUtils.ADHOC,projectToNewFutureTaskList);
    
    	/*Future Tasks ends*/
		for(id projectId : projectToNewFutureTaskList.keySet())
		{
			upsertTaskList.addAll(projectToNewFutureTaskList.get(projectId));
		}
        for(IPM_Project__c project : incomingProjects.values()) 
        {
            if(IPM_ProjectHelper.projectMasterMap.containsKey(project.Id) && IPM_ProjectHelper.projectMasterMap.get(project.Id)!=null)
            {
                IPM_Project__c projectDetail = IPM_ProjectHelper.projectMasterMap.get(project.Id);
                
                // Get associated Project Type
                IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(projectDetail);
                
                Map<Id,IPM_Section__c> associatedTemplateSectionMap = projectToTemplateSectionMap.get(project.Id);
                
                // Validate whehter Approach is internal.If it is internal then only Manage Tasks for that project.    
                if(associatedProjectType!=null )
                {
                	List<IPM_Task__c> projectExistingCurrentGateTasks = currentProjectGateExistingTaskMap.get(project.Id);
                    List<IPM_Task__c> projectExsitingpreviousGateTasks = previousProjectGateExistingTaskMap.get(project.Id);
                    List<IPM_Task__c> newTaskList = new List<IPM_Task__c> ();
                        
                    // Master list of Tasks based on template
                    if(projectToNewTaskList != null && projectToNewTaskList.containsKey(project.Id))
                    {
                    	newTaskList = projectToNewTaskList.get(project.id);
                    }	
                   
                    manageTaskCopyOverKey(associatedTemplateSectionMap,projectDetail,projectExistingCurrentGateTasks,newTaskList,upsertTaskList);
                    
                    if(projectExistingCurrentGateTasks!=null && !projectExistingCurrentGateTasks.isEmpty())
                    {
                    	upsertTaskList.addAll(projectExistingCurrentGateTasks);
                    }
                    
                    if(projectExsitingpreviousGateTasks!=null && !projectExsitingpreviousGateTasks.isEmpty())
                    {
                    	upsertTaskList.addAll(projectExsitingpreviousGateTasks);
                    }
                    
                }
            }
        }
        
        upsertNotNullTasks(upsertTaskList,deleteTaskMap);            
        
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
                if(newTaskObj.IsSystemGenerated__c || IPM_ConstantUtils.STANDARD_TASKS.equalsIgnoreCase(newTaskObj.IPM_Type_of_Task__c) )
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
                else if(IPM_ConstantUtils.ADHOC.equalsIgnoreCase(newTaskObj.IPM_Type_of_Task__c))
                {
                	externalId = projectDetail.id +String.valueOf(newTaskObj.IPM_Master_Task__c);
                }
                else
                {
                	externalId = null;
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
    
 private static void getTypeOfTask(IPM_Task__c masterTask,IPM_Task__c newTask) 
 {
    if(masterTask.RecordTypeId == standardTaskId)
    {
        newTask.IsSystemGenerated__c = true;
        newTask.IPM_Type_of_Task__c = IPM_ConstantUtils.STANDARD_TASKS;
    } 
    else
    {
        newTask.IsSystemGenerated__c = false;
        newTask.IPM_Type_of_Task__c = IPM_ConstantUtils.ADHOC;
    }
 }
 
 private static void doTeamAssignment(IPM_Project__c projectRec,list<IPM_Project_Resource__c> projResList,IPM_Task__c masterTask,IPM_Task__c newTask)
 {
     // assign user to task depending upon existing team members
    if(projResList != null && !projResList.isEmpty())
    {
        for(IPM_Project_Resource__c projectResource : projResList)
        {
            if(projectResource.IPM_Role_Type__c!=null && projectResource.IPM_Role_Type__c.equalsIgnoreCase(masterTask.IPM_Function__c) && projectResource.IPM_Project_Role_Owner__c)
            {
                newTask.IPM_Assignee__c = projectResource.IPM_User__c; 
                break;
            }       
        }
    }
    // if no team member present for specific functional role assign task to PL
    else if(projectRec.IPM_Project_Leader__c != null && newTask.IPM_Assignee__c == null)
    {
        newTask.IPM_Assignee__c = projectRec.IPM_Project_Leader__c;
    }
    
 }
    
 /**************************************************************
    * @description: Create tasks when project created, phase changes, when user adds any section
    * @param1 projectList : project record list 
    * @param1 projIdToMasterTaskListMap : project and associated task list
    * @param1 projIdProjDocSecListMap : project and project document section list
    * @param1 projIdProjResListMap : project and project resource list
 */
 public  static void  createNewTasksFromTemplates(Map<Id,IPM_Project__c> incomingProjectMap ,Map<Id,list<IPM_Task__c>> projIdToMasterTaskListMap,Map<Id,IPM_Project_Document__c> projectTargetDocumentMap,Map<Id,List<IPM_Project_Document_Section__c>> projectDocumentToTargetSectionMap,Map<Id,list<IPM_Project_Resource__c>> projIdProjResListMap, String typeOfTask,Map<Id,List<IPM_Task__c>> projectToNewTaskList)
 { 
 	Map<Id,List<IPM_Task__c>> projectToClonedTaskList = new Map<Id,List<IPM_Task__c>>();

 	for(IPM_Project__c projectRec: incomingProjectMap.values())
 	{
 		list<IPM_Task__c> projectTaskList =  new list<IPM_Task__c> ();//project specific task
		list<IPM_Task__c> masterTaskList = projIdToMasterTaskListMap.get(projectRec.Id);//task master list 
		list<IPM_Project_Resource__c> projResList = projIdProjResListMap.get(projectRec.id);//project specific team member list
		
		for(IPM_Task__c masterTask : masterTaskList)
    	{
    		//iterating over the master task list and craete project specific task
        	IPM_Task__c newTask = new IPM_Task__c();
            newTask.IPM_Task_Name__c = masterTask.IPM_Task_Name__c;
            newTask.IPM_Project_Template__c = masterTask.IPM_Project_Template__c;
            newTask.IPM_Active__c = true;
            newTask.IPM_Task_Type__c = masterTask.IPM_Task_Type__c;
            newTask.IPM_Type_of_Gate__c = masterTask.IPM_Type_of_Gate__c;
            newTask.IPM_Phase__c = masterTask.IPM_Phase__c;
            newTask.IPM_Function__c = masterTask.IPM_Function__c;
            newTask.IPM_Version_Number__c = masterTask.IPM_Version_Number__c;
            newTask.IPM_Section__c = masterTask.IPM_Section__c;
            newTask.IPM_Master_Task__c = masterTask.Id;
            newTask.IPM_Task_Complexity__c = masterTask.IPM_Task_Complexity__c ; 
            newTask.IPM_Project__c = projectRec.Id;
            newTask.RecordTypeId = Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectTasks).getRecordTypeId();
            newTask.IPM_Task_Section_External_ID__c = masterTask.IPM_SectionExternalIDFormula__c;	
            
            
            
             if(masterTask.isPDLMile__c && projectRec.IPM_ProjectGKM__c=='GKM3'&& masterTask.IPM_Phase__c=='Feasibility'){
              newTask.IPM_Type_of_Gate__c=IPM_ConstantUtils.PRODUCT_DESIGN_LOCK;
              newTask.IPM_Section_Number__c=masterTask.PDLSetionNumber__c;
            }
            
            getTypeOfTask(masterTask,newTask);

         	Map<Id,IPM_Section__c> sectionDetailMap =  new Map<Id,IPM_Section__c>();
            
            if(masterTask.IPM_Section__c != NULL)
            {
            	//create section id section map for external id
            	newTask.IPM_Project_Document_Section__c = masterTask.IPM_Project_Document_Section__c;
            	sectionDetailMap.put(masterTask.IPM_Section__c,new IPM_Section__c(Id = masterTask.IPM_Section__c));
            }
            newTask.ExternalField__c = IPM_TaskHelper.generateTaskExternalId(newTask,projectRec,sectionDetailMap);
            
            doTeamAssignment(projectRec,projResList,masterTask,newTask);
            
			//insert active task if does not associated with ENVIRONMENTAL IMPACT SECTION SEQUENCE.If Associated check if its project type is not BLG.
			projectTaskList.add(newTask);
	 	}
    	
    	projectToClonedTaskList.put(projectRec.Id,projectTaskList);
 	}
 	
 	// Set Task Type as active By default for Handling complexity change.
 	setSectionWiseTaskVisibility(incomingProjectMap,projectTargetDocumentMap,projectDocumentToTargetSectionMap,projectToClonedTaskList);
 	
 	for(Id ProjectID : projectToClonedTaskList.keySet())
 	{

 		List<IPM_Task__c>  clonedTaskList = projectToClonedTaskList.get(ProjectID);
 		List<IPM_Task__c>  finalTaskList = new List<IPM_Task__c>();
 		
		IPM_Project__c projectRec = incomingProjectMap.get(ProjectID);
		
 		for(IPM_Task__c newTask : clonedTaskList)
 		{
 			if(newTask.IPM_Active__c 
				&& ((newTask.IPM_Section__c != null && newTask.IPM_Project_Document_Section__c != null) ||
					(newTask.IPM_Section__c == null && newTask.IPM_Project_Document_Section__c == null)) 
				&& (newTask.IPM_Master_Section_Sequence__c != IPM_ConstantUtils.ENVIRONMENTAL_IMPACT_SEQUENCE || 
					(newTask.IPM_Master_Section_Sequence__c.equalsIgnoreCase(IPM_ConstantUtils.ENVIRONMENTAL_IMPACT_SEQUENCE) && projectRec.IPM_ProjectSubType__c !=IPM_ConstantUtils.IPM_BLG)))
            {
           			finalTaskList.add(newTask);
        	}
 		}
		
 		if(!finalTaskList.isEmpty())
 		{
 			projectToNewTaskList.put(ProjectID,finalTaskList);
 		}
 	}
 }	
 /**************************************************************
    * @description: Associate task with proper project document section and if section is default, then make that task as active
    * @param1 ProjectToTaskListMap : project specific task
    * @param1 projectDocToSectionMap : project specific document section
    */
 public static void setSectionWiseTaskVisibility(Map<Id,IPM_Project__c> projectMap,Map<Id,IPM_Project_Document__c> projectToDocumentMap,Map<Id,List<IPM_Project_Document_Section__c>> projectDocToSectionMap,Map<Id,List<IPM_Task__c>> projectToTaskListMap)
 {
 	
 	for(Id projectId : projectMap.keySet())
 	{
 		List<IPM_Project_Document_Section__c> projectDocSectionList = new List<IPM_Project_Document_Section__c>();
 		//task list for project
 		List<IPM_Task__c> taskList =  ProjectToTaskListMap != null && !ProjectToTaskListMap.isEmpty() && ProjectToTaskListMap.containsKey(projectId) ? ProjectToTaskListMap.get(projectId) : new List<IPM_Task__c>();
 		if(projectToDocumentMap.containsKey(projectId) && projectToDocumentMap.get(projectId)!=null)
 		{
 			IPM_Project_Document__c projectDoc = projectToDocumentMap.get(projectId); 
 			projectDocSectionList = projectDocToSectionMap.containsKey(projectDoc.Id) ? projectDocToSectionMap.get(projectDoc.Id) : new List<IPM_Project_Document_Section__c>();
 		}
 		
 		IPM_Project__c projectDetail = projectMap.get(projectId);
		for(IPM_Task__c task : taskList)
 		{
 			if(task.IPM_Active__c)
 			{
 				if(task.IPM_Section__c != null)
	 			{
	 				Boolean complexityMatch = false;
	 				
	 				complexityMatch= checkComplexityMatch(projectDetail,task);
	 				  
	    			updateTaskSections(complexityMatch,task,projectDocSectionList);
	 			}
	 			else
	 			{
	 				if(task.IPM_Task_Type__c == IPM_ConstantUtils.TYPE_NEGOTIABLE) 
					{
						task.IPM_Active__c = false;
					} 
	 			}
 			}
 			makeNullDocumentSectionTaskInactive(task);
 		}
 	}
 }
 
 
 	/**************************************************************
    * @description: Copy over the global or regional future tasks to respective project
    * @param1 projectDetail : project
    * @param2 projectToDocumentMap : project specific document
    * @param3 projectDocToSectionMap : project specific document section
    */
    
 public static void  manageFutureAdhocTasks(Map<Id,IPM_Project__c> incomingProjects,Map<Id,IPM_Project_Document__c> projectToDocumentMap,Map<Id,List<IPM_Project_Document_Section__c>> projectDocToSectionMap,Map<Id,list<IPM_Project_Resource__c>> projIdFutureProjResListMap,Map<Id,List<IPM_Task__c>> projectSpecificFutureTasks)
 {
 	//Logic for future task copy over on the Regional or Local Projects
    
    Map<Id,IPM_Task__c> completeTasksMap = new Map<Id,IPM_Task__c>();
    
    for(IPM_Project__c projectDetail:incomingProjects.values())
    {
    	projectSpecificFutureTasks.put(projectDetail.Id,new List<IPM_Task__c>());
    	
    	// Get Parent Future Tasks 
    	if(IPM_ProjectHelper.childToParentProject.containsKey(projectDetail.Id) &&  IPM_ProjectHelper.childToParentProject.get(projectDetail.id) != null)
     	{
     		Id parentProject = IPM_ProjectHelper.childToParentProject.get(projectDetail.id);
     		List<IPM_Task__c> parentProjectTaskList = IPM_ProjectHelper.DBprojectSpecificTasksMap.get(parentProject);
     		if(parentProjectTaskList != null)
     		{
	     		Map<Id,IPM_Task__c> parentProjectTaskMap = new Map<Id,IPM_Task__c>(parentProjectTaskList);
	     		completeTasksMap.putAll(parentProjectTaskMap);
     		}	
     	
     		// Get Grand Parent Tasks 
    		if(IPM_ProjectHelper.childToParentProject.containsKey(parentProject) &&  IPM_ProjectHelper.childToParentProject.get(parentProject) != null)
	     	{
	     		Id grandParentProject = IPM_ProjectHelper.childToParentProject.get(parentProject);
	     		List<IPM_Task__c> grantParentProjectTaskList = IPM_ProjectHelper.DBprojectSpecificTasksMap.get(grandParentProject);
	     		if(grantParentProjectTaskList != null)
	     		{
		     		Map<Id,IPM_Task__c> grandParentProjectTaskMap = new Map<Id,IPM_Task__c>(grantParentProjectTaskList);
		     		completeTasksMap.putAll(grandParentProjectTaskMap);
	     		}	
	     	}
     	}
     	
    	IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(projectDetail);    
    	
     	if(!completeTasksMap.isEmpty())
     	{
     		for(IPM_task__c task : completeTasksMap.values())
     		{
     			// Get the Tasks whose Phase and Gate matches with the Project. Also make sure that project span matches with Task Span
     			if(task.IPM_Phase__c ==  projectDetail.IPM_Phase__c && task.IPM_Type_of_Gate__c == associatedProjectType.IPM_Gate_Document__c && task.IPM_TaskSpan__c == projectDetail.IPMProject_Span__c)
     			{
     				// If the Task is not completed, it means it is eligible for Copy Over to child projects.
 					if(!task.IPM_Completed__c  && task.IPM_Type_of_Task__c == IPM_ConstantUtils.FUTURE_ADHOC_TASKS)
 					{
 						IPM_Project_Document__c gateSpecificDocument = projectToDocumentMap.get(projectDetail.id);
 						if(gateSpecificDocument !=null)
 						{
 							projectSpecificFutureTasks.get(projectDetail.Id).add(task);
 						}
 					}
     			}
     		}
     	}
    }
 }
 
 
 	/**************************************************************
    * @description: Get the standard template for standard tasks
    * @param1 incomingProjectMap : project
    * @param2 projectToProjectTemplateMap : project specific template
    * @param3 projectToTemplateSectionMap : project specific section
    */
    
 	public static void getStandardTaskTemplate(Map<Id,IPM_Project__c> incomingProjectMap,Map<Id,IPM_Project_Template__c> projectToProjectTemplateMap,Map<Id,Map<Id,IPM_Section__c>> projectToTemplateSectionMap)
 	{
 		for(IPM_Project__c project : incomingProjectMap.values())
	 	{
	 		IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(project);
	 		String projectCurrentGate = null;
	 		// Get the Project Gate and Phase. 
	 		if(associatedProjectType != null)
	 		{
	 			projectCurrentGate = associatedProjectType.IPM_Gate_Document__c;
	 		}	
	 		
	 		
	 		if(!String.isblank(project.IPM_Complexity__c) )
	 		{
	 			for(IPM_Project_Template__c template : IPM_ProjectHelper.complexityTemplateMap.values())
			    {
			    	// Check for Complexity,Project Type and Category Match 
			        if(template.IPM_Template_Complexity__c.equalsIgnoreCase(project.IPM_Complexity__c) && 
			            IPM_ProjectHelper.complexitySpecificTaskMap.containsKey(template.Id) && IPM_ProjectHelper.complexitySpecificTaskMap.get(template.Id)!=null && 
			            !String.isBlank(project.IPM_SourceProjectType__c) && !String.isBlank(template.IPM_Project_Type__c) && project.IPM_SourceProjectType__c == template.IPM_Project_Type__c && 
			            !String.isBlank(project.IPM_Category_Text__c) && !String.isBlank(template.IPM_Category__c) &&  template.IPM_Category__c.contains(project.IPM_Category_Text__c) )
			        {   
			        	// Store the Associated Project Template.
			        	projectToProjectTemplateMap.put(project.Id,template);
			            
			            if(IPM_ProjectHelper.complexitySpecificDocumentTemplates.containsKey(template.Id))
			            {
			            	for(IPM_Document_Template__c docTemplate : IPM_ProjectHelper.complexitySpecificDocumentTemplates.get(template.Id))
		                    {
		                        // If project Gate Matches Document Type Gate, Get the corresponding document Template and associated Sections 
		                        if(projectCurrentGate!=null && projectCurrentGate == docTemplate.IPM_Document_Type__c)
		                        {
		                             if(IPM_ProjectHelper.documentTemplateSpecificSectionMap.containsKey(docTemplate.Id) && IPM_ProjectHelper.documentTemplateSpecificSectionMap.get(docTemplate.Id)!=null)
		                             {
		                                List<IPM_Section__c> associatedDocumentSections = IPM_ProjectHelper.documentTemplateSpecificSectionMap.get(docTemplate.Id);
		                                if(!projectToTemplateSectionMap.containsKey(project.Id))
		                                {
		                                	projectToTemplateSectionMap.put(project.Id,new Map<Id,IPM_Section__c>());
		                                }
		                                // store the associated sections based on Gate Document
		                                projectToTemplateSectionMap.get(project.Id).putAll(new Map<Id,IPM_Section__c>(associatedDocumentSections));         
		                             } 
		                             break;
		                        }
		                    }
			            }
			            break;
			        }   
			    }
	 		
	 		}
	 	}
 	}
 
 /**************************************************************
    * @description: Get the project document info based on gate
    * @param1 incomingProjectMap : project
    * @param2 projectToDocumentMap : project specific document
    * @param3 projectDocumentToSectionMap : project specific document section
   * @param3 projIdProjResListMap : project specific resource
    */
 	public static void getCurrentGateProjectDocumentInfo(Map<Id,IPM_Project__c> incomingProjectMap,Map<Id,Map<String,IPM_Project_Document__c>> projectToDocumentMap,Map<Id,List<IPM_Project_Document_Section__c>> projectDocumentToSectionMap,Map<Id,IPM_Project_Document__c> projectTargetDocumentMap,Map<Id,List<IPM_Project_Document_Section__c>> projectDocumentToTargetSectionMap,Map<Id,list<IPM_Project_Resource__c>> projIdProjResListMap)
 	{
	 	for(IPM_Project__c project : incomingProjectMap.values())
	 	{
	 		IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(project);
	 		
	 		projIdProjResListMap.put(project.id,new list<IPM_Project_Resource__c>());
	 		IPM_Project_Document__c targetProjectDocument = null;
	 		
	 		// Validate whehter Approach is internal.If it is internal then only Manage Tasks for that project.    
			if(associatedProjectType!=null )
			{
			    // Project Current Phase and Gate
			    String projectCurrentGate = associatedProjectType.IPM_Gate_Document__c;
		                    
				if(projectCurrentGate!=null && String.isNotBlank(projectCurrentGate))
			    {
			        // From the newly Processed List of Project Document Template and Project Document Sections, get the currentPhase Document .
			        if(projectToDocumentMap.containsKey(project.Id) && projectToDocumentMap.get(project.Id)!=null)
			        {
			            Map<String,IPM_Project_Document__c> gateSpecificDocumentMap = projectToDocumentMap.get(project.Id);
			            if(gateSpecificDocumentMap.containsKey(projectCurrentGate) && gateSpecificDocumentMap.get(projectCurrentGate)!=null)
			            {
			                targetProjectDocument = gateSpecificDocumentMap.get(projectCurrentGate);
			                projectTargetDocumentMap.put(project.Id,targetProjectDocument);
			                
			                if(IPM_ProjectHelper.DBprojectSpecificResourceMap.containsKey(project.Id) && 
			               	IPM_ProjectHelper.DBprojectSpecificResourceMap.get(project.Id)!=null )
				            {
				                	projIdProjResListMap.put(project.id,IPM_ProjectHelper.DBprojectSpecificResourceMap.get(project.Id));
				            }
			            
			                if(projectDocumentToSectionMap.containsKey(targetProjectDocument.Id) && projectDocumentToSectionMap.get(targetProjectDocument.Id)!=null)
			                {
			                    List<IPM_Project_Document_Section__c> targetProjectDocSectionList = projectDocumentToSectionMap.get(targetProjectDocument.Id);
			                    projectDocumentToTargetSectionMap.put(targetProjectDocument.Id,targetProjectDocSectionList);			                    
			                }
			            }
			        }
		     	}
			}	
	 	}
 	}
 	
 	/**************************************************************
    * @description: Get the tasks specific to gate document
    * @param1 incomingProjectMap : project
    * @param2 projectToDocumentMap : project specific document
    * @param3 projectDocumentToSectionMap : project specific document section
   * @param3 projIdProjResListMap : project specific resource
    */
 	public static void getGateSpecificExistingTasks(Map<Id,IPM_Project__c> incomingProjectMap,Map<Id,List<IPM_Task__c>> projectSpecificTasks,Map<Id,List<IPM_Task__c>> currentGateExistingTaskMap,Map<Id,List<IPM_Task__c>> previousGateExistingTaskMap)
 	{
 		
 		for(IPM_Project__c project : incomingProjectMap.values())
 		{
 			IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(project);
			String projectCurrentGate = null ;
			
			// Project Current Phase and Gate
 			if(associatedProjectType != null)
 			{
            	projectCurrentGate = associatedProjectType.IPM_Gate_Document__c;
 			}
 			
 			// Get Previous Phases and validate whether the tasks associated with previous Phases are closed or not.
            List<IPM_Project_Type__c> previousPhasesList = IPM_Utils.getPreviousPhases(associatedProjectType,true);
            
            Set<String> previousPhases = new Set<String>();
        
            for(IPM_Project_Type__c projectType : previousPhasesList)
            {
                previousPhases.add(projectType.IPM_Phase__c);
            }
                    
                     
 			List<IPM_Task__c> existingTasks = projectSpecificTasks.get(project.Id);
 			
 			if(existingTasks!=null)
 			{
 				for(IPM_Task__c task : existingTasks)
	 			{
					// If the Task gate is same as Project Gate & task span(Standard tasks) is blank = It is an existing Gate Task.
					// If the Task gate is same as Project Gate & task span is not blank and equal to Gate Tasks(Future Tasks) = It is an existing Gate Task.
	 				if(!String.isBlank(task.IPM_Type_of_Gate__c) && !String.isBlank(projectCurrentGate) && task.IPM_Type_of_Gate__c.containsIgnoreCase(projectCurrentGate))
	 				{
	 					if(String.isBlank(task.IPM_TaskSpan__c) || ( task.IPM_TaskSpan__c == project.IPMProject_Span__c ) )
	 					{ 
		 					if(!currentGateExistingTaskMap.containsKey(project.Id))
		 					{
		 						currentGateExistingTaskMap.put(project.Id,new List<IPM_Task__c>());
		 					}
		 					currentGateExistingTaskMap.get(project.Id).add(task);
	 					}
	 				}
	 				else if(previousPhases.contains(task.IPM_Phase__c))
	 				{
	 					if(!previousGateExistingTaskMap.containsKey(project.Id))
	 					{
	 						previousGateExistingTaskMap.put(project.Id,new List<IPM_Task__c>());
	 					}
	 					previousGateExistingTaskMap.get(project.Id).add(task);
	 				}
	 			}
 			}	
 		}
 		
 	}
 	
 	// Check if task phase belongs to an Old Phase and is not complete. If yes update the Complete flag as true;
	// Check if the project is archieved then mark tasks as complete.
	// Only mark active tasks as complete. 
	                        
 	public static void managePreviousGateExistingTasks(Map<Id,IPM_Project__c> incomingProjectMap, Map<Id,List<IPM_Task__c>> previousProjectGateExistingTaskMap,Map<Id,IPM_Task__c> deleteTaskMap)
    {
    	for(IPM_Project__c project : incomingProjectMap.values())
    	{
    		IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(project);
 
    		List<IPM_Project_Type__c> previousPhasesList = IPM_Utils.getPreviousPhases(associatedProjectType,true);
    		
    		Set<String> previousPhases = new Set<String>();
        
            for(IPM_Project_Type__c projectType : previousPhasesList)
            {
                previousPhases.add(projectType.IPM_Phase__c);
            }
            
    		if(previousProjectGateExistingTaskMap.containsKey(project.Id) && previousProjectGateExistingTaskMap.get(project.Id)!=null)
    		{
    			List<IPM_Task__c> previousGateTasks = previousProjectGateExistingTaskMap.get(project.Id);
    			for(IPM_Task__c existingTask : previousGateTasks)
    			{
    				// During Phase change, any tasks which are not completed and belongs to the previous Phase, System would mark them as complete.
		    		if(existingTask.IPM_Completed__c !=null && existingTask.IPM_Phase__c!=null && !existingTask.IPM_Completed__c && 
		        	existingTask.IPM_Active__c && previousPhases.contains(existingTask.IPM_Phase__c)  )
			        {
			            existingTask.IPM_Completed__c = true;
			            existingTask.IPM_AutoCompletedBySystem__c = true;
			        }
    			}
    		}
    	}
    }
    
    /**************************************************************
    * @description: Get the project document info based on gate
    * @param1 incomingProjectMap : project
    * @param2 projectTargetDocumentMap : project specific document
    * @param3 projectDocumentToTargetSectionMap : project specific document section
   * @param3 currentProjectGateExistingTaskMap : current project tasks
    */
    public static void  manageCurrentGateTasks(Map<Id,IPM_Project__c>  incomingProjectMap,Map<Id,IPM_Project_Document__c> projectTargetDocumentMap,Map<Id,List<IPM_Project_Document_Section__c>>  projectDocumentToTargetSectionMap,Map<Id,List<IPM_Task__c>> currentProjectGateExistingTaskMap)
    {
    	for(IPM_Project__c project : incomingProjectMap.values())
    	{
    		if(currentProjectGateExistingTaskMap.containsKey(project.Id) && currentProjectGateExistingTaskMap.get(project.Id)!=null)
    		{
    			List<IPM_Task__c> currentGateTasks = currentProjectGateExistingTaskMap.get(project.Id);
    			for(IPM_Task__c currentGateTask : currentGateTasks)
    			{
    				// Check if project Complexity matches with Tasks. If not mark them as inactive. 
    				// Only for standard tasks as new tasks are getting created as part of template.
				    
				    if(project.IPM_Complexity__c != currentGateTask.IPM_Task_Complexity__c)
				    {
				    	// Make tasks as inactive if it is a standard Task. New Tasks would be created from Full Template .
				    	if(String.isNotBlank(currentGateTask.IPM_Task_Complexity__c) && 
				    		(currentGateTask.IsSystemGenerated__c || currentGateTask.IPM_Type_of_Task__c == IPM_ConstantUtils.STANDARD_TASKS ) )
				    	{
				    		currentGateTask.IPM_Active__c = false;	
				    	}	
				    }
				    
			     	
			     	if(IPM_ConstantUtils.FUTURE_STANDARD_TASKS.equalsIgnoreCase(currentGateTask.IPM_Type_of_Task__c))
	    			{
	    				currentGateTask.IPM_Type_of_Task__c = IPM_ConstantUtils.STANDARD_TASKS;
	    			}
	    			else if(IPM_ConstantUtils.FUTURE_ADHOC_TASKS.equalsIgnoreCase(currentGateTask.IPM_Type_of_Task__c))
	    			{
	    				// Since Future Adhoc can contain Multiple Span Tasks, we need to merge only the one that matches with Project Span.
	    				currentGateTask.IPM_Type_of_Task__c = IPM_ConstantUtils.ADHOC;
	    			}  
    			}
    		}
    		 
    	}
    	
    	// If there are active Tasks which are not associated with Sections and are from the Current Gate Document, Set visibility for those Tasks. 
    	setSectionWiseTaskVisibility(incomingProjectMap,projectTargetDocumentMap,projectDocumentToTargetSectionMap,currentProjectGateExistingTaskMap); 
    }
    
    /**************************************************************
    * @description: Get the template specific tasks
    * @param1 incomingProjectMap : project
    * @param2 projectToProjectTemplateMap : project specific document
    * @param3 projectToMasterTaskList : project specific document section
    */
    public static void getTemplateSpecificTasks(Map<Id,IPM_Project__c>  incomingProjectMap,Map<Id,IPM_Project_Template__c> projectToProjectTemplateMap, Map<Id,List<IPM_Task__c>> projectToMasterTaskList)
    {
    	for(IPM_Project__c project : incomingProjectMap.values())
    	{
    		IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(project);

 			// Project Current Phase and Gate
            String projectCurrentPhase = associatedProjectType.IPM_Phase__c;
            
    		List<IPM_Task__c> masterTaskList = new List<IPM_Task__c>();
    		
    		if(projectToProjectTemplateMap.containsKey(project.Id))
    		{
    			IPM_Project_Template__c projectTemplate = projectToProjectTemplateMap.get(project.Id);
    			// Get standard Tasks based on Complexity and Phase. 
		        for(IPM_Task__c task : IPM_ProjectHelper.complexitySpecificTaskMap.get(projectTemplate.Id))
		        {
		            // Validate record Types for Template tasks should be equal to master Record Type and Phase should be same.
		            if(task.RecordTypeId == IPM_ProjectHelper.taskMasterRecordType && !String.isBlank(task.IPM_Phase__c) && task.IPM_Phase__c.equalsIgnoreCase(projectCurrentPhase))
		            {
		            	
		            	// By Default make template specific Tasks as active.        	
		                masterTaskList.add(task);
		            }
		        }	
    		}
			
			projectToMasterTaskList.put(project.Id,masterTaskList);
    	}
    	
    }
    
   
   /**************************************************************
    * @description: Update teh task copy over key
    * @param1 associatedTemplateSectionMap : project
    * @param2 projectDetail : current project tasks
    * @param3 projectExistingCurrentGateTasks : previous gate project tasks
    */
   	private static void manageTaskCopyOverKey(Map<Id,IPM_Section__c> associatedTemplateSectionMap,IPM_Project__c projectDetail,List<IPM_Task__c> projectExistingCurrentGateTasks,List<IPM_Task__c> newTaskList,List<IPM_Task__c> upsertTaskList)
	{
	  if(newTaskList != null)
	  {
		for(IPM_Task__c newTask :newTaskList)
        {
            String associatedSectionNumber = IPM_ConstantUtils.BLANK;
            
	        IPM_Section__c sec = new IPM_Section__c(Id=newTask.IPM_Section__c);
	        
	        String associatedExternalId = IPM_TaskHelper.generateTaskExternalId(newTask,projectDetail,new Map<Id,IPM_Section__c>{sec.Id => sec});
	        
	        if(associatedTemplateSectionMap!=null && !associatedTemplateSectionMap.isEmpty() && associatedTemplateSectionMap.containsKey(newTask.IPM_Section__c) )
	        {
	            associatedSectionNumber = associatedTemplateSectionMap.get(newTask.IPM_Section__c).IPM_Section_Sequence__c;
	        }

        	if(projectExistingCurrentGateTasks !=null)
	        {
	        	// Perform Copy over from existing Tasks to the new Task.
	        	performTaskCopyOver(newTask,associatedSectionNumber,projectExistingCurrentGateTasks);
	        	
	        	for(Integer taskCounter=0;taskCounter< projectExistingCurrentGateTasks.size();taskCounter++)
	            {
	            	IPM_Task__c existingTask =  projectExistingCurrentGateTasks.get(taskCounter);
	            	
	                // If external Id matches on existing Tasks update the Id on the new to point to the old task.
	                if( (existingTask.IsSystemGenerated__c || existingTask.IPM_Type_of_Task__c == IPM_ConstantUtils.STANDARD_TASKS) && associatedExternalId == existingTask.ExternalField__c)
	                {
	                    newTask.Id = existingTask.Id;
	                    // Once the Task has been mapped to the existing Task, remove it from the List of current tasks.
	                    projectExistingCurrentGateTasks.remove(taskCounter);
	                    break;
	                }
	            }
	        
	        	
	        }        	
      		upsertTaskList.add(newTask);  
        }
        }
    }
    
    private static void performTaskCopyOver(IPM_Task__c newTask,String associatedSectionNumber,List<IPM_Task__c> projectExistingCurrentGateTasks)
    {
    	String newTaskCopyOverKey = getTaskCopyOverKey(newTask,associatedSectionNumber);
    	
    	for(IPM_Task__c existingTask : projectExistingCurrentGateTasks)
        {
            String existingTaskCopyOverKey = IPM_ConstantUtils.BLANK;
            
            existingTaskCopyOverKey = getTaskCopyOverKey(newTask,null);
            
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
	            
    }
    
    
    /**************************************************************
    * @description: Get the task copy over key
    * @param2 task : current project tasks
    * @param3 associatedSectionNumber : previous gate project tasks
    */
    private static String getTaskCopyOverKey(IPM_Task__c task,String associatedSectionNumber){
    	
      String taskCopyOverKey;		
	  if(!String.isBlank(associatedSectionNumber))
        {
            taskCopyOverKey = task.IPM_Phase__c + associatedSectionNumber + task.IPM_Function__c + task.IPM_Task_Name__c;
        }
            
	    else if(task.IPM_Section__c!=null)
        {
            taskCopyOverKey = task.IPM_Phase__c + task.IPM_Master_Section_Sequence__c + task.IPM_Function__c + task.IPM_Task_Name__c;
        }
        else
        {
            taskCopyOverKey = task.IPM_Phase__c + task.IPM_Function__c + task.IPM_Task_Name__c;
        }   
    	
    	return taskCopyOverKey;
    }
    
    /**************************************************************
    * @description: Upsert the not null tasks
    * @param1 upsertTaskList : project
    * @param2 deleteTaskMap : current project tasks
    */
    private static void upsertNotNullTasks( List<IPM_Task__c> upsertTaskList,Map<Id,IPM_Task__c> deleteTaskMap)
    {
		if(upsertTaskList!=null && !upsertTaskList.isEmpty())
	    {
	    	List<IPM_Task__c> finalUpsertList = new List<IPM_Task__c>();
	    	for(IPM_Task__c task : upsertTaskList)
	    	{
	    		if(!deleteTaskMap.containsKey(task.Id))
	    		{
	    			finalUpsertList.add(task);
	    		}
	    	}
	        upsert finalUpsertList ;
	    }
    }
    
    /**************************************************************
    * @description: Update the corresponding project document sections
    * @param1 complexityMatch 
    * @param2 task : current project tasks
    * @param3 projectDocSectionList : project document sections
    */
 private static void updateTaskSections(Boolean complexityMatch,IPM_Task__c task ,List<IPM_Project_Document_Section__c> projectDocSectionList){
 	
 	if(complexityMatch ||String.isBlank(task.IPM_Task_Complexity__c))
		{
			for(IPM_Project_Document_Section__c projectDocSection : projectDocSectionList)
    		{
    			if(task.IPM_Section__c == projectDocSection.IPM_Section__c)
    			{
    				task.IPM_Project_Document_Section__c = projectDocSection.Id;
    				task.IPM_Active__c = projectDocSection.IPM_Default_Section__c;
    				break;
    			}
    		}
   	    }  
		else
		{
			for(IPM_Project_Document_Section__c projectDocSection : projectDocSectionList)
    		{
    			if(task.IPM_Task_Section_External_ID__c == projectDocSection.IPM_Master_Section_External_Id__c)
    			{	
    				task.IPM_Project_Document_Section__c = projectDocSection.Id;
    				task.IPM_Active__c = projectDocSection.IPM_Default_Section__c;
    				break;
    			}
    		}
    	}
  }
  
  /**************************************************************
    * @description: Check the complexity matching of task and project
    * @param1 projectDetail : project
    * @param2 task : current tasks
    */
  private static Boolean checkComplexityMatch(IPM_Project__c projectDetail,IPM_Task__c task){
  	Boolean complexityMatch;
  	// If complexity doesnt match,remove project document section lookup.
 	 if(projectDetail.IPM_Complexity__c == task.IPM_Task_Complexity__c)
	 {
	 	complexityMatch = true;	
	 }
	 else
 	{
 		// Set the Project Document Section as null to assign new Project Document Section
 	    task.IPM_Project_Document_Section__c = null;
 		// Set the complexity as project complexity.
 		task.IPM_Task_Complexity__c  = projectDetail.IPM_Complexity__c;
 		complexityMatch = false;	
 	}
 	return complexityMatch;
  }
    
  /**************************************************************
    * @description: Make task inactive if document section is null 
    * @param1 task : task
    */
  private static void makeNullDocumentSectionTaskInactive(IPM_Task__c task){
  	if(task.IPM_Active__c && task.IPM_Section__c != null && task.IPM_Project_Document_Section__c == null)
 	 {
 		task.IPM_Active__c = false;
 	}
  }  
    
 
}