public with sharing class Oblix_AssetRedirectController {
	
	String project_id;
	String asset_id;

	public Oblix_AssetRedirectController(ApexPages.StandardSetController  stdListController) {
		project_id = null;
		asset_id = null;

	}

	public Oblix_AssetRedirectController(ApexPages.StandardController stdController) {
		asset_id = stdController.getId();
		if (NULL == project_id && NULL != asset_id){
			try{
				project_id = [SELECT Agency_Projects__c FROM Oblix_Project_Assets__c WHERE Id =: asset_id].Agency_Projects__c;
			}
			catch(Exception ex){
				project_id = '';
			}
		}

	}

	public Boolean hasPermissionToStandardPage{
		get{
			if (Oblix_PermissionHandler.hasSuperUserpermissionSet() || Oblix_PermissionHandler.isSystemAdmin()){
				return true;
			}
			else{
				return false;
			}
		}
	}


	public PageReference redirectToAsset(){

		if (hasPermissionToStandardPage){
			return null;
		}
		else{
			PageReference pageRef = Page.Oblix_CampaignAddAsset; 
			pageRef.setRedirect(true);
			pageRef.getParameters().put('projectId', project_id);
			pageRef.getParameters().put('assetId', asset_id);
			return pageRef;	
		}
	}

	public PageReference redirectToSwopMain(){

		if (hasPermissionToStandardPage){
			return null;
		}
		else{
			PageReference pageRef = Page.Oblix_SOWMain; 
			pageRef.setRedirect(true);
			return pageRef;	
		}
	}


}