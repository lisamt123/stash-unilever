trigger SAM_Request_Trigger on SAM_Request__c (before insert,after insert,before update,after update,before delete,after delete) {
    
    SAM_Trigger_Pattern__c objRequestPattern = SAM_Trigger_Pattern__c.getValues(SAM_Constants.REQUESTTRIGERNAME);
    
    System.debug('objRequestPattern.chk_Stop_Trigger_Execution__c - ' + objRequestPattern.chk_Stop_Trigger_Execution__c);
    
    if(objRequestPattern != null && objRequestPattern.chk_Stop_Trigger_Execution__c){
    
        SAM_TriggerFactory.createHandler(SAM_Request__c.sObjectType); 
        
        System.debug('SAM_Request__c.sObjectType - ' + SAM_Request__c.sObjectType);
        
    }
}