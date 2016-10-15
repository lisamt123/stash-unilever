/*************************************************************
*@Author:Cognizant
*@Date:October 2014
*@Description : To test IPM_CMIGateSectionController class
*************************************************************/

@isTest
private class IPM_CMIGateSectionController_Test {
    
    private static IPM_Project__c project;// Project object initialization
    private static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    private static PageReference pRef;
    private static User stdUserForCMIGATE;
    private static IPM_Gate_CMI__c gateCmi;
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static IPM_Project_Document_Section_Content__c projDocSecCon;
    private static IPM_CMIGateSectionController ipmCmiCon;
    private static User globalUser;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    private static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForCMIGATE=IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForCMIGATE.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForCMIGATE.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForCMIGATE);
        System.runAs(stdUserForCMIGATE) {
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
            List<IPM_Project__c>projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r),(select ID,IPM_Project__c from IPM_Questionnaires__r)
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            List<IPM_Project__c>projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
            System.assertEquals(projlList[0].id,project.id);//positive test
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
               System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);
            }
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id);
            
            gateCmi=IPM_TestFactory_Helper.createGateCMI(project.Id,false);
            gateCmi.IPM_Skip_Test__c=false;
            insert gateCmi;
            
            List<IPM_Gate_CMI__c> cmiObj=[SELECT ID,IPM_Skip_Test__c FROM IPM_Gate_CMI__c WHERE ID=:gateCmi.ID LIMIT 1];
            System.assertEquals(cmiObj[0].IPM_Skip_Test__c,false);//positive test
            
            projDocSecCon = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projDocSecCon.IPM_Project_Document_Section__c = projectDocSecListObj[0].ID;
            projDocSecCon.IPM_Content_Type__c=IPM_ConstantUtils.CMIGATE_CONTENT_TYPE;
            projDocSecCon.IPM_Gate_CMI__c=gateCmi.Id;
            
            insert projDocSecCon;
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_Content_Type__c from IPM_Project_Document_Section_Content__c where Id=:projDocSecCon.Id];
            System.assertEquals(conList[0].IPM_Content_Type__c,IPM_ConstantUtils.CMIGATE_CONTENT_TYPE,'content not created');
            
           pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put('Id', project.Id);
            Test.setCurrentPage(pRef);
            
            ipmCmiCon=new IPM_CMIGateSectionController();
        }
    }
            
            /*************************************************************************
    *@Description : to call  the method for IPM_CMIGateSectionController object 
            
    ***************************************************************************/
            static testMethod void dotest1(){
                initializeTestMethodData();
                Test.startTest();
                system.RunAs(globalUser){
                    ipmCmiCon.projectId=project.Id;
                    ipmCmiCon.setprojDocSecId(projectDocSecListObj[0].ID);
                    ipmCmiCon.gateType='Charter';
                    ipmCmiCon.showTableData();
                    List<IPM_Project_Document_Section_Content__c> projectDocSecConObj=[select IPM_Content_Type__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:ipmCmiCon.projDocSecId];
                    system.assertEquals(projectDocSecConObj[0].IPM_Content_Type__c,IPM_ConstantUtils.CMIGATE_CONTENT_TYPE,'content type matched');
                    Test.stopTest();
                }
            }


        }