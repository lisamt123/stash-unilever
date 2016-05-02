/**********************************************************************
 Name:  FAU_Webinar_ParticipantHandler()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the FAU_Webinar_Participant SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class FAU_Webinar_ParticipantHandler
	implements ITrigger
{	
	boolean triggerShouldExecute = true;
	
	// Member variable to hold the Id's of Participants which have been updated
	set<Id> setParticipantIds = new Set<Id>{};

	// Member variable to hold the Participants to update webinar date
	FAU_Participant__c[] lParticipants =new FAU_Participant__c[]{};  
	
	// Constructor
	public FAU_Webinar_ParticipantHandler()
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
		if(triggerShouldExecute){
			if(Trigger.isInsert){
				FAU_Webinar_ParticipantCls.insertSendInvitationToWebParts(trigger.new); //$$$$ Accepted by Code Standard

			}
			if(Trigger.isUpdate)
			{
				FAU_Webinar_ParticipantCls.updateSendInvitationToWebParts(trigger.new, trigger.old); //$$$$ Accepted by Code Standard
			}	
		}
 
	}
	
	public void bulkAfter()
	{
	}
		
	public void beforeInsert(SObject so)
	{
		if(triggerShouldExecute){
			//Update the First Webinar Date Time on Participants 
			FAU_Participant__c oFAUParticipant = null;
			oFAUParticipant = FAU_Webinar_ParticipantClsSC.updateWebinarDateTime((FAU_Webinar_Participant__c) so, 
																					setParticipantIds);
			if (oFAUParticipant <> null){
				lParticipants.add(oFAUParticipant);
			}
		}
	}
	
	public void beforeUpdate(SObject oldSo, SObject so)
	{
		if(triggerShouldExecute){
			//Update the First Webinar Date Time on Participants 
			FAU_Participant__c oFAUParticipant = null;
			oFAUParticipant = FAU_Webinar_ParticipantClsSC.updateWebinarDateTime((FAU_Webinar_Participant__c) so, 
																					setParticipantIds);
			if (oFAUParticipant <> null){
				lParticipants.add(oFAUParticipant);
			}
		}
	}
	

	public void beforeDelete(SObject so)
	{	
	}
	
	public void afterInsert(SObject so)
	{
	}
	
	public void afterUpdate(SObject oldSo, SObject so)
	{
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
		FAU_Utilities.saveDatabase('update', lParticipants, false);
	}
}