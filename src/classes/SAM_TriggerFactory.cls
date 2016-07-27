/********************************************************************
 Name:  SAM_TriggerFactory()
 Copyright © 2015  Unilever
 ======================================================
======================================================
Purpose:  Used to instantiate and execute Trigger Handlers associated with sObjects.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                    DATE               DETAIL                 Description
1.0     Dineshsing Girase          06/07/2016          INITIAL DEVELOPMENT         
***********************************************************************/
public with sharing class SAM_TriggerFactory
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
        SAM_Interface_Trigger handler = getHandler(soType);
        
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
     * Arguments:   SAM_Interface_Trigger handler - A Trigger Handler to execute
     */ 
    private static void execute(SAM_Interface_Trigger handler)
    {
        // Before Trigger
        if (Trigger.isBefore)
        {
            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore();
            
            // Iterate through the records to be deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                    handler.beforeDelete(Trigger.old);
            }
            // Iterate through the records to be inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                    handler.beforeInsert(Trigger.new);
            }
            // Iterate through the records to be updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                    handler.beforeUpdate(Trigger.new,Trigger.old);
            }
        }
        else
        {
            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter();
            
            // Iterate through the records deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                    handler.afterDelete(Trigger.old);
            }
            // Iterate through the records inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                    handler.afterInsert(Trigger.new);
            }
            // Iterate through the records updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                    handler.afterUpdate(Trigger.new,Trigger.old);
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
     * Returns:     SAM_Interface_Trigger - A trigger handler if one exists or null.
     */
    private static SAM_Interface_Trigger getHandler(Schema.sObjectType soType)
    {    
        if (soType == SAM_Quote_Line_Item__c.sObjectType){
            return new SAM_QLITrigger_Handler();
        }
        if (soType == SAM_Request__c.sObjectType){
            return new SAM_RequestTrigger_Handler();
        }
        return null;
    }

}