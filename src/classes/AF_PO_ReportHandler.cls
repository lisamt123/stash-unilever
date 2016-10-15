/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_PO_ReportHandler 
@CreateDate : 21/6/2014
@Description : This is a controller class for trigger's 
@        this is used to update the porepot object
@Version : 1.0
@reference : none
***********************************************************************************/
public with sharing class AF_PO_ReportHandler implements ITrigger
{
	set<String> compundKeySet = new set<String>();
	Map<String,String> compundKeyReportType = new Map<String,String>();
	/*****************************************************************************************
*  @Description: This method derived as a part of trigger factory
*                
*  @name : bulkBefore
*  @param : none
*  @return: none.
*************************************************************************************/
	public void bulkBefore()
	{
		/*Method is Blank as this handler doesnot handle any bulkBefore*/
	}
	/*****************************************************************************************
*  @Description: This method is called prior to execution of an AFTER trigger. Use this to cache
*                any data required into maps prior execution of the trigger.
*  @name : bulkAfter
*  @param : none
*  @return: none.
*************************************************************************************/
	public void bulkAfter()
	{
		if(Trigger.isInsert || Trigger.isUpdate)
		{
			if(AF_checkRecursivePOReport.run)
			{ 
				List<AF_PO_Report__c> POReportInstance = (List<AF_PO_Report__c>)trigger.new;
				for(AF_PO_Report__c  poReport : POReportInstance)
				{
					compundKeyReportType.put(poReport.AF_Compound_Key__c,poReport.AF_PO_Report_Type__c);
					compundKeySet.add(poReport.AF_Compound_Key__c);
				}
				AF_checkRecursivePOReport.run=false;
			}            
		}
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
	/******************************************************************************************
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
	/******************************************************************************************
*  @Description: This method is called iteratively for each record to be deleted during a BEFORE
*                trigger.
*  @name : beforeDelete
*  @param : none
*  @return: none.
*************************************************************************************/
	public void beforeDelete(SObject so)
	{
		// AF_POreport_Delete Trigger logic Starts
		// AF_POreport_Delete Trigger logic ends
	}
	/********************************************************************************************
*  @Description: This method is derived as a part of trigger factory
*  @name : afterInsert
*  @param : none
*  @return: none.
*************************************************************************************/
	public void afterInsert(SObject so)
	{
		/*Method is Blank as this handler doesnot handle any afterInsert*/
	}
	/********************************************************************************************
*  @Description: This method is called iteratively for each record updated during an AFTER
*                trigger.
*  @name : afterUpdate
*  @param : none
*  @return: none.
*************************************************************************************/
	public void afterUpdate(SObject oldSo, SObject so)
	{
		/*Method is Blank as this handler doesnot handle any afterUpdate*/
	}
	/********************************************************************************************
*  @Description: This method is called iteratively for each record deleted during an AFTER
*                 trigger.
*  @name : afterDelete
*  @param : none
*  @return: none.
*************************************************************************************/
	public void afterDelete(SObject so)
	{
		/*Method is Blank as this handler doesnot handle any afterDelete*/
	}
	/********************************************************************************************
*  @Description: This method is called once all records have been processed by the trigger. Use this 
*                method to accomplish any final operations such as creation or updates of 
*                 other records.
*  @name : andFinally
*  @param : none
*  @return: none.
*************************************************************************************/
	public void andFinally()
	{
		if(compundKeySet.size()>0)
		{
			AF_GetBaseFeePOData.CalculatePoReportValues(compundKeyReportType,compundKeySet);
		}  
	}
}