/*************************************************************************************
Name : BET_AccessService

Purpose : Access service class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  23-07-2015  Initial
1.1        blessy.voola@accenture.com 24-Mar-2016    Do not send notification to inactive BET owner
*************************************************************************************/
public without sharing class BET_AccessService {
    
    public static final String NO_BET_ACCESS = 'No';
    public static final String BET_MEMBER = 'Member';
    public static final String BET_MANAGER = 'Manager';
    public static final String BET_OWNER = 'Owner';
    public static final String BET_ACCESS_PENDING = 'Pending';
    public static final String MANAGER_ROLE = 'Manager';
    public static final String MEMBER_ROLE = 'Member';

    private static final Profile chatterExternalProfile = [SELECT Id FROM Profile WHERE Name = 'Chatter External User' LIMIT 1];

    private static final String EXT_ACCESS_REQ_ERROR = 'Unable to create access request.';

    private BET_AccessService(){}

    /************************************************************
        Purpose: Method checks if user has access to bet
        Parameters: Id of related user , Id of related bet
        Returns: Status String (“No”, “Member”,”Manager “, “Owner”, “Pending”)
        Throws: BET_CustomBETException
    *************************************************************/
    public static String HasUserAccess(Id userId,Id betId){
        System.debug('Entering HasUserAccess : ' + userId + ', ' + betId);
        String status = NO_BET_ACCESS;
        try{
            List<uw_BET_Team_Member__c> teamMembersRecords = [select Role__c, IsOwner__c, 
            Invite_Pending__c from uw_BET_Team_Member__c 
            where Team_Member__c =:userId 
            and BET__c =: betId limit 1];

            if(!teamMembersRecords.isEmpty()){
                uw_BET_Team_Member__c tMember = teamMembersRecords.get(0);
                status = getStatus(tMember);
            }
            if(status == NO_BET_ACCESS && checkIfRequestAccessIsPending(userId,betId)){
                status = BET_ACCESS_PENDING;
            }
        }catch(Exception e){
            throw new BET_CustomBETException('Unable to check user access',e);
        }
        System.debug('Exit HasUserAccess : ' + status);
        return status;
    }

    /************************************************************
        Purpose: Method returns status of user access;
        Parameters: Team member records
        Returns: Status String (“No”, “Member”,”Manager “, “Owner”, “Pending”)
        Throws: -
    *************************************************************/
    @TestVisible
    private static String getStatus(uw_BET_Team_Member__c tMember){
        System.debug('Entering getStatus : ' + tMember);
        String status = NO_BET_ACCESS;
        if(tMember.IsOwner__c){
            status = BET_OWNER;
        } else if(tMember.Role__c == MANAGER_ROLE){
            status = BET_MANAGER;
        } else if(tMember.Role__c == MEMBER_ROLE){
            status = BET_MEMBER;
        }
        System.debug('Exit getStatus : ' + status);
        return status;
    }

    /************************************************************
        Purpose: Method checks if there is a request access pengind for given user and bet
        Parameters: Id userId,Id betId
        Returns: Boolean
        Throws: -
    *************************************************************/
    @TestVisible
    private static Boolean checkIfRequestAccessIsPending(Id userId,Id betId){
        System.debug('Entering checkIfRequestAccessIsPending : ' + userId + ', ' + betId);
        List<BET_Member_Request__c> requests = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c =: betId and UserId__c =: userId and Status__c =: BET_LinkingService.FOLLOW_STATUS_NEW];
        System.debug('Exit checkIfRequestAccessIsPending : ' + !requests.isEmpty());
        return !requests.isEmpty();
    }

    /************************************************************
        Purpose: Method checks if there is pending member request for given betid and provided email
        Parameters: Id betId,String setEmailAdd
        Returns: Boolean : true is pending user
        Throws: -
    *************************************************************/
    public static Boolean checkIfRequestExternalAccessIsPending(Id betId,String setEmailAdd) {
        System.debug('Entering checkIfRequestExternalAccessIsPending : ' + setEmailAdd + ', ' + betId);
        List<BET_Member_Request__c> requests = [SELECT Id FROM BET_Member_Request__c WHERE Brand_Experience_Toolkit__c = : betId and External_User_Email__c =: setEmailAdd  AND Status__c =: BET_LinkingService.FOLLOW_STATUS_NEW];
        System.debug('Exit checkIfRequestExternalAccessIsPending : ' + !requests.isEmpty());
        return !requests.isEmpty();         
    }

    /************************************************************
        Purpose: Method creates access requests
        Parameters: List of member requests, Id of related bet
        Returns: List od Id of a created requests
        Throws: BET_CustomBETException
    *************************************************************/
    public static List<Id> RequestAccess(List<BET_BETWrapper.MemberRequest> memberRequests, Id betId,Id projectId){
        System.debug('Entering RequestAccess : ' + memberRequests + ', ' + betId);
        List<Id> requestIds = new List<Id>();
        Boolean isOwnerOrManager = BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(betId, UserInfo.getUserId());
              try{
          List<BET_Member_Request__c> mRequestsToBeCreated = new List<BET_Member_Request__c>();  
            uw_Bet__c bet = [select ownerId from uw_Bet__c where id=:betId];
            for(BET_BETWrapper.MemberRequest request : memberRequests){
                mRequestsToBeCreated.add(
                    new BET_Member_Request__c(
                        Bet_owner__c = bet.ownerId,
                        Brand_Experience_Toolkit__c=betId,
                        UserId__c=request.UserId,
                        Role__c = request.AccessLevel,
                        Project_Id__c = projectId,
                        Status__c = isOwnerOrManager ? BET_LinkingService.FOLLOW_STATUS_APPROVED : BET_LinkingService.FOLLOW_STATUS_NEW,
                        Do_Not_Notify_Bet__c = true)
                );
            }
            insert mRequestsToBeCreated;
           
            for(BET_Member_Request__c mrequest : mRequestsToBeCreated){
                requestIds.add(mrequest.id);
            }
            if(!requestIds.isEmpty()){
            //Do not send notification if BET owner is inactive
           uw_Bet__c betowner = [select id,name,ownerId from uw_Bet__c where id=:betId];
            User owner=[select id,isactive from User where id=:betowner.ownerid];
            if(owner.isactive)
                BET_EmailNotificationService.notifyBetOwnerOfMultipleMemberRequestsFromIPM(betId,projectId);
            }
        }catch(Exception e){
            throw new BET_CustomBETException('Unable to create access request',e);
        }
        System.debug('Exit RequestAccess : ' + requestIds);
        return requestIds;
    }

    /************************************************************
        Purpose: Method creates access request
        Parameters: User email, Id of related bet
        Returns: Id of a created request
        Throws: BET_CustomBETException
    *************************************************************/
    public static Id RequestExternalUserAccess(String userEmail, Id betId){
        System.debug('Entering RequestExternalUserAccess : ' + userEmail + ', ' + betId);
        Id requestId = null;
        Boolean isOwnerOrManager = BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(betId, UserInfo.getUserId());
        Id externalUserSalesforceId = validateAndGetUserId(userEmail,betId);
        try{
            BET_Member_Request__c mrequest = new BET_Member_Request__c(
                Brand_Experience_Toolkit__c = betId,
                External_User_Email__c = userEmail,
                External_User_Request__c = true,
                UserId__c = externalUserSalesforceId,
                Status__c = isOwnerOrManager ? BET_LinkingService.FOLLOW_STATUS_APPROVED : BET_LinkingService.FOLLOW_STATUS_NEW,
                Do_Not_Notify_Bet__c = isOwnerOrManager ? true : false);
            insert mrequest;
            requestId = mrequest.id;
        }catch(Exception e){
            throw new BET_CustomBETException(EXT_ACCESS_REQ_ERROR,e);
        }
        System.debug('Exit RequestExternalUserAccess : ' + requestId);
        return requestId;
    }

    /************************************************************
        Purpose: Method validates parameters and retrieves email related user id
        Parameters: User email, Id of related bet
        Returns: Id of an user
        Throws: BET_CustomBETException
    *************************************************************/
    @TestVisible
    private static Id validateAndGetUserId(String userEmail, Id betId){
        if(String.isBlank(userEmail)){
            throw new BET_CustomBETException(EXT_ACCESS_REQ_ERROR+' Provided user email is blank');
        }
        if(betId == null){
            throw new BET_CustomBETException(EXT_ACCESS_REQ_ERROR+' Provided BET identifier is blank');
        }
        uw_Bet__c bet = [select id ,Name, ownerid, Studio_Chatter_Group__c from uw_Bet__c where id =: betId];
        Id externalUserSalesforceId = null;
        String error = checkEmail(userEmail);
        if(error == null){
            List<User> userList = isExistingExternalUser(userEmail);
            if (!userList.isEmpty()) {
                if(userList[0].isActive) {
                    externalUserSalesforceId = userList[0].Id;
                } else {
                    throw new BET_CustomBETException(EXT_ACCESS_REQ_ERROR + ' ' + userEmail +' is an existing user (External Agent) but inactive at the moment. Please send an email to marketing@unilever.com for further clarification.'); 
                }
            }else if (checkIfRequestExternalAccessIsPending(betId,userEmail)){
                throw new BET_CustomBETException(EXT_ACCESS_REQ_ERROR + ' ' + + userEmail +' has already been invited'); 
            }
        } else {
            throw new BET_CustomBETException(EXT_ACCESS_REQ_ERROR + ' ' + error);
        }
        return externalUserSalesforceId;
    }

    /************************************************************
        Purpose: Method validates email
        Parameters: String emailAddEntered
        Returns: Error message if needed
        Throws: -
    *************************************************************/
    @TestVisible
    private static String checkEmail(String emailAddEntered){ 
        String setErrorMessage = null;
        if (emailAddEntered.trim().contains('@unilever.com')) {
            List<User> nonAgent = [SELECT id, email,IsActive, Name FROM user where email =:emailAddEntered AND profileID != :chatterExternalProfile.Id limit 1];
            if (nonAgent.isEmpty()) {
                setErrorMessage = emailAddEntered+' does not have a Chatter account. Please contact marketing@unilever.com to request an account for them. Once the user has an account, please add them as an internal member to your BET from the Manage Members page.';
            }else{
                if(nonAgent[0].IsActive){
                    setErrorMessage='This email id belongs to an existing internal Unilever user: '+nonAgent[0].Name +' who already has a Chatter account. Please add them as an internal member to your BET from the Manage Members page';
                }else {
                    setErrorMessage = 'This email id belongs to an existing Unilever internal user: '+nonAgent[0].Name+', who\'s Chatter account is currently locked. Please contact marketing@unilever.com to request this account be re-activated.';
                }  
            }
        }
        return setErrorMessage;
    }

    /************************************************************
        Purpose: Method checks if there is external user with given email
        Parameters: String emailAddEntered
        Returns: Error message if needed
        Throws: -
    *************************************************************/
    public static List<User> isExistingExternalUser(String setEmailAdd) {
        return [SELECT Id, IsActive FROM User WHERE email= :setEmailAdd AND ProfileId=:chatterExternalProfile.Id];
    }

    /************************************************************
        Purpose: Method creates all objects related to external user
        Parameters: String setEmailAdd, uw_Bet__c bet
        Returns: -
        Throws: -
    *************************************************************/
    public static void createExternalUserRelatedObjects(String setEmailAdd, uw_Bet__c bet){
        uw_Terms_Conditions__c tnc = new uw_Terms_Conditions__c();
        tnc.Status__c = 'New';
        tnc.Invitee_Email__c = setEmailAdd;
        tnc.Invite_Expires__c = System.now().addDays(14); 
        tnc.Bet_Name__c = bet.Name;
        tnc.uw_BET__c = bet.Id;
        tnc.Studio_Chatter_Group__c = bet.Studio_Chatter_Group__c;
        tnc.Action_On_Accept__c = 'Send Invite';
        try{
            insert tnc;
        }catch(exception e){
            return;
        }

        uw_TokenHelper th = new uw_TokenHelper();
        th.taCId = tnc.id;
        String encoded = th.encode();
        String encodedForURL = th.makeTokenForURL(encoded);
                    
        tnc.Invite_Token__c = encodedForURL;
        tnc.Status__c = 'Send';
        update tnc;
                    
        EntitySubscription eSub = new EntitySubscription();
        eSub.SubscriberId = Userinfo.getUserId(); 
        eSub.ParentId = tnc.Id;
        insert eSub;          
    }

    /************************************************************
        Purpose: Method retrieves all bet relates members
        Parameters: Id of related bet
        Returns: List of related member records
        Throws: -
    *************************************************************/
    public static List<BET_BETWrapper.MemberRequest> GetBetUsers(Id betId){
        System.debug('Entering GetBetUsers : ' + betId);
        List<BET_BETWrapper.MemberRequest> members = new List<BET_BETWrapper.MemberRequest>();
        try{
            uw_bet__c betRecord = [select id from uw_bet__c where id=:betId];
        }catch(Exception ex){
            throw new BET_CustomBETException('BET record not found for given id ' + betId,ex);
        }
        for(uw_BET_Team_Member__c member : [select id, Team_Member__c, Role__c from uw_BET_Team_Member__c  where BET__c =: betId]){
            BET_BETWrapper.MemberRequest mrequest = new BET_BETWrapper.MemberRequest();
            mrequest.UserId = member.Team_Member__c;
            mrequest.AccessLevel = member.Role__c;
            members.add(mrequest);
        }
        System.debug('Exit GetBetUsers : ' + members);
        return members;
    }

}