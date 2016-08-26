/**********************************************************************
Name: ICB_CalculatePlanDistaance_Batch
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Esta classe realiza o calculo da distancia planejada 
onde a distancia da visita anterior até a próxima é 
gravada na visita subsequente.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Antonio Raul 	26/06/2016  Class creation  
***********************************************************************/
global with sharing class ICB_ReturnStock_Batch implements Database.Batchable<sObject>
{
    
   
    /*******************************************************************
     Purpose: This method execute the class ICB_ReturnStock.
     Parameters: [Database.Batchablecontext]
     Returns: [Database.Querylocator]
     Throws [Exceptions]: [NONE]
     ********************************************************************/
    global Database.Querylocator start (Database.Batchablecontext bc)
    {
        //String oppDate = String.valueOf();
        String query = 'Select Id, ICB_ITEMS_RETURNED__c,Product2Id,Product2.CreatedDate,Opportunity.Account.Name From OpportunityLineItem Where Opportunity.CreatedDate = LAST_N_DAYS:7';
        return Database.getQueryLocator(query);
    }
    
    global void execute( Database.BatchableContext BC, List<OpportunityLineItem> scope)
    {
        Map<String,OpportunityLineItem> oppLineItemMap = new Map<String,OpportunityLineItem>();
        for(OpportunityLineItem item : scope)
        {
            if(oppLineItemMap.keySet().contains(item.Product2Id))
            {
                item.ICB_ITEMS_RETURNED__c += oppLineItemMap.get(item.Product2Id).ICB_ITEMS_RETURNED__c;
                oppLineItemMap.remove(item.Product2Id);
            }
            oppLineItemMap.put(item.Product2Id, item); 
        }
        List<ICB_Inventory_Line_Item__c> ivtList = new List<ICB_Inventory_Line_Item__c>();
        for(ICB_Inventory_Line_Item__c ivt : [Select ICB_Quantity_Unit__c,ICB_Product__c,ICB_Inventory__r.Name From ICB_Inventory_Line_Item__c Where ICB_Product__c =: oppLineItemMap.keySet()])
        {
            if(ivt.ICB_Inventory__r.Name == oppLIneItemMap.get(ivt.ICB_Product__c ).Opportunity.Account.Name)
            {
                ivt.ICB_Quantity_Unit__c += oppLIneItemMap.get(ivt.ICB_Product__c ).ICB_ITEMS_RETURNED__c;
                ivtList.add(ivt);
            }
        }
        Database.update(ivtList);
    }
     
    global void finish (Database.Batchablecontext bc){}
}