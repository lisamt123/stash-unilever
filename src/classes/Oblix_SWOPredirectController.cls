public with sharing class Oblix_SWOPredirectController {
	
	String swop_id;
<<<<<<< HEAD
=======

	public Oblix_SWOPredirectController(ApexPages.StandardSetController  stdListController) {
		swop_id = null;

	}

>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
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
<<<<<<< HEAD
		    PageReference pageRef = new PageReference('/apex/oblix_sowmaindetail?sowId='+swop_id);
            return pageRef;
=======

		if (hasPermissionToStandardPage){
			return null;
		}
		else{
			PageReference pageRef = Page.Oblix_SOWMainDetail; 
			pageRef.setRedirect(true);
			pageRef.getParameters().put('sowId', swop_id);
			return pageRef;	
		}
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
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