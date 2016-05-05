@isTest
private class Oblix_CampaignStageLogic_Test {

	@isTest static void Oblix_CampaignStageLogic_Test(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
        	MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Test.startTest();

			Oblix_CampaignStageLogic ctrl = new Oblix_CampaignStageLogic(mSow.id);
			Map<Integer, String> mis_stages_number_name = Oblix_CampaignStageLogic.mis_stages_number_name;
			Map<String, Integer> mis_stages_name_number = Oblix_CampaignStageLogic.mis_stages_name_number;
			Map<Integer, Integer> mii_stage_percentage = Oblix_CampaignStageLogic.mii_stage_percentage;
			List<Oblix_CampaignStageLogic.Stage> li_projected_stages = ctrl.li_projected_stages;
			List<Oblix_CampaignStageLogic.Stage> li_completed_stages = ctrl.li_completed_stages;

			Test.stopTest();
			
			System.assert(mis_stages_number_name != null);
			System.assert(mis_stages_name_number != null);
			System.assert(mii_stage_percentage != null);
			System.assert(li_projected_stages != null);
			System.assert(li_completed_stages != null);
        }
	}

	@isTest static void Oblix_CampaignStageLogic_Test2(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
        	MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);
            
            Test.startTest();

				Oblix_CampaignStageLogic ctrl = new Oblix_CampaignStageLogic(project.id, true,true);
				ctrl.saveStage();
				ctrl.setStageAttributes(true,true);
				ctrl.setCompletionStage(Oblix_CampaignStageLogic.STAGE_PROJECT_EXECUTION, Oblix_CampaignStageLogic.STAGE_PROJECT_IDEATIOIN);
				ctrl.setProjectedStage(Oblix_CampaignStageLogic.STAGE_PROJECT_EXECUTION, Oblix_CampaignStageLogic.STAGE_PROJECT_IDEATIOIN);
				
			Test.stopTest();


		System.assert(ctrl != null);
		System.assert(ctrl.li_projected_stages != null);
		System.assert(ctrl.li_completed_stages != null);


        }
	}
	
}