/**********************************************************************
 Name:  Amr_Interface_Trigger
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Interface containing methods Trigger Handlers must implement to enforce best practice
and bulkification of triggers.                                                         
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                      Description
 1.0 -   Mahesh Sankapal        05/04/2016            Initial Development  
 
***********************************************************************/
public interface Amr_Interface_Trigger 
{
    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    void bulkBefore();
    
    /**
     * bulkAfter
     *
     * This method is called prior to execution of an AFTER trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    void bulkAfter();
    
    /**
     * beforeInsert
     *
     * This method is called iteratively for each record to be inserted during a BEFORE
     * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
     */
    void beforeInsert();
    
    /**
     * beforeUpdate
     *
     * This method is called iteratively for each record to be updated during a BEFORE
     * trigger.
     */
    void beforeUpdate();

    /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger.
     */
    void beforeDelete();

    /**
     * afterInsert
     *
     * This method is called iteratively for each record inserted during an AFTER
     * trigger. Always put field validation in the 'After' methods in case another trigger
     * has modified any values. The record is 'read only' by this point.
     */
    void afterInsert();

    /**
     * afterUpdate
     *
     * This method is called iteratively for each record updated during an AFTER
     * trigger.
     */
    void afterUpdate();

    /**
     * afterDelete
     *
     * This method is called iteratively for each record deleted during an AFTER
     * trigger.
     */
    void afterDelete();

    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    void andFinally();
}