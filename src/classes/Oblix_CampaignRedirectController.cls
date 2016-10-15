public with sharing class Oblix_CampaignRedirectController {
	
	String campaign_id;

	public Oblix_CampaignRedirectController(ApexPages.StandardSetController  stdListController) {
		campaign_id = null;

	}

	public Oblix_CampaignRedirectController(ApexPages.StandardController stdController) {
		campaign_id = stdController.getId();

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


	public PageReference redirectToCampaign(){

		if (hasPermissionToStandardPage){
			return null;
		}
		else{
			PageReference pageRef = Page.Oblix_CampaignSummary; 
			pageRef.setRedirect(true);
			pageRef.getParameters().put('projectId', campaign_id);
			return pageRef;	
		}
	}

	public PageReference redirectToCampaignMain(){

		if (hasPermissionToStandardPage){
			return null;
		}
		else{
			PageReference pageRef = Page.Oblix_CampaignSummary; 
			pageRef.setRedirect(true);
			return pageRef;	
		}
	}


}