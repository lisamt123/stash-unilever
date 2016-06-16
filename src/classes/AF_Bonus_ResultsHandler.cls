/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Bonus_ResultsHandler
@CreateDate : 21/6/2014
@Description : This is a controller class for bonus result trigger 
@               
@Version : 1.0
@reference : none
***********************************************************************************/
public without sharing class AF_Bonus_ResultsHandler implements iTrigger
{
    // AF_PreventQual Trigger Logic Starts
    private AF_AnnualBonus_Qual__c custom_Qualatative = null;
    // AF_PreventQual Trigger Logic Ends
    /***********************************************************************************
*  @Description: This method is used to get the instance of annual bonus qual
*           
*  @name : bulkBefore
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void bulkBefore()
    {
        custom_Qualatative = AF_AnnualBonus_Qual__c.getInstance(AF_Constants.ANNUAL_BONUS_QUAL);    
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
        // AF_AfterUpdateBonusResult Logic Starts
        if (!AF_StopRecursiveOcc.hasAlreadyCreated() && !(system.isBatch() || system.isFuture())) 
        {
            AF_AfterUpdateBonusResHandler.AF_AfterUpdHandler((List<AF_Bonus_Results__c>)Trigger.new);  
            AF_StopRecursiveOcc.setAlreadyCreated();       
        }
        // AF_AfterUpdateBonusResult Logic Ends
    }
    /********************************************************************************************
*  @Description: This method is called iteratively for each record to be inserted during a BEFORE
*                trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
*  @name : beforeInsert
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void beforeInsert(SObject so)
    {
        AF_Bonus_Results__c bonusResultInstance = (AF_Bonus_Results__c)so;
        // AF_PreventQual Trigger Logic Starts
        if(bonusResultInstance.AF_Qual__c!=null && (bonusResultInstance.AF_Qual__c > decimal.valueof(custom_Qualatative.name) || bonusResultInstance.AF_Qual__c==0) )
        {
            bonusResultInstance.adderror(Label.AF_Enter_Qual);
        }
        // AF_PreventQual Trigger Logic Ends
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
        AF_Bonus_Results__c bonusResultInstance = (AF_Bonus_Results__c)so;
        // AF_PreventQual Trigger Logic Starts
        if(bonusResultInstance.AF_Qual__c!=null && (bonusResultInstance.AF_Qual__c > decimal.valueof(custom_Qualatative.name) || bonusResultInstance.AF_Qual__c==0 ) )
        {
            bonusResultInstance.adderror(Label.AF_Enter_Qual);
        }
        // AF_PreventQual Trigger Logic Ends
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
        //derived as a part of trigger factory
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
        //derived as a part of trigger factory
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
        //derived as a part of trigger factory
    }
    /********************************************************************************************
*  @Description: This method is called iteratively for each record deleted during an AFTER
*                trigger.
*  @name : afterDelete
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void afterDelete(SObject so)
    {
        //derived as a part of trigger factory
    }
    /******************************************************************************************
*  @Description: This method is called once all records have been processed by the trigger.
*                Use this  method to accomplish any final operations such as creation 
*                or updates of other records.
*  @name : andFinally
*  @param : none
*  @return: none.
**********************************************************************/
    public void andFinally()
    {
        //derived as a part of trigger factory
    }
}