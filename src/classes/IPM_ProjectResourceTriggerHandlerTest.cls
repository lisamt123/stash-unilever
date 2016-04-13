	/*******************************************************
	* @Description: Test class for CustomerChannelController
	* @Author:Cognizant
	* @Date:05/11/2015
	* *****************************************************/

	@isTest
	private class IPM_ProjectResourceTriggerHandlerTest {

	private static List<User> userList = new  List<User>();
	private static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
	private static List<IPM_Project_Document__c> projectDocList = new List<IPM_Project_Document__c>();
	private static List<IPM_Project_Document_Section__c> projectDocSectionList  = new List<IPM_Project_Document_Section__c>();
	private static List<IPM_Project_Resource__c> projectResourceList  = new List<IPM_Project_Resource__c>();
	private static List<IPM_Task__c> taskList  = new List<IPM_Task__c>();
	private static final String RESOURCE_HISTORY_NOT_INSERTED = 'Project Resource History not Inserted'; 
	private static final String RESOURCE_HISTORY_NOT_UPDATED = 'Project Resource History not Updated'; 
	private static final string PROJECTLEADER_NAME='ProjectLeaderRS';
	private static User projectLeader;
	/***********************************
	* @Description: Test Data Creation
	* *********************************/
	@testsetup static void createTestData()
	{

		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 3]; 

		projectLeader = IPM_TestFactory_Helper.createUser(false);
		projectLeader.ProfileId = p.id; 
		projectLeader.LastName=PROJECTLEADER_NAME;
		
		User projectResource1 =IPM_TestFactory_Helper.createUser(false);
		projectResource1.ProfileId = p.id;

		User projectResource2 = IPM_TestFactory_Helper.createUser(false);
		projectResource2.ProfileId = p.id;      

		User projectResource3 = IPM_TestFactory_Helper.createUser(false);
		projectResource3.ProfileId = p.id;

		User projectResource4 = IPM_TestFactory_Helper.createUser(false);                                                  
		projectResource4.ProfileId = p.id;

		User projectResource5 = IPM_TestFactory_Helper.createUser(false);                                                  
		projectResource5.ProfileId = p.id;

		userList.add(projectLeader);
		userList.add(projectResource1);
		userList.add(projectResource2);
		userList.add(projectResource3);
		userList.add(projectResource4);
		userList.add(projectResource5);
		insert userList;
		List<User>usersList=[SELECT ID FROM USER LIMIT 5];
		system.assertEquals(usersList.size(),5,'five users got created');
		//creating Project Template
		IPM_Project_Template__c projTemplate = IPM_TestFactory_Helper.createIPMProjectTemplate(true);

		//Creating Document Template
		IPM_Document_Template__c ipdoctem = IPM_TestFactory_Helper.creteIPMDocumentTemplate(false);
		ipdoctem.IPM_Project_Template__c=projTemplate.ID;
		ipdoctem.IPM_Document_Type__c=IPM_ConstantUtils.CHARTER_GATE;
		insert ipdoctem;

		list<IPM_Document_Template__c>docTempList=[SELECT IPM_Project_Template__c FROM IPM_Document_Template__c WHERE ID=:ipdoctem.ID];
		system.assertEquals(docTempList[0].IPM_Project_Template__c,projTemplate.ID,'document template id is:'+docTempList[0].IPM_Project_Template__c);

		//Creating master Section
		IPM_Section__c secMast = IPM_TestFactory_Helper.createIPMSection(false);
		secMast.IPM_Document_Template__c=ipdoctem.ID;
		insert secMast;
		list<IPM_Section__c>sectionList=[SELECT IPM_Document_Template__c FROM IPM_Section__c WHERE ID=:secMast.ID];
		system.assertEquals(sectionList[0].IPM_Document_Template__c,ipdoctem.ID,'master section not created');

		//20 projects are generating
		IPM_TestFactory_Helper.createGlobalCompanyCard(true);
		List<IPM_Project__c>projectsList = IPM_TestFactory_Helper.projectSetUp(20,projectLeader);
		for(IPM_Project__c project1:projectsList){
			project1.IPM_PM_Approach__c = IPM_Utils.Internal;
			project1.IPM_Project_Leader__c = projectLeader.Id;
			project1.IPM_GateKeeping_Model__c='Both';

			projectList.add(project1);
		}
		insert projectList;
		List<IPM_Project__c>projsList=[SELECT IPM_Project_Leader__c FROM IPM_Project__c WHERE IPM_Project_Leader__c=:projectLeader.Id LIMIT 20];
		system.assertEquals(projsList.size(),20,'new records not created');

		IPM_Task__c taskAsociatedRD = new IPM_Task__c(IPM_Type_of_Gate__c = IPM_ConstantUtils.CHARTER_GATE,IPM_Phase__c = 'Ideas',
					  IPM_Task_Complexity__c = IPM_ConstantUtils.COMPLEXITY_FULL,Name= '-Identify top 3 strategic channels',
					  IPM_Function__c = 'R&D',IPM_Task_Name__c ='Develop and lock Concept1',
					  IPM_Project_Template__c = projTemplate.Id,IPM_Section__c = secMast.Id,IPM_Project__c = projsList[0].Id
					 );

		IPM_Task__c taskAsociatedFinance = new IPM_Task__c(IPM_Type_of_Gate__c = IPM_ConstantUtils.CHARTER_GATE,IPM_Phase__c = 'Ideas',
						   IPM_Task_Complexity__c = IPM_ConstantUtils.COMPLEXITY_FULL,Name= 'Identify Finance',
						   IPM_Function__c = 'Finance',IPM_Task_Name__c ='Develop and lock Concept2',
						   IPM_Project_Template__c = projTemplate.Id,IPM_Section__c = secMast.Id, IPM_Project__c = projsList[0].Id
						  );

		taskList.add(taskAsociatedRD);
		taskList.add(taskAsociatedFinance);
		insert taskList;

		List<IPM_Task__c>tskList=[SELECT IPM_Project__c FROM IPM_Task__c WHERE IPM_Project__c=:projsList[0].Id LIMIT 1];
		system.assertEquals(tskList[0].IPM_Project__c,projsList[0].Id,'task is not created for'+tskList[0].IPM_Project__c);

		IPM_Project_Document__c projectDocList1 = IPM_TestFactory_Helper.createIPMProjectDocument(false);
		projectDocList1.Name='TESTAPPROVERCL-Charter1';
		projectDocList1.IPM_Project__c=projsList[0].Id;
		projectDocList1.IPM_Project_Template__c= projTemplate.Id;
		projectDocList1.IPM_Approval_Date__c=System.today();
		projectDocList1.IPM_Approved_Comments__c='Approved';

		projectDocList.add(projectDocList1);
		insert projectDocList;
		List<IPM_Project_Document__c>ProjDocList=[SELECT IPM_Project__c FROM IPM_Project_Document__c WHERE IPM_Project__c=:projsList[0].Id LIMIT 1];
		system.assertEquals(ProjDocList[0].IPM_Project__c,projsList[0].Id,'document is not created for'+ProjDocList[0].IPM_Project__c);


		// Creationg Project Document Sections
		IPM_Project_Document_Section__c pojDocSection0 = IPM_TestFactory_Helper.createIPMProjectDocumentSection(false);

		pojDocSection0.IPM_Project_Document__c = projectDocList[0].Id;
		pojDocSection0.IPM_Section__c=secMast.Id;

		projectDocSectionList.add(pojDocSection0);
		insert projectDocSectionList;
		List<IPM_Project_Document_Section__c>ProjDocSeList=[SELECT IPM_Project_Document__c FROM IPM_Project_Document_Section__c WHERE IPM_Project_Document__c=:projectDocList[0].Id LIMIT 1];
		system.assertEquals(ProjDocSeList[0].IPM_Project_Document__c,projectDocList[0].Id,'gatedocument section is created for'+ProjDocSeList[0].IPM_Project_Document__c);

		Test.startTest();
		// Add Resources to Project to create Tasks for resources.

		IPM_Project_Resource__c ipmProjectResource1 = IPM_TestFactory_Helper.createIPMProjectResource(projectList[0].Id, false);
		ipmProjectResource1.IPM_User__c = userList[1].Id;
		ipmProjectResource1.IPM_Role_Type__c = 'Finance';
		ipmProjectResource1.IPM_Member_Email__c = 'abc@gmail.com';
		projectResourceList.add(ipmProjectResource1);

		IPM_Project_Resource__c ipmProjectResource2 = IPM_TestFactory_Helper.createIPMProjectResource(projectList[0].Id, false);
		ipmProjectResource2.IPM_User__c = userList[2].Id;
		ipmProjectResource2.IPM_Role_Type__c = 'R&D';
		ipmProjectResource2.IPM_Member_Email__c = 'xyz@gmail.com';
		projectResourceList.add(ipmProjectResource2);

		insert projectResourceList;
		List <IPM_Project_Resource__c> projList1 = [Select id,IPM_User__c,IPM_Role_Type__c from IPM_Project_Resource__c where Id =: ipmProjectResource1.Id LIMIT 1];
		System.assertEquals(projList1[0].IPM_User__c,userList[1].Id,'resources are not inserted');
		System.runAs(userList[0]){
			// Update the User information and assign it to someone else and verify whether tasks are reAllocated.        
			projectResourceList[0].IPM_User__c  = userList[3].Id;

			update projectResourceList;
			List <IPM_Project_Resource__c> projResourceLst = [Select id,IPM_User__c,IPM_Member_Email__c from IPM_Project_Resource__c where Id =: projectResourceList[0].Id LIMIT 1];
			System.assertEquals(projResourceLst[0].IPM_User__c,userList[3].Id,'resource data is not updated');
			list<IPM_Task__c> tasksList = [SELECT IPM_Assignee__c, IPM_Function__c, IPM_Project__c FROM IPM_Task__c 
			   WHERE IPM_Project__c = :projectList[0].Id AND IPM_Completed__c =false];

			// Validate if the Tasks have been reassigned.
			for(IPM_Task__c task : tasksList ){
				if(task.IPM_Function__c == 'Finance')
				{
					System.assertEquals(task.IPM_Assignee__c,userList[3].Id, 'IPM_Assignee__c Is Different');
					System.assertNotEquals(task.IPM_Assignee__c,userList[1].Id);
				}
			}
		}
		System.runAs(IPM_TestFactory_Helper.createUserAdmin(false))
		{


			projectResourceList=new List<IPM_Project_Resource__c>();
			// Add Resources to Project to 
			IPM_Project_Resource__c ipmNewProjectResource1 = new IPM_Project_Resource__c(IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE,IPM_Project__c = projectList[0].Id,
														  IPM_User__c = userList[1].Id,IPM_Project_Role_Owner__c = true);

			IPM_Project_Resource__c ipmNewProjectResource2 = new IPM_Project_Resource__c(IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_RD,IPM_Project__c = projectList[0].Id,
														  IPM_User__c = userList[2].Id,IPM_Project_Role_Owner__c = true);

			IPM_Project_Resource__c ipmNewProjectResource3 = new IPM_Project_Resource__c(IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_CD,IPM_Project__c = projectList[0].Id,
														  IPM_User__c = userList[3].Id,IPM_Project_Role_Owner__c = true);

			IPM_Project_Resource__c ipmNewProjectResource4 = new IPM_Project_Resource__c(IPM_Role_Type__c =  IPM_ConstantUtils.FUNCTIONAL_ROLE_BD,IPM_Project__c = projectList[0].Id,
														  IPM_User__c = userList[4].Id,IPM_Project_Role_Owner__c = true);

			IPM_Project_Resource__c ipmNewProjectResource5 = new IPM_Project_Resource__c(IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI,IPM_Project__c = projectList[0].Id,
														  IPM_User__c = userList[5].Id,IPM_Project_Role_Owner__c = true);

			projectResourceList.add(ipmNewProjectResource1);
			projectResourceList.add(ipmNewProjectResource2);
			projectResourceList.add(ipmNewProjectResource3);
			projectResourceList.add(ipmNewProjectResource4);
			projectResourceList.add(ipmNewProjectResource5);
			insert projectResourceList;

			List<IPM_Project_Resource_History__c> resourceHistoryList = [Select Id,Type__c from IPM_Project_Resource_History__c where IPM_Project__c =: projectList[0].Id];
			System.assertEquals(7, resourceHistoryList.size(), RESOURCE_HISTORY_NOT_INSERTED);

			for(IPM_Project_Resource_History__c resourceHistory : resourceHistoryList){
				System.assertEquals(IPM_ConstantUtils.HISTORY_INSERTED, resourceHistory.Type__c, RESOURCE_HISTORY_NOT_INSERTED);
			}
			
			
			for(IPM_Project__c project : projectList) {
				
				project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
				project.IPM_Project_Leader__c = userList[0].Id;
				project.Success_Timestamp_EcoDesign__c = System.now().addMinutes(15);
				project.IPM_SourceProjectType__c = 'Original';
				project.First_Sync_To_EcoDesign__c = true;
				
			}

			update projectList;
			List<IPM_Project__c>projList=[select Id,First_Sync_To_EcoDesign__c from IPM_Project__c where Id=:projectList[0].Id Limit 1];
			System.assertEquals(projList[0].First_Sync_To_EcoDesign__c,true,'project is not inserted');
			
			
			List<IPM_Project_Resource__c> ipmProjectResourceList = [Select id,IPM_User__c,IPM_Role_Type__c,IPM_Member_Email__c from IPM_Project_Resource__c limit 1000];
			for(IPM_Project_Resource__c projRes : ipmProjectResourceList){
				projRes.IPM_Member_Email__c = 'newemail@gmail.com';
			}

			Update ipmProjectResourceList;
			List <IPM_Project_Resource__c> projResourceLst = [Select id,IPM_User__c,IPM_Member_Email__c from IPM_Project_Resource__c where Id =: ipmProjectResourceList[0].Id LIMIT 1];
			System.assertEquals(projResourceLst[0].IPM_Member_Email__c,'newemail@gmail.com','resource is not updated');
			delete ipmProjectResourceList[0];

			projResourceLst = [Select id,IPM_User__c from IPM_Project_Resource__c where Id =: ipmProjectResourceList[0].Id LIMIT 1];
			System.assertEquals(projResourceLst.isEmpty(),true,'resource is not deleted');
			

		}
		Test.stopTest();
	} 

	//Testmethod to test IPM Project Resource History for Bulk updation of project resources
	static testMethod void testProjectResourceHistoryForBulkUpdation(){
	Integer updateCount =0;
	System.runAs(IPM_TestFactory_Helper.createUserAdmin(false))
	{
		Test.startTest();
		projectLeader=[SELECT LastName FROM USER WHERE LastName=:PROJECTLEADER_NAME LIMIT 1];
		projectList=[SELECT IPM_Project_Leader__c FROM IPM_Project__c WHERE IPM_Project_Leader__c=:projectLeader.Id LIMIT 20];
		projectResourceList=[SELECT IPM_Role_Type__c,IPM_Project__c,IPM_User__c,IPM_Project_Role_Owner__c FROM IPM_Project_Resource__c LIMIT 10];
		List<IPM_Project_Resource__c> lstResourceToUpdate = new List<IPM_Project_Resource__c>();
		for(IPM_Project_Resource__c eachResource : projectResourceList){
		eachResource.IPM_Project_Role_Owner__c = false;
		lstResourceToUpdate.add(eachResource);
		}
		update lstResourceToUpdate;
		List <IPM_Project_Resource__c> projResourceLst = [Select id,IPM_User__c,IPM_Project_Role_Owner__c from IPM_Project_Resource__c where Id =: lstResourceToUpdate[0].Id LIMIT 1];
		System.assertEquals(projResourceLst[0].IPM_Project_Role_Owner__c,false,'resource is not updated');

		List<IPM_Project_Resource_History__c> resourceHistoryList  = [Select Id,Type__c from IPM_Project_Resource_History__c where IPM_Project__c =: projectList[0].Id];

		for(IPM_Project_Resource_History__c resourceHistory : resourceHistoryList){
			if(IPM_ConstantUtils.HISTORY_UPDATED == resourceHistory.Type__c ){
				updateCount++;
			}
		}
		System.assertEquals(6, updateCount, RESOURCE_HISTORY_NOT_UPDATED);
		IPM_ProjectResourceTriggerHandler proResTrig=new IPM_ProjectResourceTriggerHandler();
		Map<Id, IPM_Project_Resource__c> resMap=new Map<Id, IPM_Project_Resource__c>();
		resMap.put(projectResourceList[0].Id,projectResourceList[0]);
		proResTrig.OnAfterUpdate(lstResourceToUpdate,resMap,resMap);
		Set<Id>userId=new Set<Id>();
		userId.add(projectLeader.Id);
		IPM_ProjectResourceTriggerHandler.notifyRoleChangeToPLs(userId);
		IPM_ProjectResourceTriggerHandler.memberChangingRole(lstResourceToUpdate);
		proResTrig.onAfterUnDelete(lstResourceToUpdate);
		Test.stopTest();
		}
	}

}