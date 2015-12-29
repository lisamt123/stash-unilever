/*
*@Author:Cognizant
*@Date:December 2015
*@Description : Handler class for AF_Bonus_Threshold__c.
*********************************************/
public with sharing class AF_Bonus_ThresholdHandler implements ITrigger
{
    // AF_CreateBonusResultTrigger Logic Starts
    private List<AF_Bonus_Results__c> bonusResultObjList = new List<AF_Bonus_Results__c>();
    private Id annualBonusRecordTypeId = null;
    private string ErrorMessage='Please ensure the values entered in the target threshold fields are ascending from minimum to outstanding';
    public void bulkBefore()
    {
    }
    public void bulkAfter()
    {
        // AF_CreateBonusResultTrigger Logic Starts
        annualBonusRecordTypeId = [SELECT id FROM recordType WHERE name=:AF_Constants.ANNUAL_BONUS_REC_TYPE AND SobjectType='AF_Bonus_Results__c'].Id;
        // AF_CreateBonusResultTrigger Logic Ends
    }
    /**
    * beforeInsert
    *
    * This method is called iteratively for each record to be inserted during a BEFORE
    * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
    */
    public void beforeInsert(SObject so)
    {
        AF_Bonus_Threshold__c bonusThresholdInstance = (AF_Bonus_Threshold__c)so;
        // Af_AfterInsertBonusThresholdShare Trigger Logic Starts
        if(bonusThresholdInstance.AF_Minimum__c==0 && bonusThresholdInstance.AF_Stretching__c==0 && bonusThresholdInstance.AF_Outstanding__c==0 )
        {
            bonusThresholdInstance.addError(ErrorMessage);
        }
        else if((bonusThresholdInstance.AF_Minimum__c >= bonusThresholdInstance.AF_Stretching__c || bonusThresholdInstance.AF_Minimum__c >= bonusThresholdInstance.AF_Outstanding__c )){
            bonusThresholdInstance.addError(ErrorMessage);
        }
        else if((bonusThresholdInstance.AF_Stretching__c  >= bonusThresholdInstance.AF_Outstanding__c || bonusThresholdInstance.AF_Stretching__c <=bonusThresholdInstance.AF_Minimum__c )){
            bonusThresholdInstance.addError(ErrorMessage);
        }
        else if((bonusThresholdInstance.AF_Outstanding__c  <= bonusThresholdInstance.AF_Minimum__c || bonusThresholdInstance.AF_Outstanding__c <= bonusThresholdInstance.AF_Stretching__c )){
            bonusThresholdInstance.addError(ErrorMessage);
        }
        // Af_AfterInsertBonusThresholdShare Trigger Logic Ends
    }
    /**
    * beforeUpdate
    *
    * This method is called iteratively for each record to be updated during a BEFORE
    * trigger.
    */
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        AF_Bonus_Threshold__c bonusThresholdInstance = (AF_Bonus_Threshold__c)so;
        // Af_AfterInsertBonusThresholdShare Trigger Logic Starts
        if(bonusThresholdInstance.AF_Minimum__c==0 && bonusThresholdInstance.AF_Stretching__c==0 && bonusThresholdInstance.AF_Outstanding__c==0 )
        {
            bonusThresholdInstance.addError(ErrorMessage);
        }
        else if((bonusThresholdInstance.AF_Minimum__c >= bonusThresholdInstance.AF_Stretching__c || bonusThresholdInstance.AF_Minimum__c >= bonusThresholdInstance.AF_Outstanding__c )){
            bonusThresholdInstance.addError(ErrorMessage);
        }
        else if((bonusThresholdInstance.AF_Stretching__c  >= bonusThresholdInstance.AF_Outstanding__c || bonusThresholdInstance.AF_Stretching__c <=bonusThresholdInstance.AF_Minimum__c )){
            bonusThresholdInstance.addError(ErrorMessage);
        }
        else if((bonusThresholdInstance.AF_Outstanding__c  <= bonusThresholdInstance.AF_Minimum__c || bonusThresholdInstance.AF_Outstanding__c <=bonusThresholdInstance.AF_Stretching__c )){
            bonusThresholdInstance.addError(ErrorMessage);
        }
        // Af_AfterInsertBonusThresholdShare Trigger Logic Ends
    }
    /**
    * beforeDelete
    *
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so)
    {
        
    }
    /**
    * afterInsert
    *
    * This method is called iteratively for each record inserted during an AFTER
    * trigger. Always put field validation in the 'After' methods in case another trigger
    * has modified any values. The record is 'read only' by this point.
    */
    public void afterInsert(SObject so)
    {
        AF_Bonus_Threshold__c bonusThresholdInstance = (AF_Bonus_Threshold__c)so;
        // AF_CreateBonusResultTrigger Logic Starts
        if(!bonusThresholdInstance.AF_Pilot_Model__c)
        {
            AF_Bonus_Results__c bonResObj = new AF_Bonus_Results__c();
            bonResObj.RecordTypeId = annualBonusRecordTypeId;
            bonResObj.AF_Bonus_Thresholds__c = bonusThresholdInstance.Id;
            bonusResultObjList.add(bonResObj);
        }
        // AF_CreateBonusResultTrigger Logic Ends  
    }
    /**
    * afterUpdate
    *
    * This method is called iteratively for each record updated during an AFTER
    * trigger.
    */
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
    public void afterDelete(SObject so)
    {
        //derived as a part of trigger factory
    }
    /**
    * andFinally
    *
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally()
    {   
        // AF_CreateBonusResultTrigger Logic Starts
        if(!bonusResultObjList.isEmpty())
        {
            try
            {
                insert bonusResultObjList;
            }
            catch(DMLException ex)
            {
                ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),'AF_Bonus_ThresholdHandler','andFinally',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
            }
        }
        // AF_CreateBonusResultTrigger Logic Ends
    }
}