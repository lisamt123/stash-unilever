/******************************************** 
*@Author:Cognizant
*@Date:June 2015
*@Description : Handler class for AF_Bonus_Results__c
*********************************************/

public without sharing class AF_Bonus_ResultsHandler implements iTrigger
{
    // AF_PreventQual Trigger Logic Starts
    private AF_AnnualBonus_Qual__c custom_Qualatative = null;
    // AF_PreventQual Trigger Logic Ends
    
    
    public void bulkBefore()
    {
        custom_Qualatative = AF_AnnualBonus_Qual__c.getInstance(AF_Constants.ANNUAL_BONUS_QUAL);    
    }
    
    /**
     * bulkAfter
     *
     * This method is called prior to execution of an AFTER trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
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
    
    /**
     * beforeInsert
     *
     * This method is called iteratively for each record to be inserted during a BEFORE
     * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
     */
    public void beforeInsert(SObject so)
    {
        
        AF_Bonus_Results__c bonusResultInstance = (AF_Bonus_Results__c)so;
        
        // AF_PreventQual Trigger Logic Starts
        if(bonusResultInstance.AF_Qual__c!=null && (bonusResultInstance.AF_Qual__c > decimal.valueof(custom_Qualatative.name) || bonusResultInstance.AF_Qual__c==0) )
        {
            bonusResultInstance.adderror('Please enter qual value between 1-5');
        }
        // AF_PreventQual Trigger Logic Ends
         
    }
    
    /**
     * beforeUpdate
     *
     * This method is called iteratively for each record to be updated during a BEFORE
     * trigger.
     */
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        AF_Bonus_Results__c bonusResultInstance = (AF_Bonus_Results__c)so;
        
        // AF_PreventQual Trigger Logic Starts
        if(bonusResultInstance.AF_Qual__c!=null && (bonusResultInstance.AF_Qual__c > decimal.valueof(custom_Qualatative.name) || bonusResultInstance.AF_Qual__c==0 ) )
        {
           bonusResultInstance.adderror('Please enter qual value between 1-5');
        }
        // AF_PreventQual Trigger Logic Ends
    }

    /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger.
     */
    public void beforeDelete(SObject so)
    {
        //derived as a part of trigger factory
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
        //derived as a part of trigger factory
    }

    /**
     * afterUpdate
     *
     * This method is called iteratively for each record updated during an AFTER
     * trigger.
     */
    public void afterUpdate(SObject oldSo, SObject so)
    {
         //derived as a part of trigger factory
    }

    /**
     * afterDelete
     *
     * This method is called iteratively for each record deleted during an AFTER
     * trigger.
     */
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
        //derived as a part of trigger factory
    }
}