public with sharing class AF_OOPSActualHandler implements ITrigger{
     // AF_UpdateCatFinanceApprover Trigger Logic starts
    private List<AF_OOPS_Actual__c>  afOopsEstimates=new List<AF_OOPS_Actual__c>();
    // AF_UpdateCatFinanceApprover Trigger Logic Ends
    // AF_AfterUpdateOOPSActual Trigger Logic Starts
    private List<AF_OOPS_Actual__c> recalculateEstimateList = new List<AF_OOPS_Actual__c>();
    // AF_AfterUpdateOOPSActual Trigger Logic Ends
    // AF_OopsPOreport_Delete Trigger Logic Starts 
    private Set<Id> OOPSDeleteActualIds = new Set<Id>();
    // AF_OopsPOreport_Delete Trigger Logic Ends
    
    public void bulkBefore()
    {
        // AF_UpdateCatFinanceApprover Trigger Logic starts
        if(Trigger.isUpdate || Trigger.isInsert)
        {
            List<AF_OOPS_Actual__c> selectiveActualList = new List<AF_OOPS_Actual__c>();
            for(AF_OOPS_Actual__c afOops:(List<AF_OOPS_Actual__c>)Trigger.new)
            {
                if(afOops.AF_Agency_lk__c != null)
                {
                    selectiveActualList.add(afoops);
                }
                
                if(afOops.AF_Status__c == AF_Constants.CATEGORY_FINANCE){
                    afOopsEstimates.add(afOops);
                }
                
            }
            
            if( !afOopsEstimates.isEmpty() )
            {
                AF_UpdateOopsEstimateCatApproverValues.updateOopsagencyBulk(selectiveActualList);
            }
            
            if( !afOopsEstimates.isEmpty() )
            {
            AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(afOopsEstimates);
            }
        }
        // AF_UpdateCatFinanceApprover Trigger Logic ends
    }
    
    /**
     * bulkAfter
     *
     * This method is called prior to execution of an AFTER trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkAfter()
    {

    }
    
    /**
     * beforeInsert
     *
     * This method is called iteratively for each record to be inserted during a BEFORE
     * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
     */
    public void beforeInsert(SObject so)
    {
        //derived as a part of trigger factory
    }
    
    /**
     * beforeUpdate
     *
     * This method is called iteratively for each record to be updated during a BEFORE
     * trigger.
     */
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        //derived as a part of trigger factory
    }

    /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger.
     */
    public void beforeDelete(SObject so)
    {
     AF_OOPS_Actual__c OOPSActualInstance = (AF_OOPS_Actual__c)so;
        
        // AF_OopsPOreport_Delete Trigger Logic Starts
        OOPSDeleteActualIds.add(OOPSActualInstance.Id);
        // AF_OopsPOreport_Delete Trigger Logic Ends
    }

    /**
     * afterInsert
     *
     * This method is called iteratively for each record inserted during an AFTER
     * trigger. Always put field validation in the 'After' methods in case another trigger
     * has modified any values. The record is 'read only' by this point.
     */
    public void afterInsert(SObject so)
    {
        //derived as a part of trigger factory
    }

    /**
     * afterUpdate
     *
     * This method is called iteratively for each record updated during an AFTER
     * trigger.
     */
    public void afterUpdate(SObject oldSo, SObject so)
    {
        AF_OOPS_Actual__c OOPSActualInstance = (AF_OOPS_Actual__c)so;
        AF_OOPS_Actual__c oldOOPSActualInstance = (AF_OOPS_Actual__c)oldSo;
        
        // AF_AfterUpdateOOPSActual Trigger Logic Starts
        if(oldOOPSActualInstance.Overall__c != OOPSActualInstance.Overall__c && !OOPSActualInstance.AF_iS_OOPS_Percentage__c)
        {               
            recalculateEstimateList.add(OOPSActualInstance);
        }
        // AF_AfterUpdateOOPSActual Trigger Logic Ends      
    }

    /**
     * afterDelete
     *
     * This method is called iteratively for each record deleted during an AFTER
     * trigger.
     */
    public void afterDelete(SObject so)
    {
        //derived as a part of trigger factory
    }

    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {   
     // AF_AfterUpdateOOPSActual Trigger Logic Starts
        if( !recalculateEstimateList.isEmpty() && !AF_RecursiveTriggerHelper.isAlreadyModified())
        {
            AF_OOPSRecordManager OOPSRecordManager = new AF_OOPSRecordManager();
            OOPSRecordManager.bulkOOPSActualList = recalculateEstimateList;
            OOPSRecordManager.bulkRecalculateOOPSEstimates();
        }
        // AF_AfterUpdateOOPSActual Trigger Logic Ends
        // AF_OopsPOreport_Delete Trigger Logic Starts
        if(!OOPSDeleteActualIds.isEmpty())
        {
            try
            {
                List<AF_OOPS_Estimate__c> oopsEstRecordList = [SELECT Id FROM AF_OOPS_Estimate__c WHERE AF_OOPS_Actual__c IN :OOPSDeleteActualIds LIMIT 10000];
                if( !oopsEstRecordList.isEmpty())
                {
                    delete oopsEstRecordList;
                }
            }
            catch(Exception e)
            {
                system.debug(e);
                ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),'AF_OOPS_ActualHandler','andFinally',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            }
        }
        // AF_OopsPOreport_Delete Trigger Logic Ends
    }
}