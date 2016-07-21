@isTest
private class Oblix_CampaignSummaryController_Test {

	@isTest static void Oblix_CampaignSummaryController_Test(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
        	
            Test.startTest();

			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);
			Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
			
			Oblix_CampaignSummaryController ctrl_noParams = new Oblix_CampaignSummaryController();
            ApexPages.currentPage().getParameters().put('projectId',project.Id);
            ApexPages.currentPage().getParameters().put('sowId',mSow.Id);
			Oblix_CampaignSummaryController ctrl = new Oblix_CampaignSummaryController();
			List<Oblix_Project_Assets__c> assets = ctrl.getLiso_assets();
			System.assert(!assets.isEmpty());
			ctrl.selected_asset_id = asset.Id;
			PageReference remove = ctrl.removeAsset();
			System.assertEquals(null,remove);
			PageReference action = ctrl.addAssetAction();
			System.assert(action != null);
			Pagereference exitAction = ctrl.exitSwop();
			System.assert(exitAction != null);
			Test.stopTest();
        }
	}
}