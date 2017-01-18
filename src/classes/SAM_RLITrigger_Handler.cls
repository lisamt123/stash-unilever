/**********************************************************************
 Name:  SAM_RLITrigger_Handler()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the SAM_Request_Line_Item__c SObject. This class implements the SAM_Interface_Trigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE              DETAIL                 Description
   1.0  Pooja Kanani               04/08/2016        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class SAM_RLITrigger_Handler
    implements SAM_Interface_Trigger
{   
    
    SAM_Trigger_Pattern__c objRLIPattern = SAM_Trigger_Pattern__c.getValues(SAM_Constants.REQUESTLINEITEMTRIGERNAME);

    boolean triggerShouldExecute = objRLIPattern.chk_Stop_Trigger_Execution__c;
    // Constructor
    public SAM_RLITrigger_Handler()
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
        System.debug('bulkBefore called');
    }
    
    
    public void bulkAfter()
    {
        System.debug('bulkAfter called');
    }
        
    public void beforeInsert(List<SObject> lstsObjectNew)
    {
        if(triggerShouldExecute){
            System.debug('beforeInsert called');
            SAM_RLITrigger_TriggerUtil.PreventNewRecord(trigger.new);
            
        }
    }
    
    public void beforeUpdate(List<SObject> lstsObjectOld, List<SObject> lstsObjectNew)
    {
        if(triggerShouldExecute){
         System.debug('beforeUpdate called');        
        }
    }
    

    public void beforeDelete(List<SObject> lstsObjectOld)
    {   
        if(triggerShouldExecute){ 
           SAM_RLITrigger_TriggerUtil.PreventDelete(lstsObjectOld);
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
        System.debug('Entering SAM_RLITrigger_Handler.andFinally');     
    }
    
}