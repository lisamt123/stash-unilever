public without sharing class uw_BatchJobHelper 
{
    public static String NOT_RUNNING = 'NOT_RUNNING';
    
    public uw_BatchJobHelper()
    {
        
    }

  public void finishEnableExternalUsersForTsAndCs(List<uw_Terms_Conditions__c> batchRecs)
    {
        List<uw_Terms_Conditions__c> TnCs = [Select Status__c, Invitee_Email__c, Invite_Token__c, Invite_Expires__c, Invite_Accepted__c, Id, Bet_Name__c,Action_On_Accept__c, Sent_to_Email_Address__c From uw_Terms_Conditions__c where Status__c = 'Accepted' AND Action_On_Accept__c = 'Enable User'];
        
        List<String> userEmailAddrs = new List<String>(); 
        for (uw_Terms_Conditions__c tac: TnCs)
        {
            userEmailAddrs.add(tac.Invitee_Email__c);
        }
        // Creating a list of all the user Ids ,name validated against corresponding email addresses and external chatter license when the Batch Job is run
        //List<User> ActiveUsers = [select id , username , IsActive, UserType from user where email in:userEmailAddrs and UserType = 'CsnOnly' and IsActive = true ]; 
        Map<String,User> mapOfEmailToActiveUsers = new Map<String,User>();
        
        //Looping for all the active users
        for (User u : [select id , username , IsActive, UserType, Email from user where email in:userEmailAddrs and UserType = 'CsnOnly' and IsActive = true order by CreatedDate])
        {
            mapOfEmailToActiveUsers.put(u.Email, u); // Mapping active users with email addresses 
        }
System.debug('MAP--------'+mapOfEmailToActiveUsers);
          // We need to check the user is enabled?
          // Mark these as User Enabled
           for (uw_Terms_Conditions__c tac: TnCs) //Running a for loop against all the corresponding TnCs for the active user
          {
             if (mapOfEmailToActiveUsers.get(tac.Invitee_Email__c) != null) //If there is an active user with TnC invite update accordingly
            {
                tac.Status__c = 'User Enabled';
               //string x = [select username from user where email = :tac.Invitee_Email__c].username;//commented out as SOQL cant be there in a for loop
               tac.Sent_to_Email_Address__c = mapOfEmailToActiveUsers.get(tac.Invitee_Email__c).username ; 

            }
          }
 update TnCs;
    }
    
    
     public void enableExternalUsersForTsAndCs(List<uw_Terms_Conditions__c> batchRecs)
    {
        List<uw_Terms_Conditions__c> TnCs = [Select Status__c, Invitee_Email__c, Invite_Token__c, Invite_Expires__c, Invite_Accepted__c, Id, Bet_Name__c, Studio_Chatter_Group__c, Action_On_Accept__c From uw_Terms_Conditions__c where Id in: batchRecs];
        
        // Find the users for the external email addresses -
        List<String> userEmailAddrs = new List<String>(); 
        for (uw_Terms_Conditions__c tac: TnCs)
        {
            userEmailAddrs.add(tac.Invitee_Email__c);
        }
        
        List<User> usersToEnable = [Select id, IsActive, UserType from User where Email in : userEmailAddrs and UserType = 'CsnOnly' and IsActive = false];
        
        for (User u: usersToEnable)
        {
            u.IsActive = true;  
        }
        
        update usersToEnable;
        // TODO - Do we need to notify anyone?
        // Could we use the Tnc Rec Update to tell them they can now login?
    }
    
    
    public void sendCollaborationInvitesForAcceptedTsAndCs(List<uw_Terms_Conditions__c> batchRecs)
    {
        List<uw_Terms_Conditions__c> TnCs = [Select Status__c, Invitee_Email__c, Invite_Token__c, Invite_Expires__c, Invite_Accepted__c, Id, Bet_Name__c, Studio_Chatter_Group__c, Action_On_Accept__c From uw_Terms_Conditions__c where Id in: batchRecs];
        
        // TODO - If we have users who have accepted the t&c who already have got a invitation and a login - 
        // we can just enable their user?
        
        List<CollaborationInvitation> invitations = new List<CollaborationInvitation>();
        
        for (uw_Terms_Conditions__c tnc: TnCs)
        {
            CollaborationInvitation invite = New CollaborationInvitation();
            invite.SharedEntityId = tnc.Studio_Chatter_Group__c;
            invite.InvitedUserEmail = tnc.Invitee_Email__c;
            invitations.add(invite);
            tnc.Status__c = 'Invite Sent';
        }
    
        Database.Saveresult[] inviteResults = Database.insert(invitations, true);
        
        Database.Saveresult[] tncResults = Database.update(TnCs, true); 
    }
    
    public void markSendInviteJobAsFinished()
    {
        // Need to blank the current batch job Id
        uw_Custom_Setting__c batchJobInfo = uw_CustomSettingsManager.getCustomSetting('SEND_INVITE_BATCH_JOB_ID');
        batchJobInfo.Text_Value__c = uw_BatchJobHelper.NOT_RUNNING;
        Database.update(batchJobInfo);
    }
    
    public void cancelSendInviteJob()
    {
        uw_Custom_Setting__c batchJobInfo = uw_CustomSettingsManager.getCustomSetting('SEND_INVITE_BATCH_JOB_ID'); 
        
        if (!uw_HelperMethods.valueIsNull(batchJobInfo.Text_Value__c))
        {
            // Check it's not running
            if (batchJobInfo.Text_Value__c == NOT_RUNNING)
            {
                System.debug('This job is NOT running!');
                return;
            }
        }
        else
        {
            // Nothing to cancel
            System.debug('The job is NULL. Must not be running!');
            return;
        }
        
        System.abortJob(batchJobInfo.Text_Value__c);
        
        batchJobInfo.Text_Value__c = NOT_RUNNING;
        
        Database.update(batchJobInfo); 
    } 
    
    public void scheduleNextSendInviteBatchJob()
    {
        scheduleNextSendInviteBatchJob(new uw_SendCollaborationInviteBatchJob_Sch(), 'Send Collab Invites', 1);
    }
    
    public void scheduleNextSendInviteBatchJob(Schedulable job, String jobName, Integer waitTimeInMinutes)
    {  
        uw_Custom_Setting__c batchJobInfo = uw_CustomSettingsManager.getCustomSetting('SEND_INVITE_BATCH_JOB_ID');
        
        if (!uw_HelperMethods.valueIsNull(batchJobInfo.Text_Value__c))
        {
            // Check it's not running
            if (batchJobInfo.Text_Value__c != NOT_RUNNING)
            {
                System.debug('This job is already running!');
                return;
            }
        }
        
        Datetime sysTime = System.now();
        sysTime = sysTime.addMinutes(Integer.valueOf(waitTimeInMinutes));
         
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.debug(chron_exp);
        
        Id jobId = System.schedule(jobName + sysTime.getTime(),chron_exp,job);
        
        batchJobInfo.Text_Value__c = jobId;
        
        Database.update(batchJobInfo);
    }
    /* tests */
    
    private static testmethod void test_basic() {
        uw_Custom_Setting__c cs = new uw_Custom_Setting__c();
        cs.Name = 'SEND_INVITE_BATCH_JOB_ID';
        cs.Text_Value__c = '2112';
        insert cs;
        system.assert(cs.Id != null);

        List<uw_Terms_Conditions__c> TaCList = new List<uw_Terms_Conditions__c>();
        
        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;
        
        
        uw_BET__c bet = uw_UnitTestDataFactory.initBET('betName',true,inoPlanProject);
        uw_Terms_Conditions__c tac = uw_UnitTestDataFactory.initTac(bet, 'xyz@xyz.xyz.ajh', 'Enable User', true, true);
        TaCList.add(tac);
        
        uw_BatchJobHelper bjh = new uw_BatchJobHelper();
        system.assert(bjh != null);
        
        bjh.finishEnableExternalUsersForTsAndCs(TaCList);
        bjh.enableExternalUsersForTsAndCs(TaCList);
        bjh.sendCollaborationInvitesForAcceptedTsAndCs(TaCList);
        bjh.markSendInviteJobAsFinished();
        bjh.cancelSendInviteJob();
        bjh.scheduleNextSendInviteBatchJob();
    }
}