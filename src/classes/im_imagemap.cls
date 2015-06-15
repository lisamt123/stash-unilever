/*
This is related to a Proof of Concept - Mock up. 
https://c.cs17.visual.force.com/apex/issuebriefingcentre.
Everytime you click on an the map/heat points it opens the following page. 
My guess is this is to be dynamic in the future.

*/

public class im_imagemap {

	/**
		returns a page reference with the issue url
		@return PageReference : Page Reference for the issue.
	**/
    public PageReference submit() {
    	cp_System_Settings__c sysSetting = cp_System_Settings__c.getInstance();
		String instance = (sysSetting != null && sysSetting.Salesforce_Instance__c != null) ? sysSetting.Salesforce_Instance__c : '';
		String recordId = (sysSetting != null && sysSetting.Issue_id_for__c != null) ? sysSetting.Issue_id_for__c : '';
		return new PageReference(instance + '/' + recordId);
    }

}