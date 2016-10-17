public class BFM_UpdateFreightData {
    
    private BFM_Shipment__c theShipment;
    private BFM_Occurrence__c theOccurrence;
    private String shipOrOccNumber;
    
    @future(callout=true)
    public static void sendUpdateShipmentRequestFuture(Id shipmentOrOccurrenceId){
        new BFM_UpdateFreightData(shipmentOrOccurrenceId).sendUpdateShipmentRequest();
    }
    
    public BFM_UpdateFreightData(Id shipmentOrOccurrenceId){
        
        if(shipmentOrOccurrenceId.getSobjectType().getDescribe() == Schema.sObjectType.BFM_Shipment__c){
    		theShipment = [SELECT Vehicle_Plate__c, Shipment_Number__c FROM BFM_Shipment__c WHERE Id =:shipmentOrOccurrenceID LIMIT 1];
            shipOrOccNumber = theShipment.Shipment_Number__c;
        } else if(shipmentOrOccurrenceId.getSobjectType().getDescribe() == Schema.sObjectType.BFM_Shipment__c){
            theOccurrence = [SELECT Plate_Number__c FROM BFM_Occurrence__c where Id =:shipmentOrOccurrenceId LIMIT 1];
            shipOrOccNumber = theOccurrence.Occurrence_Number__c;
        }
        
    }
    
    public void sendUpdateShipmentRequest(){
        String plateNumber;
        BFM_UpdateFreightDataRequest request;
        if(theShipment != null){
            plateNumber = theShipment.Vehicle_Plate__c;
            BFM_GeneralServiceCalls.sendShipmentOccurrenceUpdate(plateNumber, shipOrOccNumber, null);
        } else if(theOccurrence != null){
        	plateNumber = theoccurrence.Plate_Number__c;      
            BFM_GeneralServiceCalls.sendShipmentOccurrenceUpdate(plateNumber, null, shipOrOccNumber);
        }
        
        
    }

}