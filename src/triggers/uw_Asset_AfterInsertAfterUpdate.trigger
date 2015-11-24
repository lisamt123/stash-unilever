//kj 8/10 disabled move to toolkit message

trigger uw_Asset_AfterInsertAfterUpdate on uw_Asset__c (after insert, after update) {
    
    List <uw_Asset__c> assetsToOpen = new List<uw_Asset__c>();
    List <uw_Asset__c> assetsToClose = new List<uw_Asset__c>();
    List <FeedItem> fi = new list<FeedItem>();
    if (trigger.isInsert){      
		system.debug('* insert: asset: ');
        for (uw_Asset__c a : trigger.new){
            if (a.promoted__c){
				system.debug('promoted');
                //FeedItem f = new FeedItem();
                //f.ParentId = a.BET_Chatter_Group__c;
                //f.Body = 'The file (' + a.Name + ') was moved to the toolkit.';
                //fi.add (f);		kj 8/10 requirements from jonathan povah
                assetsToOpen.add(a);
            }
        }
        //insert(fi);
        uw_TriggerHandler handler = new uw_TriggerHandler();
        handler.handleAssets(assetsToOpen, true);
        
    }else{
        for (uw_Asset__c a : trigger.new){
			system.debug('* update: asset: '+a);
			
            uw_Asset__c oldAsset = trigger.oldMap.get(a.id);
			system.debug('* asset: oldAsset: '+oldAsset);
            if (a.promoted__c && !oldAsset.promoted__c){
				system.debug('* asset: oldAsset: now open');
                //FeedItem f = new FeedItem();
                //f.ParentId = a.BET_Chatter_Group__c;
                //f.Body = 'The file (' + a.Name + ') was moved to the toolkit.';
                //fi.add (f);
                assetsToOpen.add(a);
            } else if (!a.promoted__c && oldAsset.promoted__c) {
				system.debug('* asset: oldAsset: now close');
            	assetsToClose.add(a);
            }
        }
        //insert(fi);
        uw_TriggerHandler handler = new uw_TriggerHandler();
        handler.handleAssets(assetsToOpen, true);
        handler.handleAssets(assetsToClose, false);
    }
}