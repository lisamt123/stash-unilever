trigger IPM_UserProfileTrigger on IPM_User_Profile__c (before insert,after insert,before update,after update,before delete,after delete,after undelete) {
    TriggerFactory.createHandler(IPM_User_Profile__c.sObjectType);   
}