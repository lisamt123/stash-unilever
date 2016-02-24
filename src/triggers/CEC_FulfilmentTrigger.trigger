/**********************************************************************
Name:  CEC_FulfilmentTrigger 
Copyright © 2014  Unilever
======================================================================
=======================================================================
Purpose: This is the Trigger for cec_Fulfilment__c object                                                                                                                      
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
1.0 - Esther           15/10/2014      INITIAL DEVELOPMENT  CSR

***********************************************************************/

/**
Trigger for cec_Fulfilment__c object
*/



trigger CEC_FulfilmentTrigger on cec_Fulfilment__c (before Insert, before Update) {
    
    /* checking is event is AFTER INSERT */
    if(trigger.isBefore && trigger.isInsert){
        
        
        CEC_FulfilmentTriggerHandler fulfilmentHandler = new CEC_FulfilmentTriggerHandler();
        fulfilmentHandler.beforeInsert(trigger.new); 
        
        
        
    }
    if(trigger.isBefore && trigger.isUpdate){
        
        CEC_FulfilmentTriggerHandler fulfilmentHandler = new CEC_FulfilmentTriggerHandler();
        fulfilmentHandler.beforeUpdate(trigger.new,trigger.oldMap);
    }
    
}