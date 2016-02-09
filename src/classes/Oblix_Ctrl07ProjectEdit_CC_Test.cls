@isTest
private class Oblix_Ctrl07ProjectEdit_CC_Test {

    //private static final String NOT_NULL_MESSAGE = 'Page Reference should not be null';
    private static final String PROJECT_TXT = 'Project';
    private static final String PROJECTID_TXT = 'projectId';

    @isTest static void initTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            MDO_Geography__c geographyRegion = new MDO_Geography__c();
            geographyRegion.Name = 'Europe';
            geographyRegion.geography_type__c = 'Region';
            insert geographyRegion;

            MDO_Geography__c geographyCountry = new MDO_Geography__c();
            geographyCountry.Name = 'France';
            geographyCountry.geography_type__c = 'Country Cluste';
            geographyCountry.parent_L5__c = geographyRegion.Id;
            insert geographyCountry;

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            System.assert(project.Id != null, 'project not null');
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);

            Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();
            string complexity = controller.complexity;
            string idSplit = controller.idSplit;
            Set<Oblix_Project_Assets__c> ClearList = controller.ClearList;
            String selectedCountry = controller.selectedCountry;
            controller.subCat = 'Adaptation';
            controller.recordType = 'Experiential';
            controller.AddToProjectAction();

            Test.stopTest();

            System.assert(controller.userConnected != null, 'User should be set');
        }
    }

    //@istest static void backActionWithProjectTest() {
    //    User u = Oblix_TestUtils.createTestUser();
    //    System.runAs(u) {
    //        Test.startTest();

    //        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

    //        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

    //        Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

    //        ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

    //        Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();

    //        Test.stopTest();

    //        System.assert(controller.BackAction() != null, NOT_NULL_MESSAGE);
    //    }

    //}

    //@istest static void backActionWithoutProjectTest() {
    //    User u = Oblix_TestUtils.createTestUser();
    //    System.runAs(u) {

    //        Test.startTest();

    //        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

    //        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

    //        ApexPages.currentPage().getParameters().put('sowId', mSow.id);

    //        Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();

    //        Test.stopTest();

    //        System.assert(controller.BackAction() != null, NOT_NULL_MESSAGE);
    //    }

    //}

    //@isTest static void AddAgencySplitTest() {
    //    User u = Oblix_TestUtils.createTestUser();
    //    System.runAs(u) {
    //        Test.startTest();

    //        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

    //        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

    //        Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

    //        ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

    //        Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();

    //        controller.lstProjectSplitHubs = new List<Oblix_Marketing_SOW_Project_Splits__c>();

    //        controller.AddAgencySplit();

    //        Test.stopTest();

    //        System.assert(!controller.lstProjectSplitHubs.isEmpty(), 'Collection should not be empty');
    //    }
    //}


    //@isTest static void setInfoSplitHubTest() {
    //    User u = Oblix_TestUtils.createTestUser();
    //    System.runAs(u) {
    //        Test.startTest();

    //        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

    //        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

    //        Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

    //        ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

    //        Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();

    //        controller.listItems = 'null_null_1.0,null_null_2.0,';

    //        controller.setInfoSplitHub();

    //        System.assert(controller.agencySplitInstanceJS != null, 'Object should not be null');

    //        //controller.ValueDriversUpdate();
    //        //controller.getAssetRecordType();

    //        Test.stopTest();
    //    }
    //}

    //@isTest static void setInfoMethodTest() {
    //    User u = Oblix_TestUtils.createTestUser();
    //    System.runAs(u) {
    //        Test.startTest();

    //        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

    //        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

    //        Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

    //        ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

    //        Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();

    //        controller.setInfoDrivers();
    //        controller.setInfoStages();
    //        controller.setInfoCountries();
    //        controller.setInfoTimeLine();
    //        controller.EditAction();
    //        //controller.setAgencyHubOnComplete();
    //        controller.setMoreDetails();
    //        controller.saveSubCatAsset();
    //        controller.SaveProjectAction();

    //        Test.stopTest();

    //        System.assert(project != null, 'Project should not be null');
    //        System.assert(controller.isEdit, 'Edit flag should be set');
    //    }
    //}

    //static testMethod void ValueDriversProjectTest() {
    //    User u = Oblix_TestUtils.createTestUser();
    //    System.runAs(u) {
    //        Test.startTest();

    //        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

    //        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

    //        Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

    //        ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

    //        Oblix_Ctrl07ProjectEdit_CC controller = new Oblix_Ctrl07ProjectEdit_CC();

    //        controller.project = project;

    //        controller.ValueDriversProject('c1,c2,c4,c4');
    //        controller.ValueDriversProject('c1,c2,c4,c4,c5,c6');
    //        controller.ValueDriversProject('c1,c2,c4,c4,c5,c6,c7,c8,c9,c10,c11');
    //        controller.ValueDriversProject('c1,c2,c4,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16');

    //        Test.stopTest();

    //        System.assertEquals(controller.project.Project_Scale_1__c , Oblix_Constants.Innovation_Projects_Market5, 'Field should not be empty');

    //    }

    //}

    //private static Oblix_SOW_Projects__c initSaveProjectActionData() {
    //    Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('test_project',
    //                                    Oblix_TestUtils.createTestMarketingSow(null, null,
    //                                            Oblix_TestUtils.createBrand('test_brand', 'test').Id).Id);

    //    ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
    //    return project;
    //}

    //@isTest static void SaveProjectAction_Error_Test() {
    //    System.runAs(Oblix_TestUtils.createTestUser()) {
    //        Oblix_SOW_Projects__c project = initSaveProjectActionData();

    //        Oblix_Ctrl07ProjectEdit_CC ctrl = new Oblix_Ctrl07ProjectEdit_CC();

    //        ctrl.project = project;
    //        ctrl.project.Name = null;
    //        ctrl.projectId = project.Id;

    //        Test.startTest();
    //        System.assertEquals(null, ctrl.SaveProjectAction());
    //        Test.stopTest();
    //    }
    //}

    //@isTest static void SaveProjectAction_Error2_Test() {
    //    System.runAs(Oblix_TestUtils.createTestUser()) {
    //        Oblix_SOW_Projects__c project = initSaveProjectActionData();
    //        Oblix_Ctrl07ProjectEdit_CC ctrl = new Oblix_Ctrl07ProjectEdit_CC();
    //        ctrl.project = project;
    //        ctrl.project.Name = null;
    //        ctrl.projectId = null;

    //        Test.startTest();
    //        System.assertEquals(null, ctrl.SaveProjectAction());
    //        Test.stopTest();
    //    }
    //}

    //@isTest static void SaveProjectAction_Error3_Test(){
    //    System.runAs(Oblix_TestUtils.createTestUser()) {
    //        Oblix_SOW_Projects__c project = initSaveProjectActionData();
    //        Oblix_Ctrl07ProjectEdit_CC ctrl = new Oblix_Ctrl07ProjectEdit_CC();
    //        ctrl.project = project;
    //        ctrl.projectId = null;

    //        Test.startTest();
    //        System.assertEquals(null, ctrl.SaveProjectAction());
    //        Test.stopTest();
    //    }
    //}
    
    //@isTest static void setAsGlobal_Test(){
    
    //    System.runAs(Oblix_TestUtils.createTestUser()) {
    //        Oblix_SOW_Projects__c project = initSaveProjectActionData();
    //        Oblix_Ctrl07ProjectEdit_CC ctrl = new Oblix_Ctrl07ProjectEdit_CC();
    //        ctrl.project = project;
    //        ctrl.projectId = project.Id;
            
    //        Test.startTest();
    //        ctrl.setAsGlobal();
    //        Test.stopTest();
            
    //        Oblix_SOW_Projects__c result = [select OblixRegion__c from Oblix_SOW_Projects__c where id = :project.Id];
    //        System.assertEquals('World',result.OblixRegion__c);
    //    }
    //}
    
    //@isTest static void removeAsset_Test(){
    
    //    System.runAs(Oblix_TestUtils.createTestUser()) {
            
    //        Oblix_SOW_Projects__c project = initSaveProjectActionData();
    //        Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            
    //        Test.startTest();
    //        Oblix_Ctrl07ProjectEdit_CC.removeAsset(asset.Id);
    //        Test.stopTest();
            
    //        List<Oblix_Project_Assets__c> result = [select Id from Oblix_Project_Assets__c where id = :asset.Id];
    //        System.assert(result.isEmpty());
    //    }
    //}
    
    
    //@isTest static void refresh_Test(){
    
    //    System.runAs(Oblix_TestUtils.createTestUser()) {
            
    //        Oblix_SOW_Projects__c project = initSaveProjectActionData();
    //        project.Total_Fees_for_Project__c  = 1000;
    //        update project;
    //        Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
    //        Oblix_Ctrl07ProjectEdit_CC ctrl = new Oblix_Ctrl07ProjectEdit_CC();
            
    //        Test.startTest();
    //        ctrl.refresh();
    //        Test.stopTest();
    //        System.assertNotEquals(ctrl, NULL);
            
    //    }
    //}
    
    //@isTest static void getAbreviationForCardAssets_Test(){
    
    //    System.runAs(Oblix_TestUtils.createTestUser()) {
            
    //        Oblix_SOW_Projects__c project = initSaveProjectActionData();
    //        Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            
    //        Test.startTest();
    //        Map<String, String> result = Oblix_Ctrl07ProjectEdit_CC.getAbreViationByRTBySubCatgForCardAssets();
    //        Test.stopTest();
            
    //        System.assert(!result.isEmpty());
    //    }
    //}    
    
    
    // @isTest static void getAssetDetails_Test(){
    
    //    System.runAs(Oblix_TestUtils.createTestUser()) {
            
    //        Oblix_SOW_Projects__c project = initSaveProjectActionData();
    //        Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            
    //        Test.startTest();
    //        Oblix_Utils.AssetDetailWrapper result = Oblix_Ctrl07ProjectEdit_CC.getAssetDetails(asset.Id);
    //        Test.stopTest();
            
    //        System.assert(result != null);
    //    }
    //}       
    
    //@isTest static void UpdateProjectAction_Test(){
    
    //    System.runAs(Oblix_TestUtils.createTestUser()) {
            
    //        Oblix_SOW_Projects__c project = initSaveProjectActionData();
    //        Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
    //        asset.Asset_Title__c = 'test X title';
    //        update asset;
    //        Oblix_Ctrl07ProjectEdit_CC ctrl = new Oblix_Ctrl07ProjectEdit_CC();
    //        Map<String, Object> details = new Map<String, Object>();
    //        details.put('actual_Delivery_Date', '2015-01-01');
    //        details.put('quantity', '50');
            
    //        Test.startTest();
    //        Oblix_Ctrl07ProjectEdit_CC.UpdateProjectAction(asset.Id, details) ;
    //        Test.stopTest();
            
    //        Oblix_Project_Assets__c result = [select quantity__c from Oblix_Project_Assets__c where id =: asset.Id];
    //        System.assertEquals(50,result.quantity__c);
    //    }
    //}      
    
}