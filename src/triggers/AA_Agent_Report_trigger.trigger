trigger AA_Agent_Report_trigger on aa_Agent_Report__c (before insert,after insert,before update,after update,before delete,after delete) {
	   string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
       aa_Trigger_pattern__c objAttachmentPattern = aa_Trigger_pattern__c.getValues('aa_Agent_Report_Trigger');
	   if(objAttachmentPattern != null && objAttachmentPattern.chk_Check_Run__c){
       			AA_TriggerFactory.createHandler(aa_Agent_Report__c.sObjectType); 
       }
}