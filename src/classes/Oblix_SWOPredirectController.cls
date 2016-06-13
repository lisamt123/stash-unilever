public with sharing class Oblix_SWOPredirectController {
	
	String swop_id;

	public Oblix_SWOPredirectController(ApexPages.StandardSetController  stdListController) {
		swop_id = null;

	}

	public Oblix_SWOPredirectController(ApexPages.StandardController stdController) {
		swop_id = stdController.getId();

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


	public PageReference redirectToSwop(){

		if (hasPermissionToStandardPage){
			return null;
		}
		else{
			PageReference pageRef = Page.Oblix_SOWMainDetail; 
			pageRef.setRedirect(true);
			pageRef.getParameters().put('sowId', swop_id);
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