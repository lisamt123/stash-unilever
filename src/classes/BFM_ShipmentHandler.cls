public class BFM_ShipmentHandler implements ITrigger {
  
    private Map<Id,BFM_Shipment__c> oldMap;
    private Map<Id, BFM_Shipment__c> newMap;
    private List<BFM_Shipment__c> newMap1;
    
    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {   
        oldMap = (Map<Id, BFM_Shipment__c>)trigger.oldMap;
        newMap = (Map<Id, BFM_Shipment__c>)trigger.newMap;
		this.newMap1 = (List<BFM_Shipment__c>) Trigger.New;   
        
        if(trigger.isInsert) {
            BFM_ShipmentHandlerActions.defineShipmentUnileverAccount(newMap1); // Define Shipment Unilever Account
        }
        
        if(trigger.isUpdate) {
            BFM_ShipmentHandlerActions.defineShipmentUnileverAccount(newMap1); // Define Shipment Unilever Account
            BFM_ShipmentHandlerActions.checkIfNeedsToBeDeleted(newMap1); // Checks if is Deleted Flag is true (Sent by SAP) in order to delete the record
        }              
    }
    
    public void bulkAfter()
    {
      
    }
        
    public void beforeInsert(SObject so) {
        updateUnileverCompanyName(so);

    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
        BFM_Shipment__c shipmentOld = oldMap.get(oldSo.Id);
        BFM_Shipment__c shipmentNew = newMap.get(so.Id);
        system.debug('&&&&&&'+shipmentNew.Vehicle_Plate__c);
        if(shipmentOld.Vehicle_Plate__c != shipmentNew.Vehicle_Plate__c ){
            BFM_UpdateFreightData.sendUpdateShipmentRequestFuture(shipmentOld.Id);
        }
        if(shipmentOld.X6th_flag__c == false && shipmentNew.X6th_flag__c == true && !System.isBatch()){
			BFM_ShipmentHandlerActions.send6thflag(shipmentNew); //If 6th flag is true, send it to SAP
            shipmentNew.Shipment_Start__c = System.today();
            BFM_UpdateFreightData.send6thFlagUpdate(shipmentOld.Id);
        } else if(shipmentOld.X6th_flag__c == true && shipmentNew.X6th_flag__c == false) {
            shipmentNew.Shipment_Start__c = null;
        }
    
        updateUnileverCompanyName(so);
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
    
    /** Needs to check the company code in order to get the right Account */
    public void updateUnileverCompanyName(SObject so) {
        BFM_Shipment__c shipmentNew = newMap.get(so.Id);
        RecordType rt = [Select Id,DeveloperName from RecordType where DeveloperName = 'Standard'];
        
        if(shipmentNew.Company_Code__c != null) {
            List<Account> lstAcc = [SELECT id, name, BFM_Company_Name__c from Account where BFM_Company_Code__c  =: shipmentNew.Company_Code__c AND RecordTypeId =: rt.id];
            
            if(lstAcc.size() > 0) {
                shipmentNew.Unilever_Company__c = lstAcc.get(0).id; // Should take the first retrieved account (Business rule)
            }
        } else {
            shipmentNew.Unilever_Company__c = null;
        }
    }
}