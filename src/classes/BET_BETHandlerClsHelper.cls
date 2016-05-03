/*************************************************************************************
Name : BET_BETHandlerClsHelper

Purpose : Helper class for BET_BETHandlerCls

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  28-09-2015  Initial
*************************************************************************************/

/* Helper class takes sharing settings from its 'parent' */
public class BET_BETHandlerClsHelper {

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

    /************************************************************
    Purpose: Method deletes given bets
    Parameters: List<uw_BET__c> bets
    Returns: -
    Throws: -
    *************************************************************/
    public static void softDelete(List<uw_BET__c> bets){
      System.debug('Entering softDelete : ' + bets);
      removeMembers(bets);
      archiveUnarchiveChatterGroups(bets,true);
      System.debug('Exit softDelete : ' + bets);
    }

    /************************************************************
    Purpose: Method removed bets members and chattergroups members except bet owner
    Parameters: List<uw_BET__c> bets
    Returns: -
    Throws: -
    *************************************************************/
    private static void removeMembers(List<uw_Bet__c> bets) {
      System.debug('Entering removeMembers : ' + bets);
      List<uw_BET_Team_Member__c> teamMembers = new List<uw_BET_Team_Member__c>();
      List<CollaborationGroupMember> groupMembers = new List<CollaborationGroupMember>();
      Map<Id,Id> chatterGroupOwnerMember = new Map<Id,Id>();

      for(uw_Bet__c bet : [select id, ownerId,Studio_Chatter_Group__c, (select Team_Member__c from BET_Team_Members__r) from uw_Bet__c where id in: bets]) {
        chatterGroupOwnerMember.put((Id)bet.Studio_Chatter_Group__c,bet.ownerId);
        for(uw_BET_Team_Member__c teammember : bet.BET_Team_Members__r){
          if(teammember.Team_Member__c != bet.ownerId){
            teamMembers.add(teammember);
          }
        }
      }

      for(CollaborationGroupMember cmember : [Select memberid,CollaborationGroupId from CollaborationGroupMember where CollaborationGroupId in: chatterGroupOwnerMember.keySet()]){
        if(chatterGroupOwnerMember.get(cmember.CollaborationGroupId) != cmember.memberid){
          groupMembers.add(cmember);
        }
      }

      delete teamMembers;
      delete groupMembers;
      System.debug('Exit removeMembers');
    }

}