/*****************************************************************************************************************************
Name: BET_Team_MemberHandlerCls
Copyright © 2015 Unilever. 

Purpose: Class contains logic used by BET_Team_MemberHandler

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            13/08/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/

public with sharing class BET_Team_MemberHandlerCls {

	private BET_Team_MemberHandlerCls() {}

	/************************************************************
        Purpose: Method retrieves picklist value for given fieldresult
        Parameters: Schema.DescribeFieldResult fieldResult
        Returns: List<selectOption>
        Throws: -
    *************************************************************/
	public static void runPostApprovalInsertTeamMemberOperations(List<uw_BET_Team_Member__c> newList){
		addSharings(newList);
		addCollaborationGroups(newList);
		addEntitySubscriptions(newList);
	}

	/************************************************************
        Purpose: Method adds sharings for given member list
        Parameters: List<uw_BET_Team_Member__c> newList
        Returns: -
        Throws: -
    *************************************************************/
	public static void addSharings(List<uw_BET_Team_Member__c> newList){
		BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues('BETManageMembersConfig');
        String managerRole = BETManageMembersConfig.ManagerRole__c;
        List<uw_BET__Share> shares = new List<uw_BET__Share>();
        Set<Id> bets = new Set<Id>();
        for(uw_BET_Team_Member__c member : newList){
        	bets.add(member.BET__c);
        }
        Map<Id,uw_bet__c> betMap = new Map<Id,uw_bet__c>([select id, ownerid from uw_bet__c where id in : bets]);
		for(uw_BET_Team_Member__c member : newList){
			uw_bet__c bet = betMap.get(member.BET__c);
			if(member.Team_Member__c != null && member.Team_Member__c != bet.ownerId) {
				uw_BET__Share betShare = new uw_BET__Share();
         		betShare.UserOrGroupId = member.Team_Member__c;
         		betShare.AccessLevel = (member.Role__c.equalsIgnoreCase(managerRole)) ? 'Edit' : 'Read';
         		betShare.ParentId = member.BET__c;
         		shares.add(betShare);
        	}
		}
		insert shares;
	}

	/************************************************************
        Purpose: Method adds collaboration groups members for given member list
        Parameters: List<uw_BET_Team_Member__c> newList
        Returns: -
        Throws: -
    *************************************************************/
	public static void addCollaborationGroups(List<uw_BET_Team_Member__c> newList){
		BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues('BETManageMembersConfig');
        String managerRole = BETManageMembersConfig.ManagerRole__c;
		List<CollaborationGroupMember> groups = new List<CollaborationGroupMember>();
		for(uw_BET_Team_Member__c member : newList){
			if(member.Bet__r.Studio_Chatter_Group__c != null && member.Team_Member__c != null){
				CollaborationGroupMember cgm = new CollaborationGroupMember();
	        	cgm.CollaborationGroupId = member.Bet__r.Studio_Chatter_Group__c;
	        	cgm.MemberId = member.Team_Member__c;
	        	cgm.NotificationFrequency = 'N';
	        	if (member.Role__c.equalsIgnoreCase(managerRole)){
	            	cgm.CollaborationRole = 'Admin';
	        	}else {                
	            	cgm.CollaborationRole = 'Standard';
	        	}
	        	groups.add(cgm);             
        	}
        }
        insert groups;
	}

	/************************************************************
        Purpose: Method adds entity subscription for given member list
        Parameters: List<uw_BET_Team_Member__c> newList
        Returns: -
        Throws: -
    *************************************************************/
	public static void addEntitySubscriptions(List<uw_BET_Team_Member__c> newList){
		List<EntitySubscription> eSubscriptions = new List<EntitySubscription>();
		for(uw_BET_Team_Member__c teamMember : newList){
			if(teamMember.Team_Member__c != null){
				EntitySubscription entitySubscription = new EntitySubscription();
        		entitySubscription.SubscriberId = teamMember.Team_Member__c;
        		entitySubscription.ParentId = teamMember.Bet__c;
        		eSubscriptions.add(EntitySubscription);
        	}
    	}
    	insert eSubscriptions;
	}

}