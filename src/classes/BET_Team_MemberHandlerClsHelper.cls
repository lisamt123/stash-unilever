/*************************************************************************************
Name : BET_Team_MemberHandlerClsHelper

Purpose : Helper class for BET_Team_MemberHandlerCls

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  28-09-2015  Initial
*************************************************************************************/

/* Helper class takes sharing settings from its 'parent' */
public class BET_Team_MemberHandlerClsHelper {

	private BET_Team_MemberHandlerClsHelper() {}

	/************************************************************
        Purpose: Method updates bet shares 
        Parameters: List<uw_BET_Team_Member__c> newTeamMembers
        Returns: -
        Throws: -
    *************************************************************/
	public static void memberSharesUpdate(List<uw_BET_Team_Member__c> newTeamMembers){
		BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues(BET_Team_MemberHandlerCls.BETMANAGERCONFIG);
        String managerRoleStr = Test.isRunningTest() ? BET_Team_MemberHandlerCls.MANAGERROLE : BETManageMembersConfig.ManagerRole__c;

		List<uw_BET_Team_Member__c> teamMembers = [SELECT Id, Team_Member__c,BET__c,Role__c FROM uw_BET_Team_Member__c WHERE Id in:newTeamMembers];

		Set<Id> betsIds = new Set<Id>();
    	for(uw_BET_Team_Member__c tmember : teamMembers) {
    		betsIds.add(tmember.BET__c);
    	}

        List<uw_BET__Share> betShareList = [SELECT Id,userOrGroupId,parentId FROM uw_BET__Share WHERE parentId in :betsIds and  AccessLevel in ('Edit','Read')];
        
        for(uw_BET__Share share : betShareList){
        	for(uw_BET_Team_Member__c tmember : teamMembers) {
		        if(share.userOrGroupId == tmember.Team_Member__c && share.parentId == tmember.BET__c) {
		           share.AccessLevel = tmember.Role__c.equalsIgnoreCase(managerRoleStr) ? BET_Team_MemberHandlerCls.EDIT : BET_Team_MemberHandlerCls.READ;
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
	public static void memberCollaborationGroupsUpdate(List<uw_BET_Team_Member__c> newTeamMembers){
		BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues(BET_Team_MemberHandlerCls.BETMANAGERCONFIG);
        String managerRoleStr = Test.isRunningTest() ? BET_Team_MemberHandlerCls.MANAGERROLE : BETManageMembersConfig.ManagerRole__c;

		List<uw_BET_Team_Member__c> teamMembers = [SELECT Id, Team_Member__c, Role__c, 
														  BET__c, BET__r.Studio_Chatter_Group__c FROM 
                                            			  uw_BET_Team_Member__c WHERE Id in:newTeamMembers];

        Set<Id> chatterGroupsIds = new Set<Id>();
    	for(uw_BET_Team_Member__c tmember : teamMembers) {
    		chatterGroupsIds.add(tmember.BET__r.Studio_Chatter_Group__c);
    	}
         
        List<CollaborationGroupMember> cgmList = [SELECT Id,MemberId,CollaborationGroupId FROM CollaborationGroupMember WHERE CollaborationGroupId =: chatterGroupsIds];

        for(CollaborationGroupMember cgm : cgmList){
        	for(uw_BET_Team_Member__c tmember : teamMembers) {
        		if(cgm.MemberId == tmember.Team_Member__c && cgm.CollaborationGroupId == tmember.BET__r.Studio_Chatter_Group__c){
	           		cgm.CollaborationRole = tmember.Role__c.equalsIgnoreCase(managerRoleStr) ? BET_Team_MemberHandlerCls.ADMIN : BET_Team_MemberHandlerCls.STANDARD;
           		}
       		}
        }
        update cgmList;
	}

	/************************************************************
        Purpose: Method creates external member related objects
        Parameters: List<uw_BET_Team_Member__c> newList
        Returns: -
        Throws: -
    *************************************************************/
    public static void addExternalRelatedData(List<uw_BET_Team_Member__c> newList){
        Set<Id> betIds = new Set<Id>();
        List<uw_BET_Team_Member__c> externalMembers = new List<uw_BET_Team_Member__c>();
        String externalRole = getExternalUserRoleName();
        for(uw_BET_Team_Member__c member : newList){
            if(member.Role__c == externalRole && member.Team_Member__c == null){
                externalMembers.add(member);
                betIds.add(member.BET__c);
            }
        }
        Map<Id,uw_bet__c> mapIdBet = new Map<Id,uw_bet__c>();
        for(uw_bet__c bet : [select id, name,Studio_Chatter_Group__c from uw_bet__c where id in : betIds]){
            mapIdBet.put(bet.id,bet);
        }
        for(uw_BET_Team_Member__c member : externalMembers){
            BET_AccessService.createExternalUserRelatedObjects(member.email__c,mapIdBet.get(member.BET__c)); 
        }
    }

   	/************************************************************
        Purpose: Method create sharing record based on tem member
        Parameters: uw_BET_Team_Member__c member,String managerRole
        Returns: -
        Throws: -
    *************************************************************/
	public static uw_BET__Share addShareByMember(uw_BET_Team_Member__c member,String managerRoleStr){
		uw_BET__Share betShare = new uw_BET__Share();
        betShare.UserOrGroupId = member.Team_Member__c;
        betShare.AccessLevel = (member.Role__c.equalsIgnoreCase(managerRoleStr)) ? BET_Team_MemberHandlerCls.EDIT : BET_Team_MemberHandlerCls.READ;
        betShare.ParentId = member.BET__c;
        return betShare;
	}

	/************************************************************
        Purpose: Method create group member based on tem member
        Parameters: uw_BET_Team_Member__c member,String managerRole
        Returns: -
        Throws: -
    *************************************************************/
	public static CollaborationGroupMember createCollaborationGroupMemberByTeamMember(uw_BET_Team_Member__c member,String managerRoleStr){
		CollaborationGroupMember cgm = new CollaborationGroupMember();
	    cgm.CollaborationGroupId = member.Bet__r.Studio_Chatter_Group__c;
	    cgm.MemberId = member.Team_Member__c;
	    cgm.NotificationFrequency = 'N';
	    cgm.CollaborationRole = member.Role__c.equalsIgnoreCase(managerRoleStr) ? BET_Team_MemberHandlerCls.ADMIN : BET_Team_MemberHandlerCls.STANDARD;
	    return cgm;
	}

	/************************************************************
        Purpose: Method builds entity subscription for given team member
        Parameters: uw_BET_Team_Member__c teamMember
        Returns: -
        Throws: -
    *************************************************************/
	public static EntitySubscription addEntitiySubscriptionByTeamMember(uw_BET_Team_Member__c teamMember){
		EntitySubscription entitySubscription = new EntitySubscription();
        entitySubscription.SubscriberId = teamMember.Team_Member__c;
        entitySubscription.ParentId = teamMember.Bet__c;
        return entitySubscription;
	}

    /************************************************************
        Purpose: Method returns External User role name
        Parameters: 
        Returns: role name
        Throws: -
    *************************************************************/
    public static String getExternalUserRoleName(){
        BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues(BET_Team_MemberHandlerCls.BETMANAGERCONFIG);
        return Test.isRunningTest() ? 'External Agency User' : BETManageMembersConfig.ExternalRole__c;
    }
}