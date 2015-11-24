/********************************************************************
 Name:  FAUModuleCls()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class handles the Module trigger functionality.                          
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody	   8/12/2014        INITIAL DEVELOPMENT          
***********************************************************************/
public with sharing class FAUModuleCls {

	/****************************************************************************
       Purpose:     Create Webinar Participants related to newwly created modules
    *****************************************************************************/ 
	public static List<FAU_Module_Participant__c> createWebinarParticipants(List<FAU_Module__c> newModules){
		
		List<FAU_Module_Participant__c> moduleParticipants = new List<FAU_Module_Participant__c>();
		Map<Id,List<FAU_Module__c>> programsModuleMap = new Map<Id,List<FAU_Module__c>>();
		
		for(FAU_Module__c module : newModules){
			if(programsModuleMap.keySet().contains(module.FAU_Program__c)){
				programsModuleMap.get(module.FAU_Program__c).add(module);
			} else {
				programsModuleMap.put(module.FAU_Program__c,new List<FAU_Module__c>{module});
			}
		}
		
		List<FAU_Program__c> programs = [select id, (select id,FAU_Program_Wave__c from FAU_Participants__r) from FAU_Program__c where id in : programsModuleMap.keySet()];
		
		for(FAU_Program__c program : programs){
			List<FAU_Module__c> modules = programsModuleMap.get(program.id);
			for(FAU_Participant__c participant : program.FAU_Participants__r){
				for(FAU_Module__c module : modules){
					if(module.FAU_Program__c == participant.FAU_Program_Wave__c){
						moduleParticipants.add(new FAU_Module_Participant__c(FAU_Module__c = module.id, FAU_Participant__c = participant.id));
					}
				}
			}
		}
		
		return moduleParticipants;
	}

    /*******************************************************************
       Purpose:     Retrieve Particpants Modules for Modules which have been updated
    ********************************************************************/ 
    public static FAU_Module_Participant__c[] retrieveParticipantModulesToUpdate(FAU_Module__c[] lNewModules){
        System.Debug('## Cancel FAUModuleCls retrieveParticipantModulesToUpdate begin prepare');

        return [select Id, FAU_Module__c, FAU_Workflow_Start_Date__c, FAU_Workflow_End_Date__c from FAU_Module_Participant__c 
        		WHERE FAU_Module__c = :lNewModules]; 

    }

    /*******************************************************************
       Purpose:     Updated Particpants Modules for Participants which have been updated
    ********************************************************************/ 
    public static void updateParticipantModules(FAU_Module__c oNewModule, FAU_Module_Participant__c[] lNewModlueParticipants){
   		System.Debug('## Cancel FAUModuleCls updateParticipantModules begin prepare');
   		for(FAU_Module_Participant__c oNewModuleParticipant: lNewModlueParticipants){
	        if (oNewModule.Id == oNewModuleParticipant.FAU_Module__c){
	            oNewModuleParticipant.FAU_Workflow_Start_Date__c = oNewModule.FAU_Start_Date__c;
	            oNewModuleParticipant.FAU_Workflow_End_Date__c = oNewModule.FAU_End_Date__c;
	            

	        }
	    } 
   	}	
}