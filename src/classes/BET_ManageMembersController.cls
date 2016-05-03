/**********************************************************************
Name: BET_ManageMembersContoller
Copyright © 2014 Unilever.
======================================================
==========================================================
Purpose: Apex controller to manage BET members
Used in: BET_ManageMembers VisualForce page
==========================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          12/12/2014      INITIAL DEVELOPMENT
1.1-    Blessy Voola            28 Apr 2015   T0: Fix for the issue: If a user is already added to chatter group, when trying to 
                                                 add the same user to the bet associated it is showing error
1.2    Kendre Dnyaneshwar       27 Apr 2015   T1: Modified the query in getmembers method to remove delete button for BET 
                                                 owner                                      
1.3     Michal Bluj             03/08/2015      Sonar related issues fixes
1.4     Michal Bluj             11/08/2015      IPM Member Related Changes
***********************************************************************/

global with sharing class BET_ManageMembersController {

    private static final String DEFAULT_USER_PHOTO = '/profilephoto/005/F';

    public BET_Member_Request__c betMemberRequest {get;set;}
    public uw_Bet__c bet {get;set;}
    public Id betId {get;set;}
    public Boolean selectAll {get;set;}
    public List<MemberRequestWrapper> memberRequests {get;set;}
    public List<MemberWrapper> members;

    public Id selectedRequestId {get;set;}
    public Id selectedMemberId {get;set;}
    public Boolean isBetOwnerOrManager {get;set;}
    public Boolean isBETOperationAdmin {get;set;}
    public Boolean isHubAdmin {get;set;}

    public String setErrorMessage{get;set;}
    public String setEmailAdd{get;set;}
    public String inviteSent{get;set;}
    public Profile chatterExternalProfile{get;set;}
    public Boolean requestsShouldBeAutoapproved {get;set;}

    /************************************************************
        Purpose: Controller constructor
        Parameters: ApexPages.StandardController controller
        Returns: 
        Throws: -
    *************************************************************/
    public BET_ManageMembersController(ApexPages.StandardController controller) {
        betId = (Id)ApexPages.currentPage().getParameters().get('bet');
        bet = [select id ,Name, ownerid, Studio_Chatter_Group__c from uw_Bet__c where id=:betId];
        betMemberRequest = new BET_Member_Request__c(Brand_Experience_Toolkit__c = betId);
        selectAll = false;
        requestsShouldBeAutoapproved = false;

        isHubAdmin = BET_CommonService.isHubAdmin();
        isBetOwnerOrManager = BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(betId, UserInfo.getUserId());
        isBETOperationAdmin = BET_CommonService.isBETOperationAdmin() && !isBetOwnerOrManager && !isHubAdmin;

        requestsShouldBeAutoapproved = isBetOwnerOrManager || isHubAdmin;

        chatterExternalProfile = [SELECT Id FROM Profile WHERE Name='Chatter External User' LIMIT 1];

        memberRequests = new List<MemberRequestWrapper>();
        for(BET_Member_Request__c request : [select id,  ProjectRequest__r.Project_Name__c, UserId__r.FirstName,UserId__r.LastName, UserId__r.SmallPhotoUrl, UserId__r.Title 
                                                from BET_Member_Request__c where Brand_Experience_Toolkit__c =: betId and Status__c =: BET_LinkingService.FOLLOW_STATUS_NEW]){
            memberRequests.add(new MemberRequestWrapper(request));
        }
    }

    public List<MemberWrapper> getMembers(){
        members = new List<MemberWrapper>();
        for(uw_BET_Team_Member__c member : [select id,email__c, Role__c, Team_Member__r.FirstName,Team_Member__r.LastName,Team_Member__r.SmallPhotoUrl,BET__c,Team_Member__c,Team_Member__r.Title
                                                from uw_BET_Team_Member__c where BET__c =:betId ]){
            members.add(new MemberWrapper(member,bet.ownerId));
        }
        return members;
    }


    /************************************************************
        Purpose: Method adds member ( by creating approved member request)
        Parameters: -
        Returns: PageReference
        Throws: -
    *************************************************************/
    public PageReference addMember(){
        System.debug('Entering addMember');
        PageReference pr = null;
        BET_Request_Access__c settings  = BET_Request_Access__c.getInstance();
        if(betMemberRequest.UserId__c != null){
            try{
                betMemberRequest.id = null;
                betMemberRequest.Bet_owner__c = bet.ownerid;
                betMemberRequest.Status__c = requestsShouldBeAutoapproved ? BET_LinkingService.FOLLOW_STATUS_APPROVED : BET_LinkingService.FOLLOW_STATUS_NEW;
                betMemberRequest.Do_Not_Notify_Bet__c = requestsShouldBeAutoapproved;
                betMemberRequest.External_User_Request__c = false;
                betMemberRequest.Do_Not_Notify_User__c = true;
                insert betMemberRequest;
                betMemberRequest.UserId__c = null;
                betMemberRequest = new BET_Member_Request__c(Brand_Experience_Toolkit__c = betId);
            } catch (Exception ex){
                return null;
            }

            pr = BET_ManageMembersService.forward(betId);
        }
        System.debug('Exit addMember : ' + pr);
        return pr;
    }

    /************************************************************
        Purpose: Method adds external member ( by creating approved member request)
        Parameters: -
        Returns: PageReference
        Throws: -
    *************************************************************/
    public PageReference addExternalMember(){
        System.debug('Entering addExternalMember');
        PageReference pr = null;
        Id externalUserSalesforceId = null;
        if(!String.isEmpty(betMemberRequest.External_User_Email__c)){
            if (!checkEmail(betMemberRequest.External_User_Email__c)) {
                Apexpages.Message m = new apexpages.Message(ApexPages.Severity.ERROR, setErrorMessage);
                Apexpages.addMessage(m);
                return pr;
            } else {
                List<User> userList = BET_AccessService.isExistingExternalUser(setEmailAdd);
                if(!userList.isEmpty()) {
                    if(!userList[0].isActive){
                        Apexpages.Message m = new apexpages.Message(ApexPages.Severity.ERROR, setEmailAdd +' is an existing user (External Agent) but inactive at the moment. Please send an email to marketing@unilever.com for further clarification.');
                        Apexpages.addMessage(m);  
                        return null;  
                    }else{
                        externalUserSalesforceId = userList[0].Id;
                    }
                } else if (BET_AccessService.checkIfRequestExternalAccessIsPending(betId,setEmailAdd)){
                    Apexpages.Message m = new apexpages.Message(ApexPages.Severity.INFO, 'Note: '+ betMemberRequest.External_User_Email__c + ' has already been invited');
                    Apexpages.addMessage(m); 
                    return null;  
                }
                betMemberRequest.id = null;
                betMemberRequest.Bet_owner__c = bet.ownerid;
                betMemberRequest.Status__c = requestsShouldBeAutoapproved ? BET_LinkingService.FOLLOW_STATUS_APPROVED : BET_LinkingService.FOLLOW_STATUS_NEW;
                betMemberRequest.Do_Not_Notify_Bet__c = true;
                betMemberRequest.External_User_Request__c = true;
                betMemberRequest.Do_Not_Notify_User__c = true;
                betMemberRequest.UserId__c = externalUserSalesforceId; 
                insert betMemberRequest;

                /*if(betMemberRequest.UserId__c != null){
                    BET_Request_Access__c settings  = BET_Request_Access__c.getInstance();
                    BET_CommonService.sendApprovalMailToOwner(bet, betMemberRequest.UserId__c , settings);
                }*/

                betMemberRequest = new BET_Member_Request__c(Brand_Experience_Toolkit__c = betId);
                pr = BET_ManageMembersService.forward(betId);
            }
        } else {
            Apexpages.Message m = new apexpages.Message(ApexPages.Severity.ERROR, 'The external user email address is blank. Please enter a value.');
            Apexpages.addMessage(m);
            return pr;
        }
        System.debug('Exit addExternalMember : ' + pr);
        return pr;
    }

    /************************************************************
        Purpose: Method validates email
        Parameters: String emailAddEntered
        Returns:  Boolean if email is valid
        Throws: -
    *************************************************************/
    private Boolean checkEmail(String emailAddEntered){  
        if (emailAddEntered.trim().contains('@unilever.com')) {
            setEmailAdd = emailAddEntered.trim();
            List<User> nonAgent = [SELECT id, email,IsActive, Name FROM user where email =:setEmailAdd AND profileID != :chatterExternalProfile.Id limit 1];
            if (nonAgent.isEmpty()) {
                setErrorMessage = setEmailAdd+' does not have a Chatter account. Please contact marketing@unilever.com to request an account for them. Once the user has an account, please add them as an internal member to your BET from the Manage Members page.';
            }else{
                if(nonAgent[0].IsActive){
                    setErrorMessage='This email id belongs to an existing internal Unilever user: '+nonAgent[0].Name +' who already has a Chatter account. Please add them as an internal member to your BET from the Manage Members page';
                }else {
                    setErrorMessage = 'This email id belongs to an existing Unilever internal user: '+nonAgent[0].Name+', who\'s Chatter account is currently locked. Please contact marketing@unilever.com to request this account be re-activated.';
                }  
            }
            return false;
        }else{
            setEmailAdd = emailAddEntered.trim();
            return true;
        }
    }

    /************************************************************
        Purpose: Method responsible for delete operation
        Parameters: -
        Returns: PageReference
        Throws: -
    *************************************************************/
    public PageReference doDelete(){
        System.debug('Entering doDelete : ' + selectedMemberId);
        uw_BET_Team_Member__c member = [select id,BET__c,Team_Member__c from uw_BET_Team_Member__c where id =:selectedMemberId];
        BET_ManageMembersService.deleteTeamMembers(new List<uw_BET_Team_Member__c> {member});
        BET_ManageMembersService.deleteRelatedMemberRequests(new List<uw_BET_Team_Member__c> {member},betId);
        BET_ManageMembersService.cleanUpSharesGroupsSubscriptions(new List<uw_BET_Team_Member__c> {member},bet);
        PageReference pr = BET_ManageMembersService.forward(betId);
        System.debug('Exit doDelete : ' + pr);
        return pr;
    }

    /************************************************************
        Purpose: Method responsible for mass delete operation
        Parameters: -
        Returns: PageReference
        Throws: -
    *************************************************************/
    public PageReference massDelete(){
        System.debug('Entering massDelete');
        List<uw_BET_Team_Member__c> membersToDelete = new List<uw_BET_Team_Member__c>();
        for(MemberWrapper member : members){
            if(member.isSelected){
                membersToDelete.add(member.obj);
            }
        }
        if(membersToDelete.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.BET_Member_Requests_Not_Marked));  
            return null;
        }
        BET_ManageMembersService.deleteTeamMembers(membersToDelete);
        BET_ManageMembersService.deleteRelatedMemberRequests(membersToDelete,betId);
        BET_ManageMembersService.cleanUpSharesGroupsSubscriptions(membersToDelete,bet);
        PageReference pr = BET_ManageMembersService.forward(betId);
        System.debug('Exit massDelete : ' + pr);
        return pr;
    }

    /************************************************************
        Purpose: Method responsible for approve operation
        Parameters: -
        Returns: PageReference
        Throws: -
    *************************************************************/
    public PageReference doApprove(){
        System.debug('Entering doApprove : ' + selectedRequestId);
        
        BET_Member_Request__c request = [select Status__c from BET_Member_Request__c where id=:selectedRequestId];
        request.Status__c = 'Approved';
        try{
            update request;
        } catch (Exception e){
            System.debug('Exception in doApprove : ' + e.getMessage());
            return null;
        }
        PageReference pr = BET_ManageMembersService.forward(betId);
        System.debug('Exit doApprove');
        return pr;
    }

    /************************************************************
        Purpose: Method responsible for deny operation
        Parameters: -
        Returns: PageReference
        Throws: -
    *************************************************************/
    public PageReference doDeny(){
        System.debug('Entering doDeny : ' + selectedRequestId);
        BET_Member_Request__c request = [select Status__c from BET_Member_Request__c where id=:selectedRequestId];
        request.Status__c = 'Rejected';
        try{
            update request;
        }catch(Exception e){
            System.debug('Exception in doApprove : ' + e.getMessage());
            return null;
        }
        PageReference pr = BET_ManageMembersService.forward(betId);
        System.debug('Exit doDeny');
        return pr;
    }

    /************************************************************
        Purpose: Method responsible for mass approve operation
        Parameters: -
        Returns: PageReference
        Throws: -
    *************************************************************/
    public PageReference massApprove(){
        System.debug('Entering massApprove');
        PageReference pr = BET_ManageMembersService.doMassApproveDeny('Approved',memberRequests,betId);
        System.debug('Exit massApprove : ' + pr);
        return pr;
    }

    /************************************************************
        Purpose: Method responsible for mass deny operation
        Parameters: -
        Returns: PageReference
        Throws: -
    *************************************************************/
    public PageReference massDeny(){
        System.debug('Entering massDeny');
        PageReference pr = BET_ManageMembersService.doMassApproveDeny('Rejected',memberRequests,betId);
        System.debug('Exit massDeny : ' + pr);
        return pr;
    }

    /************************************************************
        Purpose: Remote method updates members role
        Parameters: String memberid, String role
        Returns: -
        Throws: -
    *************************************************************/
    @RemoteAction
    global static void updateMemberRole(String memberid, String role){
        System.debug('Entering updateMemberRole : ' + memberid + ', ' + role);
        uw_BET_Team_Member__c member = [select Role__c,BET__c from uw_BET_Team_Member__c where id=:memberid];
        member.Role__c = role;
        update member;
        System.debug('Exit updateMemberRole : ' + member);
    }

    /************************************************************
        Purpose: Method retrieves member request roles
        Parameters: -
        Returns: List<selectOption> 
        Throws: -
    *************************************************************/
    public List<selectOption> getMemberRequestRoles() {
        Schema.DescribeFieldResult fieldResult = BET_Member_Request__c.Role__c.getDescribe();
        return BET_ManageMembersService.getRoles(fieldResult,isBetOwnerOrManager);
    }

    /************************************************************
        Purpose: Method retrieves member roles
        Parameters: -
        Returns: List<selectOption>
        Throws: -
    *************************************************************/
    public List<selectOption> getMemberRoles() {
        Schema.DescribeFieldResult fieldResult = uw_BET_Team_Member__c.Role__c.getDescribe(); 
        return BET_ManageMembersService.getRoles(fieldResult,isBetOwnerOrManager);
    }

    /************************************************************
        Purpose: Member request wrapper class
    *************************************************************/
    public class MemberRequestWrapper{
        public BET_Member_Request__c obj {get;set;}
        public Boolean isSelected {get;set;}
        public String projectName {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String photo {get;set;}
        public Id objectId {get;set;}
        public String title {get;set;}

        public MemberRequestWrapper(){}

        public MemberRequestWrapper(BET_Member_Request__c request){
            this.obj = request;
            projectName = request.ProjectRequest__r.Project_Name__c;
            firstName = request.UserId__r.FirstName;
            lastName = request.UserId__r.LastName;
            photo = String.isBlank(request.UserId__r.SmallPhotoUrl) ? DEFAULT_USER_PHOTO : request.UserId__r.SmallPhotoUrl;
            this.isSelected = false;
            objectId = request.id;
            title = request.UserId__r.Title;
        }

    }

    /************************************************************
        Purpose: Member wrapper class
    *************************************************************/
    public class MemberWrapper{
        public Boolean isSelected {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String photo {get;set;}
        public Id objectId {get;set;}
        public String role {get;set;}
        public uw_BET_Team_Member__c obj {get;set;}
        public Boolean isbetOwner {get;set;}
        public String title {get;set;}

        public MemberWrapper(){}

        public MemberWrapper(uw_BET_Team_Member__c member, Id betOwnerId ){
            this.obj = member;
            role = member.Role__c;
            firstName = member.Team_Member__c == null ? member.email__c : member.Team_Member__r.FirstName;
            lastName = member.Team_Member__r.LastName;
            photo = String.isBlank(member.Team_Member__r.SmallPhotoUrl) ? DEFAULT_USER_PHOTO : member.Team_Member__r.SmallPhotoUrl;
            this.isSelected = false;
            objectId = member.id;
            isbetOwner = member.Team_Member__c == betOwnerId;
            title = member.Team_Member__r.Title;
        }

    }
  
}