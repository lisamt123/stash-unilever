trigger CEC_AdditionalCaseInformationTrigger on cec_Additional_Case_Information__c (after insert) {
    if(trigger.isAfter && trigger.isInsert ){
        try {
            CEC_AdditionalCaseInfoTriggerHandler handler = new CEC_AdditionalCaseInfoTriggerHandler ();
            handler.afterInsert(trigger.new, trigger.newMap); 
         }
          catch(Exception ex){
             System.debug('Exception in CEC_AdditionalCaseInformationTrigger -> Exception :' + ex );
         }
     }
}