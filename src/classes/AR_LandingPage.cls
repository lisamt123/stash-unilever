public with sharing class AR_LandingPage {
	
	public AR_LandingPage() {}
	
	public PageReference init()
	{
		if (UserInfo.getUserType() == 'PowerPartner')
		{
			return Page.AR_AgencyMyProfile;
		}
		return null;
	}
	
	public ar_Agency_Portal_CMS__c content 
	{
		get
		{
			if (content == null)
			{
				try
				{
					content = [Select 	Title__c, Body__c 
								From 	ar_Agency_Portal_CMS__c 
								Where 	Type__c = 'Landing Page' 
									And Published__c = true Limit 1];	
				}
				catch (Exception ex)
				{
					ApexPages.addMessages(ex);
					content = new ar_Agency_Portal_CMS__c();
				}
			}
			return content;
		}
		set;
	}

}