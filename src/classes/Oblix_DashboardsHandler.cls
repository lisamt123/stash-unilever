public with sharing class Oblix_DashboardsHandler {

	public enum Type {SOW_SCORES, CAMPAIGN_ASSET_TYPES}
	public final String SCORE_S = 'S';
	public final String SCORE_SM = 'S/M';
	public final String SCORE_M = 'M';
	public final String SCORE_ML = 'M/L';
	public final String SCORE_L = 'L';
	public final String SCORE_TOTAL = 'TOTAL';

	public String graphData {
		get{
			if(graphData == null){
				graphData = JSON.serialize(generateGraphData());
			}
			return graphData;
		}
		set;
	}

	private Id recordId;
	private Type instanceType;

	public Oblix_DashboardsHandler(Type pInstanceType, Id pRecordId) {

		this.instanceType = pInstanceType;
		this.recordId = pRecordId;

	}

	private List<List<Object>> generateGraphData(){
		if(instanceType != null && instanceType.equals(Type.SOW_SCORES)){
			return generateSOWScoresGraphData();
		} else if(instanceType != null && instanceType.equals(Type.CAMPAIGN_ASSET_TYPES)){
			return null;//generateCampaignAssetTypesData();
		} else {
			return null;
		}
	}

	private List<List<Object>> generateSOWScoresGraphData(){
		List<List<Object>> retVal = new List<List<Object>>();

		// first array for google chart is data header setup
		List<DataSetupHeader> headerSetup = new List<DataSetupHeader>();
		headerSetup.add(new DataSetupHeader('', 'string'));
		headerSetup.add(new DataSetupHeader('Project Count', 'number'));
		headerSetup.add(new DataSetupHeader('Fee', 'number'));

		retVal.add(headerSetup);

		// calculate aggregates for actual data that will be displayed
		List<AggregateResult> scoresDistribution = [SELECT count(Id) num, Brand_Led_Growth__c FROM Oblix_SOW_Projects__c WHERE Financial_Year__c =: recordId GROUP BY Brand_Led_Growth__c LIMIT 1000000];
		List<AggregateResult> feeDistribution = [SELECT SUM(Value_to_be_paid_in_Current_FY__c) amount, Brand_Led_Growth__c FROM Oblix_SOW_Projects__c WHERE Financial_Year__c =: recordId GROUP BY Brand_Led_Growth__c LIMIT 1000000];

		Map<String, Decimal> scoreCountMap = new Map<String, Decimal>();
		Decimal total = 0;
		for(AggregateResult ar : scoresDistribution){
			scoreCountMap.put((String) ar.get('Brand_Led_Growth__c'), (Decimal) ar.get('num'));
			total += (Decimal) ar.get('num');
		}
		scoreCountMap.put(SCORE_TOTAL, total);
		total = 0;
		
		Map<String, Decimal> scoreFeeMap = new Map<String, Decimal>();
		for(AggregateResult ar : feeDistribution){
			scoreFeeMap.put((String) ar.get('Brand_Led_Growth__c'), ((Decimal) ar.get('amount')));
			total += ((Decimal) ar.get('amount'));
		}
		scoreFeeMap.put(SCORE_TOTAL, total);
		

		if(scoreCountMap.get(SCORE_TOTAL) != 0){
			scoreCountMap.put(SCORE_S, Math.round((100 * ((getScoreTotal(scoreCountMap, Oblix_Utils.TOTAL_TURNOVER_LT_100) + getScoreTotal(scoreCountMap, Oblix_Utils.INCREMENTAL_TURNOVER_LT_10))) / scoreCountMap.get(SCORE_TOTAL))));
			scoreCountMap.put(SCORE_SM, Math.round((100 * ((getScoreTotal(scoreCountMap, Oblix_Utils.TOTAL_TURNOVER_100_200) + getScoreTotal(scoreCountMap, Oblix_Utils.INCREMENTAL_TURNOVER_10_20))) / scoreCountMap.get(SCORE_TOTAL))));
			scoreCountMap.put(SCORE_M, Math.round((100 * ((getScoreTotal(scoreCountMap, Oblix_Utils.TOTAL_TURNOVER_200_300) + getScoreTotal(scoreCountMap, Oblix_Utils.INCREMENTAL_TURNOVER_20_30))) / scoreCountMap.get(SCORE_TOTAL))));
			scoreCountMap.put(SCORE_ML, Math.round((100 * ((getScoreTotal(scoreCountMap, Oblix_Utils.TOTAL_TURNOVER_300_400) + getScoreTotal(scoreCountMap, Oblix_Utils.INCREMENTAL_TURNOVER_30_40))) / scoreCountMap.get(SCORE_TOTAL))));
			scoreCountMap.put(SCORE_L, Math.round((100 * ((getScoreTotal(scoreCountMap, Oblix_Utils.TOTAL_TURNOVER_GT_400) + getScoreTotal(scoreCountMap, Oblix_Utils.INCREMENTAL_TURNOVER_GT_40))) / scoreCountMap.get(SCORE_TOTAL))));
		} else {
			scoreCountMap.put(SCORE_S, 0);
			scoreCountMap.put(SCORE_SM, 0);
			scoreCountMap.put(SCORE_M, 0);
			scoreCountMap.put(SCORE_ML, 0);
			scoreCountMap.put(SCORE_L, 0);
		}

		if(scoreFeeMap.get(SCORE_TOTAL) != 0){
			scoreFeeMap.put(SCORE_S, Math.round((100 * ((getScoreTotal(scoreFeeMap, Oblix_Utils.TOTAL_TURNOVER_LT_100) + getScoreTotal(scoreFeeMap, Oblix_Utils.INCREMENTAL_TURNOVER_LT_10))) / scoreFeeMap.get(SCORE_TOTAL))));
			scoreFeeMap.put(SCORE_SM, Math.round((100 * ((getScoreTotal(scoreFeeMap, Oblix_Utils.TOTAL_TURNOVER_100_200) + getScoreTotal(scoreFeeMap, Oblix_Utils.INCREMENTAL_TURNOVER_10_20))) / scoreFeeMap.get(SCORE_TOTAL))));
			scoreFeeMap.put(SCORE_M, Math.round((100 * ((getScoreTotal(scoreFeeMap, Oblix_Utils.TOTAL_TURNOVER_200_300) + getScoreTotal(scoreFeeMap, Oblix_Utils.INCREMENTAL_TURNOVER_20_30))) / scoreFeeMap.get(SCORE_TOTAL))));
			scoreFeeMap.put(SCORE_ML, Math.round((100 * ((getScoreTotal(scoreFeeMap, Oblix_Utils.TOTAL_TURNOVER_300_400) + getScoreTotal(scoreFeeMap, Oblix_Utils.INCREMENTAL_TURNOVER_30_40))) / scoreFeeMap.get(SCORE_TOTAL))));
			scoreFeeMap.put(SCORE_L, Math.round((100 * ((getScoreTotal(scoreFeeMap, Oblix_Utils.TOTAL_TURNOVER_GT_400) + getScoreTotal(scoreFeeMap, Oblix_Utils.INCREMENTAL_TURNOVER_GT_40))) / scoreFeeMap.get(SCORE_TOTAL))));
		} else {
			scoreFeeMap.put(SCORE_S, 0);
			scoreFeeMap.put(SCORE_SM, 0);
			scoreFeeMap.put(SCORE_M, 0);
			scoreFeeMap.put(SCORE_ML, 0);
			scoreFeeMap.put(SCORE_L, 0);
		}
		System.debug('####### ' + JSON.serialize(scoreCountMap));
		System.debug('####### ' + JSON.serialize(scoreFeeMap));

		// populate data records and add them to the google chart data
		retVal.add(new List<String>{SCORE_S, String.valueOf(scoreCountMap.get(SCORE_S)), String.valueOf(scoreFeeMap.get(SCORE_S))});
		retVal.add(new List<String>{SCORE_SM, String.valueOf(scoreCountMap.get(SCORE_SM)), String.valueOf(scoreFeeMap.get(SCORE_SM))});
		retVal.add(new List<String>{SCORE_M, String.valueOf(scoreCountMap.get(SCORE_M)), String.valueOf(scoreFeeMap.get(SCORE_M))});
		retVal.add(new List<String>{SCORE_ML, String.valueOf(scoreCountMap.get(SCORE_ML)), String.valueOf(scoreFeeMap.get(SCORE_ML))});
		retVal.add(new List<String>{SCORE_L, String.valueOf(scoreCountMap.get(SCORE_L)), String.valueOf(scoreFeeMap.get(SCORE_L))});

		return retVal;
	}

	private Decimal getScoreTotal(Map<String, Decimal> distributionMap, String businessValue){
		return distributionMap.containsKey(businessValue) ? distributionMap.get(businessValue) : 0;
	}

	//private List<DataWrapper> generateCampaignAssetTypesData(){
	//	List<DataWrapper> retVal = new List<DataWrapper>();

	//	return retVal;
	//}

	//public class DataWrapper{
	//	public List<Object> googleChartDataSetup {get; set;}
	//	public DataWrapper(){
	//		googleChartDataSetup = new List<Object>();
	//	}
	//	public DataWrapper (List<Object> pGoogleChartDataSetup){
	//		googleChartDataSetup = new List<Object>();
	//		googleChartDataSetup = pGoogleChartDataSetup;
	//	}
	//	public void add(Object googleChartDataSetupRecord){
	//		googleChartDataSetup.add(googleChartDataSetupRecord);
	//	}
	//}
	public class DataSetupHeader{
		public String label;
		public String type;
		public DataSetupHeader(String pLabel, String pType){
			this.label = pLabel;
			this.type = pType;
		}
	}
	//public class DataSetupDataRecord extends DataSetup{
	//	public List<String> dataRecord {get; set;}
	//}
}