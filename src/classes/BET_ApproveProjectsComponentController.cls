/*************************************************************************************
Name : BET_ApproveProjectsComponentController

Purpose : Controller for BET_ApproveProjectsComponent

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  05-08-2015  Initial
*************************************************************************************/
public with sharing class BET_ApproveProjectsComponentController {

	public static final Integer AUTOAPPROVE_TIME = 3;

	public Id betIdentifier{get;set;}
	public BET_Follow_Request__c followReguest {get;set;}
	public Id elementId {get;set;}
	public Boolean betOwner {get;set;}

	public BET_ApproveProjectsComponentController() {}

	/************************************************************
		Purpose: Method denies linking request
		Parameters: -
		Returns: PageReference
		Throws: -
	*************************************************************/
	public PageReference doDeny(){
		System.debug('Entering doDeny : ' + elementId);
		followReguest = [select Status__c from BET_Follow_Request__c where id=:elementId];
		followReguest.Status__c = BET_LinkingService.FOLLOW_STATUS_REJECTED;
		update followReguest;
		return forwardAction();
	}

	/************************************************************
		Purpose: Method approves linking request
		Parameters: -
		Returns: PageReference
		Throws: -
	*************************************************************/
	public PageReference doApprove(){
		System.debug('Entering doApprove : ' + elementId);
		followReguest = [select Status__c from BET_Follow_Request__c where id=:elementId];
		followReguest.Status__c = BET_LinkingService.FOLLOW_STATUS_APPROVED;
		update followReguest;
		return forwardAction();
	}

	/************************************************************
		Purpose: Method displays appropriate tab depends on number of pending requests
		Parameters: -
		Returns: PageReference
		Throws: -
	*************************************************************/
	private PageReference forwardAction(){
		System.debug('Entering forwardAction');
		PageReference pr;
		if(areThereOtherPendingRequests()){
			pr =  new PageReference('/apex/uw_BETEdit?id='+betIdentifier+'&activeTab=tabFour');
		} else {
			pr =  new PageReference('/apex/uw_BETEdit?id='+betIdentifier+'&activeTab=tabOne&rljs=true');
		}
		pr.setRedirect(true);
		System.debug('Exit forwardAction : ' + pr);
		return pr;
	}

	/************************************************************
		Purpose: Method checks if there are still some pending follow requests
		Parameters: -
		Returns: Boolean true if there are pending request , false otherwise
		Throws: -
	*************************************************************/
	private Boolean areThereOtherPendingRequests(){
		System.debug('Entering areThereOtherPendingRequests : ' + betIdentifier);
		List<BET_Follow_Request__c> requests = [select id,Project_Name__c,Project_Id__c,Project_Lead__r.name,
												CreatedDate from BET_Follow_Request__c where Brand_Experience_Toolkit__c =: betIdentifier 
												and Status__c =: BET_LinkingService.FOLLOW_STATUS_NEW limit 1];
		System.debug('Exit areThereOtherPendingRequests : ' + requests);
		return !requests.isEmpty();
	}


	/************************************************************
		Purpose: Method retrieves list of new follow requests related to bet
		Parameters: -
		Returns: List<FollowRequestWrapper>
		Throws: -
	*************************************************************/
	public List<FollowRequestWrapper> getPendingRequests(){
		System.debug('Entering getPendingRequests');
		List<FollowRequestWrapper> result = new List<FollowRequestWrapper>();
		Map<String,Date> projectIdTLDMap = new Map<String,Date>();
		Set<String> projectIds = new Set<String>();
		List<BET_Follow_Request__c> requests = [select id,Project_Name__c,Project_Id__c,Project_Lead__r.name,CreatedDate from BET_Follow_Request__c where Brand_Experience_Toolkit__c =: betIdentifier and Status__c =: BET_LinkingService.FOLLOW_STATUS_NEW order by createddate desc];
		for(BET_Follow_Request__c request : requests){
			projectIds.add(request.Project_Id__c);
		}
		for(String prId : projectIds){
			IPM_BETWrapper project  = IPM_BETUpdateService.ipm_Wrapper((Id)prId);
			projectIdTLDMap.put(prId,project.targetLaunchDate);
		}
		for(BET_Follow_Request__c request : requests){
			result.add(new FollowRequestWrapper(request,projectIdTLDMap));
		}
		System.debug('Exit getPendingRequests : ' + result);
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
		public Date tld {get;set;}
		public String remainder {get;set;}

		public FollowRequestWrapper(BET_Follow_Request__c request,Map<String,Date> projectIdTLDMap){
			id = request.id;
			ipmProject = request.Project_Name__c;
			ipmLead = request.Project_Lead__r.name;
			tld = projectIdTLDMap.get(String.valueOf((ID)request.Project_Id__c));
			remainder = String.format(Label.BET_ProjectApproveRemainder, new List<String> {request.createdDate.addDays(AUTOAPPROVE_TIME).format('d MMMM yyyy, hh:mm')});
		}
	} 

}