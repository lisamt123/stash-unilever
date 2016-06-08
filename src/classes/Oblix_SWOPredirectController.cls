public with sharing class Oblix_SWOPredirectController {
	
	String swop_id;

	public Oblix_SWOPredirectController(ApexPages.StandardSetController  stdListController) {
		swop_id = null;
	}

	public Oblix_SWOPredirectController(ApexPages.StandardController stdController) {
		swop_id = stdController.getId();
	}

	public PageReference redirectToSwop(){

		if (Oblix_PermissionHandler.hasSuperUserpermissionSet() || Oblix_PermissionHandler.isSystemAdmin()){
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

		if (Oblix_PermissionHandler.hasSuperUserpermissionSet() || Oblix_PermissionHandler.isSystemAdmin()){
			return null;
		}
		else{
			PageReference pageRef = Page.Oblix_SOWMain; 
			return pageRef;	
		}

	}

	public PageReference redirectToSOWEdit(){
		if (Oblix_PermissionHandler.hasSuperUserpermissionSet() || Oblix_PermissionHandler.isSystemAdmin()){
			PageReference pageRef = new ApexPages.StandardController(new Marketing_SOW__c(Id = swop_id)).edit();
			pageRef.getParameters().put('retURL', swop_id);
			return pageRef;
		}
		else{
			PageReference pageRef = Page.Oblix_SOWCreate;
			return pageRef;	
		}
	}
}