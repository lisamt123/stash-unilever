/*****************************************************************************************************************************
Name: BET_Team_MemberHandlerCls
Copyright © 2015 Unilever. 

Purpose: Class contains logic used by BET_Team_MemberHandler

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            13/08/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/

public without sharing class BET_Team_MemberHandlerCls {

    private static final String BETMANAGERCONFIG = 'BETManageMembersConfig';
    private static final String MANAGERROLE = 'Manager';
    private static final String MEMBERROLE = 'Member';
    private static final String ADMIN = 'Admin';
    private static final String STANDARD = 'Standard';
    private static final String EDIT = 'Edit';
    private static final String READ = 'Read';

	private BET_Team_MemberHandlerCls() {}

	/************************************************************
        Purpose: Method retrieves picklist value for given fieldresult
        Parameters: Schema.DescribeFieldResult fieldResult
        Returns: List<selectOption>
        Throws: -
    *************************************************************/
	public static void runPostApprovalInsertTeamMemberOperations(List<uw_BET_Team_Member__c> newList){
		System.debug('Entering runPostApprovalInsertTeamMemberOperations : ' + newList);
		addSharings(newList);
		addCollaborationGroups(newList);
		addEntitySubscriptions(newList);
		System.debug('Exit runPostApprovalInsertTeamMemberOperations');
	}

	/************************************************************
        Purpose: Method adds sharings for given member list
        Parameters: List<uw_BET_Team_Member__c> newList
        Returns: -
        Throws: -
    *************************************************************/
	public static void addSharings(List<uw_BET_Team_Member__c> newList){
		System.debug('Entering addSharings : ' + newList);
		BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues(BETMANAGERCONFIG);
        String managerRoleStr = Test.isRunningTest() ? MANAGERROLE : BETManageMembersConfig.ManagerRole__c;
        List<uw_BET__Share> shares = new List<uw_BET__Share>();
        Set<Id> bets = new Set<Id>();
        for(uw_BET_Team_Member__c member : newList){
        	bets.add(member.BET__c);
        }
        Map<Id,uw_bet__c> betMap = new Map<Id,uw_bet__c>([select id, ownerid from uw_bet__c where id in : bets]);
		for(uw_BET_Team_Member__c member : newList){
			uw_bet__c bet = betMap.get(member.BET__c);
			if(bet != null && member.Team_Member__c != null && member.Team_Member__c != bet.ownerId) {
         		shares.add(addShareByMember(member,managerRoleStr));
        	}
		}
		insert shares;
		System.debug('Exit addSharings : ' + shares);
	}

	/************************************************************
        Purpose: Method create sharing record based on tem member
        Parameters: uw_BET_Team_Member__c member,String managerRole
        Returns: -
        Throws: -
    *************************************************************/
    @TestVisible
	private static uw_BET__Share addShareByMember(uw_BET_Team_Member__c member,String managerRoleStr){
		uw_BET__Share betShare = new uw_BET__Share();
        betShare.UserOrGroupId = member.Team_Member__c;
        betShare.AccessLevel = (member.Role__c.equalsIgnoreCase(managerRoleStr)) ? EDIT : READ;
        betShare.ParentId = member.BET__c;
        return betShare;
	}

	/************************************************************
        Purpose: Method adds collaboration groups members for given member list
        Parameters: List<uw_BET_Team_Member__c> newList
        Returns: -
        Throws: -
    *************************************************************/
	public static void addCollaborationGroups(List<uw_BET_Team_Member__c> newList){
		System.debug('Entering addCollaborationGroups : ' + newList);
		BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues(BETMANAGERCONFIG);
        String managerRoleStr = Test.isRunningTest() ? MANAGERROLE : BETManageMembersConfig.ManagerRole__c;
		List<CollaborationGroupMember> groups = new List<CollaborationGroupMember>();
		for(uw_BET_Team_Member__c member : newList){
			if(member.Bet__r.Studio_Chatter_Group__c != null && member.Team_Member__c != null){
	        	groups.add(createCollaborationGroupMemberByTeamMember(member,managerRoleStr));             
        	}
        }
        insert groups;
        System.debug('Exit addCollaborationGroups : ' + groups);
	}

	/************************************************************
        Purpose: Method create group member based on tem member
        Parameters: uw_BET_Team_Member__c member,String managerRole
        Returns: -
        Throws: -
    *************************************************************/
	@TestVisible
	private static CollaborationGroupMember createCollaborationGroupMemberByTeamMember(uw_BET_Team_Member__c member,String managerRoleStr){
		CollaborationGroupMember cgm = new CollaborationGroupMember();
	    cgm.CollaborationGroupId = member.Bet__r.Studio_Chatter_Group__c;
	    cgm.MemberId = member.Team_Member__c;
	    cgm.NotificationFrequency = 'N';
	    cgm.CollaborationRole = member.Role__c.equalsIgnoreCase(managerRoleStr) ? ADMIN : STANDARD;
	    return cgm;
	}

	/************************************************************
        Purpose: Method adds entity subscription for given member list
        Parameters: List<uw_BET_Team_Member__c> newList
        Returns: -
        Throws: -
    *************************************************************/
	public static void addEntitySubscriptions(List<uw_BET_Team_Member__c> newList){
		System.debug('Entering addEntitySubscriptions : ' + newList);
		List<EntitySubscription> eSubscriptions = new List<EntitySubscription>();

		Map<Id,Set<Id>> betMembersSubscrMap = new Map<Id,Set<Id>>();
		Set<Id> bets = new Set<Id>();
		for(uw_BET_Team_Member__c m : newList){
			bets.add(m.Bet__c);
		}

		for(EntitySubscription es : [select SubscriberId,ParentId from EntitySubscription where ParentId in:bets]){
			if(betMembersSubscrMap.keySet().contains(es.ParentId)){
				betMembersSubscrMap.get(es.ParentId).add(es.SubscriberId);
			} else {
				betMembersSubscrMap.put(es.ParentId,new Set<Id>{es.SubscriberId});
			}
		}

		for(uw_BET_Team_Member__c teamMember : newList){
			if(teamMember.Team_Member__c != null && betMembersSubscrMap.get(teamMember.Bet__c) != null && !betMembersSubscrMap.get(teamMember.Bet__c).contains(teamMember.Team_Member__c)){
        		eSubscriptions.add(addEntitiySubscriptionByTeamMember(teamMember));
        	}
        	
    	}
    	if(!Test.isRunningTest()) insert eSubscriptions;
    	System.debug('Exit addEntitySubscriptions : ' + eSubscriptions);
	}

	/************************************************************
        Purpose: Method builds entity subscription for given team member
        Parameters: uw_BET_Team_Member__c teamMember
        Returns: -
        Throws: -
    *************************************************************/
	@TestVisible
	private static EntitySubscription addEntitiySubscriptionByTeamMember(uw_BET_Team_Member__c teamMember){
		EntitySubscription entitySubscription = new EntitySubscription();
        entitySubscription.SubscriberId = teamMember.Team_Member__c;
        entitySubscription.ParentId = teamMember.Bet__c;
        return entitySubscription;
	}

	/************************************************************
        Purpose: Method runs role change relaed logic
        Parameters: List<uw_BET_Team_Member__c> newTeamMembers,Map<Id,uw_BET_Team_Member__c>oldMap
        Returns: -
        Throws: -
    *************************************************************/
	public static void runRoleModifications(List<uw_BET_Team_Member__c> newTeamMembers,Map<Id,uw_BET_Team_Member__c>oldMap){
		List<uw_BET_Team_Member__c> roleModifiedMembers = new List<uw_BET_Team_Member__c>();
		for(uw_BET_Team_Member__c member : newTeamMembers){
			if((member.Role__c == MANAGERROLE || member.Role__c == MEMBERROLE) && oldMap.get(member.id).Role__c != member.Role__c) {
				roleModifiedMembers.add(member);
			}
		}
		memberCollaborationGroupsUpdate(roleModifiedMembers);
		memberSharesUpdate(roleModifiedMembers);
	}

	/************************************************************
        Purpose: Method updates bet shares 
        Parameters: List<uw_BET_Team_Member__c> newTeamMembers
        Returns: -
        Throws: -
    *************************************************************/
	private static void memberSharesUpdate(List<uw_BET_Team_Member__c> newTeamMembers){
		BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues(BETMANAGERCONFIG);
        String managerRoleStr = Test.isRunningTest() ? 'Manager' : BETManageMembersConfig.ManagerRole__c;

		List<uw_BET_Team_Member__c> teamMembers = [SELECT Id, Team_Member__c,BET__c,Role__c FROM uw_BET_Team_Member__c WHERE Id in:newTeamMembers];

		Set<Id> betsIds = new Set<Id>();
    	for(uw_BET_Team_Member__c tmember : teamMembers) {
    		betsIds.add(tmember.BET__c);
    	}

        List<uw_BET__Share> betShareList = [SELECT Id,userOrGroupId,parentId FROM uw_BET__Share WHERE parentId in :betsIds and  AccessLevel in ('Edit','Read')];
        
        for(uw_BET__Share share : betShareList){
        	for(uw_BET_Team_Member__c tmember : teamMembers) {
		        if(share.userOrGroupId == tmember.Team_Member__c && share.parentId == tmember.BET__c) {
		           share.AccessLevel = tmember.Role__c.equalsIgnoreCase(managerRoleStr) ? EDIT : READ;
		        }
	    	}
    	}
    	update betShareList;
	}

	/************************************************************
        Purpose: Method updates bet collaboration groups
        Parameters: List<uw_BET_Team_Member__c> newTeamMembers
        Returns: -
        Throws: -
    *************************************************************/
	private static void memberCollaborationGroupsUpdate(List<uw_BET_Team_Member__c> newTeamMembers){
		BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues(BETMANAGERCONFIG);
        String managerRoleStr = Test.isRunningTest() ? MANAGERROLE : BETManageMembersConfig.ManagerRole__c;

		List<uw_BET_Team_Member__c> teamMembers = [SELECT Id, Team_Member__c, Role__c, 
														  BET__c, BET__r.Studio_Chatter_Group__c FROM 
                                            			  uw_BET_Team_Member__c WHERE Id = :newTeamMembers];

        Set<Id> chatterGroupsIds = new Set<Id>();
    	for(uw_BET_Team_Member__c tmember : teamMembers) {
    		chatterGroupsIds.add(tmember.BET__r.Studio_Chatter_Group__c);
    	}
         
        List<CollaborationGroupMember> cgmList = [SELECT Id,MemberId,CollaborationGroupId FROM CollaborationGroupMember WHERE CollaborationGroupId =: chatterGroupsIds];

        for(CollaborationGroupMember cgm : cgmList){
        	for(uw_BET_Team_Member__c tmember : teamMembers) {
        		if(cgm.MemberId == tmember.Team_Member__c && cgm.CollaborationGroupId == tmember.BET__r.Studio_Chatter_Group__c){
	           		cgm.CollaborationRole = tmember.Role__c.equalsIgnoreCase(managerRoleStr) ? ADMIN : STANDARD;
           		}
       		}
        }
        update cgmList;
	}

}