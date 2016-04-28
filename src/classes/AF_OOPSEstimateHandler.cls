/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_OOPSEstimateHandler
@CreateDate : 21/6/2014
@Description : This is a controller class for trigger's 
@        this is used in oops estimate object
@Version : 1.0
@reference : none
***********************************************************************************/
public with sharing class AF_OOPSEstimateHandler implements ITrigger {
	private Set<id> OopsEstids = new Set<id>();
	Set<string> Compoundkey =new Set<string> ();
	Set<Id> OopsEstiamteId=new Set<Id>();
	list<AF_OOPS_Estimate__c> oopsEstimateList = new list<AF_OOPS_Estimate__c>();
	boolean errordisplay=false; 
	Set<String> quarter = new Set<String>();
	List<String> quarterList = new List<String>();
	String quarterInfo='';
	String OopsActualName=''; 
	Boolean deletePOReport = false;
	list<AF_OOPS_Estimate__c> oopsEstimatesRecords = new list<AF_OOPS_Estimate__c>();
	Integer count=0;
	/****************************************************************************************
*  @Description: this method is used to query the new records and checks the compound key and
*                delete the records                  
*  @name : bulkBefore
*  @param : none
*  @return: none.
*************************************************************************************/
	public void bulkBefore()
	{
		if(Trigger.isDelete){
			for(AF_OOPS_Estimate__c oopsEst:(List<AF_OOPS_Estimate__c>)trigger.old){
				if( oopsEst.id!=null && oopsEst.AF_Compound_key__c!=null){
					OopsEstiamteId.add(oopsEst.Id);
					Compoundkey.add(oopsEst.AF_Compound_key__c);
					quarter.add(oopsEst.AF_Mean_Quarter__c);
				}
			}
			quarterList.addAll(quarter);
			if(quarterList.size()>0){
				quarterInfo = quarterList[0];
			}
			oopsEstimateList =[select id, Name, AF_Adaptation__c, AF_Digital__c,AF_Brand__c, AF_Brand_Estimate__c, AF_Agency_Entity__c, AF_Unilever_Entity__c,  AF_Traditional__c, AF_Brand_Estimate__r.AF_Agency__c,AF_OOPS_Actual__r.Name  from AF_OOPS_Estimate__c WHERE id NOT IN:OopsEstiamteId and AF_Compound_key__c IN:Compoundkey ]; 
			for(AF_OOPS_Estimate__c  oopslist:oopsEstimateList){
				OopsActualName = oopslist.AF_OOPS_Actual__r.Name;
				if(OopsActualName.contains(quarterInfo) && (oopslist.AF_Digital__c>0 || oopslist.AF_Adaptation__c>0 ||  oopslist.AF_Traditional__c>0 )){
					errordisplay=true;
				}
				OopsActualName='';
			}
			for(AF_OOPS_Estimate__c OOPSEstimateOldtrigger :(List<AF_OOPS_Estimate__c>)trigger.old){
				If(errordisplay)
				OOPSEstimateOldtrigger.adderror(Label.AF_Base_Fees);
			} 
		}
	}
	/***********************************************************************************
*  @Description: This method is called prior to execution of an AFTER trigger.
*               Use this to cache any data required into maps prior execution of the trigger.
*  @name : bulkAfter
*  @param : none
*  @return: none.
*************************************************************************************/
	public void bulkAfter()
	{
		/*Method is Blank as this handler doesnot handle any bulkAfter*/
	}
	/*********************************************************************************************
*  @Description: This method is called iteratively for each record to be inserted during a BEFORE
*                trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
*  @name : beforeInsert
*  @param : none
*  @return: none.
*************************************************************************************/
	public void beforeInsert(SObject so)
	{
		AF_OOPS_Estimate__c OOPSEstimateInstance = (AF_OOPS_Estimate__c)so;
		//AF_UpdateOopsEstimate Trigger Logic Starts
		oopsEstimatesRecords.add(OOPSEstimateInstance);
		//AF_UpdateOopsEstimate Trigger Logic Ends
	}
	/***********************************************************************************
*  @Description: This method is called iteratively for each record to be updated 
*                during a BEFORE trigger.
*  @name : beforeUpdate
*  @param : none
*  @return: none.
*************************************************************************************/
	public void beforeUpdate(SObject oldSo, SObject so)
	{
		AF_OOPS_Estimate__c OOPSEstimateInstance = (AF_OOPS_Estimate__c)so;
		AF_OOPS_Estimate__c oldOOPSEstimateInstance = (AF_OOPS_Estimate__c)oldSo;
		//AF_UpdateOopsEstimate Trigger Logic Starts
		if(OOPSEstimateInstance.AF_Status__c==AF_Constants.BASE_FEES_READYFORPO && oldOOPSEstimateInstance.AF_Status__c==AF_Constants.BASE_FEES_READYFORPO){
			count++;
		}
		else{
			oopsEstimatesRecords.add(OOPSEstimateInstance);
		}
		//AF_UpdateOopsEstimate Trigger Logic Ends
	}
	/***********************************************************************************
*  @Description: This method is called iteratively for each record to be 
*                deleted during a BEFORE trigger.
*  @name : beforeDelete
*  @param : none
*  @return: none.
*************************************************************************************/
	public void beforeDelete(SObject so)
	{
		AF_OOPS_Estimate__c OOPSEstimateInstance = (AF_OOPS_Estimate__c)so;
		//AF_Oops_POReport Trigger Logic Starts
		OopsEstids.add(OOPSEstimateInstance.Id);
		deletePOReport = true;
		//AF_Oops_POReport Trigger Logic Ends
	}
	/***********************************************************************************
*  @Description: This method is called iteratively for each record inserted during an AFTER
*               trigger. Always put field validation in the 'After' methods in case another trigger
*               has modified any values. The record is 'read only' by this point.
*  @name : afterInsert
*  @param : none
*  @return: none.
*************************************************************************************/
	public void afterInsert(SObject so)
	{
		AF_OOPS_Estimate__c OOPSEstimateInstance = (AF_OOPS_Estimate__c)so;
		//AF_Oops_POReport Trigger Logic Starts
		OopsEstids.add(OOPSEstimateInstance.Id);
		//AF_Oops_POReport Trigger Logic Ends
	}
	/***********************************************************************************
*  @Description: This method is called iteratively for each record updated during 
*                an AFTER trigger
*  @name : afterUpdate
*  @param : none
*  @return: none.
*************************************************************************************/
	public void afterUpdate(SObject oldSo, SObject so)
	{
		AF_OOPS_Estimate__c OOPSEstimateInstance = (AF_OOPS_Estimate__c)so;
		//AF_Oops_POReport Trigger Logic Starts
		OopsEstids.add(OOPSEstimateInstance.Id);
		//AF_Oops_POReport Trigger Logic Ends
	}
	/***********************************************************************************
*  @Description: This method is derived as a part of trigger factory
*               
*  @name : afterDelete
*  @param : none
*  @return: none.
*************************************************************************************/
	public void afterDelete(SObject so)
	{
		/*Method is Blank as this handler doesnot handle any afterDelete*/
	}
	/**************************************************************************************
*  @Description: This method is called once all records have been processed by the trigger.
*                Use this method to accomplish any final operations such as creation or 
*                 updates of other records.
*  @name : andFinally
*  @param : none
*  @return: none.
*************************************************************************************/
	public void andFinally()
	{   
		//AF_Oops_POReport Trigger Logic Starts
		if( !OopsEstids.isEmpty() )
		{
			AF_GetBaseFeePOData.CreatePOReportFromOopsEstimate(OopsEstids,deletePOReport);
		}
		//AF_Oops_POReport Trigger Logic Ends
		//AF_UpdateOopsEstimate Trigger Logic Starts
		if( !oopsEstimatesRecords.isEmpty() )
		{
			AF_UpdateOopsEstimatesValues5.UpdateExchageRates(oopsEstimatesRecords);
		}
		//AF_UpdateOopsEstimate Trigger Logic Ends
	}
}