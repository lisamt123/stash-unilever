/**
 * Interface containing methods Trigger Handlers must implement to enforce best practice and bulkification of triggers.
 *
 * @author Krzysztof Wasniowski <k.wasniowski@polsource.com>
 */
public interface PBS_Trigger
{
    /**
     * This method is called prior to execution of a BEFORE trigger.
     * Use this to cacheany data required into maps prior execution of the trigger.
     *
     * @param List<SObject> newList List of new objects / modifications
     * @param List<SObject> oldList List of old objects / before modifications
     * @param String operationType Information if this is an update, insert, delete or undelete
     */
   // void bulkBefore(List<sObject> newData, List<sObject> oldData, String operationType);

    /**
     * This method is called prior to execution of an AFTER trigger.
     * Use this to cache any data required into maps prior execution of the trigger.
     *
     * @param List<SObject> newList List of new objects / modifications
     * @param List<SObject> oldList List of old objects / before modifications
     * @param String operationType Information if this is an update, insert, delete or undelete
     */
   // void bulkAfter(List<sObject> newData, List<sObject> oldData, String operationType);

    /**
     * This method is called iteratively for each record to be inserted during a BEFORE trigger.
     * Never execute any SOQL/SOSL etc in this and other iterative methods.
     *
     * @param SObject so New object
     */
    void beforeInsert(SObject so);

    /**
     * This method is called iteratively for each record to be updated during a BEFORE trigger.
     *
     * @param SObject oldSo Old object
     * @param SObject so New object
     */
    void beforeUpdate(SObject oldSo, SObject so);

    /**
     * This method is called iteratively for each record to be deleted during a BEFORE trigger.
     *
     * @param SObject so Object to delete
     */
   // void beforeDelete(SObject so);

    /**
     * This method is called iteratively for each record inserted during an AFTER trigger.
     * Always put field validation in the 'After' methods in case another trigger has modified any values. The record is 'read only' by this point.
     *
     * @param SObject so New object
     */
    void afterInsert(SObject so);

    /**
     * This method is called iteratively for each record updated during an AFTER trigger.
     *
     * @param SObject oldSo Old object
     * @param SObject so New object
     */
    void afterUpdate(SObject oldSo, SObject so);

    /**
     * This method is called iteratively for each record deleted during an AFTER trigger.
     *
     * @param SObject so Deleted object
     */
    void afterDelete(SObject so);

    /**
     * This method is called iteratively for each record undeleted during an AFTER trigger.
     *
     * @param SObject so Deleted object
     */
    void afterUndelete(SObject so);

    /**
     * This method is called once all records have been processed by the trigger.
     * Use this method to accomplish any final operations such as creation or updates of other records.
     */
    void andFinally();
}