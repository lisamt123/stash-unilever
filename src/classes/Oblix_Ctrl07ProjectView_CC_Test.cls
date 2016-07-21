@isTest
private class Oblix_Ctrl07ProjectView_CC_Test {

    private static final String NOT_NULL_MESSAGE = 'Page Reference should not be null';
    private static final String PROJECTID_TXT = 'projectId';


    private static Oblix_SOW_Projects__c createTestData() {

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

        Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);

        return project;
    }

    @isTest static void actionTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            Oblix_SOW_Projects__c project = createTestData();

            Oblix_TestUtils.createProjectAssets(project.id);

            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

            Oblix_Ctrl07ProjectView_CC controller = new Oblix_Ctrl07ProjectView_CC();

            Test.stopTest();

            controller.init();

            controller.SaveProject();

            System.assert(controller.BackToSow() != null, NOT_NULL_MESSAGE);
            System.assert(controller.CloneCampaign() != null, NOT_NULL_MESSAGE);
            System.assert(controller.EditItems() != null, NOT_NULL_MESSAGE);
            System.assert(controller.EditAddItems() != null, NOT_NULL_MESSAGE);
        }
    }

    @isTest static void DeleteItemsActionTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            Oblix_SOW_Projects__c project = createTestData();

            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.id);

            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

            Oblix_Ctrl07ProjectView_CC controller = new Oblix_Ctrl07ProjectView_CC();

            controller.init();

            controller.itemToDelete = asset.id;

            controller.DeleteItemsAction();

            Test.stopTest();

            List<Oblix_Project_Assets__c> assets = [select id from Oblix_Project_Assets__c where id = : asset.id];

            System.assert(assets.isEmpty(), 'Asset list should be empty');
        }
    }

    @istest static void SaveItemsActionTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            Oblix_SOW_Projects__c project = createTestData();

            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.id);

            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

            Oblix_Ctrl07ProjectView_CC controller = new Oblix_Ctrl07ProjectView_CC();

            controller.init();

            controller.itemToDelete = asset.id;

            controller.SaveItemsAction();

            Test.stopTest();

            List<Oblix_Project_Assets__c> assets = [select id from Oblix_Project_Assets__c where id = : asset.id];

            System.assert(!assets.isEmpty(), 'Asset list should not be empty');
        }
    }

    @isTest static void cancelCampaign_Test() {
        System.runAs(Oblix_TestUtils.createTestUser()) {
            Oblix_SOW_Projects__c project = createTestData();
            Oblix_Ctrl07ProjectView_CC ctrl = new Oblix_Ctrl07ProjectView_CC();
            ctrl.selectedProject = project;
            ctrl.cancelCampaign();
            System.assertEquals('canceled', ctrl.selectedProject.Campaign_Status__c, 'Project is not canceled.');
        }
    }

    @isTest static void EditItemsAction_Test() {
        System.runAs(Oblix_TestUtils.createTestUser()) {
            Oblix_Ctrl07ProjectView_CC ctrl = new Oblix_Ctrl07ProjectView_CC();
            Test.startTest();
            ctrl.EditItemsAction();
            Test.stopTest();
            System.assertEquals(true, ctrl.isEditItem, 'Item is not being edited.');
        }
    }

    @isTest static void SaveProject_Test() {
        System.runAs(Oblix_TestUtils.createTestUser()) {
            Oblix_SOW_Projects__c project = createTestData();
            Oblix_Ctrl07ProjectView_CC ctrl = new Oblix_Ctrl07ProjectView_CC();
            project.Name = null;
            project.Id = null;
            ctrl.SelectedProject = project;
            ctrl.SaveProject();
            System.assertEquals(ctrl.SelectedProject != null, true, 'project is being created');
        }
    }
}