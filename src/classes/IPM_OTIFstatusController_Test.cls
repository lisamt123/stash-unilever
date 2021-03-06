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
    private static IPM_OTIF_Status__c oticStatusSetting;
    private static User otifUser;
    private static string RECORD_NOT_SAVED_SUCCESSFULLY='record not saved successfully';
    private static string SECTION_CONTENT_LIST_IS_EMPTY='section content list empty';
    private static List<IPM_Project_Document_Section_Content__c> secConList;
    static uw_BET__c bet;
	static List<IPM_BET_Valid_Categories__c> betvalidCategories ;
	static final string CAT_NAME ='Household Care' ;
    /*Name: initializeData
    * @Description: Initialises the data needed for creating OTIF situation
    */
    static void initializeData() { 
        otifUser = IPM_TestFactory_Helper.createUser(true);
        system.assert(otifUser.id!=null);//positive test
        system.RunAs(otifUser){
            oticStatusSetting = IPM_TestFactory_Helper.createIPMOTIFStatus(FALSE);
            oticStatusSetting.Dependent_Field__c = IPM_ConstantUtils.BET_CURRENT_STATUS;
            oticStatusSetting.name = 'Market Ready Communication';
            insert oticStatusSetting;
            bet = BET_TestUtils.getTestBet();
        	insert bet; 
            project = IPM_TestFactory_Helper.createIPMProject(FALSE);
            project.Sustainability_Period__c='3';
            project.IPM_Target_Launch_Dates__c=system.today();
            project.IPM_IsCompleted__c=true; 
            project.bet__c = bet.id;   
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
            projDocSecCon.DependentFieldAPIName__c = IPM_ConstantUtils.BET_CURRENT_STATUS;
            insert projDocSecCon;
            
            IPM_Project_Document_Section_Content__c projectDocSecConObj=[select IPM_Project_Document_Section__c,DependentFieldAPIName__c from IPM_Project_Document_Section_Content__c where id=:projDocSecCon.Id];
            system.assertEquals(projectDocSecConObj.IPM_Project_Document_Section__c,projDocSec.ID,RECORD_NOT_SAVED_SUCCESSFULLY);
            system.assertEquals(projectDocSecConObj.DependentFieldAPIName__c, IPM_ConstantUtils.BET_CURRENT_STATUS);
        }
    }
    
        /*
    @description Contains all common data for BET testing
    */
    static void betDataInitializer(){
        	system.assertEquals(1 , [Select count() from uw_BET__c where Id=:bet.Id ],'Failed to insert BET record.');
        	betvalidCategories = new List<IPM_BET_Valid_Categories__c>();
        	betvalidCategories.add(new IPM_BET_Valid_Categories__c(Name = CAT_NAME ));
        	insert betvalidCategories;
        	system.assertEquals(1 , [Select count() from IPM_BET_Valid_Categories__c where Name =: CAT_NAME ] , 'Failed to insert category  records.');      
        	MDO_Category__c category = IPM_TestFactory_Helper.createMDOCategory(false);
        	category.Name = 'Household Care';
        	insert category;
        	system.assertEquals(1 , [Select count() from MDO_Category__c where Id =: category.Id ] , 'Failed to insert MDO category  records.');      
    }	
    /*Name: testShowContent
    * @Description: Tests actual content
    */
    static testMethod void testShowContent() {
        initializeData();
        system.RunAs(otifUser){
            Test.startTest();
            IPM_OTIFstatusController otif=new IPM_OTIFstatusController();
            PageReference pageRef = Page.IPM_ProjectDocumentSectionEditor;

            Test.setCurrentPageReference(pageRef); 
            System.currentPageReference().getParameters().put('id', project.Id);
            System.currentPageReference().getParameters().put('projDocSecId', projDocSec.Id);

            otif.secConId=project.Id;
            otif.updateOTIFStatus();
            System.assertNotEquals(otif.secCon.IPM_Content_Type__c,IPM_ConstantUtils.OTIF_CONTENT_TYPE,System.Label.IPM_CATCH_BLOCK_CALLED);
            otif.iseditable=true;
            secConList  = otif.getSecConList();
            //System.assertEquals(secConList,Null,SECTION_CONTENT_LIST_IS_EMPTY);
            otif.projDocSecId=projDocSec.Id;
            otif.otifType=IPM_ConstantUtils.OTIF_TABLE;
            secConList  = otif.getSecConList();
            System.assertNotEquals(secConList,Null,SECTION_CONTENT_LIST_IS_EMPTY);
            otif.otifType=IPM_ConstantUtils.OTIF_SECTION;
            secConList  = otif.getSecConList();
            System.assertNotEquals(secConList,Null,'');
            otif.secConId=projDocSecCon.Id;
            otif.status='Red';
            otif.updateOTIFStatus();
            System.assertEquals(otif.secCon.IPM_OTIF_Status__c,'Red',System.Label.IPM_FUNC_CALLED_SUCCESSFULLY);
            Test.stopTest();
        }
    }
    static testMethod void testOTIFDependentQuestion()
    {
    	initializeData();
    	betDataInitializer();
    	system.RunAs(otifUser){
    		Test.startTest();
            IPM_OTIFstatusController otif = new IPM_OTIFstatusController();
            otif.secConId=project.Id;
            otif.updateOTIFStatus();
            System.assertNotEquals(otif.secCon.IPM_Content_Type__c,IPM_ConstantUtils.OTIF_CONTENT_TYPE,System.Label.IPM_CATCH_BLOCK_CALLED);
            otif.iseditable=true;
            secConList  = otif.getSecConList();
            otif.projDocSecId=projDocSec.Id;
            otif.otifType=IPM_ConstantUtils.OTIF_TABLE;
            secConList  = otif.getSecConList();
            System.assertNotEquals(secConList,Null,SECTION_CONTENT_LIST_IS_EMPTY);
            otif.updateOTIFReadOnlyStatus();
            System.assertNotEquals(Null, otif.readOnlyOTIFContentMap.values());  
        
        Test.stopTest();
      }
      
        
      
      
    }
}