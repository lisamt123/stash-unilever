@isTest
private class Oblix_CampaignStageController_Test {

	@isTest static void Oblix_CampaignStageController_Test(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Test.startTest();

			Oblix_CampaignStageLogic logic = new Oblix_CampaignStageLogic(mSow.id);
			Oblix_CampaignStageController ctrl = new Oblix_CampaignStageController();
			ctrl.stage_identifier = logic;
			ctrl.b_auto_save = true;
			ctrl.s_completion_stage = Oblix_CampaignStageLogic.STAGE_PROJECT_EXECUTION;
			ctrl.s_projection_stage = Oblix_CampaignStageLogic.STAGE_PROJECT_IDEATIOIN;

			PageReference result = ctrl.setCompletionStageIdentifier();
			System.assertEquals(null, result);
			PageReference result2 = ctrl.setProjectedStageIdentifier();
			System.assertEquals(null, result2);

			Test.stopTest();
        }
	}

}