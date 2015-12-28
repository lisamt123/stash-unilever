/******************************************** 
*@Author:Cognizant
*@Date:June 2015
*@Description : Handler class for AF_Bonus_Matrix__c
*********************************************/

public without sharing class AF_Bonus_MatrixHandler implements iTrigger 
{
    // AF_UpdateBonusMatrix Trigger Logic Starts
    private List<AF_Bonus_Matrix__c> BonusMatrixRecords=new   List<AF_Bonus_Matrix__c>();
    // AF_UpdateBonusMatrix Trigger Logic Ends
    
    public void bulkBefore()
    {
        //derived as a part of trigger factory
    }
    
    /**
     * bulkAfter
     *
     * This method is called prior to execution of an AFTER trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkAfter()
    {
        //derived as a part of trigger factory
    }
    
    /**
     * beforeInsert
     *
     * This method is called iteratively for each record to be inserted during a BEFORE
     * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
     */
    public void beforeInsert(SObject so)
    {
        AF_Bonus_Matrix__c bonusMtxInstance = (AF_Bonus_Matrix__c)so;
                
        // AF_UpdateBonusMatrix Trigger Logic Starts
        BonusMatrixRecords.add(bonusMtxInstance);
        // AF_UpdateBonusMatrix Trigger Logic Ends
         
    }
    
    /**
     * beforeUpdate
     *
     * This method is called iteratively for each record to be updated during a BEFORE
     * trigger.
     */
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        AF_Bonus_Matrix__c bonusMtxInstance = (AF_Bonus_Matrix__c)so;
        AF_Bonus_Matrix__c oldBonusMtxInstance = (AF_Bonus_Matrix__c)so;
        
        // AF_UpdateBonusMatrix Trigger Logic Starts
        if(bonusMtxInstance.AF_Status__c!= AF_Constants.BASE_FEES_READYFORPO && oldBonusMtxInstance.AF_Status__c != AF_Constants.BASE_FEES_READYFORPO)
        {
            BonusMatrixRecords.add(bonusMtxInstance);
        }
        // AF_UpdateBonusMatrix Trigger Logic Ends
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
        // AF_UpdateBonusMatrix Trigger Logic Starts
        if( Trigger.isBefore && (Trigger.isBefore || Trigger.isInsert) &&  !BonusMatrixRecords.isEmpty() )
        {   
            AF_UpdateBonusEstimatesValues5.UpdateExchageRates(Trigger.new);
        }
        // AF_UpdateBonusMatrix Trigger Logic Ends
    }   

}