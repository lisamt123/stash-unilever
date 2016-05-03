trigger BET_LogChanges on uw_BET__c (after update) {
	Boolean enableTrigger = !uw_CustomSettingsManager.getCustomSettingBooleanVal(uw_CustomSettingsManager.BET_DISABLE_LOG_CHANGE_TRIGGER, false);
    if (enableTrigger) {
		Map<Id, List<String>> feedsMap = new Map<Id, List<String>>();
	    Boolean changed = false;
		List<String> diffs = new List<String>();
		for(Integer i=0; i< Trigger.new.size(); i++){
			changed = false;
			diffs = new List<String>();

	        uw_BET__c oldRecord = Trigger.old[i];
	        uw_BET__c newRecord = Trigger.new[i];

	        if(oldRecord.Status__c != newRecord.Status__c){
	            diffs.add('BET Status has been changed. '+oldRecord.Status__c+' to '+newRecord.Status__c);
	            changed = true;
	        }
	        
	        if(changed){
	        	feedsMap.put(oldRecord.Studio_Chatter_Group__c, diffs);
	        }
		}

		if(feedsMap.size() > 0){
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
	}		
}