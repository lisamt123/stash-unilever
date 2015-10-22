trigger SowAssetToProjectCalculator on Oblix_Project_Assets__c (after insert, after update, after delete) {
	//Fire the trigger on After insert to calculate Project Score Asset
	if(Trigger.isInsert && Trigger.isAfter){
		if(!Trigger.New.isempty()) Oblix_TR03AssetProjectScoreCalculator.CalculateProjectScore(Trigger.New);
	}
	//Fire the trigger on After Update to calculate Project Score Asset
	if(Trigger.isUpdate && Trigger.isAfter){
		List<Oblix_Project_Assets__c> lstAssetTrigger = new List<Oblix_Project_Assets__c>();
		for(Oblix_Project_Assets__c asset : Trigger.New){
			if(asset.FULL_Description__c != Trigger.oldMap.get(asset.Id).FULL_Description__c){
				lstAssetTrigger.add(asset);
			}
		}
		if(lstAssetTrigger.size()>0) Oblix_TR03AssetProjectScoreCalculator.CalculateProjectScore(lstAssetTrigger);
	}
	//Fire the trigger on After Delete to re-calculate Project Score Asset
	if(Trigger.isDelete && Trigger.isAfter){
		if(!Trigger.Old.isempty()) Oblix_TR03AssetProjectScoreCalculator.CalculateProjectScore(Trigger.old);
	}
}