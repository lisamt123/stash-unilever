public class uw_MakeAssetsVisible {
    
    public uw_MakeAssetsVisible() {
    }
    
    public Integer openUp(List<uw_Asset__c> assetList) {
        system.debug('openUp: entry');
        List<FeedItem> feedItems = new List<FeedItem>();
        if (publicAssetsChatterGroupId != null) {
            system.debug('doIt: for loop');
            for (uw_Asset__c asset:assetList) {
                if (asset.URL_of_Asset__c.contains('http') == false) {
                    FeedItem fi = new FeedItem(ParentId=publicAssetsChatterGroupId, RelatedRecordId=asset.URL_of_Asset__c, type='ContentPost');
                    feedItems.add(fi);              
                }
            }
            system.debug('uw_MakeAssetsVisible.doit: '+feedItems);
            if (feedItems.size() > 0) {
                checkChatter();
                // AH - TODO - this code is no longer needed for sharing...
                // This is done by posting the the content to the bet feed-
                // so it automatically opens up access when the bet becomes public
                // insert feedItems;           
            }
        }
        system.debug('doIt: exit');
        return feedItems.size();
    }
    
    // remove the asset from view
    // this removes the asset from the Public Chatter Group
    // TODO: remove the asset preview view from the page
    public Integer closeDown(List<uw_Asset__c> assetList) {
        system.debug('closeDown: entry');

        // first check we know the Public Chatter Group
        if (publicAssetsChatterGroupId != null) {
            system.debug('closeDown: for loop');
            Boolean firstContent = true;
            // build the query to get the contentversion records based on what the asset tells us
            String query = 'SELECT ContentDocumentId FROM ContentVersion WHERE Id IN (';
            for (uw_Asset__c asset:assetList) {
                if (asset.URL_of_Asset__c.contains('http') == false) {
                    if (firstContent) {
                        firstContent = false;
                    } else {
                        query += ',';
                    }
                    query += '\'' + asset.URL_of_Asset__c + '\'';                               
                }
            }
            if (firstContent) {
                system.debug('There were no assets');
                return 0;            	
            }
                
            query += ')';
            system.debug('closeDown: query: '+query);
            List<ContentVersion> cvl = Database.Query(query);
            
            // if we found some contentversion records then continue
            if (cvl.size() > 0) {
                List<ContentDocumentLink> cdlToDeleteList = new List<ContentDocumentLink>();
                // now check whether any of the ContentDocumentLinks are for our chatter group
                for (ContentVersion cv:cvl) {
                    // look for ContentDocumentLinks (note we cannot do an AND in the WHERE clause!)
                    List<ContentDocumentLink> cdlList = [SELECT id, LinkedEntityId FROM ContentDocumentLink WHERE  ContentDocumentId = :cv.ContentDocumentId];
                    for (ContentDocumentLink cdl:cdlList) {
                        system.debug('cdl: '+cdl);
                        system.debug('publicAssetsChatterGroupId: '+publicAssetsChatterGroupId);
                        
                        if (uw_HelperMethods.idsAreEqual(cdl.LinkedEntityId,publicAssetsChatterGroupId)) {
                            // yes! - add to our delete list
                            cdlToDeleteList.add(cdl);
                        }                                               
                    }
                }
                system.debug('cdlToDeleteList: '+cdlToDeleteList);
                
                if (cdlToDeleteList.size() > 0) {
                    // if we fdound something then delete it
                    system.debug('uw_MakeAssetsVisible: cdlToDeleteList: '+cdlToDeleteList);
                    delete cdlToDeleteList;                 
                }
            }
        }
        system.debug('closeDown: exit');

        return 0;       
    }
    
    public  static final String PUBLIC_ASSET_GROUP = 'Public Assets';
    public static final String PUBLIC_ASSET_GROUP_TEST = 'Public Assets Test';
    public String publicAssetsChatterGroupId { get {
        if (publicAssetsChatterGroupId == null) {
        	String cgName;
        	if (!Test.isRunningTest()) {
        		cgName = PUBLIC_ASSET_GROUP;
        	} else {
        		cgName = PUBLIC_ASSET_GROUP_TEST;
        	}
            system.debug('publicAssetsChatterGroupId: get: '+cgName);
            List<CollaborationGroup> cgl = [SELECT Id FROM CollaborationGroup WHERE Name=:cgName];            
            if ( (cgl != null) && (cgl.size()==1) ) {
                publicAssetsChatterGroupId = cgl[0].Id;             
            } else {
            	// TODO: self-healing, we could create the CollaborationGroup if it does not exist
            	/*
            	CollaborationGroup cg = new CollaborationGroup(Name=cgName, CollaborationType='Public', CanHaveGuests=false);
                insert cg;
            	*/
            }
       }
        system.debug('publicAssetsChatterGroupId: '+publicAssetsChatterGroupId);
        return publicAssetsChatterGroupId;
    } set;}

    public void checkChatter() {
        system.debug('checkChatter: entry');
        String userId = system.Userinfo.getUserId();
        
        list<CollaborationGroupMember> groupmember = [Select MemberId, CollaborationGroupId From CollaborationGroupMember where CollaborationGroupId =:publicAssetsChatterGroupId AND memberId =:userId];
        system.debug('checkChatter: groupmember: '+groupmember);
                
        if (groupmember.size() == 0){
            try {
                CollaborationGroupMember colgroupmem = new CollaborationGroupMember(MemberId = userId, CollaborationGroupId =publicAssetsChatterGroupId,CollaborationRole='Standard' );
                insert colgroupmem;
                system.debug('colgroupmem: '+colgroupmem);
            } catch(exception e){
                system.debug('colgroupmem: exception: '+e);
            }
         }
    }



}