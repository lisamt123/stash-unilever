/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimateStdCtrlExt
@CreateDate :27/6/2014
@Description : This is a controller class for AF_BrandEstimateStdCtrlExt, 
@			  this is used to display the brandestimate inputs to the users based on their Usertype
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_BrandEstimateStdCtrlExt {
	//Members
	public String agencyId{get;set;}
	public String ParentId{get;set;}
	public String brandEstimateId {get;set;}
	public Decimal progressValue {get;set;}
	public Decimal progressReviewValue {get;set;}
	public AF_Brand_Estimate__c BrandEstimateObj = new AF_Brand_Estimate__c();
	public String ParentRecordType {get;set;}
	public Boolean noEstimates {get;set;}
	public boolean isAgencyFlag{get;set;} //to check whether logged in user is partner user or not
	public boolean isAgencyFlag1{get;set;}
	public boolean iscmcoAgencyFlag{get;set;}
	private static string className_STR=AF_BrandEstimateStdCtrlExt.class.getName();
	/*************************************************************************************
*  @Description: this constructor method is used to query the users and records from the brandestiamte object
*  @name : AF_BrandEstimateStdCtrlExt
*  @param : none
*  @return: none.
******************************************************************************************/
	public AF_BrandEstimateStdCtrlExt(ApexPages.StandardController stdController) {
		noEstimates = false;
		iscmcoAgencyFlag=false;
		User userObj = new User();
		userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
		if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
			isAgencyFlag=true;
		}
		brandEstimateId = ApexPages.currentPage().getParameters().get('id');
		List<AF_Brand_Estimate__c> brandEstimates = [SELECT AF_Agency__c, Name, AF_ProgressImage__c,AF_ProgressImage_Reviews__c,AF_Category_Finance_Approved__c,AF_No_of_Reviews__c,
		(SELECT AF_Agency_Entity__r.AF_Country__c,AF_Category_Finance_Flag__c,AF_Unilever_Entity__r.Name,AF_Total_Local__c,AF_Total__c,
		AF_isCommentImage__c,AF_IsCrossBorderImage__c
		FROM Agency_Estimates__r) 
		FROM AF_Brand_Estimate__c 
		WHERE Id =:brandEstimateId LIMIT 1];
		for(AF_Brand_Estimate__c  eachBrandEstimate : brandEstimates) {
			BrandEstimateObj = eachBrandEstimate;
			progressValue = eachBrandEstimate.AF_ProgressImage__c;
			progressReviewValue = eachBrandEstimate.AF_ProgressImage_Reviews__c;
			agencyId = BrandEstimateObj.AF_Agency__c;
			if((userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCO_USER||userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER||userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CONTROLLER)&&eachBrandEstimate.AF_No_of_Reviews__c>0)
			iscmcoAgencyFlag=true;
			if((userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCO_USER ||userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CONTROLLER || userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_PROCUREMENT || userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER )&& eachBrandEstimate.AF_No_of_Reviews__c>0){
				isAgencyFlag1=true;
			}
			else
			{
				isAgencyFlag1=false;
			}
			if(eachBrandEstimate.Agency_Estimates__r.size() > 0) {
				noEstimates = true;
			}
		}
	}
	//temp just for demo on 10/07/14
	/***********************************************************************************
*  @Description: this method is used to update the status for brandestimate
*  @name : SetStatus
*  @param : none
*  @return: page reference.
*************************************************************************************/      
	public PageReference SetStatus()
	{           
		PageReference pageRef = new PageReference(AF_Constants.AGENCY_MATRIX + brandEstimateId);        
		pageRef.setRedirect(true);
		try
		{               
			BrandEstimateObj.AF_Status_Base_Fees__c = AF_Constants.BASE_FEES_READYFORPO;
			update BrandEstimateObj;                                       
		}  
		catch(Exception ex) 
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'SetStatus',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
			 apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		}                                                              
		return pageRef;        
	}
}