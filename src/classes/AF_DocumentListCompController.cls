/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_DocumentListCompController
@CreateDate : 5/6/2014
@Description : This is a controller class for Matrix Pages, 
@			  this is used to enter documents upload.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_DocumentListCompController{
	public String ParentRecordId {get;set;}
	public String ParentObjectType {get;set;}
	public Boolean IsDisplayed {get;set;}
	public string IsViewAll{get;set;}
	public boolean isAgencyFlag{get;set;} //to check wether logged in user is partner user or not
	public List<Attachment> DocumentsList {get;set;}
	public Attachment DocumentRecord {get;set;}
	public List<CustomException> ErrorCollection {get;set;}
	public Boolean IsViewAllLink{get;set;}
	public String docId{get;set;}
	public AF_Brand_Estimate__c brandEstRecord{get;set;}
	public AF_OOPS_Actual__c oopsRecord{get;set;}
	public AF_Bonus_Summary__c bonusRecord{get;set;}
	public Boolean status{get;set;}
	private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_DocumentListCompController
*  @param : none
*  @return : none
*************************************************************************/ 	
	public AF_DocumentListCompController()
	{
		User userObj = new User();
		status = false;
		brandEstRecord = new AF_Brand_Estimate__c();
		userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
		if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
			isAgencyFlag=true;
		}              
		if(ApexPages.currentPage().getParameters().get('id') != null)
		{
			DocumentRecord= new Attachment();
			ErrorCollection = new List<CustomException>();
		}
	}
	/***********************************************************************************
*  @Description: this method is used to get and display the documents in the page
*  @name : getAttachmentList
*  @param : none
*  @return: List of Attachment.
*************************************************************************************/
	public List<Attachment> getAttachmentList()
	{
		List<Attachment> docs = new List<Attachment>();
		if(IsViewAll=='true'){
			docs = [select name,description,contenttype,Owner.name,LastModifiedDate from attachment where ParentId =:ParentRecordId ORDER BY CreatedDate DESC];
			if(docs.size() > 0){IsDisplayed = true;}
			IsViewAllLink = false;
		}
		else{
			docs = [select name,description,contenttype,Owner.name,LastModifiedDate from attachment where ParentId =:ParentRecordId ORDER BY CreatedDate DESC Limit 5];
			IsViewAllLink = true;
		}
		if(ParentRecordId.startsWith(System.Label.AF_BrandEstimateId)){
			brandEstRecord = [select AF_Status_Base_Fees__c from AF_Brand_Estimate__c where id=:ParentRecordId];
			if(brandEstRecord.AF_Status_Base_Fees__c == AF_Constants.BASE_FEES_READYFORPO){
				status = true;
			}
		}
		else if(ParentRecordId.startsWith(System.Label.AF_oopsActualId)){
			oopsRecord = [select AF_Status__c from AF_OOPS_Actual__c where id=:ParentRecordId];
			if(oopsRecord.AF_Status__c == AF_Constants.BASE_FEES_READYFORPO){
				status = true;
			}
		}
		else if(ParentRecordId.startsWith(System.Label.AF_BonusSummaryId)){
			bonusRecord = [select AF_Status__c from AF_Bonus_Summary__c where id=:ParentRecordId];
			if(bonusRecord.AF_Status__c == AF_Constants.BASE_FEES_READYFORPO){
				status = true;
			}
		}
		return docs ;
	}
	/***********************************************************************************
*  @Description: this method is used to delete the uploaded documents
*  @name : delDocument
*  @param : none
*  @return: none.
*************************************************************************************/
	public void delDocument(){
		if(docId != ''){
			Attachment docDel = new Attachment();
			docDel = [select Id from Attachment where Id=:docId and ParentId =:ParentRecordId];
			try{
			delete docDel;
			}
			catch(Exception e)
			{
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'delDocument',e.getMessage(),e.getTypeName(),e.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
			}
		}
	}
	public class CustomException extends Exception {}    
}