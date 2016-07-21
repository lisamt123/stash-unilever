/**
* @author       Cognizant 
* @date         28/12/2015
* @description  This class is used to test the functionality of IPM_GetHelpDoc class 
*/
@isTest
public class IPM_GetHelpDoc_Test{
    public static IPM_GetHelpDoc ipmHelpDoc = null;
    public static PageReference  pRef;
    public static User globalUser;
    public static User stdUserForGetHelpDoc;
    public static  Document doc;
    public static String docName='IPM_HomePage';
    public static List<IPM_Milestone__c> mileList=new List<IPM_Milestone__c>();
    public static IPM_Project__c project;// Project object initialization
     private static final string TEST_COMMENTS_STR='TestComments1';
     public static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
      /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
        // user has to be created as system admin 
            stdUserForGetHelpDoc= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForGetHelpDoc.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForGetHelpDoc.id,'user id is:'+userLists[0].id);//positive test
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        List<IPM_Project__c>projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForGetHelpDoc);
        System.runAs(stdUserForGetHelpDoc) {
            insert projectList;
            
            project=projectList[0];
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project name');//positive test
        }
    }
    
     /*************************************************************************************************************************
    * @description Test Data
    */
    public static void initializeTestMethodData(){
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
        
        system.runAs(globalUser){
        
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),
            (Select Id,Name from IPM_Milestones__r)
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            
            for(IPM_Project__c projectObj : projectListObj) {
              mileList= projectObj.IPM_Milestones__r;
            }
            
        
        doc = new Document();
        doc.Name = docName;
        doc.Type = 'PDF';
        doc.Description = 'Help File';
        doc.FolderId = UserInfo.getUserId();
        insert doc;
        
        List<Document>docList=[select Id,Description from Document where Id=:doc.Id Limit 1];
        System.assertEquals(docList[0].Description,'Help File','doc not inserted');
            
        }
    }
    
    
    static testMethod void helpDocTest(){
       initializeTestMethodData();
        system.runAs(globalUser){
        pRef = Page.IPM_HomePage;
        
        Test.setCurrentPage(pRef);

        Test.startTest();
        
        
         ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(doc);
        ipmHelpDoc = new IPM_GetHelpDoc(sc);
        ipmHelpDoc.milestoneObj=mileList[0];
        ipmHelpDoc.helpDocName=docName;
        IPM_Team_Assignment_Controller teamAssignCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(teamAssignCtrl);
        IPM_HomePageController homePageCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(homePageCtrl);
        IPM_ProjectSearchCtrl projSearchCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(projSearchCtrl);
        IPM_BosscardStatusController bosscardStatusCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(bosscardStatusCtrl);
        IPM_CreateProject createProject = null;
        ipmHelpDoc = new IPM_GetHelpDoc(createProject);
        IPM_ImageUploadController imageUploadCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(imageUploadCtrl);
        IPM_Coreparameters coreParam = null;
        ipmHelpDoc = new IPM_GetHelpDoc(coreParam);
        IPM_GateDocumentController gateDocCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(gateDocCtrl);
        IPM_AddManageSection addSection = null;
        ipmHelpDoc = new IPM_GetHelpDoc(addSection);
        IPM_GateDocumentRiskManagement gateDocRiskMgmt = null;
        ipmHelpDoc = new IPM_GetHelpDoc(gateDocRiskMgmt);
        IPM_Resource_Allocation resourceAllocation = null;
        ipmHelpDoc = new IPM_GetHelpDoc(resourceAllocation);
        IPM_ProjDocumentSectionHstryController docSectionCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(docSectionCtrl);
        IPM_ProjectDocumentSectionController projDocSectionCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(projDocSectionCtrl);
        IPM_ChangProjectDocumentStatusController projDocStatusChange = null;
        ipmHelpDoc = new IPM_GetHelpDoc(projDocStatusChange);
        IPM_RolloutPlansAddController addRolloutCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(addRolloutCtrl);
        IPM_RolloutPlansTableController rolloutTableCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(rolloutTableCtrl);
        IPM_FinancialController financeCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(financeCtrl);
        IPM_FinancialCopyPasteGrid financeGridCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(financeGridCtrl);
        IPM_CommentsListController commentsCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(commentsCtrl);
        IPM_ChannelImageController channelImageCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(channelImageCtrl);
        IPM_UploadBusinessCase businessCase = null;
        ipmHelpDoc = new IPM_GetHelpDoc(businessCase);
        IPM_FileUploadController fileUploadCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(fileUploadCtrl);
        
        String str=ipmHelpDoc.getURL();
        List<Document> lstDocument = [Select Id,Name from Document where Name =:ipmHelpDoc.helpDocName  limit 1];
        System.assertEquals(lstDocument[0].Name,docName,'func not caled');
        
        Test.stopTest();
        }
        
    }
    
    
    static testMethod void NegativehelpDocTest(){
       initializeTestMethodData();
        system.runAs(globalUser){
        pRef = Page.IPM_HomePage;
        
        Test.setCurrentPage(pRef);

        Test.startTest();
        IPM_BCCController bccCtrl = null;
        ipmHelpDoc = new IPM_GetHelpDoc(bccCtrl);
        ipmHelpDoc.helpDocName='docName11';
        String str=ipmHelpDoc.getURL();
        List<Document> lstDocument = [Select Id,Name from Document where Name =:ipmHelpDoc.helpDocName  limit 1];
        System.assertEquals(lstDocument.size(),0,'negative scenario called');
        Test.stopTest();
        }
    }
}