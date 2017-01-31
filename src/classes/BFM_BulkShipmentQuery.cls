global class BFM_BulkShipmentQuery implements Database.Batchable<sObject>, Database.Stateful , Database.AllowsCallouts{
    
    private Set<String> shipmentIds;
    global List<BFM_Shipment__c> rshipmentIdList = new List<BFM_Shipment__c>();
    
    public BFM_BulkShipmentQuery(Set<String> shipmentIdList) {
        shipmentIds = shipmentIdList;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Shipment_Number__c, LastModifiedDate, Last_Shipment_Update__c FROM BFM_Shipment__c WHERE Shipment_Number__c IN :shipmentIds';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<BFM_Shipment__c> scope) {
        Set<string> shipIds = new Set<String>();
        for(BFM_Shipment__c bfms:scope) {
            shipIds.add(bfms.Shipment_Number__c);
            rshipmentIdList.add(bfms);
        }
        
        BFM_QueryFreights queryFreights = new BFM_QueryFreights(shipIds);
        
        String returnMessage = 'Documento de Transporte atualizado';
        try {
            queryFreights.callQueryFreightsCTeIssuing();
            if(!queryFreights.isSuccess()){
                returnMessage = queryFreights.getErrorMessage();
            }
        } catch(Exception ex){
            returnMessage =  ex.getMEssage() + ' '+ex.getStackTraceString();
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
        
        /*if(rshipmentIdList.size()>0) {
            List<BFM_Shipment__c> uShiplList = new List<BFM_Shipment__c>();
            for(BFM_Shipment__c bfs:rshipmentIdList) {
                BFM_Shipment__c ship = new BFM_Shipment__c();
                ship.Id = bfs.id;
                ship.Last_Shipment_Update__c = system.now(); 
                uShiplList.add(ship);
            }
            
            if(uShiplList.size()>0)
                update uShiplList;
        }*/
    }
}