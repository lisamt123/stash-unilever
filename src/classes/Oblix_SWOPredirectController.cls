public with sharing class Oblix_SWOPredirectController {
	
	String swop_id;
	public Oblix_SWOPredirectController(ApexPages.StandardController stdController) {
		swop_id = stdController.getId();
	}

	public PageReference redirectToSwop(){
		    PageReference pageRef = new PageReference('/apex/oblix_sowmaindetail?sowId='+swop_id);
            return pageRef;
	}
}