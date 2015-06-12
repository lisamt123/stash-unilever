/**********************************************************************
 Name:  FAU_ParticipantTrigger()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Trigger for the FAU_Participant SObject.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
trigger FAU_ParticipantTrigger on FAU_Participant__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

	TriggerFactory.createHandler(FAU_Participant__c.sObjectType);

}