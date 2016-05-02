/*
 * Class called from the trigger on PC_Group__c object
 *
 * @author Krzysztof Wasniowski <k.wasniowski@polsource.com>
 */
public with sharing class PC_GroupHandler implements PBS_Trigger
{
    public final static string ERROR_MESSAGE = 'Order value [ {0} ] is already in use, please pick different value.';

    /**
     * This method is called prior to execution of a BEFORE trigger. Use this to cacheany data required into maps prior execution of the trigger.
     *
     * @param List<SObject> newList List of new objects / modifications
     * @param List<SObject> oldList List of old objects / before modifications
     * @param String operationType Information if this is an update, insert, delete or undelete
     */
     
      /* 
    public void bulkBefore(List<SObject> newList, List<SObject> oldList, String operationType) {
        // just to make sonar happy that there are no empty methods
        System.debug(Logginglevel.DEBUG, 'In bulk before');
    }*/

    /**
     * This method is called prior to execution of an AFTER trigger.
     * Use this to cache any data required into maps prior execution of the trigger.
     *
     * @param List<SObject> newList List of new objects / modifications
     * @param List<SObject> oldList List of old objects / before modifications
     * @param String operationType Information if this is an update, insert, delete or undelete
     */
      /* 
    public void bulkAfter(List<SObject> newList, List<SObject> oldList, String operationType) {
        // just to make sonar happy that there are no empty methods
        System.debug(Logginglevel.DEBUG, 'In bulk after');
    }*/

    /**
     * This method is called iteratively for each record to be inserted during a BEFORE trigger.
     * Never execute any SOQL/SOSL etc in this and other iterative methods.
     *
     * @param SObject so New object
     */
    public void beforeInsert(SObject so) {
        PC_Group__c groupObj = (PC_Group__c) so;

        if (groupObj.published__c && groupObj.order__c != null && 0 < Database.countQuery('SELECT count() FROM PC_Group__c WHERE published__c = true AND order__c = ' + groupObj.order__c)) {
            groupObj.order__c.addError(String.format(ERROR_MESSAGE, new List<String>{String.valueOf(groupObj.order__c)}));
        }
    }

    /**
     * This method is called iteratively for each record to be updated during a BEFORE trigger.
     *
     * @param SObject oldSo Old object
     * @param SObject so New object
     */
    public void beforeUpdate(SObject oldSo, SObject so) {
        PC_Group__c groupObj    = (PC_Group__c) so;
        PC_Group__c groupObjOld = (PC_Group__c) oldSo;

        // check if there were any changes
        Boolean runCheck = groupObj.published__c != groupObjOld.published__c || groupObj.order__c != groupObjOld.order__c;
        // if so then check if check should be run
        runCheck = runCheck && groupObj.published__c && groupObj.order__c != null;

        if (runCheck && 0 < Database.countQuery('SELECT count() FROM PC_Group__c WHERE published__c = true AND order__c = ' + groupObj.order__c)) {
            groupObj.order__c.addError(String.format(ERROR_MESSAGE, new List<String>{String.valueOf(groupObj.order__c)}));
        }
    }

    /**
     * This method is called iteratively for each record to be deleted during a BEFORE trigger.
     *
     * @param SObject so Object to delete
     */
     /*  
    public void beforeDelete(SObject so) {
        // just to make sonar happy that there are no empty methods
        System.debug(Logginglevel.DEBUG, 'In before delete');
    }*/

    /**
     * This method is called iteratively for each record inserted during an AFTER trigger.
     * Always put field validation in the 'After' methods in case another trigger has modified any values. The record is 'read only' by this point.
     *
     * @param SObject so New object
     */
    public void afterInsert(SObject so) {
        // just to make sonar happy that there are no empty methods
        System.debug(Logginglevel.DEBUG, 'In after insert');
    }

    /**
     * This method is called iteratively for each record updated during an AFTER trigger.
     *
     * @param SObject oldSo Old object
     * @param SObject so New object
     */
    public void afterUpdate(SObject oldSo, SObject so) {
        // just to make sonar happy that there are no empty methods
        System.debug(Logginglevel.DEBUG, 'In after update');
    }

    /**
     * This method is called iteratively for each record deleted during an AFTER trigger.
     *
     * @param SObject so Deleted object
     */
    public void afterDelete(SObject so) {
        // just to make sonar happy that there are no empty methods
        System.debug(Logginglevel.DEBUG, 'In after delete');
    }

    /**
     * This method is called iteratively for each record undeleted during an AFTER trigger.
     *
     * @param SObject so Deleted object
     */
    public void afterUndelete(SObject so) {
        // just to make sonar happy that there are no empty methods
        System.debug(Logginglevel.DEBUG, 'In after undelete');
    }

    /**
     * This method is called once all records have been processed by the trigger.
     * Use this method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally() {
        // just to make sonar happy that there are no empty methods
        System.debug(Logginglevel.DEBUG, 'In finally');
    }
}