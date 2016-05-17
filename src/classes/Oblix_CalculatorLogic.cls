/*****************************************************************************************
* @author       Execloud ©
* @date         2016-01-06
* @description  Apex class contains the logic for calculating asset score total and fees
*				by the passed on list of Oblix_AssetOfferingWrapper objects
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Execloud ©            	2016-02-19          Created
*
******************************************************************************************/
public without sharing class Oblix_CalculatorLogic {


	private static Map<Id, Decimal> getScoreInnovationBrandGrowth(List<Oblix_SOW_Projects__c> li_projects){

		Map<Id, Decimal> midd_project_innovation_score = new Map<Id,Decimal>();

		for (Oblix_SOW_Projects__c project : li_projects){
			if (NULL != project && NULL != project.Brand_Led_Growth__c && String.isNotBlank(project.Brand_Led_Growth__c)){

				midd_project_innovation_score.put(project.Id, Oblix_Utils.getOblixSettingValue(project.Brand_Led_Growth__c));
			}
		} 

		return midd_project_innovation_score;
	}


	private static Map<Id, Decimal> getScoreInnovationMarket(List<Oblix_SOW_Projects__c> li_projects){

		Map<Id, Decimal> midd_project_market_score = new Map<Id,Decimal>();

		for (Oblix_SOW_Projects__c project : li_projects){
			if (NULL != project && NULL != project.Project_Scale_1__c && String.isNotBlank(project.Project_Scale_1__c)){
				
				midd_project_market_score.put(project.Id, Oblix_Utils.getOblixSettingValue(project.Project_Scale_1__c));
			}
		} 

		return midd_project_market_score;
	}

	private static Map<Id, Decimal> getScoreInnovationHub(List<Oblix_SOW_Projects__c> li_projects){

		Map<Id, Decimal> midd_project_hub_score = new Map<Id,Decimal>();

		for (Oblix_SOW_Projects__c project : li_projects){
			if (NULL != project && NULL != project.Project_Scale_2__c && String.isNotBlank(project.Project_Scale_2__c)){
				
				midd_project_hub_score.put(project.Id, Oblix_Utils.getOblixSettingValue(project.Project_Scale_2__c));
			}
		} 

		return midd_project_hub_score;
	}


	private static Map<Id, Decimal> getScoreInnovationIdea(List<Oblix_SOW_Projects__c> li_projects){

		Map<Id, Decimal> midd_project_idea_score = new Map<Id,Decimal>();

		for (Oblix_SOW_Projects__c project : li_projects){
			if (NULL != project && NULL != project.Campaign_Idea__c && String.isNotBlank(project.Campaign_Idea__c)){
				
				midd_project_idea_score.put(project.Id, Oblix_Utils.getOblixSettingValue(project.Campaign_Idea__c));
			}
		} 

		return midd_project_idea_score;
	}

	public static Map<Id, Decimal> getTotalBusinessDriverScore(Map<Id,Oblix_SOW_Projects__c> map_projects){

		Map<Id, Decimal> midd_project_business_drive_score = new Map<Id, Decimal>();
		
		Map<Id, Decimal> midd_project_innovation_score = getScoreInnovationBrandGrowth(map_projects.values());
		Map<Id, Decimal> midd_project_market_score = getScoreInnovationMarket(map_projects.values());
		Map<Id, Decimal> midd_project_hub_score = getScoreInnovationHub(map_projects.values());
		Map<Id, Decimal> midd_project_idea_score = getScoreInnovationIdea(map_projects.values());

		Decimal total_business_score = 0;
		for (Id id : map_projects.keySet()){
			if (midd_project_innovation_score.containsKey(id) && midd_project_market_score.containsKey(id) 
				&& midd_project_hub_score.containsKey(id) && midd_project_idea_score.containsKey(id)){

				total_business_score = midd_project_innovation_score.get(id) + midd_project_market_score.get(id) + midd_project_hub_score.get(id) + midd_project_idea_score.get(id);
				midd_project_business_drive_score.put(id,total_business_score);
			}

		}
		return midd_project_business_drive_score;
	}

	public static Map<Id, Decimal> getTotalProjectScore(Map<Id, Decimal> map_project_driver_score, Map<Id, Decimal> map_total_asset_score){
		Map<Id, Decimal> midd_project_total_score = new Map<Id, Decimal>();

		Decimal total_project_score = 0;
		Decimal asset_score = 0;

		for (Id id : map_project_driver_score.keySet()){
			
			if (NULL != map_project_driver_score.get(id)){

				asset_score = (NULL!= map_total_asset_score && map_total_asset_score.containsKey(id) && NULL != map_total_asset_score.get(id))
					? map_total_asset_score.get(id)
					: 0;

				total_project_score = (asset_score /100) * map_project_driver_score.get(id);
				midd_project_total_score.put(id, total_project_score);
			}

		}
		return midd_project_total_score;
	}

	public static Map<Id, Decimal> calculateTotalAssetScore(Map<Id, Oblix_SOW_Projects__c> map_projects){

		Map<Id, Decimal> midd_project_asset_total = new Map<Id, Decimal>();
		Decimal basket_score;
		Oblix_SOW_Projects__c campaign_in_scope;


		for (Id campaign_id : map_projects.keySet()){


			basket_score = 0;
			campaign_in_scope = map_projects.get(campaign_id);

			//system.debug('## 1- campaign_id: ' + campaign_id + ' - campaign_in_scope.Agency_Project_Assets__r.size(): ' + campaign_in_scope.Agency_Project_Assets__r.size());
			
			if (NULL != campaign_in_scope && campaign_in_scope.Agency_Project_Assets__r.size() > 0){

				for (Oblix_Project_Assets__c asset : campaign_in_scope.Agency_Project_Assets__r){

					//system.debug('## asset id: ' + asset.id + ' - asset.Asset_Score__c: ' + asset.Asset_Score__c + ' - asset.Quantity__c: ' +  asset.Quantity__c);

					if (NULL != asset.Asset_Score__c && NULL != asset.Quantity__c){
						basket_score += asset.Asset_Score__c * asset.Quantity__c;
					}
				}	
			}
			midd_project_asset_total.put(campaign_id, basket_score);
			
		}

		return midd_project_asset_total;
	}

	public static Map<Id, Decimal> calculateTotalAssetScore(List<Oblix_AssetOfferingWrapper.AssetWrapper> assets_in_basket){

		Map<Id, Decimal> midd_project_asset_total = new Map<Id, Decimal>();

		Decimal basket_score = 0;
		for (Oblix_AssetOfferingWrapper.AssetWrapper asset : assets_in_basket){

			if (NULL != asset.campaign_id){
				// if not added to basket yet set the initial value to 0
				basket_score = NULL != midd_project_asset_total.get(asset.campaign_id)
					? midd_project_asset_total.get(asset.campaign_id)
					: 0;

				basket_score += asset.getPointScoreForQuantity(); 
				midd_project_asset_total.put(asset.campaign_id, basket_score);
			}
		}
		return midd_project_asset_total;
	}

	public static Map<Id, Long> calculateFeeByHubs(Map<Id, Oblix_SOW_Projects__c> map_projects, Map<Id, String> map_campaign_id_box_number){
		Map<Id, Long> midd_project_total_fee = new Map<Id, Long>();

		Oblix_SOW_Projects__c project;
		Decimal point_score = 0;
		Decimal total_fee;
		String box_number ='';

		for (Id project_id : map_projects.keySet()){

			project = map_projects.get(project_id);
			total_fee = 0;


			if (NULL != project && project.Marketing_SOW_Project_Splits__r.size()>0 && map_campaign_id_box_number.containsKey(project_id)
				&& String.isNotBlank(map_campaign_id_box_number.get(project_id))){

				box_number = map_campaign_id_box_number.get(project_id);

				for (Oblix_Marketing_SOW_Project_Splits__c project_split : project.Marketing_SOW_Project_Splits__r){


					// get point score for the given box number and financial year
					point_score = getCountryBoxCalculator().getPointScore(box_number, project.Financial_Year__r.Financial_Year__c
						, project_split.OblixCountry__r.Name.toUpperCase());

					//system.debug('## 3- project_id: ' + project_id + ' - point_score: ' + point_score + ' - Financial_Year__c: ' + project.Financial_Year__r.Financial_Year__c + ' - project_split.OblixCountry__r.Name: '+ project_split.OblixCountry__r.Name);

					if (NULL == point_score){
            			throw new MissingDataException('NO_CALCULATOR_DATA_SPECIFIED for country Name: ' + project_split.OblixCountry__r.Name + ' - Financial Year: ' + project.Financial_Year__r.Financial_Year__c + ' - Project Score: ' + point_score);
					}

					total_fee += calculateFeeBySplitAndPointScore(point_score, project_split.Percentage__c);
				}

				midd_project_total_fee.put(project.Id, (Long)total_fee.round(system.RoundingMode.HALF_EVEN));

			}
			else{
				midd_project_total_fee.put(project.Id, 0);
			}

		}

		return midd_project_total_fee;
	}

	public static Map<Id, String> getBoxNumber(Map<Id, Oblix_SOW_Projects__c> map_projects, Map<Id, Decimal> map_project_total_score){

		Map<Id, String> map_campaign_id_box_number = new Map<Id, String>();
		String box_number ='';
		Oblix_SOW_Projects__c project;
		Decimal project_score;

		for (Id project_id : map_projects.keySet()){
			project_score = 0;
			box_number ='';
			project = map_projects.get(project_id);

			if (NULL != map_project_total_score && map_project_total_score.containsKey(project_id) && NULL != map_project_total_score.get(project_id)){
				project_score = map_project_total_score.get(project_id);
			}

			if (NULL != project && NULL != project.Financial_Year__r.Financial_Year__c && project_score>0){

				//system.debug('## 1- project_id: ' + project_id + ' - project_score: ' + project_score + ' - Financial_Year__c: ' +  project.Financial_Year__r.Financial_Year__c);
				// get the box number for the given project financial year and total project score
				box_number = getFinancialYearCalculator().getBoxNumberAsFieldFormat(project_score, project.Financial_Year__r.Financial_Year__c);

			}
			map_campaign_id_box_number.put(project_id, box_number);
		}

		return map_campaign_id_box_number;
	}

	@TestVisible
	private static Decimal calculateFeeBySplitAndPointScore(Decimal point_score, Decimal split_percentage ){
		
		Decimal fee_for_split = 0;
		if (NULL != point_score && point_score>0 && NULL != split_percentage && split_percentage >0){
			fee_for_split = point_score * split_percentage / 100;
		}

		return fee_for_split;
	}

	public static Map<Id, Long> getCampaignFee(Map<Id, Oblix_SOW_Projects__c> map_projects, List<Oblix_AssetOfferingWrapper.AssetWrapper> assets_in_basket
		, Boolean recalculate_project_driver_score, Boolean recalculate_total_project_score, Boolean recalculate_total_asset_score){

		Map<Id, Long> map_campaign_id_campaign_fee = new Map<Id,Long>();

		Map<Id, Decimal> midd_project_business_drive_score = new Map<Id, Decimal>();
		Map<Id, Decimal> midd_project_total_score = new Map<Id, Decimal>();
		Map<Id, Decimal> midd_project_asset_total = new Map<Id, Decimal>();



		// 1) get project business driver score if requested by parameter
		if (recalculate_project_driver_score){
			// get the totals by calling the total business drivers score method
			midd_project_business_drive_score = getTotalBusinessDriverScore(map_projects);
		}
		else{
			// loop through the passed in campaigns and build a map of campaign id and totals
			for (Id campaign_id : map_projects.keySet()){
				Oblix_SOW_Projects__c project = map_projects.get(campaign_id);

				midd_project_business_drive_score.put(campaign_id, project.Total_Value_Driver__c);
			}
		}


		// 2) get total asset scores if requested by parameter
		if (recalculate_total_asset_score){
			// get the totals by calling total project score method
			midd_project_asset_total = calculateTotalAssetScore(assets_in_basket);
		}
		else{
			// loop through the passed in campaigns and build a map for total asset scores
			for (Id campaign_id : map_projects.keySet()){
				Oblix_SOW_Projects__c project = map_projects.get(campaign_id);

				// get the value from project attribute if already calculated
				midd_project_asset_total.put(campaign_id, project.ProjectTotalAssetscore__c);
			}
		}

		// 3) get total project score if requested by parameter
		if (recalculate_total_project_score){
			// get the totals by calling total project score method
			midd_project_total_score = getTotalProjectScore(midd_project_business_drive_score,midd_project_asset_total);
		}
		else{
			for (Id campaign_id : map_projects.keySet()){
				Oblix_SOW_Projects__c project = map_projects.get(campaign_id);

				// get the value from project attribute if already calculated
				midd_project_total_score.put(campaign_id, project.Total_Project_Score__c);
			}
		}


		// 4) finally get the campaign fee for given campaign total score and related hub and splits
		//		by calling calculateFeeByHubs method
		// 		first get the box number
		Map<Id, String> map_campaign_id_box_number = getBoxNumber(map_projects , midd_project_total_score);
		map_campaign_id_campaign_fee = calculateFeeByHubs(map_projects , map_campaign_id_box_number);

		// return the result
		return map_campaign_id_campaign_fee;
	}


	private static CalculatorRangeWrapper financial_year_calculator;

	public static CalculatorRangeWrapper getFinancialYearCalculator(){

		//Map<Id,Oblix_Calculator__c> map_calculator = getCalculatorRecords();

		if (NULL != financial_year_calculator){
			return financial_year_calculator;
		}
		// check in the cache first
		// Cache.SessionPartition session_partition = Cache.Session.getPartition('OblixCalculator');
		if (Cache.Org.contains('local.Oblix.CalculatorBoxRange')){
			//system.debug('## getting values from cache');
			financial_year_calculator = (CalculatorRangeWrapper) Cache.Org.get('local.Oblix.CalculatorBoxRange');
		}
		else{ 
			//system.debug('## setting values to cache');
			// get box range record types only
			String soql_query = 'SELECT Points_Low__c, Points_High__c, Financial_Year__c, Box_Range__c FROM Oblix_Calculator__c ';
			soql_query += ' WHERE RecordTypeId = \'' + Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Box_Range') + '\'';

			//system.debug('##soql_query: '+soql_query);
			List<Oblix_Calculator__c> oblix_calculator = Database.query(soql_query);
			financial_year_calculator = new CalculatorRangeWrapper(oblix_calculator);
            //Cache.Org.put('local.Oblix.CalculatorBoxRange', financial_year_calculator);
		}

		return financial_year_calculator;

	} 

	// store it as a static to avoid querying it multiple times in the same
	// execution cotext
    private static CalculatorCountryBoxWrapper country_box_calculator;

	public static CalculatorCountryBoxWrapper getCountryBoxCalculator(){

		//Map<Id,Oblix_Calculator__c> map_calculator = getCalculatorRecords();
		//CalculatorCountryBoxWrapper country_box_calculator;

		if (NULL != country_box_calculator){
			return country_box_calculator;
		}

		// check in the cache first
		//Cache.SessionPartition session_partition = Cache.Session.getPartition('OblixCalculator');
		if (Cache.Org.contains('local.Oblix.CalculatorCountryBox')){
			//system.debug('## getting values from cache');
			country_box_calculator = (CalculatorCountryBoxWrapper) Cache.Org.get('local.Oblix.CalculatorCountryBox');
		}
		else{ 
			//system.debug('## setting values to cache');
			// get box range record types only
			String soql_query = 'SELECT ' + String.join(Oblix_Utils.getfieldsByObject('Oblix_Calculator__c'), ',') + ' FROM Oblix_Calculator__c ';
			soql_query += ' WHERE RecordTypeId = \'' + Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Country_Box_Number') + '\'';

			//system.debug('##soql_query: '+soql_query);
			List<Oblix_Calculator__c> oblix_calculator = Database.query(soql_query);
			country_box_calculator = new CalculatorCountryBoxWrapper(oblix_calculator);
            //Cache.Org.put('local.Oblix.CalculatorCountryBox', country_box_calculator);
		}

		return country_box_calculator;

	}

	private static Map<Id,Oblix_Calculator__c> map_calculator;

	public static Map<Id,Oblix_Calculator__c> getCalculatorRecords(){

		// check the map in static variable first
		if (NULL != map_calculator){
			return map_calculator;
		}

		// then check in the cache first
		if (Cache.Org.contains('local.Oblix.calculator')){
			//system.debug('## getting values from cache');
			map_calculator = (Map<Id,Oblix_Calculator__c>) Cache.Org.get('local.Oblix.calculator');
		}
		else{ 
			//system.debug('## setting values to cache');
			List<String> li_fields_to_query = Oblix_Utils.getfieldsByObject('Oblix_Calculator__c');
			String soql_query = 'SELECT ' + String.join(li_fields_to_query, ',') + ' FROM Oblix_Calculator__c';

			map_calculator = new Map<Id, Oblix_Calculator__c>((List<Oblix_Calculator__c>)Database.query(soql_query));
            //Cache.Org.put('local.Oblix.calculator', map_calculator);
		}

		//system.debug(map_calculator);
		return map_calculator;
	}

	public class CalculatorCountryBoxWrapper{
		public Map<String,Oblix_Calculator__c> map_oblix_calculator {get;set;}

		public CalculatorCountryBoxWrapper(List<Oblix_Calculator__c> oblix_calculator){
			map_oblix_calculator = new Map<String,Oblix_Calculator__c>();
			// build calculator key made up of FY + '_' + COUNTRY
			String calculator_key;
			for (Oblix_Calculator__c calc: oblix_calculator){
				calculator_key = buildKey(calc.Financial_Year__c, calc.Name);

				if (String.isNotBlank(calculator_key)){
					map_oblix_calculator.put(calculator_key, calc);
				}
			}
		}


		public Decimal getPointScore(String box_number, String financial_year, String country_name){

			Decimal point_score = 0;
			String calculator_key = buildKey(financial_year, country_name);

			//system.debug('## calculator_key: ' + calculator_key + ' - box_number: ' + box_number + ' - map_oblix_calculator: ' + json.serialize(map_oblix_calculator));

			if (map_oblix_calculator.containsKey(calculator_key) && NULL!= map_oblix_calculator.get(calculator_key) && NULL!=box_number
				&& NULL!=map_oblix_calculator.get(calculator_key).get(box_number)){

				point_score = (Decimal) map_oblix_calculator.get(calculator_key).get(box_number);	
			}

			return point_score;
		}

		private String buildKey(String financial_year, String country_name){
			String calculator_key = '';
			if (String.isNotBlank(financial_year) && String.isNotBlank(country_name)){
				calculator_key = financial_year + '_' + country_name;
			}
			return calculator_key;
		}

	}

	public class CalculatorRangeWrapper{

		public List<CalculatorRecordWrapper> li_calculator_range {get;set;}

		CalculatorRangeWrapper(){}

		CalculatorRangeWrapper(List<Oblix_Calculator__c> oblix_calculator){
			li_calculator_range = new List<CalculatorRecordWrapper>();			
			for (Oblix_Calculator__c calculator : oblix_calculator){
				li_calculator_range.add(new CalculatorRecordWrapper(calculator));
			}
		}

		public String getBoxNumberAsFieldFormat(Decimal score, String financial_year){
			String box_number = getBoxNumber(score, financial_year);

			return formatBoxNumberToField(box_number);
			
		}

		public String getBoxNumber(Decimal score, String financial_year){
			//system.debug('## TESTING: li_calculator_range: ' + json.serialize(li_calculator_range) + ' - score: ' + score + ' - financial_year: ' + financial_year);
			if (!li_calculator_range.isEmpty()){
				for (CalculatorRecordWrapper cal_rec : li_calculator_range){
					if (score > cal_rec.point_low_value && score <= cal_rec.point_high_value && financial_year == cal_rec.financial_year){
						//system.debug('## TESTING: found match: ' + cal_rec.box_range);
						return cal_rec.box_range;
					}
				}
			}
			//system.debug('## TESTING: no match found!');

			// no match found!
			return NULL;
		}

		public String formatBoxNumberToField(String box_number){
			// S.M. had to add this variable to get passed sonar Avoid reassigning parameters issue
			String formatted_box_number = '';

			if (String.isNotBlank(box_number)){
				formatted_box_number = box_number.replace(' ', '_') + '__c';
			}
			return formatted_box_number;
		}
	}

	public class CalculatorRecordWrapper{

		public Decimal point_low_value;
		public Decimal point_high_value;
		public String financial_year;
		public String box_range;

		CalculatorRecordWrapper(Oblix_Calculator__c calculator){
			this.point_low_value = calculator.Points_Low__c;
			this.point_high_value = calculator.Points_High__c;
			this.financial_year = calculator.Financial_Year__c;
			this.box_range = calculator.Box_Range__c;
		}		

	}
    public class MissingDataException extends Exception {}

}