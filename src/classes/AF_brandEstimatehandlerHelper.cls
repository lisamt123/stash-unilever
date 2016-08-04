/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_brandEstimatehandlerHelper
@CreateDate : 3/11/15
@Description : This is a controller class for User object trigger, 
@			  this is used to update the latest cat finance users and agency users in BrandEstimate.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
global with sharing class AF_brandEstimatehandlerHelper{
	global static boolean testvar=false;
	public static Map<Id,Id> brandWorkitem = new Map<Id,Id>();
	public static List<AF_Brand_Estimate__c> brandEstimateList = new  List<AF_Brand_Estimate__c>();
	public static List<AF_Brand_Estimate__c> brandEstupdateList = new  List<AF_Brand_Estimate__c>();
	private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
	public 	static Approval.ProcessResult result;
	public	static Approval.ProcessResult result2;
	/*********************************************************************************************************
*  @Description: this method is used to update the latest catfinnace users and Agency users in BrandEstimate
*  @name : brandEstimatehandlerMethod
*  @param : brandSet
*  @return: none.
**************************************************************************************************************/
	@future
	public static void brandEstimatehandlerMethod(Set<String> brandSet){
		Set<Id> brandEstIdcatfin = new Set<Id>();
		List<AF_Brand_Estimate__c> brandEstWithAgencyList = new List<AF_Brand_Estimate__c>();
		List<AF_Brand_Estimate__c> brandEstList = new  List<AF_Brand_Estimate__c>();
		list<ProcessInstanceWorkitem> workItem=new list<ProcessInstanceWorkitem>();
		testvar=true; 
		brandEstList = [select Id,Brand__r.Name,AF_Status_Base_Fees__c from AF_Brand_Estimate__c where Brand__r.Name IN:brandSet and AF_Active__c=true and AF_Status_Base_Fees__c!=:AF_Constants.BASE_FEES_READYFORPO];
		for(AF_Brand_Estimate__c b:brandEstList){
			if(b.AF_Status_Base_Fees__c==AF_Constants.CATEGORY_FINANCE){
				brandEstIdcatfin.add(b.Id);
				brandEstimateList.add(b);
			}
			if(b.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_WITH_AGENCY){
				brandEstWithAgencyList.add(b);
			}
		}
		if(brandEstWithAgencyList.size()>0){
			try{
			update brandEstWithAgencyList;
			}
			 catch(Exception e)
		        {
		            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'brandEstimatehandlerMethod',e.getMessage(),e.getTypeName(),e.getStackTraceString());
		            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		        }
		}
		workItem  =[Select p.Id,P.ActorId,p.ProcessInstance.TargetObjectId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId IN:brandEstIdcatfin  limit 50000];
		if(workItem.size()>0){
			for(ProcessInstanceWorkitem  pis:workItem){
				if(pis.ActorId!=Label.AF_Dummy_User){
					brandWorkitem.put(pis.ProcessInstance.TargetObjectId,pis.Id);
				}
			}
		}
		brandEstApprovalProcess();
	}
	/*********************************************************************************************************
*  @Description: this method is used to reject and update the latest catfinance users in BrandEstimate
*  @name : brandEstApprovalProcess
*  @param : none
*  @return: none.
**************************************************************************************************************/
	public static void brandEstApprovalProcess(){
		for(ID wid : brandWorkitem.keySet()){
			Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
			req.setComments('Rejecting for change Approver'); //RejectComment
			req.setAction('Removed');                    
			req.setWorkitemId(brandWorkitem.get(wid));
			// Submit the request for approval
			result =  Approval.process(req);
		}
		for(AF_Brand_Estimate__c brandEst:brandEstimateList){
			brandEst.AF_Status_Base_Fees__c = AF_Constants.BASE_FEES_WITH_AGENCY;
			brandEstupdateList.add(brandEst);
		}
		if(brandEstupdateList.size()>0){
			try{
			update brandEstupdateList;
			}
			catch(Exception e)
		        {
		            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'brandEstApprovalProcess',e.getMessage(),e.getTypeName(),e.getStackTraceString());
		            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		        }
		}
		for(ID wid : brandWorkitem.keySet()){
			Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
			req1.setComments('Submitting request for Change Approver');
			req1.setObjectId(wid);
			result2 = Approval.process(req1);
		}
	}
	/*********************************************************************************************************
*  @Description: this method is used to update the latest catfinnace users and Agency users in OOPS Actual
*  @name : oopsActualhandlerMethod
*  @param : brandSet
*  @return: none.
**************************************************************************************************************/
	@future
	public static void oopsActualhandlerMethod(Set<String> brandSet){
		string oopsActualhandlerMethod='oopsActualhandlerMethod';
		List<AF_OOPS_Actual__c> oopsActualList = new  List<AF_OOPS_Actual__c>();
		List<AF_OOPS_Actual__c> oopsActualWithcatList = new  List<AF_OOPS_Actual__c>();
		List<AF_OOPS_Actual__c> oopsWithAgencyList = new  List<AF_OOPS_Actual__c>();
		List<AF_OOPS_Actual__c> oopswithcatList = new  List<AF_OOPS_Actual__c>();
		List<AF_OOPS_Actual__c> oopsStatusUpdateList = new  List<AF_OOPS_Actual__c>();
		String year = String.valueof(System.Today().year());
		Set<Id> oopsId = new Set<Id>();
		oopsActualList = [select id,AF_Brand__r.Name,AF_Status__c from AF_OOPS_Actual__c where AF_Brand__r.Name IN:brandSet and AF_Status__c!=:AF_Constants.BASE_FEES_READYFORPO and AF_Fiscal_year__c=:year];
		for(AF_OOPS_Actual__c oop:oopsActualList){
			if(oop.AF_Status__c==AF_Constants.CATEGORY_FINANCE){
				oopsActualWithcatList.add(oop);
			}
			else if(oop.AF_Status__c==AF_Constants.BASE_FEES_WITH_AGENCY){
				oop.AF_Status__c = AF_Constants.CATEGORY_FINANCE;
				oopsWithAgencyList.add(oop);
				oopsId.add(oop.Id);
			}
		}
		if(oopsActualWithcatList.size()>0){
			try{
			update oopsActualWithcatList;
			}
			catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,oopsActualhandlerMethod,e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
	        }
		}
		if(oopsWithAgencyList.size()>0){
			try{
			update oopsWithAgencyList;
			}
			catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,oopsActualhandlerMethod,e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
	        }
		}
		oopswithcatList = [select id,AF_Status__c from AF_OOPS_Actual__c where Id IN:oopsId];
		for(AF_OOPS_Actual__c oop:oopswithcatList){
			oop.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
			oopsStatusUpdateList.add(oop);
		}
		if(oopsStatusUpdateList.size()>0){
			try{
			update oopsStatusUpdateList;
			}
			catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,oopsActualhandlerMethod,e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
	        }
		}
	}
}