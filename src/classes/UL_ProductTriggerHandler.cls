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
        public static void beforeInsert(List<ACCL__Product__c> productList){
            try{
                //Update product level in case product sent from Mulesoft system.
                List<UL_ProductLevelMapping__c> settings = UL_ProductLevelMapping__c.getall().values();
                if(!settings.isEmpty()){
                    
                    //Create a MAP for lookup
                    Map<String, String> levelMap = new Map<String, String>();
                    for(UL_ProductLevelMapping__c levelMapping : settings){
                        levelMap.put(levelMapping.External_System_Value__c+levelMapping.Sales_Org__c, levelMapping.TMP_System_Value__c);
                    }
                    
                    //Update product level
                    for(ACCL__Product__c product: productList){
                        String key = product.ACCL__Product_Level__c + 
                        		     UL_Sales_Org_Mapping__c.getValues(product.ACCL__Sales_Org__c).UL_Sales_Org__c;
                        if(levelMap.containsKey(key)){
                             product.ACCL__Product_Level__c = levelMap.get(key);
                        }
                    }
                }
            }catch(Exception ex){
                UL_Utility.logError(ex, UserInfo.getUserId());
            }
        }
    }