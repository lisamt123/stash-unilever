/**
* @author:Cognizant
* @date:06/05/2015
* @description:Trigger Handler for the IPM_Project_Document_Section__c SObject. This class implements the ITrigger
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public with sharing class IPM_FinancialYearHandler implements ITrigger{   
    public static boolean firstRun = true;
    //@description:Constructor
    public IPM_FinancialYearHandler (){
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    /**
    * @description:bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){
        IPM_FinancialYearTriggerHandler handler = new IPM_FinancialYearTriggerHandler();
        
        if(System.Trigger.isDelete){
            handler.onBeforeDelete((Map<Id,IPM_Financial_Year__c>) Trigger.oldMap);
        }
        
    }
    /**
    * @description:bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter(){
        IPM_FinancialYearTriggerHandler handler = new IPM_FinancialYearTriggerHandler();

        if(System.Trigger.isUpdate){
				Map<Id,IPM_Financial_Year__c> oldFMap = (Map<Id,IPM_Financial_Year__c>) Trigger.oldMap;
				Map<Id,IPM_Financial_Year__c> newFMap = (Map<Id,IPM_Financial_Year__c>) Trigger.newMap;
        		handler.onAfterUpdate((Map<Id,IPM_Financial_Year__c>) Trigger.newMap, (Map<Id,IPM_Financial_Year__c>) Trigger.oldMap);
            	handler.updateFinancialActionStandard((Map<Id,IPM_Financial_Year__c>) Trigger.newMap);
        }
    }
    /**
    * @description:beforeInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void beforeInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:beforeUpdate
    * This method is called iteratively for each record to be update during a BEFORE
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void beforeUpdate(SObject oldSo, SObject so){ 
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * @description:beforeDelete
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){  
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterUpdate
    * This method is called iteratively for each record to be update during a AFTER
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void afterUpdate(SObject oldSo, SObject so){ 
        //This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterDelete
    * This method is called iteratively for each record to be delete during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterDelete(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * @description:andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger
        ExceptionLoggingHelper.insertLogRecordList();
    }
}