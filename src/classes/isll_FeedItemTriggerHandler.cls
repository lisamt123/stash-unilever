/**********************************************************************
 Name:  isll_FeedItemTriggerHandler
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: The trigger handler for the Feed Item Object                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     30/07/2013        INITIAL DEVELOPMENT         Story id:USLL-191  	
 
***********************************************************************/
public class isll_FeedItemTriggerHandler {
	
	private Boolean m_isExecuting = false;
	private Integer BatchSize = 0;
	public static String GROUP_NAME {
		get{
			if(Test.isRunningTest()){
				GROUP_NAME = 'Internal Sustainable Living Lab_Test';
			}
			else{
				GROUP_NAME = 'Internal Sustainable Living Lab';
			}
			return GROUP_NAME;
		}
		set;
	}
	
	/*******************************************************************
       Purpose: Constructor that receives values for the class properties from the trigger and populates them.
    ********************************************************************/
	public isll_FeedItemTriggerHandler(Boolean isExecuting, Integer size){
		m_isExecuting = isExecuting;
		BatchSize = size;
	}
	
	/*******************************************************************
       Purpose: Handler method for Before Delete FeedItem
       Params:  oldMap - Map of FeedItem. Corresponds to Trigger.oldMap
    ********************************************************************/	
	public void OnBeforeDelete(Map<Id, FeedItem> oldMap){
		
		List<Chatter_History__c> chatterHistoryToInsert = new List<Chatter_History__c>();
		Id chatterGroupID;
		
		List<CollaborationGroup> groups = [select id, name from CollaborationGroup where name = :GROUP_NAME];
		if(null != groups && groups.size() > 0){
			for(CollaborationGroup grp :groups){
				if(grp.Name == GROUP_NAME){
					chatterGroupID = grp.id;
				}
			}
		}
		
		for(FeedItem fi : oldMap.values()){
			//only populate history object if the feed is part of isll chatter group
			if(fi.ParentId == chatterGroupID){
				chatterHistoryToInsert.add(new Chatter_History__c(Feed_Contents__c = fi.Body, 
																	Feed_Owner__c = fi.CreatedById, 
																	Deleting_Moderator__c = System.Userinfo.getUserId()));
			}
		}
		
		if(!chatterHistoryToInsert.isEmpty()){
			insert chatterHistoryToInsert;
		}
		
	}

}