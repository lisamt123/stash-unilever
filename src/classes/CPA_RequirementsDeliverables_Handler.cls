/**********************************************************************
 Name:  CPA_RequirementsDeliverables_Handler()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the CPA_Requirements_and_Deliverables__c SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                      DATE              DETAIL                 Description
   1.0      Jayprakash Bharti           01/04/2016        INITIAL DEVELOPMENT    Handle Tigger evnts on KeyContact       
***********************************************************************/

public with sharing class CPA_RequirementsDeliverables_Handler
    implements CPA_Interface_Trigger
{   
    
    CPA_Trigger_Pattern__c objPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.REQUIRMENTANDDELIVERABLETRIGERNAME);
    
    boolean triggerShouldExecute = objPattern.chk_Check_Run__c;
    // Constructor
    public CPA_RequirementsDeliverables_Handler()
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
        System.debug('Need to override this method as present in interface');
    }
    
    public void bulkAfter()
    {
       System.debug('Method is present in interface, need to override here');
    }
        
    public void beforeInsert(SObject so)
    {
        System.debug('This method is present in interface, hence need to override');
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
         if(triggerShouldExecute){ 
            CPA_RequirementsDeliverables_TriggerUtil.restrictUpdate(trigger.new);//to restrict Update of KeyContact
         }
    }
    

    public void beforeDelete(SObject so)
    {   
       CPA_RequirementsDeliverables_TriggerUtil.DontDelete(trigger.old);  
    }
    
    public void afterInsert(SObject so) 
    {
        System.debug('This method present in interface, need to override here');
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        System.debug('This method present in interface, hence need to override in this class');
    }
    
    /*******************************************************************
    Purpose: This method is present in interface, hence need to override here
    Parameters: SObject
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void afterDelete(SObject so)
    {
        System.debug('Method is present in interface, hence need to override here');
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {   
        System.debug('Exiting CPA_RequirementsDeliverables_Handler.andFinally');
    }

}