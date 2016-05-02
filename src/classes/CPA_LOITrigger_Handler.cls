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
        if(triggerShouldExecute){
            if(Trigger.isInsert || Trigger.isUpdate) {
                System.debug('Inside isInsert, isUpdate');
                //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
                //if(Trigger.isInsert){
                //}
                //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
                //if(Trigger.isUpdate) 
                //{
                    // Fill the Map with Participants Chatter Group memeberships for the program chatter group
                //} 

            } else if(Trigger.isDelete){
                CPA_LOI_TriggerUtil.DontDelete(trigger.old); 
            }
        }
    }
    
    public void bulkAfter()
    {
        System.debug('Inside bulkAfter');
        //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
        //if(triggerShouldExecute){ 
        //    if(Trigger.isInsert || Trigger.isUpdate) {
                //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
                //if(Trigger.isUpdate) {
                //}
         //   }
        //}
    }
        
    public void beforeInsert(SObject so)
    {
        if(triggerShouldExecute){
            CPA_LOI_TriggerUtil.checkforCancel(trigger.new);
            CPA_LOI_TriggerUtil.checklistValueOfLOI(trigger.new);
            //added by dinesh to generate internal LOI ID and internal PWO ID
            //CPA_LOI_TriggerUtil.internalLIOID(trigger.new);
            //Below line added by Dinesh [16/02]
            //CPA_LOI_TriggerUtil.getInternalPWOIDFromPWORF(trigger.new); // commented by pooja on 1st April 16 and added below line
            CPA_PWO_LOI_Trigger_Util.getInternalPWOIDFromPWO(trigger.new);
        }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        if(triggerShouldExecute){ 
            CPA_LOI_TriggerUtil.checklistValueOfLOI(trigger.new);
            CPA_LOI_TriggerUtil.requireApprovalComments(trigger.new);
            CPA_PWO_LOI_Trigger_Util.getUpdatedInternalPWOIDFromPWO(trigger.old,trigger.new);
        }
    }
    

    public void beforeDelete(SObject so)
    {   
             CPA_LOI_TriggerUtil.DontDelete(trigger.old);  
    }
    
    public void afterInsert(SObject so) 
    {
        //Commented below empty if condition because of SonarQube issue - Avoid empty if statements
        //if(triggerShouldExecute){}
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        if(triggerShouldExecute){
           listPWORFToUpdate =  CPA_LOI_TriggerUtil.submitforApproval(trigger.old,trigger.new);
            CPA_LOI_TriggerUtil.recallApproval(trigger.old,trigger.new);
           //listLOICancel =  CPA_LOI_TriggerUtil.cancelAllLOI(trigger.new);
        }
    }
    /*******************************************************************
    Purpose: This method is present in interface, hence need to override
    Parameters: SObject
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void afterDelete(SObject so)
    {
        System.debug('This method is present in interface, hence need to override');
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {
        if(listPWORFToUpdate!=null && listPWORFToUpdate.size()>0){    
            CPA_Utilities.saveDatabase(CPA_ConstantsForContractingAppClasses.UPDATECONSTANT, listPWORFToUpdate, false);
        }
        /*if(listLOICancel!=null && listLOICancel.size()>0){
            CPA_Utilities.saveDatabase(CPA_ConstantsForContractingAppClasses.UPDATECONSTANT, listLOICancel, false); 
        }*/
    }

}