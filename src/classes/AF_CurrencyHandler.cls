/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_CurrencyHandler 
@CreateDate : 21/5/2014
@Description : This is a Handler class for AF_Currency__c object
@        
@Version : 1.0
@reference : none
***********************************************************************************/
public without sharing class AF_CurrencyHandler implements iTrigger
{
	public void bulkBefore()
	{
		//derived as a part of trigger factory
	}
	/*******************************************************************************************
*  @Description: This method is called prior to execution of an AFTER trigger. Use this to cache
*                any data required into maps prior execution of the trigger.
*  @name : bulkAfter
*  @param : none
*  @return: none.
*************************************************************************************/
	public void bulkAfter()
	{
		//derived as a part of trigger factory
	}
	/***********************************************************************************************
*  @Description: This method is called iteratively for each record to be inserted during a BEFORE
*                trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
*  @name : beforeInsert
*  @param : none
*  @return: none.
*************************************************************************************/ 
	public void beforeInsert(SObject so)
	{   
		//derived as a part of trigger factory
	}
	/***********************************************************************************************
*  @Description: This method is called iteratively for each record to be updated during a BEFORE
*               trigger.
*  @name : beforeUpdate
*  @param : none
*  @return: none.
*************************************************************************************/
	public void beforeUpdate(SObject oldSo, SObject so)
	{
		AF_Currency__c currencyInstance = (AF_Currency__c)so;
		AF_Currency__c oldCurrencyInstance = (AF_Currency__c)oldSo;
		// AF_lockPreviousYear Trigger Logic Starts
		if(currencyInstance.Locked__c && currencyInstance.AF_Average_Exchange_Rate_To_EUR__c != oldCurrencyInstance.AF_Average_Exchange_Rate_To_EUR__c)
		{
			currencyInstance.AF_Average_Exchange_Rate_To_EUR__c.adderror(Label.AF_Lock);
		} 
		if(currencyInstance.AF_Fiscal_Year_new__c != null && integer.valueof(currencyInstance.AF_Fiscal_Year_new__c) < date.today().year())
		{
			currencyInstance.locked__c = true;
		}
		// AF_lockPreviousYear Trigger Logic Ends
	}
	/***********************************************************************************************
*  @Description: This method is called iteratively for each record to be deleted during a BEFORE
*                trigger.
*  @name : beforeDelete
*  @param : none
*  @return: none.
*************************************************************************************/   
	public void beforeDelete(SObject so)
	{
		//derived as a part of trigger factory
	}
	/***********************************************************************************************
*  @Description:  This method is called iteratively for each record inserted during an AFTER
*                 trigger. Always put field validation in the 'After' methods in case 
*                 another trigger has modified any values. The record is 'read only' by this point.
*  @name : afterInsert
*  @param : none
*  @return: none.
*************************************************************************************/   
	public void afterInsert(SObject so)
	{
		//derived as a part of trigger factory
	}
	/***********************************************************************************************
*  @Description:  This method is called iteratively for each record updated during an AFTER
*                 trigger.
*  @name : afterUpdate
*  @param : none
*  @return: none.
*************************************************************************************/   
	public void afterUpdate(SObject oldSo, SObject so)
	{
		//derived as a part of trigger factory 
	}
	/***********************************************************************************************
*  @Description:  This method is called iteratively for each record updated during an AFTER
*                 trigger.
*  @name : afterDelete
*  @param : none
*  @return: none.
*************************************************************************************/  
	public void afterDelete(SObject so)
	{
		//derived as a part of trigger factory
	}
	/***********************************************************************************************
*  @Description:  This method is called once all records have been processed by the trigger. 
*                 Use this  method to accomplish any final operations such as creation 
*                  or updates of other records.
*  @name : andFinally
*  @param : none
*  @return: none.
*************************************************************************************/  
	public void andFinally()
	{
		//derived as a part of trigger factory
	}
}