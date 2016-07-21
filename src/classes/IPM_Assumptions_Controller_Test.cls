/******************************************************************************************************************************
* @author Cognizant 
* @date 15/12/2014
* @description Test Class for IPM_Assumptions_Controller
*/
@isTest
public class IPM_Assumptions_Controller_Test{    
    public static IPM_Project__c project;// Project object initialization
    public static IPM_Project_Document__c projDoc;
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    public static User stdUserForAssumption;
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    public static PageReference  pRef;
    public static IPM_Assumptions_Controller ipmAssumContrl;
    private static final string TEST_COMMENTS_STR='TestComments1';
    public static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    public static List<IPM_Project__c> projlList=new List<IPM_Project__c>();
    public static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    public static IPM_Project_Document_Section_Content__c projectDocSecConListObj=new IPM_Project_Document_Section_Content__c();
    public static User globalUser;
    public static List<IPM_Questionnaire__c> quesList;
    public static IPM_Project_Document_Section__c docSec;
    public static IPM_Project_Document__c document;
    private static final string SAVE_ASSUMPTION_STR='assumption saved';
    private static final string ASSUMPTION_DATA_STR='assumption data';
    public static List<IPM_Project_Document_Section_Content__c> conList=new List<IPM_Project_Document_Section_Content__c>();
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
        // user has to be created as system admin 
            stdUserForAssumption= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForAssumption.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForAssumption.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForAssumption);
        System.runAs(stdUserForAssumption) {
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
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r),(select ID,IPM_Project__c from IPM_Questionnaires__r)
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
           
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                quesList=projectObj.IPM_Questionnaires__r;
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);
            }
            document=projDocList[0];
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            
            docSec=projectDocSecListObj[0];
            projectDocSecConListObj = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projectDocSecConListObj.IPM_Project_Document_Section__c = docSec.ID;
            projectDocSecConListObj.IPM_Gate_Type__c='Charter';
            projectDocSecConListObj.IPM_Assumption_A_P__c=ASSUMPTION_DATA_STR;
            projectDocSecConListObj.IPM_Assumption_Volume_Yr_2__c=ASSUMPTION_DATA_STR;
            projectDocSecConListObj.IPM_Assumption_Market_Size__c=ASSUMPTION_DATA_STR;
            projectDocSecConListObj.IPM_Assumption_CAPEX__c=ASSUMPTION_DATA_STR;
            projectDocSecConListObj.IPM_Assumption_Countries__c=ASSUMPTION_DATA_STR;
            projectDocSecConListObj.IPM_Assumption_GM__c=ASSUMPTION_DATA_STR;
            projectDocSecConListObj.IPM_Assumption_Volume__c=ASSUMPTION_DATA_STR;
            projectDocSecConListObj.IPM_Assumption_Pricing__c=ASSUMPTION_DATA_STR;
            projectDocSecConListObj.IPM_Assumption_Restages__c=ASSUMPTION_DATA_STR;
            projectDocSecConListObj.IPM_Assumption_T_O_Cannibalization__c=ASSUMPTION_DATA_STR;
            insert projectDocSecConListObj;
            List<IPM_Project_Document_Section_Content__c>contentList=[select Id,IPM_Assumption_T_O_Cannibalization__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecConListObj.Id];
            System.assertEquals(contentList[0].IPM_Assumption_T_O_Cannibalization__c,ASSUMPTION_DATA_STR,'content created');
            
            pRef = Page.IPM_GateDocument;
            pRef.getParameters().put(IPM_ConstantUtils.SF_ID, projectListObj[0].Id);
            Test.setCurrentPage(pRef);
            ipmAssumContrl=new IPM_Assumptions_Controller();
            
        }
    }

    public static testMethod void testSaveAssumptions(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            Id assumptionId=projectDocSecConListObj.Id; //Getting Assumption Id
            ipmAssumContrl.gateDocType='Charter';
            ipmAssumContrl.contentCount=0;
            ipmAssumContrl.saveAssumptions();
            ipmAssumContrl.projDocSecId=docSec.Id;
            ipmAssumContrl.comments='assumption data';
            
            ipmAssumContrl.contentName=IPM_ConstantUtils.VOLUME_YEAR_2;
            ipmAssumContrl.saveAssumptions();
            conList=[select Id,IPM_Assumption_Volume_Yr_2__c from IPM_Project_Document_Section_Content__c where Id=:assumptionId];
            System.assertEquals(conList[0].IPM_Assumption_Volume_Yr_2__c,ipmAssumContrl.comments,SAVE_ASSUMPTION_STR);
            
            ipmAssumContrl.contentName=IPM_ConstantUtils.MARKET_SIZE;
            ipmAssumContrl.saveAssumptions();
            conList=new List<IPM_Project_Document_Section_Content__c>();
            conList=[select Id,IPM_Assumption_Market_Size__c from IPM_Project_Document_Section_Content__c where Id=:assumptionId];
            System.assertEquals(conList[0].IPM_Assumption_Market_Size__c,ipmAssumContrl.comments,SAVE_ASSUMPTION_STR);
            
            ipmAssumContrl.contentName=IPM_ConstantUtils.AP;
            ipmAssumContrl.saveAssumptions();
            conList=new List<IPM_Project_Document_Section_Content__c>();
            conList=[select Id,IPM_Assumption_A_P__c from IPM_Project_Document_Section_Content__c where Id=:assumptionId];
            System.assertEquals(conList[0].IPM_Assumption_A_P__c,ipmAssumContrl.comments,SAVE_ASSUMPTION_STR);
            
            ipmAssumContrl.contentName=IPM_ConstantUtils.CAPEX;
            ipmAssumContrl.saveAssumptions();
            conList=new List<IPM_Project_Document_Section_Content__c>();
            conList=[select Id,IPM_Assumption_CAPEX__c from IPM_Project_Document_Section_Content__c where Id=:assumptionId];
            System.assertEquals(conList[0].IPM_Assumption_CAPEX__c,ipmAssumContrl.comments,SAVE_ASSUMPTION_STR);
            
            ipmAssumContrl.contentName=IPM_ConstantUtils.COUNTRIES;
            ipmAssumContrl.saveAssumptions();
            conList=new List<IPM_Project_Document_Section_Content__c>();
            conList=[select Id,IPM_Assumption_Countries__c from IPM_Project_Document_Section_Content__c where Id=:assumptionId];
            System.assertEquals(conList[0].IPM_Assumption_Countries__c,ipmAssumContrl.comments,SAVE_ASSUMPTION_STR);
            
            ipmAssumContrl.contentName=IPM_ConstantUtils.GM;
            ipmAssumContrl.saveAssumptions();
            conList=new List<IPM_Project_Document_Section_Content__c>();
            conList=[select Id,IPM_Assumption_GM__c from IPM_Project_Document_Section_Content__c where Id=:assumptionId];
            System.assertEquals(conList[0].IPM_Assumption_GM__c,ipmAssumContrl.comments,SAVE_ASSUMPTION_STR);
            
            ipmAssumContrl.contentName=IPM_ConstantUtils.VOLUME_ASSUMPTION;
            ipmAssumContrl.saveAssumptions();
            conList=new List<IPM_Project_Document_Section_Content__c>();
            conList=[select Id,IPM_Assumption_Volume__c from IPM_Project_Document_Section_Content__c where Id=:assumptionId];
            System.assertEquals(conList[0].IPM_Assumption_Volume__c,ipmAssumContrl.comments,SAVE_ASSUMPTION_STR);
            
            ipmAssumContrl.contentName=IPM_ConstantUtils.PRICING;
            ipmAssumContrl.saveAssumptions();
            conList=new List<IPM_Project_Document_Section_Content__c>();
            conList=[select Id,IPM_Assumption_Pricing__c from IPM_Project_Document_Section_Content__c where Id=:assumptionId];
            System.assertEquals(conList[0].IPM_Assumption_Pricing__c,ipmAssumContrl.comments,SAVE_ASSUMPTION_STR);
           
            ipmAssumContrl.contentName=IPM_ConstantUtils.RESTAGES;
            ipmAssumContrl.saveAssumptions();
            conList=new List<IPM_Project_Document_Section_Content__c>();
            conList=[select Id,IPM_Assumption_Restages__c from IPM_Project_Document_Section_Content__c where Id=:assumptionId];
            System.assertEquals(conList[0].IPM_Assumption_Restages__c,ipmAssumContrl.comments,SAVE_ASSUMPTION_STR);
            
            ipmAssumContrl.contentName=IPM_ConstantUtils.CANNIBALIZATION;
            ipmAssumContrl.saveAssumptions();
            conList=new List<IPM_Project_Document_Section_Content__c>();
            conList=[select Id,IPM_Assumption_T_O_Cannibalization__c from IPM_Project_Document_Section_Content__c where Id=:assumptionId];
            System.assertEquals(conList[0].IPM_Assumption_T_O_Cannibalization__c,ipmAssumContrl.comments,SAVE_ASSUMPTION_STR);
            
            ipmAssumContrl.contentName=IPM_ConstantUtils.VOLUME_YEAR_2;
            ipmAssumContrl.saveAssumptions();
            conList=new List<IPM_Project_Document_Section_Content__c>();
            conList=[select Id,IPM_Assumption_Volume_Yr_2__c from IPM_Project_Document_Section_Content__c where Id=:assumptionId];
            System.assertEquals(conList[0].IPM_Assumption_Volume_Yr_2__c,ipmAssumContrl.comments,SAVE_ASSUMPTION_STR);
          
        }
        Test.stopTest();
    }
    
    
    public static testMethod void testNegativeScenario(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmAssumContrl.projDocSecId=project.Id;
            ipmAssumContrl.saveAssumptions();
            conList=new List<IPM_Project_Document_Section_Content__c>();
            conList=[select Id,IPM_Assumption_Volume_Yr_2__c from IPM_Project_Document_Section_Content__c where Id=:ipmAssumContrl.assumption.Id];
            System.assertEquals(conList.size(),0,'catch block called');
            Test.stopTest();
    }
}
}