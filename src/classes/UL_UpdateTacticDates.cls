public with sharing class UL_UpdateTacticDates{ 
    @InvocableMethod(Label = 'UpdateTacticDates')
    public static void UpdateTacticDISODates(List<ACSFUL001__Tactic__c> newTactic){
        List<ACSFUL001__Tactic__c> tacticRecords = new List<ACSFUL001__Tactic__c>();
        list<ACSFUL001__Promotion__c> PromotionData =[SELECT Id, 
                                                    ACSFUL001__Date_From__c,
                                                    ACSFUL001__Date_Thru__c,
                                                    ACSFUL001__Delivery_Date_From__c,
                                                    ACSFUL001__Delivery_Date_Thru__c,
                                                    ACSFUL001__Order_Date_From__c,
                                                    ACSFUL001__Order_Date_Thru__c,
                                                    ACSFUL001__Placement_Date_From__c,
                                                    ACSFUL001__Placement_Date_Thru__c 
                                                    FROM ACSFUL001__Promotion__c where id =:newTactic[0].ACSFUL001__Promotion__c];
                                                    system.debug('--15---'+PromotionData);
           if(!PromotionData.isEmpty()){
               for(ACSFUL001__Tactic__c tData:[select id from ACSFUL001__Tactic__c where id=:newTactic[0].id]){
                        tData.ACSFUL001__Date_From__c = PromotionData[0].ACSFUL001__Date_From__c;
                        tData.ACSFUL001__Date_Thru__c = PromotionData[0].ACSFUL001__Date_Thru__c;
                        tData.ACSFUL001__Shipment_Date_From__c = PromotionData[0].ACSFUL001__Delivery_Date_From__c;
                        tData.ACSFUL001__Shipment_Date_Thru__c = PromotionData[0].ACSFUL001__Delivery_Date_Thru__c;
                        tData.UL_Order_Date_From__c = PromotionData[0].ACSFUL001__Order_Date_From__c;
                        tData.UL_Order_Date_Thru__c = PromotionData[0].ACSFUL001__Order_Date_Thru__c;
                        tData.ACSFUL001__Instore_Date_From__c = PromotionData[0].ACSFUL001__Placement_Date_From__c;
                        tData.ACSFUL001__Instore_Date_Thru__c = PromotionData[0].ACSFUL001__Placement_Date_Thru__c;  
                        tacticRecords.add(tData);                                           
                    }
                    Database.update(tacticRecords);
                    system.debug('--29---'+tacticRecords);
           }
        
    }
}