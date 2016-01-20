public without sharing class uw_TacHelper 
{
    
    public uw_TacHelper()
    {
        
    }
    
    
    public void handleUserAfterInserts(List<User> newUsers)
    {
        // If we have a new user that is an External User - 
        // and they are active - search for their TAC record matching on email address
        
        // If none exists - we need to create one. We also need to find the Collabl Group the user was added to
        // to do this we need to let the user be created first - and pass the handling to a future handler?
        List<Id> newExternalUsers = new List<Id>();
        for (User u: newUsers)
        {
            if (u.UserType.equalsIgnoreCase('CsnOnly'))
            {
                newExternalUsers.add(u.Id);
            }   
        }
        
        if (newExternalUsers.size() > 0)
        {
            uw_TacHelper.staticCreateTACSForNewExternalUsers(newExternalUsers);
        }
    }
    
    public void handleUserAfterUpdates()
    {
        
    }
    
    @future 
    public static void futureEnableUsersAfterAcceptTermsAndConditions(List<Id> newUserIds)
    {
        Map<Id,User> newUserMap = new Map<Id,User>([Select id, username, email, IsActive from User where Id in : newUserIds and UserType = 'CsnOnly']);
        for (User u: newUserMap.values())
        {
            // Should we add some other flad too - or TnC Status? Waiting / Accepted?
            u.IsActive = true;
        }
        
        update  newUserMap.values();
    }
    
    
    @future
    public static void futureCreateTACSForNewExternalUsers(List<Id> newUserIds)
    {
        
    }
    
    @future
    public static void futureDisableNewExternalUserWithNoTnc(List<Id> newUserIds)
    {
        Map<Id,User> newUserMap = new Map<Id,User>([Select id, username, email, IsActive from User where Id in : newUserIds and UserType = 'CsnOnly']);
        
        for (User u: newUserMap.values())
        {
            // Should we add some other flad too - or TnC Status? Waiting / Accepted?
            u.IsActive = false;
        }
        
        update  newUserMap.values();
    }
    
    public static void staticCreateTACSForNewExternalUsers(List<Id> newUserIds)
    {
        // Create a Map of Id to User
        Map<Id,User> newUserMap = new Map<Id,User>([Select id, username, email, IsActive from User where Id in : newUserIds and UserType = 'CsnOnly']);
        
        // Create a Map of email to User
        // Create a list of email
        Map<String,User> email2UserMap = new  Map<String,User>();
        List<String> newUserEmailAddrs = new List<String>();
        for (User u: newUserMap.values())
        {
            email2UserMap.put(u.Email,u);
            newUserEmailAddrs.add(u.Email);
        }
        
        // TODO
        // Do these user.emails already have TAC records?
        
        // Also Look for Collab Invitations
        // TODO - do we also need to look at status? Sent/Accepted/Cancelled
        List<CollaborationInvitation> invites = [Select Status, SharedEntityId, ParentId, InviterId, InvitedUserEmailNormalized, InvitedUserEmail From CollaborationInvitation where InvitedUserEmailNormalized in : newUserEmailAddrs];  
        
        // Create Map of email to CollaborationInvitation
        // Create List of CollaborationInvitation where SharedEntity is a collaboration group Id
        Map<String,CollaborationInvitation> email2InvitationMap = new Map<String,CollaborationInvitation>();
        List<Id> collabGroupIds = new List<Id>();
        for (CollaborationInvitation ci: invites)
        {
            email2InvitationMap.put(ci.InvitedUserEmailNormalized,ci);
            if (isCollaborationGroupId(ci.SharedEntityId))
            {
                collabGroupIds.add(ci.SharedEntityId);
            }
        }
        
        // Create a map of chatter group to bet
        List<uw_BET__c> listOfBets = [Select Id, Name, Studio_Chatter_Group__c from uw_Bet__c where Studio_Chatter_Group__c in : collabGroupIds];
        Map<String,uw_BET__c> collabGroup2BetMap = new Map<String,uw_BET__c>();
        
        for (uw_BET__c bet: listOfBets)
        {
            collabGroup2BetMap.put(bet.Studio_Chatter_Group__c, bet);
        } 
        
        // From the collab invites - we need to find the collab groups - 
        // from these we need to be able to find the associated Bets
         
        // Look for Tac Records and Collab Invitations too.
        // Create a map of email to tac
        List<uw_Terms_Conditions__c> tacRecords = [Select uw_BET__c, Studio_Chatter_Group__c, Status__c, Invitee_Email__c, Invite_Token__c, Invite_Expires__c, Invite_Accepted__c, Bet_Name__c, InvitefromChatter__c, Sent_to_Email_Address__c From uw_Terms_Conditions__c where Invitee_Email__c in : newUserEmailAddrs];
        Map<String, uw_Terms_Conditions__c> emailToTacMap = new Map<String, uw_Terms_Conditions__c>();
        
        for (uw_Terms_Conditions__c tac: tacRecords)
        {
            emailToTacMap.put(tac.Invitee_Email__c,tac);
        }
        
        // Lets look at each user - 
        List<User> usersToDisable = new List<User>();
        List<Id> usersIdsToDisable = new List<Id>();
        List<uw_Terms_Conditions__c> tacRecordsToCreate = new List<uw_Terms_Conditions__c>();
        List<uw_Terms_Conditions__c> tacRecordsToUpdate = new List<uw_Terms_Conditions__c>();
    
        for (User u: newUserMap.values())
        {
            // Do they have a Collab Invite?
            CollaborationInvitation invite = email2InvitationMap.get(u.Email);
            uw_Terms_Conditions__c tacRec = emailToTacMap.get(u.Email);
            
            if (null == tacRec)
            {
                // We have no tac record - need to disable the user - send them an email - and create a tac record
                if (null != invite)
                {
                    tacRecordsToCreate.add(populateTacRecord(u.Email,collabGroup2BetMap.get(invite.SharedEntityId)));
                    u.IsActive = false;
                    usersToDisable.add(u);
                    usersIdsToDisable.add(u.Id);
                }
            }
            else
            {
                // Two possibilities here
                // MOST LIKELY: User has a TaC and a CollaborationInvitation. The user has accepted TaC and has followed link to create salesforce user
                //   Chatter will show status change from 'Invite Sent' to 'Logged In'
                // UNLIKELY: User has a TaC but has not accepted TaC. Someone in Salesforce has just created a salesforce user with same email address!
                //   Chatter will show status change of 'Sent' to 'Logged In'
                if (tacRec.Status__c == 'Invite Sent') {
                    tacRec.Status__c = 'Logged In';
                    tacRecordsToUpdate.add(tacRec);
                } else if (tacRec.Status__c == 'Sent') {
                    // resend the invite to go down the scenario 2 route
                    tacRec.Status__c = 'Send';
                    tacRecordsToUpdate.add(tacRec);

                    // disable the user
                    u.IsActive = false;
                    usersToDisable.add(u);
                    usersIdsToDisable.add(u.Id);
                }
            }
        }
        
        if (tacRecordsToCreate.size() > 0)
        {
            createTacRecordsAndTriggerMails(tacRecordsToCreate);
        }
        
        if (tacRecordsToUpdate.size() > 0) {
            update tacRecordsToUpdate;
        }
        
        // TODO - issue with Mixed DML !!
        // Pass toa future method - 
        if (usersToDisable.size() > 0)
        {
            // Database.update(usersToDisable);
            uw_TacHelper.futureDisableNewExternalUserWithNoTnc(usersIdsToDisable);
        }
    }
    
    public static uw_Terms_Conditions__c populateTacRecord(String inviteeEmail, uw_Bet__c bet)
    {
        uw_Terms_Conditions__c tnc = new uw_Terms_Conditions__c();
        tnc.Action_On_Accept__c = 'Enable User';
        string x = [select username from user where email = :inviteeEmail].username;
        tnc.Sent_to_Email_Address__c = x;        
        tnc.Status__c = 'New';
        tnc.Invitee_Email__c = inviteeEmail;
        // .Invite_Token__c,
        tnc.Invite_Expires__c = System.now().addDays(14); 
        //.Invite_Accepted__c
        // This should be stored in local member variable!!
        
        if(bet <> null)
        {
        tnc.Bet_Name__c = bet.Name;
         tnc.uw_BET__c = bet.Id;
        tnc.Studio_Chatter_Group__c = bet.Studio_Chatter_Group__c;
        
        }
        else
        {
        tnc.Bet_Name__c = 'Chatter';
        }
        
        
      
        //insert tnc;
            
        // TODO - generate a better token than this - 
        // Add other values / org/ email/etc
        //tnc.Invite_Token__c = tnc.Id;
        //tnc.Status__c = 'Send';
        //update tnc;
        
        return tnc;
    }
    
    public static List<uw_Terms_Conditions__c> createTacRecordsAndTriggerMails(List<uw_Terms_Conditions__c> tacRecords)
    {
        // Insert the records - 
        // generate the tokens - and update to to Send
        // TODO Create a token helper
        
        insert tacRecords;
        
        // create a token helper
        uw_TokenHelper th = new uw_TokenHelper();

        for (uw_Terms_Conditions__c tac : tacRecords)
        {
            // encrypt the token
            th.taCId = tac.id;
            String encoded = th.encode();
            // encode it for a URL
            String encodedForURL = th.makeTokenForURL(encoded);

            // retire - we now use the encoded token
            //tac.Invite_Token__c = tac.Id;
            tac.Invite_Token__c = encodedForURL;
            tac.Status__c = 'Send'; 
            tac.InvitefromChatter__c = true;            
        }
        
        update tacRecords;
        
        return tacRecords;
    }
        
    public static Boolean isCollaborationGroupId(String recId)
    {
        if (recId.substring(0,3) == '0F9')
        {
            return true;    
        }
        
        return false;
    }
    
    private static testmethod void test_basic() {
        uw_Custom_Setting__c cs = new uw_Custom_Setting__c();
        cs.Name = 'TERMS_AND_CONDITIONS_ID';
        cs.Text_Value__c = '068c00000005aeJAAQ';
        insert cs;
        system.assert(cs.Id != null);
        
        uw_Custom_Setting__c cs2 = new uw_Custom_Setting__c();
        cs2.Name = 'TOKEN_KEY';
        cs2.Text_Value__c = 'GTq2xh0iIt45Pw8Ij8os+rOJNANxAWjJYRtyfhgnUAQ=';
        insert cs2;
        system.assert(cs2.Id != null);

        uw_TacHelper th = new uw_TacHelper();
        system.assert(th != null);
        
        th.handleUserAfterUpdates();
    
        uw_Terms_Conditions__c tc = new uw_Terms_Conditions__c();
        tc.Invite_Expires__c = System.now()+1;
        tc.Invitee_Email__c = 'aEmail@yyy.yyy.com';
        tc.Status__c = 'Accepted';
        List<uw_Terms_Conditions__c> tacRecords = new List<uw_Terms_Conditions__c>();
        tacRecords.add(tc);
        
        uw_TacHelper.createTacRecordsAndTriggerMails(tacRecords);
        
        uw_TacHelper.isCollaborationGroupId(tc.Id);
        
    
    }

    private static testmethod void test_static() {
        final String email = 'inviteeEmail@a.b.c.edu.edu';
        final String email2 = 'inviteeEmail2@a.b.c.edu.edu';
        User u1 = uw_UnitTestDataFactory.initExternalUser('test', email, 'LastName', email);
        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;
        uw_BET__c bet = uw_UnitTestDataFactory.initBET('betName', true,inoPlanProject);
        
        uw_TacHelper.populateTacRecord(email, bet);       
    }
    
    private static testmethod void test_futures() {
        User u1 = uw_UnitTestDataFactory.initInternalUser('aAlias1', 'aEmail1@a.b.edu.edu', 'aLastName1', 'aEmail1@a.b.edu.edu');
        User u2 = uw_UnitTestDataFactory.initInternalUser('aAlias2', 'aEmail2@a.b.edu.edu', 'aLastName2', 'aEmail2@a.b.edu.edu');
        User ue3 = uw_UnitTestDataFactory.initExternalUser('aAlias3', 'aEmail3@a.b.edu.edu', 'aLastName3', 'aEmail3@a.b.edu.edu');

        List<Id> newUserIds = new List<Id>();
        newUserIds.add(u1.Id);
        newUserIds.add(u2.Id);
        newUserIds.add(ue3.Id);

        // @future tests
        Test.startTest();
            uw_TacHelper.futureEnableUsersAfterAcceptTermsAndConditions(newUserIds);
            uw_TacHelper.futureCreateTACSForNewExternalUsers(newUserIds);
            uw_TacHelper.futureDisableNewExternalUserWithNoTnc(newUserIds);
        Test.stopTest();        
    } 
}