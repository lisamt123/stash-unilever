public with sharing class AR_AgencyPortfolioAndInformation {
	
	public AR_AgencyPortfolioAndInformation() {}
	
	public String theAgencyId { get;set; }
	
	// Query required fields and child information
	public Account agency
	{
		get {
			if (agency == null)
			{
				return [Select 	Id, Name, Description, Awards__c, Strategic_Capabilities__c, Overall_Rating__c, Website, Phone, 
								General_Email__c, Vimeo_Link__c, Agency_Contact__c,
								(Select City__c From Geographies__r Order by City__c),
								(Select Number_of_Employees__c From Financials__r Order by Name DESC limit 1),
								(Select Id, Name From Attachments Order By Name)
						From	Account
				Where	Id = :theAgencyId];
			}
			return agency;
		}
		set;
	}
	
	// Build a list of offices, based on the child Geography records against the Agency.
	public String offices 
	{
		get 
		{
			if (offices == null)
			{
				offices = '';
				try 
				{
					for (ar_Geography__c geo :agency.Geographies__r)
					{
						if (geo.City__c != null)
							offices += geo.City__c + ' / ';
					}
					offices = offices.Substring(0, offices.length() - 3);
				} catch (Exception ex)
				{
					ApexPages.addMessages(ex);
				}
			}
			return offices;
		}
		set;
	}
	
	// Calculate the number of employees, based on the latest child Financial record against the agency
	public String numberEmployees 
	{
		get
		{
			if (this.numberEmployees == null)
			{
				this.numberEmployees = '';
				try
				{
					numberEmployees = string.valueOf(agency.Financials__r[0].Number_of_Employees__c) + ' Staff';
				} 
				catch (Exception ex)
				{
					ApexPages.addMessages(ex);
				}
			}
			return numberEmployees;
		}
		set;
	}
	
	public List<ar_Experience__c> projects 
	{
		get
		{
			if (projects == null)
			{
				return [Select		Id, Brand_Competitor__c,
									(Select Id, Name From Attachments Where Name like 'one_%')
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