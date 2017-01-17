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
        this.nfeList = (List<BFM_NF_e__c>) Trigger.New;
        if(trigger.isUpdate) {
            List<BFM_Ct_e__c> cteListToUpdate = new List<BFM_Ct_e__c>();
            
            Set<String> setCteKeys = new Set<String>();
			String nfeKey = '';
            String cnpj = '';
            for(BFM_NF_e__c nfe : nfeList) {
                if(nfe.CT_e__c != null) {
                    setCteKeys.add(nfe.CT_e__c);
                }
                if(nfe.NF_e_access_key__c!=null)
                {
                    nfeKey = nfe.NF_e_access_key__c;
                }
            }
            if(nfeKey != '')
            {       
				system.debug('nfeKey:'+nfeKey);
				cnpj = nfeKey.substring(6, 20);
				system.debug('cnpj:'+cnpj);
				List<Account> acc = [SELECT id,Name,Address__c,City__c,Vendor_UF_State__c FROM  Account where CNPJ__c=:cnpj];
				system.debug('acc:'+acc);
				if(acc.size()>0)
				{
					for(Account a : acc)
					{
						for(BFM_NF_e__c nfe : nfeList) {
							if(nfe.Incoterms__c == 'CIF' || nfe.Incoterms__c == 'CPT')
							{
								nfe.Street_Taker__c = a.Address__c;
								nfe.City_Taker__c = a.City__c; 
								nfe.Taker_Name__c = a.Id;
								nfe.State_Taker__c = a.Vendor_UF_State__c;
							}
							if(nfe.Incoterms__c == 'FOB')
							{
								nfe.CNPJ_issuer__c = nfe.CNPJ_destination__c;
								nfe.Name_Issuer__c = nfe.Name_destination__c; 
								nfe.Street_Issuer__c = nfe.Street_Destination__c;
                                nfe.City_Issuer__c = nfe.City_Destination__c;
                                nfe.District_Issuer__c = nfe.District_destination__c;
                                nfe.State_Issuer__c = nfe.State_destination__c;
                                nfe.Address_Number_Issuer__c = nfe.Address_Number_Destination__c;
                                nfe.City_Code_Issuer__c = nfe.City_Code_Destination__c;
                                nfe.Postal_Code_Issuer__c = nfe.Postal_code_destination__c;
                            }
						}
					}
				} 
            }
            if(setCteKeys.size() > 0){
                List<BFM_Ct_e__c> cteList = [SELECT id, CT_e_key__c, Shipment__c FROM  BFM_Ct_e__c where id =: setCteKeys];
                
                for(BFM_Ct_e__c cte : cteList) {
                    System.debug('cte : ' + cte);
                    cte.Shipment__c = nfeList.get(0).Shipment__c;
                    cteListToUpdate.add(cte);
                }
                
                if(cteListToUpdate.size() > 0){Database.update(cteListToUpdate);}
            }
        }
    }
    
    public void bulkAfter() {
        List<BFM_NF_e__c> nfeList = (List<BFM_NF_e__c>) Trigger.New;
        Set<Id> deliveriesIds = new Set<Id>();
        
        for(BFM_NF_e__c child : nfeList) {
            deliveriesIds.add(child.Delivery__c);
        }
        system.debug('delids===>'+deliveriesIds);
        
        Map<Id,BFM_Delivery__c> mapDelivery = new Map<Id,BFM_Delivery__c>([Select Stage__c from BFM_Delivery__c where id in :deliveriesIds]);
        System.debug('bulkAfter mapDelivery-->' + mapDelivery);      
        
        Set<Id> stageIds = new Set<Id>();
        for(BFM_Delivery__c parentRecord : mapDelivery.values()){
            stageIds.add(parentRecord.Stage__c);                        
        }
        system.debug('stgids--->'+stageIds);
        
        Map<Id,BFM_Stage__c> mapStages = new Map<Id,BFM_Stage__c>([Select id,Total_Gross_Weight__c, Name from BFM_Stage__c WHERE ID in : stageIds]);        
        System.debug('bulkAfter mapStages-->' + mapStages);
        
        List<BFM_NF_e__c> nfesList = [Select id, Gross_weight__c, Delivery__c,Delivery__r.Stage__c from BFM_NF_e__c where Delivery__c IN: mapDelivery.values()];
        System.debug('bulkAfter nfesList-->' + nfesList);
        
        // ***********************  (modified by chaitanya)
           
            for(BFM_NF_e__c nfe1 : nfesList) {
 
            if(mapDelivery.containsKey(nfe1.Delivery__c) && mapStages.containsKey(mapDelivery.get(nfe1.Delivery__c).Stage__c)) {
            
                mapStages.get(mapDelivery.get(nfe1.Delivery__c).Stage__c).Total_Gross_Weight__c = 0.0; 
            }    
            }
        
        //*************************
        Double grossWeight = 0.0;
        for(BFM_NF_e__c nfe : nfesList) {
 
            if(mapDelivery.containsKey(nfe.Delivery__c) && mapStages.containsKey(mapDelivery.get(nfe.Delivery__c).Stage__c)) {
                System.debug('nfe.Gross_weight__c' + nfe.Gross_weight__c);
              //  grossWeight += nfe.Gross_weight__c;  (modified by chaitanya)
                
                system.debug('grsweight--->'+grossWeight);
                if(nfe.Delivery__r.Stage__c==mapDelivery.get(nfe.Delivery__c).Stage__c && nfe.Gross_weight__c!=null)
                {
                mapStages.get(mapDelivery.get(nfe.Delivery__c).Stage__c).Total_Gross_Weight__c += nfe.Gross_weight__c; // (modified by chaitanya)
                }
            }
        }
        system.debug('grsweight--->'+grossWeight);
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