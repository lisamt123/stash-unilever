/**********************************************************************
 Name:  FAU_ParticipantHandler()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the FAU_Participant SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class FAU_ParticipantHandler
    implements ITrigger
{   
    boolean triggerShouldExecute = true;
    public static final String PERMISSION_SET_PARTICIPANT_PLATFORM = 'FAU_Participant_Platform';
    public static final String PERMISSION_SET_PARTICIPANT_SALESFORCE = 'FAU_Participant_Salesforce';
    public static string dmlInsert='insert';//Modified by yugandhar
    //Particpant Permission Set
    List<Id> lIdParticipant = new List<Id>();
    
    // Member variable to hold the list of users for Update (About Me)
    List<User> lUpdateUserBio = new List<User>();
    
    // Member variable to hold the Participant Shares to be created 
    List<FAU_Participant__Share> lAddParticipantShares = new List<FAU_Participant__Share>();

    // Member variable to hold the Program Shares to be created 
    List<FAU_Program__Share> lAddProgramShares = new List<FAU_Program__Share>();

    // Member variable to hold the existing Participant Shares to be retrieve 
    List<FAU_Participant__Share> lAllParticipantShares = new List<FAU_Participant__Share>();
    // Member variable to hold the existing Program Shares to be retrieve 
    List<FAU_Program__Share> lAllProgramShares = new List<FAU_Program__Share>();

    // Member variable to hold the Participant Shares to be removed 
    List<FAU_Participant__Share> lRemoveParticipantShares = new List<FAU_Participant__Share>();
    // Member variable to hold the Program Shares to be removed 
    List<FAU_Program__Share> lRemoveProgramShares = new List<FAU_Program__Share>();

    // Member variable to hold the Program Modules to be retrieved
    List<FAU_Module__c> lProgramModules = new List<FAU_Module__c>();
    // Member variable to hold the Program Webinars to be retrieved
    List<FAU_Webinar__c> lProgramWebinars = new List<FAU_Webinar__c>();
    // Member variable to hold the Program Webinars to be retrieved
    List<FAU_Milestone__c> lProgramMilestones = new List<FAU_Milestone__c>();
    
    // Member variable to hold the Program Module Participants to be created
    List<FAU_Module_Participant__c> lAddModuleParticipants = new List<FAU_Module_Participant__c>();
    // Member variable to hold the Program Webinars Participants to be created 
    List<FAU_Webinar_Participant__c> lAddWebinarParticipants = new List<FAU_Webinar_Participant__c>();
    // Member variable to hold the Program Milestones Participants to be created 
    List<FAU_Milestone_Participant__c> lAddMilestoneParticipants = new List<FAU_Milestone_Participant__c>();

    // Member variable to hold the Program Module Participants to be updated
    List<FAU_Module_Participant__c> lUpdateModuleParticipants = new List<FAU_Module_Participant__c>();
    // Member variable to hold the Program Webinars Participants to be updated 
    List<FAU_Milestone_Participant__c> lUpdateMilestoneParticipants = new List<FAU_Milestone_Participant__c>();


    // Member variable to hold the list of users for Update of Biography 
    Map<Id, User>  mUser = new Map<Id, User> ();

    // Member variable to hold the Chatter Groups Members to be created for the programs
    List<CollaborationGroupMember> lCollaborationGroupMembers = new List<CollaborationGroupMember>();

    // Member variable to hold the Chatter Groups Members which exists
    Map<Id, FAU_Participant__c>  mFAU_ParticipantChatter = new Map<Id, FAU_Participant__c> ();

    // Class to implement Chatter Services
    FAU_ChatterService service = new FAU_ChatterServiceImpl();

    //Particpant Permission Set
    List<PermissionSet> lParticipantPermissionSet = new List<PermissionSet>();

    // Member to Add to Permission Set
    List<PermissionSetAssignment>  lAddPermissionSetAssignment = new List<PermissionSetAssignment> ();

    // Member to Remove to Permission Set
    List<PermissionSetAssignment>  lRemovePermissionSetAssignment = new List<PermissionSetAssignment> ();
    
    List<FAU_Participant__c> declinedParticipants = new List<FAU_Participant__c>();
    
    List<FAU_Participant__c> deletedParticipants = new List<FAU_Participant__c>();

    // Constructor
    public FAU_ParticipantHandler()
    {
    }

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {   
        System.debug('Entering FAU_ParticipantHandler.bulkAfter');  
        if(triggerShouldExecute){
            if(Trigger.isInsert || Trigger.isUpdate) {


                if(Trigger.isInsert){
                    // Fill the Map with Particiapnts and PA info
                    mUser = FAU_ParticipantClsSC.createUserMap(trigger.new);
                }

                if(Trigger.isUpdate) 
                {
                    // Fill the Map with Participants Chatter Group memeberships for the program chatter group
                    mFAU_ParticipantChatter = FAU_ParticipantClsSC.createParticipantMap(trigger.new); 

                    lUpdateModuleParticipants = FAU_ParticipantClsSC.retrieveParticipantModulesToUpdate(trigger.old, trigger.new);
                    lUpdateMilestoneParticipants = FAU_ParticipantClsSC.retrieveParticipantMilestonesToUpdate(trigger.old, trigger.new);
                    
                } 
                

            } else if(Trigger.isDelete){
                deletedParticipants = Trigger.old;
            }

            
        }
        System.debug('Exiting FAU_ParticipantHandler.bulkAfter');   
 
    }
    
    public void bulkAfter()
    {
        System.debug('Entering FAU_ParticipantHandler.bulkAfter');  


        if(triggerShouldExecute){ 
            if(Trigger.isInsert || Trigger.isUpdate) {

                 
                for(Integer i = (Trigger.new.size()-1); i >=0 ; i--) {
                    lIdParticipant.add(Trigger.new[i].Id);
                }
                // @Future Create Permission Set Assignments
                FAU_PermissionSetsCls.createPermissionSetAssign(lIdParticipant);

                if (Trigger.isInsert){
                    // Retrieve Program Modules
                    lProgramModules = FAU_ParticipantClsSC.retrieveProgramModules(trigger.new);
                    // Retrieve Program Webinars 
                    lProgramWebinars = FAU_ParticipantClsSC.retrieveProgramWebinars(trigger.new);
                    // Retrieve Program Webinars 
                    lProgramMilestones = FAU_ParticipantClsSC.retrieveProgramMilestones(trigger.new);
                }   
                
                
                if (Trigger.isUpdate){
                    // Retrieve the share records for the Participants 
                    lAllParticipantShares = FAU_ParticipantClsSC.retrieveParticipantShares(trigger.new);
                    // Retrieve the share records for the Programs
                    lAllProgramShares = FAU_ParticipantClsSC.retrieveProgramShares(trigger.new);
                    
                    declinedParticipants = FAU_ParticipantClsSC.getDeclinedParticipants(trigger.new, trigger.oldMap);

                    // Retrieve Module & Milestone Particpant V1.2 


                }
            }

            // @future Remove Permission Set Assignments 
            FAU_PermissionSetsCls.retrieveRemovePermissionSetAssign();

        }
        System.debug('Exiting FAU_ParticipantHandler.bulkAfter');   
    }
        
    public void beforeInsert(SObject so)
    {
        System.debug('Entering FAU_ParticipantHandler.beforeInsert');
        if(triggerShouldExecute){
            
            //Set FAU_Is_deferred_To_PA__c
            FAU_ParticipantClsSC.setIsdeferredToPA((FAU_Participant__c) so); 
            
            // Update Participant Record 'Biography' with 'About Me' from the User 
            FAU_ParticipantClsSC.updateBiographyOnParticipant((FAU_Participant__c)so, mUser);
    

        }
        System.debug('Exiting FAU_ParticipantHandler.beforeInsert');
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering FAU_ParticipantHandler.beforeUpdate');
        if(triggerShouldExecute){ 

            //Set FAU_Is_deferred_To_PA__c
            FAU_ParticipantClsSC.setIsdeferredToPA((FAU_Participant__c) so);
            
            // Add the Participant to the Program Chatter Group
            CollaborationGroupMember oCollaborationGroupMember = null;
             
            oCollaborationGroupMember = FAU_ParticipantClsSC.addParticipantChatter((FAU_Participant__c) so, mFAU_ParticipantChatter.get((Id)so.get('Id')));
            if (oCollaborationGroupMember <> null){
                System.debug('#### FAU_ParticipantHandler.oCollaborationGroupMember: ' + oCollaborationGroupMember);
                lCollaborationGroupMembers.add(oCollaborationGroupMember);
            }

            //Update the biography field from the User About Me field 
            User oUser = null;  
            oUser = FAU_ParticipantClsSC.updateBioOnUser((FAU_Participant__c) so, (FAU_Participant__c) oldso);
            if (oUser <> null){
                lUpdateUserBio.add(oUser);
            }

            //Update Milestones & Module Participants for the time triggers
            FAU_ParticipantClsSC.updateParticipantModules(lUpdateModuleParticipants, (FAU_Participant__c) so);
            FAU_ParticipantClsSC.updateParticipantMilestones(lUpdateMilestoneParticipants, (FAU_Participant__c) so);

            for(FAU_Milestone_Participant__c oNewMilestoneParticipant: lUpdateMilestoneParticipants){
                System.debug('#### FAU_ParticipantHandler.oNewMilestoneParticipant.FAU_Participant_s_Invite_Status__c: ' + oNewMilestoneParticipant.FAU_Participant_s_Invite_Status__c);
            }
        }
        System.debug('Exiting FAU_ParticipantHandler.beforeUpdate');
    }
    

    public void beforeDelete(SObject so)
    {   
    }
    
    public void afterInsert(SObject so) 
    {
        System.debug('Entering FAU_ParticipantHandler.afterInsert');
        if(triggerShouldExecute){
            
            //Add Participant User Sharing to the Participant Record(Edit) and Program Record(Read)
            FAU_ParticipantClsSC.addSharing((FAU_Participant__c) so, lAddParticipantShares, lAddProgramShares);

            //Create Module Participant Records from the Program Modules 
            System.debug('lProgramModules' + lProgramModules);
            lAddModuleParticipants.addAll(FAU_ParticipantClsSC.addProgramModulesParticipants((FAU_Participant__c) so, lProgramModules));

            //Create Webinar Participant Records from the Program Webinars 
            lAddWebinarParticipants.addAll(FAU_ParticipantClsSC.addProgramWebinarParticipants((FAU_Participant__c) so, lProgramWebinars));
            
            //Create Milestone Participant Records from the Program Webinars 
            lAddMilestoneParticipants.addAll(FAU_ParticipantClsSC.addProgramMilestoneParticipants((FAU_Participant__c) so, lProgramMilestones));
        
        }
        System.debug('Exiting FAU_ParticipantHandler.afterInsert');
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering FAU_ParticipantHandler.afterUpdate');
        if(triggerShouldExecute){
            //Add Participant User Sharing to the Participant Record(Edit) and Program Record(Read)
            FAU_ParticipantClsSC.addSharing((FAU_Participant__c) so, (FAU_Participant__c) oldSo, lAddParticipantShares, lAddProgramShares);
            
            //Remove Participant User Sharing to the Participant Record(Edit) and Program Record(Read)
            FAU_ParticipantClsSC.removeSharing((FAU_Participant__c) so, (FAU_Participant__c) oldSo,
                                    lAllParticipantShares, lAllProgramShares,
                                    lRemoveParticipantShares, lRemoveProgramShares);

            //Automatically Submit for Approvals() 
            FAU_ParticipantClsSC.submitforApprovals((FAU_Participant__c) so, (FAU_Participant__c) oldSo);
        }
        System.debug('Exiting FAU_ParticipantHandler.afterUpdate');
    }
    
    public void afterDelete(SObject so)
    {
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {
        System.debug('Entering FAU_ParticipantHandler.andFinally');
        if(triggerShouldExecute){
            

            FAU_Utilities.saveDatabase(dmlInsert, lAddParticipantShares, false);
            FAU_Utilities.saveDatabase(dmlInsert, lAddProgramShares, false);
            FAU_Utilities.saveDatabase(dmlInsert, lAddModuleParticipants, false);
            FAU_Utilities.saveDatabase(dmlInsert, lAddWebinarParticipants, false);
            FAU_Utilities.saveDatabase(dmlInsert, lAddMilestoneParticipants, false);
            
            System.debug('#### FAU_ParticipantHandler.andFinally lCollaborationGroupMembers: ' + lCollaborationGroupMembers);
            service.commitChatterMember(lCollaborationGroupMembers); 
     
            FAU_Utilities.saveDatabase('update', lUpdateUserBio, false);
            FAU_Utilities.saveDatabase('update', lUpdateModuleParticipants, false);
            FAU_Utilities.saveDatabase('update', lUpdateMilestoneParticipants, false);

            FAU_Utilities.deleteDatabase (lRemoveParticipantShares, false);
            FAU_Utilities.deleteDatabase (lRemoveProgramShares, false);
            FAU_ParticipantClsSC.removeParticipantsFromChatterGroup(declinedParticipants);
            FAU_ParticipantClsSC.removeParticipantsFromChatterGroup(deletedParticipants);
            //FAU_Utilities.deleteDatabase (lRemovePermissionSetAssignment, false);
        }
        System.debug('Exiting FAU_ParticipantHandler.andFinally');
    }

}