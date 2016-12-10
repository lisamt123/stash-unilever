/***************************************************************
    Name: UL_ProductTriggerHandler
    Copyright © 2015 Salesforce
    ======================================================
    Purpose:
    Handle Product object trigger events
    ======================================================
    History
    -------
    VERSION     AUTHOR         DATE             DETAIL                 Description
    1.0         Ketan Mehta    24/11/2016       Initial Development    Handles product before insert event
    ***************************************************************/
    public with sharing class UL_ProductTriggerHandler{
        
        /*******************************************************************
        Purpose: Handles product before insert event 
        Version 1.0
        Parameters: List of Product
        Returns: None
        Throws: None
        ********************************************************************/
        public static void beforeInsert(List<ACSFUL001__Product__c> productList){
            try{
                //Update product level in case product sent from Mulesoft system.
                List<UL_PromotionLevelMapping__c> settings = UL_PromotionLevelMapping__c.getall().values();
                if(!settings.isEmpty()){
                    
                    //Create a MAP for lookup
                    Map<String, String> levelMap = new Map<String, String>();
                    for(UL_PromotionLevelMapping__c levelMapping : settings){
                        levelMap.put(levelMapping.ExternalSystemLevel__c+levelMapping.UL_Sales_Org__c, levelMapping.TMPSystemLevel__c);
                    }
                    
                    //Update product level
                    for(ACSFUL001__Product__c product: productList){
                        String key = product.ACSFUL001__Product_Level__c+ UL_Sales_Org_Mapping__c.getValues(product.ACSFUL001__Sales_Org__c).UL_Sales_Org__c;
                        if(levelMap.containsKey(key)){
                             product.ACSFUL001__Product_Level__c = levelMap.get(key);
                        }
                    }
                }
            }catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'UL_ProductTriggerHandler', 'beforeInsert', 
                        'An Error occured on promotion insert', ex, NULL, NULL, NULL, NULL,UL_Utility.APPLICATION_NAME);
            }
        }
    }