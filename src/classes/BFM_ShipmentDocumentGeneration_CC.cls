public without sharing class BFM_ShipmentDocumentGeneration_CC {
    public Map<Id, List<BFM_SES__c>> sesByStageId {get;set;}
    public String stageIds{get;set;}
    private Id shipmentId;
    public BFM_ShipmentDocumentGeneration_CC(ApexPages.StandardController stdCtr){
        shipmentId = stdCtr.getId();
        List<BFM_Stage__c> theStages = [SELECT Id, (SELECt Id FROM Stages__r) FROM BFM_Shipment__c WHERE id =: shipmentId ].stages__r;
        sesByStageId = new Map<Id, List<BFM_SES__c>>();
        stageIds = '';
        List<BFM_SES__c> SESs = [SELECT Id, Name, SES_Number__c, Stage__c, Stage__r.Shipment__c FROM BFM_SES__C WHERE Stage__r.Shipment__c = : shipmentId];
        for(BFM_SES__c ses: SESs){
            if(!sesByStageId.containsKey(ses.Stage__c)){
                System.debug('putting in map ' + ses.Stage__c);
                sesByStageId.put(ses.Stage__c, new List<BFM_SES__c>());
                stageIds += ses.Stage__c +',';
            }
            sesByStageId.get(ses.Stage__c).add(ses);
        }
        
    }
    
    public List<BFM_NF_e__c> getNFes(){
        return [SELECT Name, NF_e_Access_Key__c FROM BFM_NF_e__c WHERE Delivery__r.Stage__r.Shipment__c = : shipmentId];
    }
    
}