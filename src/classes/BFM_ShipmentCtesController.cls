public class BFM_ShipmentCtesController {
	private Id shipmentId;
    public BFM_ShipmentCtesController(ApexPages.StandardController stdCtr){
        shipmentId = stdCtr.getId();
    }
    
    public List<BFM_CT_e__c> ctes{
        get{
            ctes = [SELECt Id, Name FROM BFM_CT_e__c 
                                  	WHERE Id IN (SELECT CT_e__c FROM BFM_NF_e__c WHERE Delivery__r.Stage__r.Shipment__c = :shipmentId)];
            return ctes;
        } set;
    }
}