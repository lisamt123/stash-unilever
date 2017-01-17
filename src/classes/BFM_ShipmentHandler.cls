public class BFM_ShipmentHandler implements ITrigger {
    private Map<Id,BFM_Shipment__c> oldMap;
    private Map<Id, BFM_Shipment__c> newMap;
    private RecordType unileverAccount;

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore() {   
        oldMap = (Map<Id, BFM_Shipment__c>)trigger.oldMap;
        newMap = (Map<Id, BFM_Shipment__c>)trigger.newMap;   
        unileverAccount  = [SELECT id from RecordType where DeveloperName = 'BFM_Unilever_Account'];
    }
    
    public void bulkAfter() {}
    
    public void beforeInsert(SObject so) {
        BFM_Shipment__c shipmentNew = newMap.get(so.Id);
        defineUnileverAccount(shipmentNew);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
        BFM_Shipment__c shipmentOld = oldMap.get(oldSo.Id);
        BFM_Shipment__c shipmentNew = newMap.get(so.Id);
        
        if(!shipmentOld.X6th_flag__c  && shipmentNew.X6th_flag__c && !System.isBatch()){
            shipmentNew.Shipment_Start__c = System.today();
            BFM_UpdateFreightData.send6thFlagUpdate(shipmentOld.Id);
        } else if(shipmentOld.X6th_flag__c && !shipmentNew.X6th_flag__c) {
            shipmentNew.Shipment_Start__c = null;
        }
        
        defineUnileverAccount(shipmentNew);
        checkIfNeedsToBeDeleted(shipmentNew);
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
    
    public void defineUnileverAccount(BFM_Shipment__c shipmentNew) {
        for(Account acc : [SELECT company_code__c,Plant_Code__c, id from Account where RecordType.id =: unileverAccount.id]){ 
            shipmentNew.Unilever_Company__c = acc.Id;
        }
    }
    
    public void checkIfNeedsToBeDeleted(BFM_Shipment__c shipmentNew) {
        Set<Id> deleteRecords = new Set<Id>();
        if(shipmentNew.Is_Deleted_in_SAP__c) {
            deleteRecords.add(shipmentNew.id);
        }
        
        System.debug('deleteRecords' + deleteRecords);
        if(deleteRecords.size() > 0) {
            deleteRecords(deleteRecords);
        }
    }
    
    @future
     public static void deleteRecords(Set<Id> objectsIdsToDelete) {
        delete [Select Id from BFM_Shipment__c where Id in : objectsIdsToDelete];
    }
}