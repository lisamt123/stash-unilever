/*****************************************************************************
*@Author:Cognizant
*@Name:IPM_CU_Complexity_Controller_Controller_Test
*@CreateDate:07/08/2015
*@Description : To test IPM_CU_Complexity_Controller class functionalities
*@Version : 1.0
*@reference : IPM_CU_Complexity_Controller controller
*/
@isTest
public class IPM_CU_Complexity_Controller_Test {
    public static IPM_Project_Document_Section_Content__c projDocSecCon;//IPM_Project_Document_Section_Content__c object
    public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    public static List<IPM_Project__c> projectListObj = new List<IPM_Project__c>();
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    
    public static User platformUser;//for creating user
    public static List<IPM_Project_Document_Section__c> sectionList = new List<IPM_Project_Document_Section__c>();
    public static IPM_Project_Document_Section_Content__c sectionContent;
    public static string CONTENT_NOT_PROPER = 'Content count is not proper'; 
    public static string SECTIONCONTENT_NOT_UPDATED = 'Section Content not updated properly.';
    public static string SECTIONCONTENT_NOT_INSERTED = 'Section Content not inserted properly,';
    public static string PROJECTEFFECT_NOT_UPDATED = 'project effect not updated properly.';
    public static string PROJECTEFFECT_NOT_INSERTED = 'project effect not inserted properly.';
    public static string INCRASE_IN_COMPLEXITY = 'Increase in complexity by';
    public static string CHARTER = 'Charter';
    public static string CLUB = 'Club';
    
    /*******************************************************************************************************
    * @description  Test Method to initialize data for test methods
    * @name : initializeData
    * @param : void
    * @return :void
    */
    
    @testSetup static void projectSetUpData() 
    {
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
        }
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        system.assertEquals(companyCardList.size(), 3, 'Company card not created properly.');
        
        IPM_TestFactory_Helper.getProjectMasterData();
         
        projectList = IPM_TestFactory_Helper.projectSetUp(1,platformUser);
         
        System.runAs(platformUser)
        {
           insert projectList;
        }  
        system.assertEquals(projectList.size(),1,'Projects are not created');
    }
    
    public static void createTestData(){
        Set<String> projectNameSet = new Set<String>{'TestComments1'};
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
        System.runAs(globalUser)
        { 
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r)
            from IPM_Project__c where Name in:projectNameSet];
            
            for(IPM_Project__c projectObj : projectListObj)
            {
                projDocList = projectObj.Project_Documents__r;
                system.assertEquals(projDocList[0].IPM_GateDocuments__c,CHARTER,'Project Document created');  
            }
            
            sectionList = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            
            sectionList[0].IPM_Selected_Channel_Name__c =CLUB;
            sectionList[0].IPM_Customer_Channel_Info__c ='ABC';
            update sectionList;
            IPM_Project_Document_Section__c testProjDocSection = [Select id, IPM_Selected_Channel_Name__c from IPM_Project_Document_Section__c where id =: sectionList[0].Id];
            system.assertEquals(testProjDocSection.IPM_Selected_Channel_Name__c, CLUB, 'Section not updated properly.');
            
            sectionContent = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            sectionContent.IPM_Project_Document_Section__c = sectionList[0].Id;
            sectionContent.IPM_Gate_Type__C = CHARTER;
            insert sectionContent;
            IPM_Project_Document_Section_Content__c testProDocSecContent = [Select id, IPM_Gate_Type__C from IPM_Project_Document_Section_Content__c where id=:sectionContent.Id];
            system.assertEquals(testProDocSecContent.IPM_Gate_Type__C, CHARTER, SECTIONCONTENT_NOT_UPDATED);
            
        }
    }
    
    /*******************************************************************************************************
    * @description  Test Method to test IPM_CU_Complexity_Controller methods. This test will all the  method in respective controller.
    * @name : testData
    * @param : void
    * @return :void
*/
    public static testMethod void testData(){
        Test.startTest();
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(globalUser)
        { 
            createTestData();
            apexpages.currentpage().getparameters().put('id',projectListObj[0].id);
            IPM_CU_Complexity_Controller control=new IPM_CU_Complexity_Controller();
            control.isEditable=true;
            control.IncDecBy=10;
            control.projectEffect=INCRASE_IN_COMPLEXITY;
            control.contentCount=0;
            control.typeOfGate=CHARTER;
            control.projDocSecCon=sectionContent;
            control.projectSecId=sectionList[0].Id;
            control.phase='Idea';
            control.projSpan='';

            control.getCuCount();
            System.assertEquals(control.contentCount, 1, CONTENT_NOT_PROPER);
            
            control.projectSecId=sectionList[0].Id;
            control.contentCount=3;
            control.saveCuCount();
            System.assertEquals(control.contentCount, 3, CONTENT_NOT_PROPER);
            
            control.contentCount=0;
            control.saveCuCount();
            System.assertEquals(control.contentCount, 0, CONTENT_NOT_PROPER);

            control.contentCount=1;
            control.projModel='';
            control.IncDecBy=1.00;
            control.projectEffect='Decrease in complexity by';
            control.saveIncOrDec();
            System.assertEquals(control.projDocSecCon.IPM_Decreased_By__c, 1.00, SECTIONCONTENT_NOT_UPDATED);

            control.contentCount=0;
            control.IncDecBy=1.00;
            control.projectEffect=INCRASE_IN_COMPLEXITY;
            control.saveIncOrDec();
            System.assertEquals(control.projDocSecCon.IPM_Increased_By__c, 1.00, SECTIONCONTENT_NOT_INSERTED);

            control.saveNetProjectEffect();
            System.assertEquals(control.projDocSecCon.IPM_Project_Effect__c, INCRASE_IN_COMPLEXITY, PROJECTEFFECT_NOT_UPDATED);
            
            control.contentCount=1;
            control.saveNetProjectEffect();
            System.assertEquals(control.projDocSecCon.IPM_Content_Type__c, IPM_ConstantUtils.CU_COMPLEXITY, PROJECTEFFECT_NOT_INSERTED);

            control.getProjEffect();
            System.assertEquals(control.getProjEffect().size(), 3,control.getProjEffect().size()); 

            IPM_CU_Complexity_Consolidated testConsolidated = new  IPM_CU_Complexity_Consolidated();
            testConsolidated.projectId = projectListObj[0].id;
            testConsolidated.gateType = CHARTER; 
            testConsolidated.getSectionContent();
            System.assert(testConsolidated.secContentList!= null,'list is null'); 
        }
        Test.stopTest();
        
    }
    
}