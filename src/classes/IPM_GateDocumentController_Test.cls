/******************************************************************************************************************************
* @author Cognizant 
* @date 15/12/2014
* @description Test Class for Gate Document Controller
*/
@isTest
private class IPM_GateDocumentController_Test{    
    private static IPM_Project__c project;// Project object initialization
  
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static final string PROJECT_DOC_NOT_CREATED='Project Document not created';
    private static PageReference  pRef;
    private static IPM_GateDocumentController ipmGateDocContrl;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    private static List<IPM_Project__c> projlList=new List<IPM_Project__c>();
    private static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    private static User globalUser;
    //private static User globalProjectLeader;
    private static List<IPM_Milestone__c> mileList;
    private static IPM_ProjectIntermediateController interCon;
    private static IPM_Project_Document_Section__c docSec;
    private static IPM_Project_Document__c document;
    private static User stdUserForGateDocument;
    private static final string LOCAL_STR='Local';
    private static final string REGIONAL_STR='Regional';
    private static List<IPM_Project_Rollout__c> regionalRolloutList;
    private static List<IPM_Project_Rollout__c> localRolloutList;
    private static IPM_Document_Template__c ipdt;
    private static IPM_Project_Template__c projTempl;
   
   /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
         test.startTest();
          System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForGateDocument= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForGateDocument.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForGateDocument.id,'user not created properly');//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card not inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForGateDocument);
        System.runAs(stdUserForGateDocument) {
            insert projectList;
            
            project=projectList[0];
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project insertion failed');//positive test
            
            regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{stdUserForGateDocument,stdUserForGateDocument,stdUserForGateDocument});
            insert regionalRolloutList;
            List<IPM_Project_Rollout__c> proRegListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:regionalRolloutList[0].ID LIMIT 1];
            System.assertEquals(proRegListObj[0].IPM_Rollout_Span__c,REGIONAL_STR,'regional rollout not created');//positive test
            
            Map<Id,List<IPM_Project_Rollout__c>> projectToRolloutMap = new Map<Id,List<IPM_Project_Rollout__c>>();
            List<IPM_Project_Rollout__c> projectRolloutList = new List<IPM_Project_Rollout__c>();
            for(IPM_Project_Rollout__c projectRollout : regionalRolloutList)
            {
                if(projectToRolloutMap.containsKey(projectRollout.IPM_Project__c))
                {
                    projectRolloutList = projectToRolloutMap.get(projectRollout.IPM_Project__c);
                }
                projectRolloutList.add(projectRollout);
                projectToRolloutMap.put(projectRollout.IPM_Project__c,projectRolloutList);
                
            }
            
            // Create local Rollouts for Created regional Rollouts.
            localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{stdUserForGateDocument});  
            
            insert localRolloutList; 
            localRolloutList[0].Regional_Project__c=regionalRolloutList[0].IPM_Project__c;
            update localRolloutList;
            List<IPM_Project_Rollout__c> proLocListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:localRolloutList[0].ID LIMIT 1];
            System.assertEquals(proLocListObj[0].IPM_Rollout_Span__c,LOCAL_STR,'local rollout not created');//positive test
            
            
        }
        test.stopTest();
    }
    
    /*************************************************************************************************************************
    * @description Test Data to set up the project related data
    */
    public static void initializeTestMethodData(){
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
        system.runAs(globalUser){
            projectListObj = [Select Id,IPM_Project_Type__c,IPMProject_Span__c, Source_Rollout_External_Id__c,IPM_ProjectGKM__c,IPM_CompanyCardText__c,IPM_GateKeeping_Model__c,IPM_Phase__c, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r),(select ID,IPM_Project__c from IPM_Questionnaires__r)
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
            System.assertEquals(projlList[0].id,project.id, 'Projects not creatd properly');//positive test
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                mileList=projectObj.IPM_Milestones__r;
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_NOT_CREATED);
            }
           
           
            IPM_Project_Template__c projTemplate = IPM_TestFactory_Helper.createIPMProjectTemplate(FALSE);
            insert projTemplate;
            List<IPM_Project_Template__c> projTemplList=[SELECT ID,IPM_Template_Complexity__c FROM IPM_Project_Template__c WHERE ID=:projTemplate.ID LIMIT 1];
            projTempl=projTemplList[0];        
            System.assertEquals(projTempl.IPM_Template_Complexity__c, IPM_ConstantUtils.COMPLEXITY_FULL, 'Projetc template not created properly.');
    
            IPM_Document_Template__c ipdoctem = IPM_TestFactory_Helper.creteIPMDocumentTemplate(FALSE);
            ipdoctem.IPM_Project_Template__c = projTempl.ID;
            insert ipdoctem;
            List<IPM_Document_Template__c> projDocTemplList=[SELECT ID,IPM_Project_Template__c,IPM_Document_Template_Name__c,IPM_Document_Type__c FROM IPM_Document_Template__c WHERE ID=:ipdoctem.ID LIMIT 1];
            ipdt=projDocTemplList[0];
            System.assertEquals(projDocTemplList[0].id,ipdoctem.id, 'Document template not created properly.' );//positive test
            
            IPM_Section__c secMastParent = IPM_TestFactory_Helper.createIPMSection(FALSE);
            secMastParent.IPM_Document_Template__c = ipdt.ID;
            secMastParent.IPM_Section_Label_Type__c = IPM_ConstantUtils.SECTION_TYPE_HEADER;
            insert secMastParent;
            List<IPM_Section__c> projSecMstlList=[SELECT ID,IPM_Document_Template__c,IPM_Section_Sequence__c,IPM_Section_Name__c FROM IPM_Section__c WHERE ID=:secMastParent.ID LIMIT 1];
           
            System.assertEquals(projSecMstlList[0].IPM_Document_Template__c,ipdt.ID, 'Section is not associated with document template.');//positive test
            
            //Creating master Section
            IPM_Section__c secMast = IPM_TestFactory_Helper.createIPMSection(FALSE);
            secMast.IPM_Document_Template__c = ipdt.ID;
            secMast.IPM_Parent_Section__c =secMastParent.Id;
            secMast.IPM_Section_Type__c=IPM_ConstantUtils.SECTION_TYPE_TEXT;
            insert secMast;
            List<IPM_Section__c> projSecMstlList1=[SELECT ID,IPM_Document_Template__c,IPM_Section_Sequence__c,IPM_Section_Name__c FROM IPM_Section__c WHERE ID=:secMast.ID LIMIT 1];
          
            System.assertEquals(projSecMstlList1[0].IPM_Document_Template__c,ipdt.ID, 'Section is not properly mapped with document template.');//positive test
            
            IPM_Section__c secMastHeader = IPM_TestFactory_Helper.createIPMSection(FALSE, '1', 'Introduction', 'Header');
            secMastHeader.IPM_Document_Template__c = ipdt.ID;
            secMastHeader.IPM_Section_Type__c=IPM_ConstantUtils.SECTION_TYPE_HEADER;
            insert secMastHeader;
            List<IPM_Section__c> projSecMstlList2=[SELECT ID,IPM_Document_Template__c,IPM_Section_Sequence__c,IPM_Section_Name__c FROM IPM_Section__c WHERE ID=:secMastHeader.ID LIMIT 1];
            System.assertEquals(projSecMstlList2[0].IPM_Document_Template__c,ipdt.ID, 'Section is not properly mapped with document template.');//positive test
            
            IPM_Section__c secMastSubHeader = IPM_TestFactory_Helper.createIPMSection(FALSE, '1.2', 'Justification', 'Sub Header');
            secMastSubHeader.IPM_Document_Template__c = ipdt.ID;
            secMastSubHeader.IPM_Parent_Section__c =secMastHeader.Id;
            secMastSubHeader.IPM_Section_Type__c=IPM_ConstantUtils.SECTION_TYPE_SUBHEADER;
            insert secMastSubHeader;
            List<IPM_Section__c> projSecMstlList3=[SELECT ID,IPM_Document_Template__c,IPM_Section_Sequence__c,IPM_Section_Name__c FROM IPM_Section__c WHERE ID=:secMastSubHeader.ID LIMIT 1];
            System.assertEquals(projSecMstlList3[0].IPM_Document_Template__c,ipdt.ID, 'Section is not properly mapped with document template.');//positive test
            
            IPM_Section__c secMastTopic = IPM_TestFactory_Helper.createIPMSection(FALSE, '1.2.1', 'Consumer Need', 'Topic');
            secMastTopic.IPM_Document_Template__c = ipdt.ID;
            secMastTopic.IPM_Parent_Section__c =secMastSubHeader.Id;
            secMastTopic.IPM_Section_Type__c=IPM_ConstantUtils.SECTION_TYPE_TEXT;
            insert secMastTopic;
            List<IPM_Section__c> projSecMstlList4=[SELECT ID,IPM_Document_Template__c,IPM_Section_Sequence__c,IPM_Section_Name__c FROM IPM_Section__c WHERE ID=:secMastTopic.ID LIMIT 1];
            System.assertEquals(projSecMstlList4[0].IPM_Document_Template__c,ipdt.ID, 'Section is not properly mapped with document template.');//positive test
            
            
            document=projDocList[0];
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:document.Id];
            system.assertNotEquals(projDocList[0].Id, Null, 'There is no project document');
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id, 'Project documents does not match');
            docSec=projectDocSecListObj[0];
            projectDocSecListObj[0].IPM_Section__c=secMast.Id;
            projectDocSecListObj[0].IPM_Default_Section__c=true;
            projectDocSecListObj[0].IPM_Master_Section_External_Id__c =IPM_ConstantUtils.IPM_CU_COMPLEXITY;
            projectDocSecListObj[0].IPM_FunctionalRole__c=IPM_ConstantUtils.FUNCTIONAL_ROLE_PL;
            
            projectDocSecListObj[1].IPM_Section__c=secMastHeader.Id;
            projectDocSecListObj[1].IPM_Default_Section__c=true;
            projectDocSecListObj[1].IPM_Master_Section_External_Id__c ='Introduction';
            projectDocSecListObj[1].IPM_FunctionalRole__c='MKTG DEV';
            
            projectDocSecListObj[2].IPM_Section__c=secMastSubHeader.Id;
            projectDocSecListObj[2].IPM_Default_Section__c=true;
            projectDocSecListObj[2].IPM_Master_Section_External_Id__c ='Justification';
            
            projectDocSecListObj[3].IPM_Section__c=secMastTopic.Id;
            projectDocSecListObj[3].IPM_Default_Section__c=true;
            projectDocSecListObj[3].IPM_Master_Section_External_Id__c ='Consumer_Need';
            projectDocSecListObj[3].IPM_FunctionalRole__c='MKTG DEV';
            
            update projectDocSecListObj;
            pRef = Page.IPM_GateDocument;
            pRef.getParameters().put(IPM_ConstantUtils.SF_ID, projectListObj[0].Id);
            pRef.getParameters().put('printDoc', IPM_ConstantUtils.CHARTER_GATE);
            Test.setCurrentPage(pRef);
            interCon=new IPM_ProjectIntermediateController ();
            interCon.project.Id=projectListObj[0].Id;
            
        }
    }

    
    
    /*************************************************************************************************************************
* @description Running Test Script To test the Constructor
*/ 
    static testMethod void getProjectDocumentTest(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
         ipmGateDocContrl=new IPM_GateDocumentController();
            ipmGateDocContrl.DueDateMsg=false;
            ipmGateDocContrl.isPDLApproved = TRUE;
            ipmGateDocContrl.lstMstn=new List<IPM_Milestone__c>();
            ipmGateDocContrl.lstMstn.add(mileList[0]);
            ipmGateDocContrl.getProjectDocument();
            ipmGateDocContrl.project.IPM_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
            ipmGateDocContrl.project.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_GCLT;
            ipmGateDocContrl.getProjectDocument();
            ipmGateDocContrl.project.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
            ipmGateDocContrl.getProjectDocument();
            ipmGateDocContrl.project.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            ipmGateDocContrl.getProjectDocument();
            ipmGateDocContrl.project.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            ipmGateDocContrl.getProjectDocument();
            ipmGateDocContrl.project.IPM_Phase__c=IPM_ConstantUtils.PHASE_CAPABILITY;
            ipmGateDocContrl.getProjectDocument();
            ipmGateDocContrl.project.IPM_Phase__c=IPM_ConstantUtils.MARKET_READY_GATE;
            ipmGateDocContrl.project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            ipmGateDocContrl.getProjectDocument();
            ipmGateDocContrl.project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            ipmGateDocContrl.getProjectDocument();
            ipmGateDocContrl.project.IPM_Phase__c=IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE;
            ipmGateDocContrl.getProjectDocument();
            ipmGateDocContrl.project.IPM_Phase__c=IPM_ConstantUtils.PHASE_PLE;
            ipmGateDocContrl.getProjectDocument();
            ipmGateDocContrl.project.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
            ipmGateDocContrl.getProjectDocument();
            
            List<IPM_Project_Document__c> lstProjectDoc=[SELECT Id,IPM_Contract_GateKeeper_Model__c,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,
            IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c 
            FROM IPM_Project_Document__c 
            WHERE IPM_Project__c=:project.Id and IPM_GateDocuments__c=:ipmGateDocContrl.gateDocument];
            System.assertEquals(lstProjectDoc[0].IPM_GateDocuments__c,ipmGateDocContrl.gateDocument,'gate doc not matched');
            test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
* @description Running Test Script to check the Documet Sections are fetched
*/ 
    static testMethod void getProjectDocumentSectionTest(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ApexPages.currentPage().getParameters().put('setStatus',IPM_ConstantUtils.STATUS_APPROVED);
            ApexPages.currentPage().getParameters().put('StatusDate', '11/11/2016');
            ApexPages.currentPage().getParameters().put('StatusComments','test comment');
            Attachment att = new Attachment(name='att',  parentId = projDocList[0].Id, body = Blob.valueOf('test att'));
            insert att;
        ipmGateDocContrl=new IPM_GateDocumentController();
            ipmGateDocContrl.dueDate = '11/11/2016';
            ipmGateDocContrl.regionalCPP = 'test';
            ipmGateDocContrl.localCPP = 'test';
            ipmGateDocContrl.reactivateProjectFlag = true;
            ipmGateDocContrl.attachmentName = 'test';
            ipmGateDocContrl.projectDoc.Id=projDocList[0].Id;
            ipmGateDocContrl.isPDLApproved = true;
            ipmGateDocContrl.isPDLDocument = true;
            ipmGateDocContrl.getFilledInPercent();
            ipmGateDocContrl.getProjectDocumentSection();
            ipmGateDocContrl.getPdlDocumentStatus();
            List<IPM_Project_Document_Section__c>projSubSectionList=[SELECT Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c, IPM_Section_Sequence__c, 
            IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,
            IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c,IPM_Project_Document__c,
            IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Count_of_Comments__c,IPM_FunctionalRole__c,IPM_Has_Appendix__c,
            IPM_GateHistory__c,IPM_GateHistory_Date__c,IPM_Gate_Document_Summary__c,LastModifiedBy.Name,LastModifiedDate,IPM_Master_Section_External_Id__c 
            FROM IPM_Project_Document_Section__c 
            WHERE IPM_Project_Document__c=:ipmGateDocContrl.projectDoc.Id AND IPM_Section__r.IPM_Parent_Section__c =:ipmGateDocContrl.parentSectionId AND IPM_Default_Section__c=true  order by IPM_Section__r.IPM_Section_Sequence__c asc limit 50000];  
            
            if(!projSubSectionList.isEmpty())   
            {
                System.assert(projSubSectionList[0].IPM_Default_Section__c,'project section is not proper');
            }
            test.stopTest();
        }
    }

    /*************************************************************************************************************************
* @description Running Test Script to get the Appendix sections
*/ 
    static testMethod void getAppendixSectionsTest() {  
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();   
            ipmGateDocContrl=new IPM_GateDocumentController();
            ipmGateDocContrl.isPDLApproved = true;
            ipmGateDocContrl.projectDoc.Id=projDocList[0].Id;
            docSec.IPM_Has_Appendix__c=true;
            docSec.IPM_Default_Section__c=true;
            update docSec;
            system.assertEquals(docSec.IPM_Project_Document__c,projDocList[0].Id, 'Record Not Same');
            
            ipmGateDocContrl=new IPM_GateDocumentController ();
            ipmGateDocContrl.projectDoc.Id=document.Id;
            ipmGateDocContrl.getAppendixSections();
            List<IPM_Project_Document_Section__c>projDocAppdxSectionList=[SELECT ID,IPM_Has_Appendix__c,IPM_FunctionalRole__c,IPM_Master_Section_External_Id__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section_Sequence__c,IPM_Section_Name__c 
                                                                          FROM IPM_Project_Document_Section__c 
                                                                          WHERE IPM_Project_Document__c=:ipmGateDocContrl.projectDoc.Id 
                                                                          AND IPM_Has_Appendix__c=true AND IPM_Default_Section__c=true 
                                                                          ORDER BY IPM_Section_Sequence_Number__c asc limit 50000];
            System.assert(projDocAppdxSectionList[0].IPM_Has_Appendix__c,'Project document sections not updated properly');           
            test.stopTest();                                         
        }
    }
    /*************************************************************************************************************************
* @description Running Test Script to set up vaius rendereing condition from controller
*/ 
    static testMethod void isEditLinkAvailableTest(){ 
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();  
            ipmGateDocContrl=new IPM_GateDocumentController();          
            ipmGateDocContrl.isEditLinkAvailable();
            System.assertEquals(ipmGateDocContrl.isEditLinkActive,true,'Project document sections not updated properly');
            test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
* @description Running Test Script
*/ 
    static testMethod void showAttchSectionTest(){   
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmGateDocContrl=new IPM_GateDocumentController();
            ipmGateDocContrl.sectionId=projectDocSecListObj[0].Id;
            List<Attachment>attachmentList=[SELECT Id,Name,ParentId,Description FROM Attachment WHERE ParentId=:ipmGateDocContrl.sectionId limit 1];
            System.assertEquals(attachmentList.size(),0,'Attachment found');//Negative Assert
            test.stopTest();
        }
    }
    
    //Test method for controller class IPM_PDocAttachmentListCtrl
    static testMethod void IPM_PDocAttachmentListCtrlTest(){
        initializeTestMethodData();
        system.runAs(globalUser){
            
            ApexPages.StandardController sc = new ApexPages.StandardController(project);
            IPM_PDocAttachmentListCtrl docCtrl = new IPM_PDocAttachmentListCtrl(sc);
            System.assert(docCtrl.documentList.size() == 0,'Attachment Exists!!');  
            
            attachment att = new attachment(name='Gate_Document', ParentId= projectDocSecListObj[0].Id, body=blob.ValueOf('test'));
            insert att;
            
            pRef = Page.IPM_GateDocAttchList;
            pRef.getParameters().put('id', project.Id);
            Test.setCurrentPage(pRef);
            Test.startTest();
            List<Attachment> lstAttachment = [Select Id,Name from attachment where Name like :IPM_ConstantUtils.GD_ATTACHMENT_SUFFIX limit 1];
            System.assertEquals(lstAttachment.size(),1,'Attachment missing for Gate doc.');// Negative Test
  
            Test.stopTest();
        }
    }
    
     /*************************************************************************************************************************
* @description Running Test Script to check the Documet Sections are fetched
*/ 
    static testMethod void IPMSequenceTest(){
        
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmGateDocContrl=new IPM_GateDocumentController();
            List<IPM_Project_Document_Section__c> projectDocSecList = [Select Id,IPM_Section__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:document.Id];
            ipmGateDocContrl.isPDLApproved = TRUE;
            IPM_Section__c sec = [Select Id, IPM_Section_Sequence__c From IPM_Section__c WHERE Id =:projectDocSecList[0].IPM_Section__c];
            sec.IPM_Section_Sequence__c = '2.2';
            sec.IPM_Negotiable__c = true;
            update sec;
            ipmGateDocContrl=new IPM_GateDocumentController();            
            
            sec.IPM_Section_Sequence__c = '3.2';
            update sec;
            ipmGateDocContrl=new IPM_GateDocumentController();
            
            sec.IPM_Section_Sequence__c = '4.2';
            update sec;
            System.assertEquals(sec.IPM_Section_Sequence__c,'4.2','Section Sequence Not updated');
            ipmGateDocContrl=new IPM_GateDocumentController();
          
            
            test.stopTest();
        }
    }
    /*************************************************************************************************************************
* @description Running Test Script to check the Documet Sections are fetched
*/  
    static testMethod void IPMSequenceTest2(){
        
        initializeTestMethodData();
        system.RunAs(globalUser){
             test.startTest();
            //ipmGateDocContrl=new IPM_GateDocumentController();
            List<IPM_Project_Document_Section__c> projectDocSecList = [Select Id,IPM_Section__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:document.Id];
            
            IPM_Section__c sec = [Select Id, IPM_Section_Sequence__c From IPM_Section__c WHERE Id =:projectDocSecList[0].IPM_Section__c];
            sec.IPM_Section_Sequence__c = '2.2';
            sec.IPM_Negotiable__c = false;
            update sec;
            ipmGateDocContrl=new IPM_GateDocumentController();    
            
            sec.IPM_Section_Sequence__c = '3.2';
            sec.IPM_Negotiable__c = false;
            update sec;
            ipmGateDocContrl=new IPM_GateDocumentController();
            
            sec.IPM_Section_Sequence__c = '4.2';
            sec.IPM_Negotiable__c = false;
            update sec;
            ipmGateDocContrl=new IPM_GateDocumentController();
            
            sec.IPM_Section_Sequence__c = '5.2';
            sec.IPM_Negotiable__c = false;
            update sec;
            projectDocSecList[0].IPM_FunctionalRole__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_SC;
            update projectDocSecList;
            ipmGateDocContrl=new IPM_GateDocumentController();
            
            sec.IPM_Section_Sequence__c = '6.2';
            sec.IPM_Negotiable__c = false;
            update sec;
            
            System.assertEquals(sec.IPM_Section_Sequence__c,'6.2','Section Sequence Not updated');
            
            projectDocSecList[0].IPM_FunctionalRole__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_BB;
            update projectDocSecList;
            
          
            ipmGateDocContrl=new IPM_GateDocumentController();
         
            test.stopTest();
        }

    }
    
     static testMethod void IPMSequenceTest3(){
          initializeTestMethodData();
         system.RunAs(globalUser){
             test.startTest();
             
             List<IPM_Project_Document_Section__c> projectDocSecList = [Select Id,IPM_Section__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:document.Id];
             IPM_Section__c sec = [Select Id, IPM_Section_Sequence__c From IPM_Section__c WHERE Id =:projectDocSecList[0].IPM_Section__c];
             sec.IPM_Section_Sequence__c = '7.2';
             sec.IPM_Negotiable__c = false;
             update sec;
             projectDocSecList[0].IPM_FunctionalRole__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_RD;
             update projectDocSecList;
             ipmGateDocContrl=new IPM_GateDocumentController();
             
            sec.IPM_Section_Sequence__c = '5.2';
            sec.IPM_Negotiable__c = true;
            update sec;
            projectDocSecList[0].IPM_FunctionalRole__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_Finance;
            update projectDocSecList;
            ipmGateDocContrl=new IPM_GateDocumentController();
             
            sec.IPM_Section_Sequence__c = '6.2';
            sec.IPM_Negotiable__c = true;
            update sec;
            System.assertEquals(sec.IPM_Section_Sequence__c,'6.2','Section Sequence Not updated');
            
            projectDocSecList[0].IPM_FunctionalRole__c =  IPM_ConstantUtils.FUNCTIONAL_ROLE_BD;
            update projectDocSecList;
            ipmGateDocContrl=new IPM_GateDocumentController(); 
             
             test.stopTest();
         }
     }
    
     static testMethod void IPMSequenceTest4(){
          initializeTestMethodData();
          system.RunAs(globalUser){
             test.startTest();
             
             List<IPM_Project_Document_Section__c> projectDocSecList = [Select Id,IPM_Section__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:document.Id];
             IPM_Section__c sec = [Select Id, IPM_Section_Sequence__c From IPM_Section__c WHERE Id =:projectDocSecList[0].IPM_Section__c];
             sec.IPM_Section_Sequence__c = '1.2';
             sec.IPM_Negotiable__c = true;
             update sec;
             projectDocSecList[0].IPM_Section_Status__c = 'Filled-in';
             projectDocSecList[0].IPM_FunctionalRole__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI;
             update projectDocSecList;
             
             ipmGateDocContrl=new IPM_GateDocumentController();
             ipmGateDocContrl.isPDLApproved = TRUE;
             sec.IPM_Section_Sequence__c = '7.2';
             sec.IPM_Negotiable__c = true;
             update sec;
             System.assertEquals(sec.IPM_Section_Sequence__c,'7.2','Section Sequence Not updated');
             
             projectDocSecList[0].IPM_Section_Status__c = 'Excluded';
             projectDocSecList[0].IPM_FunctionalRole__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_CD;
             update projectDocSecList;
             System.assertEquals(projectDocSecList[0].IPM_FunctionalRole__c,IPM_ConstantUtils.FUNCTIONAL_ROLE_CD,'Function Role Not updated');

             ipmGateDocContrl=new IPM_GateDocumentController();
             test.stopTest();
         }
     }
     /*************************************************************************************************************************
* @description Running Test Script to get the Dynamic sections based on Refactor
*/ 
    static testMethod void testDocumentAndCancel(){
        initializeTestMethodData();
       // Test.setCurrentPage(Page.IPM_GateDocumentPDF);
        system.RunAs(globalUser){
            test.startTest();
           
           ipmGateDocContrl=new IPM_GateDocumentController();
            
            ipmGateDocContrl.moveToNextDocument();
            IPM_Financial__c finr = [SELECT  Financial_External_ID__c FROM IPM_Financial__c WHERE Parent_Project__c =: projectListObj[0].Id limit 1];
            
            /*IPM_Project_Type__c currentProjectType =  IPM_Utils.retrieveProjectType(projectListObj[0]);*/
           
  			projectListObj[0].IPMProject_Span__c = 'Local';
  			 projectListObj[0].IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
  			update projectListObj[0];
  			
            finr.Financial_External_ID__c =  projectListObj[0].Source_Rollout_External_Id__c;
            update finr;
            
            ipmGateDocContrl.moveToNextDocument();
            
            ipmGateDocContrl.projectDoc.Id=projDocList[0].Id;
            List<IPM_Project_Document_Section__c>projSubLevelSectionList=[SELECT Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c, IPM_Section_Sequence__c, 
            IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,
            IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c,IPM_Project_Document__c,
            IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Count_of_Comments__c,IPM_FunctionalRole__c,IPM_Has_Appendix__c,
            IPM_GateHistory__c,IPM_GateHistory_Date__c,IPM_Gate_Document_Summary__c,LastModifiedBy.Name,LastModifiedDate,IPM_Master_Section_External_Id__c 
            FROM IPM_Project_Document_Section__c 
            WHERE IPM_Project_Document__c=:ipmGateDocContrl.projectDoc.Id AND IPM_Section__r.IPM_Parent_Section__r.ID=:ipmGateDocContrl.parentSectionId AND IPM_Default_Section__c=true  order by IPM_Section__r.IPM_Section_Sequence__c asc limit 50000];
      if(!projSubLevelSectionList.isEmpty())  
      {
        System.assert(projSubLevelSectionList[0].IPM_Default_Section__c,'Project document sections not updated properly');
      }
      
       ipmGateDocContrl=new IPM_GateDocumentController();
            ipmGateDocContrl.projectDoc.Id=projDocList[0].Id;
            projSubLevelSectionList=[SELECT Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c, IPM_Section_Sequence__c, 
            IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,
            IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c,IPM_Project_Document__c,
            IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Count_of_Comments__c,IPM_FunctionalRole__c,IPM_Has_Appendix__c,
            IPM_GateHistory__c,IPM_GateHistory_Date__c,IPM_Gate_Document_Summary__c,LastModifiedBy.Name,LastModifiedDate,IPM_Master_Section_External_Id__c 
            FROM IPM_Project_Document_Section__c 
            WHERE IPM_Project_Document__c=:ipmGateDocContrl.projectDoc.Id AND IPM_Section__r.IPM_Parent_Section__r.ID=:ipmGateDocContrl.parentSectionId AND IPM_Default_Section__c=true  order by IPM_Section__r.IPM_Section_Sequence__c asc limit 50000];
      if(!projSubLevelSectionList.isEmpty())  
      {
        System.assert(projSubLevelSectionList[0].IPM_Default_Section__c,'Project document sections not updated properly');
      }
      ipmGateDocContrl.cancelStoppingProject();

      ipmGateDocContrl.showAllCurrentDocSummaryAttch();
      ipmGateDocContrl=new IPM_GateDocumentController();
      ipmGateDocContrl.moveToPLE();
          test.stopTest();
      }
    }

}