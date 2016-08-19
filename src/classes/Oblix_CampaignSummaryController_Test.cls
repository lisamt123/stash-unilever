@isTest
private class Oblix_CampaignSummaryController_Test {

    private static final String PROJECT_NAME = 'Project';
    private static final String PAGE_PROJECT_ID_PARAMETER_NAME = 'projectId';
    private static final String PAGE_SOW_ID_PARAMETER_NAME = 'sowId';

    @isTest static void Oblix_CampaignSummaryController_Test(){
        User u = Oblix_TestUtils.createTestUser();
        insert Oblix_TestUtils.createOblixCustomSettings();
        System.runAs(u) {
            
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME + System.now().addDays(2), mSow.id);

            project.Project_Start_Date__c = date.today();
            project.Project_Completion_Date__c = date.today();
            project.First_Air_Date__c = date.today();
            project.Production_Completion_Date__c = date.today();
            project.BET_first_release__c = date.today();
            project.Date_for_Assets_to_be_in_BET__c = date.today();
            project.Preview_Date__c = date.today();
            project.Start_of_TV_production__c = date.today();
            project.Final_release__c = date.today();
            project.Live_Date__c = date.today();
            project.Live_date_Asset_delivery__c = date.today();

            update project;

            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            
            Oblix_CampaignSummaryController ctrl_noParams = new Oblix_CampaignSummaryController();
            ctrl_noParams.removeAsset();
            ApexPages.currentPage().getParameters().put(PAGE_PROJECT_ID_PARAMETER_NAME,project.Id);
            ApexPages.currentPage().getParameters().put(PAGE_SOW_ID_PARAMETER_NAME,mSow.Id);
            Oblix_CampaignSummaryController ctrl = new Oblix_CampaignSummaryController();

            System.assertNotEquals(null, ctrl.can_adjust_fee);
            System.assertNotEquals(null, ctrl.can_manage_asset);
            
            List<Oblix_Project_Assets__c> assets = ctrl.getLiso_assets();
            System.assert(!assets.isEmpty());
            
            ctrl.selected_asset_id = asset.Id;
            PageReference viewAsset = ctrl.viewAsset();
            System.assertNotEquals(null,viewAsset);
            
            ctrl.PercentToAdjust = 67;
            PageReference adjustFee = ctrl.adjustFee();
            System.assertNotEquals(null,adjustFee);
            
            PageReference remove = ctrl.removeAsset();
            System.assertEquals(null,remove);
            
            PageReference action = ctrl.addAssetAction();
            System.assert(action != null);
            
            Pagereference exitAction = ctrl.exitSwop();
            System.assert(exitAction != null);

            System.assertEquals(null,ctrl.turn_over_size);
            System.assertNotEquals(null,ctrl.maxAllowedAdjustValue);
            System.assertNotEquals(null,ctrl.reportDeveloperName);
            
            Test.stopTest();
        }
    }




    @isTest static void Oblix_CampaignSummaryController_TestDeleteCampaign(){
        User u = Oblix_TestUtils.createTestUser();
        insert Oblix_TestUtils.createOblixCustomSettings();
        System.runAs(u) {
            
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME + System.now().addDays(3), mSow.id);
            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            system.assert(asset!=null,'asset inserted');
            
            ApexPages.currentPage().getParameters().put(PAGE_PROJECT_ID_PARAMETER_NAME,project.Id);
            ApexPages.currentPage().getParameters().put(PAGE_SOW_ID_PARAMETER_NAME,mSow.Id);
            Oblix_CampaignSummaryController ctrl = new Oblix_CampaignSummaryController();
            
            PageReference deleteCampaign = ctrl.deleteCampaign();

            Test.stopTest();

            List<Oblix_SOW_Projects__c> projects = [SELECT Id FROM Oblix_SOW_Projects__c WHERE Id =: project.Id];
            System.assertEquals(0, projects.size());

            Pagereference sow_page = Page.Oblix_SOWMainDetail;
            sow_page.getParameters().put(PAGE_SOW_ID_PARAMETER_NAME, mSow.Id);
            sow_page.setRedirect(true);
            System.assertEquals(sow_page.getUrl(),deleteCampaign.getUrl());

        }
    }



    @isTest static void Oblix_CampaignSummaryController_TestDeleteCampaignException(){
        User u = Oblix_TestUtils.createTestUser();
        insert Oblix_TestUtils.createOblixCustomSettings();
        System.runAs(u) {
            
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME + System.now().addDays(3), mSow.id);
            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            system.assert(asset!=null,'asset inserted');
            ApexPages.currentPage().getParameters().put(PAGE_PROJECT_ID_PARAMETER_NAME,project.Id);
            ApexPages.currentPage().getParameters().put(PAGE_SOW_ID_PARAMETER_NAME,mSow.Id);
            Oblix_CampaignSummaryController ctrl = new Oblix_CampaignSummaryController();
            
            Oblix_SOW_Projects__c bckp = ctrl.selected_project;
            system.assert(bckp !=null,'bckp inserted');
            ctrl.selected_project = null;
            PageReference deleteCampaign = ctrl.deleteCampaign();

            Test.stopTest();

            List<Oblix_SOW_Projects__c> projects = [SELECT Id FROM Oblix_SOW_Projects__c WHERE Id =: project.Id];
            System.assertEquals(1, projects.size());

            System.assertEquals(null,deleteCampaign);

        }
    }



    @isTest static void Oblix_CampaignSummaryController_TestCancelCampaign(){
        User u = Oblix_TestUtils.createTestUser();
        insert Oblix_TestUtils.createOblixCustomSettings();
        System.runAs(u) {
            
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME + System.now().addDays(4), mSow.id);
            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            system.assert(asset!=null,'asset inserted');
            ApexPages.currentPage().getParameters().put(PAGE_PROJECT_ID_PARAMETER_NAME,project.Id);
            ApexPages.currentPage().getParameters().put(PAGE_SOW_ID_PARAMETER_NAME,mSow.Id);
            Oblix_CampaignSummaryController ctrl = new Oblix_CampaignSummaryController();
            
            PageReference cancelCampaign = ctrl.cancelCampaign();

            Test.stopTest();

            List<Oblix_SOW_Projects__c> projects = [SELECT Id, Campaign_Status__c FROM Oblix_SOW_Projects__c WHERE Id =: project.Id];
            PageReference nextPage = Page.oblix_sowmaindetail;
            nextPage.getParameters().put(PAGE_SOW_ID_PARAMETER_NAME, mSow.Id);
            //System.assertEquals(nextPage.getUrl(),cancelCampaign.getUrl());

        }
    }

    @isTest static void Oblix_CampaignSummaryController_TestSyncCampaign(){
        User u = Oblix_TestUtils.createTestUser();
        insert Oblix_TestUtils.createOblixCustomSettings();
        PageReference cancelCampaign;
        System.runAs(u) {
            
            Test.startTest();
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Marketing_SOW__c mSow1 = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME + System.now(), Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME + System.now(), mSow.id);
            Oblix_SOW_Projects__c project1 = Oblix_TestUtils.createSowProjects(PROJECT_NAME + System.now().addDays(5), mSow1.id);
            project.Sync_Status__c = Oblix_TestUtils.JOB_STATUS_SYNC_REQUIRED;
            update project;
            project1.Campaign_PFY__c = project.Id;
            update project1;
            
            ApexPages.currentPage().getParameters().put(PAGE_PROJECT_ID_PARAMETER_NAME,project1.Id);
            ApexPages.currentPage().getParameters().put(PAGE_SOW_ID_PARAMETER_NAME,mSow.Id);
            Oblix_CampaignSummaryController ctrl = new Oblix_CampaignSummaryController();
            
            cancelCampaign = ctrl.syncCampaign();

            Test.stopTest();

            List<Oblix_SOW_Projects__c> projects = [SELECT Id, Sync_Status__c FROM Oblix_SOW_Projects__c WHERE Id =: project.Id];
            //System.assertEquals(Oblix_TestUtils.JOB_STATUS_SYNC_REQUESTED, projects[0].Sync_Status__c);

            

        }
    }



    @isTest static void Oblix_CampaignSummaryController_TestRefreshPopUpStageIdentifier(){
        User u = Oblix_TestUtils.createTestUser();
        insert Oblix_TestUtils.createOblixCustomSettings();
        System.runAs(u) {

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME + System.now().addDays(2), mSow.id);

            ApexPages.currentPage().getParameters().put(PAGE_PROJECT_ID_PARAMETER_NAME,project.Id);
            ApexPages.currentPage().getParameters().put(PAGE_SOW_ID_PARAMETER_NAME,mSow.Id);
            Oblix_CampaignSummaryController ctrl = new Oblix_CampaignSummaryController();

            Test.startTest();
        
            ctrl.refreshPopUpStageIdentifier();            
            
            Test.stopTest();

            System.assertEquals(ctrl.stage_identifier_pop_up.sow_project_in_scope.Projected_Stage_CFY__c, ctrl.stage_identifier.sow_project_in_scope.Projected_Stage_CFY__c);
            System.assertEquals(ctrl.stage_identifier_pop_up.sow_project_in_scope.Completed_Stage_CFY__c, ctrl.stage_identifier.sow_project_in_scope.Completed_Stage_CFY__c);
        }
    }



}