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
1.1 -   Blessy Voola            17 Mar 2015     T0-Fix to resolve the issue-when a user clicks access toolkit, user is redirected to bet home page.
1.2 -    Blessy Voola            28 Apr 2015    T1-Fix to resolve the issue-User with CB4L Hub admin permission set cannot access chatter on toolkit page for public BET.
**********************************************************************/
/* withour sharing sue to this is service class */
public without sharing class BET_CommonService {

    public static final String BET_REQUEST_ACCESS = 'BET_Request_Access';
    public static final String BET_REQUEST_ACCESS_ALREADY_PENDING = 'BET_Request_Access_Already_Pending';
    public static final String BET_REQUEST_ACCESS_OWNER = 'BET_Request_Access_Owner';

    public static final String BET_HUB_ADMIN_PERM_SET = 'CB4L_HUB_Admin';
    public static final String BET_OPERATION_ADMIN_PERM_SET = 'BET_Operation_Admin';


    public class BetException extends Exception {}
    
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

        if (userPermissions != null && userPermissions.size() > 0) {
            for (PermissionSet userPermission : userPermissions) {
                if (userPermission.ObjectPerms != null && userPermission.ObjectPerms.size() > 0) {
                    for (ObjectPermissions op : userPermission.ObjectPerms) {
                        if (checkReadOnly && op.PermissionsViewAllRecords) {
                            return true;
                        } 
                        else if (!checkReadOnly && op.PermissionsModifyAllRecords)
                               {
                             return true;
                             }
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
            if(teamMemberList.size() > 0 && teamMemberList[0].Role__c == 'Manager'){
                isAllowed = true;
            }else{
                List<uw_BET__c> betList = [SELECT Id, Name, OwnerId FROM uw_BET__c WHERE Id = :betId LIMIT 1];
                if(betList.size() > 0 && betList[0].OwnerId == currentUserId){
                    isAllowed = true;
                }   
            }
        } 
        return isAllowed;  
    }

    /*****************************************************************************************
    Purpose: Checks if user is already member of BET with status PENDING
    Parameters: String String
    Returns: Boolean
    ******************************************************************************************/  
    /*private static Boolean isExistingPendingUser(String email, String betId){
        List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Pending_Request__c, Email__c, Team_Member__c, Team_Member__r.Name, Name, Role__c, StudioEnabled__c, 
                                                BETEnabled__c, IsOwner__c, Editing__c 
                                                FROM uw_Bet_Team_Member__c 
                                                WHERE Email__c= :email AND Pending_Request__c = true AND 
                                                BET__c = :betId]; 

        if(teamMemberList.size() > 0){
            return true;
        }else{
            return false;
        }
    }*/

    /*****************************************************************************************
    Purpose: Function to send email to owner of bet
    Parameters: uw_BET__c, Id, BET_Request_Access__c
    ******************************************************************************************/  
    public static void sendApprovalMailToOwner(uw_BET__c bet, Id userId, BET_Request_Access__c settings){        
        User usr = [SELECT Id, Name, Email FROM User WHERE Id =: userId LIMIT 1];

        String template = BET_CommonService.generateTemplate(bet, usr, settings); 
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
    Purpose: Function to generate template of mail basing on BET, user and custom settings
    Parameters: uw_BET__c, User, BET_Request_Access__c
    Returns: String
    ******************************************************************************************/  
    private static String generateTemplate(uw_BET__c bet, User usr, BET_Request_Access__c settings){
        String siteUrl = String.valueOf(Url.getSalesforceBaseUrl().toExternalForm());

        String template = '<table style="color: #222; font-size: 12px; font-family: Arial, Helvetica, sans-serif; line-height: 15px;" border="0" width="600">'
                            +'<tbody><tr><td>'
                            +'<table style="color: #222; font-size: 12px; font-family: Arial, Helvetica, sans-serif; line-height: 15px;" border="0" width="600">'
                            +'<tbody><tr>'
                            +'<td colspan="2">'
                                +'<div class="headlineText" style="margin-top: 30px; margin-bottom: 19px;">'
                                +'<a href="'+siteUrl+'/'+usr.Id+'" style="text-decoration:none; color: #015ba7;" target="_blank" title="This external link will open in a new window">'+usr.Name+'</a> '
                                +'requested access to the BET <a href="'+siteUrl+'/'+bet.Id+'" style="text-decoration:none; color: #015ba7;" target="_blank" title="This external link will open in a new window">'+bet.Name+'</a> '
                                +'<span style="color:#888;font-size:13px;font-weight:normal;">('+bet.Sharing__c+' With Customers)</span>.<br></div>' 
                            +'</td>'
                            +'</tr>'                  
                            +'<tr><td colspan="2"><div class="messageSmallText" style="width: 600px;">'
                            +'To view this BET, go to: <br><a href="'+siteUrl+'/'+bet.Id+'" style="text-decoration:none; color: #015ba7;" class="smallLinkStyle" target="_blank" title="This external link will open in a new window">'
                            +' '+siteUrl+'/'+bet.Id+'</a></div>'
                            +'</td></tr>'
                            +'</tbody></table></td>'
                            +'</tr><tr><td>'
                            +'<br><div class="footerText">'
                            +'<div class="emailfootertext" emloc="_footer_" style="font-family: Arial, Helvetica, sans-serif; color: #7d7d84; line-height: 14px; font-size: 11px;">'
                            +'This email was sent to the user <a href="'+siteUrl+'/'+bet.OwnerId+'?fromEmail=1" style="text-decoration:none; color: #015ba7;" target="_blank" title="This external link will open in a new window">'+bet.Owner.Email+'</a>.<br>';
                            if(settings.Logo_Url__c != null && settings.Logo_Url__c != ''){
                                template += '<br><img src="'+settings.Logo_Url__c+'" alt="Logo" title="Logo">';
                            }                           
                            template +=''+settings.Footer__c+'</div></div>'
                            +'</td>'
                            +'</tr></tbody></table>';
        return template;
    }

    /*****************************************************************************************
    Purpose: Function to create BET Team member
    Parameters: Id, Id, String, String, Boolean, String
    Returns: uw_Bet_Team_Member__c
    Throws [Exceptions]: [optional]
    ******************************************************************************************/  
    /*private static uw_Bet_Team_Member__c createBetTeamMember(Id userId, Id betId, String roleName, String accessName, Boolean isPending, String email) {        
        uw_Bet_Team_Member__c teamMember = new uw_Bet_Team_Member__c();
        teamMember.Team_Member__c = userId;
        teamMember.BET__c = betId;
        teamMember.Role__c = roleName;
        teamMember.Access_Level__c = accessName;
        teamMember.BETEnabled__c = false;                 
        teamMember.Pending_Request__c = isPending;
        teamMember.Email__c = email;
        
        try {
            insert teamMember;   
        }catch(Exception qe) {
            throw new BetException('Problem with inserting BET member.',qe);
        }       
        
        return teamMember;
    }*/

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
            //User owner;
            //if(settings.Send_Mail_To_Owner__c){
            //    owner = [SELECT Id, Email, Name FROM User WHERE Id = :bet.OwnerId];
            //}        

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

            //if(BET_CommonService.isExistingPendingUser(email, betId)){
                 //commented out because of issue #88
                //BET_CommonService.sendAlreadyPendingMail(betId, email, userId);
            //    return false;
            //}else{
            //    try{                
            //        uw_Bet_Team_Member__c teamMember = BET_CommonService.createBetTeamMember(userId, betId, 'Member', 'Toolkit Experience (Toolkit only)', true, email);
                    //commented out because of issue #88
                    //BET_CommonService.sendApprovalMail(betId, email, userId);
            //        if(settings.Send_Mail_To_Owner__c){
             //           BET_CommonService.sendApprovalMailToOwner(bet, userId, settings);
             //       }
            //        return true;
            //    }catch(Exception e){
            //        throw new BetException ('Problem occured while creating new member or sending mail',e);
            //    }
            //}
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

        uw_BET__Share betShare = deleteBETShare(teamMember);      
        CollaborationGroupMember cgm = deleteCollaborationGroupMember(teamMember);        
        EntitySubscription entitySubscription = deleteEntitySubscription(teamMember);
        
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
    Purpose: Support method to get a BETShare object 
    Parameters:  uw_BET_Team_Member__c
    Returns: BETShare object 
    ******************************************************************************************/ 
    private static uw_BET__Share deleteBETShare(uw_BET_Team_Member__c teamMember) {
        List<uw_BET__Share> betShareList = [SELECT Id FROM uw_BET__Share WHERE ParentId = :teamMember.Team_Member__c AND userOrGroupId = :teamMember.Id LIMIT 1]; 
        if (betShareList.isEmpty()) {
           System.Debug('No BET Share is found');
           return null;
        }
        
        return betShareList[0];
    }

    /*****************************************************************************************
    Purpose: Support method to get a CollaborationGroupMember object 
    Parameters: uw_BET_Team_Member__c
    Returns: CollaborationGroupMember object
    ******************************************************************************************/
    private static CollaborationGroupMember deleteCollaborationGroupMember(uw_BET_Team_Member__c teamMember) {
        Id chatterGroupId = teamMember.BET__r.Studio_Chatter_Group__c;
        List<CollaborationGroupMember> cgmList = [SELECT Id FROM CollaborationGroupMember WHERE CollaborationGroupId =: chatterGroupId AND memberId=:teamMember.Team_Member__c];
        if ( cgmList.isEmpty()) {
           System.Debug('No CollaborationGroupMember found.');
           return null;
        }
        
        return cgmList[0];
    }

    /*****************************************************************************************
    Purpose: Support method to get an EntitySubscription object
    Parameters: uw_BET_Team_Member__c
    Returns: EntitySubscription object
    ******************************************************************************************/
    private static EntitySubscription deleteEntitySubscription(uw_BET_Team_Member__c teamMember) {
        List<EntitySubscription> entitySubscriptionList = [Select Id,SubscriberId,ParentId from EntitySubscription where SubscriberId=:teamMember.Team_Member__c and ParentId=:teamMember.BET__c LIMIT 1];
        if ( entitySubscriptionList.isEmpty() ) {
           System.Debug('No CollaborationGroupMember found.');
           return null;
        }
        
        return entitySubscriptionList[0];        
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
        if(isadmin&&ishubadmin||!isadmin){
       // if (!BET_CommonService.hasAccess(false)) {
               /*T1-End*/
            try {
                uw_BET__c bet = [ SELECT Sharing__c, Id, Studio_Chatter_Group__c, 
                                    (SELECT Id,Team_Member__c FROM BET_Team_Members__r WHERE Team_Member__c =: userId) 
                                FROM uw_BET__c
                                WHERE Id = :betId ];
                if (bet.Sharing__c == 'Public'  && (bet.BET_Team_Members__r == null || bet.BET_Team_Members__r.isEmpty())) {
                    BET_CommonService.addUserToPublicBET(bet, userId);
                    
                }
            } catch (Exception e){
                throw new BetException('No BET found.',e);
           }
        }
    }

    /*****************************************************************************************
    Purpose: Method to add user to a BET as a member
    Parameters: Id, Id
    ******************************************************************************************/
    private static void addUserToPublicBET(uw_BET__c bet, Id userId){
        
        BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues('BETManageMembersConfig');
        String ToolkitAccessLevel = BETManageMembersConfig.ToolkitAccessLevel__c;
        String InternalUserRecordType = BETManageMembersConfig.InternalUserRecordType__c;
        String BETMemberObjectName = BETManageMembersConfig.BET_Member_Object_Name__c;

        uw_BET_Team_Member__c BETTeamMember = new uw_BET_Team_Member__c();
        List<RecordType> recordTypeIdList = [SELECT Id FROM RecordType WHERE SobjectType = :BETMemberObjectName and Name = :InternalUserRecordType LIMIT 1];
        if ( recordTypeIdList.isEmpty()) {
            System.Debug('No RecordType found');
            return;
        }     
        //recordTypeId = recordTypeIdList[0];
        BETTeamMember.recordTypeId = recordTypeIdList[0].Id;
        BETTeamMember.Team_Member__c = userId;
        BETTeamMember.BET__c = bet.Id;
        BETTeamMember.BETEnabled__c = true;
        BETTeamMember.Access_Level__c = ToolkitAccessLevel;

        //  T0-Begin---------------------
        /*done by member trigger
        List<EntitySubscription> eslist= [SELECT Id FROM EntitySubscription
                                                    WHERE SubscriberId=: userId and ParentId=: bet.Id];
        EntitySubscription entitySubscription = new EntitySubscription();
        */
        //T0-End--------------------- 

        /*done by member trigger
        List<CollaborationGroupMember> cgmList = [SELECT Id FROM CollaborationGroupMember 
                                                    WHERE MemberId =: userId and CollaborationGroupId =: bet.Studio_Chatter_Group__c];                                       
        CollaborationGroupMember cgm;
        if (cgmList.isEmpty()) {
            cgm = new CollaborationGroupMember();
            cgm.CollaborationGroupId = bet.Studio_Chatter_Group__c;
            cgm.MemberId = userId;
            cgm.NotificationFrequency = 'N';
            cgm.CollaborationRole = 'Standard';
        }
        
        uw_BET__Share betShare = new uw_BET__Share();
        betShare.UserOrGroupId = userId;
        betShare.AccessLevel = 'Read';
        betShare.ParentId = bet.Id;
        
        */
      
        Savepoint sp = Database.setSavepoint();
        try {
            insert BETTeamMember;
            /*insert betShare; done by member trigger
            if (cgm!= null) {
                insert cgm;
            }*/
             //T0-Begin---------------------
        /*/*done by member trigger
        if(eslist.isempty())
        {
        entitySubscription.SubscriberId = userId;
        entitySubscription.ParentId = bet.Id;
        if(entitySubscription!=null){
           insert entitySubscription;
            }
              //T0-End---------------------
        }         */
          
        } catch (Exception e) {
           Database.rollback(sp);
           throw new BetException('Cannot access BET',e);
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
    
}