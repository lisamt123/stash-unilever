/*************************************************************** 
	Name: WIN_ChatterDeletedEndpoint
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Returns all the deleted feed items 
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	20/12/2016	Initial Dev 	Chatter deleted feed items 
***************************************************************/
@RestResource(urlMapping='/tqchatter/deleted/*')
global with sharing class WIN_ChatterDeletedEndpoint {
	
    /**
	 *	Purpose: Wrapper for the deleted record
	 */
	global class DeletedRecord {
		public DateTime deletedDate;
		public String id;

		public DeletedRecord(String id, DateTime deletedDate) {
			this.id = id;
			this.deletedDate = deletedDate;
		}
	}
	
	/**
	 *	Purpose: Wrapper for the result of the call
	 */
	global class GetDeletedResult{
		public DateTime latestDateCovered;
		public DateTime earliestDateAvailable;
		public DeletedRecord[] deletedRecords;
		
		public GetDeletedResult() {
			deletedRecords = new List<DeletedRecord>();
		}
	}

	/**
	 *	Return the list of followers, with the email address if selected
	 */
	@HttpGet
    webservice static GetDeletedResult getDeletedFeedItems() {
    	RestRequest req = RestContext.request;
    	Datetime startDate, endDate;

    	try {
    		startDate = (Datetime)JSON.deserialize('"' + req.params.get('start') + '"', Datetime.class); 
    	} catch(Exception e) {
    		startDate = DateTime.now().addhours(-10);
    	}

    	try {
    		endDate = (Datetime)JSON.deserialize('"' + req.params.get('end') + '"', Datetime.class);
    	} catch(Exception e) {
    		endDate = DateTime.now();
    	}
    	
    	Database.GetDeletedResult deletionsResult = Database.getDeleted('FeedItem', startDate, endDate);
    	GetDeletedResult response = new GetDeletedResult();
    	response.earliestDateAvailable = deletionsResult.getEarliestDateAvailable();
    	response.latestDateCovered = deletionsResult.getLatestDateCovered();
    	
    	for (Database.DeletedRecord record : deletionsResult.getDeletedRecords()){ 
    		response.deletedRecords.add(new DeletedRecord(record.getId(), record.getDeletedDate()));
    	}
    	
    	return response;
	}	
}