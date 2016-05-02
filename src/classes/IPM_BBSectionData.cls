/*****************************************************************
Created By:Rajesh (Cognizant)
Created Date:14/04/2015
Description:Display the local country feedbacks to contract gate and market ready
Reference:IPM_BBSectionData component
******************************************************************/
Public with sharing class IPM_BBSectionData{
public list<IPM_Financial__c>lstcountryFeedback{get;set;}
public string proid{get;set;}

	public IPM_BBSectionData(){
		proid=ApexPages.currentPage().getParameters().get('Id');
	    lstcountryFeedback=new list<IPM_Financial__c>();
	    IPM_project__c IPMproject=[Select IPMProject_Span__c from IPM_project__c where id=:proid];
	    if(IPMproject.IPMProject_Span__c==IPM_ConstantUtils.Regional) {
	    	lstcountryFeedback=[Select IPM_Country_Feedback__c,Regional_Project__c,Display_Name__c from IPM_Financial__c where (Regional_Project__c=:proid  ) and isActive__c=true and Local_Project__c!=null order by Display_Name__c LIMIT 50000];
		}
	    else {
		    lstcountryFeedback=[Select IPM_Country_Feedback__c,Regional_Project__c,Display_Name__c from IPM_Financial__c where (Regional_Project__r.IPM_Parent_Project__c=:proid ) and isActive__c=true and Local_Project__c!=null order by Display_Name__c LIMIT 50000];
		}
	}
}