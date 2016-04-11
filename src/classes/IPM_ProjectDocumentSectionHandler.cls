/****************************************************************************************************************************************
* @Autor Cognizant
* @Created Date date 29/07/2015
* @Description Trigger Handler for the IPM Project Document Section SObject. This class implements the ITrigger
               interface to help ensure the trigger code is bulkified and all in one place.
               */

public with sharing class IPM_ProjectDocumentSectionHandler implements ITrigger
{   
    // In case of complexity change and transaction management, it would be done as part of task creation and task update.
    // So in those scenario's it would be skipped.
    public static Boolean SKIP_SECTION_TASK_ASSOCIATION = false;
    
    // Query result limit
    private static final String LIMIT_CLAUSE_STR = ' LIMIT 50000 '; 
    // Constructor
    public IPM_ProjectDocumentSectionHandler()
    {
        ExceptionLoggingHelper.initializeExceptionLog();
    }
    
    
    // Newly created Task List for Project
    @TestVisible
    private List<IPM_Task__c> upsertTaskList = new List<IPM_Task__c>();
    
    // Adhoc Task list for deletion
    @TestVisible
    private List<IPM_Task__c> deleteAdhocTaskList = new List<IPM_Task__c>();
     
    // Adhoc Task list for Insertion
    @TestVisible 
    private List<IPM_Task__c> insertAdhocTaskList = new List<IPM_Task__c>(); 
    
    @TestVisible
    private static Map<Id,List<IPM_Project_Document_Section__c>> projectDocToSectionMap = new Map<Id,List<IPM_Project_Document_Section__c>>();
    /***********************************************************************************************************************************
    * bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){ 
        //This method has been included as the class implements the ITrigger interface
        
    }
    /***********************************************************************************************************************************
    * bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter()
    {
        
        Set<Id> addedSectionRelatedTempaltes = new Set<Id>(); 
        
        // Project id to project map
        Map<Id,IPM_Project__c> projectMap ;
        
        // Project id to Project  Document map 
        Map<Id,IPM_Project_Document__c> projectToDocumentMap = new Map<Id,IPM_Project_Document__c>();
        
        //  Project Id and set of Selected sections set map
        Map<Id,List<IPM_Project_Document_Section__c>> projectToAddedSectionMap = new Map<Id,List<IPM_Project_Document_Section__c>>();
             
        //  Project Id and set of unselected sections set map
        Map<Id,List<IPM_Project_Document_Section__c>> projectToRemovedSectionMap = new Map<Id,List<IPM_Project_Document_Section__c>>();
      
        Map<Id,List<IPM_Task__c>> sectionBasedMasterTasks = new Map<Id,List<IPM_Task__c>>();
        
        // Project Id and List of IPM Project Document Section Object Map    
        Map<Id,List<IPM_Task__c>> projectDocSectionToTaskMap = new Map<Id,List<IPM_Task__c>>(); 
        
        // Project Id and List of IPM Project Resource Map    
        Map<Id,List<IPM_Project_Resource__c>> projectToResourceMap = new Map<Id,List<IPM_Project_Resource__c>>(); 
        
        // Project Id and List of IPM Task Map    
        Map<Id,List<IPM_Task__c>> projectToTaskMap = new Map<Id,List<IPM_Task__c>>();
        
        if(Trigger.isUpdate)
        {
            
            Map<Id,IPM_Project_Document_Section__c> newProjectDocSectionMap = (Map<Id,IPM_Project_Document_Section__c>)Trigger.NewMap;
            Map<Id,IPM_Project_Document_Section__c> oldProjectDocSectionMap = (Map<Id,IPM_Project_Document_Section__c>)Trigger.OldMap;
            
            for(IPM_Project_Document_Section__c sec : newProjectDocSectionMap.values())
            {
                // If the Section Default Value has changed
                if(!SKIP_SECTION_TASK_ASSOCIATION && sec.IPM_Default_Section__c != oldProjectDocSectionMap.get(sec.id).IPM_Default_Section__c)
                {
                    // If the new Default Section Value is true
                    if(sec.IPM_Default_Section__c) 
                    {
                        // Get the list of Project Templates for which Section is added by User.
                        addedSectionRelatedTempaltes.add(sec.IPM_ProjectTemplate__c);
                        
                        if(projectToAddedSectionMap.containsKey(sec.IPM_Project_ID__c) && projectToAddedSectionMap.get(sec.IPM_Project_ID__c)!=null )
                        {
                            projectToAddedSectionMap.get(sec.IPM_Project_ID__c).add(sec);
                        }
                        else
                        {
                            projectToAddedSectionMap.put(sec.IPM_Project_ID__c,new List<IPM_Project_Document_Section__c>{sec});
                        }
                    }
                    else
                    {
                        if(projectToRemovedSectionMap.containsKey(sec.IPM_Project_ID__c) && projectToRemovedSectionMap.get(sec.IPM_Project_ID__c)!=null )
                        {
                            projectToRemovedSectionMap.get(sec.IPM_Project_ID__c).add(sec); 
                        }
                        else
                        {
                            projectToRemovedSectionMap.put(sec.IPM_Project_ID__c,new List<IPM_Project_Document_Section__c>{sec});
                        }
                    }
                }       
            }
        }
        
		// If project document section has been added or Removed
        if(!projectToAddedSectionMap.isEmpty() || !projectToRemovedSectionMap.isEmpty())
        {

            // Get List of Master Tasks associated with the Sections Added.
            List<IPM_Task__c> masterTasks = [SELECT Id,IPM_Task_Name__c,IPM_Task_Type__c,IPM_Type_of_Gate__c,IPM_Phase__c,IPM_Function__c,IPM_Version_Number__c,
                                                IPM_Section__c,IPM_Master_Task__c,IPM_Task_Complexity__c,IPM_Project_Document_Section__c,IPM_Is_Master__c,
                                                IPM_Project_Template__c, IPM_Active__c,ExternalField__c,IPM_Master_Section_Name__c,IPM_Master_Section_Sequence__c,IPM_Assignee__c,
                                                IsSystemGenerated__c,RecordTypeId,IPM_Type_of_Task__c,IPM_SectionExternalIDFormula__c
                                                FROM IPM_Task__c 
                                                WHERE (IPM_Project_Template__c in :addedSectionRelatedTempaltes and IPM_Is_Master__c = true) 
                                                OR (IPM_Project__c in :projectToRemovedSectionMap.keySet() )  LIMIT 50000];
                                                
             
            for(IPM_Task__c task : masterTasks)
            {
                if(task.IPM_Is_Master__c)
                {
                	if( task.IPM_Section__c!=null)
                	{
	                    if(sectionBasedMasterTasks.containsKey(task.IPM_Section__c) && sectionBasedMasterTasks.get(task.IPM_Section__c)!=null )
	                    {
	                        sectionBasedMasterTasks.get(task.IPM_Section__c).add(task);
	                    }
	                    else
	                    {
	                        List<IPM_Task__c> temporaryTaskList = new List<IPM_Task__c>{task};
	                        sectionBasedMasterTasks.put(task.IPM_Section__c,temporaryTaskList);
	                    }
                	}
                }
                else
                {
                    if(projectDocSectionToTaskMap.containsKey(task.IPM_Project_Document_Section__c) &&  projectDocSectionToTaskMap.get(task.IPM_Project_Document_Section__c)!=null )
                    {
                        projectDocSectionToTaskMap.get(task.IPM_Project_Document_Section__c).add(task);
                    }
                    else
                    {
                        List<IPM_Task__c> associatedTaskList = new List<IPM_Task__c>{task};
                        projectDocSectionToTaskMap.put(task.IPM_Project_Document_Section__c,associatedTaskList);    
                    }   
                }
            }
        }
       
        // Logic for Adding Tasks based on Added Sections by user.
        if(!projectToAddedSectionMap.isEmpty())
        {    
        	// Project Id to Master future tasks
        	Map<Id,List<IPM_Task__c>> projectToMasterFutureTasks = new Map<Id,List<IPM_Task__c>>();
        	

        	Map<Id,List<IPM_Task__c>> projectNewTaskMap = new Map<Id,List<IPM_Task__c>>();
        	Map<Id,List<IPM_Task__c>> projectToNewFutureTaskList = new Map<Id,List<IPM_Task__c>>();
       		
       		// Projects Id set 
            Set<Id> associatedProjectAddedSecIds = projectToAddedSectionMap.keySet();
            
            String projectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',true,new Set<String>{'IPM_Project_Resource__c'},false);
            String projectWhereClause = ' WHERE Id IN: associatedProjectAddedSecIds '+LIMIT_CLAUSE_STR;

            String projectSelectString = projectQuery + projectWhereClause;
  
            projectMap = new map<Id,IPM_Project__c>((List<IPM_Project__c>) database.query(projectSelectString));
            
            String projectDocumentQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Document__c',true,new Set<String>{'IPM_Project_Document_Section__c'},false);
            String projectDocumentWhereClause = ' WHERE IPM_Project__c IN: associatedProjectAddedSecIds '+LIMIT_CLAUSE_STR;
            
            String projectDocumentSelectString = projectDocumentQuery + projectDocumentWhereClause;
            
            Map<Id,IPM_Project_Document__c> projectDocumentMap = new Map<Id,IPM_Project_Document__c>( (List<IPM_Project_Document__c>) database.query(projectDocumentSelectString) );
        	
        	for(IPM_Project__c project : projectMap.values())
        	{
        		projectToResourceMap.put(project.Id,project.IPM_Project_Resources__r);
        		
    		  	//task that are to be inserted when asociated section is added
                List<IPM_Task__c> associatedMasterTaskList =  new List<IPM_Task__c>();
                
                //project document section that are added by user
                for(IPM_Project_Document_Section__c projectSection : projectToAddedSectionMap.get(project.Id))
                {
                    // check if there are any corresponding Master Tasks associated with the section.
                    if(sectionBasedMasterTasks.containsKey(projectSection.IPM_Section__c))
                    {
                        associatedMasterTaskList.addall(sectionBasedMasterTasks.get(projectSection.IPM_Section__c));
                    }    
                }
                
                // map all the master task that need to be inserted as the associated section is inserted by user
                projectToTaskMap.put(project.Id,associatedMasterTaskList);
        		
        	}
			// Create map of Project document project id to project document 
			// create map of project document id to project doc section 
        	for(IPM_Project_Document__c projectDoc : projectDocumentMap.values())
            {
            	IPM_Project__c associatedProject = projectMap.get(projectDoc.IPM_Project__c);
            	IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(associatedProject);
		 		String projectCurrentGate = associatedProjectType.IPM_Gate_Document__c;

		 		if(projectCurrentGate == projectDoc.IPM_GateDocuments__c)
		 		{
		 			projectToDocumentMap.put(projectDoc.IPM_Project__c,projectDoc);
		 			projectDocToSectionMap.put(projectDoc.Id,projectDoc.IPM_Project_Sections__r);
		 		}
            }

            IPM_ProjectHelper.initializeProjectDetail(projectMap);
            IPM_ProjectHelper.initializeTasks();
            
            // Create standard tasks from of each project wise  
            IPM_TaskHelper.createNewTasksFromTemplates(projectMap,projectToTaskMap,projectToDocumentMap,projectDocToSectionMap,projectToResourceMap,IPM_ConstantUtils.STANDARD,projectNewTaskMap);
            
            // Get futute Ad hoc tasks for each project wise
            IPM_TaskHelper.manageFutureAdhocTasks(projectMap,projectToDocumentMap,projectDocToSectionMap,projectToResourceMap,projectToMasterFutureTasks);
        	
        	// Create future  Ad hoc task 
        	IPM_TaskHelper.createNewTasksFromTemplates(projectMap,projectToMasterFutureTasks,projectToDocumentMap,projectDocToSectionMap,projectToResourceMap,IPM_ConstantUtils.ADHOC,projectToNewFutureTaskList);
            
            
            //add all project's task in list to insert
            for(Id projectId :  projectNewTaskMap.keyset())
            {
            	upsertTaskList.addAll(projectNewTaskMap.get(projectId));
            }
            
            for(Id projectId :  projectToNewFutureTaskList.keyset())
            {
            	upsertTaskList.addAll(projectToNewFutureTaskList.get(projectId));
            }
        }       
        
        // Logic for Removing Tasks based on Added Sections by user.    
     	removeProjectDocumneSection(projectToRemovedSectionMap,projectDocSectionToTaskMap);
     
    }
    
    public void beforeInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface 
    }
    
    
    public void beforeUpdate(SObject oldSo, SObject so){     

        //This method has been included as the class implements the ITrigger interface
    }
    
    /***********************************************************************************************************************************
    * beforeDelete
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){   
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    
  
    public void afterUpdate(SObject oldSo, SObject so){   
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterDelete(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    
    /***********************************************************************************************************************************
    * andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger
        ExceptionLoggingHelper.insertLogRecordList();
        // Upsert task 
        if(!upsertTaskList.isEmpty())
        {
            upsert  upsertTaskList ExternalField__c;
        }
        // delete tasks
        if(!deleteAdhocTaskList.isEmpty())
        {
        	delete deleteAdhocTaskList;
        }
        // insert tasks
        if(!insertAdhocTaskList.isEmpty())
        {
        	insert insertAdhocTaskList;
        }
   }
   
   public void removeProjectDocumneSection(Map<Id,List<IPM_Project_Document_Section__c>> projectToRemovedSectionMap, Map<Id,List<IPM_Task__c>> projectDocSectionToTaskMap){
   	   if(!projectToRemovedSectionMap.isEmpty())
        {
        	for(id projectId : projectToRemovedSectionMap.keySet())
            {
            	
                // Get List of Added project Document Sections.
                List<IPM_Project_Document_Section__c> removedSectionList = projectToRemovedSectionMap.get(projectId);
              
                for(IPM_Project_Document_Section__c removedSection : removedSectionList)
                {
                	if(projectDocSectionToTaskMap.containsKey(removedSection.Id))
                    {
                        List<IPM_Task__c> associatedTasks = projectDocSectionToTaskMap.get(removedSection.Id);
                  		
                        for(IPM_Task__c task : associatedTasks)
                        {   
                        	// If task is standard update status to inactive
                            if(task.IPM_Type_of_Task__c != IPM_ConstantUtils.ADHOC){
                            	  task.IPM_Active__c = false; 
                            	  upsertTaskList.add(task);   
                            }
                            // If task is adhoc delete the task
                            else if(task.IPM_Type_of_Task__c == IPM_ConstantUtils.ADHOC){

                            	  deleteAdhocTaskList.add(task);  
                            }
                        }
                    }       
                }       
            }   
        }
   	
   } 
}