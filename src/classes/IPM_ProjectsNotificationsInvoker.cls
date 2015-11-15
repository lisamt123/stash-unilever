public with sharing class IPM_ProjectsNotificationsInvoker {
    
    @InvocableMethod
    public static void notifyUsers(List<Id> userIdLst) {
        updateResources(userIdLst);
        Set<Id> userIds = new Set<Id>();
        userIds.addAll(userIdLst);
        //IPM_TaskHelper.reAssign(userIds);
    }
    
    @future
    private static void updateResources(List<Id> userIdLst) {
        list<IPM_Project_Resource__c> projectResources = [SELECT Id FROM IPM_Project_Resource__c WHERE IPM_User__c IN :userIdLst];
        system.debug('** projectResources ' + projectResources);
        update projectResources;
    }
}