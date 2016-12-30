/***************************************************************
Name: UL_PromotionInstoreDates()
Copyright © 2015 Salesforce
======================================================
Purpose:
Controller for UL_CreatePromotion apex page.
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Vinod Thupakula    24/10/2016        INITIAL DEV       Promotion trigger helper class.
*****************************************************************/
Public with sharing class UL_PromotionInstoreDates{
    
  public static final String CUSTOM = 'Custom';
 /*******************************************************************
Purpose: this method update the instore dates 
Version: 1.0
Parameters: List,Map,Map
Returns: Void
Throws N/A
********************************************************************/
public static void inStoredatesUpdated(List<ACCL__Promotion__c> newPromotions,
                                        Map<id,ACCL__Promotion__c> oldPromotionsMap,
                                        Map<id,ACCL__Promotion__c> newPromotionsMap){
        boolean isCheckedStoreDate = false;
        try{
                for(ACCL__Promotion_Template__c pTemp:[select id,
                                                                    Calculate_In_store_Dates__c 
                                                                        from 
                                                                    ACCL__Promotion_Template__c  
                                                                        where 
                                                                    id=:newPromotions[0].ACCL__Promotion_Template__c 
                                                                    limit 1]){
                    isCheckedStoreDate  = pTemp.Calculate_In_store_Dates__c ;
                } 
                
                if(isCheckedStoreDate){
                    for (ACCL__Promotion__c obj: newPromotions){                         
                       if((oldPromotionsMap.get(obj.Id).UL_Delivery_Profile__c != 
                                     newPromotionsMap.get(obj.Id).UL_Delivery_Profile__c ||oldPromotionsMap.get(obj.Id).ACCL__Placement_Date_From__c!= 
                                     newPromotionsMap.get(obj.Id).ACCL__Placement_Date_From__c) && obj.UL_Delivery_Profile__c != null && obj.UL_Delivery_Profile__c != UL_Utility.NONE){
                             UL_Delivery_Profile__c uProfile = [SELECT Id, UL_Delivery_Profile_Name__c, Name, UL_Shipment_Start_days__c, UL_Shipment_End_days__c, UL_Instore_End_days__c FROM UL_Delivery_Profile__c where UL_Delivery_Profile_Name__c=:obj.UL_Delivery_Profile__c  limit 1];
                             
                             obj.ACCL__Placement_Date_Thru__c = obj.ACCL__Placement_Date_From__c.addDays(Integer.valueOf(uProfile.UL_Instore_End_days__c));
                                
                             obj.ACCL__Delivery_Date_From__c = obj.ACCL__Placement_Date_From__c.addDays(Integer.valueOf(uProfile.UL_Shipment_Start_days__c));
                             obj.ACCL__Delivery_Date_Thru__c=  obj.ACCL__Placement_Date_From__c.addDays(Integer.valueOf(uProfile.UL_Shipment_End_days__c));

                     
                      }
                      
                      else {
                    	  if(oldPromotionsMap.get(obj.Id).ACCL__Placement_Date_Thru__c != 
                                     newPromotionsMap.get(obj.Id).ACCL__Placement_Date_Thru__c || oldPromotionsMap.get(obj.Id).ACCL__Delivery_Date_From__c != 
                                     newPromotionsMap.get(obj.Id).ACCL__Delivery_Date_From__c ||oldPromotionsMap.get(obj.Id).ACCL__Delivery_Date_Thru__c!= 
                                     newPromotionsMap.get(obj.Id).ACCL__Delivery_Date_Thru__c){
                    		  obj.UL_Delivery_Profile__c = CUSTOM;
                    	  }
                      }
                   }
               }
        }
        catch(Exception Ex){
          	UL_Utility.logError(Ex, UserInfo.getUserId());            
            }
    }
 /*******************************************************************
Purpose: this method update the instore dates 
Version: 1.0
Parameters: List,
Returns: Void
Throws N/A
********************************************************************/
public static void deletePromotion(List<ACCL__Promotion__c> oldPromotions){
    try{
	    for (ACCL__Promotion__c delPromotion : oldPromotions) {
	        if (!UL_Utility.PROMOTIONSTATUS.contains(delPromotion.UL_Current_Status__c) && string.isNotEmpty(delPromotion.UL_Current_Status__c)) {
	            delPromotion.adderror(Label.UL_PromotionDeleteError+ UL_Utility.SPACE + delPromotion.UL_Current_Status__c + UL_Utility.STATUS);
	        }
	      }
    }
    catch(Exception Ex){
            UL_Utility.logError(Ex, UserInfo.getUserId());
    	}
    }
}