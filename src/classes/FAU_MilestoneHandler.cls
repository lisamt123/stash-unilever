/********************************************************************
 Name:  FAU_MilestoneHandler()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the FAU_Milestone_Participant SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/12/2014        INITIAL DEVELOPMENT           
***********************************************************************/
public with sharing class FAU_MilestoneHandler 
    implements ITrigger
{   
    public FAU_MilestoneHandler() {    
    }

    boolean triggerShouldExecute = true;

   
    List<FAU_Milestone_Participant__c> lMilestoneParticipantsUpdate = new List<FAU_Milestone_Participant__c>();
    
    


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
                lMilestoneParticipantsUpdate = FAUMilestoneCls.retrieveParticipantMilestonesToUpdate(trigger.new);
            }
        }
    }
    
    public void bulkAfter()
    {
        if(triggerShouldExecute){
            if(Trigger.isInsert) {
                lMilestoneParticipantsUpdate = FAUMilestoneCls.createMilestoneParticipants(trigger.new);
            }
        }
    }
        
    public void beforeInsert(SObject so)
    {
        FAUMilestoneCls.updateParticipantMilestones((FAU_Milestone__c) so, lMilestoneParticipantsUpdate);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        FAUMilestoneCls.updateParticipantMilestones((FAU_Milestone__c) so, lMilestoneParticipantsUpdate);
    }
     

  // This Class is implementing ITrigger, So can't remove this Function
  
   public void beforeDelete(SObject so)
    { 
    }
     // This Class is implementing ITrigger, So can't remove this Function
     
    public void afterInsert(SObject so) 
    {
    }
     // This Class is implementing ITrigger, So can't remove this Function
     
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
     // This Class is implementing ITrigger, So can't remove this Function
     
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
            upsert lMilestoneParticipantsUpdate;

        }
        System.debug('Exiting FAU_ProgramHandler.andFinally');
    }

}