/***************************************************************
    Name: UL_DeliveryProfile_MasterTrigger
    Copyright: Accenture
    ======================================================
    Purpose:
    Trigger on DeliveryProfile Object
    ======================================================
    History
    -------
    VERSION     AUTHOR         DATE             DETAIL                 Description
    1.0         M Kalyan Goud  04.01.2017       Initial Development    Handles DeliveryProfile before/after insert/update/delete events
    ***************************************************************/

    trigger UL_DeliveryProfile_MasterTrigger on UL_Delivery_Profile__c (
        before insert, after insert,
        before update, after update,
        before delete, after delete) {
        
        public static final string STRING_UL_DELIVERYPROFILE_MASTERTRIGGER_BEFORE = 'UL_DeliveryProfile_MasterTrigger - Before';
        public static final string STRING_UL_DELIVERYPROFILE_MASTERTRIGGER_AFTER = 'UL_DeliveryProfile_MasterTrigger - After';
                
            if(UL_Utility.IS_DELIVERY_PROFILE_TRIGGER_ENABLED){
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
                            
                        }
                        if(Trigger.isDelete){
                            
                        }
                    }
                    
                    if(Trigger.isAfter && !UL_GlobalTriggerMonitor_Class.executedTriggers.contains(STRING_UL_DELIVERYPROFILE_MASTERTRIGGER_AFTER)){
                        UL_GlobalTriggerMonitor_Class.executedTriggers.add(STRING_UL_DELIVERYPROFILE_MASTERTRIGGER_AFTER);
                        if(Trigger.isInsert){
                            handleDeliveryProfileEvents = new UL_DeliveryProfile_TriggerHandler(Trigger.New, NULL, Trigger.NewMap, NULL);
                             
                        }
                        if(Trigger.isUpdate){
                            handleDeliveryProfileEvents = new UL_DeliveryProfile_TriggerHandler(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
                            
                        }
                        if(Trigger.isDelete){
                            handleDeliveryProfileEvents = new UL_DeliveryProfile_TriggerHandler(NULL, Trigger.old, NULL, Trigger.oldMap);
                             
                        }
                    }
                } 
            }       
    }