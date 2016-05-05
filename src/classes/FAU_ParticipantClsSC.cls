/********************************************************************
 Name:  FAU_ParticipantClsSC()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class handles the Program trigger functionality.                          
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   0.1   Jack Dermody      18/09/2014        INITIAL DEVELOPMENT   
   1.0   Jack Dermody      18/09/2014        Coding Standards          
***********************************************************************/
public with sharing class FAU_ParticipantClsSC {

    public static void submitforApprovals(FAU_Participant__c newParticipant, FAU_Participant__c oldParticipant)
    {
        // FAU Request New Personal Assistant User
        //for (Integer i = 0; i < newParticipant.size(); i++) {
        if (newParticipant.FAU_Request_PA_User_Email_Address__c <>  oldParticipant.FAU_Request_PA_User_Email_Address__c
                    && newParticipant.FAU_Request_PA_User_Email_Address__c <> null 
                    && newParticipant.FAU_Personal_Assistant__c == null) {

            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(newParticipant.Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful
            System.debug('Submitted for approval successfully: '+result.isSuccess());

        }
        //} 
        
    }
     /*******************************************************************
       Purpose:     Set FAU_Is_deferred_To_PA__c for participant
    ********************************************************************/ 
    public static void setIsdeferredToPA(FAU_Participant__c newParticipant){
        if (newParticipant.FAU_Personal_Assistant__c <> null){
            newParticipant.FAU_Is_deferred_To_PA__c = true;
        }else{
            newParticipant.FAU_Is_deferred_To_PA__c = false;
        }
    }
    
    public static void removeParticipantsFromChatterGroup(List<FAU_Participant__c> participants){
        Set<String> members = new Set<String>();
        Set<String> groups = new Set<String>();
        Map<Id,String> programChatterGroup = new Map<Id,String>();
        Set<Id> programs = new Set<Id>();
        for(FAU_Participant__c participant : participants){
            programs.add(participant.FAU_Program_Wave__c);
        }
        
        for(FAU_Program__c program : [select FAU_Participant_Chatter_Group_Id__c from FAU_Program__c limit 10000]){
            programChatterGroup.put(program.id,program.FAU_Participant_Chatter_Group_Id__c);
        }
        
        for(FAU_Participant__c participant : participants){
            members.add(participant.FAU_User__c);
            groups.add(programChatterGroup.get(participant.FAU_Program_Wave__c));
        }
        delete [select id from CollaborationGroupMember where MemberId in: members and CollaborationGroupId in: groups];
    }
    
    public static List<FAU_Participant__c> getDeclinedParticipants(List<FAU_Participant__c> participants, Map<Id,sObject> oldMap){
        List<FAU_Participant__c> declined = new List<FAU_Participant__c>();
        for(FAU_Participant__c participant : participants){
            FAU_Participant__c old = (FAU_Participant__c)oldMap.get(participant.id);
            if(participant.FAU_Invite_Status__c == 'Declined' && old.FAU_Invite_Status__c != 'Declined'){
                declined.add(participant);
            }
        }
        return declined;
    }
    /*******************************************************************
       Purpose:     Updated Particpants Modules for Participants which have been updated
    ********************************************************************/ 
    public static void updateParticipantModules(FAU_Module_Participant__c[] lNewModuleParticipants, FAU_Participant__c oNewParticipant){
        for(FAU_Module_Participant__c oNewModuleParticipant: lNewModuleParticipants){
            if (oNewParticipant.Id == oNewModuleParticipant.FAU_Participant__c){
                oNewModuleParticipant.FAU_Participant_s_Invite_Status__c = oNewParticipant.FAU_Invite_State__c;
            }
        } 
    }   

    /*******************************************************************
       Purpose:     Updated Particpants Milestones for Participants which have been updated
    ********************************************************************/ 
    public static void updateParticipantMilestones(FAU_Milestone_Participant__c[] lNewMilestoneParticipants, FAU_Participant__c oNewParticipant){
        for(FAU_Milestone_Participant__c oNewMilestoneParticipant: lNewMilestoneParticipants){
            if (oNewParticipant.Id == oNewMilestoneParticipant.FAU_Participant__c){
                oNewMilestoneParticipant.FAU_Participant_s_Invite_Status__c = oNewParticipant.FAU_Invite_State__c;
            }
        } 
    }   

    /*******************************************************************
       Purpose:     Retrieve Particpants Modules for Participants which have been updated
    ********************************************************************/ 
    public static FAU_Module_Participant__c[] retrieveParticipantModulesToUpdate(FAU_Participant__c[] newParticipant, FAU_Participant__c[] oldParticipant){
        System.Debug('## Cancel FAU_ParticipantClsSC retrieveParticipantModulesToUpdate begin prepare');
        // Member variable to hold the Participants  which have there status Changed
        List<FAU_Participant__c> lUpdateParticipant = new List<FAU_Participant__c>();
 
        for(Integer i = (newParticipant.size()-1); i >=0 ; i--) {
            if (newParticipant[i].FAU_Invite_State__c != oldParticipant[i].FAU_Invite_State__c){
                lUpdateParticipant.add(newParticipant[i]);
            }
        } 
        
        return [select Id, FAU_Participant__c from FAU_Module_Participant__c 
                WHERE FAU_Participant__c = :lUpdateParticipant]; 

    }

    /*******************************************************************
       Purpose:     Retrieve Particpants Milestones for Participants which have been updated
    ********************************************************************/ 
    public static FAU_Milestone_Participant__c[] retrieveParticipantMilestonesToUpdate(FAU_Participant__c[] newParticipant, FAU_Participant__c[] oldParticipant){
        System.Debug('## Cancel FAU_ParticipantClsSC retrieveParticipantMilestonesToUpdate begin prepare');
        // Member variable to hold the Participants  which have there status Changed
        List<FAU_Participant__c> lUpdateParticipant = new List<FAU_Participant__c>();
 
        for(Integer i = (newParticipant.size()-1); i >=0 ; i--) {
            if (newParticipant[i].FAU_Invite_State__c != oldParticipant[i].FAU_Invite_State__c){
                lUpdateParticipant.add(newParticipant[i]);
            }
        } 

        return [select Id, FAU_Participant__c from FAU_Milestone_Participant__c 
                WHERE FAU_Participant__c = :lUpdateParticipant]; 

    }
    

    /*******************************************************************
       Purpose:     Retrieve the User records into a map
    ********************************************************************/
    public static Map<Id, User>  createUserMap(FAU_Participant__c[] lNewParticipant){

        Map<Id, User>  mUser = new Map<Id, User> ();
        Id[] lUserId = new Id[]{}; 
        
        for(FAU_Participant__c oNewParticipant: lNewParticipant){
            lUserId.Add(oNewParticipant.FAU_User__c);
        }
        User[] lUser = [select Id, AboutMe FROM User WHERE Id = :lUserId];

        for(User oUser: lUser){
            mUser.put(oUser.Id, oUser);
        }

        return mUser;
 
    }

    /*******************************************************************
       Purpose:     Retrieve the Participant records into a map
    ********************************************************************/
    public static Map<Id, FAU_Participant__c> createParticipantMap(FAU_Participant__c[] lNewParticipant){

        Map<Id, FAU_Participant__c> mFAU_ParticipantChatter = new Map<Id, FAU_Participant__c>();                

        for(FAU_Participant__c oParticipant: [SELECT Id, FAU_User__c, FAU_Invite_State__c, FAU_Program_Wave__r.FAU_Participant_Chatter_Group_Id__c 
                            FROM FAU_Participant__c 
                            WHERE Id in :trigger.new]){
            mFAU_ParticipantChatter.put(oParticipant.Id, oParticipant);
        }

        return mFAU_ParticipantChatter;

    }

    /*******************************************************************
       Purpose:     Update Participant Biography
    ********************************************************************/
    public static void updateBiographyOnParticipant(FAU_Participant__c oNewParticipant, Map<Id, User>  mUser){
        if (oNewParticipant.FAU_Biography__c == null){
            oNewParticipant.FAU_Biography__c = mUser.get(oNewParticipant.FAU_User__c).AboutMe;
        }
    }

    /*******************************************************************
       Purpose:     Add a Particiapant User to Chatter Group
    ********************************************************************/
    public static CollaborationGroupMember addParticipantChatter(FAU_Participant__c newParticipant, FAU_Participant__c oldParticipantEnhanced){
        
        CollaborationGroupMember member = new CollaborationGroupMember();

        System.debug('#### FAU_ParticipantClsSC.newParticipant.FAU_Invite_State__c: ' + newParticipant.FAU_Invite_State__c);
        System.debug('#### FAU_ParticipantClsSC.oldParticipantEnhanced.FAU_Invite_State__c : ' + oldParticipantEnhanced.FAU_Invite_State__c );
        System.debug('#### FAU_ParticipantClsSC.userAndChatterGroupExistOn(newParticipant) : ' + userAndChatterGroupExistOn(oldParticipantEnhanced) );
        
        if( (newParticipant.FAU_Invite_State__c == 'Accepted')
            && (oldParticipantEnhanced.FAU_Invite_State__c != 'Accepted') 
            && (userAndChatterGroupExistOn(oldParticipantEnhanced)))
        {   
            System.debug('#### FAU_ParticipantClsSC.newParticipant: ' + newParticipant);        
            member.MemberId = newParticipant.FAU_User__c;
            member.CollaborationGroupId = oldParticipantEnhanced.FAU_Program_Wave__r.FAU_Participant_Chatter_Group_Id__c;
                
        }else{
            member = null;
        }   
        System.debug('#### FAU_ParticipantClsSC.member: ' + member);
        return member;

    }

    /*******************************************************************
       Purpose:     Update User About Me with Participant Biography 
    ********************************************************************/
    public static user updateBioOnUser(FAU_Participant__c newParticipant, FAU_Participant__c oldParticipant)
    { 
        User oUser = new User();
        if (((newParticipant.FAU_User__c <> oldParticipant.FAU_User__c)||
            (newParticipant.FAU_Biography__c <> oldParticipant.FAU_Biography__c)) &&
            newParticipant.FAU_User__c <> null){
     
            oUser.Id = newParticipant.FAU_User__c;
            oUser.AboutMe = newParticipant.FAU_Biography__c;
 
        } else{
            oUser = null;
        }
        return oUser;
    }

    /*******************************************************************
       Purpose:     Add Sharing for Participant and Program for User and PA (Insert)
    ********************************************************************/
    public static void addSharing(FAU_Participant__c newParticipant,
                                        FAU_Participant__Share[] lParticipantShares, 
                                        FAU_Program__Share[] lProgramShares){   
            
        if ((newParticipant.FAU_User__c <> null && newParticipant.FAU_Is_Participant_Shared__c)
             && newParticipant.FAU_User__c <> newParticipant.OwnerId){
            lParticipantShares.add(addParticipantSharing(newParticipant, 'User'));
            lProgramShares.add(addProgramSharing(newParticipant, 'User'));
        }
     

        if ((newParticipant.FAU_Personal_Assistant__c <> null && newParticipant.FAU_Is_Participant_Shared__c)
             && newParticipant.FAU_Personal_Assistant__c <> newParticipant.OwnerId){
            lParticipantShares.add(addParticipantSharing(newParticipant, 'PA'));  
            lProgramShares.add(addProgramSharing(newParticipant, 'PA'));
        }
                       
    }

    /*******************************************************************
       Purpose:     Add Sharing for Participant and Program for User and PA (Update)
    ********************************************************************/
    public static void addSharing(FAU_Participant__c newParticipant, 
                                        FAU_Participant__c oldParticipant,
                                        FAU_Participant__Share[] lParticipantShares, 
                                        FAU_Program__Share[] lProgramShares){   

        if (((newParticipant.FAU_User__c <> oldParticipant.FAU_User__c && newParticipant.FAU_User__c <> null)
                || (oldParticipant.FAU_Is_Participant_Shared__c == false && newParticipant.FAU_Is_Participant_Shared__c))
                && newParticipant.FAU_User__c <> newParticipant.OwnerId){
            lParticipantShares.add(addParticipantSharing(newParticipant, 'User'));
            lProgramShares.add(addProgramSharing(newParticipant, 'User'));
        }
     

        if (((newParticipant.FAU_Personal_Assistant__c <> oldParticipant.FAU_Personal_Assistant__c)
            || (oldParticipant.FAU_Is_Participant_Shared__c == false && newParticipant.FAU_Is_Participant_Shared__c))
            && newParticipant.FAU_Personal_Assistant__c <> newParticipant.OwnerId && newParticipant.FAU_Personal_Assistant__c <> null){
                
            lParticipantShares.add(addParticipantSharing(newParticipant, 'PA'));
            lProgramShares.add(addProgramSharing(newParticipant, 'PA'));
        }
                    
    }

    /*******************************************************************
       Purpose:     Retrieve Participant Shares 
    ********************************************************************/
    public static FAU_Participant__Share[] retrieveParticipantShares(FAU_Participant__c[] lParticipants){

        return [Select Id, ParentId, UserOrGroupId FROM FAU_Participant__Share WHERE ParentId = :lParticipants
                                                                AND AccessLevel = 'Edit'];

    }

    /*******************************************************************
       Purpose:     Retrieve Program Shares 
    ********************************************************************/
    public static FAU_Program__Share[] retrieveProgramShares(FAU_Participant__c[] lParticipants){
        
        id[] lProgramIds = new Id[]{};
            
        for(FAU_Participant__c oParticipants: lParticipants){
            lProgramIds.Add(oParticipants.FAU_Program_Wave__c);
        }
        
        return [Select Id, ParentId, UserOrGroupId FROM FAU_Program__Share WHERE ParentId in :lProgramIds
                                                                AND AccessLevel = 'Read'];

    }

    /*******************************************************************
       Purpose:     Remove Sharing for Participant and Program for User and PA 
    ********************************************************************/
    public static void removeSharing(FAU_Participant__c newParticipant, 
                                        FAU_Participant__c oldParticipant,
                                        FAU_Participant__Share[] lParticipantShares, 
                                        FAU_Program__Share[] lProgramShares,
                                        FAU_Participant__Share[] lRemoveParticipantShares, 
                                        FAU_Program__Share[] lRemoveProgramShares){ 

        if (((newParticipant.FAU_User__c <> oldParticipant.FAU_User__c && oldParticipant.FAU_User__c <> null)
            || (newParticipant.FAU_Is_Participant_Shared__c == false && oldParticipant.FAU_Is_Participant_Shared__c))
            && oldParticipant.FAU_User__c <> newParticipant.OwnerId){
            lRemoveParticipantShares.addAll(removeParticipantSharing(oldParticipant, lParticipantShares, 'User')); 
            lRemoveProgramShares.addAll(removeProgramSharing(oldParticipant, lProgramShares, 'User'));   
        }

        if (((newParticipant.FAU_Personal_Assistant__c <> oldParticipant.FAU_Personal_Assistant__c)
            || (newParticipant.FAU_Is_Participant_Shared__c == false && oldParticipant.FAU_Is_Participant_Shared__c))
            && oldParticipant.FAU_Personal_Assistant__c <> newParticipant.OwnerId && oldParticipant.FAU_Personal_Assistant__c <> null){
            lRemoveParticipantShares.addAll(removeParticipantSharing(oldParticipant, lParticipantShares, 'PA'));  
            lRemoveProgramShares.addAll(removeProgramSharing(oldParticipant, lProgramShares, 'PA'));   
        }

    }

    /*******************************************************************
       Purpose:     Retrieve Program Modules for Participants
    ********************************************************************/ 
    public static FAU_Module__c[] retrieveProgramModules(FAU_Participant__c[] lParticipants){
        id[] lProgramIds = new Id[]{};

        for(FAU_Participant__c oParticipant: lParticipants){
            lProgramIds.Add(oParticipant.FAU_Program_Wave__c);
        }
        
        return [Select Id, FAU_Program__c, FAU_Program__r.Id FROM FAU_Module__c WHERE FAU_Program__c = :lProgramIds];

    }

    /*******************************************************************
       Purpose:     Retrieve Program Webinar for Participants
    ********************************************************************/ 
    public static FAU_Webinar__c[] retrieveProgramWebinars(FAU_Participant__c[] lParticipants){
        id[] lProgramIds = new Id[]{};
            
        for(FAU_Participant__c oParticipant: lParticipants){
            lProgramIds.Add(oParticipant.FAU_Program_Wave__c);
        }
        
        return [Select Id, FAU_Program_Wave__c FROM FAU_Webinar__c WHERE FAU_Program_Wave__c = :lProgramIds];
                
    }

    /*******************************************************************
       Purpose:     Retrieve Program Milestones for Participants
    ********************************************************************/ 
    public static FAU_Milestone__c[] retrieveProgramMilestones(FAU_Participant__c[] lParticipants){
        id[] lProgramIds = new Id[]{};
            
        for(FAU_Participant__c oParticipant: lParticipants){
            lProgramIds.Add(oParticipant.FAU_Program_Wave__c);
        }
        
        return [Select Id, FAU_Program_Wave__c FROM FAU_Milestone__c WHERE FAU_Program_Wave__c = :lProgramIds];
                
    }
    /*******************************************************************
       Purpose:     Add  Modules Partipants from Modules
    ********************************************************************/ 
    public static FAU_Module_Participant__c[] addProgramModulesParticipants(FAU_Participant__c oParticipant, FAU_Module__c[] lModules){

        FAU_Module_Participant__c[] lModuleParticipants  =new FAU_Module_Participant__c[]{};

        for(FAU_Module__c oModule: lModules){ 
            if(oParticipant.FAU_Program_Wave__c == oModule.FAU_Program__c){
            
                FAU_Module_Participant__c oModuleParticipant = new FAU_Module_Participant__c(
                  FAU_Module__c = oModule.Id, 
                  FAU_Participant__c = oParticipant.Id
                );
                
                lModuleParticipants.add(oModuleParticipant); 
            }
        }
        
        return lModuleParticipants;

    }

    /*******************************************************************
       Purpose:     Add  Webinar Partipants from Webinar
    ********************************************************************/ 
    public static FAU_Webinar_Participant__c[] addProgramWebinarParticipants(FAU_Participant__c oParticipant, FAU_Webinar__c[] lWebinars){

        FAU_Webinar_Participant__c[] lWebinarParticipants  =new FAU_Webinar_Participant__c[]{};


        for(FAU_Webinar__c oWebinar: lWebinars){ 
            if(oParticipant.FAU_Program_Wave__c == oWebinar.FAU_Program_Wave__c){
            
                FAU_Webinar_Participant__c oWebinarParticipant = new FAU_Webinar_Participant__c(
                  FAU_Webinar__c = oWebinar.Id, 
                  FAU_Participant__c = oParticipant.Id
                );
                
                lWebinarParticipants.add(oWebinarParticipant); 
            }
        }
        
        return lWebinarParticipants;

    }

    /******************************************************************* 
       Purpose:     Add  Milestone Partipants from Milestones
    ********************************************************************/ 
    public static FAU_Milestone_Participant__c[] addProgramMilestoneParticipants(FAU_Participant__c oParticipant, FAU_Milestone__c[] lMilestones){

        FAU_Milestone_Participant__c[] lMilestoneParticipants  =new FAU_Milestone_Participant__c[]{};


        for(FAU_Milestone__c oMilestone: lMilestones){ 
            if(oParticipant.FAU_Program_Wave__c == oMilestone.FAU_Program_Wave__c){
            
                FAU_Milestone_Participant__c oMilestoneParticipant = new FAU_Milestone_Participant__c(
                  FAU_Milestone__c = oMilestone.Id, 
                  FAU_Participant__c = oParticipant.Id
                );
                
                lMilestoneParticipants.add(oMilestoneParticipant); 
            }
        }
        
        return lMilestoneParticipants;

    }

  


    //Private Methods
    //*********************************************
    /*******************************************************************
       Purpose:     Add Participant Sharing (User or PA)
    ********************************************************************/ 
    private static FAU_Participant__Share addParticipantSharing(FAU_Participant__c oParticipant, String sRelatedUser){

        FAU_Participant__Share oParticipantShare = new FAU_Participant__Share();
        
        oParticipantShare.ParentId = oParticipant.Id;
        if(sRelatedUser == 'User'){
            oParticipantShare.UserOrGroupId = oParticipant.FAU_User__c; 
        }else{
            oParticipantShare.UserOrGroupId = oParticipant.FAU_Personal_Assistant__c;
        }
        //oFAUPartShare.UserOrGroupId = oParticipant.FAU_User__c;   
        oParticipantShare.AccessLevel = 'Edit'; 
        
        return oParticipantShare;
    }
    
    /*******************************************************************
       Purpose:     Add Program Sharing (User or PA)
    ********************************************************************/
    private  static FAU_Program__Share addProgramSharing(FAU_Participant__c oParticipant, String sRelatedUser){ 

        FAU_Program__Share oProgramShare = new FAU_Program__Share();
        
        oProgramShare.ParentId = oParticipant.FAU_Program_Wave__c;
        if(sRelatedUser == 'User'){
            oProgramShare.UserOrGroupId = oParticipant.FAU_User__c;
        }else{
            oProgramShare.UserOrGroupId = oParticipant.FAU_Personal_Assistant__c;
        }
        oProgramShare.AccessLevel = 'Read'; 
        
        return oProgramShare;
    }

    /*******************************************************************
       Purpose:     Remove Participant Sharing (User & PA)
    ********************************************************************/
    private  static FAU_Participant__Share[] removeParticipantSharing(FAU_Participant__c oParticipant, 
                                                                        FAU_Participant__Share[] lParticipantShares,
                                                                        String sRelatedUser){ 
        List<FAU_Participant__Share> lRemoveParticipantShares = new List<FAU_Participant__Share>();
    
        for(FAU_Participant__Share oParticipantShares: lParticipantShares){
            if (oParticipantShares.ParentId == oParticipant.Id && 
                ((oParticipantShares.UserOrGroupId == oParticipant.FAU_User__c && sRelatedUser == 'User')||
                (oParticipantShares.UserOrGroupId == oParticipant.FAU_Personal_Assistant__c && sRelatedUser == 'PA'))){
                lRemoveParticipantShares.add(oParticipantShares);   
            
            }
        }

        return lRemoveParticipantShares; 

    }

    /*******************************************************************
       Purpose:     Remove Program Sharing (User & PA)
    ********************************************************************/
    private  static FAU_Program__Share[] removeProgramSharing(FAU_Participant__c oParticipant, 
                                                                        FAU_Program__Share[] lProgramShares,
                                                                        String sRelatedUser){ 
        List<FAU_Program__Share> lRemoveProgramShares = new List<FAU_Program__Share>();

        for(FAU_Program__Share oProgramShare: lProgramShares){
            if (oProgramShare.ParentId == oParticipant.FAU_Program_Wave__c && 
                ((oProgramShare.UserOrGroupId == oParticipant.FAU_User__c && sRelatedUser == 'User')||
                (oProgramShare.UserOrGroupId == oParticipant.FAU_Personal_Assistant__c && sRelatedUser == 'PA'))){
                lRemoveProgramShares.add(oProgramShare);    
            
            }
        }  

        return lRemoveProgramShares;

    }

    /*******************************************************************
       Purpose:     Check to see if the Participant USer is apart of the Program Chatter
    ********************************************************************/
    private static Boolean userAndChatterGroupExistOn(FAU_Participant__c participant)
    {
        System.debug(LoggingLevel.DEBUG, 'add to chatter, Id:' + participant.Id);
        System.debug(LoggingLevel.DEBUG, 'add to chatter, chatterGroupId:' + participant.FAU_Program_Wave__r.FAU_Participant_Chatter_Group_Id__c);
        System.debug(LoggingLevel.DEBUG, 'add to chatter, user:' + participant.FAU_User__c);
        
        //CollaborationGroupMember[] lCGM = [SELECT Id, CollaborationGroupId FROM CollaborationGroupMember WHERE MemberId = :participant.FAU_User__c AND CollaborationGroupId = :participant.FAU_Program_Wave__r.FAU_Participant_Chatter_Group_Id__c];
        
        //System.debug(LoggingLevel.DEBUG, '#### lCGM:' + lCGM.size(); 
 
        return
        (   
            (participant != null) && 
            (participant.FAU_Program_Wave__r != null) && 
            (participant.FAU_Program_Wave__r.FAU_Participant_Chatter_Group_Id__c != null) 
        );
    }

}