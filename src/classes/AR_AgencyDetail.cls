public with sharing class AR_AgencyDetail {
	
	//***************************
	//Attributes
	//***************************
	// Query for ratings the logged in user has made
	public ar_Rating_Review__c yourRating { 
		get 
		{
			if (yourRating == null)
			{
				try
				{
					yourRating = [Select 		Id, Clarity_of_Strategy__c, Collaboration_Fit__c, Craft_Execution__c,
													Creativity_Ideas__c, Insight_Foresight__c, Value_for_Money__c, Overall__c
										From 		ar_Rating_Review__c 
										Where 		Agency__c = :agency.Id 
											And 	CreatedById = :UserInfo.getUserId()
										Order By	CreatedDate desc
										Limit	1
										];
				}
				catch (Exception ex) {}
			}
			return yourRating;
		}
		set;
	}
	
	public Account agency { get;set; }
	
	// Specifies which fields on the rating object to count
	private static Set<String> ratingFieldList = new Set<String>{'clarity_of_strategy__c', 'collaboration_fit__c', 'craft_execution__c', 
																'creativity_ideas__c', 'insight_foresight__c', 'value_for_money__c'};

	// Map for getting the crowd scores for each rating criteria against an agency
	public Map<String, CrowdRating> crowdRatingMap {
		get 
		{
			if (crowdRatingMap == null)
			{
				crowdRatingMap = new Map<String, CrowdRating>();
				
				// Loop through all fields on the rating object
				for (String fieldName :Schema.SObjectType.ar_Rating_Review__c.Fields.getMap().keyset())
				{
					// Only do fields included in the ratingFieldList set
					if (ratingFieldList.contains(fieldName.toLowerCase()))
					{
						// Instantiate new CrowdRating class. Set scores to 0
						CrowdRating crowdRating = new CrowdRating();
						crowdRating.ratingScore = 0;
						crowdRating.ratingCount = 0;
						integer totalScore = 0;
						
						// Loop through objects and start counting ratings
						for (sObject rating :agency.Ratings__r)
						{
							if (rating.get(fieldName) != null && rating.get(fieldName) != 0)
							{
								totalScore = totalScore + integer.valueOf(rating.get(fieldName));
								crowdRating.ratingCount++;
							}
							
						}
						// Get the average score, put into map
						if (crowdRating.ratingCount > 0) crowdRating.ratingScore = totalScore / crowdRating.ratingCount;
						crowdRatingMap.put(fieldName, crowdRating);
					}
				}
			}
			return crowdRatingMap;
		}
		set;
	}
	
	public class CrowdRating {
		public integer ratingScore { get;set; }
		public integer ratingCount { get;set; }
	}
	
	// Query for similar agencies. A similar agency is one that includes the same Agency Expertise
	// as the current agency
	public List<Account> similarAgencies {
		get 
		{
			if (similarAgencies == null)
			{
				if (agency.Agency_Expertise__c != null)
				{
					string similarAgencyQuery = 
						' Select 	Id, Name, Description, Strategic_Capabilities__c, Overall_Rating__c, ' +
						'			(Select Id From Attachments Where Name like \'three_%\'), ' +
						'			(Select Id From Ratings__r) ' +
						' From 		Account ' +
						' Where 	Id != \'' + agency.Id + '\'' +
						' 	And		Published__c = true ' + 
						' 	And		Agency_Expertise__c includes (';
						
					List<String> agencyExpertise = agency.Agency_Expertise__c.split(';');
					for (Integer i = 0; i < agencyExpertise.size(); i++)
					{
						if (i == 0)  similarAgencyQuery += '\'' + agencyExpertise[i] + '\'';
						else		similarAgencyQuery += ',\'' + agencyExpertise[i]  + '\'';
					}
					similarAgencyQuery += ') Limit 4';
					similarAgencies = database.query(similarAgencyQuery);
				}
				else
				{
					similarAgencies = new List<Account>();
				}
			}
			return similarAgencies;
		}
		set;
	}
	
	//***************************
	//Variables
	//***************************
	
	//***************************
	//Constructor
	//***************************
	public AR_AgencyDetail(ApexPages.StandardController controller)
	{
		try {
			agency = getAccountAndChildren();
		} 
		catch (Exception ex)
		{
			ApexPages.addMessages(ex);
		}
	}
	
	//***************************
	//Methods
	//***************************
	
	// Single query to retreive the account information and all required child details
	private Account getAccountAndChildren(){
		if (agency == null)
		{
			agency =  [Select 	Id, Agency_Expertise__c,
								(Select City__c From Geographies__r Order by City__c),
								(Select Number_of_Employees__c From Financials__r Order by Name DESC limit 1),
								(Select CreatedById, CreatedDate, CreatedBy.Name, CreatedBy.SmallPhotoUrl, Overall__c, Clarity_of_Strategy__c, Collaboration_Fit__c, Craft_Execution__c,
									Creativity_Ideas__c, Insight_Foresight__c, Value_for_Money__c, Review__c From Ratings__r Order By CreatedDate desc)
							From	Account
						Where	Id = :ApexPages.currentPage().getParameters().get('id')];
		}
		return agency;
	}
}