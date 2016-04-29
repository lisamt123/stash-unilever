/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_OOPSActualHandler
@CreateDate : 21/6/2014
@Description : This is a controller class for trigger's 
@              for oops actucal object
@Version : 1.0
@reference : none
***********************************************************************************/
public with sharing class AF_OOPSActualHandler implements ITrigger{
	// AF_UpdateCatFinanceApprover Trigger Logic starts
	private List<AF_OOPS_Actual__c>  afOopsEstimates=new List<AF_OOPS_Actual__c>();
	// AF_UpdateCatFinanceApprover Trigger Logic Ends
	// AF_AfterUpdateOOPSActual Trigger Logic Starts
	private List<AF_OOPS_Actual__c> recalculateEstimateList = new List<AF_OOPS_Actual__c>();
	// AF_AfterUpdateOOPSActual Trigger Logic Ends
	// AF_OopsPOreport_Delete Trigger Logic Starts 
	private Set<Id> OOPSDeleteActualIds = new Set<Id>();
	// AF_OopsPOreport_Delete Trigger Logic Ends
	private static string className_STR=AF_OOPSActualHandler.class.getName();
	/***********************************************************************************
*  @Description: this method is used to add the records to the list whose 
*                status is with category finance              
*  @name : bulkBefore
*  @param : none
*  @return: none.
*************************************************************************************/  
	public void bulkBefore()
	{
		// AF_UpdateCatFinanceApprover Trigger Logic starts
		if(Trigger.isUpdate || Trigger.isInsert)
		{
			List<AF_OOPS_Actual__c> selectiveActualList = new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c afOops:(List<AF_OOPS_Actual__c>)Trigger.new)
			{
				if(afOops.AF_Agency_lk__c != null)
				{
					selectiveActualList.add(afoops);
				}
				if(afOops.AF_Status__c == AF_Constants.CATEGORY_FINANCE){
					afOopsEstimates.add(afOops);
				}
			}
			if( !afOopsEstimates.isEmpty() )
			{
				AF_UpdateOopsEstimateCatApproverValues.updateOopsagencyBulk(selectiveActualList);
			}
			if( !afOopsEstimates.isEmpty() )
			{
				AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(afOopsEstimates);
			}
		}
		// AF_UpdateCatFinanceApprover Trigger Logic ends
	}
	/**************************************************************************************
*  @Description: This method is derived as a part of trigger factory
*                
*  @name : bulkAfter
*  @param : none
*  @return: none.
*************************************************************************************/   
	public void bulkAfter()
	{
		/*Method is Blank as this handler doesnot handle any beforeAfter*/
	}
	/********************************************************************************************
*  @Description: This method is derived as a part of trigger factory
*                
*  @name : beforeInsert
*  @param : none
*  @return: none.
*************************************************************************************/   
	public void beforeInsert(SObject so)
	{
		/*Method is Blank as this handler doesnot handle any beforeInsert*/
	}
	/********************************************************************************************
*  @Description: This method is derived as a part of trigger factory
*               
*  @name : beforeUpdate
*  @param : none
*  @return: none.
*************************************************************************************/ 
	public void beforeUpdate(SObject oldSo, SObject so)
	{
		/*Method is Blank as this handler doesnot handle any beforeUpdate*/
	}
	/********************************************************************************************
*  @Description: This method is called iteratively for each record to be deleted during a 
*                BEFORE trigger.
*  @name : beforeDelete
*  @param : none
*  @return: none.
*************************************************************************************/ 
	public void beforeDelete(SObject so)
	{
		AF_OOPS_Actual__c OOPSActualInstance = (AF_OOPS_Actual__c)so;
		// AF_OopsPOreport_Delete Trigger Logic Starts
		OOPSDeleteActualIds.add(OOPSActualInstance.Id);
		// AF_OopsPOreport_Delete Trigger Logic Ends
	}
	/*************************************************************************************************
*  @Description: This method is called iteratively for each record inserted during an AFTER
*                trigger. Always put field validation in the 'After' methods in case 
*                another trigger has modified any values. The record is 'read only' by this point.
*  @name : afterInsert
*  @param : none
*  @return: none.
*************************************************************************************/ 
	public void afterInsert(SObject so)
	{
		/*Method is Blank as this handler doesnot handle any afterInsert*/	
	}
	/*************************************************************************************************
*  @Description: This method is called iteratively for each record updated during an AFTER
*               trigger.
*  @name : afterUpdate
*  @param : none
*  @return: none.
*************************************************************************************/
	public void afterUpdate(SObject oldSo, SObject so)
	{
		AF_OOPS_Actual__c OOPSActualInstance = (AF_OOPS_Actual__c)so;
		AF_OOPS_Actual__c oldOOPSActualInstance = (AF_OOPS_Actual__c)oldSo;
		// AF_AfterUpdateOOPSActual Trigger Logic Starts
		if(oldOOPSActualInstance.Overall__c != OOPSActualInstance.Overall__c && !OOPSActualInstance.AF_iS_OOPS_Percentage__c)
		{               
			recalculateEstimateList.add(OOPSActualInstance);
		}
		// AF_AfterUpdateOOPSActual Trigger Logic Ends      
	}
	/*************************************************************************************************
*  @Description: This method is called iteratively for each record deleted during an AFTER
*               trigger.
*  @name : afterDelete
*  @param : none
*  @return: none.
*************************************************************************************/ 
	public void afterDelete(SObject so)
	{
		/*Method is Blank as this handler doesnot handle any afterDelete*/	
	}
	/******************************************************************************************************
*  @Description: This method is called once all records have been processed by the trigger. Use this 
*               method to accomplish any final operations such as creation or updates of other records.
*  @name : andFinally
*  @param : none
*  @return: none.
*************************************************************************************/ 
	public void andFinally()
	{   
		// AF_AfterUpdateOOPSActual Trigger Logic Starts
		if( !recalculateEstimateList.isEmpty() && !AF_RecursiveTriggerHelper.isAlreadyModified())
		{
			AF_OOPSRecordManager OOPSRecordManager = new AF_OOPSRecordManager();
			OOPSRecordManager.bulkOOPSActualList = recalculateEstimateList;
			OOPSRecordManager.bulkRecalculateOOPSEstimates();
		}
		// AF_AfterUpdateOOPSActual Trigger Logic Ends
		// AF_OopsPOreport_Delete Trigger Logic Starts
		if(!OOPSDeleteActualIds.isEmpty())
		{
			try
			{
				List<AF_OOPS_Estimate__c> oopsEstRecordList = [SELECT Id FROM AF_OOPS_Estimate__c WHERE AF_OOPS_Actual__c IN :OOPSDeleteActualIds LIMIT 10000];
				if( !oopsEstRecordList.isEmpty())
				{
					delete oopsEstRecordList;
				}
			}
			catch(Exception e)
			{
				system.debug(e);
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'andFinally',e.getMessage(),e.getTypeName(),e.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Delete));
			}
		}
		// AF_OopsPOreport_Delete Trigger Logic Ends
	}
}