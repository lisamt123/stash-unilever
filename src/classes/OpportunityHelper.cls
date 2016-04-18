public with sharing class OpportunityHelper {

	//Test
    /******************* For after update trigger **************************/
    public static void OppUpdate(List<Opportunity> listNewTrigger, Map<Id,Opportunity> mapOld){ 
    
        List<String> listPackageName= new List<String>();
        List<String> listPriceBook= new List<String>();
        List<OpportunityLineItem> listOppLineItem = new List<OpportunityLineItem>();
        List<Id> listOppId = new List<Id>();
        
        for(Opportunity opp : listNewTrigger){
            if(opp.package__c != mapOld.get(opp.id).package__c){
                if(opp.package__c != null){
                    listPackageName.add(opp.package__c);
                    listPriceBook.add(opp.pricebook2id);
                    listOppId.add(opp.Id);
                }
            }
        }
        
        //Delete existing Opportunity Line Item
        if(!listOppId.isEmpty()){    
            List<OpportunityLineItem> oldOppLineItem = [select Id from OpportunityLineItem where opportunityId in :listOppId];
            delete oldOppLineItem;
        }
        
        //Opportunity should already have product added in related list     
        List<priceBookEntry> listPriceBookEntry = [select id, product2Id, pricebook2Id, unitPrice, product2.Package__c
                                                     from pricebookEntry where 
                                                     priceBook2Id in :listPriceBook and 
                                                     product2.Package__c in : listPackageName];
         
        //For every Opportunity check if there is any pricebookentry with produt same as opportunity pakage name
        for(Opportunity opp1 : listNewTrigger){
            for(priceBookEntry pbe: listPriceBookEntry ){
                if(opp1.pricebook2id == pbe.pricebook2Id && opp1.package__c == pbe.product2.Package__c){
                    OpportunityLineItem oppLineItem = new OpportunityLineItem(OpportunityId = opp1.id, PricebookentryId = pbe.Id, quantity=1, totalPrice=pbe.unitPrice);
                    listOppLineItem.add(oppLineItem);
                }
            }
        }
    
        insert listOppLineItem;
    }
    
    /******************* For after insert trigger ***************************/
    public static void OppInsert(List<Opportunity> listNewTrigger){ 
    
        List<String> listPackageName= new List<String>();
        List<String> listPriceBook= new List<String>();
        List<OpportunityLineItem> listOppLineItem = new List<OpportunityLineItem>();
        List<priceBookEntry> listNewPbe = new List<priceBookEntry>();
        Map<opportunity, List<priceBookEntry>> mapOppPbe = new Map<opportunity,List<priceBookEntry>>(); 
        
        for(Opportunity opp:listNewTrigger){
            if(opp.package__c != null){
                listPackageName.add(opp.package__c);
            }
        }
        
        List<Product2> listProd = [select id, name, package__c from Product2 where package__c =: listPackageName];
        
        //Need a pricebook,
        Pricebook2 pb = [select id, name from Pricebook2 where name LIKE 'Standard%' and isActive = true limit 1];
                
        listNewPbe = [select id, product2.Package__c, unitPrice from priceBookEntry where product2.Package__c =: listPackageName and priceBook2Id =: pb.Id]; 
        
        // If priceBookEntry is not available then insert priceBookEntry 
        if(listNewPbe.isEmpty()){
            for(Opportunity opp1 : listNewTrigger){
                for(Product2 prod: listProd){
                    if(prod.package__c == opp1.package__c){
                        priceBookEntry newPbe = new priceBookEntry ( Product2Id = prod.id, pricebook2id = pb.id, unitPrice = 0, IsActive = true);
                        listNewPbe.add(newPbe);
                    }    
                }
                mapOppPbe.put(opp1, listNewPbe);
            }
            Insert listNewPbe;
        }
        
        //Insert OpportunityLineItem
        for(Opportunity opp2 : listNewTrigger){
            for(priceBookEntry pbook : listNewPbe){ 
                if(opp2.package__c == pbook.product2.Package__c){
                    OpportunityLineItem oppLineItem = new OpportunityLineItem(OpportunityId = opp2.id, PricebookentryId = pbook.Id, quantity=1, totalPrice=pbook.unitPrice);
                    listOppLineItem.add(oppLineItem);
                }    
            }
        }
        If(!listOppLineItem.isEmpty())
            Insert listOppLineItem;
    }
}