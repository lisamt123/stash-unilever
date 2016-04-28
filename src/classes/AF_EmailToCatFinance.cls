/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_EmailToCatFinance
@CreateDate : 22/9/2014
@Description : This controller class is used to send emails to category finance based on the status
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_EmailToCatFinance 
{
	List<AF_Brand_Estimate__c> lstBrandEstimate=new list<AF_Brand_Estimate__c>();
	private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
	public AF_EmailToCatFinance()
	{
		string year_url=ApexPages.CurrentPage().getParameters().get(AF_Constants.YEAR);
		lstBrandEstimate=[SELECT Id,name,AF_Fiscal_Year__c,Brand__r.Name,AF_Notified_To_CatFinance__c FROM AF_Brand_Estimate__c WHERE AF_Status_Base_Fees__c = :AF_Constants.BASE_FEES_INITIATE AND AF_Active__c = true AND AF_Locked__c = false AND AF_Created_By_Batch__c = true AND AF_Notified_To_CatFinance__c = false AND AF_Fiscal_Year__c =:year_url];
		if(lstBrandEstimate.size()==0)
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,Label.AF_No_Records_To_Notify));
	}
	public boolean displayPopup {get; set;}
	/***********************************************************************************
*  @Description: this method will confirm email based on the permission set
*  @name : confirm
*  @param : none.
*  @return: none.
*************************************************************************************/
	public PageReference confirm() 
	{       
		if(lstBrandEstimate.size()>0)
		{        
			Map<string,string> mapusers=new Map<string,string>();
			List<PermissionSetAssignment> permissionSetAssign=[SELECT Assignee.email,Assignee.name,Id,PermissionSetId FROM PermissionSetAssignment where PermissionSet.name=:AF_Constants.PERM_FINANCE_CAT];
			if(permissionSetAssign.size()>0)
			{
				for(PermissionSetAssignment assignment : permissionSetAssign)
				{
					mapusers.put(assignment.Assignee.email,assignment.Assignee.name);
				}
			}
			mapusers.put('yamunayarlagadda@gmail.com','Yamuna Yarlagadda');
			if(!mapusers.isempty())
			{
				list<AF_Brand_Estimate__c> BrandEstimates=new list<AF_Brand_Estimate__c>();
				string strbody='';
				strbody+='<p>Creative agency fee estimates are required to be entered in the tool for "2014" financial year. Please log into the Agency Fees application, using the link below, and enter your overall estimate for Brand Beverages';
				for(AF_Brand_Estimate__c AFB:lstBrandEstimate)
				{
					AFB.AF_Notified_To_CatFinance__c=true;
					BrandEstimates.add(AFB);
					strbody+=', '+AFB.Brand__r.Name+'';
				}
				strbody+='</p>';
				list<Messaging.SingleEmailMessage> emailslist=new list<Messaging.SingleEmailMessage>();
				for(string str: mapusers.keyset())
				{
					List<String> lstEmail=new List<String>();
					lstEmail.add(str);
					string headdr='Dear '+mapusers.get(str)+'<br/>';
					headdr+=strbody+'<br/><br/>';
					headdr+='From<br/><br/>CMCO Finance';
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;                    
					mail.setToAddresses(lstEmail) ;
					mail.setSubject('Agency Fees alignment process for the current financial year');         
					mail.setHtmlBody(headdr);
					emailslist.add(mail);
				}
				if(!emailslist.isempty() && !Test.isRunningTest())
				{     
					Messaging.sendEmail(emailslist);
				}
				try{
				update BrandEstimates;
				displayPopup =true;
				}
				catch(Exception e)
				{
					AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'confirm',e.getMessage(),e.getTypeName(),e.getStackTraceString());
					apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
				}
			}
		}
		Else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,Label.AF_No_Records_To_Notify));
		}
		return null;
	}
	/***********************************************************************************
*  @Description: this method will close the displaypopup
*  @name : closePopup
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void closePopup() 
	{ 
		displayPopup = false;    
	}
}