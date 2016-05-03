/**********************************************************************
 Name:  FAU_ModuleTrigger()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Trigger for the FAU_Module__c SObject.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/12/2014        INITIAL DEVELOPMENT           
***********************************************************************/

trigger FAU_ModuleTrigger on FAU_Module__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

	TriggerFactory.createHandler(FAU_Module__c.sObjectType);
}