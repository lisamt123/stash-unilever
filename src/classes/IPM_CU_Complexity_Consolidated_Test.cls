/**
* @author       Cognizant 
* @date         11/08/2015
* @description  This class is used to test the functionality of IPM_CU_Complexity_Consolidated class 
*/
@isTest
public class IPM_CU_Complexity_Consolidated_Test{

    public static IPM_Project__c project;// Project object initialization
    public static IPM_Project_Document__c projDoc;
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    public static IPM_CU_Complexity_Consolidated ipm_cuConsolidated;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    public static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    public static List<IPM_Project__c> projlList=new List<IPM_Project__c>();
    public static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    public static User globalUser;
    public static User stdUserForCuConsolidated;
    public static IPM_Project_Document_Section_Content__c projectDocSecConListObj;
    public static IPM_Project__c ParentProject;// Project object initialization
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForCuConsolidated= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForCuConsolidated.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForCuConsolidated.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForCuConsolidated);
        System.runAs(stdUserForCuConsolidated) {
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
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r )
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
            System.assertEquals(projlList[0].Name,TEST_COMMENTS_STR,'project not created');//positive test
            
           ParentProject= IPM_TestFactory_Helper.createIPMProject(FALSE);
           ParentProject.Name='parent project';
           insert ParentProject;
           List<IPM_Project__c>parProList=[select Id,Name from IPM_Project__c where Id=:ParentProject.Id];
           System.assertEquals(parProList[0].Name,'parent project','parent project not created');
            
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);
            }
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id);
            
            projectDocSecConListObj = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projectDocSecConListObj.IPM_Project_Document_Section__c = projectDocSecListObj[0].ID;
            projectDocSecConListObj.IPM_Content_Type__c=IPM_ConstantUtils.CUCOMPLEXITY_CONTENT_TYPE;
            insert projectDocSecConListObj;
            
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecConListObj.Id];
            System.assertEquals(conList[0].IPM_Content_Type__c,IPM_ConstantUtils.CUCOMPLEXITY_CONTENT_TYPE,'content not created');
            
            ipm_cuConsolidated=new IPM_CU_Complexity_Consolidated();
            
        }
    }
    
       /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testMethod void saveScoreTest(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
        project.IPM_Parent_Project__c=ParentProject.Id;
        update project;
        List<IPM_Project__c>prjList=[select Id,IPM_Parent_Project__c from IPM_Project__c where Id=:project.Id];
        System.assertEquals(prjList[0].IPM_Parent_Project__c,ParentProject.Id,'project not updated');
        projectDocSecConListObj.IPM_Project_Document_Section__c=projectDocSecListObj[0].Id;
        update projectDocSecConListObj;
        List<IPM_Project_Document_Section_Content__c>prjconList=[select Id,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecConListObj.Id];
        System.assertEquals(prjconList[0].IPM_Project_Document_Section__c,projectDocSecListObj[0].Id,'project not updated');
        ipm_cuConsolidated.projectId=ParentProject.Id;
        List<IPM_Project_Document_Section_Content__c>contentList=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecConListObj.Id];
        System.assertEquals(contentList[0].IPM_Content_Type__c,IPM_ConstantUtils.CUCOMPLEXITY_CONTENT_TYPE,'content not created');
         test.stopTest();
         }
     }
 }