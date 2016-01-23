/******************************************************************************************************************************
* @author Cognizant 
* @date 15/12/2014
* @description Test Class for IPM_ProjDocumentSectionHstryController
*/
@isTest
public class IPM_PjtDocSectionHstryController_Test {    
    public static IPM_Project__c project;// Project object initialization
    public static IPM_Project_Document__c projDoc;
    public static User stdUserSecHistory;
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    public static List<SelectOption> secOpt=new List<SelectOption>();
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    public static PageReference  pRef;
    public static IPM_ProjDocumentSectionHstryController projDocHistoryCont;
    private static final string TEST_COMMENTS_STR='TestComments1';
    public static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    public static List<IPM_Project__c> projlList=new List<IPM_Project__c>();
    public static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    public static User globalUser;
    public static IPM_Project_Document_Section__c docSec;
    public static IPM_Project_Document__c document;
    public static IPM_ProjectIntermediateController interCon;
    private static final string PHASE_CHANGE_STR='phase changed';
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
    
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserSecHistory= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        } 
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserSecHistory);
       
        System.runAs(stdUserSecHistory) {
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
     public static void initializeTestMethodData(){
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
        system.runAs(globalUser){
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r),(select ID,IPM_Project__c from IPM_Questionnaires__r)
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
            System.assertEquals(projlList[0].id,project.id);//positive test
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
               System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);
            }
            document=projDocList[0];
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id);
           docSec=projectDocSecListObj[0];
           
            pRef = Page.IPM_SectionHistory;
            pRef.getParameters().put(IPM_ConstantUtils.SF_ID, projectListObj[0].Id);
            pRef.getParameters().put('projDocSecId',docSec.Id);
            Test.setCurrentPage(pRef);
            projDocHistoryCont=new IPM_ProjDocumentSectionHstryController();
        }
    }
     
      /*
     * @Description Do the actual test
     */
    static testMethod void testHistory() {
          initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
        
       projDocHistoryCont.sectionId=docSec.Id;
        //Scenerio 2 : Project phase is feasibility, and span is regional
      
        projDocHistoryCont.moveToNextDocument();
       
        system.assertEquals(projDocHistoryCont.project.IPM_Phase__c,IPM_ConstantUtils.PHASE_FEASIBILITY,PHASE_CHANGE_STR);
        
        
        projDocHistoryCont.moveToNextDocument();
        
       
        system.assertEquals(projDocHistoryCont.project.IPM_Phase__c,IPM_ConstantUtils.PHASE_CAPABILITY,PHASE_CHANGE_STR);
        
        //Scenerio 3: Project phase is capability and span is regional
        
        projDocHistoryCont.moveToNextDocument();
        
       
        system.assertEquals(projDocHistoryCont.project.IPM_Phase__c,IPM_ConstantUtils.PHASE_MARKET_READY,PHASE_CHANGE_STR);
        
        
          }
        Test.stopTest(); 
    }
    
    
}