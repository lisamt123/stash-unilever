public with sharing class Oblix_Ctrl02OverrideAssetNew {
	
	public Oblix_Project_Assets__c asset {get;set;}
	public Id rt_AudioVisuel {get;set;}
	public Id rt_StaticImagery {get;set;}
	public Id rt_Admin {get;set;}
	public Id rt_Digital {get;set;}
	public Id rt_Experiential {get;set;}
	
	public Id agencyid {get;set;}
	
	public Oblix_Ctrl02OverrideAssetNew(ApexPages.StandardController controller){
		 if(!System.Test.isRunningTest()){
		 	 controller.addFields(new List<String>{'Sub_Category__c', 'Asset_Type__c'});
		 }
		
		 this.asset  = (Oblix_Project_Assets__c) controller.getRecord();
		 agencyid = asset.Agency_Projects__c;
		 rt_AudioVisuel = Oblix_Utils.MapRecordType('Oblix_Project_Assets__c').get('Audio_Visual'); 
			rt_StaticImagery = Oblix_Utils.MapRecordType('Oblix_Project_Assets__c').get('Static_Imagery');
			rt_Admin = Oblix_Utils.MapRecordType('Oblix_Project_Assets__c').get('Admin');
			rt_Digital = Oblix_Utils.MapRecordType('Oblix_Project_Assets__c').get('Digital');
			rt_Experiential = Oblix_Utils.MapRecordType('Oblix_Project_Assets__c').get('Experiential');
				
		 if(asset == null || asset.Id == null){
		 	
		 	
		 	if(ApexPages.currentPage().getParameters().get('RecordType') != null){
		 		 asset = (Oblix_Project_Assets__c)Oblix_Project_Assets__c.sObjectType.newSObject(ApexPages.currentPage().getParameters().get('RecordType'), true) ;
		 		asset.Agency_Projects__c = agencyid;
		 	}
		 	System.debug('###ASSET : '+asset);
		 	//projectId = ApexPages.currentPage().getParameters().get('projectID');
		 	//if(projectId != null) asset.Agency_Projects__c = projectId;
		 	
		 }else{
		 	
		 	asset = [Select Id, Name, Asset_Type__c, Sub_Category__c, Agency_Projects__c, RecordTypeId,
		 			Quantity__c, Channels__c, Location__c, FULL_Description__c, Additional_Description__c
		 				from Oblix_Project_Assets__c where Id =: ApexPAges.currentPage().getParameters().get('Id')
		 			];
		 				
		 }
		 	
		 
		 
	}
	
}