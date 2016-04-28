/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Bonus_MatrixHandler
@CreateDate : 21/6/2014
@Description : This is a controller class for bonus matrix trigger
@             
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public without sharing class AF_Bonus_MatrixHandler implements iTrigger 
{
    // AF_UpdateBonusMatrix Trigger Logic Starts
    private List<AF_Bonus_Matrix__c> BonusMatrixRecords=new   List<AF_Bonus_Matrix__c>();
    // AF_UpdateBonusMatrix Trigger Logic Ends
    Integer count=0;
    /***********************************************************************************
*  @Description: this method is derived as a part of trigger factory
*  @name : bulkBefore
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void bulkBefore()
    {
    	/*Method is Blank as this handler doesnot handle any bulkBefore*/
    }
    /***********************************************************************************
*  @Description: This method is derived as a part of trigger factory
*            
*  @name : bulkAfter
*  @param : none
*  @return: boolean.
*************************************************************************************/   
    public void bulkAfter()
    {
    	/*Method is Blank as this handler doesnot handle any beforeAfter*/
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
        AF_Bonus_Matrix__c bonusMtxInstance = (AF_Bonus_Matrix__c)so;
        // AF_UpdateBonusMatrix Trigger Logic Starts
        BonusMatrixRecords.add(bonusMtxInstance);
        // AF_UpdateBonusMatrix Trigger Logic Ends
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
        AF_Bonus_Matrix__c bonusMtxInstance = (AF_Bonus_Matrix__c)so;
        AF_Bonus_Matrix__c oldBonusMtxInstance = (AF_Bonus_Matrix__c)oldSo;
        // AF_UpdateBonusMatrix Trigger Logic Starts
        if(bonusMtxInstance.AF_Status__c==AF_Constants.BASE_FEES_READYFORPO && oldBonusMtxInstance.AF_Status__c==AF_Constants.BASE_FEES_READYFORPO){
            count++;
        }
        else{
            BonusMatrixRecords.add(bonusMtxInstance);
        }
        // AF_UpdateBonusMatrix Trigger Logic Ends
    }
    /********************************************************************************************
*  @Description: This method is derived as a part of trigger factory
*                
*  @name : beforeDelete
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void beforeDelete(SObject so)
    {
    	/*Method is Blank as this handler doesnot handle any beforeDelete*/
    }
    /********************************************************************************************
*  @Description: This method is derived as a part of trigger factory
*                
*  @name : afterInsert
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void afterInsert(SObject so)
    {
    	/*Method is Blank as this handler doesnot handle any afterInsert*/
    }
    /********************************************************************************************
*  @Description: This derived as a part of trigger factory
*                
*  @name : afterUpdate
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void afterUpdate(SObject oldSo, SObject so)
    {
    	/*Method is Blank as this handler doesnot handle any afterUpdate*/
    }
    /********************************************************************************************
*  @Description: this derived as a part of trigger factory
*                
*  @name : afterDelete
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void afterDelete(SObject so)
    {
    	/*Method is Blank as this handler doesnot handle any afterDelete*/
    }
    /**********************************************************************************************************
*  @Description: This method is called once all records have been processed by the trigger. Use this 
*               method to accomplish any final operations such as creation or updates of other records.
*  @name : andFinally
*  @param : none
*  @return: none.
**********************************************************************/
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