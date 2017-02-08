/**
 * Class name : BFM_ShipmentHandlerActions 
 * Description : Handle all shipment trigger business rules
 * Developer : Lucas Oliveira
 * Date : 01/24/2017
 */
public class BFM_ShipmentHandlerActions {
    /**
     * Method name : defineShipmentUnileverAccount 
     * Description : Define Unilever Account for Shipment
     * Date : 01/24/2017
     */
    public static void defineShipmentUnileverAccount(List<BFM_Shipment__c> shipmentNewLst) {
        RecordType unileverAccount  = [SELECT id from RecordType where DeveloperName = 'Unilever_Account' Limit 1];
        List<Account> acc = [SELECT id from Account where RecordType.id =: unileverAccount.id];
        for(BFM_Shipment__c item : shipmentNewLst){
            item.Unilever_Company__c = acc.get(0).Id;
        }
    }
    
     /**
     * Method name : checkIfNeedsToBeDeleted 
     * Description : Checks if is Deleted Flag is true (Sent by SAP) in order to delete the record
     * Date : 01/24/2017
     */
    public static void checkIfNeedsToBeDeleted(List<BFM_Shipment__c> shipmentNewLst) {
        Set<Id> deleteRecords = new Set<Id>();
        for(BFM_Shipment__c shipmentNew : shipmentNewLst) {
            if(shipmentNew.Is_Deleted_in_SAP__c) {
                deleteRecords.add(shipmentNew.id);
            }
        }
        
        if(deleteRecords.size() > 0) {
            deleteRecords(deleteRecords);
        }
    }
    
     /**
     * Method name : send6thflag 
     * Description : If 6th flag is true, send it to SAP
     * Date : 01/24/2017
     */
    public static void send6thflag(BFM_Shipment__c shipmentNew) {  
        List<BFM_NF_e__c> nfeList = [SELECT id, Shipment__c from BFM_NF_e__c where Shipment__c =: shipmentNew.id];
        if(nfeList.size() > 0) {
            shipmentNew.X6th_flag_Updated_Date__c = System.today();
            BFM_UpdateFreightData.send6thFlagUpdate(shipmentNew.Id);
        } else {
            shipmentNew.addError(Label.BFM_Error_Setting_6thflag);
        }
    }
    
    @future
    public static void deleteRecords(Set<Id> objectsIdsToDelete) {
        delete [Select Id from BFM_Shipment__c where Id in : objectsIdsToDelete];
    }
}