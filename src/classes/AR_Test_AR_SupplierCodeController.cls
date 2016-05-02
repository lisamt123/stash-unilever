@isTest
private class AR_Test_AR_SupplierCodeController {
    
    static testMethod void myUnitTest() {
        // insert all data required for the page (consider Custom Settings, f)
        ar_Application__c app = new ar_Application__c(Last_Name__c = 'Ortiz');
        insert app;
        
        // how filed set should be loaded
        //ar_Application__c inputData = TestDataFactory.getApplication();
        //inputData.Agree_to_comply_Unilever_Supplier_Code__c = 'Yes';
        
        // field sets on the page
        //List<Schema.FieldSetMember> fs_supplierCode = AR_MetaDataHandler.GetAllApplicationFieldsets().get('supplier_code');
        
        Test.startTest();
            // page context
            Cookie cook = AR_SessionHandler.getCookie(app.id);
            PageReference pr = Page.ar_suppliercode;
            pr.setCookies(new Cookie[]{cook});
            Test.setCurrentPage(pr);
            
            // instantiate controller
            AR_SupplierCodeController controller = new AR_SupplierCodeController();
            
            // start page
            controller.initPage();
            
            // check if data was loaded
            system.assertNotEquals(null, controller.applicationObject.getId(), 'Application data was not loaded');
            
            // enter values in the form (option 1)
            ar_Application__c ctr_application = (ar_Application__c)controller.applicationObject.obj;
            ctr_application.Agree_to_comply_Unilever_Supplier_Code__c = 'Yes';
            
            // enter values in the form (option 2)
            //ctr_application = TestDataFactory.loadValuesInFieldSet(inputData, fs_supplierCode);
            
            // save data
            controller.save();
            
        Test.stopTest();
        
        // check if save was successfull
        app = [select id, Agree_to_comply_Unilever_Supplier_Code__c from ar_Application__c where id = :app.id];
        system.assertEquals('Yes', app.Agree_to_comply_Unilever_Supplier_Code__c, 'Save failed. Supplier code was not agreed');
    }
}