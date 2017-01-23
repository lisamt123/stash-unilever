public with sharing class BFM_NFEHandler implements ITrigger {   
    
    private Map<Id,BFM_NF_e__c> oldMap;
    private Map<Id, BFM_NF_e__c> newMap;
    private List<BFM_NF_e__c> nfeList;
    
    public BFM_NFEHandler() {}

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore(){

    }
    
    public void bulkAfter() {
        List<BFM_NF_e__c> nfeList = (List<BFM_NF_e__c>) Trigger.New;

        Set<Id> deliveriesIds = new Set<Id>();
        
        for(BFM_NF_e__c child : nfeList) {
            deliveriesIds.add(child.Delivery__c);
        }
        
        Map<Id,BFM_Delivery__c> mapDelivery = new Map<Id,BFM_Delivery__c>([Select Stage__c from BFM_Delivery__c where id in :deliveriesIds]);
      
        
        Set<Id> stageIds = new Set<Id>();
        for(BFM_Delivery__c parentRecord : mapDelivery.values()){
            stageIds.add(parentRecord.Stage__c);                        
        }

        
        Map<Id,BFM_Stage__c> mapStages = new Map<Id,BFM_Stage__c>([Select id,Total_Gross_Weight__c, Name from BFM_Stage__c WHERE ID in : stageIds]);        
        
        List<BFM_NF_e__c> nfesList = [Select id, Gross_weight__c, Delivery__c,Delivery__r.Stage__c from BFM_NF_e__c where Delivery__c IN: mapDelivery.values()];

        for(BFM_NF_e__c nfe1 : nfesList) {
            
            if(mapDelivery.containsKey(nfe1.Delivery__c) && mapStages.containsKey(mapDelivery.get(nfe1.Delivery__c).Stage__c)) {
                
                mapStages.get(mapDelivery.get(nfe1.Delivery__c).Stage__c).Total_Gross_Weight__c = 0.0; 
            }    
        }

        Double grossWeight = 0.0;
        for(BFM_NF_e__c nfe : nfesList) {
            
            if(mapDelivery.containsKey(nfe.Delivery__c) && mapStages.containsKey(mapDelivery.get(nfe.Delivery__c).Stage__c)) {

                if(nfe.Delivery__r.Stage__c==mapDelivery.get(nfe.Delivery__c).Stage__c && nfe.Gross_weight__c!=null)
                {
                    mapStages.get(mapDelivery.get(nfe.Delivery__c).Stage__c).Total_Gross_Weight__c += nfe.Gross_weight__c; // (modified by chaitanya)
                }
            }
        }
        Database.Update(mapStages.values());        
    }
    
    public void beforeInsert(SObject so) {}
    
    public void beforeUpdate(SObject oldSo, SObject so) {}

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
    public void andFinally(){}
}