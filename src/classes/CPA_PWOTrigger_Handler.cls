/**********************************************************************
 Name:  CPA_PWOTrigger_Handler()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the CPA_project_work_order__c SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE              DETAIL                 Description
   1.0   Shreyas Mangalvedhekar      03/04/2016        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class CPA_PWOTrigger_Handler
    implements CPA_Interface_Trigger
{   
    
    CPA_Trigger_Pattern__c objPWOPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.PWOTRIGGERNAME);
    
    boolean triggerShouldExecute = objPWOPattern.chk_Check_Run__c;
    List<CPA_PWORF__c> lstPWORFUpdate = new List<CPA_PWORF__c>();
    List<CPA_TAT__c> lstTATforUpdate = new List<CPA_TAT__c>();
    // Constructor
    public CPA_PWOTrigger_Handler()
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
        System.debug('Entering CPA_PWOTrigger_Handler.bulkAfter');  
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
        System.debug('Exiting CPA_PWOTrigger_Handler.bulkAfter');   
 
    }
    
    public void bulkAfter()
    {
        System.debug('Entering CPA_PWOTrigger_Handler.bulkAfter');  


        if(triggerShouldExecute){ 
            if(Trigger.isInsert || Trigger.isUpdate) {

                if(Trigger.isUpdate) {
                    
                }
            }

            

        }
        System.debug('Exiting CPA_PWOTrigger_Handler.bulkAfter');   
    }
        
    public void beforeInsert(SObject so)
    {
        System.debug('Entering CPA_PWOTrigger_Handler.beforeInsert');
        if(triggerShouldExecute){
            
           CPA_Project_Work_Order_TriggerUtil.checklistValueOfcontract(trigger.new);
           //Below call added by Dinesh on 9/2 to generate internal POW ID
           //CPA_Project_Work_Order_TriggerUtil.internalPWOID(trigger.new);
           //Dinesh added this line [16/02] to get internal PWO ID from PWORF
           CPA_Project_Work_Order_TriggerUtil.getInternalPWOIDFromPWORF(trigger.new);
           //Below line added by Dinesh for Standalone PWO, later on move this method to trigger util class
           //CPA_StandalonePWOAndCR.createPWORF(trigger.new);
           CPA_Project_Work_Order_TriggerUtil.setFirstPWO(trigger.new);
    

        }
        System.debug('Exiting CPA_PWOTrigger_Handler.beforeInsert');
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering CPA_PWOTrigger_Handler.beforeUpdate');
        if(triggerShouldExecute){ 
            CPA_Project_Work_Order_TriggerUtil.checklistValueOfcontract(trigger.new);
            CPA_Project_Work_Order_TriggerUtil.requireApprovalComments(trigger.new);
            //CPA_Project_Work_Order_TriggerUtil.latestPWOStatus(trigger.new); // commented by Pooja bcoz of exception
          //  CPA_CNFTNF_TriggerUtil.CNFTNF_HistoricalData(trigger.old,trigger.new);
            
        }
        System.debug('Exiting CPA_PWOTrigger_Handler.beforeUpdate');
    }
    

    public void beforeDelete(SObject so)
    {   
        CPA_Project_Work_Order_TriggerUtil.DOntDelete(trigger.old);
    }
    
    public void afterInsert(SObject so) 
    {
        System.debug('Entering CPA_PWOTrigger_Handler.afterInsert');
        if(triggerShouldExecute){
            //CPA_StandalonePWOAndCR.updatePWORFName(trigger.new);
       lstTATforUpdate = CPA_Project_Work_Order_TriggerUtil.UpdateTATObj(trigger.new); 
        //CPA_Project_Work_Order_TriggerUtil.newPWO(trigger.new);// commented by Pooja bcoz of exception
            
        }
        System.debug('Exiting CPA_PWOTrigger_Handler.afterInsert');
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering CPA_PWOTrigger_Handler.afterUpdate');
        if(triggerShouldExecute){
           lstPWORFUpdate  = CPA_Project_Work_Order_TriggerUtil.submitforApproval(trigger.old,trigger.new);
            CPA_Project_Work_Order_TriggerUtil.recallApproval(trigger.old,trigger.new);
            CPA_CNFTNF_TriggerUtil.CNFTNF_HistoricalData(trigger.old,trigger.new);
        }
        System.debug('Exiting CPA_PWOTrigger_Handler.afterUpdate');
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
        System.debug('Entering CPA_PWOTrigger_Handler.andFinally');   
        if(lstTATforUpdate !=null && lstTATforUpdate.size()>0)  
        {
             CPA_Utilities.saveDatabase('insert', lstTATforUpdate , false);
        }
        if(lstPWORFUpdate !=null && lstPWORFUpdate.size()>0   ){
           CPA_Utilities.saveDatabase('update', lstPWORFUpdate , false); 

        }
        System.debug('Exiting CPA_PWOTrigger_Handler.andFinally');
    }

}