/**********************************************************************
Name: OpportunityHelper
Copyright © 2016 
======================================================
======================================================
Purpose: Create/Update/Delete Oppertunitylineitems based on Package value in Opportunity  
-------
======================================================
======================================================
History
-------
VERSION AUTHOR    DATE         DETAIL Description
1.0 	       19/04/2016      
***********************************************************************/
public class OpportunityHelper {

    /******************* For after update trigger **************************/
    public static void opportunityUpdate(List<Opportunity> listNewTrigger, Map<Id,Opportunity> mapOld){ 
        try{
			List<String> listofPackageNames= new List<String>();
			List<String> listofPriceBooks= new List<String>();
			List<OpportunityLineItem> listofOpportunityLineItem = new List<OpportunityLineItem>();
			List<Id> listofOpportunityId = new List<Id>();
			
			for(Opportunity OpportunityRecords : listNewTrigger){
				if(OpportunityRecords.package__c != mapOld.get(OpportunityRecords.id).package__c){
					System.debug('Opportunity realted package value is :'+OpportunityRecords.package__c);
					if(OpportunityRecords.package__c != null){
						listofPackageNames.add(OpportunityRecords.package__c);
						listofPriceBooks.add(OpportunityRecords.pricebook2id);
						listofOpportunityId.add(OpportunityRecords.Id);
					}
				}
			}
			//Delete existing Opportunity Line Item
			if(!listofOpportunityId.isEmpty()){    
				List<OpportunityLineItem> oldOpportunityRecordsLineItem = [select Id from OpportunityLineItem where OpportunityId in :listofOpportunityId];
				delete oldOpportunityRecordsLineItem;
			}
			//Opportunity should already have product added in related list     
			List<priceBookEntry> listofPriceBooksEntry = [select id, product2Id, pricebook2Id, unitPrice, product2.Package__c
														 from pricebookEntry where 
														 priceBook2Id in :listofPriceBooks and 
														 product2.Package__c in : listofPackageNames];
			 
			//For every Opportunity check if there is any pricebookentry with produt same as Opportunity pakage name
			for(Opportunity opportunityWithPriceBookEntry : listNewTrigger){
				for(priceBookEntry pricebooke: listofPriceBooksEntry ){
					if(opportunityWithPriceBookEntry.pricebook2id == pricebooke.pricebook2Id && opportunityWithPriceBookEntry.package__c == pricebooke.product2.Package__c){
						OpportunityLineItem OpportunityRecordsLineItem = new OpportunityLineItem(OpportunityId = opportunityWithPriceBookEntry.id, PricebookentryId = pricebooke.Id, quantity=1, totalPrice=pricebooke.unitPrice);
						listofOpportunityLineItem.add(OpportunityRecordsLineItem);
					}
				}
			}
			
			insert listofOpportunityLineItem;
		}//tryblock end
		catch(Exception e){
			system.debug('Error Message is: -> '+e.getMessage());
		}//Catchblock end 
    }// Method End
    
    /******************* For after insert trigger ***************************/
    public static void OpportunityInsert(List<Opportunity> listNewTrigger){ 
      try{     
        List<String> listofPackageNames= new List<String>();
        List<String> listofPriceBooks= new List<String>();
        List<OpportunityLineItem> listofOpportunityLineItem = new List<OpportunityLineItem>();
        List<priceBookEntry> listNewPriceBook = new List<priceBookEntry>();
        Map<Opportunity, List<priceBookEntry>> mapOpportunityRecordspricebooke = new Map<Opportunity,List<priceBookEntry>>(); 
        
        for(Opportunity OpportunityRecordsForInsert:listNewTrigger){
            if(OpportunityRecordsForInsert.package__c != null){
                listofPackageNames.add(OpportunityRecordsForInsert.package__c);
            }
        }
        List<Product2> listOfProducts = [select id, name, package__c from Product2 where package__c =: listofPackageNames];
        
        //Need a pricebook,
        Pricebook2 pricebook = [select id, name from Pricebook2 where name LIKE 'Standard%' and isActive = true limit 1];
                
        listNewPriceBook = [select id, product2.Package__c, unitPrice from priceBookEntry where product2.Package__c =: listofPackageNames and priceBook2Id =: pricebook.Id]; 
        
        // If priceBookEntry is not available then insert priceBookEntry 
        if(listNewPriceBook.isEmpty()){
            for(Opportunity opportunitywithPriceBookEntry:listNewTrigger){
                for(Product2 prod: listOfProducts){
                    if(prod.package__c == opportunitywithPriceBookEntry.package__c){
                        priceBookEntry newpricebooke = new priceBookEntry ( Product2Id = prod.id, pricebook2id = pricebook.id, unitPrice = 0, IsActive = true);
                        listNewPriceBook.add(newpricebooke);
                    }    
                }
                mapOpportunityRecordspricebooke.put(opportunitywithPriceBookEntry,listNewPriceBook);
            }
            Insert listNewPriceBook;
        }
        //Insert OpportunityLineItem
        for(Opportunity OpportunityRecords2 : listNewTrigger){
            for(priceBookEntry pricebookook : listNewPriceBook){ 
                if(OpportunityRecords2.package__c == pricebookook.product2.Package__c){
					System.debug('Opportunity realted package value is :'+OpportunityRecords2.package__c);
                    OpportunityLineItem OpportunityRecordsLineItem = new OpportunityLineItem(OpportunityId = OpportunityRecords2.id, PricebookentryId = pricebookook.Id, quantity=1, totalPrice=pricebookook.unitPrice);
                    listofOpportunityLineItem.add(OpportunityRecordsLineItem);
                }    
            }
        }
        If(!listofOpportunityLineItem.isEmpty())
            Insert listofOpportunityLineItem;
      }//tryblock end
      Catch(Exception E){
		system.debug('Error Message is:'+E.getMessage());  
	  }//Catchblock end 	  
    }
}