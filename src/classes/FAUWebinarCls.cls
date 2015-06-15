/********************************************************************
 Name:  FAUWebinarCls()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class handles the Webinar trigger functionality.                          
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Michal Bluj	   13/12/2014        INITIAL DEVELOPMENT          
***********************************************************************/
public with sharing class FAUWebinarCls {
	
	/****************************************************************************
       Purpose:     Retrieve and set status to Invited for Webinar Participants related to invited webinars
    *****************************************************************************/ 
	public static List<FAU_Webinar_Participant__c> updateWebinarParticipantsWhenChangedToInvited(List<FAU_Webinar__c> newWebinars, Map<Id,sObject> oldMap){
		List<FAU_Webinar__c> invitedWebinars = new List<FAU_Webinar__c>();
		for(FAU_Webinar__c webinar : newWebinars){
			if(webinar.recordTypeid == Schema.SObjectType.FAU_Webinar__c.getRecordTypeInfosByName().get('Normal').getRecordTypeId()){
				if(webinar.FAU_Status__c == 'Invited' && ((FAU_Webinar__c)oldMap.get(webinar.id)).FAU_Status__c != 'Invited'){
					invitedWebinars.add(webinar);
				} 
			}
		}
		
		List<FAU_Webinar_Participant__c> relatedParticipants = [select id, FAU_Status__c,FAU_Has_Accepted__c from FAU_Webinar_Participant__c where FAU_Webinar__c in:invitedWebinars and FAU_Participant__r.FAU_Invite_State__c = 'Accepted'];
		for(FAU_Webinar_Participant__c participant : relatedParticipants){
			participant.FAU_Status__c = 'Invited';
			participant.FAU_Has_Accepted__c = true; // that will trigger email notifiction
		}
		return relatedParticipants;
	}
	
	/****************************************************************************
       Purpose:     Create Webinar Participants related to newwly created webinars
    *****************************************************************************/ 
	public static List<FAU_Webinar_Participant__c> createWebinarParticipants(List<FAU_Webinar__c> newWebinars){
		
		List<FAU_Webinar_Participant__c> webinarParticipants = new List<FAU_Webinar_Participant__c>();
		Map<Id,List<FAU_Webinar__c>> programsWebinarMap = new Map<Id,List<FAU_Webinar__c>>();
		
		
		for(FAU_Webinar__c webinar : newWebinars){
			if(programsWebinarMap.keySet().contains(webinar.FAU_Program_Wave__c)){
				programsWebinarMap.get(webinar.FAU_Program_Wave__c).add(webinar);
			} else {
				programsWebinarMap.put(webinar.FAU_Program_Wave__c,new List<FAU_Webinar__c>{webinar});
			}
		}
		
		List<FAU_Program__c> programs = [select id, (select id,FAU_Program_Wave__c from FAU_Participants__r) from FAU_Program__c where id in : programsWebinarMap.keySet()];
		
		for(FAU_Program__c program : programs){
			List<FAU_Webinar__c> webinars = programsWebinarMap.get(program.id);
			for(FAU_Participant__c participant : program.FAU_Participants__r){
				for(FAU_Webinar__c webinar : webinars){
					if(webinar.FAU_Program_Wave__c == participant.FAU_Program_Wave__c){
						webinarParticipants.add(new FAU_Webinar_Participant__c(FAU_Webinar__c = webinar.id, FAU_Participant__c = participant.id));
					}
				}
			}
		}
		
		return webinarPArticipants;
	}
	
}