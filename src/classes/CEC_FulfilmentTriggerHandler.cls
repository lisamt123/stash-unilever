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
   1.0 - Esther            16/10/2014      INITIAL DEVELOPMENT  CSR
 
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
                    CEC_FulfilmentQualityCheckHelper qualityCheckHelper = new CEC_FulfilmentQualityCheckHelper();
            if(!fulfilmentList.isEmpty())
                    qualityCheckHelper.qualityCheck(fulfilmentList);
            
              
    }
    
        }