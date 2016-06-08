/**********************************************************************
 Name:  CPA_PWORFTrigger_Handler()
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

public with sharing class CPA_PWORFTrigger_Handler
    implements CPA_Interface_Trigger
{   
    
    CPA_Trigger_Pattern__c objAttachmentPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.PWORFTRIGERNAME);
    
    boolean triggerShouldExecute = objAttachmentPattern.chk_Check_Run__c;
    // Constructor
    public CPA_PWORFTrigger_Handler()
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
        //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
        //if(triggerShouldExecute){
       //     if(Trigger.isInsert || Trigger.isUpdate) {

                //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
                //if(Trigger.isInsert){
                //}
                //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
                //if(Trigger.isUpdate) 
                //{
                    // Fill the Map with Participants Chatter Group memeberships for the program chatter group
                //} 
                
       //     } else if(Trigger.isDelete){
               // CPA_LOI_TriggerUtil.DontDelete(trigger.old); - This was already commented
       //     }
           
       // }
    }
    
    public void bulkAfter()
    {
        //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
        //if(triggerShouldExecute){ 
        //    if(Trigger.isInsert || Trigger.isUpdate) {
                //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
                //if(Trigger.isUpdate) {
                //}
        //    }

        //}
    }
        
    public void beforeInsert(SObject so)
    {
        //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
        //if(triggerShouldExecute){

       // }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        if(triggerShouldExecute){ 
             //CPA_PWORF_TriggerUtil.recallApproval(trigger.new);//to perform recall Approval process on PWORF record 
            CPA_PWORF_TriggerUtil.updateSLAData(trigger.old,trigger.new);
            //CPA_PWORF_TriggerUtil.AssignProject_requestor(trigger.new); // to assign Project_requestor if not selected
            CPA_PWORF_TriggerUtil.requireApprovalComments(trigger.new);
            //Dinesh added below code [17/02] to generate internal PWO ID
            //later on move this method to CPA_PWORF_TriggerUtil class
            CPA_CalculationOfBusinessDaysForSLADates.generateInternalPWOID(trigger.old,trigger.new);
            CPA_PWORF_TriggerUtil.restrictULPMtoUpdate(trigger.old,trigger.new);
            CPA_PWORF_TriggerUtil.restricSMTULPMToAcceptReject(trigger.new,trigger.old);
        }
    }
    

    public void beforeDelete(SObject so)
    {   
        CPA_PWORF_TriggerUtil.DontDelete(trigger.old);
    }
    
    public void afterInsert(SObject so) 
    {
        //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
        if(triggerShouldExecute){
            CPA_PWORFAgeing.InsertPworfAgeingRecord(trigger.new); // to set the Ageing Days.
        }
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        if(triggerShouldExecute){
            CPA_PWORF_TriggerUtil.submitforApproval(trigger.old,trigger.new);
            CPA_PWORF_TriggerUtil.recallApproval(trigger.old,trigger.new);
            // 04/04/2016 :- Shreyas  : This method to unlock the PWORF from approval process.
            CPA_PWORF_TriggerUtil.unlockPworf(trigger.new);
            //CPA_PWORF_TriggerUtil.updateSLAData(trigger.new);
            CPA_PWORFAgeing.updatePworfAgeingRecord(trigger.old,trigger.new); // to set the Ageing Days.
            //Dinesh added below line for search testing, please dont remove this line
            //9/2 - commented because, generating PWO ID either from LIO or PWO
            //CPA_CalculationOfBusinessDaysForSLADates.forSearch(trigger.old,trigger.new);
        }
    }
    /*******************************************************************
    Purpose: This method is present in interface, hence need to override here
    Parameters: SObject
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void afterDelete(SObject so)
    {
        System.debug('This method is present in interface, hence need to override here');
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    { 
        System.debug('Entering CPA_PWORFTrigger_Handler.andFinally');     
        System.debug('Exiting CPA_PWORFTrigger_Handler.andFinally');
    }

}