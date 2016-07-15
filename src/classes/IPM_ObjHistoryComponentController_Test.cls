/******************************************************************************************************************************
* @author Cognizant 
* @date 15/12/2014
* @description Test Class for IPM_ObjectHistoryComponentController
*/
@isTest
private class IPM_ObjHistoryComponentController_Test{    
    private static IPM_Project__c project;// Project object initialization
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<user>userList=new List<user>();
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    private static PageReference  pRef;
    private static IPM_ObjectAllHistoryComponentController objHistoryALL;
    private static IPM_ObjectHistoryComponentController objHistory;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    private static List<IPM_Project__c> projlList=new List<IPM_Project__c>();
    private static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    private static IPM_Project_Document_Section_Content__c projectDocSecConListObj=new IPM_Project_Document_Section_Content__c();
    private static User globalUser;
    
    public static IPM_Project_Document_Section__c docSec;
    private static final String TEST_SUMMARY = 'Setup the History data';
   
    private static final String TEST_DATA = 'TEST DATA';
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        
        userList = IPM_TestFactory_Helper.createUserList();
        List<User>userLists=[SELECT id FROM user WHERE id=:userList[0].id LIMIT 1];
        System.AssertEquals(userLists[0].id, userList[0].id,'user id is:'+userLists[0].id);//positive test
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,userList[0]);
        System.runAs(userList[0]) {
            insert projectList;
        }
        project=projectList[0];
        project.Name='ProChgStatus';
        List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
        System.assertEquals(projlList1[0].id,project.id);//positive test
    }
    
    /*************************************************************************************************************************
    * @description Test Data
    */
     static void initializeTestMethodData(){
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id from User where Email ='globalUser@unilever.test.com' limit 1]; 
        system.runAs(globalUser){
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r),(select ID,IPM_Project__c from IPM_Questionnaires__r)
            from IPM_Project__c where Name in:projectNameSet];
            
            project=projectListObj[0];
            projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
            
            System.assertEquals(projlList[0].id,project.id);//positive test\
            
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);
            }
            
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id);
           
            projectDocSecListObj[0].IPM_Gate_Document_Summary__c=TEST_SUMMARY;
            update projectDocSecListObj[0];
            docSec=projectDocSecListObj[0];
            projectDocSecConListObj = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projectDocSecConListObj.IPM_Project_Document_Section__c = docSec.ID;
            insert projectDocSecConListObj;
            pRef = Page.IPM_SectionHistory;
            pRef.getParameters().put(IPM_ConstantUtils.SF_ID, projectListObj[0].Id);
            Test.setCurrentPage(pRef);
            objHistoryAll=new IPM_ObjectAllHistoryComponentController();
            objHistory=new IPM_ObjectHistoryComponentController();
            
        }
    }

    /*
     * @Description Do the actual test
     */
    static testMethod void testHistory() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
        
            objHistoryAll.myObject=projectDocSecListObj[0];
            objHistoryAll.recordLimit=1;
         
            objHistoryAll.projectId=project.id;
            objHistoryAll.sectionId=docSec.Id;
         
            objHistoryAll.getObjectHistory();
        
            objHistory.myObject=projectDocSecListObj[0];
            objHistory.recordLimit=50;
            objHistory.getObjectHistory();
      
            String fieldName=TEST_DATA;
            IPM_ObjectAllHistoryComponentController.returnFieldLabel(fieldName);
            IPM_ObjectAllHistoryComponentController.objectHistoryLine objHis1 =new IPM_ObjectAllHistoryComponentController.objectHistoryLine();
            objHis1.theDate=TEST_DATA;
            objHis1.who= TEST_DATA;
            objHis1.userId=project.Id;
            objHis1.action= TEST_DATA;
            objHis1.whoImage= TEST_DATA;
            objHis1.recordLink= TEST_DATA;
            objHis1.actionType= TEST_DATA;
        
            IPM_ObjectHistoryComponentController.returnFieldLabel(fieldName);
            IPM_ObjectHistoryComponentController.objectHistoryLine objHis =new IPM_ObjectHistoryComponentController.objectHistoryLine();
            objHis.theDate= TEST_DATA;
            objHis.who= TEST_DATA;
            objHis.userId=project.Id;
            objHis.action= TEST_DATA;
            objHis.whoImage= TEST_DATA;
            objHis.fieldName= TEST_DATA;
            system.assertEquals(objHis1.actionType,TEST_DATA,'we cannot query data as we are not call any function');
            test.stopTest();
        }
    }
}