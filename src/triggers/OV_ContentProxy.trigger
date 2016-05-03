/**********************************************************************
Name: OV_ContentProxy
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Trigger OV_ContentProxy object
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             25/05/2015      INITIAL DEVELOPMENT
**********************************************************************/
trigger OV_ContentProxy on OV_ContentProxy__c (after delete, after insert, after update, before delete, before insert, before update, after undelete) {
    /*
    if (Trigger.isAfter && Trigger.isUpdate){
        OV_TriggerHandler handler = new OV_TriggerHandler();        
        handler.handleNewVersionOfReport(Trigger.new, Trigger.old);
    }
    */

    
    OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
    
    if(triggerSwitchCustomSetting != null && triggerSwitchCustomSetting.ContentProxy__c){
    	OV_TriggerFactory.createHandler(OV_ContentProxy__c.sObjectType);
    }
}