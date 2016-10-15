/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Constants
@CreateDate : 2/10/2014
@Description : This is Handler class for AF_Brand_Estimate__c
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_Brand_EstimateHandler implements ITrigger
{
	private List<AF_Brand_Estimate__c> afBrandEstimatesList = new List<AF_Brand_Estimate__c>();
	private List<AF_Brand_Estimate__c> UpdateOopsagencyList = new List<AF_Brand_Estimate__c>();
	private Set<id> brandsWithBaseFeesIds = new Set<id>();
	private Set<String> brandPOEstids = new Set<String>();
	// Af_AfterInsertBrandEstShare Trigger Logic Starts
	private Set<id> BrandEstids = new Set<id>();    
	private List<AF_Agency_Estimate__c> updateAgencyEstimates=new List<AF_Agency_Estimate__c>();
	private List<AF_Agency_Estimate__c> poReportAgencyEstimates=new List<AF_Agency_Estimate__c>();
	private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
	// Af_AfterInsertBrandEstShare Trigger Logic Ends
	/***********************************************************************************
*  @Description: this method is used to query and update the record based on the user type
*  @             and updates the status field of the record 
*  @name : bulkBefore
*  @param : none
*  @return: none.
*************************************************************************************/
	public void bulkBefore()
	{
		if(Trigger.isUpdate || Trigger.isInsert)
		{
			// UpdateCatFinanceApprover Trigger Logic Starts
			List<AF_Brand_Estimate__c> brandEstimateList = (List<AF_Brand_Estimate__c>)trigger.new;
			for(AF_Brand_Estimate__c brandEstimateInstance : brandEstimateList)
			{
				if(brandEstimateInstance.AF_Status_Base_Fees__c == AF_Constants.BASE_FEES_WITH_AGENCY)
				{
					afBrandEstimatesList.add(brandEstimateInstance);
					if(brandEstimateInstance.AF_Agency__c != null)
					{
						UpdateOopsagencyList.add(brandEstimateInstance);
					}
				}
				if(!brandEstimateInstance.TriggerEmailAgency__c)
				{
					brandEstimateInstance.Archived_BrandEstimate_Quarter__c = brandEstimateInstance.AF_Basefee_Estimate_Initial_Quarter__c;
				}
			}
			// UpdateCatFinanceApprover Trigger Logic Ends
			bulkBeforeExt();
		}
		      
	}
	/***********************************************************************************
*  @Description: this method is derived as a part of trigger factory
*  @             
*  @name : bulkAfter
*  @param : none
*  @return: none.
*************************************************************************************/
	public void bulkAfter()
	{
		if(Trigger.IsUpdate){
			// Af_AfterInsertBrandEstShare Trigger Logic Starts
			Set<id> POReportBrandEstids=new set<id>();
			String statusReadyForPO = AF_Constants.BASE_FEES_READYFORPO;
			for(AF_Brand_Estimate__c  brand:(List<AF_Brand_Estimate__c>)Trigger.new)   
			{
				AF_Brand_Estimate__c oldBrandEstimate = (AF_Brand_Estimate__c)Trigger.oldMap.get(brand.id);
				if(oldBrandEstimate.AF_Status_Base_Fees__c != statusReadyForPO &&  brand.AF_Status_Base_Fees__c== statusReadyForPO )            
				{               
					BrandEstids.add(brand.Id);      
				}
				//PO Report
				if(oldBrandEstimate.AF_Status_Base_Fees__c != brand.AF_Status_Base_Fees__c){
					POReportBrandEstids.add(brand.Id);
				}             
			}
			if( !BrandEstids.isEmpty() )  
			{      
				for(AF_Agency_Estimate__c agencyEst:[SELECT id,Name,AF_Status__c,AF_Agency_Entity__c,AF_Unilever_Entity__c,AF_Agency_Spot_Rate__c,Unilever_Code__c,
				AF_Agency_Exchange_Rate__c,AF_Traditional__c,AF_Traditional_Local__c ,AF_Digital__c,AF_Digital_Local__c,
				AF_Adaptation__c ,AF_Adaptation_Local__c,Indicative_Gain_in_USD__c,Indicative_Gain_Loss_in_EUR__c,
				AF_Matrix_Data_Entry_Currency__c,AF_Ready_For_PO_Entry_Currency__c FROM AF_Agency_Estimate__c   
				WHERE AF_Brand_Estimate__c IN : BrandEstids limit 10000 ])
				{ 
					if(agencyEst.AF_Status__c!= statusReadyForPO )
					{  
						agencyEst.AF_Status__c = statusReadyForPO;
						updateAgencyEstimates.add(agencyEst);  
					}         
				}
			}  
			if( !POReportBrandEstids.isEmpty() )
			{
				for(AF_Agency_Estimate__c agencyEst:[SELECT AF_Status__c,AF_Brand_Estimate__r.AF_Status_Base_Fees__c FROM AF_Agency_Estimate__c 
				WHERE AF_Brand_Estimate__c IN : POReportBrandEstids limit 10000 ])
				{ 
					if(agencyEst.AF_Brand_Estimate__r.AF_Status_Base_Fees__c.length() > 0)
					{  
						agencyEst.AF_Status__c=agencyEst.AF_Brand_Estimate__r.AF_Status_Base_Fees__c;
						poReportAgencyEstimates.add(agencyEst);  
					}         
				} 
			}
			// Af_AfterInsertBrandEstShare Trigger Logic Ends
		}
	}
	/***********************************************************************************
*  @Description: this method is derived as a part of trigger factory
*  @             
*  @name : beforeInsert
*  @param : none
*  @return: none.
*************************************************************************************/
	public void beforeInsert(SObject so)
	{
		/*Method is Blank as this handler doesnot handle any beforeInsert*/
	}
	/***********************************************************************************
*  @Description: this method is derived as a part of trigger factory
*  @             
*  @name : beforeUpdate
*  @param : none
*  @return: none.
*************************************************************************************/
	public void beforeUpdate(SObject oldSo, SObject so)
	{
		/*Method is Blank as this handler doesnot handle any beforeUpdate*/
	}
	/**********************************************************************************************
*  @Description: this method is iteratively for each record to be deleted during a BEFORE trigger
*  @             
*  @name : beforeUpdate
*  @param : none
*  @return: none.
*************************************************************************************/
	public void beforeDelete(SObject so)
	{
		// AF_POreport_Delete Trigger logic Starts
		BrandPOEstids.add(so.Id);
		// AF_POreport_Delete Trigger logic ends
	}
	/**********************************************************************************************
*  @Description: this method is derived as a part of trigger factory
*  @             
*  @name : afterInsert
*  @param : none
*  @return: none.
*************************************************************************************/
	public void afterInsert(SObject so)
	{
		/*Method is Blank as this handler doesnot handle any afterInsert*/
	}
	/**********************************************************************************************
*  @Description: this method is iteratively for each record updated during an AFTER trigger
*  @             
*  @name : afterUpdate
*  @param : none
*  @return: none.
*************************************************************************************/
	public void afterUpdate(SObject oldSo, SObject so)
	{
		AF_Brand_Estimate__c brandEstimateInstance = (AF_Brand_Estimate__c)so;
		AF_Brand_Estimate__c oldBrandEstimateInstance = (AF_Brand_Estimate__c)oldSo;
		// AF_Brand_Controller_Review Trigger Logic Starts      
		if(brandEstimateInstance.AF_Status_Base_Fees__c !=null && brandEstimateInstance.AF_Status_Base_Fees__c == AF_Constants.BASE_FEES_WIHTCMCO && brandEstimateInstance.AF_Category_Finance_Approved__c)
		{
			brandsWithBaseFeesIds.add(brandEstimateInstance.id);
		}
		// AF_Brand_Controller_Review Trigger Logic ends
		// AF_POreport_Delete Trigger logic Starts
		if( (!brandEstimateInstance.AF_Dont_Show_on_Report__c && oldBrandEstimateInstance.AF_Dont_Show_on_Report__c && 
					brandEstimateInstance.AF_Active__c && !oldBrandEstimateInstance.AF_Active__c ) ||
				(brandEstimateInstance.AF_Basefee_Estimate_Initial_Quarter__c!= oldBrandEstimateInstance.AF_Basefee_Estimate_Initial_Quarter__c) )
		{
			BrandPOEstids.add(brandEstimateInstance.Id);
		}
		// AF_POreport_Delete Trigger logic Ends 
	}
	/**********************************************************************************************
*  @Description: this method is derived as a part of trigger factory
*  @             
*  @name : afterDelete
*  @param : none
*  @return: none.
*************************************************************************************/
	public void afterDelete(SObject so)
	{
		/*Method is Blank as this handler doesnot handle any afterDelete*/
	}
	/***************************************************************************************
*  @Description: this method is used to query and update the record in the object, based on
*  @             the parent object action, update,delete will be actioned on childobject
*  @name : andFinally
*  @param : none
*  @return: none.
*************************************************************************************/
	public void andFinally()
	{  
		string  andfinally='andFinally';
		// UpdateCatFinanceApprover Trigger Logic Starts
		if( !UpdateOopsagencyList.isEmpty() )
		{
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagencyBulk(UpdateOopsagencyList);
		}
		if( !afBrandEstimatesList.isEmpty() )
		{  
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(afBrandEstimatesList);
		}
		// UpdateCatFinanceApprover Trigger Logic Ends
		// AF_Brand_Controller_Review Trigger Logic Starts
		if(AF_CheckRecursive.run && !brandsWithBaseFeesIds.isempty())
		{
			AF_Brand_Controller_Review brandControllerObj = new AF_Brand_Controller_Review();
			AF_CheckRecursive.run=false;
			brandControllerObj.Create_Review(brandsWithBaseFeesIds);
		}
		// AF_Brand_Controller_Review Trigger Logic Ends 
		// Af_AfterInsertBrandEstShare Trigger Logic Starts
		If( !updateAgencyEstimates.isEmpty() )
		{
			try{
			update updateAgencyEstimates;
			}
			 catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,andfinally,e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
	        }
		}
		If( !poReportAgencyEstimates.isEmpty() )
		{
			try{
			update poReportAgencyEstimates;
			}
			 catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,andfinally,e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
	        }
		}
		if( !BrandEstids.isEmpty() )
		{
			AF_OOPSRecordManagerAsyncWrapper.CreateOOPSEstimateRecordsByCollection(BrandEstids);
			AF_BonusRecordManagerAsyncWrapper.CreateMultiObjectRecordsAsync(BrandEstids);
		}
		// Af_AfterInsertBrandEstShare Trigger Logic Ends
		 addFinallyExt();
	}
	
	public void bulkBeforeExt(){
		if(Trigger.isUpdate)
		{
			// Af_locking Logic Starts
			Set<Id> userinContextSet = new Set<Id>();
			Set<Id> userWithPermSet = new Set<Id>();
			List<AF_Brand_Estimate__c> brandEstimateList = (List<AF_Brand_Estimate__c>)trigger.new;
			Map<Id,AF_Brand_Estimate__c> existingBrandEstMap = (Map<Id,AF_Brand_Estimate__c>)trigger.OldMap;
			for(AF_Brand_Estimate__c incomingBrandEst : brandEstimateList)
			{
				AF_Brand_Estimate__c existingBrandEst = existingBrandEstMap.get(incomingBrandEst.id);
				if(existingBrandEst.AF_Locked__c && incomingBrandEst.AF_Locked__c)
				{
					userinContextSet.add(UserInfo.getUserId());
				}
			}
			for(permissionsetassignment incontextPermSet : [SELECT AssigneeId,Id,PermissionSetId FROM PermissionSetAssignment WHERE PermissionSet.name=: AF_Constants.PERM_CMCO_SUPERUSER and assigneeid in: userinContextSet LIMIT 10000])
			{
				if(incontextPermSet.assigneeId != null)
				{
					userWithPermSet.add(incontextPermSet.assigneeId);
				}
			}
			for(AF_Brand_Estimate__c incomingBrandEst : brandEstimateList)
			{
				AF_Brand_Estimate__c existingBrandEst = (AF_Brand_Estimate__c)existingBrandEstMap.get(incomingBrandEst.id);
				if(existingBrandEst.AF_Locked__c && incomingBrandEst.AF_Locked__c && !userWithPermSet.contains(userinfo.getuserid()))
				{
					incomingBrandEst.adderror(Label.AF_Record_Locked);
				}
			}
			// Af_locking Logic Ends    
		} 
	}
	
	public void addFinallyExt(){
		string addFinallyExt='addFinallyExt';
		// AF_POreport_Delete Trigger logic Starts
		if(!BrandPOEstids.isEmpty()){
			try{
				List<AF_Agency_Estimate__c>  agencyEstRecordList = [SELECT Id FROM AF_Agency_Estimate__c WHERE AF_Brand_Estimate__c IN :BrandPOEstids LIMIT 50000];
				if(!agencyEstRecordList.isEmpty())
				{
					if(Trigger.isUpdate && Trigger.isAfter)
					{
						try{
						update agencyEstRecordList;
						}
						 catch(Exception e)
					        {
					            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,addFinallyExt,e.getMessage(),e.getTypeName(),e.getStackTraceString());
					            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
					        }
					}
					else if(Trigger.isDelete && Trigger.isBefore)
					{
						try{
						delete agencyEstRecordList;
						}
						catch(Exception e)
					        {
					            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,addFinallyExt,e.getMessage(),e.getTypeName(),e.getStackTraceString());
					            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Delete)); 
					        }
					}
				}
			}
			catch(Exception e)
			{
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,addFinallyExt,e.getMessage(),e.getTypeName(),e.getStackTraceString());
				system.debug(e);
			}
		}
		// AF_POreport_Delete Trigger logic Finshes
	}
}