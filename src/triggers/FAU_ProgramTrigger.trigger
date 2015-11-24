/**********************************************************************
 Name:  FAU_ProgramTrigger()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Trigger for the FAU_Program__c SObject.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
trigger FAU_ProgramTrigger on FAU_Program__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {


	TriggerFactory.createHandler(FAU_Program__c.sObjectType);
}