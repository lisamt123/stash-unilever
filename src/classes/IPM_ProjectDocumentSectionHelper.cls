/****************************************************************************************************************************************
* @Autor Cognizant
* @Created Date date 13/01/2016
* @Description Helper class for IPM_ProjectDocumentSectionHandler.
               */

public with sharing class IPM_ProjectDocumentSectionHelper    
{
    private static final String LIMIT_CLAUSE_STR = ' LIMIT 50000 ';
    
    public static void removeProjectDocumentSection(Map<Id,List<IPM_Project_Document_Section__c>> projectToRemovedSectionMap, Map<Id,List<IPM_Task__c>> projectDocSectionToTaskMap,Map<Id,List<IPM_Project_Document_Section__c>> projectDocToSectionMap,List<IPM_Task__c> upsertTaskList, List<IPM_Task__c> deleteAdhocTaskList){
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
                            if(task.IPM_Type_of_Task__c == IPM_ConstantUtils.STANDARD_TASKS){
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
   
  public static void addProjectDocumentSection( Map<Id,List<IPM_Project_Document_Section__c>> projectToAddedSectionMap, Map<Id,List<IPM_Task__c>> sectionBasedMasterTasks,Map<Id,List<IPM_Project_Document_Section__c>> projectDocToSectionMap,List<IPM_Task__c> upsertTaskList, List<IPM_Task__c> insertAdhocTaskList )
  {
       if(!projectToAddedSectionMap.isEmpty())
        {    
            // Project id to project map
            Map<Id,IPM_Project__c> projectMap ;
            
            // Project Id and List of IPM Task Map    
            Map<Id,List<IPM_Task__c>> projectToTaskMap = new Map<Id,List<IPM_Task__c>>();   
            
            // Project Id to Master future tasks
            Map<Id,List<IPM_Task__c>> projectToMasterFutureTasks = new Map<Id,List<IPM_Task__c>>();
            
             // Project id to Project  Document map 
            Map<Id,IPM_Project_Document__c> projectToDocumentMap = new Map<Id,IPM_Project_Document__c>();
            
            // Project Id and List of IPM Project Resource Map    
            Map<Id,List<IPM_Project_Resource__c>> projectToResourceMap = new Map<Id,List<IPM_Project_Resource__c>>(); 

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
    
  }
}