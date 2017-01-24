/*************************************************************************************************************************************************************
@ Class:          UL_DeliveryProfile_TriggerHandler
@ Version:        1.0
@ Author:         M Kalyan Goud (mingi.kalyan.goud@accenture.com)
@ Req No's:       TPM-1713
@ Refer Classes:  UL_U
@ Purpose:        Acts as a trigger handler for UL_DeliveryProfile_MasterTrigger
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 04.01.2017 / M Kalyan Goud / Created the class.
**************************************************************************************************************************************************************/

public without sharing class UL_DeliveryProfile_TriggerHandler {
    Private List<UL_Delivery_Profile__c> new_DeliveryProfile_List = new List<UL_Delivery_Profile__c>();
    Private List<UL_Delivery_Profile__c> old_DeliveryProfile_List = new List<UL_Delivery_Profile__c>();
    Private Map<Id, UL_Delivery_Profile__c> new_DeliveryProfile_Map = new Map<Id, UL_Delivery_Profile__c>();
    Private Map<Id, UL_Delivery_Profile__c> old_DeliveryProfile_Map = new Map<Id, UL_Delivery_Profile__c>();
    
    
    
    public UL_DeliveryProfile_TriggerHandler(
        List<UL_Delivery_Profile__c> newTriggerList, List<UL_Delivery_Profile__c> oldTriggerList,
        Map<Id, UL_Delivery_Profile__c> newTriggerMap, Map<Id, UL_Delivery_Profile__c> oldTriggerMap) {
            new_DeliveryProfile_List = newTriggerList;
            old_DeliveryProfile_List = oldTriggerList;
            new_DeliveryProfile_Map =  newTriggerMap; 
            old_DeliveryProfile_Map = oldTriggerMap;
        }
    
/*********************************************************************************************************************************************************
@ Method:      handleBeforeInsert
@ Version:     1.0
@ Author:      M Kalyan Goud (mingi.kalyan.goud@accenture.com)
@ Param paramName:  NULL
@ Return:      NULL
@ Purpose:     Handles the trigger before insert event logic
----------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 04.01.2017 / M Kalyan Goud / Created the method.
**********************************************************************************************************************************************************/    
    public void handleBeforeInsert(){ 
        Set<String> delivery_profile_names = new Set<String>();
        Date lowestDate = System.today();
        Date highestDate = System.today();
        for(UL_Delivery_Profile__c newDeliveryProfile : new_DeliveryProfile_List){
        system.debug('newDeliveryProfile.UL_Delivery_Profile_Name__c ::: '+newDeliveryProfile.UL_Delivery_Profile_Name__c);            
            if(newDeliveryProfile.UL_Sales_Organisation__c.equals(UL_Utility.UK_SO)){
                if(newDeliveryProfile.UL_Valid_From__c < lowestDate){
                    lowestDate = newDeliveryProfile.UL_Valid_From__c;
                }                
                if(newDeliveryProfile.UL_Valid_Thru__c > highestDate){
                    highestDate = newDeliveryProfile.UL_Valid_Thru__c;
                }
                
                delivery_profile_names.add(newDeliveryProfile.UL_Delivery_Profile_Name__c);
            }
                  
            
        }
         
        if(delivery_profile_names.size() > 0){
            deliveryProfileNameValidation(delivery_profile_names, lowestDate, highestDate);
        }
        
    }
    
     
/*********************************************************************************************************************************************************
@ Method:      deliveryProfileNameValidation
@ Version:     1.0
@ Author:      M Kalyan Goud (mingi.kalyan.goud@accenture.com)
@ Param paramName:  NULL
@ Return:      NULL
@Req No:       TPM-1713
@ Purpose:     The validation of uniqueness on Delivery Profile is simply Profile Name and Time Frame.
----------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 04.01.2017 / M Kalyan Goud / Created the method.
**********************************************************************************************************************************************************/ 
    public void deliveryProfileNameValidation(Set<String> delivery_profile_names, Date lowestDate, Date highestDate){
        Map<String, UL_Delivery_Profile__c> checkNames = new Map<String, UL_Delivery_Profile__c>();
        for(UL_Delivery_Profile__c dp : [SELECT Id,Name, UL_Delivery_Profile_Name__c, UL_Valid_From__c, UL_Valid_Thru__c FROM UL_Delivery_Profile__c WHERE UL_Delivery_Profile_Name__c IN :delivery_profile_names AND (UL_Valid_From__c >= :Date.valueOf(lowestDate) OR UL_Valid_Thru__c <= :Date.valueOf(highestDate)) ORDER BY UL_Valid_Thru__c DESC, UL_Valid_From__c DESC]){
            if(checkNames.containsKey(dp.UL_Delivery_Profile_Name__c)){
                if(dp.UL_Valid_From__c > checkNames.get(dp.UL_Delivery_Profile_Name__c).UL_Valid_From__c){
                    checkNames.put(dp.UL_Delivery_Profile_Name__c, dp);
                }                
            } else {
                checkNames.put(dp.UL_Delivery_Profile_Name__c, dp);
            }            
        }
         
        for(UL_Delivery_Profile__c newDeliveryProfile : new_DeliveryProfile_List){
            if(checkNames.containsKey(newDeliveryProfile.UL_Delivery_Profile_Name__c)){
                if(newDeliveryProfile.UL_Valid_From__c < checkNames.get(newDeliveryProfile.UL_Delivery_Profile_Name__c).UL_Valid_Thru__c 
                   || newDeliveryProfile.UL_Valid_Thru__c < checkNames.get(newDeliveryProfile.UL_Delivery_Profile_Name__c).UL_Valid_Thru__c){                        
                    String errMessage =  Label.UL_Duplicate_Record_Found+'--'+checkNames.get(newDeliveryProfile.UL_Delivery_Profile_Name__c).UL_Delivery_Profile_Name__c+':'+checkNames.get(newDeliveryProfile.UL_Delivery_Profile_Name__c).Name;
                    newDeliveryProfile.addError(errMessage);
                }
            }
        }        
    }  
    
}