/*************************************************************
*@Author:Cognizant
*@Date:October 2014
*@Description : To test IPM_AssortStrategy class
*************************************************************/

@isTest
private class IPM_AssortmentStrategy_Test {
	
	public static IPM_Project__c project;// Project object initialization
	public static IPM_Project_Document__c projDoc;
	public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
	public static IPM_Project_Document_Section__c projDocSec;
	public static IPM_Project_Rollout__c projRoll;
	public static IPM_Document_Template__c ipdt;
	public static IPM_Project_Template__c projTempl;
	public static IPM_Section__c secMst;
	private static PageReference pRef;
	private static IPM_AssortmentStrategy  ipmAssort;
	private static List<user>userList=new List<user>();
	private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
	private static user testUser;
	private static final String TEST_TESTING='Test,Testing';
	public static IPM_Project_Document_Section_Content__c projDocSecCon;
	private static final string HYPERMARKET_STR='HyperMarket';
    private static final string INCUMBENT_STR='CU CIF BANO REP ECON DOYP 450ML DOM';
	
	/*************************************************************************
	*@Description : to Intialize(insert) the data for Project, Project Document
					project Document section, project Document section content
					Customer_Channel_Priority_Order objects
	***************************************************************************/
	static testMethod void initializeData(){ 
		testUser=IPM_TestFactory_Helper.createUser(false);
		insert testUser;
		userList.add(testUser);
		List<User>userLists=[SELECT id FROM user WHERE id=:testUser.id LIMIT 1];
		System.AssertEquals(userLists[0].id, testUser.id,'user id is:'+userLists[0].id);//positive test
		//creating Project Template
		IPM_Project_Template__c projTemplate = IPM_TestFactory_Helper.createIPMProjectTemplate(FALSE);
		insert projTemplate;
		
		List<IPM_Project_Template__c> projTemplList=[SELECT ID,IPM_Template_Complexity__c FROM IPM_Project_Template__c WHERE ID=:projTemplate.ID LIMIT 1];
		
		projTempl=projTemplList[0];        
		System.assertEquals(projTempl.IPM_Template_Complexity__c, IPM_ConstantUtils.COMPLEXITY_FULL);

		IPM_Document_Template__c ipdoctem = IPM_TestFactory_Helper.creteIPMDocumentTemplate(FALSE);
		ipdoctem.IPM_Project_Template__c = projTempl.ID;
		insert ipdoctem;
		
		List<IPM_Document_Template__c> projDocTemplList=[SELECT ID,IPM_Project_Template__c,IPM_Document_Template_Name__c,IPM_Document_Type__c FROM IPM_Document_Template__c WHERE ID=:ipdoctem.ID LIMIT 1];
		ipdt=projDocTemplList[0];
		
		System.assertEquals(projDocTemplList[0].id,ipdoctem.id );//positive test
		
		//Creating master Section
		IPM_Section__c secMast = IPM_TestFactory_Helper.createIPMSection(FALSE);
		secMast.IPM_Document_Template__c = ipdt.ID;
		insert secMast;
		
		List<IPM_Section__c> projSecMstlList=[SELECT ID,IPM_Document_Template__c,IPM_Section_Sequence__c,IPM_Section_Name__c FROM IPM_Section__c WHERE ID=:secMast.ID LIMIT 1];

		secMst=projSecMstlList[0];
		System.assertEquals(projSecMstlList[0].IPM_Document_Template__c,ipdt.ID);//positive test
		
		// Create Project
		IPM_Project__c projectRecord = IPM_TestFactory_Helper.createIPMProject(FALSE);
		projectRecord.IPM_Project_Leader__c=testUser.Id;
		insert projectRecord;
		projectList.add(projectRecord);
		List<IPM_Project__c> projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectRecord.ID LIMIT 1];
		
		project=projlList[0];
		System.assertEquals(projlList[0].id,projectRecord.id);//positive test
		List<IPM_Project__Share>projectShareList=IPM_TestFactory_Helper.shareIPMProject(projectList,userList);
		insert projectShareList;
		list<IPM_Project__Share>shareList=[SELECT ParentId,UserOrGroupId FROM IPM_Project__Share WHERE ParentId=:projectRecord.id AND UserOrGroupId=:testUser.id LIMIT 1];
		system.assertEquals(shareList[0].UserOrGroupId,testUser.id,testUser.id+'User should have edit access to project');//positive test
		
		IPM_Project_Rollout__c projRollOut = IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
		projRollOut.IPM_Project__c=project.ID;
		projRollOut.RecordTypeId=Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get('Regional Rollout').RecordTypeId;
		projRollOut.IPM_Regional_PL__c=testUser.id;
		insert projRollOut;
		
		List<IPM_Project_Rollout__c> projRollOutList=[SELECT ID,RecordTypeId,IPM_Rollout_Project__c,Market_Cluster__c,Target_Launch_Date__c,IPM_Regional_PL__c FROM IPM_Project_Rollout__c WHERE ID=:projRollOut.ID LIMIT 1];
		
		projRoll=projRollOutList[0];
		System.assertEquals(projRollOutList[0].IPM_Regional_PL__c,testUser.id);//positive test

		IPM_Project_Document__c projDocument = IPM_TestFactory_Helper.createIPMProjectDocument(FALSE);
		projDocument.IPM_Project__c=project.ID;
		projDocument.IPM_Project_Template__c= projTempl.Id;  
		insert projDocument;
		
		projDocList=[SELECT IPM_GateDocuments__c,IPM_Project__c,IPM_Project_Template__c,IPM_Contract_GateKeeper_Model__c FROM IPM_Project_Document__c WHERE ID=:projDocument.ID LIMIT 1];
		projDoc=projDocList[0];
		System.assertEquals(projDocList[0].IPM_Project__c,project.ID);//positive test
		
		// Creationg Project Document Sections
		IPM_Project_Document_Section__c pojDocSection = IPM_TestFactory_Helper.createIPMProjectDocumentSection(FALSE);
		pojDocSection.IPM_Project_Document__c=projDoc.ID;
		
		pojDocSection.IPM_Section__c=secMst.Id;
		insert pojDocSection;

		List<IPM_Project_Document_Section__c> projDocSecList=[SELECT ID,IPM_Default_Section__c,IPM_Project_Document__c,IPM_Section__c FROM IPM_Project_Document_Section__c WHERE ID=:pojDocSection.ID LIMIT 1];
		projDocSec=projDocSecList[0];
		System.assertEquals(projDocSecList[0].IPM_Section__c,secMst.Id); //positive test 
		
		
		
		projDocSecCon = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
		projDocSecCon.IPM_Project_Document_Section__c = projDocSec.ID;
		projDocSecCon.IPM_Customer_Channels__c=HYPERMARKET_STR;
		projDocSecCon.IPM_Assort_Channel_Name__c=HYPERMARKET_STR;
		projDocSecCon.IPM_Incumbent_CUs__c=INCUMBENT_STR;
		projDocSecCon.IPM_Content_Type__c=IPM_ConstantUtils.ASSORTMENT_CONTENT_TYPE;
		
		insert projDocSecCon;
		IPM_Project_Document_Section_Content__c projectDocSecConObj=[select IPM_Content_Type__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where id=:projDocSecCon.Id];
		system.assertEquals(projectDocSecConObj.IPM_Content_Type__c,IPM_ConstantUtils.ASSORTMENT_CONTENT_TYPE);
		List<IPM_Project_Document_Section_Content__c>conList=new List<IPM_Project_Document_Section_Content__c>();
		conList.add(projDocSecCon);
		
		
		List<IPM_Project_Document_Section_Content__share>projectConShareList=IPM_TestFactory_Helper.shareIPMSectionContent(conList,userList);
		insert projectConShareList;
		
		list<IPM_Project_Document_Section_Content__share>shareList1=[SELECT ParentId,UserOrGroupId FROM IPM_Project_Document_Section_Content__share WHERE ParentId=:projDocSecCon.id AND UserOrGroupId=:testUser.id LIMIT 1];
		system.assertEquals(shareList1[0].UserOrGroupId,testUser.id,testUser.id+'User should have edit access to project');//positive test
		
		
		
		
		 pRef = Page.IPM_ProjectDocumentSectionEditor;
		pRef.getParameters().put('Id', project.Id);
		pRef.getParameters().put('projDocSecId', projDocSec.Id);
		pRef.getParameters().put('gateType',IPM_ConstantUtils.CHARTER_GATE);
		pRef.getParameters().put('IsEditable',IPM_ConstantUtils.TEAM_TRUE);
		Test.setCurrentPage(pRef);
		
		ipmAssort=new IPM_AssortmentStrategy ();
		
	} 
	
	
	
	
	/*************************************************************************
	*@Description : to Intialize the data for IPM_AssortmentStrategy object and 
			to cover CreateAssortStrategy method of IPM_AssortmentStrategy class
	***************************************************************************/
	static testMethod void testcreateChannel(){
		initializeData();
		Test.startTest();
		system.RunAs(testUser){
			
			set<string>cuname=new set<string>();
			cuname.add(HYPERMARKET_STR);
			set<string>cuname1=new set<string>();
			cuname1.add(INCUMBENT_STR);
			ipmAssort.ProdocSecId=projDocSec.Id;
			ipmAssort.setProdocSecId(projDocSec.Id);
			ipmAssort.setchannelName=cuname;
			ipmAssort.IPMProdocContent.IPM_Distribution_Type__c='Numeric';
			ipmAssort.setSelectedCUsNames=new set<string>();
			ipmAssort.setSelectedCUsNames.clear();
			ipmAssort.channelName='';
			ipmAssort.CreateAssortStrategy();
			ipmAssort.channelName=TEST_TESTING;
			ipmAssort.selectedCUsNames=TEST_TESTING;
			ipmAssort.setSelectedCUsNames=cuname1;
			ipmAssort.HoldCustomesChannels();
			ipmAssort.HoldCUsNames();
			ipmAssort.CreateAssortStrategy();
			List<IPM_Project_Document_Section_Content__c> secConLst=[select IPM_Content_Type__c  from IPM_Project_Document_Section_Content__c where ID=:projDocSecCon.Id];
			system.assertEquals(secConLst[0].IPM_Content_Type__c,IPM_ConstantUtils.ASSORTMENT_CONTENT_TYPE,'Data is created');
			Test.stopTest();
		}
	}
	
	/*************************************************************************
	*@Description : to Intialize the data for IPM_AssortmentStrategy object and 
					to cover updateAssortS method of IPM_AssortmentStrategy class
	***************************************************************************/
	static testMethod void testchangePriority(){
		initializeData();
		
		
			Test.startTest();
			
			system.RunAs(testUser){
			
			ipmAssort.AssortPriority='1';
			ipmAssort.ProdocSecId=projDocSec.Id;
			ipmAssort.setProdocSecId(projDocSec.Id);
		    ipmAssort.selecteAssortTodelete=projDocSecCon.Id;
			ipmAssort.updateAssortS();
			List<IPM_Project_Document_Section_Content__c> secConLst1=[select IPM_Content_Type__c,IPM_Assortment_Strategy_Priority__c  from IPM_Project_Document_Section_Content__c where ID=:projDocSecCon.Id];
			system.assertEquals(secConLst1[0].IPM_Assortment_Strategy_Priority__c,'1','Data is updated');
			
			
			Test.stopTest();
		
	}
	}
	/*************************************************************************
	*@Description : to Intialize the data for IPM_AssortmentStrategy object and 
					to cover DltAllAssort method of IPM_AssortmentStrategy class
	***************************************************************************/
	static testMethod void testdeleteSectionContent(){
		initializeData();
		Test.startTest();
		system.RunAs(testUser){
			
			ipmAssort.selecteAssortName=INCUMBENT_STR;
			ipmAssort.ProdocSecId=projDocSecCon.Id;
			ipmAssort.DltAllAssort();
			List<IPM_Project_Document_Section__c> secConLst=[select ID  from IPM_Project_Document_Section__c where Id=:ipmAssort.ProdocSecId];
			system.assertEquals(secConLst.size(),0,'record is deleted');
			
			Test.stopTest();
		} 
	}    
}