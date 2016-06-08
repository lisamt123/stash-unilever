/**********************************************************************
 Name:  CPA_Query_comment_Trigger_Handler()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the CPA_Queries__c SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE              DETAIL                 Description
   1.0   Pooja Kanani      14/03/2016        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class CPA_Query_comment_Trigger_Handler
    implements CPA_Interface_Trigger
{   
    
    CPA_Trigger_Pattern__c objCRPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.QUERYCOMMENTTRIGERNAME);
    //CPA_Trigger_Pattern__c objCRPattern = CPA_Trigger_Pattern__c.getValues('CPA_Query_comment');
    boolean triggerShouldExecute = objCRPattern.chk_Check_Run__c;
    // Constructor
    public CPA_Query_comment_Trigger_Handler()
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
        System.debug('Entering CPA_Queries_Trigger_Handler.bulkAfter');  
        
    }
    
    public void bulkAfter()
    {
        System.debug('Entering CPA_Queries_Trigger_Handler.bulkAfter');  

       
    }
        
    public void beforeInsert(SObject so)
    {
        System.debug('Entering CPA_Queries_Trigger_Handler.beforeInsert');
        if(triggerShouldExecute){
             CPA_Queries_TriggerUtil.assigneduser(trigger.new);
        }
    }
    
    /*******************************************************************
    Purpose: This method is present in interface, hence need to override here
    Parameters: SObject
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void beforeUpdate(SObject oldSo, SObject so){
        System.debug('This method is present in interface, hence need to override here');
    }
    
    
    /*******************************************************************
    Purpose: This method is present in interface, hence need to override here
    Parameters: SObject
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void beforeDelete(SObject so){
        System.debug('This method is present in interface, hence need to override here');
    }
   
    /*******************************************************************
    Purpose: This method is present in interface, hence need to override here
    Parameters: SObject
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void afterInsert(SObject so){
        System.debug('This method is present in interface, hence need to override here');
    }
    
    /*******************************************************************
    Purpose: This method is present in interface, hence need to override here
    Parameters: SObject
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void afterUpdate(SObject oldSo, SObject so){
        System.debug('This method is present in interface, hence need to override here');
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
        System.debug('Entering CPA_Queries_Trigger_Handler.andFinally');     
        System.debug('Exiting CPA_Queries_Trigger_Handler.andFinally');
    }

}