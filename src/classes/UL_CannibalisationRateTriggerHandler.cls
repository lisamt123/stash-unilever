/***************************************************************
Name: UL_CannibalisationRateTriggerHandler
Copyright © 2015 Salesforce
======================================================
Purpose:
Handle Canniblisation Rate object trigger events
======================================================
History
-------
VERSION     AUTHOR         DATE             DETAIL                 Description
1.0         Omkar Narkar    29/11/2016       Initial Development    Handles Cannibalisation Rate before insert event
***************************************************************/
public with sharing class UL_CannibalisationRateTriggerHandler{
    
    /*******************************************************************
    Purpose: Handles Cannibalisation Rate before insert event 
    Version 1.0
    Parameters: List of Product
    Returns: NoneUL_Valid_From__c
    Throws: None
    ********************************************************************/
    public static void beforeInsert(List<UL_Cannibalisation_Rate__c> cannibalisationRateList){
        try{
            Date smallestFromDate = UL_Utility.NULL_DATE;
            Date largestThruDate = UL_Utility.NULL_DATE;
            Set<Id> customerIdSet = new Set<Id>();
            Set<Id> productIdSet = new Set<Id>();
            Set<String> featureSet = new Set<String>();
            Map<String, Set<UL_Cannibalisation_Rate__c>> cannibalisationRateMap = new Map<String, Set<UL_Cannibalisation_Rate__c>>();
            String errorMessage = System.Label.UL_Cannibalisation_Error;
            //Sprint 5
            ACCL__Product__c allProducts = UL_Utility.returnGenericProduct();
            UL_Planning_Level__c allAccounts = UL_Utility.returnGenericCustomer();
            
            //Searching smallest start date and largest thru date to limit number of existing records queried
            for(UL_Cannibalisation_Rate__c rate : cannibalisationRateList){
                //Populating Customer
                if(rate.UL_Customer_ID__c!=UL_Utility.NULL_ID){
                    rate.UL_Customer__c = (Id)rate.UL_Customer_ID__c;
                }
                
                //finding smallest From Date
                if(smallestFromDate==UL_Utility.NULL_DATE){
                    smallestFromDate = rate.UL_Valid_From__c;
                }
                else if(smallestFromDate > rate.UL_Valid_From__c){
                    smallestFromDate = rate.UL_Valid_From__c;
                }
                
                //Finding largest Thru Date
                if(largestThruDate==UL_Utility.NULL_DATE){
                    largestThruDate = rate.UL_Valid_Thru__c;
                }
                else if(largestThruDate < rate.UL_Valid_Thru__c){
                    largestThruDate = rate.UL_Valid_Thru__c;
                }
                if(rate.UL_Customer__c==UL_Utility.NULL_ID){
                   rate.UL_Customer__c = allAccounts.UL_Customer__c; 
                }
                customerIdSet.add(rate.UL_Customer__c);
                if(rate.UL_Product__c==UL_Utility.NULL_ID){
                    rate.UL_Product__c = allProducts.Id;
                }
                productIdSet.add(rate.UL_Product__c);
                if(rate.UL_Feature__c!=UL_Utility.NULL_VALUE){
                    featureSet.add(rate.UL_Feature__c);
                }
            }
            
            //Querying the existing records for validation & Creating Map
            for(UL_Cannibalisation_Rate__c existingRate : [SELECT Id, UL_Customer__c, UL_Product__c, UL_Valid_From__c, UL_Valid_Thru__c, UL_Feature__c
                                  FROM UL_Cannibalisation_Rate__c 
                                  WHERE UL_Product__c IN :productIdSet OR UL_Customer__c IN :customerIdSet OR UL_Feature__c IN :featureSet
                                  OR (UL_Valid_From__c <= :smallestFromDate AND UL_Valid_Thru__c >= :smallestFromDate) 
                                  OR (UL_Valid_From__c <= :largestThruDate AND UL_Valid_Thru__c >= :largestThruDate)
                                  LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())]){
                String key = String.valueOf(existingRate.UL_Customer__c) + String.valueOf(existingRate.UL_Product__c) + existingRate.UL_Feature__c;
                if(!cannibalisationRateMap.containsKey(key)){
                    cannibalisationRateMap.put(key, new Set<UL_Cannibalisation_Rate__c>());
                }
                cannibalisationRateMap.get(key).add(existingRate);
            }
            
            //Validation
            for(UL_Cannibalisation_Rate__c rate : cannibalisationRateList){
                String key = String.valueOf(rate.UL_Customer__c) + String.valueOf(rate .UL_Product__c) + rate.UL_Feature__c;
                //Checking if Map contains the Key
                if(cannibalisationRateMap.containsKey(key)){
                    for(UL_Cannibalisation_Rate__c existingRate : cannibalisationRateMap.get(key)){
                        if(existingRate.Id!= rate.Id && existingRate.UL_Valid_From__c <= rate.UL_Valid_Thru__c && existingRate.UL_Valid_Thru__c >= rate.UL_Valid_From__c){
                            rate.addError(errorMessage);
                        }
                    }
                }
                else{
                    cannibalisationRateMap.put(key, new Set<UL_Cannibalisation_Rate__c>());
                }
                cannibalisationRateMap.get(key).add(rate);
            }
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
}