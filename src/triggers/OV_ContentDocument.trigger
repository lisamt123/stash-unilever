/**********************************************************************
Name: OV_ContentDocument
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Trigger OV_ContentDocument object
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             24/07/2015      INITIAL DEVELOPMENT
**********************************************************************/
trigger OV_ContentDocument on ContentDocument (after delete, after insert, after update, before delete, before insert, before update, after undelete) {
    OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
    
    if(triggerSwitchCustomSetting != null && triggerSwitchCustomSetting.ContentDocument__c){
    	OV_TriggerFactory.createHandler(ContentDocument.sObjectType);
    }
}