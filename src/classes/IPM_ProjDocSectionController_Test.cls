/**************************************************************************************************************************
* @Author: Cognizant
* @Created Date: 20/02/2015
* @Description: Test Class Project Document Section Controller
*/
@isTest
private class IPM_ProjDocSectionController_Test{   
    //Initializing Variables
    private static User platformUser;
    private static final string SECTION_NOT_UPDATED = 'section not updated properly';
    private static final string PROJ_RESOURCE_NOT_UPDATED = 'project resource not updated properly';
    private static final string PROJ_DOC_SEC_ID_STR = 'projdocsecid';
	private static final string SAVE_FAILED = 'save failed';
    private static final string GATE_DOC_SECTION_ACCESS_2 = 'trade_promotion_strategy,country_feedback_requirements';
    private static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    private static List<IPM_Project__c> projectListObj = new List<IPM_Project__c>();
    private static List<IPM_Project_Document_Section__c> sectionList = new List<IPM_Project_Document_Section__c>();
    private static IPM_Project_Document_Section_Content__c sectionContent;
    private static List<IPM_Gate_Document_Section_Access__c> customSettingDataList = new List<IPM_Gate_Document_Section_Access__c>();
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static IPM_Project_Resource__c ipmProjectResource; 
    private static List<IPM_Gate_CMI__c> gateCMI = new List<IPM_Gate_CMI__c>();
    private static List<IPM_Questionnaire__c> questionaire = new List<IPM_Questionnaire__c>();
    
	
    /***********************************
    * @Description: Test Data Creation
    * *********************************/

    @testSetup static void projectSetUp() 
    {
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
        }
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        Set<Id> companyCardId = new Set<Id>();        
        for(IPM_Company_Card__c temp : companyCardList){
            companyCardId.add(temp.Id);
        }
        List<IPM_Company_Card__c> ipmCompanyCardList = [Select id from IPM_Company_Card__c where id in : companyCardId]; 
        system.assertEquals(ipmCompanyCardList.size(), 3, 'Company card not created properly.');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        
        projectList = IPM_TestFactory_Helper.projectSetUp(1,platformUser);
        
        System.runAs(platformUser)
        {
            insert projectList;
            projectList[0].IPM_Technical_Project_Leader__c=platformUser.id;
            update projectList;
        }  
        Set<Id> projectIdList = new Set<Id>();        
        for(IPM_project__c temp : projectList){
            projectIdList.add(temp.Id);
        }        
        List<IPM_Project__c> ipmProjectList = [Select id from IPM_Project__c where id in : projectIdList];  
        system.assertEquals(ipmProjectList.size(),1,'Projects are not created');
    }

    public static void createTestData(){
        Set<String> projectNameSet = new Set<String>{'TestComments1'};
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
        System.runAs(globalUser)
        { 
            projectListObj = [Select Id, Name,IPM_Technical_Project_Leader__c, (Select Id,IPM_GateDocuments__c from Project_Documents__r)
            from IPM_Project__c where Name in:projectNameSet];
            
            for(IPM_Project__c projectObj : projectListObj)
            {
                projDocList = projectObj.Project_Documents__r;
                system.assertEquals(projDocList[0].IPM_GateDocuments__c,'Charter','Project Document not created');  
            }
            
            sectionList = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            sectionList[0].IPM_FunctionalRole__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_BD;
            sectionList[0].IPM_Gate_Document_Summary__c = 'testSummary';
            update sectionList;
            
            Set<Id> sectionIdList = new Set<Id>();        
            for(IPM_Project_Document_Section__c temp : sectionList){
                sectionIdList.add(temp.Id);
            }
            
            system.assertEquals(sectionList[0].IPM_FunctionalRole__c, IPM_ConstantUtils.FUNCTIONAL_ROLE_BD, 'Section not updated properly.');
            
            sectionContent = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            sectionContent.IPM_Project_Document_Section__c = sectionList[0].Id;
            sectionContent.IPM_Content_Type__c = IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION;
            sectionContent.IPM_Customer_Channels__c = 'ABC';
            sectionContent.IPM_Customer_Channel_Priority__c = 1; 
            sectionContent.IPM_OTIF_Measure__c = 'XYZ';
            sectionContent.IPM_CMI_Is_Free_Text__c = false;
            sectionContent.IPM_Section_Id__c = sectionList[0].Id;
            sectionContent.IPM_OTIF_Status__c = 'Green';
            insert sectionContent;
            IPM_Project_Document_Section_Content__c ipmSectionContent = [Select id, IPM_Customer_Channel_Priority__c from IPM_Project_Document_Section_Content__c where id =: sectionContent.Id];            
            system.assertEquals(ipmSectionContent.IPM_Customer_Channel_Priority__c, 1, 'Section not inserted properly');
            
            
            gateCMI = IPM_TestFactory_Helper.createCMIGateRecords(true, projectListObj);
            gateCMI[0].IPM_Skip_Test_Reason__c = 'XYZ';
            update gateCMI;
            IPM_Gate_CMI__c testCMI = [Select id, IPM_Skip_Test_Reason__c from IPM_Gate_CMI__c where id =: gateCMI[0].Id];
            system.assertEquals(testCMI.IPM_Skip_Test_Reason__c, 'XYZ', 'CMI not updated properly.');
            

            IPM_Gate_Document_Section_Access__c customSettingData = new IPM_Gate_Document_Section_Access__c();
            customSettingData.Name = 'BD Marketing';
            customSettingData.IPM_Gate_Document_Section_Access_1__c = 'Introduction,Idea_Graphic,Consumer_Need,Strategic_Fit,Competitors,Target_Audience,Concept,CU_And_Complexity,Degree_of_Commonality,Communication,Trademarks,Product,Proposed_Pricing,Mix_Qualification_Plan_and_Action_Standards ';
            customSettingData.IPM_Gate_Document_Section_Access_2__c = 'Merchandising_Strategy,Trade_Promotion_Strategy,Country_Feedback_Requirements,Regional_BD_Team_Feedback_to_Global,Regional_BD_Team_FB_Req,Pack_Graphics';
            customSettingDataList.add(customSettingData);
            
            IPM_Gate_Document_Section_Access__c customSettingData1 = new IPM_Gate_Document_Section_Access__c();
            customSettingData1.Name = 'CD';
            customSettingData1.IPM_Gate_Document_Section_Access_1__c = 'Introduction,Customers_Channels,Promotion_Guidance_for_Deployment,Assortment_Strategy,Merchandising_Strategy,Trade_Promotion_Strategy,Customers_Channels,Trade_Story, Mix_Qualification_Plan_and_Action_Standards ';
            customSettingData1.IPM_Gate_Document_Section_Access_2__c = GATE_DOC_SECTION_ACCESS_2;
            customSettingDataList.add(customSettingData1);
            
            IPM_Gate_Document_Section_Access__c customSettingData2 = new IPM_Gate_Document_Section_Access__c();
            customSettingData2.Name = 'CMI';
            customSettingData2.IPM_Gate_Document_Section_Access_1__c = 'Introduction,Consumer_Evidence_Concept,Mix_Qualification_Plan_and_Action_Standards,Consumer_Evidence_Pack,Consumer_Evidence_Product,Consumer_Evidence_Price,Full_Mix,Mix_Qualification_Plan_and_Action_Standards ';
            customSettingData2.IPM_Gate_Document_Section_Access_2__c = GATE_DOC_SECTION_ACCESS_2;
            customSettingDataList.add(customSettingData2);
            
            IPM_Gate_Document_Section_Access__c customSettingData3 = new IPM_Gate_Document_Section_Access__c();
            customSettingData3.Name = 'Finance';
            customSettingData3.IPM_Gate_Document_Section_Access_1__c = 'Introduction,Business_Case_Action_Standards,Initial_Estimate_of_Opportunity,BD/BB_Alignment,Business_Case_Action_Standards,Assumptions,Sensitivity_Analysis,Business_Waste,Mix_Qualification_Plan_and_Action_Standards ';
            customSettingData3.IPM_Gate_Document_Section_Access_2__c = GATE_DOC_SECTION_ACCESS_2;
            customSettingDataList.add(customSettingData3);
            
            IPM_Gate_Document_Section_Access__c customSettingData4 = new IPM_Gate_Document_Section_Access__c();
            customSettingData4.Name = 'Project Leader';
            customSettingData4.IPM_Gate_Document_Section_Access_1__c = 'Introduction,Idea_Graphic,Feedback_from_Last_Gate,Human_Resources,Key_Issues_needing_focus_in_Gate_Meeting,Key_Changes_since_Contract_Gate, Mix_Qualification_Plan_and_Action_Standards ';
            customSettingData4.IPM_Gate_Document_Section_Access_2__c = GATE_DOC_SECTION_ACCESS_2;
            customSettingDataList.add(customSettingData4);
            
            IPM_Gate_Document_Section_Access__c customSettingData5 = new IPM_Gate_Document_Section_Access__c();
            customSettingData5.Name = 'R&D';
            customSettingData5.IPM_Gate_Document_Section_Access_1__c = 'Introduction,R&D_Initial_Outline_Product_Pack,Environmental_Impact,R&D_Feasibility,Pack_Graphics,Product,R&D_Technical_Readiness, Mix_Qualification_Plan_and_Action_Standards ';
            customSettingData5.IPM_Gate_Document_Section_Access_2__c = GATE_DOC_SECTION_ACCESS_2;
            customSettingDataList.add(customSettingData5);
            
            IPM_Gate_Document_Section_Access__c customSettingData6 = new IPM_Gate_Document_Section_Access__c();
            customSettingData6.Name = 'Supply Chain';
            customSettingData6.IPM_Gate_Document_Section_Access_1__c = 'Introduction,CU_And_Complexity,Degree_of_Commonality,Supply_Chain_Feasibility,Supply_Chain_Technical_Readiness,Technical, Mix_Qualification_Plan_and_Action_Standards ';
            customSettingData6.IPM_Gate_Document_Section_Access_2__c = GATE_DOC_SECTION_ACCESS_2;
            customSettingDataList.add(customSettingData6);
            
            IPM_Gate_Document_Section_Access__c customSettingData7 = new IPM_Gate_Document_Section_Access__c();
            customSettingData7.Name = 'Technical Project Leader';
            customSettingData7.IPM_Gate_Document_Section_Access_1__c = 'Introduction,R&D_Initial_Outline_Product_Pack,Environmental_Impact,R&D_Feasibility,R&D_Technical_Readiness,Supply_Chain_Initial_Outline,Supply_Chain_Feasibility,Mix_Qualification_Plan_and_Action_Standards ';
            customSettingData7.IPM_Gate_Document_Section_Access_2__c = GATE_DOC_SECTION_ACCESS_2;
            customSettingDataList.add(customSettingData7);
            
            insert customSettingDataList;
            Set<Id> customSettingIdList = new Set<Id>();
            for(IPM_Gate_Document_Section_Access__c testCustomSetting : customSettingDataList){
                customSettingIdList.add(testCustomSetting.Id);
            }
            List<IPM_Gate_Document_Section_Access__c> testCustomSettingList = [Select id from IPM_Gate_Document_Section_Access__c limit 1000];
            system.assertEquals(testCustomSettingList.size(), 8, 'Custom setting data not inserted properly.');
            
            ipmProjectResource = IPM_TestFactory_Helper.createIPMProjectResource(projectListObj[0].Id,FALSE);
            ipmProjectResource.IPM_Role_Type__c = 'BD';
            ipmProjectResource.IPM_User__c = globalUser.Id ;
            insert ipmProjectResource;
            IPM_Project_Resource__c testResource = [Select id, IPM_Role_Type__c from IPM_Project_Resource__c where id =: ipmProjectResource.Id];
            system.assertEquals(testResource.IPM_Role_Type__c, 'BD', 'project resource not inserted properly.');
            
            questionaire = [Select id, IPM_GK_Answers__c from IPM_Questionnaire__c limit 1000];
            questionaire[0].IPM_GK_Answers__c = 'Yes';
            questionaire[0].IPM_Score__c = 4;
            questionaire[0].IPM_Active_RQS__c = true;
            questionaire[0].IPM_Comments__c = 'Comment';
            questionaire[0].IPM_Project_Document_Section__c = sectionList[0].Id;
            update questionaire; 
            IPM_Questionnaire__c testQuestionaire = [Select id, IPM_Active_RQS__c from IPM_Questionnaire__c where id=: questionaire[0].Id];
            system.assertEquals(testQuestionaire.IPM_Active_RQS__c, true, 'Questionare not updated properly.');
        }
    }
    
    /**************************************************************************************************************************
    * @Description: For Running the Test Script
    */ 
    public static testMethod void testSave(){ 
        Test.startTest();
        createTestData();
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
        System.runAs(globalUser)
        {
            PageReference pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getparameters().put('Id', projectListObj[0].ID);
            pRef.getparameters().put(PROJ_DOC_SEC_ID_STR, sectionList[0].Id);
            Test.setCurrentPage(pRef );
            
            IPM_ProjectDocumentSectionController projDocSecControl=new IPM_ProjectDocumentSectionController();
            projDocSecControl.selectedOTIFStatus='abc';
            projDocSecControl.gateDocument=IPM_ConstantUtils.CHARTER_GATE;
            projDocSecControl.secList='asd';
            projDocSecControl.isFlagedNext = 'True';
            projDocSecControl.isChecked = 'true';
            projDocSecControl.IsGateSave = 'Gate';
            projDocSecControl.save();
            projDocSecControl.cancel();
            projDocSecControl.TaskDelete();
            projDocSecControl.delet();
            projDocSecControl.UpdateTask();
            projDocSecControl.lstPagination();
            projDocSecControl.getSecOption();
            System.assert(projDocSecControl.projDocSec!=null, 'Project Document Section not created');
            System.assert(projDocSecControl.projDoc!=null, 'Project Document not created');
            projDocSecControl.status=true;
            projDocSecControl.IsEditableSumm=true;
            projDocSecControl.projDocSec.IPM_Gate_Document_Summary__c='test with comment.test with comment';
            projDocSecControl.projDocSec.IPM_Negotiable__c=true;
            projDocSecControl.save();
            projDocSecControl.projDocSec.IPM_Negotiable__c=false;
            projDocSecControl.projDocSec.IPM_PDP_Document_Summary__c=projDocSecControl.projDocSec.IPM_Gate_Document_Summary__c;
            projDocSecControl.project.name='testwithinvaliddatatestwithinvaliddatatestwithinvaliddatatestwithinvaliddatatestwithinvaliddatatestwithinvaliddatatestwithinvaliddata';
            projDocSecControl.save(); 
        }
        Test.stopTest();
    }
    
    public static testMethod void testSaveForBBUser(){ 
        Test.startTest();
        createTestData();
        IPM_Project_Resource__c testResource = [Select id, IPM_User__c, IPM_Role_Type__c from IPM_Project_Resource__c where id =: ipmProjectResource.id];  
        testResource.IPM_Role_Type__c = 'BB';
        update testResource; 
        IPM_Project_Resource__c projResource = [Select id, IPM_Role_Type__c from IPM_Project_Resource__c where id =: testResource.Id];
        system.assertEquals(projResource.IPM_Role_Type__c, 'BB', PROJ_RESOURCE_NOT_UPDATED);
        
        User testUser = [Select id from User where id =: testResource.IPM_User__c];
        IPM_Project_Document_Section__c testsection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: sectionList[0].Id];
        testSection.IPM_Master_Section_External_Id__c = IPM_ConstantUtils.CMI_SECTION;
        update testSection;
        IPM_Project_Document_Section__c docSection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: testSection.Id];
        system.assertEquals(docSection.IPM_Master_Section_External_Id__c, IPM_ConstantUtils.CMI_SECTION, SECTION_NOT_UPDATED);
        
        System.runAs(testUser)
        {
            PageReference pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getparameters().put('Id', projectListObj[0].ID);
            pRef.getparameters().put(PROJ_DOC_SEC_ID_STR, testSection.Id);
            Test.setCurrentPage(pRef );
            
            IPM_ProjectDocumentSectionController projDocSecControl =new IPM_ProjectDocumentSectionController();
            projDocSecControl.save();
            system.assertEquals(projDocSecControl.projectId, projectListObj[0].ID, SAVE_FAILED);
        }
        Test.stopTest();
    }
    
    public static testMethod void testSaveForCMIUser(){ 
        Test.startTest();
        createTestData();
        IPM_Project_Resource__c testResource = [Select id, IPM_User__c, IPM_Role_Type__c from IPM_Project_Resource__c where id =: ipmProjectResource.id];  
        testResource.IPM_Role_Type__c = 'CMI';
        update testResource; 
        IPM_Project_Resource__c projResource = [Select id, IPM_Role_Type__c from IPM_Project_Resource__c where id =: testResource.Id];
        system.assertEquals(projResource.IPM_Role_Type__c, 'CMI', PROJ_RESOURCE_NOT_UPDATED);
        
        User testUser = [Select id from User where id =: testResource.IPM_User__c];
        IPM_Project_Document_Section__c testsection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: sectionList[0].Id];
        testSection.IPM_Master_Section_External_Id__c = IPM_ConstantUtils.RISK_SECTION;
        update testSection;
        IPM_Project_Document_Section__c docSection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: testSection.Id];
        system.assertEquals(docSection.IPM_Master_Section_External_Id__c, IPM_ConstantUtils.RISK_SECTION, SECTION_NOT_UPDATED);
        
        System.runAs(testUser)
        {
            PageReference pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getparameters().put('Id', projectListObj[0].ID);
            pRef.getparameters().put(PROJ_DOC_SEC_ID_STR, testSection.Id);
            Test.setCurrentPage(pRef );
            
            IPM_ProjectDocumentSectionController projDocSecControl =new IPM_ProjectDocumentSectionController();
            projDocSecControl.save();
            system.assertEquals(projDocSecControl.projectId, projectListObj[0].ID, SAVE_FAILED);
        }
        Test.stopTest();
    }
    
    public static testMethod void testSaveForCDUser(){ 
        Test.startTest();
        createTestData(); 
        IPM_Project_Resource__c testResource = [Select id, IPM_User__c, IPM_Role_Type__c from IPM_Project_Resource__c where id =: ipmProjectResource.id];  
        testResource.IPM_Role_Type__c = 'CD';
        update testResource; 
        IPM_Project_Resource__c projResource = [Select id, IPM_Role_Type__c from IPM_Project_Resource__c where id =: testResource.Id];
        system.assertEquals(projResource.IPM_Role_Type__c, 'CD', PROJ_RESOURCE_NOT_UPDATED);
        
        User testUser = [Select id from User where id =: testResource.IPM_User__c];
        IPM_Project_Document_Section__c testsection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: sectionList[0].Id];
        testSection.IPM_Master_Section_External_Id__c = IPM_ConstantUtils.CMI_SECTION;
        update testSection;
        IPM_Project_Document_Section__c docSection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: testSection.Id];
        system.assertEquals(docSection.IPM_Master_Section_External_Id__c, IPM_ConstantUtils.CMI_SECTION, SECTION_NOT_UPDATED);
        
        System.runAs(testUser)
        {
            PageReference pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getparameters().put('Id', projectListObj[0].ID);
            pRef.getparameters().put(PROJ_DOC_SEC_ID_STR, testSection.Id);
            Test.setCurrentPage(pRef );
            
            IPM_ProjectDocumentSectionController projDocSecControl =new IPM_ProjectDocumentSectionController();
            projDocSecControl.save();
            system.assertEquals(projDocSecControl.projectId, projectListObj[0].ID,SAVE_FAILED);
        }
        Test.stopTest();
    }
    
    public static testMethod void testSaveForRnDUser(){ 
        Test.startTest();
        createTestData();
        IPM_Project_Resource__c testResource = [Select id, IPM_User__c, IPM_Role_Type__c from IPM_Project_Resource__c where id =: ipmProjectResource.id];  
        testResource.IPM_Role_Type__c = 'R&D';
        update testResource; 
        IPM_Project_Resource__c projResource = [Select id, IPM_Role_Type__c from IPM_Project_Resource__c where id =: testResource.Id];
        system.assertEquals(projResource.IPM_Role_Type__c, 'R&D', PROJ_RESOURCE_NOT_UPDATED);
        
        User testUser = [Select id from User where id =: testResource.IPM_User__c];
        IPM_Project_Document_Section__c testsection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: sectionList[0].Id];
        testSection.IPM_Master_Section_External_Id__c = IPM_ConstantUtils.CMI_SECTION;
        update testSection;
        IPM_Project_Document_Section__c docSection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: testSection.Id];
        system.assertEquals(docSection.IPM_Master_Section_External_Id__c, IPM_ConstantUtils.CMI_SECTION, SECTION_NOT_UPDATED);
        
        System.runAs(testUser)
        {
            PageReference pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getparameters().put('Id', projectListObj[0].ID);
            pRef.getparameters().put(PROJ_DOC_SEC_ID_STR, testSection.Id);
            Test.setCurrentPage(pRef );
            
            IPM_ProjectDocumentSectionController projDocSecControl =new IPM_ProjectDocumentSectionController();
            projDocSecControl.save();
            system.assertEquals(projDocSecControl.projectId, projectListObj[0].ID, SAVE_FAILED);
        }
        Test.stopTest();
    }
    
    public static testMethod void testSaveForSCUser(){ 
        Test.startTest();
        createTestData();
        IPM_Project_Resource__c testResource = [Select id, IPM_User__c, IPM_Role_Type__c from IPM_Project_Resource__c where id =: ipmProjectResource.id];  
        testResource.IPM_Role_Type__c = 'Supply Chain';
        update testResource; 
        IPM_Project_Resource__c projResource = [Select id, IPM_Role_Type__c from IPM_Project_Resource__c where id =: testResource.Id];
        system.assertEquals(projResource.IPM_Role_Type__c, 'Supply Chain', PROJ_RESOURCE_NOT_UPDATED);
        
        User testUser = [Select id from User where id =: testResource.IPM_User__c];
        IPM_Project_Document_Section__c testsection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: sectionList[0].Id];
        testSection.IPM_Master_Section_External_Id__c = IPM_ConstantUtils.CMI_SECTION;
        update testSection;
        IPM_Project_Document_Section__c docSection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: testSection.Id];
        system.assertEquals(docSection.IPM_Master_Section_External_Id__c, IPM_ConstantUtils.CMI_SECTION, SECTION_NOT_UPDATED);
        
        System.runAs(testUser)
        {
            PageReference pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getparameters().put('Id', projectListObj[0].ID);
            pRef.getparameters().put(PROJ_DOC_SEC_ID_STR, testSection.Id);
            Test.setCurrentPage(pRef );
            
            IPM_ProjectDocumentSectionController projDocSecControl =new IPM_ProjectDocumentSectionController();
            projDocSecControl.save();
            system.assertEquals(projDocSecControl.projectId, projectListObj[0].ID,SAVE_FAILED);
        }
        testResource.IPM_Role_Type__c = 'BB';
        update testResource; 
        
        System.runAs(testUser)
        {
            PageReference pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getparameters().put('Id', projectListObj[0].ID);
            pRef.getparameters().put(PROJ_DOC_SEC_ID_STR, testSection.Id);
            Test.setCurrentPage(pRef );
            
            IPM_ProjectDocumentSectionController projDocSecControl =new IPM_ProjectDocumentSectionController();
            projDocSecControl.project.IPM_Phase__c=IPM_ConstantUtils.PHASE_MARKET_READY;
            projDocSecControl.getIpmuserType();
        }
        
        Test.stopTest();
    }
    
    public static testMethod void testPagination(){ 
        Test.startTest();
        createTestData();
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
        IPM_Project_Resource__c testResource = [Select id, IPM_User__c, IPM_Role_Type__c from IPM_Project_Resource__c where id =: ipmProjectResource.id];  
        testResource.IPM_Role_Type__c = 'Finance';
        update testResource; 
        IPM_Project_Resource__c projResource = [Select id, IPM_Role_Type__c from IPM_Project_Resource__c where id =: testResource.Id];
        system.assertEquals(projResource.IPM_Role_Type__c, 'Finance', PROJ_RESOURCE_NOT_UPDATED);
        
        IPM_Project_Document_Section__c testsection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: sectionList[0].Id];
        testSection.IPM_Master_Section_External_Id__c = IPM_ConstantUtils.CMI_SECTION;
        testSection.IPM_FunctionalRole__c = 'Finance';
        update testSection;
        IPM_Project_Document_Section__c docSection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: testSection.Id];
        system.assertEquals(docSection.IPM_Master_Section_External_Id__c, IPM_ConstantUtils.CMI_SECTION, SECTION_NOT_UPDATED);
        
        System.runAs(globalUser)
        {
            PageReference pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getparameters().put('Id', projectListObj[0].ID);
            pRef.getparameters().put(PROJ_DOC_SEC_ID_STR, testSection.Id);
            Test.setCurrentPage(pRef );
            
            IPM_ProjectDocumentSectionController projDocSecControl =new IPM_ProjectDocumentSectionController();
            projDocSecControl.isChecked = 'true';
            projDocSecControl.save();
            system.assertEquals(projDocSecControl.projectId, projectListObj[0].ID,SAVE_FAILED);
            
            projDocSecControl.isFlagedNext = 'true';
            projDocSecControl.pagination();
            system.assertEquals(projDocSecControl.showNext, true, 'pagination functionality failed');
            
            projDocSecControl.isFlagedNext = '';
            projDocSecControl.isFlagedPre = 'true';
            projDocSecControl.pagination();
            system.assertEquals(projDocSecControl.showPre, true, 'pagination functionality failed');
            
        }
        Test.stopTest();
    }
    
    //covers IPM_BBCountryList code coverage
    IPM_BBCountryList testBBCountryList = new IPM_BBCountryList();
}