/**********************************************************************
 Name:  Amr_Job_DetailsTrigger_Handler()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the CPA_CR__c SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE              DETAIL                 Description
   1.0 -   Mahesh Sankapal      05/04/2016            Initaial Developemnt        
***********************************************************************/

public with sharing class Amr_Job_DetailsTrigger_Handler
    implements amr_Interface_Trigger
{   
    
    /*CPA_Trigger_Pattern__c objCRPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.CRTRIGGERNAME);
    boolean triggerShouldExecute = objCRPattern.chk_Check_Run__c;
    */
    // Constructor
    public Amr_Job_DetailsTrigger_Handler()
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
        System.debug('Entering Amr_ReportTrigger_Util.bulkAfter');          
    }
    
    public void bulkAfter()
    {
        System.debug('Entering Amr_ReportTrigger_Util.bulkAfter');
    }
        
    public void beforeInsert(SObject so)
    {
        System.debug('Entering Amr_ReportTrigger_Util.beforeInsert');
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering Amr_ReportTrigger_Util.beforeUpdate');
    }
    

    public void beforeDelete(SObject so)
    {   
      System.debug('Entering Amr_ReportTrigger_Util.beforeDelete');
    }
    
    public void afterInsert(SObject so) 
    {
       System.debug('Entering Amr_ReportTrigger_Util.afterInsert');
       Amr_ReportTrigger_Util.amr_report_trigger_method(trigger.new,trigger.old);
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering Amr_ReportTrigger_Util.afterUpdate');
        Amr_ReportTrigger_Util.amr_report_trigger_method(trigger.new,trigger.old);
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
        System.debug('Entering Amr_ReportTrigger_Util.andFinally');           
        System.debug('Exiting Amr_ReportTrigger_Util.andFinally');
    }

}