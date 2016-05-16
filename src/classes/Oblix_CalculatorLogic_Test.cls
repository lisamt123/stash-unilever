/*****************************************************************************************
* @author       Execloud ©
* @date         2016-01-06
* @description  Apex test class for calculator logic, fees, scores, etc
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Execloud ©            	2016-02-19          Created
*
******************************************************************************************/
@isTest
public with sharing class Oblix_CalculatorLogic_Test {
	public Oblix_CalculatorLogic_Test() {
		
	}

	private static List<Asset_Scoring__c> list_of_asset_scoring;
	private static void initialiseTestClass(){

		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
        	list_of_asset_scoring = Oblix_TestUtils.createAssetScoringRecords(10);	
        	insert list_of_asset_scoring;

        	insert Oblix_TestUtils.createOblixCustomSettings();
        	insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
        	insert Oblix_TestUtils.createCountryCalculatorRecords();


        }

	}


	//private static testMethod void checkTotalBusinessDriverScoreCalculatorRecords(){
		
	//	initialiseTestClass();

	//	Oblix_CalculatorLogic.getCalculatorRecords();

 //       MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

 //       Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);


	//	Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(4,10,5,mSow.Id,'Total turnover €300-€400m', 'Multiple countries (5-10), multiple language (5-10)', 'Up to 4 locations', 'Existing');

	//	system.debug('### map_campaigns_to_test: ' + json.serialize(map_campaigns_to_test));
 //       // Brand_Led_Growth__c: Total turnover €300-€400m = 0.45
 //       // Project_Scale_1__c: Multiple countries (5-10), multiple language (5-10) = 0.35
 //       // Project_Scale_2__c: Up to 5 locations = 0.30
 //       // Campaign_Idea__c: Existing = 0.6
 //       // total = 1.70

	//	// ***********************************************************************************************
	//	// 		TEST BUSINESS DRIVER SCORE
	//	// ***********************************************************************************************
	//	Map<Id, Decimal> map_campaign_business_driver = Oblix_CalculatorLogic.getTotalBusinessDriverScore(map_campaigns_to_test);

	//	List<Oblix_Project_Assets__c> list_assets_in_basket = new List<Oblix_Project_Assets__c>();
	//	Oblix_SOW_Projects__c project;

	//	// all campaigns should have the same business driver score 
	//	for (Id campaign_id : map_campaigns_to_test.keySet()){
	//		system.assertEquals(1.70, map_campaign_business_driver.get(campaign_id), 'expecting 1.65 as total business driver score actual!');
			
	//		project = map_campaigns_to_test.get(campaign_id);

	//		list_assets_in_basket.addAll(project.Agency_Project_Assets__r);
	//	}	
	//	system.debug('### list_assets_in_basket: ' + json.serialize(list_assets_in_basket));

	//	// ***********************************************************************************************
	//	// 		TEST TOTAL ASSETS SCORE
	//	// ***********************************************************************************************
	//	List<Oblix_AssetOfferingWrapper.AssetWrapper> asset_wrappers_in_basket = Oblix_AssetOfferingWrapper.convertAssetToItemsInBasket(list_assets_in_basket);

	//	Map<Id, Decimal> midd_project_asset_total = Oblix_CalculatorLogic.calculateTotalAssetScore(asset_wrappers_in_basket);

	//	system.debug('### asset_wrappers_in_basket: ' + json.serialize(asset_wrappers_in_basket));
	//	system.debug('### midd_project_asset_total: ' + json.serialize(midd_project_asset_total));

	//	Map<Id, Decimal> midd_expected_asset_totals = new Map<Id, Decimal>();

	//	for (Oblix_Project_Assets__c assets : [SELECT Asset_score__c, Quantity__c, Agency_Projects__c FROM Oblix_Project_Assets__c WHERE Agency_Projects__c in : midd_project_asset_total.keySet()]){

	//		system.debug('### assets: ' + json.serialize(assets));

	//		Integer total_score =  midd_expected_asset_totals.containsKey(assets.Agency_Projects__c)
	//			? (Integer) midd_expected_asset_totals.get(assets.Agency_Projects__c)
	//			: 0;

	//		total_score += (Integer) (assets.Quantity__c * assets.Asset_score__c);
					
	//		midd_expected_asset_totals.put(assets.Agency_Projects__c, total_score);

	//	}


	//	for(Id campaign_id : midd_project_asset_total.keySet()){
	//		system.debug('### campaign_id: ' + campaign_id);
	//		system.assertEquals(midd_expected_asset_totals.get(campaign_id), midd_project_asset_total.get(campaign_id),  'expecting ' + midd_expected_asset_totals.get(campaign_id) + ' actual was ' + midd_project_asset_total.get(campaign_id));
	//	}

	//	// ***********************************************************************************************
	//	// 		TEST TOTAL CAMPAIGN SCORE
	//	// ***********************************************************************************************
	//	Map<Id, Decimal> midd_project_total_score = Oblix_CalculatorLogic.getTotalProjectScore(map_campaign_business_driver, midd_project_asset_total);

	//	for (Id campaign_id : map_campaigns_to_test.keySet()){
			
	//		Decimal campaign_score = (midd_project_asset_total.get(campaign_id)/100) * map_campaign_business_driver.get(campaign_id);


	//		system.assertEquals(campaign_score, midd_project_total_score.get(campaign_id), 'expecting ' + campaign_score + ' as total campaign score actual was' + midd_project_total_score.get(campaign_id));
	//	}


	//	// ***********************************************************************************************
	//	// 		TEST TOTAL CAMPAIGN FEE
	//	// ***********************************************************************************************
	//	Map<Id, Decimal> midd_project_total_fee = Oblix_CalculatorLogic.calculateFeeByHubs(map_campaigns_to_test,midd_project_total_score);
	//	// all campaigns should have the same business driver score 
	//	for (Id campaign_id : map_campaigns_to_test.keySet()){
			

	//		Decimal total_fee = 0;
	//		project = map_campaigns_to_test.get(campaign_id);
	//		Decimal project_score = 0;
	//		Decimal point_score = 0;
	//		String box_number ='';

			
	//		project_score = midd_project_total_score.get(campaign_id);
			

			
	//		for (Oblix_Marketing_SOW_Project_Splits__c project_split : project.Marketing_SOW_Project_Splits__r){

	//			system.debug('##TESTING 1- campaign_id: ' + campaign_id + ' - project_score: ' + project_score + ' - Financial_Year__c: ' +  project.Financial_Year__r.Financial_Year__c);

	//			// get the box number for the given project financial year and total project score
	//			box_number = Oblix_CalculatorLogic.getFinancialYearCalculator().getBoxNumberAsFieldFormat(project_score, project.Financial_Year__r.Financial_Year__c);

	//			system.debug('##TESTING 2- campaign_id: ' + campaign_id + ' - project_score: ' + project_score + ' - Financial_Year__c: ' +  project.Financial_Year__r.Financial_Year__c + ' - box_number: '+ box_number);

	//			if (NULL != box_number){
	//				// get point score for the given box number and financial year
	//				point_score = Oblix_CalculatorLogic.getCountryBoxCalculator().getPointScore(box_number, project.Financial_Year__r.Financial_Year__c
	//					, project_split.OblixCountry__r.Name.toUpperCase());

	//				total_fee += Oblix_CalculatorLogic.calculateFeeBySplitAndPointScore(point_score, project_split.Percentage__c);
	//			}
	//		}

	//		system.assertEquals(total_fee, midd_project_total_fee.get(campaign_id),  'expecting ' + total_fee + ' as total campaign score actual was' + midd_project_total_fee.get(campaign_id));
	//	}
	//}


	private static testMethod void checkCampaignWithLargeNumberOfAssetsAndBusinessDriverScore(){
		
		initialiseTestClass();

		Oblix_CalculatorLogic.getCalculatorRecords();

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);


		Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(3,100,5,mSow.Id,'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');

		system.debug('### map_campaigns_to_test: ' + json.serialize(map_campaigns_to_test));
        // Brand_Led_Growth__c: Total turnover >€400m = 0.5
        // Project_Scale_1__c: Global campaign (all market clusters) = 0.5
        // Project_Scale_2__c: Up to 5 locations = 0.30
        // Campaign_Idea__c: New – Multi channel = 1.2
        // total = 2.50

		// ***********************************************************************************************
		// 		TEST BUSINESS DRIVER SCORE
		// ***********************************************************************************************
		Map<Id, Decimal> map_campaign_business_driver = Oblix_CalculatorLogic.getTotalBusinessDriverScore(map_campaigns_to_test);

		List<Oblix_Project_Assets__c> list_assets_in_basket = new List<Oblix_Project_Assets__c>();
		Oblix_SOW_Projects__c project;

		// all campaigns should have the same business driver score 
		for (Id campaign_id : map_campaigns_to_test.keySet()){
			system.assertEquals(2.50, map_campaign_business_driver.get(campaign_id), 'expecting 2.50 as total business driver score actual!');
			
			project = map_campaigns_to_test.get(campaign_id);

			list_assets_in_basket.addAll(project.Agency_Project_Assets__r);
		}	
		system.debug('### list_assets_in_basket: ' + json.serialize(list_assets_in_basket));

		// ***********************************************************************************************
		// 		TEST TOTAL ASSETS SCORE
		// ***********************************************************************************************
		List<Oblix_AssetOfferingWrapper.AssetWrapper> asset_wrappers_in_basket = Oblix_AssetOfferingWrapper.convertAssetsToItemsInBasket(list_assets_in_basket);

		Map<Id, Decimal> midd_project_asset_total = Oblix_CalculatorLogic.calculateTotalAssetScore(asset_wrappers_in_basket);

		system.debug('### asset_wrappers_in_basket: ' + json.serialize(asset_wrappers_in_basket));
		system.debug('### midd_project_asset_total: ' + json.serialize(midd_project_asset_total));

		Map<Id, Decimal> midd_expected_asset_totals = new Map<Id, Decimal>();

		for (Oblix_Project_Assets__c assets : [SELECT Asset_score__c, Quantity__c, Agency_Projects__c FROM Oblix_Project_Assets__c WHERE Agency_Projects__c in : midd_project_asset_total.keySet()]){

			system.debug('### assets: ' + json.serialize(assets));

			Integer total_score =  midd_expected_asset_totals.containsKey(assets.Agency_Projects__c)
				? (Integer) midd_expected_asset_totals.get(assets.Agency_Projects__c)
				: 0;

			total_score += (Integer) (assets.Quantity__c * assets.Asset_score__c);
					
			midd_expected_asset_totals.put(assets.Agency_Projects__c, total_score);

		}


		for(Id campaign_id : midd_project_asset_total.keySet()){
			system.debug('### campaign_id: ' + campaign_id);
			system.assertEquals(midd_expected_asset_totals.get(campaign_id), midd_project_asset_total.get(campaign_id),  'expecting ' + midd_expected_asset_totals.get(campaign_id) + ' actual was ' + midd_project_asset_total.get(campaign_id));
		}

		// ***********************************************************************************************
		// 		TEST TOTAL CAMPAIGN SCORE
		// ***********************************************************************************************
		Map<Id, Decimal> midd_project_total_score = Oblix_CalculatorLogic.getTotalProjectScore(map_campaign_business_driver, midd_project_asset_total);

		for (Id campaign_id : map_campaigns_to_test.keySet()){
			
			Decimal campaign_score = (midd_project_asset_total.get(campaign_id)/100) * map_campaign_business_driver.get(campaign_id);


			system.assertEquals(campaign_score, midd_project_total_score.get(campaign_id), 'expecting ' + campaign_score + ' as total campaign score actual was' + midd_project_total_score.get(campaign_id));
		}

		// ***********************************************************************************************
		// 		TEST TOTAL CAMPAIGN FEE
		// ***********************************************************************************************
    	Map<Id, String> map_campaign_id_box_number = Oblix_CalculatorLogic.getBoxNumber(map_campaigns_to_test , midd_project_total_score);

		Map<Id, Decimal> midd_project_total_fee = Oblix_CalculatorLogic.calculateFeeByHubs(map_campaigns_to_test,map_campaign_id_box_number);
		// all campaigns should have the same business driver score 
		for (Id campaign_id : map_campaigns_to_test.keySet()){
			

			Decimal total_fee = 0;
			project = map_campaigns_to_test.get(campaign_id);
			Decimal project_score = 0;
			Decimal point_score = 0;
			String box_number ='';

			
			project_score = midd_project_total_score.get(campaign_id);
			

			
			for (Oblix_Marketing_SOW_Project_Splits__c project_split : project.Marketing_SOW_Project_Splits__r){

				system.debug('##TESTING 1- campaign_id: ' + campaign_id + ' - project_score: ' + project_score + ' - Financial_Year__c: ' +  project.Financial_Year__r.Financial_Year__c);

				// get the box number for the given project financial year and total project score
				box_number = Oblix_CalculatorLogic.getFinancialYearCalculator().getBoxNumberAsFieldFormat(project_score, project.Financial_Year__r.Financial_Year__c);

				system.debug('##TESTING 2- campaign_id: ' + campaign_id + ' - project_score: ' + project_score + ' - Financial_Year__c: ' +  project.Financial_Year__r.Financial_Year__c + ' - box_number: '+ box_number);

				if (NULL != box_number){
					// get point score for the given box number and financial year
					point_score = Oblix_CalculatorLogic.getCountryBoxCalculator().getPointScore(box_number, project.Financial_Year__r.Financial_Year__c
						, project_split.OblixCountry__r.Name.toUpperCase());

					total_fee += Oblix_CalculatorLogic.calculateFeeBySplitAndPointScore(point_score, project_split.Percentage__c);
				}
			}

				system.assertEquals(total_fee, midd_project_total_fee.get(campaign_id),  'expecting ' + total_fee + ' as total campaign score actual was' + midd_project_total_fee.get(campaign_id));
		}
	}



	private static testMethod void checkTotalCampaignFees(){
		
		initialiseTestClass();

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

		Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(1,20,5,mSow.Id,'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');

		Oblix_SOW_Projects__c project = map_campaigns_to_test.values()[0];


		List<Oblix_Project_Assets__c> list_assets_in_basket = new List<Oblix_Project_Assets__c>();
		list_assets_in_basket.addAll(project.Agency_Project_Assets__r);

		List<Oblix_AssetOfferingWrapper.AssetWrapper> list_asset_wrappers = Oblix_AssetOfferingWrapper.convertAssetsToItemsInBasket(list_assets_in_basket);


		// ***********************************************************************************************
		// 		TEST TOTAL CAMPAIGN FEE
		// ***********************************************************************************************
		
		Map<Id, Double> midd_project_total_fee = Oblix_CalculatorLogic.getCampaignFee(map_campaigns_to_test, list_asset_wrappers, true, true, true, Oblix_Utils.TOTAL_PROJECT_SCORE_CFY_FILED);

		system.assert(midd_project_total_fee.values()[0] > 0,  'expecting total campaign fees to be greater than zero');
	}



	//private static testMethod void check(){
		
	//	initialiseTestClass();

	//	Oblix_CalculatorLogic.getCalculatorRecords();

 //       MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

 //       Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);


	//	Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(5,10,5,mSow.Id);

 //       // Brand_Led_Growth__c: Total turnover €300-€400m = 0.45
 //       // Project_Scale_1__c: Multiple countries (5-10), multiple language (5-10) = 0.35
 //       // Project_Scale_2__c: Up to 4 locations = 0.25
 //       // Campaign_Idea__c: Existing = 0.6

	//	Map<Id, Decimal> map_campaign_fee = Oblix_CalculatorLogic.calculateTotalAssetScore(map_campaigns_to_test);

	//	// all campaigns should have the same fee 
	//	for (Id campaign_id : map_campaigns_to_test.keySet()){
	//		system.assertEquals(map_campaign_fee.get(campaign_id), 1.65);
			
	//	}	

	//}


}