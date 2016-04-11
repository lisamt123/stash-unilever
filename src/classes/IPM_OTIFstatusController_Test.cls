/**
@Author  Cognizant 
@name IPM_OTIFstatusController_Test
@CreateDate 15/04/2015
@DescriptionChecks the OTIF status of the Gate Document
@Version <1.0>
@reference IPM_OTIFstatusController
*/
@isTest
private class IPM_OTIFstatusController_Test {
    
    private static IPM_Project__c project;
    private static IPM_Project_Document__c projDoc;
    private static List<IPM_Project_Document__c> projDocList;
    private static IPM_Project_Document_Section__c projDocSec;
    private static IPM_Project_Document_Section_Content__c projDocSecCon;
    private static User otifUser;
    private static string RECORD_NOT_SAVED_SUCCESSFULLY='record not saved successfully';
    private static string SECTION_CONTENT_LIST_IS_EMPTY='section content list empty';
    
    /*Name: initializeData
    * @Description: Initialises the data needed for creating OTIF situation
    */
    static void initializeData() { 
        otifUser = IPM_TestFactory_Helper.createUser(true);
        system.assert(otifUser.id!=null);//positive test
        system.RunAs(otifUser){
            project = IPM_TestFactory_Helper.createIPMProject(FALSE);
            project.Sustainability_Period__c='3';
            project.IPM_Target_Launch_Dates__c=system.today();
            project.IPM_IsCompleted__c=true; 
            insert project;
            IPM_Project__c projectObj=[select IPM_IsCompleted__c from IPM_Project__c where id=:project.Id];
            system.assert(projectObj.IPM_IsCompleted__c,RECORD_NOT_SAVED_SUCCESSFULLY);
            
            projDoc = IPM_TestFactory_Helper.createIPMProjectDocument(false);
            projDoc.IPM_Project__c=project.ID;
            projDoc.IPM_GateDocuments__c='Charter';
            projDoc.IPM_Project_Document_External_Id__c = 'Test_Ext_Id';
            insert projDoc;
            IPM_Project_Document__c projectDocObj=[select IPM_Project__c from IPM_Project_Document__c where id=:projDoc.Id];
            system.assertEquals(projectDocObj.IPM_Project__c,project.ID,RECORD_NOT_SAVED_SUCCESSFULLY);
            
            projDocList=new List<IPM_Project_Document__c>();
            projDocList.add(projDoc);
            
            projDocSec = IPM_TestFactory_Helper.createIPMProjectDocumentSection(false);
            projDocSec.IPM_Project_Document__c=projDoc.ID;
            insert projDocSec;
            
            IPM_Project_Document_Section__c projectDocSecObj=[select IPM_Project_Document__c from IPM_Project_Document_Section__c where id=:projDocSec.Id];
            system.assertEquals(projectDocSecObj.IPM_Project_Document__c,projDoc.ID,RECORD_NOT_SAVED_SUCCESSFULLY);
            
            projDocSecCon = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projDocSecCon.IPM_Project_Document_Section__c=projDocSec.ID;
            projDocSecCon.IPM_OTIF_No_of_Status__c=4;
            projDocSecCon.IPM_OTIF_Measure__c='Measure 1';
            projDocSeccon.IPM_OTIF_Responsibility__c='BD';
            projDocSecCon.IPM_OTIF_Status__c='Not Applicable';
            projDocSecCon.IPM_OTIF_HelpText_Red__c='Red';
            projDocSecCon.IPM_OTIF_HelpText_NA__c='NA';
            projDocSecCon.IPM_OTIF_HelpText_Green__c='Green';
            projDocSecCon.IPM_OTIF_HelpText_Amber__c='Amber';
            projDocSecCon.IPM_Section_Number__c='2.2';
            projDocSecCon.IPM_OTIF_Sequence__c=1;
            projDocSecCon.IPM_Section_Id__c=projDocSec.ID;
            projDocSecCon.IPM_Section_Name__c='Customer Channel';
            projDocSecCon.IPM_Section_type__c='Checklist';
            insert projDocSecCon;
            
            IPM_Project_Document_Section_Content__c projectDocSecConObj=[select IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where id=:projDocSecCon.Id];
            system.assertEquals(projectDocSecConObj.IPM_Project_Document_Section__c,projDocSec.ID,RECORD_NOT_SAVED_SUCCESSFULLY);
        }
    }
    
    /*Name: testShowContent
    * @Description: Tests actual content
    */
    static testMethod void testShowContent() {
        initializeData();
        system.RunAs(otifUser){
            Test.startTest();
            IPM_OTIFstatusController otif=new IPM_OTIFstatusController();
            otif.secConId=project.Id;
            otif.updateOTIFStatus();
            System.assertNotEquals(otif.secCon.IPM_Content_Type__c,IPM_ConstantUtils.OTIF_CONTENT_TYPE,System.Label.IPM_CATCH_BLOCK_CALLED);
            otif.iseditable=true;
            otif.showSectionContent();
            System.assertEquals(otif.secConList,Null,SECTION_CONTENT_LIST_IS_EMPTY);
            otif.projDocSecId=projDocSec.Id;
            otif.otifType=IPM_ConstantUtils.OTIF_TABLE;
            otif.showSectionContent();
            System.assertNotEquals(otif.secConList,Null,SECTION_CONTENT_LIST_IS_EMPTY);
            otif.otifType=IPM_ConstantUtils.OTIF_SECTION;
            otif.showSectionContent();
            System.assertNotEquals(otif.secConList,Null,'');
            otif.secConId=projDocSecCon.Id;
            otif.status='Red';
            otif.updateOTIFStatus();
            System.assertEquals(otif.secCon.IPM_OTIF_Status__c,'Red',System.Label.IPM_FUNC_CALLED_SUCCESSFULLY);
            Test.stopTest();
        }
    }
}