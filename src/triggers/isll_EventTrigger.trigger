/**********************************************************************
 Name:  isll_EventTrigger
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: The trigger for the Event__c object. Follows the following pattern 
		 http://developer.force.com/cookbook/recipe/trigger-pattern-for-tidy-streamlined-bulkified-triggers                                                           
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Marc Saelzler     29/10/2013        INITIAL DEVELOPMENT         Due to issue in row 18 of 'Master List for RFC 22 10 13_2'.
 
***********************************************************************/

trigger isll_EventTrigger on Event__c (after delete)
{    
   if(Trigger.isDelete && Trigger.isAfter) {
		isll_EventHandler handler = new isll_EventHandler(Trigger.isExecuting, Trigger.size);
		handler.OnAfterDelete(Trigger.oldMap);
	}
}