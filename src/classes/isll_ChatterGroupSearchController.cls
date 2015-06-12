public with sharing class isll_ChatterGroupSearchController {
	
	public String searchText {get;set;}
	public List<CollaborationGroup> chatterGroups {get;set;}
	public Integer resultsSize {get;set;}

	public isll_ChatterGroupSearchController() {}

	public void searchGroups()
	{
		if (searchText == null || searchText == '')
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Fatal, 'Please enter a search term.'));
		}
		else
		{
			String querySearchText = '%' + searchText + '%';
			chatterGroups = [Select Id
								, Name
								, CollaborationType
								, Description
								, SmallPhotoUrl
						From	CollaborationGroup
						Where	Name Like :querySearchText
							And CollaborationType = 'Public'
							And isArchived = false
						Limit 	1000];
			resultsSize = chatterGroups.size();
		}
		
	}

}