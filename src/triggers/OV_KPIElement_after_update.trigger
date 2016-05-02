/**********************************************************************
Name: OV_KPIElement_after_update
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Trigger OV_KPIElement_after_update object
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             25/05/2015      INITIAL DEVELOPMENT
**********************************************************************/
trigger OV_KPIElement_after_update on OV_KPI_Element__c (after delete, after insert, after update, before delete, before insert, before update, after undelete) {
	/*
    if (Trigger.isAfter && Trigger.isUpdate){
        OV_TriggerHandler handler = new OV_TriggerHandler();        
        handler.handleKPIElementAfterUpdates(Trigger.new,Trigger.old);
    }
    */
    OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
    
    if(triggerSwitchCustomSetting != null && triggerSwitchCustomSetting.KPIElement__c){
    	OV_TriggerFactory.createHandler(OV_KPI_Element__c.sObjectType);
    }
    
}