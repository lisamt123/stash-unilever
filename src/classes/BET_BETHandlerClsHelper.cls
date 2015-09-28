public without sharing class BET_BETHandlerClsHelper {

	private BET_BETHandlerClsHelper() {}

 	/************************************************************
    Purpose: Method inserts Chatter Feed records
    Parameters: Map<Id, List<String>> feedsMap)
    Returns: -
    Throws: -
  	*************************************************************/
	public static void insertFeeds(Map<Id, List<String>> feedsMap){
		List<FeedItem> feedToInsert = new List<FeedItem>();
      	for(Id groupId : feedsMap.keySet()){
      		List<String> diffMsgs = feedsMap.get(groupId);
      		for(String d: diffMsgs){
        		FeedItem f = new FeedItem();
        		f.Body = d;
        		f.Type = 'TextPost';
        		f.ParentId = groupId;
        		feedToInsert.add(f);
        	}
      	}
    	insert feedToInsert;
	}

  	/************************************************************
    Purpose: Method archives and unarchives BET related chatter groups
    Parameters: List<uw_BET__c> bets,Boolean shouldBeArchived
    Returns: -
    Throws: -
  	*************************************************************/
  	public static void archiveUnarchiveChatterGroups(List<uw_BET__c> bets,Boolean shouldBeArchived){
	    Set<String> chatterGroups = new Set<String>();
	    for(uw_BET__c bet : bets){
	      chatterGroups.add(bet.Studio_Chatter_Group__c);
	    }
	    List<CollaborationGroup> groups = [select id, IsArchived from CollaborationGroup where id in: chatterGroups];
	    for(CollaborationGroup grp : groups){
	      grp.IsArchived = shouldBeArchived;
	    }
	    update groups;
  	}

}