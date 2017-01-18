/*************************************************************************************************************************************************************
@ Trigger:        UL_DeliveryProfile_MasterTrigger  
@ Version:        1.0
@ Author:         M Kalyan Goud (mingi.kalyan.goud@accenture.com)
@ Req No:   
@ Refer Classes:  UL_DeliveryProfile_TriggerHandler
@ Purpose:        Acts as a master trigger with all events for UL_Delivery_Profile__c object
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 04.01.2017 / M Kalyan Goud / Created the Trigger.
**************************************************************************************************************************************************************/
trigger UL_DeliveryProfile_MasterTrigger on UL_Delivery_Profile__c (
    before insert, after insert,
    before update, after update,
    before delete, after delete) {
        
        public static final string STRING_UL_DELIVERYPROFILE_MASTERTRIGGER_BEFORE = 'UL_DeliveryProfile_MasterTrigger - Before';
        public static final string STRING_UL_DELIVERYPROFILE_MASTERTRIGGER_AFTER = 'UL_DeliveryProfile_MasterTrigger - After';
        
        UL_DeliveryProfile_TriggerHandler handleDeliveryProfileEvents;
        if(!System.isBatch()){
            if(Trigger.isBefore && !UL_GlobalTriggerMonitor_Class.executedTriggers.contains(STRING_UL_DELIVERYPROFILE_MASTERTRIGGER_BEFORE)){
                UL_GlobalTriggerMonitor_Class.executedTriggers.add(STRING_UL_DELIVERYPROFILE_MASTERTRIGGER_BEFORE);
                if(Trigger.isInsert){
                    handleDeliveryProfileEvents = new UL_DeliveryProfile_TriggerHandler(Trigger.new, NULL, NULL, NULL);
                    handleDeliveryProfileEvents.handleBeforeInsert();
                }
                if(Trigger.isUpdate){
                    handleDeliveryProfileEvents = new UL_DeliveryProfile_TriggerHandler(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
                    handleDeliveryProfileEvents.handleBeforeUpdate();
                }
                if(Trigger.isDelete){
                    
                }
            }
            if(Trigger.isAfter && !UL_GlobalTriggerMonitor_Class.executedTriggers.contains(STRING_UL_DELIVERYPROFILE_MASTERTRIGGER_AFTER)){
                UL_GlobalTriggerMonitor_Class.executedTriggers.add(STRING_UL_DELIVERYPROFILE_MASTERTRIGGER_AFTER);
                if(Trigger.isInsert){
                    handleDeliveryProfileEvents = new UL_DeliveryProfile_TriggerHandler(Trigger.New, NULL, Trigger.NewMap, NULL);
                    handleDeliveryProfileEvents.handleAfterInsert();
                }
                if(Trigger.isUpdate){
                    handleDeliveryProfileEvents = new UL_DeliveryProfile_TriggerHandler(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
                    handleDeliveryProfileEvents.handleAfterUpdate();
                }
                if(Trigger.isDelete){
                    handleDeliveryProfileEvents = new UL_DeliveryProfile_TriggerHandler(NULL, Trigger.old, NULL, Trigger.oldMap);
                    handleDeliveryProfileEvents.handleAfterDelete();
                }
            }
        }        
    }