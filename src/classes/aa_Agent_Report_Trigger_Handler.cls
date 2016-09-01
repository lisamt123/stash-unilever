/**
 * Name:        -   aa_Agent_Report_Trigger_Handler()
 * @description -   Trigger Handler for the Agent_Report__c SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.     
 * @Author      -   Aslesha R K     
 */

public with sharing class aa_Agent_Report_Trigger_Handler
    implements AA_Interface_Trigger
{   
    
   aa_Trigger_pattern__c objAttachmentPattern = aa_Trigger_pattern__c.getValues('aa_Agent_Report_Trigger');
    boolean triggerShouldExecute = objAttachmentPattern.chk_Check_Run__c;
    
    // Constructor
    public aa_Agent_Report_Trigger_Handler()
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
        System.debug('Entering aa_Agent_Report_Trigger_Handler.bulkBefore');     
        System.debug('Exiting aa_Agent_Report_Trigger_Handler.bulkBefore');
         if(Trigger.isDelete){
         system.debug('Inside TRigger.isDelete -  Calling aa_Agent_Report_util.AgentReportRejected_Email');
         aa_Agent_Report_util.AgentReportRejected_Email(trigger.old);   
         }
    }
    
    public void bulkAfter()
    {
        System.debug('Entering aa_Agent_Report_Trigger_Handler.bulkAfter');     
        System.debug('Exiting aa_Agent_Report_Trigger_Handler.bulkAfter');
        if (Trigger.isUpdate)
        {
           aa_Agent_Report_util.CallDeleteAgentReport(trigger.new);
        }
         if(Trigger.isInsert)
         {
            aa_Agent_Report_util.Agent_After_Insert(trigger.new); 
         }
        
    }
        
    public void beforeInsert(SObject so)
    {
        System.debug('Entering aa_Agent_Report_Trigger_Handler.beforeInsert');     
        System.debug('Exiting aa_Agent_Report_Trigger_Handler.beforeInsert');
        
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering aa_Agent_Report_Trigger_Handler.beforeUpdate');   
        aa_Agent_Report_util.create_Chatter_posting(trigger.new,trigger.old);  
        System.debug('Exiting aa_Agent_Report_Trigger_Handler.beforeUpdate');
        
    }
    

    public void beforeDelete(SObject so)
    {   
        
        System.debug('Entering aa_Agent_Report_Trigger_Handler.beforeDelete');     
        System.debug('Exiting aa_Agent_Report_Trigger_Handler.beforeDelete');
        
        
    }
    
    public void afterInsert(SObject so) 
    {
        System.debug('Entering aa_Agent_Report_Trigger_Handler.afterInsert');     
        System.debug('Exiting aa_Agent_Report_Trigger_Handler.afterInsert');
        
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering aa_Agent_Report_Trigger_Handler.afterUpdate');     
        System.debug('Exiting aa_Agent_Report_Trigger_Handler.afterUpdate');
        
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
        System.debug('Entering aa_Agent_Report_Trigger_Handler.andFinally');     
        System.debug('Exiting aa_Agent_Report_Trigger_Handler.andFinally');
    }

}