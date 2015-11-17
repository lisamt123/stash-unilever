/**
@Author Cognizant
@Name IPM_CompanyCardTrigger
@CreateDate 27/08/2015
@Description This Trigger is used for the IPM_Company_Card__c SObject.
@Version 1.0
@reference 
*/
trigger IPM_CompanyCardTrigger on IPM_Company_Card__c (before insert,after insert,before update,after update,before delete,after delete) {
    string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
    IPM_Trigger_Router__c triggerRouter = IPM_Trigger_Router__c.getInstance(CSkey); 
   /** Checking for the trigger router flag from custom setting   */
    if(triggerRouter!=null && triggerRouter.is_Disabled__c){
        return;
    }
    TriggerFactory.createHandler(IPM_Company_Card__c.sObjectType);    
       
}