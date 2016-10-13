/********************************************************************
 Name:  FAU_WebinarHandler()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the FAU_Webinar SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Michal Bluj      13/12/2014        INITIAL DEVELOPMENT           
***********************************************************************/
public with sharing class FAU_WebinarHandler implements ITrigger {
    
    boolean triggerShouldExecute = true;
    
    List<FAU_Webinar_Participant__c> webinarRelatedParticipants = new List<FAU_Webinar_Participant__c>();
      
    public FAU_WebinarHandler() {}
    //Intentionally empty body as it is required to implement all of ITrigger methods.
    public void bulkBefore(){   
        
    }
    
    public void bulkAfter(){
        if(triggerShouldExecute){
            if(Trigger.isInsert){
                webinarRelatedParticipants = FAUWebinarCls.createWebinarParticipants(Trigger.new);
            }
            if(Trigger.isUpdate){
                webinarRelatedParticipants = FAUWebinarCls.updateWebinarParticipantsWhenChangedToInvited(Trigger.new,Trigger.oldMap);
            }
        }
    }
     
     //Intentionally empty body as it is required to implement all of ITrigger methods.   
    public void beforeInsert(SObject so){
    }
    //Intentionally empty body as it is required to implement all of ITrigger methods.
    public void beforeUpdate(SObject oldSo, SObject so){
    }
    //Intentionally empty body as it is required to implement all of ITrigger methods. 
    public void beforeDelete(SObject so){   
    }
    //Intentionally empty body as it is required to implement all of ITrigger methods.
    public void afterInsert(SObject so){
    }
    //Intentionally empty body as it is required to implement all of ITrigger methods.
    public void afterUpdate(SObject oldSo, SObject so){
    }
    //Intentionally empty body as it is required to implement all of ITrigger methods.
    public void afterDelete(SObject so){
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally(){
        if(triggerShouldExecute){
            if(Trigger.isInsert) {
                insert webinarRelatedParticipants;
            }
            if(Trigger.isUpdate) {
                update webinarRelatedParticipants;
            }
        }
    }

}