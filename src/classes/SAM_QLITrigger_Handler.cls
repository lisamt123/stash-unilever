/**********************************************************************
 Name:  SAM_QLITrigger_Handler()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the SAM_Quote_Line_Item__c SObject. This class implements the SAM_Interface_Trigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE              DETAIL                 Description
   1.0   Dineshsing Girase      06/07/2016        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class SAM_QLITrigger_Handler
    implements SAM_Interface_Trigger
{   
    
    SAM_Trigger_Pattern__c objQLIPattern = SAM_Trigger_Pattern__c.getValues(SAM_Constants.QUOTELINEITEMTRIGERNAME);
    //Dinesh 26/7 - Check null before below line
    boolean triggerShouldExecute = objQLIPattern.chk_Stop_Trigger_Execution__c;
    // Constructor
    public SAM_QLITrigger_Handler()
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
            SAM_QLITrigger_Util.PreventNewRecord(trigger.new);
            SAM_QLITrigger_Util.currencyConversionRate(trigger.new);
            
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
            SAM_QLITrigger_Util.PreventDelete(trigger.old);
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
    if(triggerShouldExecute){
        System.debug('This method is present in interface, hence need to override here');
        SAM_QLITrigger_Util.ReNumberQuotationLineItems(lstsObjectOld);
        }
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
     
    public void andFinally()
    { 
        System.debug('Entering SAM_QLITrigger_Handler.andFinally');     
    }
    
}