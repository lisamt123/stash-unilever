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
****************************************************************************/
trigger CEC_CaseTrigger on Case (before insert,after insert,before update,after update) { 
    
    if(trigger.isAfter && trigger.isInsert){   
        System.debug('After Insert'); 
        debugLog('AFTER INSERT');
        CEC_CaseTriggerHelper caseHelper = new CEC_CaseTriggerHelper();
        caseHelper.checkCaseDetails(trigger.newMap);
        caseHelper.updateProductAndReasonCode(trigger.newMap);
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        System.debug('Before Update'); 
        debugLog('BEFORE UPDATE');
        CEC_CaseTriggerHelper caseHelper = new CEC_CaseTriggerHelper();
        caseHelper.updateAccountOwner(trigger.new);
        caseHelper.updateCaseDetailsIfRecordTypeIsSpam(trigger.newMap,trigger.oldMap); 
        caseHelper.updateProductAndReasonCode(trigger.newMap);
        caseHelper.updateCountryDetail(trigger.newMap);
        //caseHelper.insertCountryDetail(trigger.new);
        caseHelper.updateDayCodeMftrCode(trigger.newMap, trigger.oldMap);       
        
        caseHelper.updateRetentionDate(trigger.new ,trigger.oldmap);
        /* Start -  US-097 Personal data not included in Pulse */
        caseHelper.updatePIIWarningForUpdate(Trigger.New, Trigger.oldMap);
        /* End -  US-097 Personal data not included in Pulse */
    }
    
    // Create & Send Safety Alerts for the updated Case Product and Reason codes. 
    if(trigger.isAfter && trigger.isUpdate){
        System.debug('After Update'); 
        debugLog('AFTER UPDATE');
        CEC_AlertActionHelper actionHelper = new CEC_AlertActionHelper();
        actionHelper.createCaseSafetyAlerts(trigger.newMap,trigger.oldMap); 
        CEC_CaseTriggerHelper caseHelper = new CEC_CaseTriggerHelper();
        caseHelper.updateAccountRetentionDetails(trigger.new, trigger.oldMap);
    }
    
    
    /* Support team change starts

-> Changes for incident INC000096161554 - [Information not transmitted in Salesforce]
-> To populate Country Name field when case is created by Contact-us form

*/
    if(trigger.isBefore && trigger.isInsert){ 
        System.debug('Before Insert'); 
        debugLog('BEFORE INSERT');
        CEC_CaseTriggerHelper caseHelper = new CEC_CaseTriggerHelper();
        caseHelper.insertCountryDetail(trigger.new);
        caseHelper.updatePIIWarningForInsert(trigger.new);
        
    }
    
    /* Support team change ends*/

     private void debugLog(String event) {

 System.debug('******** START  *********' + event);
        System.debug('OLD MAP ' + trigger.oldMap);
        System.debug('NEW MAP ' + trigger.newMap);
        System.debug('OLD List ' + trigger.old);
        System.debug('NEW List ' + trigger.new);
        System.debug('******** END *********' + event);
 }
    
}