/***************************************************************
    Name: UL_Product_Part_Trigger
    Copyright: Accenture
    ======================================================
    Purpose:
    Trigger on ProductPart Object
    ======================================================
    History
    -------
    VERSION     AUTHOR         DATE             DETAIL                 Description
    1.0         Chandra Reddy  19/10/2016       Initial Development    Handles ProductPart before insert, before update, after insert events
    ***************************************************************/  
    trigger UL_Product_Part_Trigger on ACCL__Product_Part__c (before insert, before update, after insert) {
            if(UL_Utility.IS_PRODUCTPART_TRIGGER_ENABLED){
            if(trigger.isBefore){
                if(trigger.isInsert){
                    UL_ProductPartTriggerUtil.UpdateCUQuantity(trigger.new);
                }
                if(trigger.isUpdate){
                    UL_ProductPartTriggerUtil.UpdateCUQuantity(trigger.new);        
                }
            }
            if(trigger.isAfter){
                if(trigger.isInsert){
                    UL_ProductTypeHandler.updateProductType(trigger.new);
                }
            }  
        }  
    }