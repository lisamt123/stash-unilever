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
    }
    
    // Create & Send Safety Alerts for the updated Case Product and Reason codes. 
    if(trigger.isAfter && trigger.isUpdate){
        System.debug('After Update'); 
        CEC_AlertActionHelper actionHelper = new CEC_AlertActionHelper();
        actionHelper.createCaseSafetyAlerts(trigger.newMap,trigger.oldMap); 
        
        
    }
    /* Support team change starts
    
     -> Changes for incident INC000096161554 - [Information not transmitted in Salesforce]
     -> To populate Country Name field when case is created by Contact-us form
    
    */
    if(trigger.isBefore && trigger.isInsert){ 
        System.debug('Before Insert'); 
       CEC_CaseTriggerHelper caseHelper = new CEC_CaseTriggerHelper();
       
       caseHelper.insertCountryDetail(trigger.new);
      
    }
    
     /* Support team change ends*/
    
}