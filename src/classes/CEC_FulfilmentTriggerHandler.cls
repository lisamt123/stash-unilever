/**********************************************************************
Name:  CEC_FulfilmentTriggerHandler 
Copyright © 2014  Unilever
======================================================================
=======================================================================
Purpose: This is the Handler class for cec_Fulfilment__c trigger                                                                                                                      
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
1.0 - Esther            16/10/2014      INITIAL DEVELOPMENT      CSR
2.0 - Masood           09/03/2016      INITIAL DEVELOPMENT      Update debit card value
3.0 - Mahesh           2nd june 2016   CSC-4518                 To calculate Total Enclosure Value
***********************************************************************/

/**
Handler class for Trigger for CEC_FulfilmentTrigger
*/

public with sharing class CEC_FulfilmentTriggerHandler { 
    
    /**
This method is entry point for the actions to be executed before a cec_Fulfilment__c record is inserted
@param : fulfilmentList- List of cec_Fulfilment__c objects which are to be inserted
@return : void
*/
    
    public void beforeInsert(List<cec_Fulfilment__c> fulfilmentList){
        
        
        /* Calling helper to check quality */
        CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
        if(!fulfilmentList.isEmpty()){
            fulfilmentHelper.qualityCheck(fulfilmentList);
            fulfilmentHelper.beforeInsUpdCalcEnclosure(fulfilmentList, null);
        }
        
    }
    public void beforeUpdate(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_fulfilment__C> fulfilmentOldMap){
        
        
        /* Calling helper to check quality */
        CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
        //if(!fulfilmentList.isEmpty())
        //Commented for CSC 3135
        //fulfilmentHelper.refundApprovalCheck(fulfilmentList,fulfilmentOldMap);
        fulfilmentHelper.beforeInsUpdCalcEnclosure(fulfilmentList,fulfilmentOldMap);
        fulfilmentHelper.deleteFulfilmentEnclosure(fulfilmentList,fulfilmentOldMap);
        fulfilmentHelper.upsertFulfilmentEnclosure(fulfilmentList,fulfilmentOldMap);
        fulfilmentHelper.convertRefundValueToWords(fulfilmentList,fulfilmentOldMap);
        fulfilmentHelper.updateDebitCardValue(fulfilmentList,fulfilmentOldMap);
        fulfilmentHelper.updateEvoucherValue(fulfilmentList,fulfilmentOldMap);
        fulfilmentHelper.updateAccountDetails(fulfilmentList,fulfilmentOldMap);  
        fulfilmentHelper.updateFulfilmentApprovedDate(fulfilmentList,fulfilmentOldMap);
    }   
    
    
    public void afterInsert(List<cec_Fulfilment__c> fulfilmentList){        
        
        CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
        if(!fulfilmentList.isEmpty())
            fulfilmentHelper.insertFulfilmentEnclosure(fulfilmentList);
        
    } 
    
}