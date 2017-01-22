public class BFM_UpdateFreightData {
    
    private BFM_Shipment__c theShipment;
    private BFM_Occurrence__c theOccurrence;
    private String shipOrOccNumber;
    
    @future(callout=true)
    public static void sendUpdateShipmentRequestFuture(Id shipmentOrOccurrenceId){
        new BFM_UpdateFreightData(shipmentOrOccurrenceId).sendUpdateShipmentRequest();
    }
    
    @future(callout=true)
    public static void send6thFlagUpdate(Id shipmentOrOccurrenceId){
    new BFM_UpdateFreightData(shipmentOrOccurrenceId).send6thFlagUpdateRequest();        
    }
  
    public BFM_UpdateFreightData(Id shipmentOrOccurrenceId){
        
        if(shipmentOrOccurrenceId.getSobjectType().getDescribe() == Schema.sObjectType.BFM_Shipment__c){
        theShipment = [SELECT Vehicle_Plate__c, Shipment_Number__c,Shipment_Start__c, X6th_flag__c FROM BFM_Shipment__c WHERE Id =:shipmentOrOccurrenceID LIMIT 1];
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
    
    public void send6thFlagUpdateRequest(){
      BFM_UpdateFreightDataRequest req = new BFM_UpdateFreightDataREquest();
        req.updateFreightData = new BFM_UpdateFreightDataREquest.UpdateFreightData();
        req.updateFreightData.shipment = new BFM_UpdateFreightDataRequest.Shipment();
        req.updateFreightData.shipment.shipmentId = this.theShipment.Shipment_Number__c;
        req.updateFreightData.shipment.checkoutDateTime = this.theShipment.Shipment_Start__c;
        BFM_GeneralServiceCalls.sendShipmentUpdate(req);
    }
    

}