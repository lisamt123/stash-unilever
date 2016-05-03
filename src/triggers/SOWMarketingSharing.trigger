trigger SOWMarketingSharing on Marketing_SOW__c (before insert, before update,after insert, after update) {
	TriggerFactory.createHandler(Marketing_SOW__c.sObjectType);
	/*
	if(Trigger.isInsert && Trigger.isBefore){
		List<Marketing_SOW__c> lstMarkBrandCateg = new List<Marketing_SOW__c>();
		for(Marketing_SOW__c markSow : Trigger.New){
			if(markSow.OblixBrand__c != null){
				lstMarkBrandCateg.add(markSow);
			}
		}
		if(lstMarkBrandCateg.size()>0) Oblix_TR06SowMarketBrandPopulate.PopulateBrandCategoriesforSOW(lstMarkBrandCateg);
	}*/
	
	/*
	if(Trigger.isInsert && Trigger.isAfter){
		//Start Sharing Process Part
		List<Marketing_SOW__c> lstMarkBrandCateg = new List<Marketing_SOW__c>();
		for(Marketing_SOW__c markSow : Trigger.New){
			//if(markSow.Brand__c != null || markSow.Big_C__c != null){
				lstMarkBrandCateg.add(markSow);
			//}
		}
		if(lstMarkBrandCateg.size()>0) Oblix_TR01SOWMarkingSharing.sowMarketingSharing(lstMarkBrandCateg);
		//End Sharing Process Part
	}
	
	*/
	/*
	if(Trigger.isUpdate && Trigger.isBefore){
		List<Marketing_SOW__c> lstMarkBrandCateg = new List<Marketing_SOW__c>();
		for(Marketing_SOW__c markSow : Trigger.New){
			if(markSow.OblixBrand__c != Trigger.oldMap.get(markSow.Id).OblixBrand__c){
				lstMarkBrandCateg.add(markSow);
			}
		}
		System.debug('###lstMarkBrandCateg : '+lstMarkBrandCateg);
		if(lstMarkBrandCateg.size()>0) Oblix_TR06SowMarketBrandPopulate.PopulateBrandCategoriesforSOW(lstMarkBrandCateg);
	}
	*/
	/*if (Trigger.isUpdate && Trigger.isAfter) {
	
		//Start Sharing Process Part
		List<Marketing_SOW__c> lstMarkBrandCateg = new List<Marketing_SOW__c>();
		for(Marketing_SOW__c markSow : Trigger.New){
			//if(markSow.Brand__c != null || markSow.Big_C__c != null){
				lstMarkBrandCateg.add(markSow);
			//}
		}
		if(lstMarkBrandCateg.size()>0) Oblix_TR01SOWMarkingSharing.sowMarketingSharing(lstMarkBrandCateg);
		//End Sharing Process Part
	*/
		//Start Approval Process Part
	/*	 List<Marketing_SOW__c> lstSowRecords = new List<Marketing_SOW__c>();
		 for (Integer i = 0; i < Trigger.new.size(); i++) {
        	if (Trigger.old[i].SOW_Status__c != Oblix_Constants.Lbl_SOWSTATUS_AWAITINGAPPROVAL && Trigger.new[i].SOW_Status__c == Oblix_Constants.Lbl_SOWSTATUS_AWAITINGAPPROVAL) {
				lstSowRecords.add(Trigger.new[i]);
        	}
    	 }
    if(lstSowRecords.size()>0) Oblix_TR02SubmitSOWForApproval.SubmitSowForApproval(lstSowRecords);
    //End Aproval Process Part
	}
	*/
	
}