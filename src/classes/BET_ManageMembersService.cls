/* service class without sharing */
public without sharing class BET_ManageMembersService {

	private BET_ManageMembersService() {}

	/************************************************************
        Purpose: Method deletes team members
        Parameters: List<uw_BET_Team_Member__c> members
        Returns: -
        Throws: -
    *************************************************************/
	public static void deleteTeamMembers(List<uw_BET_Team_Member__c> members){
		delete members;
	}
	
	public static PageReference doMassApproveDeny(String status,List<BET_ManageMembersController.MemberRequestWrapper> memberRequests,Id betId){
        System.debug('Entering doMassApproveDeny ' + status + ', ' + memberRequests + ', ' + betId);
        List<BET_Member_Request__c> requests = new List<BET_Member_Request__c>();
        for(BET_ManageMembersController.MemberRequestWrapper memberRequest : memberRequests){
            if(memberRequest.isSelected){
                memberRequest.obj.Status__c = status;
                requests.add(memberRequest.obj);
            }
        }
        try{
            if(requests.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.BET_Member_Requests_Not_Marked));  
                return null;
            } else {
                update requests;
            }
        }catch (Exception e){
            System.debug('Exception in doApprove : ' + e.getMessage());
            return null;
        }
        PageReference pr = BET_ManageMembersService.forward(betId);
        System.debug('Exit doMassApproveDeny : ' + pr);
        return pr;
    }

	/************************************************************
        Purpose: Method deletes related member requests
        Parameters: List<uw_BET_Team_Member__c> deletedMembers
        Returns: -
        Throws: -
    *************************************************************/
    public static void deleteRelatedMemberRequests(List<uw_BET_Team_Member__c> deletedMembers, Id betId){
        System.debug('Entering deleteRelatedMemberRequests : ' + deletedMembers);
        Set<Id> usersIds = new Set<Id>();
        for(uw_BET_Team_Member__c teamMember : deletedMembers){
            usersIds.add(teamMember.Team_Member__c);
        }
        delete [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c =: betId and UserId__c in :usersIds];
        System.debug('Entering deleteRelatedMemberRequests');
    }

    /************************************************************
        Purpose: Method cleans up after removed tem members
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
    public static void cleanUpSharesGroupsSubscriptions(List<uw_BET_Team_Member__c> deletedMembers, uw_BET__c bet){
        System.debug('Entering cleanUpSharesGroupsSubscriptions : ' + deletedMembers);
        Set<Id> usersIds = new Set<Id>();
        for(uw_BET_Team_Member__c teamMember : deletedMembers){
            usersIds.add(teamMember.Team_Member__c);
        }
        delete [SELECT Id FROM uw_BET__Share WHERE parentId = :bet.id AND userOrGroupId in:usersIds]; 
        delete [SELECT Id FROM CollaborationGroupMember WHERE CollaborationGroupId =: bet.Studio_Chatter_Group__c AND memberId in : usersIds];
        delete [Select Id,SubscriberId,ParentId from EntitySubscription where SubscriberId in:usersIds and ParentId=:bet.id limit 1000];
        System.debug('Exit cleanUpSharesGroupsSubscriptions');
    }


    /************************************************************
        Purpose: Method retrieves picklist value for given fieldresult
        Parameters: Schema.DescribeFieldResult fieldResult
        Returns: List<selectOption>
        Throws: -
    *************************************************************/
    public static List<selectOption> getRoles(Schema.DescribeFieldResult fieldResult,Boolean isBetOwnerOrManager){
        List<selectOption> options = new List<selectOption>();           
        List<Schema.PicklistEntry> picklistEntryList = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry picklistEntry : picklistEntryList){
            if(!isBetOwnerOrManager && picklistEntry.getLabel() != 'Manager') {
                options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
            } else if (isBetOwnerOrManager) {
                options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
            }
        }       
        return options;
    }

    /************************************************************
        Purpose: Method refreshes page
        Parameters: -
        Returns: PageReference
        Throws: -
    *************************************************************/
    public static PageReference forward(Id betId){
        System.debug('Entering forward');
        PageReference pr = new PageReference('/apex/BET_ManageMembers?bet='+betId);
        pr.setRedirect(true);
        System.debug('Exit forward ' + pr);
        return pr;
    }
}