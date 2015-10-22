/**
    About
    -----
    Description: Class Oblix_TR02SubmitSOWForApproval
    Created for: Oblix Unilever Project
    Create date: 09/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : used as a fired class from Trigger  "After Update" on SOW Marketing object, to Submit records for Approvals
                     
            Functionnalities : 
                    
    Update History
    --------------    
*/
public with sharing class Oblix_TR02SubmitSOWForApproval {
	
	public static void SubmitSowForApproval(List<Marketing_SOW__c> lstMarketingTriggered){
		for(Marketing_SOW__c marketing : lstMarketingTriggered){
			 // create the new approval request to submit
	            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
	            req.setComments('Submitted for approval. Please approve.');
	            req.setObjectId(marketing.Id);
	            // submit the approval request for processing
	            Approval.ProcessResult result = Approval.process(req);
	            // display if the reqeust was successful
	            System.debug('Submitted for approval successfully: '+result.isSuccess());
		}
	}
}