/**********************************************************************
 Name:  CPA_Resource_Requirement_Handler()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the CPA_Resource_Requirement__c SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                      DATE              DETAIL                 Description
   1.0      Pooja          01/04/2016        INITIAL DEVELOPMENT    Handle Tigger evnts on Resource_Requirement      
***********************************************************************/

public with sharing class CPA_Resource_Requirement_Handler
    implements CPA_Interface_Trigger
{   
    
    CPA_Trigger_Pattern__c objResource_RequirementPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.RESOURCEREQUIREMENTTRIGERNAME);
    
    boolean triggerShouldExecute = objResource_RequirementPattern.chk_Check_Run__c;
    // Constructor
    public CPA_Resource_Requirement_Handler()
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
        System.debug('Method is present in interface, need to override in this class');
    }
    
    public void bulkAfter()
    {
       System.debug('Need to override this method as present in interface');
    }
        
    public void beforeInsert(SObject so)
    {
        System.debug('Method is present in interface, need to override here');
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        if(triggerShouldExecute){ 
            CPA_Resource_Requirement_TriggerUtil.restrictUpdatenewResource_Requirement(trigger.new);//to restrict Update 
        }
    }
    

    public void beforeDelete(SObject so)
    {   
       CPA_Resource_Requirement_TriggerUtil.DontDelete(trigger.old);  
       
    }
    
    public void afterInsert(SObject so) 
    {
        System.debug('This method is present in interface, hence need to override');
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        System.debug('This method present in interface, need to override here');
    }
    
    /*******************************************************************
    Purpose: This method is present in interface, hence need to override here
    Parameters: SObject
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void afterDelete(SObject so)
    {
        System.debug('This method present in interface, hence need to override here');
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {   
        System.debug('Exiting CPA_Resource_Requirement_Handler.andFinally');
    }

}