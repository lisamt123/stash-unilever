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
    private static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    private static List<IPM_Project__c> projectListObj = new List<IPM_Project__c>();
    private static List<IPM_Project_Document_Section__c> sectionList = new List<IPM_Project_Document_Section__c>();
    private static IPM_Project_Document_Section_Content__c sectionContent;
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static IPM_Project_Resource__c ipmProjectResource; 
    private static List<IPM_Gate_CMI__c> gateCMI = new List<IPM_Gate_CMI__c>();
    private static List<IPM_Questionnaire__c> questionaire = new List<IPM_Questionnaire__c>();
    private static final String PRODUCT_SECTION = 'Product';
    
    
    /***********************************
* @Description: Test Data Creation
* *********************************/

    @testSetup static void projectSetUp() 
    {  
      test.startTest();
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
            projectList[0].IPM_Phase__c = 'Ideas';
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
            projectListObj = [Select Id, Name, IPM_Phase__c,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_ProjectGKM__c,IPM_CompanyCardText__c, IPM_Technical_Project_Leader__c, (Select Id,IPM_GateDocuments__c from Project_Documents__r)
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
  private static PageReference currentPageSetup(){
    	PageReference pRef = Page.IPM_ProjectDocumentSectionEditor;
        pRef.getparameters().put('Id', projectListObj[0].ID);
        pRef.getparameters().put(PROJ_DOC_SEC_ID_STR, sectionList[0].Id);
        return pRef;
    }
    public static testMethod void testSave(){ 
        createTestData();
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
        System.runAs(globalUser)
        {
            Test.startTest();
            PageReference pRef = currentPageSetup();
            Test.setCurrentPage(pRef );
            
            IPM_ProjectDocumentSectionController projDocSecControl=new IPM_ProjectDocumentSectionController();
            projDocSecControl.selectedOTIFStatus='abc';
            projDocSecControl.gateDocument=IPM_ConstantUtils.CHARTER_GATE;
            projDocSecControl.secList='asd';
            projDocSecControl.isFlagedNext = 'True';
            projDocSecControl.isChecked = 'true';
            projDocSecControl.IsGateSave = 'Gate';
            projDocSecControl.save();
            
            system.assert(projDocSecControl.projDocSec!=null, 'Project Document Section not created');			
            								 
            projDocSecControl.cancel();
            PageReference url = projDocSecControl.cancel();
            String urlStr = url.getURL();
            system.assert(urlStr.Contains(projectListObj[0].ID),'Url for Cancel not formed properly');
            system.assert(urlStr.Contains(sectionList[0].Id),'Url for Cancel not formed properly');
            
            projDocSecControl.TaskDelete();
            
            PageReference newSec = projDocSecControl.lstPagination();
            String newSecStr = newSec.getUrl();
            system.assert(newSecStr.Contains(projectListObj[0].ID),'Url for Cancel not formed properly');
            system.assert(newSecStr.Contains(sectionList[0].Id),'Url for Cancel not formed properly');
            
            List<SelectOption> options = projDocSecControl.getSecOption();
            system.assert(options.size()==1, 'There are no options to select');
           
            projDocSecControl.charcterCount();
            
            system.assert(projDocSecControl.projDoc!=null, 'Project Document not created');
            
            projDocSecControl.status=true;
            projDocSecControl.projDocSec.IPM_FunctionalRole__c=IPM_ConstantUtils.FUNCTIONAL_ROLE_RnD;
            projDocSecControl.IsEditableSumm=true;
            projDocSecControl.projDocSec.IPM_Gate_Document_Summary__c='test with comment.test with comment';
            projDocSecControl.projDocSec.IPM_Negotiable__c=true;
            projDocSecControl.save();
            
            IPM_Project_Document_Section__c prjDSection = [select id, IPM_FunctionalRole__c, IPM_Gate_Document_Summary__c, IPM_Negotiable__c from IPM_Project_Document_Section__c where id = :sectionList[0].Id ];
            system.assert(projDocSecControl.projDocSec.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_RnD,'Functional Role not updated');
            system.assert(projDocSecControl.projDocSec.IPM_Gate_Document_Summary__c=='test with comment.test with comment','Gate Document summary not saved');
            system.assert(projDocSecControl.projDocSec.IPM_Negotiable__c==true,'Project Document section is not negotiable');
            
            
            projDocSecControl.projDocSec.IPM_Negotiable__c=true;
            projDocSecControl.projDocSec.IPM_Gate_Document_Summary__c='test with comment.test with comment';
            projDocSecControl.projDocSec.IPM_FunctionalRole__c=IPM_ConstantUtils.FUNCTIONAL_ROLE_SC;
            projDocSecControl.save();
            
            prjDSection = [select id, IPM_FunctionalRole__c from IPM_Project_Document_Section__c where id = :sectionList[0].Id ];
            system.assert(projDocSecControl.projDocSec.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_SC,'Functional Role not updated');
            
            projDocSecControl.projDocSec.IPM_Negotiable__c=false;
            projDocSecControl.projDocSec.IPM_PDP_Document_Summary__c=projDocSecControl.projDocSec.IPM_Gate_Document_Summary__c;
            IPM_ProjectDocumentSectionController.project.name='testwithinvaliddatatestwithinvaliddatatestwithinvaliddatatestwithinvaliddatatestwithinvaliddatatestwithinvaliddatatestwithinvaliddata';
            projDocSecControl.save(); 
            prjDSection = [select id, IPM_Negotiable__c from IPM_Project_Document_Section__c where id = :sectionList[0].Id ];
            system.assert(projDocSecControl.projDocSec.IPM_Negotiable__c==false,'Document is Negotiable');
            projectListObj = [Select Id, Name, IPM_Phase__c,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_ProjectGKM__c,IPM_CompanyCardText__c, IPM_Technical_Project_Leader__c, (Select Id,IPM_GateDocuments__c from Project_Documents__r)
            from IPM_Project__c LIMIT 10]; 
            for(Integer i = 0; i< projectListObj.size();i++){
                projectListObj[i].IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            }
            update projectListObj;
       
            IPM_ProjectDocumentSectionController projDocSecControl1=new IPM_ProjectDocumentSectionController(); 
            projDocSecControl1.save();
            Test.stopTest();
        }
        
    }
    
    public static testMethod void testSaveForBBUser(){ 
        Test.startTest();
        createTestData();
        IPM_Project_Resource__c testResource = [Select id, IPM_User__c, IPM_Role_Type__c from IPM_Project_Resource__c where id =: ipmProjectResource.id];  
        testResource.IPM_Role_Type__c = 'BB';
        update testResource; 
        
        testResource = [Select id, IPM_User__c, IPM_Role_Type__c from IPM_Project_Resource__c where id =: ipmProjectResource.id];
        system.assert(testResource.IPM_Role_Type__c == 'BB', 'Role not updated');
        
        
        IPM_Project_Resource__c projResource = [Select id, IPM_Role_Type__c from IPM_Project_Resource__c where id =: testResource.Id];
        system.assertEquals(projResource.IPM_Role_Type__c, 'BB', PROJ_RESOURCE_NOT_UPDATED);
        
        User testUser = [Select id from User where id =: testResource.IPM_User__c];
        IPM_Project_Document_Section__c testsection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: sectionList[0].Id];
        testSection.IPM_Master_Section_External_Id__c = IPM_ConstantUtils.CMI_SECTION;
        update testSection;
        testsection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: sectionList[0].Id];
        system.assert(testSection.IPM_Master_Section_External_Id__c == IPM_ConstantUtils.CMI_SECTION, 'Master Section External ID not updated');
        
        IPM_Project_Document_Section__c docSection = [Select id, IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where id =: testSection.Id];
        system.assertEquals(docSection.IPM_Master_Section_External_Id__c, IPM_ConstantUtils.CMI_SECTION, SECTION_NOT_UPDATED);
        
        System.runAs(testUser)
        {
            PageReference pRef = currentPageSetup();
            Test.setCurrentPage(pRef );
            projectListObj = [Select Id, Name, IPM_Phase__c,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_ProjectGKM__c,IPM_CompanyCardText__c, IPM_Technical_Project_Leader__c, (Select Id,IPM_GateDocuments__c from Project_Documents__r)
            from IPM_Project__c LIMIT 100]; 
            for(Integer i = 0; i< projectListObj.size();i++){
                projectListObj[i].IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            }
            update projectListObj;
            
             docSection.IPM_Gate_Document__c = IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE;
             docSection.IPM_Master_Section_External_Id__c = PRODUCT_SECTION;
             update docSection;
             
             docSection = [Select id, IPM_Master_Section_External_Id__c,IPM_Gate_Document__c from IPM_Project_Document_Section__c where id =: testSection.Id];
             system.assert(docSection.IPM_Gate_Document__c == IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE , 'Gate Document not updated');
             system.assert(docSection.IPM_Master_Section_External_Id__c == PRODUCT_SECTION , 'Master Section External id not updated');
            
            IPM_ProjectDocumentSectionController projDocSecControl =new IPM_ProjectDocumentSectionController();
            projDocSecControl.save();
            projDocSecControl.showGlobalClaimsComponent();
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
            PageReference pRef = currentPageSetup();
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
            PageReference pRef = currentPageSetup();
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
            PageReference pRef = currentPageSetup();
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
            PageReference pRef = currentPageSetup();
            Test.setCurrentPage(pRef );
            
            IPM_ProjectDocumentSectionController projDocSecControl =new IPM_ProjectDocumentSectionController();
            projDocSecControl.save();
            system.assertEquals(projDocSecControl.projectId, projectListObj[0].ID,SAVE_FAILED);
        }
        testResource.IPM_Role_Type__c = 'BB';
        update testResource; 
        
        testResource = [Select id, IPM_User__c, IPM_Role_Type__c from IPM_Project_Resource__c where id =: ipmProjectResource.id]; 
        system.assert(testResource.IPM_Role_Type__c == 'BB', 'Role not updated');
        
        System.runAs(testUser)
        {
            PageReference pRef = currentPageSetup();
            Test.setCurrentPage(pRef );
            
            IPM_ProjectDocumentSectionController projDocSecControl =new IPM_ProjectDocumentSectionController();
            IPM_ProjectDocumentSectionController.project.IPM_Phase__c=IPM_ConstantUtils.PHASE_MARKET_READY;
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
           PageReference pRef = currentPageSetup();
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
            
            projDocSecControl.projDocSec.IPM_Master_Section_External_Id__c = IPM_ConstantUtils.RISK_SECTION;
            
            update projDocSecControl.projDocSec;
            projDocSecControl.checkRMPFilled();
            projDocSecControl.IsNotify();
            
            Account acc=new Account(Name='Acme Inc');
            insert acc;
            
            Attachment attach=new Attachment();     
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=acc.id;
            insert attach;
            
            Attachment a = [SELECT Id FROM Attachment WHERE Id=:attach.Id];
            projDocSecControl.delet();
            Delete a;
            projDocSecControl.delet();
            // Task Update
            List<IPM_Task__c> taskToUpdate = [Select IPM_Type_of_Task__c,IPM_Completed__c,IPM_Completed_Date__c,IPM_Master_Task__c,IPM_Assignee__c,IPM_Project__c from IPM_Task__c LIMIT 1000];
            taskToUPdate[0].IPM_Completed__c = TRUE;
            taskToUPdate[0].IPM_Completed_Date__c = System.today();
            update taskToUpdate;
            projDocSecControl.UpdateTask();   
            
            taskToUPdate[0].IPM_Completed__c = FALSE;
            taskToUPdate[0].IPM_Completed_Date__c = System.today().addDays(1);
            update taskToUpdate;
            projDocSecControl.UpdateTask();
        }
        
        Test.stopTest();
    }
 
    //covers IPM_BBCountryList code coverage
    IPM_BBCountryList testBBCountryList = new IPM_BBCountryList();
}