/**********************************************************************
 Name:  CPA_LOITrigger_Handler()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the CPA_LOI__c SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE              DETAIL                 Description
   1.0   Shreyas Mangalvedhekar      03/04/2016        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class CPA_LOITrigger_Handler
    implements CPA_Interface_Trigger
{   
    
    CPA_Trigger_Pattern__c objLOIPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.LOITRIGGERNAME);
    boolean triggerShouldExecute = objLOIPattern.chk_Check_Run__c;
    List<CPA_PWORF__c> listPWORFToUpdate = new List<CPA_PWORF__c>();
    List<CPA_LOI__c> listLOICancel = new List<CPA_LOI__c> ();
    // Constructor
    public CPA_LOITrigger_Handler()
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
        System.debug('Entering CPA_LOITrigger_Handler.bulkAfter');  
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
        System.debug('Exiting CPA_LOITrigger_Handler.bulkAfter');   
 
    }
    
    public void bulkAfter()
    {
        System.debug('Entering CPA_LOITrigger_Handler.bulkAfter');  


        if(triggerShouldExecute){ 
            if(Trigger.isInsert || Trigger.isUpdate) {

                if(Trigger.isUpdate) {
                    
                }
            }

            

        }
        System.debug('Exiting CPA_LOITrigger_Handler.bulkAfter');   
    }
        
    public void beforeInsert(SObject so)
    {
        System.debug('Entering CPA_LOITrigger_Handler.beforeInsert');
        if(triggerShouldExecute){
            
            CPA_LOI_TriggerUtil.checkforCancel(trigger.new);
            CPA_LOI_TriggerUtil.checklistValueOfLOI(trigger.new);
            //added by dinesh to generate internal LOI ID and internal PWO ID
            CPA_LOI_TriggerUtil.internalLIOID(trigger.new);
            //Below line added by Dinesh [16/02]
            CPA_LOI_TriggerUtil.getInternalPWOIDFromPWORF(trigger.new);
    

        }
        System.debug('Exiting CPA_LOITrigger_Handler.beforeInsert');
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering CPA_LOITrigger_Handler.beforeUpdate');
        if(triggerShouldExecute){ 

            CPA_LOI_TriggerUtil.checklistValueOfLOI(trigger.new);
            CPA_LOI_TriggerUtil.requireApprovalComments(trigger.new);
        }
        System.debug('Exiting CPA_LOITrigger_Handler.beforeUpdate');
    }
    

    public void beforeDelete(SObject so)
    {   
             CPA_LOI_TriggerUtil.DontDelete(trigger.old);  
    }
    
    public void afterInsert(SObject so) 
    {
        System.debug('Entering CPA_LOITrigger_Handler.afterInsert');
        if(triggerShouldExecute){}
        System.debug('Exiting CPA_LOITrigger_Handler.afterInsert');
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering CPA_LOITrigger_Handler.afterUpdate');
        if(triggerShouldExecute){
           listPWORFToUpdate =  CPA_LOI_TriggerUtil.submitforApproval(trigger.old,trigger.new);
            CPA_LOI_TriggerUtil.recallApproval(trigger.old,trigger.new);
           listLOICancel =  CPA_LOI_TriggerUtil.cancelAllLOI(trigger.new);
        }
        System.debug('Exiting CPA_LOITrigger_Handler.afterUpdate');
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
        System.debug('Entering CPA_LOITrigger_Handler.andFinally');
        if(listPWORFToUpdate!=null && listPWORFToUpdate.size()>0){    
            CPA_Utilities.saveDatabase('update', listPWORFToUpdate, false);
        }
        if(listLOICancel!=null && listLOICancel.size()>0){
            CPA_Utilities.saveDatabase('update', listLOICancel, false); 
        }
            
        System.debug('Exiting CPA_LOITrigger_Handler.andFinally');
    }

}