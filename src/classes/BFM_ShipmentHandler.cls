public class BFM_ShipmentHandler implements ITrigger {
    private Map<Id,BFM_Shipment__c> oldMap;
    private Map<Id, BFM_Shipment__c> newMap;

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore() {   
        oldMap = (Map<Id, BFM_Shipment__c>)trigger.oldMap;
        newMap = (Map<Id, BFM_Shipment__c>)trigger.newMap;
    }
    
    public void bulkAfter() { 
    }
    
    public void beforeInsert(SObject so) {
    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
        BFM_Shipment__c shipmentOld = oldMap.get(oldSo.Id);
        BFM_Shipment__c shipmentNew = newMap.get(so.Id);
        system.debug('BFM_ShipmentHandler beforeUpdate shipmentNew.Vehicle_Plate__c '+ shipmentNew.Vehicle_Plate__c);
        if(shipmentOld.Vehicle_Plate__c != shipmentNew.Vehicle_Plate__c ){
            BFM_UpdateFreightData.sendUpdateShipmentRequestFuture(shipmentOld.Id);
        }
        if(shipmentOld.X6th_flag__c == false && shipmentNew.X6th_flag__c == true && !System.isBatch()){
            shipmentNew.Shipment_Start__c = System.today();
            BFM_UpdateFreightData.send6thFlagUpdate(shipmentOld.Id);
        } else if(shipmentOld.X6th_flag__c == true && shipmentNew.X6th_flag__c == false) {
            shipmentNew.Shipment_Start__c = null;
        }
    }
    

    public void beforeDelete(SObject so){}
    
    public void afterInsert(SObject so) {}
    
    public void afterUpdate(SObject oldSo, SObject so){}
    
    public void afterDelete(SObject so){}
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally() {}
    
}