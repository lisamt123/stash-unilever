/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_EditComment
@CreateDate : 4/7/2014
@Description : This is a controller class is used to edit the comment adn save comments 
@           
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_EditComment
{
	public String ParentId {get;set;}
	public String CommentId {get;set;}
	public String ParentRecordType {get;set;}
	public String ReturnPage {get;set;}
	public AF_Comments__c CommentRecord {get;set;}
	public List<CustomException> ErrorCollection {get;set;}    
	public Boolean IsEdit {get;set;}
	public Boolean IsAdd {get;set;}            
	public Boolean IsDisplayed {get;set;}
	public String ReturnPageURL {get;set;}
	private static string className_STR=AF_EditComment.class.getName();
	/***********************************************************************************
*  @Description: this method is used to query and edit the comments
*  @name : AF_EditComment
*  @param : none
*  @return: none.
*************************************************************************************/  
	public AF_EditComment()
	{
		if(ApexPages.currentPage().getParameters().get('Id') != null)
		{
			CommentId = ApexPages.currentPage().getParameters().get('Id');          
		}
		if(ApexPages.currentPage().getParameters().get('rp') != null)
		{
			ReturnPage = ApexPages.currentPage().getParameters().get('rp');
		}
		ErrorCollection = new List<CustomException>();
		CommentRecord = [Select a.SystemModstamp, a.OwnerName__c, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, a.CreatedDate, a.CreatedById, a.AF_Public__c, a.AF_Parent_Record_Id__c, a.AF_Parent_Object_Type__c, a.AF_Comments__c, a.AF_Bonus__c From AF_Comments__c a where a.Id = : CommentId];   
	}
	/***********************************************************************************
*  @Description: this method is used to query and save the comments
*  @name : SaveComment
*  @param : none
*  @return: none.
*************************************************************************************/  
	public PageReference SaveComment()
	{
		PageReference pageRef = new PageReference(AF_Constants.AGENCY_MATRIX+ReturnPage);
		pageRef.setRedirect(true);                       
		try
		{
			if(CommentRecord.AF_Comments__c.length() > 0)
			{                
				update CommentRecord;                
			}             
		}
		catch(Exception ex)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'SaveComment',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		}
		//return pageRef;
		apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,Label.AF_Updated_successfully));
		return null;
	}                    
	public class CustomException extends Exception {}
}