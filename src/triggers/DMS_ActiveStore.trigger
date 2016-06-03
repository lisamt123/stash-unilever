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

VERSION 	AUTHOR		 		DATE  		Description
1.0		DIMITRI M. SANTANA	 02/06/2016		INITIAL DEVELOPMENT

***********************************************************************/

trigger DMS_ActiveStore on Target__c (before insert) {
    
    List<Id> sellerIds = new List<Id>();
    Map<String,Integer> numberStoresSeller = new Map<String,Integer>();
    
    for(Target__c target : Trigger.New) 
    {        
        sellerIds.add(target.SalesRep__c);                       
    }
    
    
    for(AggregateResult agg : [SELECT OwnerId,count(id) countSellers FROM Account WHERE OwnerId =: sellerIds and RecordTypeId =: DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer') GROUP BY OwnerId]){        
        numberStoresSeller.put(String.valueOf(agg.get('OwnerId')),Integer.valueOf(agg.get('countSellers')));        
    }        
    
    for(Target__c target : Trigger.New) 
    {       
        if(target.TargetDate__c.Month() == Date.today().Month() && target.TargetDate__c.Year() == Date.today().Year()){
            if(numberStoresSeller.containsKey(target.SalesRep__c)){
                target.ImpactedStores__c = numberStoresSeller.get(target.SalesRep__c);            
            }else{
                target.ImpactedStores__c = 0;
            }
        }
    }
}