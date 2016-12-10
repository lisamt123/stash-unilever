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
            Date smallestFromDate;
            Date largestThruDate;
            Set<Id> customerIdSet = new Set<Id>();
            Set<Id> productIdSet = new Set<Id>();
            List<UL_Cannibalisation_Rate__c> existingRecordList = new List<UL_Cannibalisation_Rate__c>();
            Map<String, Set<UL_Cannibalisation_Rate__c>> cannibalisationRateMap = new Map<String, Set<UL_Cannibalisation_Rate__c>>();
            String errorMessage = 'Dates are overlapping with existing records for same product/customer combination';
            
            //Searching smallest start date and largest thru date to limit number of existing records queried
            for(UL_Cannibalisation_Rate__c rate : cannibalisationRateList){
                //finding smallest From Date
                if(smallestFromDate==null){
                    smallestFromDate = rate.UL_Valid_From__c;
                }
                else if(smallestFromDate > rate.UL_Valid_From__c){
                    smallestFromDate = rate.UL_Valid_From__c;
                }
                
                //Finding largest Thru Date
                if(largestThruDate==null){
                    largestThruDate = rate.UL_Valid_Thru__c;
                }
                else if(largestThruDate < rate.UL_Valid_Thru__c){
                    largestThruDate = rate.UL_Valid_Thru__c;
                }
                if(rate.UL_Customer__c!=null){
                    customerIdSet.add(rate.UL_Customer__c);
                }
                if(rate.UL_Product__c!=null){
                    productIdSet.add(rate.UL_Product__c);
                }
            }
            
            //Querying the existing records for validation
            existingRecordList = [SELECT Id, UL_Customer__c, UL_Product__c, UL_Valid_From__c, UL_Valid_Thru__c
                                  FROM UL_Cannibalisation_Rate__c 
                                  WHERE UL_Product__c IN :productIdSet AND UL_Customer__c IN :customerIdSet
                                  AND ((UL_Valid_From__c <= :smallestFromDate AND UL_Valid_Thru__c >= :smallestFromDate) 
                                       OR (UL_Valid_From__c <= :largestThruDate AND UL_Valid_Thru__c >= :largestThruDate)
                                      )];
            
            //Creating Map
            for(UL_Cannibalisation_Rate__c existingRate : existingRecordList){
                String key = String.valueOf(existingRate.UL_Customer__c) + String.valueOf(existingRate.UL_Product__c);
                if(!cannibalisationRateMap.containsKey(key)){
                    cannibalisationRateMap.put(key, new Set<UL_Cannibalisation_Rate__c>());
                }
                cannibalisationRateMap.get(key).add(existingRate);
            }
            
            //Validation
            for(UL_Cannibalisation_Rate__c rate : cannibalisationRateList){
                if(rate.UL_Customer__c!=null && rate .UL_Product__c!=null){
                    String key = String.valueOf(rate.UL_Customer__c) + String.valueOf(rate .UL_Product__c);
                    //Checking if Map contains the Key
                    if(cannibalisationRateMap.containsKey(key)){
                        for(UL_Cannibalisation_Rate__c existingRate : cannibalisationRateMap.get(key)){
                            if(existingRate.UL_Valid_From__c <= rate.UL_Valid_Thru__c && existingRate.UL_Valid_Thru__c >= rate.UL_Valid_From__c){
                                rate.addError(errorMessage);
                            }
                        }
                    }
                    else{
                        cannibalisationRateMap.put(key, new Set<UL_Cannibalisation_Rate__c>());
                    }
                    cannibalisationRateMap.get(key).add(rate);
                }
            }
        }catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'UL_CannibalisationRateTriggerHandler', 'beforeInsert', 
                                                  'An Error occured on Cannibalisation Rate insert', ex, NULL, NULL, NULL, NULL,UL_Utility.APPLICATION_NAME);
        }
    }
}