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
			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME, mSow.id);
			Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
			
			Oblix_CampaignSummaryController ctrl_noParams = new Oblix_CampaignSummaryController();
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
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME, mSow.id);
            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            
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



    @isTest static void Oblix_CampaignSummaryController_TestCancelCampaign(){
        User u = Oblix_TestUtils.createTestUser();
        insert Oblix_TestUtils.createOblixCustomSettings();
        System.runAs(u) {
            
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME, mSow.id);
            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            
            ApexPages.currentPage().getParameters().put(PAGE_PROJECT_ID_PARAMETER_NAME,project.Id);
            ApexPages.currentPage().getParameters().put(PAGE_SOW_ID_PARAMETER_NAME,mSow.Id);
            Oblix_CampaignSummaryController ctrl = new Oblix_CampaignSummaryController();
            
            PageReference cancelCampaign = ctrl.cancelCampaign();

            Test.stopTest();

            List<Oblix_SOW_Projects__c> projects = [SELECT Id, Campaign_Status__c FROM Oblix_SOW_Projects__c WHERE Id =: project.Id];
            System.assertEquals(Oblix_Utils.CAMPAIGN_STATUS_CANCELLED, projects[0].Campaign_Status__c);

            PageReference nextPage = Page.oblix_sowmaindetail;
            nextPage.getParameters().put(PAGE_SOW_ID_PARAMETER_NAME, mSow.Id);
            System.assertEquals(nextPage.getUrl(),cancelCampaign.getUrl());

        }
    }

}