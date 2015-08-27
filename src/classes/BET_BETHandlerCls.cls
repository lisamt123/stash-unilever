/*************************************************************************************
Name : BET_BETHandlerCls

Purpose : Class contains logic used by BET_BETHandler class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  22-07-2015  Initial
*************************************************************************************/
public without sharing class BET_BETHandlerCls {

  private static final String BET_STATUS_CHANGED = 'BET Status has been changed. ';
  private static final String BET_LAUNCH_DATE_CHANGED = 'BET Target Launch Date has been changed. ';
  private static final String BET_PROJECT_CHANGED = 'BET Lead IPM Project has been changed. ';
  private static final String BET_CATEGORY_GROUP_CHANGED = 'BET Category group has been changed. ';
  private static final String BET_CATEGORY_CHANGED = 'BET Category has been changed. ';
  private static final String BET_BRAND_POSITIONING_CHANGED = 'BET Brand Position has been changed. ';
  private static final String BET_BRAND_CHANGED = 'BET Brand has been changed. ';
  private static final String BET_DESCRIPTION_CHANGED = 'BET Description has been changed. ';
  private static final String BET_TO = ' to ';

  private static Map<Id,String> projectsMap = new Map<Id,String>();
  private static Map<Id,String> categoryGroupsMap = new Map<Id,String>();
  private static Map<Id,String> categoriesMap = new Map<Id,String>();
  private static Map<Id,String> brandPositionsMap = new Map<Id,String>();
  private static Map<Id,String> brandsMap = new Map<Id,String>();

  private static Set<Id> projects = new Set<Id>();
  private static Set<Id> categoryGroups = new Set<Id>();
  private static Set<Id> categories = new Set<Id>();
  private static Set<Id> positionings = new Set<Id>();
  private static Set<Id> brands = new Set<Id>();

  private BET_BETHandlerCls(){}

  /************************************************************
    Purpose: Method verifies if bet ws archive/unarchived and runs related logic
    Parameters: List<uw_BET__c> newBetList,Map<Id,uw_BET__c> oldBetMap
    Returns: -
    Throws: -
  *************************************************************/
  public static void archiveOrUnarchiveBet(List<uw_BET__c> newBetList,Map<Id,uw_BET__c> oldBetMap){
    List<uw_BET__c> archivedBets = new List<uw_BET__c>();
    List<uw_BET__c> unArchivedBets = new List<uw_BET__c>();
    for(uw_BET__c bet : newBetList){
      if(bet.Is_Archived__c == true && bet.Is_Archived__c != oldBetMap.get(bet.id).Is_Archived__c){
        archivedBets.add(bet);
      }
      if(bet.Is_Archived__c == false && bet.Is_Archived__c != oldBetMap.get(bet.id).Is_Archived__c){
        unArchivedBets.add(bet);
      }
    }
    if(!archivedBets.isEmpty()) {
      archiveBETs(archivedBets);
    }
    if(!unArchivedBets.isEmpty()){
      unArchiveBETs(unArchivedBets);
    }
  }

  /************************************************************
    Purpose: Method does bet archive related logic 
    Parameters: List<uw_BET__c> archivedBets
    Returns: -
    Throws: -
  *************************************************************/
  private static void archiveBETs(List<uw_BET__c> archivedBets){
    archiveUnarchiveChatterGroups(archivedBets,true);
    //BET_EmailNotificationService.notifyAllIPMProjectLeadersOfArchivedBet(archivedBets);
  }

  /************************************************************
    Purpose: Method does bet unarchive related logic 
    Parameters: List<uw_BET__c> unArchivedBets
    Returns: -
    Throws: -
  *************************************************************/
  private static void unArchiveBETs(List<uw_BET__c> unArchivedBets){
    archiveUnarchiveChatterGroups(unArchivedBets,false);
    //BET_EmailNotificationService.notifyAllIPMProjectLeadersOfUnArchivedBet(unArchivedBets);
    //BET_LinkingService.unlinkIPMsfromBets(unArchivedBets);
  }

  /************************************************************
    Purpose: Method archives and unarchives BET related chatter groups
    Parameters: List<uw_BET__c> bets,Boolean shouldBeArchived
    Returns: -
    Throws: -
  *************************************************************/
  private static void archiveUnarchiveChatterGroups(List<uw_BET__c> bets,Boolean shouldBeArchived){
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
    Purpose: Method updates IPM when changes on Bet made.
    Parameters: List<uw_BET__c> newBetList,Map<Id,uw_BET__c> oldBetMap
    Returns: -
    Throws: -
  *************************************************************/
  public static void informIPMOnBetChanges(List<uw_BET__c> newBetList,Map<Id,uw_BET__c> oldBetMap){
    List<String> updatedFields = new List<String>();
    for(uw_BET__c bet : newBetList){
      Boolean changesDone = false;

      if(bet.status__c != oldBetMap.get(bet.id).Status__c){
        changesDone = true;
        updatedFields.add('Status');
      }
      if(bet.ownerid != oldBetMap.get(bet.id).ownerid){
        changesDone = true;
        updatedFields.add('BetOwner');
      }
      if(bet.FinalReleaseDate__c != oldBetMap.get(bet.id).FinalReleaseDate__c){
        changesDone = true;
        updatedFields.add('FinalReleaseDate');
      }
      if(bet.FirstReleaseDate__c != oldBetMap.get(bet.id).FirstReleaseDate__c){
        changesDone = true;
        updatedFields.add('FirstReleaseDate');
      }
      if(bet.Final_Release_Due_Date__c != oldBetMap.get(bet.id).Final_Release_Due_Date__c){
        changesDone = true;
        updatedFields.add('FinalReleaseDueDate');
      }
      if(bet.First_Release_Due_Date__c != oldBetMap.get(bet.id).First_Release_Due_Date__c) {
        changesDone = true;
        updatedFields.add('FirstReleaseDueDate');
      }
      if(bet.Is_Archived__c != oldBetMap.get(bet.id).Is_Archived__c) {
        changesDone = true;
        updatedFields.add('isArchived');
      }
      if(changesDone) {
        BET_BETWrapper wrapper = new BET_BETWrapper(bet);
        IPM_BETUpdateService.updateIPM(bet.id,wrapper,updatedFields, UserInfo.getUserId());
      }
      
    }
  }

  /************************************************************
    Purpose: Method updates final due dates of BET
    Parameters: List<uw_BET__c> bets
    Returns: -
    Throws: -
  *************************************************************/
  public static void updateReleaseDueDates(List<uw_BET__c> bets){
    for(uw_BET__c bet : bets){
      bet.Final_Release_Due_Date__c = BET_BETService.getFinalReleaseDueDate(bet.Launch_Date__c);
      bet.First_Release_Due_Date__c = BET_BETService.getFirstReleaseDueDate(bet.Launch_Date__c);
    }
  }

  /************************************************************
    Purpose: Builds BET map from sObject map
    Parameters: Map<Id,SObject> sobjectMap
    Returns: Map<Id,uw_BET__c>
    Throws: -
  *************************************************************/
	public static Map<Id,uw_BET__c> buildBetMap(Map<Id,SObject> sobjectMap){
		Map<Id,uw_Bet__c> betmap = new Map<Id,uw_Bet__c>();
		for(Id id : sobjectMap.keySet()){
			betmap.put(id,(uw_Bet__c)Trigger.oldMap.get(id));
		}
		return betmap;
	}

  /************************************************************
    Purpose: Logs chnges made on BET object
    Parameters: -
    Returns: -
    Throws: -
  *************************************************************/
	public static void logChanges(){
		Boolean enableLogging = !uw_CustomSettingsManager.getCustomSettingBooleanVal(uw_CustomSettingsManager.BET_DISABLE_LOG_CHANGE_TRIGGER, false);
    	if (enableLogging) {
    		Map<Id, List<String>> feedsMap = fillFeeds();
    		if(!feedsMap.isEmpty()){
      			insertFeeds(feedsMap);
    		}
  		}    
	}

  /************************************************************
    Purpose: Method builds Chatter Feeds records related to made changes
    Parameters: -
    Returns: Map<Id, List<String>> 
    Throws: -
  *************************************************************/
	private static Map<Id, List<String>> fillFeeds(){
    retrieveReletedReferencesIds();
    fillMapObjects();
    return buildFeedMap();
	}

  private static Map<Id, List<String>> buildFeedMap(){
    Map<Id, List<String>> feedsMap = new Map<Id, List<String>>();
    for(Integer i=0; i< Trigger.new.size(); i++){
      uw_BET__c oldRecord = (uw_BET__c)Trigger.old[i];
      uw_BET__c newRecord = (uw_BET__c)Trigger.new[i];
      List<String> diffs = addDifferences(oldRecord,newRecord);
      if(!diffs.isEmpty()){
        feedsMap.put(oldRecord.Studio_Chatter_Group__c, diffs);
      }
    }
    return feedsMap;
  }

  private static List<String> addDifferences(uw_BET__c oldRecord,uw_BET__c newRecord ){
    List<String> diffs = new List<String>();
    if(oldRecord.Status__c != newRecord.Status__c){
      diffs.add(BET_STATUS_CHANGED+oldRecord.Status__c+BET_TO+newRecord.Status__c);
    }

    if(oldRecord.Launch_Date__c != newRecord.Launch_Date__c){
      String oldDate = oldRecord.Launch_Date__c != null ? String.valueOf(oldRecord.Launch_Date__c).substring(0,10) : '';
      String newDate = newRecord.Launch_Date__c != null ? String.valueOf(newRecord.Launch_Date__c).substring(0,10) : '';
      diffs.add(BET_LAUNCH_DATE_CHANGED+oldDate+BET_TO+newDate);
    }

    if(oldRecord.IPM_Project__c != newRecord.IPM_Project__c){
      diffs.add(BET_PROJECT_CHANGED+projectsMap.get(oldRecord.IPM_Project__c)+BET_TO+projectsMap.get(newRecord.IPM_Project__c));
    }

    if(oldRecord.Category_Group__c != newRecord.Category_Group__c){
      diffs.add(BET_CATEGORY_GROUP_CHANGED+categoryGroupsMap.get(oldRecord.Category_Group__c)+BET_TO+categoryGroupsMap.get(newRecord.Category_Group__c));
    }

    if(oldRecord.Product_Category__c != newRecord.Product_Category__c){
      diffs.add(BET_CATEGORY_CHANGED+categoriesMap.get(oldRecord.Product_Category__c)+BET_TO+categoriesMap.get(newRecord.Product_Category__c));
    }

    if(oldRecord.Brand_Position__c != newRecord.Brand_Position__c){
      diffs.add(BET_BRAND_POSITIONING_CHANGED+brandPositionsMap.get(oldRecord.Brand_Position__c)+BET_TO+brandPositionsMap.get(newRecord.Brand_Position__c));
    }

    if(oldRecord.Product_Brand__c != newRecord.Product_Brand__c){
      diffs.add(BET_BRAND_CHANGED+brandsMap.get(oldRecord.Product_Brand__c)+BET_TO+brandsMap.get(newRecord.Product_Brand__c));
    }

    if(oldRecord.Description__c != newRecord.Description__c){
      diffs.add(BET_DESCRIPTION_CHANGED+oldRecord.Description__c+BET_TO+newRecord.Description__c);
    }
    return diffs;
  }

  private static void retrieveReletedReferencesIds(){
    for(Integer i=0; i< Trigger.new.size(); i++){

      uw_BET__c oldRecord = (uw_BET__c)Trigger.old[i];
      uw_BET__c newRecord = (uw_BET__c)Trigger.new[i];

      if(oldRecord.IPM_Project__c != newRecord.IPM_Project__c){
        projects.add(oldRecord.IPM_Project__c);
        projects.add(newRecord.IPM_Project__c);
      }

      if(oldRecord.Category_Group__c != newRecord.Category_Group__c){
        categoryGroups.add(oldRecord.Category_Group__c);
        categoryGroups.add(newRecord.Category_Group__c);
      }

      if(oldRecord.Product_Category__c != newRecord.Product_Category__c){
        categories.add(oldRecord.Product_Category__c);
        categories.add(newRecord.Product_Category__c);
      }

      if(oldRecord.Brand_Position__c != newRecord.Brand_Position__c){
        positionings.add(oldRecord.Brand_Position__c);
        positionings.add(newRecord.Brand_Position__c);
      }

      if(oldRecord.Product_Brand__c != newRecord.Product_Brand__c){
        brands.add(oldRecord.Product_Brand__c);
        brands.add(newRecord.Product_Brand__c);
      }
    }
  }

  /************************************************************
    Purpose: Method create set of maps with objects ids and related names
    Parameters: Set<Id>projects,Set<Id>categoryGroups,Set<Id>categories,Set<Id>positionings,Set<Id>brands
    Returns: -
    Throws: -
  *************************************************************/

  private static void fillMapObjects(){
    for(IPM_Project__c project : [select id, name from IPM_Project__c where id in : projects]){
      projectsMap.put(project.id,project.name);
    }

    for(MDO_Category__c mdo : [select id, name from MDO_Category__c where id in : categoryGroups]){
      categoryGroupsMap.put(mdo.id,mdo.name);
    }

    for(MDO_Category__c mdo : [select id, name from MDO_Category__c where id in : categories]){
      categoriesMap.put(mdo.id,mdo.name);
    }

    for(MDO_BrandPosition__c mdo : [select id, name from MDO_BrandPosition__c where id in : positionings]){
      brandPositionsMap.put(mdo.id,mdo.name);
    }

    for(MDO_Brand__c mdo : [select id, name from MDO_Brand__c where id in : brands]){
      brandsMap.put(mdo.id,mdo.name);
    }
  }

  /************************************************************
    Purpose: Method inserts Chatter Feed records
    Parameters: Map<Id, List<String>> feedsMap)
    Returns: -
    Throws: -
  *************************************************************/
	private static void insertFeeds(Map<Id, List<String>> feedsMap){
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
    Purpose: Method deletes BET related collaboration group
    Parameters: -
    Returns: -
    Throws: -
  *************************************************************/
	public static void deleteBETRelatedCollaborationGroup(){ // Taken from uw_BET_before_delete trigger
		List<Id> delete_BET_group_Ids = new List<Id>();
    	List<Id> BET_Ids = new List<Id>();
    	List<uw_BET_Team_Member__c> delete_BET_Team_Member = new List<uw_BET_Team_Member__c>();
    
    	for(SObject uobj : Trigger.old){ //for loop for BET related chatter grouo id and BET ids.
    		uw_BET__c u = (uw_BET__c)uobj;
            delete_BET_group_Ids.add(u.Studio_Chatter_Group__c);//BET related chatter group
            BET_Ids.add(u.Id);//BET ids
            System.debug('Group Id'+u.CollaborationGroupId__c+'second group id'+u.Studio_Chatter_Group__c);      
    	}
    
    	/* Below code is added to delete the Chatter groupo associated with the deleted BET */
    	try {
       		Database.delete(delete_BET_group_Ids,false);//deleted BET related Chatter group
    	} catch(System.DmlException e) {
        	System.debug('Error in deleting the BET Group');
    	}

    	/* Below code is added to delete the BET Team members associated with the deleted BET */

    	try {
        	delete_BET_Team_Member = [Select u.Id, u.BET__c From uw_BET_Team_Member__c u where u.BET__c in:BET_Ids];//BET team members
    	} catch(Exception e) {
          System.debug('Error in retrieving team member');
    	}

    	try {
       	  Database.delete(delete_BET_Team_Member,false);//deleted BET team members
    	} catch(System.DmlException e) {
        	System.debug('Error in deleting the BET Member');
    	}
	}

}