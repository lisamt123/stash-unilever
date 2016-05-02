/*****************************************************************************************************************************
Name: BET_Team_MemberHandlerCls
Copyright © 2015 Unilever. 

Purpose: Class contains logic used by BET_Team_MemberHandler

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            13/08/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
/* Without sharing due to this it ITrigger implementation class  */
public without sharing class BET_Team_MemberHandlerCls {

    public static final String BETMANAGERCONFIG = 'BETManageMembersConfig';
    public static final String MANAGERROLE = 'Manager';
    public static final String MEMBERROLE = 'Member';
    public static final String ADMIN = 'Admin';
    public static final String STANDARD = 'Standard';
    public static final String EDIT = 'Edit';
    public static final String READ = 'Read';

	private BET_Team_MemberHandlerCls() {}

	/************************************************************
        Purpose: Method runs new member related operations
        Parameters: List<uw_BET_Team_Member__c> newList
        Returns: -
        Throws: -
    *************************************************************/
	public static void runPostApprovalInsertTeamMemberOperations(List<uw_BET_Team_Member__c> newList){
		System.debug('Entering runPostApprovalInsertTeamMemberOperations : ' + newList);
        BET_Team_MemberHandlerClsHelper.addExternalRelatedData(newList);
		addSharings(newList);
		addCollaborationGroups(newList);
		addEntitySubscriptions(newList);
        addStandardUserPermissionSet(newList);
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
        BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues(BET_Team_MemberHandlerCls.BETMANAGERCONFIG);
        String managerRoleStr = Test.isRunningTest() ? MANAGERROLE : BETManageMembersConfig.ManagerRole__c;
        String externalRole = BET_Team_MemberHandlerClsHelper.getExternalUserRoleName();
        List<uw_BET__Share> shares = new List<uw_BET__Share>();
        Set<Id> bets = new Set<Id>();
        for(uw_BET_Team_Member__c member : newList){
        	bets.add(member.BET__c);
        }
        Map<Id,uw_bet__c> betMap = new Map<Id,uw_bet__c>([select id, ownerid from uw_bet__c where id in : bets]);
		for(uw_BET_Team_Member__c member : newList){
			uw_bet__c bet = betMap.get(member.BET__c);
			if(bet != null && member.Team_Member__c != null && member.Team_Member__c != bet.ownerId && member.Role__c != externalRole) {
         		shares.add(BET_Team_MemberHandlerClsHelper.addShareByMember(member,managerRoleStr));
        	}
		}
		insert shares;
		System.debug('Exit addSharings : ' + shares);
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

		List<uw_BET_Team_Member__c> teamMembers = [SELECT Id, Team_Member__c, Role__c, 
														  BET__c, BET__r.Studio_Chatter_Group__c FROM 
                                            			  uw_BET_Team_Member__c WHERE Id in:newList];


        Set<Id> chatterGroupsIds = new Set<Id>();
    	for(uw_BET_Team_Member__c tmember : teamMembers) {
    		chatterGroupsIds.add(tmember.BET__r.Studio_Chatter_Group__c);
    	}
         
        List<CollaborationGroupMember> cgmList = [SELECT Id,MemberId,CollaborationGroupId FROM CollaborationGroupMember WHERE CollaborationGroupId =: chatterGroupsIds];

        Map<String,Set<Id>> groupUsersMap = new Map<String,Set<Id>>();

        for(CollaborationGroupMember cg  : cgmList){
        	if(groupUsersMap.keySet().contains(cg.CollaborationGroupId)){
        		groupUsersMap.get(cg.CollaborationGroupId).add(cg.MemberId);
        	} else {
        		groupUsersMap.put(cg.CollaborationGroupId,new Set<Id>{cg.MemberId});
        	}
        }

		for(uw_BET_Team_Member__c member : teamMembers){
			Set<Id> users = groupUsersMap.get(member.Bet__r.Studio_Chatter_Group__c);
			if((users == null || !users.contains(member.Team_Member__c)) && member.Bet__r.Studio_Chatter_Group__c != null && member.Team_Member__c != null) {
	        	groups.add(BET_Team_MemberHandlerClsHelper.createCollaborationGroupMemberByTeamMember(member,managerRoleStr));             
        	}
        }
        insert groups;
        System.debug('Exit addCollaborationGroups : ' + groups);
	}

	/************************************************************
        Purpose: Method adds entity subscription for given member list
        Parameters: List<uw_BET_Team_Member__c> newList
        Returns: -
        Throws: -
    *************************************************************/
	public static void addEntitySubscriptions(List<uw_BET_Team_Member__c> newList){
		System.debug('Entering addEntitySubscriptions : ' + newList);
        String externalRole = BET_Team_MemberHandlerClsHelper.getExternalUserRoleName();
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
			if(teamMember.Team_Member__c != null && betMembersSubscrMap.get(teamMember.Bet__c) != null && !betMembersSubscrMap.get(teamMember.Bet__c).contains(teamMember.Team_Member__c) && teamMember.Role__c != externalRole){
        		eSubscriptions.add(BET_Team_MemberHandlerClsHelper.addEntitiySubscriptionByTeamMember(teamMember));
        	}
        	
    	}
        insert eSubscriptions;
    	System.debug('Exit addEntitySubscriptions : ' + eSubscriptions);
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
		BET_Team_MemberHandlerClsHelper.memberCollaborationGroupsUpdate(roleModifiedMembers);
		BET_Team_MemberHandlerClsHelper.memberSharesUpdate(roleModifiedMembers);
	}

    /************************************************************
        Purpose: Method adds CB4L_Standard_User permission sets to new members in case they do not have any other BET permission set assigned
        Parameters: List<uw_BET_Team_Member__c> newTeamMembers
        Returns: -
        Throws: -
    *************************************************************/
    public static void addStandardUserPermissionSet(List<uw_BET_Team_Member__c> newTeamMembers){
        Set<Id> relatedUsersIds = new Set<Id>();

        String externalRole = BET_Team_MemberHandlerClsHelper.getExternalUserRoleName();

        for(uw_BET_Team_Member__c member : newTeamMembers){
            if(member.Team_Member__c != null && member.Role__c != externalRole) {
                relatedUsersIds.add(member.Team_Member__c);
            }
        }

        if(!relatedUsersIds.isEmpty() && !(System.isBatch() || System.isFuture())){
            addStandardUserPermissionSetFuture(relatedUsersIds);
        }
        else if(!relatedUsersIds.isEmpty() && (System.isBatch() || System.isFuture())){
            addStandardUserPermissionSet(relatedUsersIds);            
        }
    }

    /************************************************************
        Purpose: Method adds CB4L_Standard_User permission sets to new members in case they do not have any other BET permission set assigned
        Parameters: Set<Id> relatedUsersIds
        Returns: -
        Throws: -
    *************************************************************/
    @Future
    private static void addStandardUserPermissionSetFuture(Set<Id> relatedUsersIds){
        addStandardUserPermissionSet(relatedUsersIds);
    }

    /************************************************************
        Purpose: Method adds CB4L_Standard_User permission sets to new members in case they do not have any other BET permission set assigned
        Parameters: Set<Id> relatedUsersIds
        Returns: -
        Throws: -
    *************************************************************/
    private static void addStandardUserPermissionSet(Set<Id> relatedUsersIds){
        if(!relatedUsersIds.isEmpty()) {

            Map<String,Id> permsetMap = BET_CommonService.getIdsOfBETsPermissionSets();
            List<Id> betsPermissionSets = permsetMap.values();

            Set<Id> usersWithBetPermissionSets = new Set<Id>();
            for(PermissionSetAssignment assignment : [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId in : relatedUsersIds and PermissionSetId in : betsPermissionSets order by AssigneeId]){
                usersWithBetPermissionSets.add(assignment.AssigneeId);
            }

            relatedUsersIds.removeAll(usersWithBetPermissionSets);

            List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
            for(Id user : relatedUsersIds){
                PermissionSetAssignment assignment = new PermissionSetAssignment(AssigneeId = user,PermissionSetId = permsetMap.get(BET_CommonService.BET_STANDARD_PERM_SET));
                assignments.add(assignment);

            }

            if(!Test.isRunningTest()) {
                insert assignments;
            }
        }
    }

}