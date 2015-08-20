/********************************************************************
 Name:  FAU_ProgramCls()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class handles the Program trigger functionality.                                                      
                                                                       
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      14/09/2014        INITIAL DEVELOPMENT       
   1.1    Rangappa Gunda    23/07/2015       Fix to add missing Information to complete on Milestone when program created from Template     
***********************************************************************/
public with sharing class FAU_ProgramClsSC {

    public static final String TEMPLATE_RECORDTYPE_DEVELOPERNAME = 'Template';

    public static List<CollaborationGroupMember> getChatterGroupMembersForParticipants(List<FAU_Participant__c> participants){
        if(participants.isEmpty()) {
            return new List<CollaborationGroupMember>();
        } else {
            Set<String> members = new Set<String>();
            Set<String> groups = new Set<String>();
            Map<Id,String> programChatterGroup = new Map<Id,String>();
            Set<Id> programs = new Set<Id>();
            for(FAU_Participant__c participant : participants){
                programs.add(participant.FAU_Program_Wave__c);
            }
        
            for(FAU_Program__c program : [select FAU_Participant_Chatter_Group_Id__c from FAU_Program__c LIMIT 5000]){
                programChatterGroup.put(program.id,program.FAU_Participant_Chatter_Group_Id__c);
            }
        
            for(FAU_Participant__c participant : participants){
                members.add(participant.FAU_User__c);
                groups.add(programChatterGroup.get(participant.FAU_Program_Wave__c));
            }
            return [select id from CollaborationGroupMember where MemberId in: members and CollaborationGroupId in: groups];
        }
    }

    /*******************************************************************
       Purpose:     Gets and Completes participants related to programs
    ********************************************************************/     
    public static List<FAU_Participant__c> getAndCompleteProgramsRelatedParticipants(List<FAU_Program__c> programs){
        List<FAU_Participant__c> participants = [select id , FAU_Invite_State__c,FAU_Program_Wave__r.FAU_Participant_Chatter_Group_Id__c from FAU_Participant__c where FAU_Program_Wave__c in: programs];
        for(FAU_Participant__c participant : participants){
            participant.FAU_Invite_State__c = 'Completed';
        }
        return participants;
    }
    
    /*******************************************************************
       Purpose:     Gets and Update participants related to programs
    ********************************************************************/     
    public static List<FAU_Participant__c> getAndUpdateProgramsRelatedParticipants(List<FAU_Program__c> programs){
        List<FAU_Participant__c> participants = [select id , FAU_Invite_State__c from FAU_Participant__c where FAU_Program_Wave__c in: programs];
        for(FAU_Participant__c participant : participants){
            //participant.FAU_Biography_Deadline__c = '';
        }
        return participants;
    }

    /*******************************************************************
       Purpose:     Retrieve Program Modules for Participants
    ********************************************************************/ 
    public static FAU_Module__c[] retrieveProgramModules(FAU_Program__c oProgram){
        
        return [select FAU_Description__c, FAU_End_Date__c, FAU_Module_Number__c, 
                        FAU_Program__c, FAU_Start_Date__c, Id, Name 
                        FROM FAU_Module__c 
                        WHERE FAU_Program__c = :oProgram.Id]; 

    }

    /*******************************************************************
       Purpose:     Retrieve Program Webinars for Participants
    ********************************************************************/ 
    public static FAU_Webinar__c[] retrieveProgramWebinars(FAU_Program__c oProgram){
        
        return [select FAU_Description__c, FAU_End_Time__c, FAU_Program_Wave__c, 
                        FAU_Start_Time__c, FAU_Title__c, FAU_URL__c, Id, Name 
                        FROM FAU_Webinar__c
                        WHERE FAU_Program_Wave__c = :oProgram.Id];

    }

    /*******************************************************************
       Purpose:     Retrieve Program Webinars for Participants
    ********************************************************************/ 
    public static FAU_Milestone__c[] retrieveProgramMilestones(FAU_Program__c oProgram){
        
        return [select CreatedById, CreatedDate, FAU_1st_Reminder__c, FAU_2nd_Reminder__c, FAU_Description__c, 
                        FAU_Due_Date__c, FAU_Milestone_Completition__c, FAU_Program_Wave__c, FAU_Type__c, Id, Name,
                        FAU_Information_to_Complete__c // Fix to add missing Information to complete on Milestone 
                        FROM FAU_Milestone__c
                        WHERE FAU_Program_Wave__c = :oProgram.Id];

    }


    /*******************************************************************
       Purpose:     Create Program 
    ********************************************************************/ 
    public static FAU_Program__c createProgram(FAU_Program__c oProgram, String sProgramName, 
                                                    Recordtype oRecordtype, Integer iNumberOfDays){

        // Member variable to hold the New Program & Child Objects
        FAU_Program__c oProgramInsert = new FAU_Program__c();
        List<FAU_Module__c> lModulesInsert = new List<FAU_Module__c>();
        List<FAU_Webinar__c> lWebinarsInsert = new List<FAU_Webinar__c>();
        List<FAU_Milestone__c> lMilestonesInsert = new List<FAU_Milestone__c>();


        oProgramInsert =  createProgramObject(oProgram, sProgramName, 
                                                    oRecordtype, iNumberOfDays);       
        insert oProgramInsert;
        
        if(oRecordtype.DeveloperName == TEMPLATE_RECORDTYPE_DEVELOPERNAME){
            oProgram.FAU_Program_Template__c = oProgramInsert.Id;
            update oProgram;
        }else{
            oProgramInsert.FAU_Program_Template__c = oProgram.Id;
            update oProgramInsert;
        }

        lModulesInsert = createProgramModules(oProgram, oProgramInsert, iNumberOfDays);
        insert lModulesInsert;

        lWebinarsInsert = createProgramWebinars(oProgram, oProgramInsert, iNumberOfDays);
        insert lWebinarsInsert;

        lMilestonesInsert = createProgramMilestones(oProgram, oProgramInsert, iNumberOfDays);
        insert lMilestonesInsert;

        return oProgramInsert;

    }

    /*******************************************************************
       Purpose:     Create Program Object
    ********************************************************************/ 
    public static FAU_Program__c createProgramObject(FAU_Program__c oProgram, String sProgramName, 
                                                    Recordtype oRecordtype, Integer iNumberOfDays){

        FAU_Program__c oProgramInsert = oProgram.clone(false, true, false, false); 
        oProgramInsert.Name = sProgramName;
        oProgramInsert.RecordTypeId = oRecordtype.Id;
        oProgramInsert.FAU_Status__c = 'Draft';
        oProgramInsert.OwnerId = UserInfo.getUserId();
        if (oProgram.FAU_Invitation_ResponseDeadline__c <> null){
            oProgramInsert.FAU_Invitation_ResponseDeadline__c = oProgram.FAU_Invitation_ResponseDeadline__c.addDays(iNumberOfDays);
        }

        if (oProgram.FAU_Start_Date__c <> null){
            oProgramInsert.FAU_Start_Date__c = oProgram.FAU_Start_Date__c.addDays(iNumberOfDays);
        }

        if (oProgram.FAU_Biography_Deadline__c <> null){
            oProgramInsert.FAU_Biography_Deadline__c = oProgram.FAU_Biography_Deadline__c.addDays(iNumberOfDays);
        }

        return oProgramInsert;
    }
    /*******************************************************************
       Purpose:     Create Program Modules
    ********************************************************************/ 
    public static FAU_Module__c[] createProgramModules(FAU_Program__c oProgram, FAU_Program__c oProgramInsert,
                                                                Integer iNumberOfDays){

        List<FAU_Module__c> lModulesInsert = new List<FAU_Module__c>();
        List<FAU_Module__c> lModules = new List<FAU_Module__c>();

        lModules = retrieveProgramModules(oProgram);

        for(FAU_Module__c oModule: lModules){     
            FAU_Module__c oModuleInsert = oModule.clone(false, true, false, false);               //See sObject Clone Method
            oModuleInsert.FAU_Program__c = oProgramInsert.Id;
            if (oModule.FAU_Start_Date__c <> null){
                oModuleInsert.FAU_Start_Date__c = oModule.FAU_Start_Date__c.addDays(iNumberOfDays);
            }
            if (oModule.FAU_End_Date__c <> null){
                oModuleInsert.FAU_End_Date__c = oModule.FAU_End_Date__c.addDays(iNumberOfDays);
            }
            lModulesInsert.add(oModuleInsert);
        
        }
       return lModulesInsert;

    }

    /*******************************************************************
       Purpose:     Create Program Webinars
    ********************************************************************/ 
    public static FAU_Webinar__c[] createProgramWebinars(FAU_Program__c oProgram, FAU_Program__c oProgramInsert,
                                                                Integer iNumberOfDays){

        List<FAU_Webinar__c> lWebinarsInsert = new List<FAU_Webinar__c>();
        List<FAU_Webinar__c> lWebinars = new List<FAU_Webinar__c>();

        lWebinars = retrieveProgramWebinars(oProgram);

        for(FAU_Webinar__c oWebinar: lWebinars){
            FAU_Webinar__c oWebinarInsert = oWebinar.clone(false, true, false, false);               //See sObject Clone Method
            oWebinarInsert.FAU_Program_Wave__c = oProgramInsert.Id;
            if (oWebinar.FAU_Start_Time__c <> null){
                oWebinarInsert.FAU_Start_Time__c = oWebinar.FAU_Start_Time__c.addDays(iNumberOfDays);
            }
            if (oWebinar.FAU_End_Time__c <> null){
                oWebinarInsert.FAU_End_Time__c = oWebinar.FAU_End_Time__c.addDays(iNumberOfDays);
            }
            lWebinarsInsert.add(oWebinarInsert);
        } 
       return lWebinarsInsert;

    }

    /*******************************************************************
       Purpose:     Create Program Milesones
    ********************************************************************/ 
    public static FAU_Milestone__c[] createProgramMilestones(FAU_Program__c oProgram, FAU_Program__c oProgramInsert,
                                                                Integer iNumberOfDays){
        List<FAU_Milestone__c> lMilestonesInsert = new List<FAU_Milestone__c>();
        List<FAU_Milestone__c> lMilestones = new List<FAU_Milestone__c>();

        lMilestones = retrieveProgramMilestones(oProgram); 

        for(FAU_Milestone__c oMilestone: lMilestones){
            FAU_Milestone__c oMilestoneInsert = oMilestone.clone(false, true, false, false);               //See sObject Clone Method
            oMilestoneInsert.FAU_Program_Wave__c = oProgramInsert.Id;
            if (oMilestone.FAU_Due_Date__c <> null){
                oMilestoneInsert.FAU_Due_Date__c = oMilestone.FAU_Due_Date__c.addDays(iNumberOfDays);
            }
            if (oMilestone.FAU_1st_Reminder__c <> null){
                oMilestoneInsert.FAU_1st_Reminder__c = oMilestone.FAU_1st_Reminder__c.addDays(iNumberOfDays);
            }
            if (oMilestone.FAU_2nd_Reminder__c <> null){
                oMilestoneInsert.FAU_2nd_Reminder__c = oMilestone.FAU_2nd_Reminder__c.addDays(iNumberOfDays);
            }

            lMilestonesInsert.add(oMilestoneInsert);
        
        }
       return lMilestonesInsert;

    }


}