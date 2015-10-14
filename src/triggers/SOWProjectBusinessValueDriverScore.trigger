trigger SOWProjectBusinessValueDriverScore on Oblix_SOW_Projects__c (before insert, before update) {
	
	if(Trigger.isUpdate && Trigger.isBefore){
		List<Oblix_SOW_Projects__c>  lstProjectToFire = new List<Oblix_SOW_Projects__c>();
		
		for(Oblix_SOW_Projects__c project : Trigger.New){
			if(project.Brand_Led_Growth__c  != Trigger.oldMap.get(project.Id).Brand_Led_Growth__c ||
			   project.Innovation_Projects__c  != Trigger.oldMap.get(project.Id).Innovation_Projects__c ||
			   project.Project_Scale_1__c  != Trigger.oldMap.get(project.Id).Project_Scale_1__c ||
			   project.Project_Scale_2__c  != Trigger.oldMap.get(project.Id).Project_Scale_2__c ||
			   project.Campaign_Idea__c  != Trigger.oldMap.get(project.Id).Campaign_Idea__c 
			){
				lstProjectToFire.add(project);
			}
		}
		if(lstProjectToFire.size()>0) Oblix_TR04ProjectBusinessDriverScore.myMethod(lstProjectToFire);
	}
	
	if(Trigger.isInsert && Trigger.IsBefore){
		List<Oblix_SOW_Projects__c>  lstProjectToFire = new List<Oblix_SOW_Projects__c>();
		
		for(Oblix_SOW_Projects__c project : Trigger.New){
			if(project.Brand_Led_Growth__c != null || project.Innovation_Projects__c != null || project.Project_Scale_1__c != null 
				|| project.Project_Scale_2__c != null || project.Campaign_Idea__c != null){
					lstProjectToFire.add(project);
				}
		}
		if(lstProjectToFire.size()>0) Oblix_TR04ProjectBusinessDriverScore.myMethod(lstProjectToFire);
	}
}