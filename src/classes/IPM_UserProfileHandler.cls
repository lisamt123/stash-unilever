/**
* @author:Cognizant
* @date:06/05/2015
* @description:Trigger Handler for the IPM_User_Profile__c SObject. This class implements the ITrigger
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public with sharing class IPM_UserProfileHandler implements ITrigger{
    
    //@description:Constructor
    public IPM_UserProfileHandler(){
        System.debug('IPMUserProfileHandler constructor executed.');
    }
    
    /**
    * @description:bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){
         
        if (Trigger.isInsert || Trigger.isUpdate) {
            IPM_ShareWithWorkLevel.CategoryValidation((List<IPM_User_Profile__c>)trigger.new);
        } 
        
       
    }
    /**
    * @description:bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter(){
        
        if (Trigger.isInsert || Trigger.isUpdate) {
          //  IPM_ShareWithWorkLevel.ShareRecords((List<IPM_User_Profile__c>)trigger.new);
           //IPM_ShareWithWorkLevel.CategoryValidation((List<IPM_User_Profile__c>)trigger.new);
        } 
    }
    /**
    * @description:beforeInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */      
    public void beforeInsert(SObject so){
        System.debug('Before Insert: ' + so);
    }
    /**
    * @description:beforeUpdate
    * This method is called iteratively for each record to be update during a BEFORE
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void beforeUpdate(SObject oldSo, SObject so){
        System.debug('Before Update Old: ' + oldSo);
        System.debug('Before Update New: ' + so);
    }
    /**
    * @description:beforeDelete
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){   
        System.debug('Before Delete: ' + so);
    }
    /**
    * @description:afterInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterInsert(SObject so){
        System.debug('After Insert: ' + so);
    }
    /**
    * @description:afterUpdate
    * This method is called iteratively for each record to be update during a AFTER
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void afterUpdate(SObject oldSo, SObject so){
        System.debug('After Update Old:' + oldSo);
        System.debug('After Update New: ' + so);
    }
    /**
    * @description:afterDelete
    * This method is called iteratively for each record to be delete during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterDelete(SObject so){
        System.debug('After Delete: ' + so);
    }
    
    /**
    * @description:andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
        System.debug('IPMUserProfile Trigger finally block executed.');
    }
    
}