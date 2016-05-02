/**********************************************************************
 Name:  FeedItemTrigger
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: The trigger for the FeedItem object. Follows the following pattern 
         http://developer.force.com/cookbook/recipe/trigger-pattern-for-tidy-streamlined-bulkified-triggers                                                           
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     30/07/2013        INITIAL DEVELOPMENT         Story id:USLL-191      
 
***********************************************************************/

trigger isll_FeedItemTrigger on FeedItem (after delete, after insert, after undelete, 
                                                        after update, before delete, before insert, before update) { 
   if(Trigger.isDelete && Trigger.isBefore) {
        isll_FeedItemTriggerHandler handler = new isll_FeedItemTriggerHandler(Trigger.isExecuting, Trigger.size);
        handler.OnBeforeDelete(Trigger.oldMap);
    }
}