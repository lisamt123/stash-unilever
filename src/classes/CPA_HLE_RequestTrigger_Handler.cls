/**********************************************************************
 Name:  CPA_HLE_RequestTrigger_Handler()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the CPA_HLE_Request__c SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE              DETAIL                 Description
   1.0   Shreyas Mangalvedhekar      03/04/2016        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class CPA_HLE_RequestTrigger_Handler
    implements CPA_Interface_Trigger
{   
    
CPA_Trigger_Pattern__c objHLEPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.HLEREQUESTTRIGERNAME);
    
    boolean triggerShouldExecute = objHLEPattern.chk_Check_Run__c;
    // Constructor
    public CPA_HLE_RequestTrigger_Handler()
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
        System.debug('Entering CPA_HLE_RequestTrigger_Handler.bulkAfter');  
        //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
       // if(triggerShouldExecute){
           // if(Trigger.isInsert || Trigger.isUpdate) {

                //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
                //if(Trigger.isInsert){
                //}
                //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
                //if(Trigger.isUpdate) 
               // {
                    // Fill the Map with Participants Chatter Group memeberships for the program chatter group
               // } 
                

          //  } else if(Trigger.isDelete){
               // CPA_LOI_TriggerUtil.DontDelete(trigger.old); - this was already commented
           // }
        //}
    }
    
    public void bulkAfter()
    {
        //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
        //if(triggerShouldExecute){ 
         //   if(Trigger.isInsert || Trigger.isUpdate) {
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
        //}
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        if(triggerShouldExecute){ 
         CPA_HLERequest_TriggerUtil.unlockrecord(trigger.old,trigger.new);//to perform recall Approval process
         CPA_HLERequest_TriggerUtil.sLAValues(trigger.old,trigger.new);
         CPA_HLERequest_TriggerUtil.requireApprovalComments(trigger.new);
        }
    }
    

    public void beforeDelete(SObject so)
    {   
       CPA_HLERequest_TriggerUtil.DontDelete(trigger.old);  
    }
    
    public void afterInsert(SObject so) 
    {
        //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
        //if(triggerShouldExecute){
        //}
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        if(triggerShouldExecute){
            CPA_HLERequest_TriggerUtil.submitforApproval(trigger.old,trigger.new);
            CPA_HLERequest_TriggerUtil.recallApproval(trigger.old,trigger.new);
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
        System.debug('Entering CPA_HLE_RequestTrigger_Handler.andFinally');     
        System.debug('Exiting CPA_HLE_RequestTrigger_Handler.andFinally');
    }

}