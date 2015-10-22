public with sharing class Oblix_TR03AssetProjectScoreCalculator {
	
	public static void CalculateProjectScore(List<Oblix_Project_Assets__c> lstAsset){
		set<Id> setProjectIds = new set<Id>();
		List<Oblix_SOW_Projects__c> lstProjectAgencies = new List<Oblix_SOW_Projects__c>();
		
		for(Oblix_Project_Assets__c asset : lstAsset){
			setProjectIds.add(asset.Agency_Projects__c);
		}
		lstProjectAgencies = [Select Id, Name, ProjectTotalAssetscore__c, 
				(select Id, Name,Asset_Total_Score__c, Asset_Scoring_Number__c from Agency_Project_Assets__r)  
				from Oblix_SOW_Projects__c where id in :setProjectIds];
		
		if(lstProjectAgencies.size()>0){
			for(Oblix_SOW_Projects__c project : lstProjectAgencies){
				System.debug('###project asset size : '+project.Agency_Project_Assets__r.size());
				if(project.Agency_Project_Assets__r.size()>0){
					Integer tmp_totalassetScoringNumber = 0;
					for(Oblix_Project_Assets__c projectAsset : project.Agency_Project_Assets__r){
						tmp_totalassetScoringNumber += Integer.ValueOf(projectAsset.Asset_Scoring_Number__c);
					}
					project.ProjectTotalAssetScore__c = tmp_totalassetScoringNumber;
				}
			}	
		update lstProjectAgencies;
		}
		
	}
}