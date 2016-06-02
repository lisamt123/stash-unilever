/**************************************************************************************************************************
* @Author: Cognizant
* @Created Date: 02/03/2016
* @Description: Test Class Project Document Section Handler
*/
@isTest
private with sharing class IPM_ProjectDocumentSectionHandler_Test{   

    private static user projectLeader;
    private static user adminUser;
    private static IPM_Project_Template__c projTemplate;
    private static IPM_Document_Template__c DocumentTemplate;
    private static IPM_Section__c section;
    private static IPM_Task__c task;
    private static List<IPM_Project_Type__c> projectType;
    private static List<IPM_Project__C> projectList;
    private static List<IPM_Company_Card__c> companyCardList; 
    private static final String PROJDOCSECTION_ACTIVATION_ERROR ='Project Document Section fails to get checked';
    private static final String TASK_ACTIVAION_ERROR = 'Task Generation is getting fails';
    private static final String IPM_USER ='IPMUSER_LASTNAME';
    private static final String PLATFORM_USER = 'PLATFORM_USER' ;
   
    @testSetup static void testProjectSetup() { 

        //create system admin to create master data
        adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
        insert adminUser;
        
        adminUser = [SELECT Id,lastName FROM User WHERE Id =:adminUser.id];
        System.assertEquals(IPM_USER, adminUser.LastName, 'Admin User creation fails'); 

    System.runAs(adminUser){
        // Create Project leader
        projectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
        projectLeader = [SELECT Id,lastName FROM User WHERE Id =:projectLeader.id];
        System.assertEquals(PLATFORM_USER, projectLeader.LastName, 'Project Leader Creation fails'); 
        
        // Create Project Master Data  
        IPM_TestFactory_Helper.getProjectMasterData();

        // Get Project Template
        projTemplate=[SELECT ID,IPM_Template_Complexity__c FROM IPM_Project_Template__c WHERE IPM_Template_Complexity__c=:IPM_ConstantUtils.COMPLEXITY_LITE LIMIT 1];

        System.assertEquals(projTemplate.IPM_Template_Complexity__c, IPM_ConstantUtils.COMPLEXITY_LITE);

        // Get Document Template
        DocumentTemplate=[SELECT ID,IPM_Project_Template__c,IPM_Document_Template_Name__c,IPM_Document_Type__c FROM IPM_Document_Template__c WHERE IPM_Project_Template__c=:projTemplate.ID LIMIT 1];

        System.assertEquals(DocumentTemplate.IPM_Project_Template__c, projTemplate.id, 'Project Template insertion fails' );

        // Get IPM Section
        section =[SELECT ID,IPM_Document_Template__c,IPM_Section_Sequence__c,IPM_Section_Name__c,External_ID__c FROM IPM_Section__c WHERE IPM_Document_Template__c=:DocumentTemplate.ID LIMIT 1];

        System.assertEquals(section.IPM_Document_Template__c, DocumentTemplate.id, 'IPM Section insertion fails');

        // Get Project Type
        projectType = [SELECT Id,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPM_Project_Span__c,IPM_Phase__c,IPM_Source_Company_Card__c FROM IPM_Project_Type__c LIMIT 1];
       
        System.assert(projectType.size()>0);
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        // Get Standard IPM Master Task 
        task = [SELECT Id, IPM_Active__c,IPM_Project_Template__c,IPM_Is_Master__c FROM IPM_Task__c LIMIT 1];
        System.assertNotEquals(null, task.id, 'Task insertion fails');
        
        task.IPM_Project_Template__c = projTemplate.ID;
        task.IPM_Section__c = section.id;
        task.IPM_Type_of_Gate__c = IPM_ConstantUtils.MARKET_READY_GATE; 
        task.IPM_Type_of_Task__c = IPM_ConstantUtils.STANDARD;
        task.IPM_Phase__c = IPM_ConstantUtils.PHASE_CAPABILITY;
        task.IPM_Task_Complexity__c = IPM_ConstantUtils.COMPLEXITY_LITE;
        task.IPM_Task_Type__c = IPM_ConstantUtils.TYPE_NEGOTIABLE;
        update task;
        
        task = [SELECT Id, IPM_Active__c,IPM_Is_Master__c,IPM_Project_Template__c,IPM_Task_Name__c  FROM IPM_Task__c LIMIT 1];
        System.assertEquals(task.IPM_Project_Template__c,projTemplate.ID, 'Task Update fails');
        System.debug('IPM_Task_Name__c::' + task.IPM_Task_Name__c);
        }
    System.runAs(projectLeader){

        projectList = IPM_TestFactory_Helper.createIPMProjectList(FALSE,2);  
        for(Integer i=0; i <= 1; i++)
            {
                projectList[i].IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
                projectList[i].IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
                projectList[i].IPMProject_Span__c = IPM_ConstantUtils.IPMGLOBAL;
                projectList[i].IPM_Phase__c = IPM_ConstantUtils.PHASE_CAPABILITY;
                projectList[i].IPM_CompanyCardText__c = 'Global Company Card';
                projectList[i].IPM_Child_Complexity__c = IPM_ConstantUtils.COMPLEXITY_LITE;
                projectList[i].IPM_Complexity__c = IPM_ConstantUtils.COMPLEXITY_LITE;
                
            }   
        insert projectList;
        
        projectList = [SELECT Id,IPM_Complexity__c From IPM_Project__c WHERE Id IN: projectList LIMIT 5000];
        System.assertEquals(2, projectList.size(),'Project Insertion Fails');     
        System.debug('IPM_Complexity__c::'+projectList[0].IPM_Complexity__c);     
         
        List<IPM_Project_Document__c> ipmProjdocumentList = new List<IPM_Project_Document__c>();
        for(IPM_Project__c project: projectList)
        {
                //Creating project document
                IPM_Project_Document__c projDocument = IPM_TestFactory_Helper.createIPMProjectDocument(FALSE);
                projDocument.IPM_Project__c = project.ID;
                projDocument.IPM_Project_Template__c = projTemplate.Id;  
                projDocument.IPM_Document_Order__c= 1;
                projDocument.IPM_GateDocuments__c = IPM_ConstantUtils.MARKET_READY_GATE;
                ipmProjdocumentList.add(projDocument);
        }
        insert ipmProjdocumentList;
        
        ipmProjdocumentList = [SELECT Id FROM IPM_Project_Document__c LIMIT 5000];
        System.assertEquals(2, ipmProjdocumentList.size(),'Project Document insertion fails');
        
        List<IPM_Project_Document_Section__c> ipmProjDocumentSecList = new List<IPM_Project_Document_Section__c>();
        for(IPM_Project_Document__c projectDocument: ipmProjdocumentList)
        {
                IPM_Project_Document_Section__c pojDocSection = IPM_TestFactory_Helper.createIPMProjectDocumentSection(FALSE);
                pojDocSection.IPM_Project_Document__c = projectDocument.ID;
                pojDocSection.IPM_Section__c = section.Id;
                pojDocSection.IPM_Default_Section__c = false;
                pojDocSection.IPM_Gate_Document__c = IPM_ConstantUtils.MARKET_READY_GATE;
                pojDocSection.IPM_Section_Name__c = section.IPM_Section_Name__c;
                pojDocSection.IPM_Section_Sequence_Number__c = section.IPM_Section_Sequence__c;
                pojDocSection.IPM_Master_Section_External_Id__c = section.External_ID__c;
                ipmProjDocumentSecList.add(pojDocSection);
        }
        insert ipmProjDocumentSecList;
        ipmProjDocumentSecList = [SELECT Id FROM IPM_Project_Document_Section__c LIMIT 5000];
        System.assertEquals(2, ipmProjDocumentSecList.size(), 'Project Document Section Insertion fails');
     
        
        }
    }   
    static testMethod void testProjectDocumentSectionHandler(){
        
        projectLeader = [SELECT Id,lastName FROM User WHERE lastName =:PLATFORM_USER LIMIT 1];
        System.assertEquals(PLATFORM_USER, projectLeader.LastName, 'Project Leader is not getting'); 
        
        
        // Share Master Project to Project Leader
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{projectLeader});
        
        System.runAs(projectLeader){        
            
          
            List<IPM_Project_Document_Section__c> projectDocumentSectionList =[SELECT ID,IPM_Default_Section__c,IPM_Project_Document__c,IPM_Section__c,IPM_ProjectTemplate__c FROM IPM_Project_Document_Section__c LIMIT 100];
            System.assertEquals(2, projectDocumentSectionList.size(), 'Project Document Section is not getting');
          
                 Test.startTest();
            
            // Enabled Project Document Section  A
            projectDocumentSectionList[0].IPM_Default_Section__c = true;
            // Enabled Project Document Section  B
            projectDocumentSectionList[1].IPM_Default_Section__c = true;
            
            
            update projectDocumentSectionList;
            
            projectDocumentSectionList = getProjDocumentSectionList(projectDocumentSectionList);
            
            System.assertEquals(true, projectDocumentSectionList[0].IPM_Default_Section__c, PROJDOCSECTION_ACTIVATION_ERROR);
            System.assertEquals(true, projectDocumentSectionList[1].IPM_Default_Section__c, PROJDOCSECTION_ACTIVATION_ERROR);
            
            // Task A is generated with corresponding active project Document Default Section A
            List<IPM_Task__c> taskList =  getTaskListByProjDocSecId(projectDocumentSectionList[0].id);
            System.assert(taskList.size() >0, TASK_ACTIVAION_ERROR);
            System.assertEquals(true, taskList[0].IPM_Active__c, TASK_ACTIVAION_ERROR);
            
            // Task B is generated with corresponding active project Document Default Section B
            taskList =  getTaskListByProjDocSecId(projectDocumentSectionList[1].id); 
            System.assert(taskList.size() >0, TASK_ACTIVAION_ERROR);
            System.assertEquals(true, taskList[0].IPM_Active__c, TASK_ACTIVAION_ERROR);
            Test.stopTest();
            
            
             
            projectDocumentSectionList =[SELECT ID,IPM_Default_Section__c,IPM_Project_ID__c,IPM_Project_Document__c,IPM_Section__c,IPM_ProjectTemplate__c FROM IPM_Project_Document_Section__c LIMIT 100];
            System.assertEquals(2, projectDocumentSectionList.size(), 'Project Document Section is not getting');
          	
          	Set<Id> projectIdSet = new Set<Id>();
          	for(IPM_Project_Document_Section__c docSection : projectDocumentSectionList)
        	{
        		projectIdSet.add(docSection.IPM_Project_ID__c);
        	}
        	
            // Disabled Project Document Section  A
            projectDocumentSectionList[0].IPM_Default_Section__c = false;
            // Disabled Project Document Section  B
            projectDocumentSectionList[1].IPM_Default_Section__c = false;
            
            List<IPM_Project__c> projectDBList = [SELECT Id,IPM_Complexity__c From IPM_Project__c WHERE Id IN: projectIdSet LIMIT 5000];
            
        	System.assertEquals(IPM_ConstantUtils.COMPLEXITY_LITE, projectDBList[0].IPM_Complexity__c,'Complexity is not lite');
        	System.assertEquals(IPM_ConstantUtils.COMPLEXITY_LITE, projectDBList[1].IPM_Complexity__c,'Complexity is not lite');
        	     
            update projectDocumentSectionList;
            
            projectDocumentSectionList = getProjDocumentSectionList(projectDocumentSectionList);
            
            System.assertEquals(false, projectDocumentSectionList[0].IPM_Default_Section__c, PROJDOCSECTION_ACTIVATION_ERROR);
            System.assertEquals(false, projectDocumentSectionList[1].IPM_Default_Section__c, PROJDOCSECTION_ACTIVATION_ERROR);
            
            // Task A is deactive with corresponding active project Document Default Section A
            taskList =  getTaskListByProjDocSecId(projectDocumentSectionList[0].id);
            System.assert(taskList.size() >0, TASK_ACTIVAION_ERROR);
            System.assertEquals(false, taskList[0].IPM_Active__c, TASK_ACTIVAION_ERROR);
            
           // Task B is deactive with corresponding active project Document Default Section B
            taskList =  getTaskListByProjDocSecId(projectDocumentSectionList[1].id); 
            System.assert(taskList.size() >0, TASK_ACTIVAION_ERROR);
            System.assertEquals(false, taskList[0].IPM_Active__c, TASK_ACTIVAION_ERROR);
            
        }
        
    }
    
  
    
    private static List<IPM_Project_Document_Section__c> getProjDocumentSectionList(List<IPM_Project_Document_Section__c>  projectDocumentSectionList)
     {
        List<IPM_Project_Document_Section__c> projectDocumentSectionUpdatedList = [SELECT ID,IPM_Default_Section__c,IPM_Project_Document__c,IPM_Section__c,IPM_ProjectTemplate__c FROM IPM_Project_Document_Section__c WHERE Id IN : projectDocumentSectionList];
        return projectDocumentSectionUpdatedList;       
     }  
     
    private static List<IPM_Task__c> getTaskListByProjDocSecId(Id projDocSecId)
     {
        List<IPM_Task__c>  updatedTask = [SELECT Id, IPM_Task_Name__c, IPM_Task_Type__c, IPM_Type_of_Gate__c, IPM_Phase__c, IPM_Function__c, IPM_Version_Number__c, IPM_Section__c, IPM_Master_Task__c, IPM_Task_Complexity__c, IPM_Project_Document_Section__c, IPM_Is_Master__c, IPM_Project_Template__c, IPM_Active__c, ExternalField__c FROM IPM_Task__c WHERE IPM_Project_Document_Section__c=:projDocSecId LIMIT 50000];
        return updatedTask;
        
     } 
        
     

}