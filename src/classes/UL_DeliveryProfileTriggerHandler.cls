/***************************************************************
Name: UL_DeliveryProfileTriggerHandler()
Copyright © 2016 Salesforce
======================================================
Purpose:
Controller for Delivery Profile trigger.
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Vinod Thupakula    05/12/2016        INITIAL DEV       Delivery profile trigger handler.
*****************************************************************/
public with sharing class UL_DeliveryProfileTriggerHandler{

/*******************************************************************
    Purpose: this method 
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws N/A
    ********************************************************************/
public static void checkDuplicateRecords(List<UL_Delivery_Profile__c> deliveryProfiles){
    try{
        Date smallestStartDate = null;
        Date largestEndDate = null;
        Set<Id> customerIds = new Set<Id>();
        Set<Id> productIds= new Set<Id>();
        Set<Integer> instoreDuration = new Set<Integer>();
        Map<String, Set<UL_Delivery_Profile__c>> deliveryProfileMap = new Map<String, Set<UL_Delivery_Profile__c>>();
        
        String errorMessage = System.label.Duplicate_for_Delivery_profile;
         for(UL_Delivery_Profile__c dPro:deliveryProfiles){
             if(smallestStartDate==null){
                    smallestStartDate= dPro.UL_Valid_From__c;
                }
             else {
            	 if(smallestStartDate> dPro.UL_Valid_From__c){
                    smallestStartDate = dPro.UL_Valid_From__c;
                }
             }	 
             if(largestEndDate==null){
                    largestEndDate = dPro.UL_Valid_Thru__c;
                }
             else{ 
            	 if(largestEndDate< dPro.UL_Valid_Thru__c){
                    largestEndDate = dPro.UL_Valid_Thru__c;
                }
             }	 
             if(dPro.UL_Account__c !=  null){
                    customerIds.add(dPro.UL_Account__c);
             }
             if(dPro.UL_Product__c != null){
                    productIds.add(dPro.UL_Product__c);
                }
             if(dPro.UL_Instore_End_days__c != null){
                    instoreDuration.add(Integer.valueOf(dPro.UL_Instore_End_days__c));
                }
                
                if(dPro.id != null){
                    for(UL_Delivery_Profile__c existingProfile :[SELECT Id, UL_Account__c, UL_Product__c, UL_Valid_From__c, UL_Valid_Thru__c, UL_Instore_End_days__c
                                  FROM UL_Delivery_Profile__c
                                  WHERE id !=:dPro.id AND (UL_Product__c IN :productIds OR UL_Account__c IN :customerIds OR UL_Instore_End_days__c IN :instoreDuration
                                  OR (UL_Valid_From__c <= :smallestStartDate AND UL_Valid_Thru__c >= :smallestStartDate) 
                                  OR (UL_Valid_From__c <= :largestEndDate AND UL_Valid_Thru__c >= :largestEndDate ))
                                  limit :(Limits.getLimitQueryRows()-Limits.getQueryRows())]){
                                        String key = String.valueOf(existingProfile.UL_Account__c) + String.valueOf(existingProfile.UL_Product__c) + existingProfile.UL_Instore_End_days__c;
                                        if(!deliveryProfileMap.containsKey(key)){
                                            deliveryProfileMap.put(key, new Set<UL_Delivery_Profile__c>());
                                        }
                                        deliveryProfileMap.get(key).add(existingProfile);
                                  }
                }
                else{
                    for(UL_Delivery_Profile__c existingProfile :[SELECT Id, UL_Account__c, UL_Product__c, UL_Valid_From__c, UL_Valid_Thru__c, UL_Instore_End_days__c
                                  FROM UL_Delivery_Profile__c
                                  WHERE UL_Product__c IN :productIds OR UL_Account__c IN :customerIds OR UL_Instore_End_days__c IN :instoreDuration
                                  OR (UL_Valid_From__c <= :smallestStartDate AND UL_Valid_Thru__c >= :smallestStartDate) 
                                  OR (UL_Valid_From__c <= :largestEndDate AND UL_Valid_Thru__c >= :largestEndDate )
                                   limit :(Limits.getLimitQueryRows()-Limits.getQueryRows())]){
                                   String key = String.valueOf(existingProfile.UL_Account__c) + String.valueOf(existingProfile.UL_Product__c) + existingProfile.UL_Instore_End_days__c;
                                        if(!deliveryProfileMap.containsKey(key)){
                                            deliveryProfileMap.put(key, new Set<UL_Delivery_Profile__c>());
                                        }
                                        deliveryProfileMap.get(key).add(existingProfile);
                                   
                       }
                }            
         }
         
         //Validation
            for(UL_Delivery_Profile__c  dProfile: deliveryProfiles){
                String key = String.valueOf(dProfile.UL_Account__c) + String.valueOf(dProfile.UL_Product__c) + dProfile.UL_Instore_End_days__c;
                //Checking if Map contains the Key
                if(deliveryProfileMap.containsKey(key)){
                    for(UL_Delivery_Profile__c existingProfile : deliveryProfileMap.get(key)){
                        if(existingProfile.Id!= dProfile.Id && existingProfile.UL_Valid_From__c <= dProfile.UL_Valid_Thru__c && existingProfile.UL_Valid_Thru__c >= dProfile.UL_Valid_From__c){
                            dProfile.addError(errorMessage);
                        }
                    }
                }
                else{
                    deliveryProfileMap.put(key, new Set<UL_Delivery_Profile__c >());
                }
                deliveryProfileMap.get(key).add(dProfile);
            }
    }
    catch(Exception ex){
            UL_Utility.logError(Ex, UserInfo.getUserId());
    }
}
}