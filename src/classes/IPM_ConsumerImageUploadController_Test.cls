/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class to test IPM_ConsumerImageUploadController class functionalities
**/
@isTest
public class IPM_ConsumerImageUploadController_Test{
    private static User stdUserForConsumerImageUpload;
    public static Document doc; 
    public static Document documnt;   
    private static IPM_Project_Document_Section_Content__c sectionContent;
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();   
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<IPM_Project_Document_Section__c> sectionList = new List<IPM_Project_Document_Section__c>();
    private static final string DOC_NAME_STR='abc.yuv';
    private static Set<String> projectNameSet = new Set<String>{'TestComments1'};
    private static string RECORD_NOT_SAVED = 'Record not saved successfully.';
     public static User globalUser;
    /*******************************************************************************************************
    * @description  Test Method to initialize data for test methods
    * @name : initializeData
    * @param : void
    * @return :void
    */
    @testSetup public static void initializeData()
    {
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForConsumerImageUpload = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
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
        
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForConsumerImageUpload);
        
        System.runAs(stdUserForConsumerImageUpload)
        {
            insert projectList;
             List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectList[0].ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,'TestComments1','project inserted');//positive test
    }
    }
    
    /*******************************************************************************************************
    * @description  Test Method to initialize data for test methods
    * @name : testDataSetup
    * @param : void
    * @return :void
    */
  public static void testDataSetup(){     

        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
        System.runAs(globalUser)
        { 
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r)
            from IPM_Project__c 
            where Name in:projectNameSet];
            
            for(IPM_Project__c projectObj : projectListObj)
            {
                projDocList = projectObj.Project_Documents__r;                
                system.assertEquals(projDocList[0].IPM_GateDocuments__c,'Charter','Project Document created'); 

            }
            
            sectionList = [Select Id,IPM_Section_Name__c,IPM_Selected_Channel_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            sectionList[0].IPM_Selected_Channel_Name__c ='Club';
            sectionList[0].IPM_Customer_Channel_Info__c ='ABC';
            update sectionList;      
            
            list<IPM_Project_Document_Section__c> checkSectionList=[Select Id,IPM_Section_Name__c,IPM_Selected_Channel_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where ID=:sectionList[0].Id];
            
            system.assertEquals(checkSectionList[0].IPM_Selected_Channel_Name__c, 'Club', RECORD_NOT_SAVED); 
            
            
            sectionContent = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            sectionContent.IPM_Project_Document_Section__c = sectionList[0].Id;
            sectionContent.IPM_Content_Type__c = IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION;
            sectionContent.IPM_Customer_Channels__c = 'Hypermarket';
            sectionContent.IPM_Customer_Channel_Priority__c = 1; 
            insert sectionContent;
            list<IPM_Project_Document_Section_Content__c> checkSectionContentList=[Select Id,IPM_Customer_Channel_Priority__c from IPM_Project_Document_Section_Content__c 
            where ID=:sectionContent.Id];
            system.assertEquals(checkSectionContentList[0].IPM_Customer_Channel_Priority__c, 1, RECORD_NOT_SAVED); 
            doc=new Document();
            doc.name=DOC_NAME_STR;
            doc.FolderId=UserInfo.getUserId();
            insert doc;
            List<Document>documentList=[select Id,name from Document where Id=:doc.Id limit 1];
            system.assertEquals(documentList[0].name,DOC_NAME_STR,'document saved');          
            
        }  

    }
    
    /***********************************
    * @Description: Test Method invocation
    * *********************************/
    
    static testMethod void dotest()
    {
        testDataSetup();
        test.startTest();
        system.runAs(globalUser){
            IPM_ConsumerImageUploadController impconsumer=new IPM_ConsumerImageUploadController();
            documnt=new Document();
            documnt.name='def.yuv';
            documnt.FolderId=UserInfo.getUserId();
            impconsumer.upload(); 
            impconsumer.document=doc;
            impconsumer.projDocSecConId=sectionContent.Id;
            impconsumer.upload(); 
            List<Document>docList=[SELECT id, name, description FROM Document WHERE Id=:doc.Id]; 
            system.assertEquals(docList[0].name,doc.name,'Document is not uploaded');
            impconsumer.document=documnt;
            impconsumer.upload();
            List<Document>docList1=[SELECT id, name, description FROM Document WHERE Id=:documnt.Id]; 
            system.assertEquals(docList1[0].name,documnt.name,'Document is uploaded');      
        }
        test.stopTest();
    }

}