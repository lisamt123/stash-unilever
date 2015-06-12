/********************************************************************
 Name:  FAUMilestoneCls()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class handles the Milestone trigger functionality.                          
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      8/12/2014        INITIAL DEVELOPMENT          
***********************************************************************/
public with sharing class FAUMilestoneCls {

	/*******************************************************************************
       Purpose:     Create Webinar Participants related to newwly created milestones
    ********************************************************************************/ 
	public static List<FAU_Milestone_Participant__c> createMilestoneParticipants(List<FAU_Milestone__c> newMilestones){
		
		List<FAU_Milestone_Participant__c> MilestoneParticipants = new List<FAU_Milestone_Participant__c>();
		Map<Id,List<FAU_Milestone__c>> programsMilestoneMap = new Map<Id,List<FAU_Milestone__c>>();
		
		for(FAU_Milestone__c Milestone : newMilestones){
			if(programsMilestoneMap.keySet().contains(Milestone.FAU_Program_Wave__c)){
				programsMilestoneMap.get(Milestone.FAU_Program_Wave__c).add(Milestone);
			} else { 
				programsMilestoneMap.put(Milestone.FAU_Program_Wave__c,new List<FAU_Milestone__c>{Milestone});
			}
		}
		
		List<FAU_Program__c> programs = [select id, (select id,FAU_Program_Wave__c from FAU_Participants__r) from FAU_Program__c where id in : programsMilestoneMap.keySet()];
		
		for(FAU_Program__c program : programs){
			List<FAU_Milestone__c> Milestones = programsMilestoneMap.get(program.id);
			for(FAU_Participant__c participant : program.FAU_Participants__r){
				for(FAU_Milestone__c Milestone : Milestones){
					if(Milestone.FAU_Program_Wave__c == participant.FAU_Program_Wave__c){
						MilestoneParticipants.add(new FAU_Milestone_Participant__c(FAU_Milestone__c = Milestone.id, FAU_Participant__c = participant.id));
					}
				}
			}
		}
		
		return MilestonePArticipants;
	}

    /*******************************************************************
       Purpose:     Retrieve Particpants Milestones for Milestones which have been updated
    ********************************************************************/ 
    public static FAU_Milestone_Participant__c[] retrieveParticipantMilestonesToUpdate(FAU_Milestone__c[] lNewMilestones){
        System.Debug('## Cancel FAUMilestoneCls retrieveParticipantMilestonesToUpdate begin prepare');

        return [select Id, FAU_Milestone__c, FAU_1st_Reminder__c, FAU_2nd_Reminder__c, FAU_Due_Date__c from FAU_Milestone_Participant__c 
                WHERE FAU_Milestone__c = :lNewMilestones]; 

    }

    /*******************************************************************
       Purpose:     Updated Particpants Milestones for Participants which have been updated
    ********************************************************************/ 
    public static void updateParticipantMilestones(FAU_Milestone__c oNewMilestone, FAU_Milestone_Participant__c[] lNewModlueParticipants){
        System.Debug('## Cancel FAUMilestoneCls updateParticipantMilestones begin prepare');
        for(FAU_Milestone_Participant__c oNewMilestoneParticipant: lNewModlueParticipants){
            if (oNewMilestone.Id == oNewMilestoneParticipant.FAU_Milestone__c){
                oNewMilestoneParticipant.FAU_Workflow_1st_Reminder__c = oNewMilestone.FAU_1st_Reminder__c;
                oNewMilestoneParticipant.FAU_Workflow_2nd_Reminder__c = oNewMilestone.FAU_2nd_Reminder__c;
                oNewMilestoneParticipant.FAU_Workflow_Due_Date__c = oNewMilestone.FAU_Due_Date__c;

            }
        } 
    }   
}