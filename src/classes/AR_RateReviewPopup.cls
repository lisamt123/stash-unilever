public with sharing class AR_RateReviewPopup {
	
	public String theAgencyId { get;set; }
	
	public AR_RateReviewPopup() 
	{ 
		rateReview = new ar_Rating_Review__c();
	}
	
	public ar_Rating_Review__c rateReview { get;set; }
	
	public Account agency {
		get {
			if (agency == null)
			{
				try
				{
					agency = [Select	Id, Name
							 From	Account
							 Where	Id = :theAgencyId];
				}
				catch (Exception ex)
				{
					ApexPages.addMessages(ex);
					return null;
				}
			}
			return agency;
		}
		set;
	}
	
	public PageReference saveReview(){
		try 
		{
			rateReview.Agency__c = theAgencyId;
			insert rateReview;
			PageReference pageRef = new PageReference('/apex/AR_AgencyDetail?id=' + theAgencyId);
			pageRef.setRedirect(true);
			return pageRef;
		}
		catch (Exception ex)
		{
			ApexPages.addMessages(ex);
			return null;
		}
	}

}