/**********************************************************************
Name:  CEC_CaseTrigger()
Copyright ? 2013  Unilever
======================================================
======================================================
Purpose:  Common Trigeer on Case for all events                                                
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
1.0 -   Aalokkumar       22/08/2014       INITIAL DEVELOPMENT     frequent caller tracking 
1.1 -   Pavan            18/02/2015       CR                      safety alerts  
1.2 -   Samrin Shaikh    16/11/2015       CSC-2845                US-097 Personal data not included in Pulse
1.3 -   Mahendra         17/11/2015       CSC-2910                Personal Data Retention
1.4 -   Sathish          04/12/2015       CSC-2763                Updated the Alert Action helper's new class.
1.5 -   Goverdhan S.     10/12/2015       CSC-2850                Update for CSAT functionality
****************************************************************************/
trigger CEC_CaseTrigger on Case (before insert,after insert,before update,after update) { 
    
    if(trigger.isAfter && trigger.isInsert){   
        System.debug('After Insert'); 
        CEC_CaseTriggerHelper caseHelper = new CEC_CaseTriggerHelper();
        caseHelper.checkCaseDetails(trigger.newMap);
        caseHelper.updateProductAndReasonCode(trigger.newMap);
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        System.debug('Before Update'); 
        CEC_CaseTriggerHelper caseHelper = new CEC_CaseTriggerHelper();
        caseHelper.updateAccountOwner(trigger.new);
        caseHelper.updateCaseDetailsIfRecordTypeIsSpam(trigger.newMap,trigger.oldMap); 
        caseHelper.updateProductAndReasonCode(trigger.newMap);
        caseHelper.updateCountryDetail(trigger.newMap);
        //caseHelper.insertCountryDetail(trigger.new);
        caseHelper.updateDayCodeMftrCode(trigger.newMap, trigger.oldMap);
        // to set flag for survey email workflow
        caseHelper.setWorkflowFlag(trigger.newMap, trigger.oldMap);    
        //to set the store and product information for web email cases
        caseHelper.updateStoreAndProductInfo(trigger.new, trigger.oldmap);
        caseHelper.updateRetentionDate(trigger.new ,trigger.oldmap);
        /* Start -  US-097 Personal data not included in Pulse */
        caseHelper.updatePIIWarningForUpdate(Trigger.New, Trigger.oldMap);
        /* End -  US-097 Personal data not included in Pulse */
    }
    
    // Create & Send Safety Alerts for the updated Case Product and Reason codes. 
    if(trigger.isAfter && trigger.isUpdate){
        System.debug('After Update Create & Send Safety Alerts for the updated Case Product and Reason codes.'); 
        CEC_InstantAlertActionHelper actionHelper = new CEC_InstantAlertActionHelper();
        actionHelper.createAlertEntries(trigger.oldMap, trigger.newMap);
        CEC_CaseTriggerHelper caseHelper = new CEC_CaseTriggerHelper();
        caseHelper.updateAccountRetentionDetails(trigger.new, trigger.oldMap);
    }
    
    
    /* Support team change starts

-> Changes for incident INC000096161554 - [Information not transmitted in Salesforce]
-> To populate Country Name field when case is created by Contact-us form

*/
    if(trigger.isBefore && trigger.isInsert){ 
        System.debug('Before Insert'); 
        CEC_CaseTriggerHelper caseHelper = new CEC_CaseTriggerHelper();
        caseHelper.updateSuppliedEmail(trigger.new);//To update the suppliedEmail for Web Cases
        caseHelper.insertCountryDetail(trigger.new);
        caseHelper.updatePIIWarningForInsert(trigger.new);
        
    }
    
    /* Support team change ends*/
    
/** START: GS Test ***** 
    if(trigger.isBefore && trigger.isUpdate){
            System.debug('Before Update'); 
            CEC_CaseTriggerHelper caseHelper = new CEC_CaseTriggerHelper();
            caseHelper.updateCaseFields(trigger.newMap);
    }
/** END: GS TEST   ****/
}