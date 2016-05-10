/********************************************************************
 Name:  CPA_TriggerFactory()
 Copyright © 2015  Unilever
 ======================================================
======================================================
Purpose:  Used to instantiate and execute Trigger Handlers associated with sObjects.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE               DETAIL                 Description
1.0     Shreyas Mangalvedhekar      03/04/2015          INITIAL DEVELOPMENT         
1.1     Jayprakash Bharti           01/04/2016          UPDATED KEYCONTACT  
***********************************************************************/
public with sharing class CPA_TriggerFactory
{
    /**
     * Public static method to create and execute a trigger handler
     *
     * Arguments:   Schema.sObjectType soType - Object type to process (SObject.sObjectType)
     *
     * Throws a TriggerException if no handler has been coded.
     */
    public static void createHandler(Schema.sObjectType soType)
    {
        // Get a handler appropriate to the object being processed
        CPA_Interface_Trigger handler = getHandler(soType);
        
        // Make sure we have a handler registered, new handlers must be registered in the getHandler method.
        if (handler == null)
        {
            throw new TriggerException('No Trigger Handler registered for Object Type: ' + soType);
        }
        
        // Execute the handler to fulfil the trigger
        execute(handler);
    }
    
    /**
     * private static method to control the execution of the handler
     *
     * Arguments:   CPA_Interface_Trigger handler - A Trigger Handler to execute
     */ 
    private static void execute(CPA_Interface_Trigger handler)
    {
        // Before Trigger
        if (Trigger.isBefore)
        {
            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore();
            
            // Iterate through the records to be deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeDelete(so);
                }
            }
            // Iterate through the records to be inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.beforeInsert(so);
                }
            }
            // Iterate through the records to be updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        }
        else
        {
            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter();
            
            // Iterate through the records deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterDelete(so);
                }
            }
            // Iterate through the records inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.afterInsert(so);
                }
            }
            // Iterate through the records updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        }
        
        // Perform any post processing
        handler.andFinally();
    }
    
    /**
     * private static method to get the appropriate handler for the object type.
     * Modify this method to add any additional handlers.
     *
     * Arguments:   Schema.sObjectType soType - Object type tolocate (SObject.sObjectType)
     *
     * Returns:     CPA_Interface_Trigger - A trigger handler if one exists or null.
     */
    private static CPA_Interface_Trigger getHandler(Schema.sObjectType soType)
    {
        if (soType == CPA_LOI__c.sObjectType){
            return new CPA_LOITrigger_Handler();
        }
        if (soType == CPA_CR__c.sObjectType){
            return new CPA_CRTrigger_Handler();
        }
        if (soType == CPA_project_work_order__c.sObjectType){
            return new CPA_PWOTrigger_Handler();
        }
        if (soType == CPA_PWORF__c.sObjectType){
            return new CPA_PWORFTrigger_Handler();
        }
        if (soType == CPA_HLE_Request__c.sObjectType){
            return new CPA_HLE_RequestTrigger_Handler();
        }
        if (soType == Attachment.sObjectType){
            return new CPA_attachment_Trigger_Handler();
        }
        if (soType == CPA_Queries__c.sObjectType){
            return new CPA_Queries_Trigger_Handler();
        }
        if (soType == CPA_Query_comment__c.sObjectType){
            return new CPA_Query_comment_Trigger_Handler();
        }
        if (soType == CPA_Key_Contacts__c.sObjectType){
            return new CPA_Key_Contact_Trigger_Handler();
        }
        if (soType == CPA_Requirements_and_Deliverables__c.sObjectType){
            return new CPA_RequirementsDeliverables_Handler();
        }
        if (soType == CPA_Resource_Requirement__c.sObjectType){
            return new CPA_Resource_Requirement_Handler();
        }
         if (soType == CPA_User_Defined_Attribute__c.sObjectType){
            return new CPA_User_Defined_Attribute_Handler();
        }
        
        return null;
    }

}