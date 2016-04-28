/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_CommentsListCompController
@CreateDate : 25/6/2014
@Description : This is a controller class for AF_CommentsListComp Component, 
@			  this is used to enter comments and display comments in matrix page.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_CommentsListCompController{
	public String ParentRecordId {get;set;}
	public String ParentObjectType {get;set;}
	public String brandvalue1{get;set;}
	public String category1{get;set;}
	public String year1{get;set;}
	public Boolean IsDisplayed {get;set;}
	public string IsViewAll{get;set;}
	public Boolean IsViewAllLink{get;set;}
	public string CommentId{get;set;}
	public string ReturnPageURL{get;set;}
	public string commentValue{get;set;}
	public boolean isAgencyFlag{get;set;} //to check wether logged in user is partner user or not
	public AF_Comments__c CommentRecord {get;set;}
	public List<CustomException> ErrorCollection {get;set;}
	public boolean isCMCOUser{get;set;}  
	public  List<AF_Comments__c> commentsList;
	public Id myCommentId{get;set;}
	public Id myCreateId{get;set;}
	public Boolean bCMCOSuperUser{get;set;}
	public Id LoggedId{get;set;}
	private static string className_STR=AF_CommentsListCompController.class.getName();
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_CommentsListCompController
*  @param : none
*  @return : none
*************************************************************************/
	public AF_CommentsListCompController()
	{   
		isCMCOUser=false;
		bCMCOSuperUser=false;
		LoggedId = UserInfo.getUserId();
		User userObj = new User();
		userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
		if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
			isAgencyFlag=true;
		}
		if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCO_USER){
			isCMCOUser=true;
		}  
		if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER){
			bCMCOSuperUser=true;
		}   
		IsDisplayed = false;        
		if(ApexPages.currentPage().getParameters().get('Id') != null)
		{
			CommentId = ApexPages.currentPage().getParameters().get('Id');          
		}
		ErrorCollection = new List<CustomException>();        
		CommentRecord = new AF_Comments__c();           
	}
	/**********************************************************************
*  @Description: this method get the comments and display in the page
*  @name : getCommentsList
*  @param : none
*  @return: List of AF_Comments__c.
**********************************************************************/  
	public List<AF_Comments__c> getCommentsList()
	{
		List<AF_Comments__c> comments;
		commentsList = new List<AF_Comments__c>();
		IsDisplayed = false;                                
		if(IsViewAll == 'true')
		{
			IsDisplayed = true;
			IsViewAllLink = false;
			comments = [select id, Name, AF_Type__c,AF_Public__c, AF_Parent_Record_Id__c, CreatedById, OwnerName__c, CreatedDate, AF_Comments__c from AF_Comments__c WHERE AF_Parent_Record_Id__c = : ParentRecordId ORDER BY CreatedDate DESC];    
		}
		else
		{
			IsViewAllLink = true;
			comments = [select id, Name, AF_Type__c, AF_Public__c,AF_Parent_Record_Id__c, CreatedById, OwnerName__c, CreatedDate, AF_Comments__c from AF_Comments__c WHERE AF_Parent_Record_Id__c = : ParentRecordId ORDER BY CreatedDate DESC LIMIT 5];    
		} 
		commentsList.addAll(comments);
		return comments;
	}
	/**********************************************************************
*  @Description: this method is used to edit the existing comments
*  @name : EditComment
*  @param : none
*  @return: PageReference.
**********************************************************************/ 
	public PageReference EditComment()
	{
		ReturnPageURL = ParentRecordId;
		PageReference pageRef =  new PageReference(AF_Constants.EDIT_COMMENT);
		pageRef.getParameters().put('Id', CommentId);
		pageRef.getParameters().put('rp', ReturnPageURL);
		pageRef.setRedirect(true);  
		return null;
	}
	/**********************************************************************
*  @Description: this method is used to edit and save the existing comments
*  @name : SaveCommentEdit
*  @param : none
*  @return: none.
**********************************************************************/ 
	public void SaveCommentEdit(){
		integer i=0;
		myCommentId=null;
		for(AF_Comments__c c:commentsList){
			if(c.AF_Comments__c.length() > 0){
				i++;
			}
		}
		if(i==commentsList.size()){
			try{
			update commentsList;
			}
			catch(Exception e)
			{
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'SaveCommentEdit',e.getMessage(),e.getTypeName(),e.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update));
			}
		}
	}
	/**********************************************************************
*  @Description: this method is used to save the existing comments
*  @name : SaveComment
*  @param : none
*  @return: none.
**********************************************************************/ 
	public void SaveComment()
	{
		try
		{
			if(CommentRecord.AF_Comments__c.length() > 0)
			{
				AF_Comments__c recordsToInsert = new AF_Comments__c();
				recordsToInsert.AF_Parent_Record_Id__c = ParentRecordId;
				recordsToInsert.AF_Parent_Object_Type__c = ParentObjectType;
				recordsToInsert.AF_Comments__c = CommentRecord.AF_Comments__c;
				recordsToInsert.AF_Public__c = CommentRecord.AF_Public__c;
				MapToLookups(recordsToInsert);
				insert recordsToInsert;                                
			}             
		}
		catch(Exception ex)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'SaveComment',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert)); 
		}
	}
	/**********************************************************************
*  @Description: this method is used as lookup for the sobject
*  @name : MapToLookups
*  @param : none
*  @return: none.
**********************************************************************/  
	private void MapToLookups(AF_Comments__c pCommentRecord) 
	{
		// this is a helper method that detects ParentObjectType and assign the id to specific looup fields
		if(ParentObjectType == AF_Constants.SOBJECT_BRANDESTIMATE_APINAME){
			pCommentRecord.AF_Brand_Estimate__c = ParentRecordId; 
			UpdateIsCommentOnRecord(AF_Constants.SOBJECT_BRANDESTIMATE_APINAME, ParentRecordId);
		}
		if(ParentObjectType == AF_Constants.SOBJECT_AGENCYESTIMATE_APINAME){
			pCommentRecord.AF_Agency_Estimate__c = ParentRecordId; 
			UpdateIsCommentOnRecord(AF_Constants.SOBJECT_AGENCYESTIMATE_APINAME, ParentRecordId);
		}
		if(ParentObjectType == AF_Constants.SOBJECT_BONUS_SUMMARY_APINAME){
			pCommentRecord.AF_Bonus_Summary__c = ParentRecordId;
		}
		if(ParentObjectType == AF_Constants.SOBJECT_BONUS_MATRIX_APINAME){
			pCommentRecord.AF_Bonus__c = ParentRecordId;
		}
		if(ParentObjectType == AF_Constants.SOBJECT_OOPSESTIMATE_APINAME){
			pCommentRecord.AF_OOPS_Estimate__c = ParentRecordId;
		}        
	}
	/**********************************************************************
*  @Description: this method is used as a check whether comments are entered
*  @name : UpdateIsCommentOnRecord
*  @param : none
*  @return: none.
**********************************************************************/ 
	private void UpdateIsCommentOnRecord(string pObjectType, Id pObjectId)
	{   
		STRING UpdateIsCommentOnRecord='UpdateIsCommentOnRecord';
		if(pObjectType == AF_Constants.SOBJECT_BRANDESTIMATE_APINAME){
			try{
				AF_Brand_Estimate__c objBE    = [select Id, AF_isComment__c from AF_Brand_Estimate__c where Id = : pObjectId];
				if(objBE != null){
					objBE.AF_isComment__c = true; 
					update objBE;
				}
			}catch(DMLException ex){
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,UpdateIsCommentOnRecord,ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
			}
		}
		if(pObjectType == AF_Constants.SOBJECT_AGENCYESTIMATE_APINAME){
			try{ 
				AF_Agency_Estimate__c objAE = [select Id, AF_isComment__c from AF_Agency_Estimate__c where Id = : pObjectId];
				if(objAE != null){
					objAE.AF_isComment__c = true; 
					update objAE;
				}
			}catch(DMLException ex){
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,UpdateIsCommentOnRecord,ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
			}
		}
		if(pObjectType == AF_Constants.SOBJECT_OOPSESTIMATE_APINAME){
			try{AF_OOPS_Estimate__c objOE  = [select Id, AF_isComment__c from AF_OOPS_Estimate__c where Id = : pObjectId];
				if(objOE != null){
					objOE.AF_isComment__c = true; 
					update objOE;
				}
			}catch(DMLException ex){
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,UpdateIsCommentOnRecord,ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
			}
		}        
	}
	public class CustomException extends Exception {}
	/**********************************************************************
*  @Description: this method is used to check the access to edit the comments
*  @name : editCommentByUsers
*  @param : none
*  @return: none.
**********************************************************************/ 	
	public void editCommentByUsers(){
		if(myCreateId!=UserInfo.getUserId() && !bCMCOSuperUser){
			myCommentId=null;
			apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Comment)); 
		}
	}
}