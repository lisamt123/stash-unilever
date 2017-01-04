public class BFM_CarrierCockpit_CC {
    
    public List<BFM_Stage__c> stages{get;set;}
    public Map<Account, List<BFM_Stage__c>> stagesByVendor{get;set;}
    
    public BFM_CarrierCockpit_CC(ApexPages.StandardController stdCtr){
        //Id accId = stdCtr.getId();
        stagesByVendor = new Map<Account, List<BFM_Stage__c>>();
        
        Id accId = '0018A000007SARV';
        stages = [SELECT Shipment__r.Carrier_Account__c, Shipment__r.Carrier_Account__r.Name, Shipment__r.Shipment_Number__c,Name, Shipment__r.Unilever_Company__r.Name,
                  						Shipment__r.Pricing_Calculation_Date__c,
                  						Origin_city__c, Destination_City__c, 
                  						Shipment__r.Shipment_Start__c,Gross_value_from_cost_preview__c
                                     	FROM BFM_Stage__c 
                                     	WHERE Shipment__r.Carrier_Account__c =: accId];
        for(BFM_Stage__c stage: stages){
            if(!stagesByVendor.containsKey(stage.Shipment__r.Carrier_Account__r)){
                stagesByVendor.put(stage.Shipment__r.Carrier_Account__r, new List<BFM_Stage__c>());
            }
            stagesByVendor.get(stage.Shipment__r.Carrier_Account__r).add(stage);
        }
    }
    
}