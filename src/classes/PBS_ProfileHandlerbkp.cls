/**
 * Class called from the trigger on PBS_Profile__c object
 *
 * @author Krzysztof Wasniowski <k.wasniowski@polsource.com>
 */
public with sharing class PBS_ProfileHandlerbkp implements PBS_Trigger
{
    /**
     * List<Training_Track__Share> toAdd list of sharings to be added
     */
    List<Almond__Training_Track__Share> toAdd    = new List<Almond__Training_Track__Share>();
    /**
     * List<Training_Track__Share> toAdd list of sharings to be removed
     */
    List<Almond__Training_Track__Share> toRemove = new List<Almond__Training_Track__Share>();

    /**
     * This method is called prior to execution of a BEFORE trigger.
     * Use this to cacheany data required into maps prior execution of the trigger.
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
        // just to make sonar happy that there are no empty methods
        System.debug(Logginglevel.DEBUG, 'In before insert');
    }

    /**
     * This method is called iteratively for each record to be updated during a BEFORE trigger.
     *
     * @param SObject oldSo Old object
     * @param SObject so New object
     */
    public void beforeUpdate(SObject oldSo, SObject so) {
        // just to make sonar happy that there are no empty methods
        System.debug(Logginglevel.DEBUG, 'In before update');
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
        // check if new sharings should be created
        /*PBS_ProfileService.PBS_ProfileWithoutSharing serviceClass = new PBS_ProfileService.PBS_ProfileWithoutSharing();
        toAdd.addAll(serviceClass.getNewSharingForProfile((PBS_Profile__c) so));*/
    }

    /**
     * This method is called iteratively for each record updated during an AFTER trigger.
     *
     * @param SObject oldSo Old object
     * @param SObject so New object
     */
    public void afterUpdate(SObject oldSo, SObject so) {
        PBS_Profile__c oldObj = (PBS_Profile__c) oldSo;
        PBS_Profile__c obj    = (PBS_Profile__c) so;

        // skip if nothing important changed
        if ( PBS_ProfileService.isUpdateRequired(obj, oldObj) ) {
          /*  PBS_ProfileService.PBS_ProfileWithoutSharing serviceClass = new PBS_ProfileService.PBS_ProfileWithoutSharing();
            toAdd.addAll(serviceClass.getNewSharingForProfile(obj));
            toRemove.addAll(serviceClass.getExistingSharingForProfile(oldObj));*/
        }
    }

    /**
     * This method is called iteratively for each record deleted during an AFTER trigger.
     *
     * @param SObject so Deleted object
     */
    public void afterDelete(SObject so) {
        // check if sharings should be removed
       /* PBS_ProfileService.PBS_ProfileWithoutSharing serviceClass = new PBS_ProfileService.PBS_ProfileWithoutSharing();
        toRemove.addAll(serviceClass.getExistingSharingForProfile((PBS_Profile__c) so));*/
    }

    /**
     * This method is called iteratively for each record undeleted during an AFTER trigger.
     *
     * @param SObject so Deleted object
     */
    public void afterUndelete(SObject so) {
        // check if sharings should be restored
       /* PBS_ProfileService.PBS_ProfileWithoutSharing serviceClass = new PBS_ProfileService.PBS_ProfileWithoutSharing();
        toAdd.addAll(serviceClass.getNewSharingForProfile((PBS_Profile__c) so));*/
    }

    /**
     * This method is called once all records have been processed by the trigger.
     * Use this method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally() {
        // process all sharings captured suring trigger live
       /* PBS_ProfileService.PBS_ProfileWithoutSharing serviceClass = new PBS_ProfileService.PBS_ProfileWithoutSharing();
        serviceClass.updateSharing(toAdd, toRemove);*/
    }
}