/*************************************************************************************
Name : BET_ApproveProjectsComponentController

Purpose : Controller for BET_ApproveProjectsComponent

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  05-08-2015  Initial
*************************************************************************************/
public with sharing class BET_ApproveProjectsComponentController {

	public Id betIdentifier{get;set;}
	public IPM_Project__c project {get;set;}
	public BET_Follow_Request__c followReguest {get;set;}
	public Id elementId {get;set;}

	public BET_ApproveProjectsComponentController() {}

	/************************************************************
		Purpose: Method denies linking request
		Parameters: -
		Returns: -
		Throws: -
	*************************************************************/
	public void doDeny(){
		followReguest = [select Status__c from BET_Follow_Request__c where id=:elementId];
		followReguest.Status__c = BET_LinkingService.FOLLOW_STATUS_REJECTED;
		update followReguest;
	}

	/************************************************************
		Purpose: Method approves linking request
		Parameters: -
		Returns: -
		Throws: -
	*************************************************************/
	public void doApprove(){
		followReguest = [select Status__c from BET_Follow_Request__c where id=:elementId];
		followReguest.Status__c = BET_LinkingService.FOLLOW_STATUS_APPROVED;
		update followReguest;
	}

	/************************************************************
		Purpose: Method retrieves list of new follow requests related to bet
		Parameters: -
		Returns: List<FollowRequestWrapper>
		Throws: -
	*************************************************************/
	public List<FollowRequestWrapper> getPendingRequests(){
		List<FollowRequestWrapper> result = new List<FollowRequestWrapper>();
		Map<String,Date> projectIdTLDMap = new Map<String,Date>();
		Set<String> projectIds = new Set<String>();
		List<BET_Follow_Request__c> requests = [select id,Project_Name__c,Project_Id__c,Project_Lead__r.name,CreatedDate from BET_Follow_Request__c where Brand_Experience_Toolkit__c =: betIdentifier and Status__c =: BET_LinkingService.FOLLOW_STATUS_NEW order by createddate desc];
		for(BET_Follow_Request__c request : requests){
			projectIds.add(request.Project_Id__c);
		}

		for(IPM_Project__c project : [select IPM_Target_Launch_Dates__c from IPM_Project__c where id in : projectIds]){
			projectIdTLDMap.put(String.valueOf(project.id),project.IPM_Target_Launch_Dates__c);
		}

		Integer counter = 0;
		for(BET_Follow_Request__c request : requests){
			FollowRequestWrapper wrapper = new FollowRequestWrapper();
			wrapper.id = request.id;
			wrapper.ipmProject = request.Project_Name__c;
			wrapper.ipmLead = request.Project_Lead__r.name;
			wrapper.tld = String.valueOf(projectIdTLDMap.get(String.valueOf((ID)request.Project_Id__c)));
			wrapper.remainder = String.format(Label.BET_ProjectApproveRemainder, new List<String> {String.valueOf(request.createdDate.addDays(3))});
			result.add(wrapper);
			counter ++;
		}

		return result;
	}

	/**********************************************************
		Name : FollowRequestWrapper
		Purpose : Wrapper class for BET_Follow_Request__c object
	***********************************************************/
	public class FollowRequestWrapper{
		public Id id {get;set;}
		public String ipmProject {get;set;}
		public String ipmLead {get;set;}
		public String tld {get;set;}
		public String remainder {get;set;}
	} 

}