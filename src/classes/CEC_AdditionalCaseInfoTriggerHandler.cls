/**********************************************************************
 Name:  CEC_AdditionalCaseInfoTriggerHandler 
 Copyright © 2014  Unilever
 ======================================================================
=======================================================================
Purpose: This is the Handler class for cec_Additional_Case_Information__c trigger                                                                                                                      
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
   1.0 - Shruti            20/10/2014      INITIAL DEVELOPMENT  CSR
 
***********************************************************************/

/**
Handler class for Trigger for cec_Additional_Case_Information__c
*/

public with sharing class CEC_AdditionalCaseInfoTriggerHandler { 

    /**
    This method is entry point for the actions to be executed when a AdditionalCaseInfo record is inserted
    @param : addtionalCaseInfoList- List of cec_Additional_Case_Information__c objects which are inserted
    @return : void
    */
    public void afterInsert(List<cec_Additional_Case_Information__c > addtionalCaseInfoList, MAP<Id,cec_Additional_Case_Information__c> addtionalCaseInfoMap){
        try{
            /* Calling helper to send emails */
            CEC_AdditionalCaseInfoTriggerHelper addCaseInfoHelper = new CEC_AdditionalCaseInfoTriggerHelper();
            addCaseInfoHelper.generateReport(addtionalCaseInfoList, addtionalCaseInfoMap);
            
            
            
        } catch(Exception ex){
            System.debug('Exception in CEC_AdditionalCaseInfoTriggerHandler.afterInsert() -> Exception :' + ex );
        }
    }


   

}