/********************************************************************
 Name:  FAU_ProgramHandler()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the FAU_Program SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class FAU_ProgramHandler
    implements ITrigger
{   
    boolean triggerShouldExecute = true;
/*
    public static final String SOBJECT_NAME = 'FAU_Program__c';
    public static final String TEMPLATE_RECORDTYPE_DEVELOPERNAME = 'Template';
    public static final String CORE_RECORDTYPE_DEVELOPERNAME = 'Core';
    public static final String FRANCHISE_RECORDTYPE_DEVELOPERNAME = 'Franchise';
*/
    // Member variable to hold the Chatter Groups to be created for the programs
    List<CollaborationGroup> chatterGroups = new List<CollaborationGroup>();
/*
    // Member variable to hold the Existing Child Objects
    List<FAU_Module__c> lModules = new List<FAU_Module__c>();
    List<FAU_Webinar__c> lWebinars = new List<FAU_Webinar__c>();
    List<FAU_Milestone__c> lMilestones = new List<FAU_Milestone__c>();

    // Member variable to hold the New Program & Child Objects
    List<FAU_Program__c> lProgramInsert = new List<FAU_Program__c>();
    List<FAU_Module__c> lModulesInsert = new List<FAU_Module__c>();
    List<FAU_Webinar__c> lWebinarsInsert = new List<FAU_Webinar__c>();
    List<FAU_Milestone__c> lMilestonesInsert = new List<FAU_Milestone__c>();
    
    
    Map<String, Id> mRecordTypes = new Map<String, Id> ();
*/

	List<FAU_Participant__c> relatedCompletedParticipants = new List<FAU_Participant__c>();
    List<FAU_Participant__c> relatedUpdateParticipants = new List<FAU_Participant__c>();
    
    // Class to implement Chatter Services
    FAU_ChatterService service = new FAU_ChatterServiceImpl();

    // Constructor
    public FAU_ProgramHandler()
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
        /*System.debug('Entering FAU_ProgramHandler.bulkBefore'); 
        if(triggerShouldExecute){
            if(Trigger.isUpdate) {
                lModules = FAU_ProgramClsSC.retrieveProgramModules(trigger.new);
                lWebinars = FAU_ProgramClsSC.retrieveProgramWebinars(trigger.new);
                lMilestones = FAU_ProgramClsSC.retrieveProgramMilestones(trigger.new);

                mRecordTypes = FAU_ProgramClsSC.retrieveProgramRecordtypes(SOBJECT_NAME);
            }
        }*/
    }
    
    public void bulkAfter()
    {
    	if(triggerShouldExecute){
            if(Trigger.isUpdate) {
            	List<FAU_Program__c> completedPrograms = new List<FAU_Program__c>();
            	for(sObject p : Trigger.new){
            		FAU_Program__c program = (FAU_Program__c)p;
            		if(program.FAU_Status__c == 'Completed' && ((FAU_Program__c)Trigger.oldMap.get(program.id)).FAU_Status__c != 'Completed'){
            			completedPrograms.add(program);
            		}
            	}
            	relatedCompletedParticipants = FAU_ProgramClsSC.getAndCompleteProgramsRelatedParticipants(completedPrograms);

                List<FAU_Program__c> updatedParticipantPrograms = new List<FAU_Program__c>();
                for(sObject p : Trigger.new){
                    FAU_Program__c program = (FAU_Program__c)p;
                    if(program.FAU_Status__c !='Completed' && 
                        (program.FAU_Biography_Deadline__c !=((FAU_Program__c)Trigger.oldMap.get(program.id)).FAU_Biography_Deadline__c)){
                        updatedParticipantPrograms.add(program);
                    }
                }
                relatedUpdateParticipants = FAU_ProgramClsSC.getAndUpdateProgramsRelatedParticipants(updatedParticipantPrograms);


            }
    	}
    }
        
    public void beforeInsert(SObject so)
    {
        if(triggerShouldExecute){
            System.debug('Entering FAU_ProgramHandler.chatterGroups' + chatterGroups.size());
            
            chatterGroups.add(service.createChatterGroup((FAU_Program__c)so, (Id)so.get('OwnerId')));
            
            System.debug('Exiting FAU_ProgramHandler.chatterGroups' + chatterGroups);
        }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
    	/*System.debug('Entering FAU_ProgramHandler.beforeUpdate'); 
        FAU_Program__c oProgramInsert = null;
        if (so.get('FAU_Make_Template__c') == true){
	        if (so.get('FAU_Status__c') =='Draft'){
	            oProgramInsert = FAU_ProgramClsSC.createProgramObjects(true, mRecordTypes,
	                                    			(FAU_Program__c) so, 
	                                                lModules,  lModulesInsert,
	                                                lWebinars, lWebinarsInsert,
	                                                lMilestones, lMilestonesInsert);

	    	}else if(so.get('FAU_Status__c') <> 'Draft'){
	    		oProgramInsert = FAU_ProgramClsSC.createProgramObjects(false,  mRecordTypes,
	                                    			(FAU_Program__c) so, 
	                                                lModules,  lModulesInsert,
	                                                lWebinars, lWebinarsInsert,
	                                                lMilestones, lMilestonesInsert);
	    	}

	    	System.debug('Entering FAU_ProgramHandler.oProgramInsert:' + oProgramInsert);
		    if (oProgramInsert <> null){
		        lProgramInsert.add(oProgramInsert);
		    }
	    }*/
    }
     

    public void beforeDelete(SObject so)
    {   
    }
    
    public void afterInsert(SObject so) 
    {
        if(triggerShouldExecute){
            //1.2 lModules.addAll(FAU_ProgramClsSC.addProgramModule((FAU_Program__c)so)); 
        }
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
        System.debug('Entering FAU_ProgramHandler.andFinally');
        if(triggerShouldExecute){
            
            System.debug('#### FAU_ProgramHandler.andFinally chatterGroups' + chatterGroups.size());
            if(!Trigger.isDelete){
            	service.commitChatterGroups(chatterGroups, trigger.new);
            }
            
            if(Trigger.isUpdate){
            	update relatedCompletedParticipants;
                update relatedUpdateParticipants;
            	delete FAU_ProgramClsSC.getChatterGroupMembersForParticipants(relatedCompletedParticipants);
            }
            /*
            System.debug('Entering FAU_ProgramHandler.lProgramInsert:' + lProgramInsert);
            insert lProgramInsert;

            if (lProgramInsert.size()>0){
            	trigger.new[0].FAU_Program_Template__c = lProgramInsert[0].Id;
            }

            for(FAU_Module__c oModulesInsert:lModulesInsert){
            	oModulesInsert.FAU_Program__c = lProgramInsert[0].Id;
            }
            for(FAU_Webinar__c oWebinarsInsert:lWebinarsInsert){
            	oWebinarsInsert.FAU_Program_Wave__c = lProgramInsert[0].Id;
            }
            for(FAU_Milestone__c oMilestonesInsert:lMilestonesInsert){
            	oMilestonesInsert.FAU_Program_Wave__c = lProgramInsert[0].Id;
            }

            System.debug('Entering FAU_ProgramHandler.lModulesInsert:' + lModulesInsert);
            insert lModulesInsert;
            System.debug('Entering FAU_ProgramHandler.lWebinarsInsert:' + lWebinarsInsert); 
            insert lWebinarsInsert;
            System.debug('Entering FAU_ProgramHandler.lMilestonesInsert:' + lMilestonesInsert);
            insert lMilestonesInsert;
            */

        }
        System.debug('Exiting FAU_ProgramHandler.andFinally');
    }
}