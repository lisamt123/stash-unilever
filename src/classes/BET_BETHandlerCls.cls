/*************************************************************************************
Name : BET_BETHandlerCls

Purpose : Class contains logic used by BET_BETHandler class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  22-07-2015  Initial
*************************************************************************************/
public with sharing class BET_BETHandlerCls {

  private BET_BETHandlerCls(){}

	public static Map<Id,uw_BET__c> buildBetMap(Map<Id,SObject> sobjectMap){
		Map<Id,uw_Bet__c> betmap = new Map<Id,uw_Bet__c>();
		for(Id id : sobjectMap.keySet()){
			betmap.put(id,(uw_Bet__c)Trigger.oldMap.get(id));
		}
		return betmap;
	}

	public static void logChanges(){
		Boolean enableLogging = !uw_CustomSettingsManager.getCustomSettingBooleanVal(uw_CustomSettingsManager.BET_DISABLE_LOG_CHANGE_TRIGGER, false);
    	if (enableLogging) {
    		Map<Id, List<String>> feedsMap = fillFeeds();
    		if(!feedsMap.isEmpty()){
      			insertFeeds(feedsMap);
    		}
  		}    
	}

	private static Map<Id, List<String>> fillFeeds(){
		Map<Id, List<String>> feedsMap = new Map<Id, List<String>>();
      	Boolean changed = false;
    	List<String> diffs = new List<String>();
    	for(Integer i=0; i< Trigger.new.size(); i++){
      		changed = false;
      		diffs = new List<String>();

          	uw_BET__c oldRecord = (uw_BET__c)Trigger.old[i];
          	uw_BET__c newRecord = (uw_BET__c)Trigger.new[i];

          	if(oldRecord.Status__c != newRecord.Status__c){
              	diffs.add('BET Status has been changed. '+oldRecord.Status__c+' to '+newRecord.Status__c);
              	changed = true;
          	}
          
          	if(changed){
            	feedsMap.put(oldRecord.Studio_Chatter_Group__c, diffs);
          	}
    	}
    	return feedsMap;
	}

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

	public static void deleteBETRelatedCollaborationGroup(){ // Taken from uw_BET_before_delete trigger
		List<Id> delete_BET_group_Ids = new List<Id>();
    	List<CollaborationGroup> delete_BET_chatter_group = new List<CollaborationGroup>();
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
       		List<Database.DeleteResult> result_delete_BET_Group = null;
       		result_delete_BET_Group = Database.delete(delete_BET_group_Ids,false);//deleted BET related Chatter group
    	} catch(System.DmlException e) {
        	System.debug('Error in deleting the BET Group');
    	}

    	/* Below code is added to delete the BET Team members associated with the deleted BET */

    	try {
        	delete_BET_Team_Member =[Select u.Id, u.BET__c From uw_BET_Team_Member__c u where u.BET__c in:BET_Ids];//BET team members
    	} catch(Exception e) {
          System.debug('Error in retrieving team member');
    	}

    	try {
       		List<Database.DeleteResult> result_delete_BET_Member = null;
       		result_delete_BET_Member = Database.delete(delete_BET_Team_Member,false);//deleted BET team members
    	} catch(System.DmlException e) {
        	System.debug('Error in deleting the BET Member');
    	}
	}

}