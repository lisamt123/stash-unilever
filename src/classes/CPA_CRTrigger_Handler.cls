/**********************************************************************
 Name:  CPA_CRTrigger_Handler()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the CPA_CR__c SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE              DETAIL                 Description
   1.0   Shreyas Mangalvedhekar      03/04/2016        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class CPA_CRTrigger_Handler
    implements CPA_Interface_Trigger
{   
    
    CPA_Trigger_Pattern__c objCRPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.CRTRIGGERNAME);
    boolean triggerShouldExecute = objCRPattern.chk_Check_Run__c;
    // Constructor
    public CPA_CRTrigger_Handler()
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
        System.debug('Entering CPA_CRTrigger_Handler.bulkAfter');  
        if(triggerShouldExecute){
            if(Trigger.isInsert || Trigger.isUpdate) {


                if(Trigger.isInsert){
                    
                }

                if(Trigger.isUpdate) 
                {
                    // Fill the Map with Participants Chatter Group memeberships for the program chatter group
                    
                    
                } 
                

            } else if(Trigger.isDelete){
                CPA_LOI_TriggerUtil.DontDelete(trigger.old); 
            }

            
        }
        System.debug('Exiting CPA_CRTrigger_Handler.bulkAfter');   
 
    }
    
    public void bulkAfter()
    {
        System.debug('Entering CPA_CRTrigger_Handler.bulkAfter');  


        if(triggerShouldExecute){ 
            if(Trigger.isInsert || Trigger.isUpdate) {

                if(Trigger.isUpdate) {
                    
                }
            }

            

        }
        System.debug('Exiting CPA_CRTrigger_Handler.bulkAfter');   
    }
        
    public void beforeInsert(SObject so)
    {
        System.debug('Entering CPA_CRTrigger_Handler.beforeInsert');
        if(triggerShouldExecute){
            
            CPA_CR_TriggerUtil.CreateCR(trigger.new);
			CPA_CR_TriggerUtil.checklistValueOfCR(trigger.new);
			CPA_CR_TriggerUtil.standaloneCR(trigger.new);
         
    

        }
        System.debug('Exiting CPA_CRTrigger_Handler.beforeInsert');
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering CPA_CRTrigger_Handler.beforeUpdate');
        if(triggerShouldExecute){ 

			CPA_CR_TriggerUtil.previouStatusValue(trigger.old,trigger.new);
			CPA_CR_TriggerUtil.checklistValueOfCR(trigger.new);
			CPA_CR_TriggerUtil.requireApprovalComments(trigger.new);
			//  CPA_CR_TriggerUtil.unlockrecord(trigger.old,trigger.new);
			CPA_CR_TriggerUtil.calculateDelta(trigger.old,trigger.new);
        }
        System.debug('Exiting CPA_CRTrigger_Handler.beforeUpdate');
    }
    

    public void beforeDelete(SObject so)
    {   
        CPA_CR_TriggerUtil.DOntDeleteCR(trigger.old);
  
    }
    
    public void afterInsert(SObject so) 
    {
        System.debug('Entering CPA_CRTrigger_Handler.afterInsert');
        if(triggerShouldExecute){
			CPA_CR_TriggerUtil.newCR(trigger.new);
		}
        System.debug('Exiting CPA_CRTrigger_Handler.afterInsert');
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering CPA_CRTrigger_Handler.afterUpdate');
        if(triggerShouldExecute){
           CPA_CR_TriggerUtil.submitforApproval(trigger.old,trigger.new);
           CPA_CR_TriggerUtil.recallApproval(trigger.old,trigger.new);
        }
        System.debug('Exiting CPA_CRTrigger_Handler.afterUpdate');
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
        System.debug('Entering CPA_CRTrigger_Handler.andFinally');     
        System.debug('Exiting CPA_CRTrigger_Handler.andFinally');
    }

}