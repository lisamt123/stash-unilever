/**********************************************************************
 Name:  SAM_RequestTrigger_Handler()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the SAM_Request__c SObject. This class implements the SAM_Interface_Trigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE              DETAIL                 Description
   1.0   Dineshsing Girase      06/07/2016        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class SAM_RequestTrigger_Handler
    implements SAM_Interface_Trigger
{   
    SAM_Trigger_Pattern__c objRequestPattern = SAM_Trigger_Pattern__c.getValues(SAM_Constants.REQUESTTRIGERNAME);
    boolean triggerShouldExecute = objRequestPattern.chk_Stop_Trigger_Execution__c;
    // Constructor
    public SAM_RequestTrigger_Handler()
    {
    }

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
     
    public void bulkBefore(){
        System.debug('bulkBefore called');
    }
    
    
    public void bulkAfter()
    {
        System.debug('bulkAfter called');
    }
        
    public void beforeInsert(List<SObject> lstsObjectNew)
    {
        if(triggerShouldExecute){
            SAM_Request_TriggerUtil.PreventRequestAssignment(lstsObjectNew);
            System.debug('beforeInsert called');
        }
    }
    
    public void beforeUpdate(List<SObject> lstsObjectOld, List<SObject> lstsObjectNew)
    {
        if(triggerShouldExecute)
        {
            System.debug('beforeUpdate called');
            SAM_Request_TriggerUtil.validationForBuildDetail(trigger.new,trigger.old);
            SAM_Request_TriggerUtil.PreventRequestAssignment(trigger.new);
            SAM_Request_TriggerUtil.PreventEditAfterClose(trigger.new,trigger.old); 
           // SAM_Request_TriggerUtil.StatusUpdate(lstsObjectNew,lstsObjectOld);         
        }
    }
    

    public void beforeDelete(List<SObject> lstsObjectOld)
    {   
        if(triggerShouldExecute){ 
            //SAM_Request_TriggerUtil.PreventDelete(lstsObjectOld);
            System.debug('beforeDelete called');
        }
    }
    
    public void afterInsert(List<SObject> lstsObjectNew) 
    {
        if(triggerShouldExecute){ 
            System.debug('afterInsert called');
        }
    }
    
    public void afterUpdate(List<SObject> lstsObjectOld, List<SObject> lstsObjectNew)
    {
        if(triggerShouldExecute){
            System.debug('afterUpdate called');
            //SAM_Request_TriggerUtil.ResetNextActionPicklists(lstsObjectNew,lstsObjectOld);
        }
    }
    
    
    /*******************************************************************
    Purpose: This method is present in interface, hence need to override here
    Parameters: SObject
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    
    public void afterDelete(List<SObject> lstsObjectOld)
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
    }
    
}