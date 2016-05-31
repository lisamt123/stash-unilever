/**
 * Class PBS_TriggerFactory
 *
 * Used to instantiate and execute Trigger Handlers associated with sObjects.
 */
public with sharing class PBS_TriggerFactory
{
    /**
     * Represents insert operation
     */
    public final static String OP_INSERT   = 'INSERT';
    /**
     * Represents update operation
     */
    public final static String OP_UPDATE   = 'UPDATE';
    /**
     * Represents delete operation
     */
    public final static String OP_DELETE   = 'DELETE';
    /**
     * Represents undelete operation
     */
    public final static String OP_UNDELETE = 'UNDELETE';

    /**
     * Public static method to create and execute a trigger handler
     *
     * @param Schema.sObjectType soType - Object type to process (SObject.sObjectType)
     * @throws PBS_TriggerException if no handler has been coded.
     */
    public static void createHandler(Schema.sObjectType soType)
    {
        // Get a handler appropriate to the object being processed
        PBS_Trigger handler = getHandler(soType);

        // Make sure we have a handler registered, new handlers must be registered in the getHandler method.
        if (handler == null)
        {
            throw new PBS_TriggerException('No Trigger Handler registered for Object Type: ' + soType);
        }

        // Execute the handler to fulfil the trigger
        execute(handler);
    }

    /**
     * private static method to control the execution of the handler
     *
     * @param OV_ITrigger handler - A Trigger Handler to execute
     */
    private static void execute(PBS_Trigger handler)
    {
        String operationType = Trigger.IsInsert ? PBS_TriggerFactory.OP_INSERT : Trigger.isUpdate ? PBS_TriggerFactory.OP_UPDATE : Trigger.isDelete ? PBS_TriggerFactory.OP_DELETE : PBS_TriggerFactory.OP_UNDELETE;

        // Before Trigger
        if (Trigger.isBefore)
        {
            // Call the bulk before to handle any caching of data and enable bulkification
            //handler.bulkBefore(Trigger.new, Trigger.old, operationType);

            // Iterate through the records to be deleted passing them to the handler.
            /*
            if (Trigger.isDelete)
            {
               for (SObject so : Trigger.old)
                {
                    //handler.beforeDelete(so);
                }
            }*/
            // Iterate through the records to be inserted passing them to the handler.
            if (Trigger.isInsert)
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
            //handler.bulkAfter(Trigger.new, Trigger.old, operationType);

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
            // Iterate through the records undeleted passing them to the handler.
            else if (Trigger.isUnDelete)
            {
                for (SObject so : Trigger.new)
                {
                    handler.afterUndelete(so);
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
     * @param Schema.sObjectType soType - Object type tolocate (SObject.sObjectType)
     * @return OV_Trigger - A trigger handler if one exists or null.
     */
    private static PBS_Trigger getHandler(Schema.sObjectType soType)
    {    system.debug('----soType'+soType);
         system.debug('----111Testing trigger');
        if (soType == PBS_Profile__c.sObjectType) {
            return new PBS_ProfileHandler();
        } else if (soType == PBS_Training_Track__c.sObjectType) {
            system.debug('----Testing trigger');
            return new PBS_TrainingTrackHandler();
        } else if (soType == PC_Group__c.sObjectType) {
            return new PC_GroupHandler();
        }

        return null;
    }
}