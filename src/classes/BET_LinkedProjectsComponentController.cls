/*************************************************************************************
Name : BET_LinkedProjectsComponentController

Purpose : Controller for BET_LinkedProjectsComponent

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  05-08-2015  Initial
*************************************************************************************/
public with sharing class BET_LinkedProjectsComponentController {

	public Id betIdentifier {get;set;}

	public BET_LinkedProjectsComponentController() {}

	/************************************************************
		Purpose: Method retreives all linked projects related to given bet
		Parameters: -
		Returns: List of wrapped IPM_Projects objects
		Throws: -
	*************************************************************/
	public List<FollowRequestWrapper> getLinkedProjects(){
		uw_Bet__c bet = [select id, IPM_Project__c , IPM_Project__r.name from uw_Bet__c where id=:betIdentifier];
		List<FollowRequestWrapper> requests = new List<FollowRequestWrapper>();
		Boolean leadProjectPresent = false;
		for(IPM_BETWrapper bw : IPM_BETUpdateService.returnIPM(bet.id)){
			if(bw.projectId == bet.IPM_Project__c){
				leadProjectPresent = true;
				requests.add(new FollowRequestWrapper(bw.projectId,bw.projectName,true));
			} else {
				requests.add(new FollowRequestWrapper(bw.projectId,bw.projectName,false));
			}
		}
		if(!leadProjectPresent && bet.IPM_Project__c != null){
			requests.add(new FollowRequestWrapper(bet.IPM_Project__c,bet.IPM_Project__r.name,true));
		}
		return requests;
	}

	/**********************************************************
		Name : FollowRequestWrapper
		Purpose : Wrapper class for BET_Follow_Request__c object
	***********************************************************/
	public class FollowRequestWrapper{
		public String projectId {get;set;}
		public String projectName {get;set;}
		public Boolean isLeadProject {get;set;}

		public FollowRequestWrapper(String id, String name, Boolean isLead){
			projectId = id;
			projectName = name;
			isLeadProject = isLead;
		}
	}
}