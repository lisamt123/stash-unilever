public with sharing class UL_UpdateTacticDates{ 
    @InvocableMethod(Label = 'UpdateTacticDates')
    public static void UpdateTacticDISODates(List<ACCL__Tactic__c> newTactic){
        List<ACCL__Tactic__c> tacticRecords = new List<ACCL__Tactic__c>();
        list<ACCL__Promotion__c> PromotionData =[SELECT Id, 
                                                    ACCL__Date_From__c,
                                                    ACCL__Date_Thru__c,
                                                    ACCL__Delivery_Date_From__c,
                                                    ACCL__Delivery_Date_Thru__c,
                                                    ACCL__Order_Date_From__c,
                                                    ACCL__Order_Date_Thru__c,
                                                    ACCL__Placement_Date_From__c,
                                                    ACCL__Placement_Date_Thru__c 
                                                    FROM ACCL__Promotion__c where id =:newTactic[0].ACCL__Promotion__c];
                                                    system.debug('--15---'+PromotionData);
           if(!PromotionData.isEmpty()){
               for(ACCL__Tactic__c tData:[select id from ACCL__Tactic__c where id=:newTactic[0].id]){
                        tData.ACCL__Date_From__c = PromotionData[0].ACCL__Date_From__c;
                        tData.ACCL__Date_Thru__c = PromotionData[0].ACCL__Date_Thru__c;
                        tData.ACCL__Shipment_Date_From__c = PromotionData[0].ACCL__Delivery_Date_From__c;
                        tData.ACCL__Shipment_Date_Thru__c = PromotionData[0].ACCL__Delivery_Date_Thru__c;
                        tData.UL_Order_Date_From__c = PromotionData[0].ACCL__Order_Date_From__c;
                        tData.UL_Order_Date_Thru__c = PromotionData[0].ACCL__Order_Date_Thru__c;
                        tData.ACCL__Instore_Date_From__c = PromotionData[0].ACCL__Placement_Date_From__c;
                        tData.ACCL__Instore_Date_Thru__c = PromotionData[0].ACCL__Placement_Date_Thru__c;  
                        tacticRecords.add(tData);                                           
                    }
                    Database.update(tacticRecords);
                    system.debug('--29---'+tacticRecords);
           }
        
    }
}