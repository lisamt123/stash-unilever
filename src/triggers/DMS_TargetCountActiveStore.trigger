/**********************************************************************
Name: DMS_ActiveStore
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Trigger to generate the target for impactedStores
====================================================== 
======================================================
History 

VERSION     AUTHOR              DATE        Description
1.0     DIMITRI M. SANTANA   02/06/2016     INITIAL DEVELOPMENT
1.1		DIMITRI M. SANTANA	 14/06/2016		CHANGE LOGIC

***********************************************************************/

trigger DMS_TargetCountActiveStore on Target__c (before insert,before update) {
    
    private Set<Id> sellerContactIds = new Set<Id>();
   private Map<String,Map<String,Set<id>>> numberStoresSeller = new Map<String,Map<String,Set<id>>>();
    
    
    for(Target__c target : Trigger.New) 
    {       
        if(target.RecordTypeId.equals(DMS_RecordTypeMemory.getRecType('Target__c', 'Hexagon_Layout'))){
            sellerContactIds.add(target.SalesRep__c);  
        }
    }
    DMS_CountActiveStore countActiveStore = new DMS_CountActiveStore();
    numberStoresSeller = countActiveStore.countStores(sellerContactIds);
   
    System.debug('numero de lojas aqui!!! ' +numberStoresSeller);
    for(Target__c target : Trigger.New) 
    {       
        if(target.TargetDate__c.Month() == Date.today().Month() && target.TargetDate__c.Year() == Date.today().Year()){
            if(numberStoresSeller.containsKey(target.SalesRep__c) && numberStoresSeller.get(target.SalesRep__c).containsKey(target.SalesChannel__c)){
                target.ImpactedStores__c = numberStoresSeller.get(target.SalesRep__c).get(target.SalesChannel__c).size();            
            }else{
                target.ImpactedStores__c = 0;
            }
        }       
    }
}