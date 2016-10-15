/********************************************************************
 Name:  FAU_ModuleHandler()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the FFAU_Module_Participant SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/12/2014        INITIAL DEVELOPMENT           
***********************************************************************/
public with sharing class FAU_ModuleHandler 
    implements ITrigger
{   
    public FAU_ModuleHandler() {    
    }

    boolean triggerShouldExecute = true;

   
    List<FAU_Module_Participant__c> lModuleParticipantsUpdate = new List<FAU_Module_Participant__c>();
    
    


    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {   
        System.debug('Entering FAU_ProgramHandler.bulkBefore'); 
        if(triggerShouldExecute){
            if(Trigger.isUpdate) {
                lModuleParticipantsUpdate = FAUModuleCls.retrieveParticipantModulesToUpdate(trigger.new);
            }
        }
    }
    
    public void bulkAfter()
    {
    	if(triggerShouldExecute){
    		if(Trigger.isInsert){
    			lModuleParticipantsUpdate = FAUModuleCls.createWebinarParticipants(Trigger.new);
    		}
    	}
    }
        
    public void beforeInsert(SObject so)
    {
        FAUModuleCls.updateParticipantModules((FAU_Module__c) so, lModuleParticipantsUpdate);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        FAUModuleCls.updateParticipantModules((FAU_Module__c) so, lModuleParticipantsUpdate);
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
        System.debug('Entering FAU_ProgramHandler.andFinally');
        if(triggerShouldExecute){
            System.debug('##### FAU_ProgramHandler.andFinally lModuleParticipantsUpdate:' + lModuleParticipantsUpdate);
            upsert lModuleParticipantsUpdate;

        }
        System.debug('Exiting FAU_ProgramHandler.andFinally');
    }
}