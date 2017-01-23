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
                //Update external id
                updateExtIdMethod(productList);
            }catch(Exception ex){
                UL_Utility.logError(ex, UserInfo.getUserId());
            }
        }
        /*******************************************************************
        Author: Balakrishna Mandula(balakrishna.mandula@accenture.com)
        Purpose: Handles product before update event 
        Version 1.0
        Parameters: List of Product
        Returns: None
        Throws: None
        Date: 22/01/2017
        ********************************************************************/
         public static void beforeUpdate(Map<Id, ACCL__Product__c> oldProductMap, Map<Id, ACCL__Product__c> newProductMap){
             System.debug('beforeUpdate');
             try{
                 updateExtIdMethod(newProductMap.values());
                 
             }catch(Exception ex){
                UL_Utility.logError(ex, UserInfo.getUserId());
            }
         }
        /*******************************************************************
        Author: Balakrishna Mandula(balakrishna.mandula@accenture.com)
        Purpose: Updates EXternal Id field on Product when it's empty
        Version 1.0
        Parameters: List of Product
        Returns: None
        Throws: None
        Date: 22/01/2017
        ********************************************************************/
        private static void updateExtIdMethod(List<ACCL__Product__c> productList){
            try{
                for(ACCL__Product__c product: productList){
                if(String.isBlank(product.ACCL__ExternalId__c)){
                    product.ACCL__ExternalId__c = product.ACCL__Product_Code__c + '-' + product.UL_Division__c + '-' + product.UL_Distribution_Channel__c;
                }
            }
            }
            catch(Exception ex){
               UL_Utility.logError(ex, UserInfo.getUserId()); 
            }
        }
    }