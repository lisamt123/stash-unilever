public with sharing class AR_AgencyMyProfile {
	
	public AR_AgencyMyProfile(){}
	
	public Account agency {
		get 
		{
			if (agency == null)
			{
				try
				{
					return [Select 	Id, Name
							From 	Account 
							Where 	Id IN (Select AccountId From User Where Id = :UserInfo.getUserId())];
				}
				catch (Exception ex)
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'There was an error retrieving your agency details.'));
					return null;
				}
			}
			return agency;
		}
		set;
	}

}