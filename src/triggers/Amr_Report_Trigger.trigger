trigger Amr_Report_Trigger on Amr_Job_Details__c (after insert, after update) {
    string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
    
    Amr_Trigger_Pattern__c objAttachmentPattern = Amr_Trigger_Pattern__c.getValues('Amr_Report');
    system.debug('test--value==>'+objAttachmentPattern);
    /** Checking for the trigger router flag from custom setting   */
    if(objAttachmentPattern.Check_Run__c){
        Amr_TriggerFactory.createHandler(Amr_Job_Details__c.sObjectType);  
    } 
}