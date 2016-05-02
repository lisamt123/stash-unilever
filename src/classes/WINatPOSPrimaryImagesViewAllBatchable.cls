/*===========================================================================
  Name:  WINatPOSPrimaryImagesViewAllBatchable                                                       
  Copyright notice:                                                          
  ===========================================================================
  ===========================================================================
   Purpose: WINatPOSPrimaryImagesViewAllBatchable class used to make all feed Items
            which are primary images for Assets to be visible for all/community users 
			also
                                                                    
  ===========================================================================
  ===========================================================================
  History                                                                   
  -------                                                                   
  VERSION  AUTHOR           DATE              DETAIL          RELEASE/CSR   
   1.0 -  Karol Szepietowski   02/12/2015      INITIAL DEVELOPMENT               
  ===========================================================================*/

global class WINatPOSPrimaryImagesViewAllBatchable implements Database.Batchable<sObject>{
	
    global Database.QueryLocator start(Database.BatchableContext BC){
      
      String visibility ='InternalUsers';
      return Database.getQueryLocator('select id from File__Feed where Parent.Is_Primary_Image__c = true and Parent.Asset__c != null and Visibility=:visibility Limit 50000');
   }
    
    /*******************************************************************
    Purpose: Processing FeedItems which should be visible to community
    Returns: void 
    ********************************************************************/
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<FeedItem> fileLst = new List<FeedItem>();
		Set<Id> feedItemsToUpadate = new Set<Id>();
        for(File__Feed fFeed : (List<File__Feed>)scope){
            feedItemsToUpadate.add(fFeed.id);
        }	
        
       system.debug(feedItemsToUpadate.size());


        for(FeedItem  f : [select Id,ParentId, Type, Visibility from FeedItem where id in : feedItemsToUpadate Limit 50000]){
            f.Visibility = 'AllUsers';
            fileLst.add(f);
        }
        
        Database.update(fileLst, false);

    }
    
    global void finish(Database.BatchableContext BC){
    }
}