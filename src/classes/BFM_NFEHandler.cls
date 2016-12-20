public with sharing class BFM_NFEHandler implements ITrigger
{   
    
    private Map<Id,BFM_NF_e__c> oldMap;
    private Map<Id, BFM_NF_e__c> newMap;
    public BFM_NFEHandler() {    
    }

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    { 
       
    }
    
    public void bulkAfter()
    {
        Set<Id> parentIds = new Set<Id>();
        List<BFM_NF_e__c> nfeList = (List<BFM_NF_e__c>) Trigger.New;
        for(BFM_NF_e__c child : nfeList){
            parentIds.add(child.Delivery__c);
        }
        system.debug('nfeList-->'+nfeList);
        Map<Id,BFM_Delivery__c> parentRecords = new Map<Id,BFM_Delivery__c>([Select Stage__c from BFM_Delivery__c where id in :parentIds]);
        Set<Id> grandParentIds = new Set<Id>();
        
        for(BFM_Delivery__c parentRecord : parentRecords.values()){
            grandParentIds.add(parentRecord.Stage__c);            
        }
    system.debug('parentRecords-->'+parentRecords);        
        system.debug('grandParentIds-->'+grandParentIds);
        Map<Id,BFM_Stage__c> grandParentRecords = new Map<Id,BFM_Stage__c>([Select id,Total_Gross_Weight__c from BFM_Stage__c where id in : grandParentIds]);
        List<BFM_NF_e__c> nfesList = [select id,Gross_weight__c,Delivery__c from BFM_NF_e__c where Delivery__c IN: parentRecords.values()];
        for(BFM_Stage__c bfms:grandParentRecords.values())
        {
            Decimal grossweight=0.000;
            for(BFM_NF_e__c child : nfesList){
                if(parentRecords.containsKey(child.Delivery__c) && grandParentRecords.containsKey(parentRecords.get(child.Delivery__c).Stage__c)){
                grossweight+=child.Gross_weight__c;
                }
            }
           grandParentRecords.get(bfms.id).Total_Gross_Weight__c = grossweight;

        }
        update grandParentRecords.values();
        BFM_NF_e__c nfeList1 = new BFM_NF_e__c();
        List<BFM_SES__c> seslist =[select id, Stage__c from BFM_SES__c where Stage__c=:grandParentIds];
        system.debug('seslist:'+seslist);
        for(BFM_NF_e__c bfmnfe: nfeList )
        {
            system.debug('bfmnfe:'+bfmnfe);
            if(bfmnfe.SES__c==null)
            {
                for(BFM_SES__c bfmses:seslist )    
                {
                    system.debug('bfmses:'+bfmses);
                    nfeList1.id = bfmnfe.id;
                    nfeList1.SES__c = bfmses.id;
                }
                system.debug('nfeList1:'+nfeList1);
            }           
        }
        system.debug('nfeList1:'+nfeList1);
       if(nfeList1.SES__c!=null){
          update nfeList1;
        }
    }
        
    public void beforeInsert(SObject so)
    {
       
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        
  
    }
     

    public void beforeDelete(SObject so)
    {   
    }
    
    public void afterInsert(SObject so) 
    { 
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {


    }
    
    public void afterDelete(SObject so)
    {
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {
        
    }

}