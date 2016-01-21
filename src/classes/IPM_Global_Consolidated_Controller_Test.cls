/**
* @author       Cognizant 
* @date         11/08/2015
* @description  This class is used to test the functionality of IPM_Global_Consolidated_Controller class 
*/
@isTest
public class IPM_Global_Consolidated_Controller_Test{
    public static IPM_Project__c project;// Project object initialization
    public static IPM_Global_Consolidated_Controller ipnmGlobConscon;
    public static User globalUser;
    public static User stdUserForRiskSec;
    public static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    public static List<IPM_Project__c>projectList=new List<IPM_Project__c>();
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    private static final string MASTER_EXTERNL_ID='CU_And_Complexity';
    public static List<IPM_Project_Document_Section__c> projectDocSecListObj =new List<IPM_Project_Document_Section__c>();
    private static final string GATE_DOC_SUMMARY='gate document summary';
     public static IPM_Project__c ParentProject;// Project object initialization
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForRiskSec= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForRiskSec.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForRiskSec.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForRiskSec);
        System.runAs(stdUserForRiskSec) {
            insert projectList;
            
            project=projectList[0];
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project name');//positive test
        }
    }
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    static void initializeTestMethodData(){
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
        system.runAs(globalUser){
             projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r),(select ID,IPM_Project__c from IPM_Questionnaires__r)
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            ParentProject= IPM_TestFactory_Helper.createIPMProject(FALSE);
           ParentProject.Name='parent project';
           insert ParentProject;
           List<IPM_Project__c>parProList=[select Id,Name from IPM_Project__c where Id=:ParentProject.Id];
           System.assertEquals(parProList[0].Name,'parent project','parent project not created');
             for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
               
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);  
            }
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Master_Section_External_Id__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];  
             
            ipnmGlobConscon=new IPM_Global_Consolidated_Controller();
            
           }
       }
       
           /*************************************************************************************************************************
            * @description Running Test Script
           */ 
    static testMethod void getSummaryTest(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipnmGlobConscon.secExtId='abc';
            ipnmGlobConscon.gateDocument=IPM_ConstantUtils.CHARTER_GATE;
            project.IPM_Parent_Project__c=ParentProject.Id;
            projectDocSecListObj[0].IPM_Master_Section_External_Id__c=MASTER_EXTERNL_ID;
            projectDocSecListObj[0].IPM_Gate_Document_Summary__c=GATE_DOC_SUMMARY;
            projectDocSecListObj[0].IPM_Project_Document__c=projDocList[0].Id;
            update projectDocSecListObj;
            List<IPM_Project_Document_Section__c>secList=[select Id,IPM_Master_Section_External_Id__c from IPM_Project_Document_Section__c where Id=:projectDocSecListObj[0].Id LIMIT 1];
            System.assertEquals(secList[0].IPM_Master_Section_External_Id__c,MASTER_EXTERNL_ID,'section not updated');
            ipnmGlobConscon.ProjectId=ParentProject.Id;
            ipnmGlobConscon.secExtId=MASTER_EXTERNL_ID;
            ipnmGlobConscon.getSummary();
            List<IPM_Project_Document_Section__c>secSummaryList=[SELECT IPM_Gate_Document_Summary__c,IPM_Project_Document__r.IPM_Project__r.IPM_Project_Name__c 
                         FROM IPM_Project_Document_Section__c WHERE IPM_Master_Section_External_Id__c=:ipnmGlobConscon.secExtId limit 1];
            System.assertEquals(secSummaryList[0].IPM_Gate_Document_Summary__c,GATE_DOC_SUMMARY,'summary not retrieved');
            test.stopTest();
        }
    }
}