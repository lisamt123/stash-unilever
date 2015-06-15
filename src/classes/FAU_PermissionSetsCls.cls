/********************************************************************
 Name:  FAU_PermissionSetsCls()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class handles the Permission Set Assignment functionality.                          
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   0.1   Jack Dermody	   22/10/2014        INITIAL DEVELOPMENT          
***********************************************************************/
public without sharing class FAU_PermissionSetsCls {
	// Static Variables
	public static final String PARTICIPANT_PLATFORM = 'Salesforce Platform';
	public static final String PARTICIPANT_SALESFORCE = 'Salesforce';
	public static final String PERMISSION_SET_PARTICIPANT_PLATFORM = 'FAU_Participant_Platform';
	public static final String PERMISSION_SET_PARTICIPANT_SALESFORCE = 'FAU_Participant_Salesforce';
	
		
    /*******************************************************************
       Purpose:     Create Permission Set Assignment
    ********************************************************************/
    @future
    public static void createPermissionSetAssign(Id[] lnewParticipants){

    	List<PermissionSetAssignment>  lAddPermissionSetAssignment = new List<PermissionSetAssignment> ();

    	PermissionSet [] lPermissionSet = [SELECT Id, Name  
												FROM PermissionSet
												WHERE (Name = :PERMISSION_SET_PARTICIPANT_SALESFORCE 
												OR Name = :PERMISSION_SET_PARTICIPANT_PLATFORM)
												LIMIT 2];
		FAU_Participant__c[] lParticipantPermissionSet = [Select Id, FAU_User__r.User_License__c, FAU_Personal_Assistant__r.User_License__c
															FROM FAU_Participant__c
															WHERE id = :lnewParticipants];

/*
		FAU_Participant__c[] lParticipantPermissionSet = [Select Id, FAU_User_License__c 
															FROM FAU_Participant__c
															WHERE id = :lnewParticipants  
																AND (FAU_User__c NOT IN (SELECT AssigneeId 
																				FROM PermissionSetAssignment
																				WHERE PermissionSet.Name = :PERMISSION_SET_PARTICIPANT_SALESFORCE 
																				OR PermissionSet.Name = :PERMISSION_SET_PARTICIPANT_PLATFORM))
																AND (FAU_Personal_Assistant__c NOT IN (SELECT AssigneeId 
																				FROM PermissionSetAssignment
																				WHERE PermissionSet.Name = :PERMISSION_SET_PARTICIPANT_SALESFORCE 
																				OR PermissionSet.Name = :PERMISSION_SET_PARTICIPANT_PLATFORM))];
*/

		for (FAU_Participant__c oParticipantPermissionSet : lParticipantPermissionSet){
			lAddPermissionSetAssignment.addAll(createPermissionSetAssign(oParticipantPermissionSet, lPermissionSet));
		}

		FAU_Utilities.saveDatabase('insert', lAddPermissionSetAssignment, false);
		
	
 
    }

    /*******************************************************************
       Purpose:     Retrieve Participant List for removing Permission Set
    ********************************************************************/
    @future
    public static void retrieveRemovePermissionSetAssign(){
    	List<Id> lParticipantPersonalAssitId = new List<Id>();
    	
    		
    	for(FAU_Participant__c p :[SELECT FAU_User__c, FAU_Personal_Assistant__c
										FROM FAU_Participant__c
										WHERE FAU_Invite_State__c <> 'Declined']){
    		lParticipantPersonalAssitId.add(p.FAU_User__c);
    		lParticipantPersonalAssitId.add(p.FAU_Personal_Assistant__c);
    	}
		
		PermissionSetAssignment[] lPermissionSetAssignment = [Select Id 
																FROM  PermissionSetAssignment 
																WHERE (PermissionSet.Name = :PERMISSION_SET_PARTICIPANT_SALESFORCE 
																			OR PermissionSet.Name = :PERMISSION_SET_PARTICIPANT_PLATFORM)
																			AND AssigneeId NOT IN :lParticipantPersonalAssitId
																];
		//System.debug('PermissionSetAssignment: Exiting lPermissionSetAssignment.size(): ' + lPermissionSetAssignment.size());
		delete lPermissionSetAssignment;

    }

    /*******************************************************************
       Purpose:     Create Permission Set for Participant and Program for User and PA (Insert)
    ********************************************************************/
    
    private static PermissionSetAssignment[] createPermissionSetAssign(FAU_Participant__c newParticipant, 
    										PermissionSet[] lPermissionSet){
    	PermissionSetAssignment oUserPermissionSetAssignment = new PermissionSetAssignment();
    	PermissionSetAssignment oPAPermissionSetAssignment = new PermissionSetAssignment();
    	List<PermissionSetAssignment>  lAddPermissionSetAssignment = new List<PermissionSetAssignment> ();
    	Id idPermissionSetPlatform = null;
    	Id idPermissionSetSalesforce = null;

    	for(PermissionSet oPermissionSet: lPermissionSet){
    		if(oPermissionSet.Name == PERMISSION_SET_PARTICIPANT_PLATFORM){
    			idPermissionSetPlatform = oPermissionSet.Id;
    		}
    		if(oPermissionSet.Name == PERMISSION_SET_PARTICIPANT_SALESFORCE){
    			idPermissionSetSalesforce = oPermissionSet.Id;
    		}
    	}
  
  		//User Permission Set
  		System.debug('##### FAU_PermissionSetsCls.PermissionSetAssignment newParticipant.FAU_User__r.User_License__c:' + newParticipant.FAU_User__r.User_License__c);
        if (newParticipant.FAU_User__r.User_License__c == PARTICIPANT_PLATFORM){
	        oUserPermissionSetAssignment.PermissionSetId = idPermissionSetPlatform;     
	    }else if(newParticipant.FAU_User__r.User_License__c == PARTICIPANT_SALESFORCE){
	    	oUserPermissionSetAssignment.PermissionSetId = idPermissionSetSalesforce;
	    }else{
	    	newParticipant.addError('The particiapnt has to have either a Salesforce or Salesforce Platform licence.');
	    }

	    oUserPermissionSetAssignment.AssigneeId = newParticipant.FAU_User__c ;

	    lAddPermissionSetAssignment.add(oUserPermissionSetAssignment);

	    //Personal Assitent Permission Set
	    if (newParticipant.FAU_Personal_Assistant__r <> null){
	        if (newParticipant.FAU_Personal_Assistant__r.User_License__c == PARTICIPANT_PLATFORM){
		        oPAPermissionSetAssignment.PermissionSetId = idPermissionSetPlatform;     
		    }else if(newParticipant.FAU_Personal_Assistant__r.User_License__c == PARTICIPANT_SALESFORCE){
		    	oPAPermissionSetAssignment.PermissionSetId = idPermissionSetSalesforce;
		    }else{
		    	newParticipant.addError('The personal assitent has to have either a Salesforce or Salesforce Platform licence.');
		    }

		    oPAPermissionSetAssignment.AssigneeId = newParticipant.FAU_User__c ;

		    lAddPermissionSetAssignment.add(oPAPermissionSetAssignment);
	    }

        return lAddPermissionSetAssignment;

    }


}