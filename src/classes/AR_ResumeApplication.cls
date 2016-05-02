public with sharing class AR_ResumeApplication {
	
	public string email {get;set;}
	public string uniqueKey {get;set;}
	
	public AR_ResumeApplication(){}
	
	public PageReference continueApplication(){
		
		if (email == null || email == '')
		{
			addErrorMessage('Please enter an email address.');
		}
		if (uniqueKey == null || uniqueKey == '')
		{
			addErrorMessage('Please enter your unique key.');
		}
		
		if (ApexPages.hasMessages())
		{
			system.debug(logginglevel.info, 'ApexPage has messages.');
			return null;
		}
		
		try 
		{
			ar_Application__c app = [Select Id, Status__c, Cannot_reapply_until__c From ar_Application__c Where Id = :uniqueKey and Email__c = :email];
			
			if (app.Status__c == 'Initial Review' || app.Status__c == 'Final Review')
			{
				addErrorMessage('Your application is locked and currently under review at Unilever. Please contact Unilever for any updates.');
				return null;
			}
			
			if (app.Status__c == 'Approved')
			{
				addErrorMessage('Your application has been submitted and approved. You should now access your account through the rostered agency login at http://agency.unilever.com/AR_Login');
				return null;
			}
			
			if (app.Status__c == 'Rejected' && app.Cannot_reapply_until__c >= system.today())
			{
				addErrorMessage('Your application has been previously rejected and you cannot reapply until ' + string.valueOf(app.Cannot_reapply_until__c).left(10) + '. Please contact Unilever for any questions.');
				return null;
			}
			
			AR_SessionHandler.SetCookie(app.Id);
			return Page.AR_SupplierCode;
		} 
		catch (Exception ex)
		{
			addErrorMessage('Your email or unique key was not found, please try again or contact Unilever for assistance.');
			return null;
		}
		
	}
	
	public void addErrorMessage(string message){
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
	}
	
	//*
	//Check Cookie Data returns the ID in the Cookie
	//*
	public PageReference init() {
		if(AR_SessionHandler.GetAgencyId() != null) {
			system.debug(logginglevel.info, 'Cookie found with existing Application info... resuming it...');
			return Page.AR_SupplierCode;
		}
		system.debug(logginglevel.info, 'No Cookie found with existing Application info... asking for Login...');
		return null;
	}

}