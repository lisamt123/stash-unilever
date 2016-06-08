/*************************************************************************************
Name : BET_LinkedProjectsComponentController

Purpose : Controller for BET_LinkedProjectsComponent

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  05-08-2015  Initial
*************************************************************************************/
public with sharing class BET_LinkedProjectsComponentController {

	public Id betIdentifier {get;set;}
	public String selectedProjectId {get;set;}
	public Boolean admin {get;set;}

	public BET_LinkedProjectsComponentController() {}

	/************************************************************
		Purpose: Method retreives all linked projects related to given bet. Lead project is taken from IPM or from BET, 
				follow projects are taken from approved requests
		Parameters: -
		Returns: List of wrapped IPM_Projects objects
		Throws: -
	*************************************************************/
	public List<FollowRequestWrapper> getLinkedProjects(){
		System.debug('Entering getLinkedProjects');
		uw_Bet__c bet = [select id, IPM_Project__c , IPM_Project__r.name, Inoplan_Project_Keyword_Search__c from uw_Bet__c where id=:betIdentifier];
		List<FollowRequestWrapper> requests = new List<FollowRequestWrapper>();
		if(bet.IPM_Project__c != null){
			requests.add(new FollowRequestWrapper(bet.IPM_Project__c,bet.Inoplan_Project_Keyword_Search__c,true));
		}
		for(BET_Follow_Request__c req : [select id,Project_Name__c,Project_Id__c from BET_Follow_Request__c where Brand_Experience_Toolkit__c=:betIdentifier 
										 and Status__c=:BET_LinkingService.FOLLOW_STATUS_APPROVED 
										 and Project_Id__c !=: bet.IPM_Project__c]){
			requests.add(new FollowRequestWrapper(req.Project_Id__c,req.Project_Name__c,false));
		}
		System.debug('Exit getLinkedProjects : ' + requests);
		return requests;
	}

	/************************************************************
		Purpose: Method sets given project as bets lead project
		Parameters: -
		Returns: PageReference
		Throws: -
	*************************************************************/
	public PageReference setAsLeadProject(){
		System.debug('Entering setAsLeadProject : ' + selectedProjectId + ', ' +  betIdentifier);
		BET_LinkingService.setASLead((Id)selectedProjectId, betIdentifier);
		PageReference pr =  new PageReference('/apex/uw_BETEdit?id='+betIdentifier+'&activeTab=tabThree&rljs=true');
		pr.setRedirect(true);
		return pr;
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