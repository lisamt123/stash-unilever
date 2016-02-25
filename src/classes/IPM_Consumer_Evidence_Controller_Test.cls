/*************************************************************
*@Author:Cognizant
*@Date:October 2014
*@Description : To test IPM_Consumer_Evidence_Controller class
*************************************************************/

@isTest
private class IPM_Consumer_Evidence_Controller_Test {
    public static IPM_Project__c project;// Project object initialization
    public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    public static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static PageReference pRef;
    public static User globalUser;
    public static IPM_Consumer_Evidence_Controller ipmConsumerEvidencon;
    public static User stdUserForConsumerEvid;
    public static IPM_Project_Document_Section_Content__c projDocSecCon;
    private static string COMMENTS_STR='comments';
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    public static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    private static final String CONSUMER_COUYNTRY='IND';
    private static String str='';
    /*************************************************************************
    *@Description : to Intialize(insert) the data for Project, Project Document
                    project Document section, project Document section content
                    Customer_Channel_Priority_Order objects
    ***************************************************************************/
    @testSetup static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForConsumerEvid= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForConsumerEvid.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForConsumerEvid.id,'user id is:'+userLists[0].id);//positive test
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForConsumerEvid);
        System.runAs(stdUserForConsumerEvid) {
            insert projectList;
            
            project=projectList[0];
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project inserted');//positive test
            
            
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
            List<IPM_Project__c> projlList=new List<IPM_Project__c>();
            projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
            System.assertEquals(projlList[0].id,project.id);//positive test
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);
            }
            
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id);
            projectDocSecListObj[0].IPM_Selected_Consumer_Evidence_Countries__c='abc;def';
            update projectDocSecListObj[0];
            
            projDocSecCon = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projDocSecCon.IPM_Project_Document_Section__c = projectDocSecListObj[0].ID;
            projDocSecCon.IPM_Consumer_Evidence_Logo_Id__c=IPM_ConstantUtils.BLANK;
            projDocSecCon.IPM_Consumer_Evidence_Country__c=CONSUMER_COUYNTRY;
            projDocSecCon.IPM_Consumer_Evidence_Concept_Name__c=IPM_ConstantUtils.CONCEPT_TEST_TWO;
            projDocSecCon.IPM_Consumer_Evidence_Comments__c=COMMENTS_STR;
            projDocSecCon.IPM_Content_Type__c = IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE;
            insert projDocSecCon;
            
            List<IPM_Project_Document_Section_Content__c>contentList=[select Id,IPM_Consumer_Evidence_Concept_Name__c,IPM_CMI_Result__c from IPM_Project_Document_Section_Content__c where Id=:projDocSecCon.Id];
            System.assertEquals(contentList[0].IPM_Consumer_Evidence_Concept_Name__c,IPM_ConstantUtils.CONCEPT_TEST_TWO,'content created');
            
            pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put(IPM_ConstantUtils.SF_ID, projectListObj[0].Id);
            Test.setCurrentPage(pRef);
            ipmConsumerEvidencon=new IPM_Consumer_Evidence_Controller();
            
        }
    }
    
    /*************************************************************************
    *@Description : to call  the method for IPM_CMIGateSectionController object 
            
    ***************************************************************************/
    static testMethod void doShowCountryList(){
        
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmConsumerEvidencon.projDocSecId = project.Id;
            ipmConsumerEvidencon.showCountryList();
            ipmConsumerEvidencon.projDocSecId = projectDocSecListObj[0].Id;
            ipmConsumerEvidencon.projectId=project.Id;
            ipmConsumerEvidencon.comments='abc';
            ipmConsumerEvidencon.isEditable=true;
            ipmConsumerEvidencon.projDocSec=projectDocSecListObj[0];
            ipmConsumerEvidencon.showCountryList();
            ipmConsumerEvidencon.countryName='abc';
            ipmConsumerEvidencon.showCountryList();
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_Consumer_Evidence_Country__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:ipmConsumerEvidencon.projDocSec.Id];
            System.assertEquals(conList[0].IPM_Consumer_Evidence_Country__c,CONSUMER_COUYNTRY,'show country list called');
        }
        test.stopTest();
    }
    /***********************************
    * @Description: Test Method invocation
    * *********************************/
    
    static testMethod void testCreateConcept()
    {
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            projectDocSecListObj[0].IPM_Selected_Consumer_Evidence_Countries__c=project.Id;
            update projectDocSecListObj[0];
            List<IPM_Project_Document_Section_Content__c>conList=[select IPM_Project_Document_Section__r.IPM_Selected_Consumer_Evidence_Countries__c,IPM_Content_Type__c,IPM_Consumer_Evidence_Concept_Name__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projectDocSecListObj[0].Id];
            System.assertEquals(conList[0].IPM_Project_Document_Section__r.IPM_Selected_Consumer_Evidence_Countries__c,project.Id,'tested for negative scenario');
            
            ipmConsumerEvidencon.countryName='123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
            ipmConsumerEvidencon.projDocSec=projectDocSecListObj[0];
            ipmConsumerEvidencon.createConcept(); 
            ipmConsumerEvidencon.countryName='qwe';
            ipmConsumerEvidencon.projDocSec.IPM_Selected_Consumer_Evidence_Countries__c='';
            ipmConsumerEvidencon.createConcept(); 
            projectDocSecListObj[0].IPM_Selected_Consumer_Evidence_Countries__c='qwe';
            update projectDocSecListObj[0];
            ipmConsumerEvidencon.createConcept(); 
            conList=[select IPM_Project_Document_Section__r.IPM_Selected_Consumer_Evidence_Countries__c,IPM_Content_Type__c,IPM_Consumer_Evidence_Concept_Name__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projectDocSecListObj[0].Id];
            System.assertEquals(conList[0].IPM_Project_Document_Section__r.IPM_Selected_Consumer_Evidence_Countries__c,'qwe','create concept called');
            
        }
        test.stopTest();
    }
    /***********************************
    * @Description: Test Method invocation
    * *********************************/
    
    static testMethod void testSaveConcept()
    {
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmConsumerEvidencon.projDocSecConId = project.Id;
            ipmConsumerEvidencon.projDocSecId=projectDocSecListObj[0].ID;
            ipmConsumerEvidencon.saveConcept();
            ipmConsumerEvidencon.projDocSecConId=projDocSecCon.Id;
            ipmConsumerEvidencon.comments=COMMENTS_STR;
            ipmConsumerEvidencon.saveConcept();
            List<IPM_Project_Document_Section_Content__c>conList=[select IPM_Consumer_Evidence_Comments__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:ipmConsumerEvidencon.projDocSec.Id];
            System.assertEquals(conList[0].IPM_Consumer_Evidence_Comments__c,COMMENTS_STR,'save successfully');
            
            for(Integer i=0;i<32770;i++){
            str+='a';
            }
            ipmConsumerEvidencon.comments=str;
            ipmConsumerEvidencon.saveConcept();
            
        }
        test.stopTest();
    }
    /***********************************
    * @Description: Test Method invocation
    * *********************************/
    
    static testMethod void testAddConcept()
    {
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmConsumerEvidencon.addCountryConcept='add';
            ipmConsumerEvidencon.projDocSecId=project.Id;
            ipmConsumerEvidencon.addConcept(); 
            ipmConsumerEvidencon.projDocSecId=projectDocSecListObj[0].ID;
            
            ipmConsumerEvidencon.addConcept();
            List<IPM_Project_Document_Section_Content__c>conList=[select IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:ipmConsumerEvidencon.projDocSec.Id];
            System.assertEquals(conList[0].IPM_Content_Type__c,IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE,'add concept successfully');
            
        }
        test.stopTest();
    }
    /***********************************
    * @Description: Test Method invocation
    * *********************************/
    
    static testMethod void testDeleteConcep()
    {
        
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmConsumerEvidencon.projDocSecConId=project.Id;
            ipmConsumerEvidencon.deleteConcept();
            ipmConsumerEvidencon.projDocSecId=projectDocSecListObj[0].ID;
            ipmConsumerEvidencon.projDocSecConId=projDocSecCon.Id;
            projectDocSecListObj[0].IPM_Selected_Consumer_Evidence_Countries__c='consume';
            update projectDocSecListObj[0];
            ipmConsumerEvidencon.deleteCountry='';
            ipmConsumerEvidencon.deleteConcept();    
            ipmConsumerEvidencon.deleteCountry=CONSUMER_COUYNTRY;
            ipmConsumerEvidencon.deleteConcept();
            
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:ipmConsumerEvidencon.projDocSecConId];
            System.assertEquals(conList.size(),0,'delete successfully');
            
        }
        test.stopTest();
    }
    /***********************************
    * @Description: Test Method invocation
    * *********************************/
    
    static testMethod void testDeleteImage()
    {
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmConsumerEvidencon.projDocSecConId=project.Id;
            ipmConsumerEvidencon.deleteImage();
            ipmConsumerEvidencon.projDocSecConId=projDocSecCon.Id;
            ipmConsumerEvidencon.projDocSecId=projectDocSecListObj[0].ID;
            ipmConsumerEvidencon.deleteImage();
            List<IPM_Project_Document_Section_Content__c>conList=[select IPM_Consumer_Evidence_Logo_Id__c from IPM_Project_Document_Section_Content__c where Id=:ipmConsumerEvidencon.projDocSecConId];
            System.assertEquals(conList[0].IPM_Consumer_Evidence_Logo_Id__c,null,'delete successfully');
        }
        test.stopTest();
    }
    /***********************************
    * @Description: Test Method invocation
    * *********************************/
    
    static testMethod void testDeleteSelectedCountry()
    {   
        
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmConsumerEvidencon.deleteCountry =CONSUMER_COUYNTRY;
            projectDocSecListObj[0].IPM_Selected_Consumer_Evidence_Countries__c=CONSUMER_COUYNTRY;
            update projectDocSecListObj[0];
            ipmConsumerEvidencon.projDocSecId=project.ID;
            ipmConsumerEvidencon.deleteSelectedCountry();
           
            ipmConsumerEvidencon.projDocSecId=projectDocSecListObj[0].ID;
            ipmConsumerEvidencon.deleteSelectedCountry();
            
            projectDocSecListObj[0].IPM_Selected_Consumer_Evidence_Countries__c='consume';
            update projectDocSecListObj[0];
            
            ipmConsumerEvidencon.deleteSelectedCountry();
            
            ipmConsumerEvidencon.deleteSelectedCountry();
            List<IPM_Project_Document_Section_Content__c>conList=new List<IPM_Project_Document_Section_Content__c>();
            conList=[select Id,IPM_Consumer_Evidence_Country__c from IPM_Project_Document_Section_Content__c where Id=:ipmConsumerEvidencon.projDocSecConId];
            System.assertEquals(conList.size(),0,'delete successfully');
            
        }
        test.stopTest();
    }
}