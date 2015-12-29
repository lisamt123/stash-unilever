/******************************************** 
*@Author:Cognizant
*@Date:December 2015
*@Description : Handler class for AF_PO_Report__c 
*********************************************/
public with sharing class AF_PO_ReportHandler implements ITrigger
{
    set<String> compundKeySet = new set<String>();
    Map<String,String> compundKeyReportType = new Map<String,String>();
    public void bulkBefore()
    {
    }
    /**
    * bulkAfter
    *
    * This method is called prior to execution of an AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter()
    {
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            if(AF_checkRecursivePOReport.run)
            { 
                List<AF_PO_Report__c> POReportInstance = (List<AF_PO_Report__c>)trigger.new;
                for(AF_PO_Report__c  poReport : POReportInstance)
                {
                    compundKeyReportType.put(poReport.AF_Compound_Key__c,poReport.AF_PO_Report_Type__c);
                    compundKeySet.add(poReport.AF_Compound_Key__c);
                }
                AF_checkRecursivePOReport.run=false;
            }            
        }
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
        // AF_POreport_Delete Trigger logic Starts
        // AF_POreport_Delete Trigger logic ends
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
        if(compundKeySet.size()>0)
        {
            AF_GetBaseFeePOData.CalculatePoReportValues(compundKeyReportType,compundKeySet);
        }  
    }
}