public with sharing class AR_PortfolioPopup {
	
	public String theAgencyId { get;set; }
	
	public AR_PortfolioPopup() {}
	
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
	
	public List<ar_Experience__c> projects 
	{
		get
		{
			if (projects == null)
			{
				projects = [Select		Id, Name, Brand_Competitor__c, Project_Title__c, 
										Outline_of_project__c, Video_Link__c, Links__c, Featured_Quote__c,
										(Select Id, Name From Attachments Limit 4)
							From		ar_Experience__c
							Where		Agency__c = :theAgencyId
								And		RecordType.Name = 'Project'
							Order By	CreatedDate desc
							Limit		4];
			}
			return projects;
		}
		set;
	}

}