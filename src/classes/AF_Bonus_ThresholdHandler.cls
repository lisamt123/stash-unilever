/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Bonus_ResultsHandler
@CreateDate : 21/6/2014
@Description : This is a controller class for AF_Bonus_Threshold__c
@               
@Version : 1.0
@reference : none
***********************************************************************************/
public with sharing class AF_Bonus_ThresholdHandler implements ITrigger
{
    // AF_CreateBonusResultTrigger Logic Starts
    private List<AF_Bonus_Results__c> bonusResultObjList = new List<AF_Bonus_Results__c>();
    private Id annualBonusRecordTypeId = null;
    private string ErrorMessage=Label.AF_Thershold_Fields;
    /***********************************************************************************
*  @Description: This method is derived as per trigger factory
*           
*  @name : bulkBefore
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void bulkBefore()
    {
    	/*Method is Blank as this handler doesnot handle any bulkBefore*/
    }
     /***********************************************************************************
*  @Description: This method is called prior to execution of an AFTER trigger. 
*                Use this to cache any data required into maps prior execution of the trigger.
*  @name : bulkAfter
*  @param : none
*  @return: boolean.
*************************************************************************************/ 
    public void bulkAfter()
    {
        // AF_CreateBonusResultTrigger Logic Starts
        annualBonusRecordTypeId = [SELECT id FROM recordType WHERE name=:AF_Constants.ANNUAL_BONUS_REC_TYPE AND SobjectType=:AF_Constants.SOBJECT_BONUSRESULT_APINAME].Id;
        // AF_CreateBonusResultTrigger Logic Ends
    }
     /********************************************************************************************
*  @Description: This method is called iteratively for each record to be inserted during a BEFORE
* 					trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
*  @name : beforeInsert
*  @param : none
*  @return: boolean.
*************************************************************************************/
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
     /********************************************************************************************
*  @Description: This method is called iteratively for each record to be updated during a BEFORE
*                trigger
*  @name : beforeUpdate
*  @param : none
*  @return: boolean.
*************************************************************************************/  
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
     /********************************************************************************************
*  @Description: This method is called iteratively for each record to be updated during a BEFORE
*                trigger
*  @name : beforeUpdate
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void beforeDelete(SObject so)
    {
    	/*Method is Blank as this handler doesnot handle any beforeDelete*/
    }
   /********************************************************************************************
*  @Description: This method is called iteratively for each record inserted during an AFTER
*                trigger. Always put field validation in the 'After' methods in case another trigger
*                 has modified any values. The record is 'read only' by this point.
*  @name : afterInsert
*  @param : none
*  @return: boolean.
*************************************************************************************/
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
     /********************************************************************************************
*  @Description: This method is called iteratively for each record updated during an AFTER
*                trigger.
*  @name : afterUpdate
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void afterUpdate(SObject oldSo, SObject so)
    {
    	/*Method is Blank as this handler doesnot handle any afterDelete*/
    }
    /********************************************************************************************
*  @Description: This method is derived as a part of trigger factory
*                
*  @name : afterDelete
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void afterDelete(SObject so)
    {
       /*Method is Blank as this handler doesnot handle any afterDelete*/
    }
     /*************************************************************************************************
*  @Description: This method is called once all records have been processed by the trigger. Use this 
* 				 method to accomplish any final operations such as creation or updates of other records.
*  @name : andFinally
*  @param : none
*  @return: none.
**********************************************************************/
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
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),'AF_Bonus_ThresholdHandler','andFinally',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
            }
        }
        // AF_CreateBonusResultTrigger Logic Ends
    }
}