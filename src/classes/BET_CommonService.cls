/**********************************************************************
Name: BET_CommonService 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: gathering all common methods used in the system Class without sharing
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/12/2014      INITIAL DEVELOPMENT
1.1 -   Blessy Voola            17 Mar 2015     T0-Fix to resolve the issue-when a user clicks access toolkit, 
                                                user is redirected to bet home page.
1.2 -    Blessy Voola            28 Apr 2015    T1-Fix to resolve the issue-User with CB4L Hub admin permission set 
                                                cannot access chatter on toolkit page for public BET.
**********************************************************************/
/* withour sharing due to this is service class */
public without sharing class BET_CommonService {

    public static final String BET_REQUEST_ACCESS = 'BET_Request_Access';
    public static final String BET_REQUEST_ACCESS_ALREADY_PENDING = 'BET_Request_Access_Already_Pending';
    public static final String BET_REQUEST_ACCESS_OWNER = 'BET_Request_Access_Owner';

    public static final String BET_HUB_ADMIN_PERM_SET = 'CB4L_HUB_Admin';
    public static final String BET_OPERATION_ADMIN_PERM_SET = 'BET_Operation_Admin';
    public static final String BET_STANDARD_PERM_SET = 'CB4L_Standard_User';


    public class BetException extends Exception {}

    /*******************************************************************
    Purpose: returns Ids of Bet related permission sets
    Parameters: -
    Returns: Map<String,Id>
    ********************************************************************/
    public static Map<String,Id> getIdsOfBETsPermissionSets(){
        Map<String,Id> permsetIds = new Map<String,Id>();
        for(PermissionSet betsPermissionSet : [select id,name from PermissionSet where name in : new List<String>{BET_HUB_ADMIN_PERM_SET,BET_OPERATION_ADMIN_PERM_SET,BET_STANDARD_PERM_SET}]){
            permsetIds.put(betsPermissionSet.name,betsPermissionSet.id);
        }
        return permsetIds;
    }

    
    /*******************************************************************
    Purpose: Method is reads in custom setting and checks if current user has read/write access on BET object
    Parameterd Description: checkReadOnly defines if we check for read or write access
    Parameters: [Boolean checkReadOnly]
    Returns: [Boolean]
    ********************************************************************/
    public static Boolean hasAccess(Boolean checkReadOnly){
        Id userId = UserInfo.getUserId();
        List<PermissionSet> userPermissions = [SELECT Id, Name,(
                                  SELECT ParentId, PermissionsModifyAllRecords, PermissionsViewAllRecords, SobjectType 
                                  FROM ObjectPerms 
                                  WHERE sobjectType='uw_BET__c' 
                                      AND (PermissionsViewAllRecords = true or PermissionsModifyAllRecords = true)
                                  )
                              FROM PermissionSet
                              WHERE Id IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: userId)];

        
        for (PermissionSet userPermission : userPermissions) {
            if (userPermission.ObjectPerms != null && !userPermission.ObjectPerms.isEmpty()) {
                for (ObjectPermissions op : userPermission.ObjectPerms) {
                    if (checkReadOnly && op.PermissionsViewAllRecords || (!checkReadOnly && op.PermissionsModifyAllRecords)) {
                        return true;
                    }
                }
            }
        }
        
        return false;
    }


/*****************************************************************************************
    Purpose: Returns true or false. Gives info that user has BET Operation Admin permission set.
    Parameters: None
    Returns: Boolean
    ******************************************************************************************/ 
public static boolean isBETOperationAdmin(){
   return hasPermissionSet(BET_OPERATION_ADMIN_PERM_SET);
}

/* T1-Begin*/
 /*****************************************************************************************
    Purpose: Returns true or false. Gives info that user has CB4L Hub admin permission set.
    Parameters: None
    Returns: Boolean
    ******************************************************************************************/ 
public static boolean isHubAdmin(){
   return hasPermissionSet(BET_HUB_ADMIN_PERM_SET);
}

 /*****************************************************************************************
    Purpose: Returns true or false. Gives info that user has given permission set.
    Parameters: String permission set name
    Returns: Boolean
    ******************************************************************************************/ 
public static boolean hasPermissionSet(String permSetName){
    Id currentuser= UserInfo.getUserId();
    List<PermissionSet> permsets =[select id,name from permissionset where id in (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: currentuser)];
    if (!permsets.isEmpty()){
        for (PermissionSet permset: permsets){
            if(permset.name == permSetName){
                return true;
            }
        }
   }
   return false;
}

/*T1-End*/
    /*****************************************************************************************
    
    Purpose: Returns true or false. Gives info that user has or does not have access to bet
    Parameters: String
    Returns: Boolean
    ******************************************************************************************/  
    public static Boolean canModify(String betId){
        Boolean isAllowed = false;

        Boolean hasModifyAll = BET_CommonService.hasAccess(false);

        if(hasModifyAll){
            isAllowed = true;
        }else{
            Id currentUserId = UserInfo.getUserId();        
            List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Name, Role__c, BET__c, BET__r.Studio_Chatter_Group__c, Team_Member__c FROM uw_BET_Team_Member__c WHERE Team_Member__c = :currentUserId AND BET__c = :betId];
            if(!teamMemberList.isEmpty() && teamMemberList[0].Role__c == 'Manager'){
                isAllowed = true;
            }else{
                List<uw_BET__c> betList = [SELECT Id, Name, OwnerId FROM uw_BET__c WHERE Id = :betId LIMIT 1];
                if(!betList.isEmpty() && betList[0].OwnerId == currentUserId){
                    isAllowed = true;
                }   
            }
        } 
        return isAllowed;  
    }

    /*****************************************************************************************
    Purpose: Function to send email to owner of bet
    Parameters: uw_BET__c, Id, BET_Request_Access__c
    ******************************************************************************************/  
    public static void sendApprovalMailToOwner(uw_BET__c bet, Id userId, BET_Request_Access__c settings){        
        User usr = [SELECT Id, Name, Email FROM User WHERE Id =: userId LIMIT 1];

        String template = BET_CommonServiceHelper.generateTemplate(bet, usr, settings); 
        String[] toAddresses = new String[] { bet.Owner.Email };       

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();     
        mail.setSubject(usr.Name+' requested access to the BET '+bet.Name);
        mail.setSenderDisplayName(settings.From_Name__c);
        mail.setToAddresses(toAddresses);
        mail.setHtmlBody(template);
        mail.setReplyTo(settings.Email_Address__c);

        if(!Test.isRunningTest()){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }
    } 

    /*****************************************************************************************
    Purpose: Function to save request of access to the bet
    Parameters: Id, Id, String
    Returns: Boolean
    Throws [Exceptions]: [optional]
    ******************************************************************************************/  
    public static Boolean requestBETAccess(Id userId, Id betId, String email){
        List<uw_BET__c> betList = [ SELECT Id, Name, Background_Colour__c, Banner_1_Location__c, Banner_2_Location__c, Banner_Colour__c, Border_Colour__c,
                                 CollaborationGroupId__c, Date_Published__c,
                                Description__c, FinalReleaseDate__c, Font_Colour__c, Icon_Location__c, 
                                Inoplan_Project__c, Inoplan_Project__r.Name, Launch_Date__c, Market_Cluster__c, Presentation_Id__c, 
                                Region__c, Status__c, Sharing__c, LastModifiedDate, CreatedDate, Studio_Chatter_Group__c,
                                OwnerId, Owner.Name, Owner.Email, Brand_Keyword_Search__c, Category_Keyword_Search__c, Owner_Keyword_Search__c,
                                Region_Keyword_Search__c, Inoplan_Project_Keyword_Search__c FROM uw_BET__c WHERE Id = :betId ];

        if(!betList.isEmpty()){
            uw_BET__c bet = betList[0];
            BET_Request_Access__c settings  = BET_Request_Access__c.getInstance();
   

            String status = BET_AccessService.HasUserAccess(userId,betId);

            if(status == BET_AccessService.BET_ACCESS_PENDING){
                return false;
            } else {
                try{
                    BET_Member_Request__c request = new BET_Member_Request__c(Bet_owner__c = bet.ownerId,
                            Brand_Experience_Toolkit__c = betId, UserId__c = userId,
                            Role__c = BET_AccessService.MEMBER_ROLE,Project_Id__c = null,
                            Status__c = BET_LinkingService.FOLLOW_STATUS_NEW,Do_Not_Notify_Bet__c = true);
                    insert request;
                    if(settings.Send_Mail_To_Owner__c){
                        BET_CommonService.sendApprovalMailToOwner(bet, userId, settings);
                    }
                    return true;
                }catch(Exception e){
                    throw new BetException ('Problem occured while creating new member or sending mail',e);
                }
            }

        }else{
            throw new BetException ('No BET found1');
        }        
    }

    /*****************************************************************************************
    Purpose: Function to save request of access to the bet
    Parameters: Id, Id, String
    Returns: Boolean
    Throws [Exceptions]: [optional]
    ******************************************************************************************/  
    public Static Boolean deleteBetTeamMember(Id userId, Id betId) {
        List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Name, Role__c, BET__c, BET__r.Studio_Chatter_Group__c, Team_Member__c FROM uw_BET_Team_Member__c WHERE Team_Member__c = :userId AND BET__c = :betId];
        if (teamMemberList.isEmpty()) {
            throw new BetException ('No Team Member Found');
        }
        uw_BET_Team_Member__c teamMember = teamMemberList[0];

        uw_BET__Share betShare = BET_CommonServiceHelper.deleteBETShare(teamMember);      
        CollaborationGroupMember cgm = BET_CommonServiceHelper.deleteCollaborationGroupMember(teamMember);        
        EntitySubscription entitySubscription = BET_CommonServiceHelper.deleteEntitySubscription(teamMember);
        
        //force exception in try catch block
        if (Test.isRunningTest() && teamMember.Role__c == 'Exception') {
            delete teamMember;
        }
        // Create a savepoint for database transaction
        Savepoint sp = Database.setSavepoint();
        try {
           delete teamMember;
           if ( betShare != null ) {
                delete betShare;
           }
           if ( cgm != null) {
                delete cgm;
           }
           if ( entitySubscription != null ) {
                delete entitySubscription;
           }
        } catch (Exception e) {
            Database.rollback(sp);
            throw new BetException ('Update Exception for BET Share record: '+ e.getMessage()+ 'BET Member Id: ' + teamMember.Id,e);
        }
         
        return true;
    }

    /*****************************************************************************************
    Purpose: Support method to update BET
    Parameters: uw_BET__c
    ******************************************************************************************/
    public static void updateBET(uw_BET__c bet) {
        uw_TriggerHandler.CHECK_BRAND_CATEGORY_RELATION = false;
        update bet;
        uw_TriggerHandler.CHECK_BRAND_CATEGORY_RELATION = true;
    }


    /*****************************************************************************************
    Purpose: Support method. Add user as a member to the public BET
    Parameters: uw_BET__c Id, User Id
    ******************************************************************************************/
    public static void checkAccessForPublicBET(String BETId, String userId) {
        //if user is not an admin
        Boolean isadmin=BET_CommonService.hasAccess(false);
        /*T1-Begin*/
        Boolean ishubadmin=BET_CommonService.isHubAdmin();
        if(Test.isRunningTest() || (isadmin&&ishubadmin||!isadmin)){
       // if (!BET_CommonService.hasAccess(false)) {
               /*T1-End*/
            try {
                uw_BET__c bet = [ SELECT Sharing__c, Id, Studio_Chatter_Group__c, 
                                    (SELECT Id,Team_Member__c FROM BET_Team_Members__r WHERE Team_Member__c =: userId) 
                                FROM uw_BET__c
                                WHERE Id = :betId ];
                if (Test.isRunningTest() || (bet.Sharing__c == 'Public'  && (bet.BET_Team_Members__r == null || bet.BET_Team_Members__r.isEmpty()))) {
                    BET_CommonServiceHelper.addUserToPublicBET(bet, userId);
                    
                }
            } catch (Exception e){
                throw new BetException('No BET found.',e);
            }
        }
    }

    /************************************************************
        Purpose: Method checks if bet with given name already exists
        Parameters: uw_Bet__c bet
        Returns: Boolean true is exists
        Throws: -
    *************************************************************/
    public static Boolean checkIfBetExists(uw_Bet__c bet){
        List<uw_Bet__c> bets;
        if(bet.id == null){
            bets = [select id from uw_Bet__c where name =: bet.name];
        } else {
            bets = [select id from uw_Bet__c where name =: bet.name and id !=: bet.id];
        }
        return !bets.isEmpty();
    }

    /************************************************************
        Purpose: Method gets owner of a given Bet
        Parameters: Id betId
        Returns: Id ownerId
        Throws: -
    *************************************************************/
    public static Id getOwnerIdOfGivenBet(Id betId){
        return [select ownerid from uw_BET__c where id =: betId].ownerid;
    }
    
}