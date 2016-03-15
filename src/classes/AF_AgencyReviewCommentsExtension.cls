/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_AgencyReviewCommentsExtension
   @CreateDate : 23/6/2014
   @Description : This is a controller class for AF_ControllerReview Page, 
   @			  this is used to the Approval process to CMCO after review.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
public with sharing class AF_AgencyReviewCommentsExtension{
	public AF_Brand_Estimate__c brandEstimate {get; set;}
	public boolean checkReview {get; set;}
	public String controllerReviewId{get;set;}
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_AgencyReviewCommentsExtension
*  @param : ApexPages.StandardController
*  @return : none
*************************************************************************/
	public AF_AgencyReviewCommentsExtension(ApexPages.StandardController stdController) {
		checkReview =true;
		String brandEstimateId = ApexPages.currentPage().getParameters().get('id');
		brandEstimate = [SELECT Name, AF_Status_Base_Fees__c, 
		(SELECT Controller_Group__c, AF_Comment__c,Review_Completed__c
		FROM Controller_Reviews__r) 
		FROM AF_Brand_Estimate__c 
		WHERE Id =:brandEstimateId LIMIT 1];
		for(AF_Controller_Review__c review:brandEstimate.Controller_Reviews__r){
			System.debug(review.Review_Completed__c );
			controllerReviewId = review.Id;
			if(!review.Review_Completed__c)
			checkReview =false;
		}
	}
	/***************************************************************************************
*  @Description: this method is used to submit for the Approval Process to CMCO after review
*  @name : saveControllerReview
*  @param : none
*  @return: PageReference.
*********************************************************************************************/
	public PageReference saveControllerReview(){
		if(checkReview){
			apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.info,' You cannot edit as its in Approval process');
			apexpages.addmessage(msg);
			return null;
		}
		Integer count = 0;
		For(AF_Controller_Review__c review : brandEstimate.Controller_Reviews__r){
			if (review.Review_Completed__c)
			count++;
		}
		try{
			update brandEstimate.Controller_Reviews__r;
			//Check if all reviews have been completed
			if (count == brandEstimate.Controller_Reviews__r.size()){
				brandEstimate.AF_Status_Base_Fees__c = 'With CMCO';
				update brandEstimate;
				Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
				request.setObjectId(brandEstimate.Id);
				request.setComments('Submitted for approval. Please approve.');
				request.setNextApproverIds(new ID[]{UserInfo.getUserId()});
				// submit the approval request for processing
				Approval.ProcessResult result = Approval.process(request);
			}
			apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Confirm,'Record successfully saved');
			apexpages.addmessage(msg); 
		}catch(Exception ex){
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),'AF_AgencyReviewCommentsExtension','saveControllerReview',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
			apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Confirm, 'Reviews Complete');
			apexpages.addmessage(msg);  
		}
		return null;
	}
}