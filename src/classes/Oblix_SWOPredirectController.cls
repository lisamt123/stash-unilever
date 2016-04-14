public with sharing class Oblix_SWOPredirectController {
	
	String swop_id;

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
}