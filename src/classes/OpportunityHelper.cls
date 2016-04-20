/**********************************************************************
Name: OpportunityHelper
Purpose: This is a helper class of OpportunityTrigger. Create/Update/Delete Oppertunitylineitems based on Package in Opportunity  
History
-------
VERSION AUTHOR    DATE         DETAIL Description
1.0 	       19/04/2016      Created the class
***********************************************************************/
public class OpportunityHelper {
	
	// Calling this method for after update trigger 
    public static void opportunityUpdate(List<Opportunity> listNewTrigger, Map<Id,Opportunity> mapOld){ 
    	List<String> listofPackageNames= new List<String>();
		List<String> listofPriceBooks= new List<String>();
		List<OpportunityLineItem> listofOpportunityLineItem = new List<OpportunityLineItem>();
		List<Id> listofOpportunityId = new List<Id>();
        try{
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
			//Retrieve product and pricebook if Opportunity already have product added in related list     
			List<priceBookEntry> listofPriceBooksEntry = [select id, product2Id, pricebook2Id, unitPrice, product2.Package__c
														 from pricebookEntry where 
														 priceBook2Id in :listofPriceBooks and 
														 product2.Package__c in : listofPackageNames];
			//To Do : If opportunity does not have pricebook associated with it then we need to retrieve a product, pricebook then create a PriceBookEntry 
			
			//For every Opportunity check if there is any product same as Opportunity pakage and opportunity pricebook
			for(Opportunity opportunityWithPriceBookEntry : listNewTrigger){
				for(priceBookEntry pricebooke: listofPriceBooksEntry ){
					if(opportunityWithPriceBookEntry.pricebook2id == pricebooke.pricebook2Id && opportunityWithPriceBookEntry.package__c == pricebooke.product2.Package__c){
						OpportunityLineItem OpportunityRecordsLineItem = new OpportunityLineItem(OpportunityId = opportunityWithPriceBookEntry.id, PricebookentryId = pricebooke.Id, quantity=1, totalPrice=pricebooke.unitPrice);
						listofOpportunityLineItem.add(OpportunityRecordsLineItem);
					}
				}
			}
			if(!listofOpportunityLineItem.isEmpty()){
				system.debug('listofOpportunityLineItem ->' + listofOpportunityLineItem);
				insert listofOpportunityLineItem;
			}
		}//tryblock end
		catch(Exception e){
			system.debug('Error Message is: -> '+e.getMessage());
		} 
    }// Method End
    
    
    // Calling this method for after update trigger 
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
        //Need products and pricebook to retrieve priceBookEntry
        List<Product2> listOfProducts = [select id, name, package__c from Product2 where package__c =: listofPackageNames];
        Pricebook2 pricebook = [select id, name from Pricebook2 where name LIKE 'Standard%' and isActive = true limit 1];
        listNewPriceBook = [select id, product2.Package__c, unitPrice from priceBookEntry where product2.Package__c =: listofPackageNames and priceBook2Id =: pricebook.Id]; 
        
        // To Do: If priceBookEntry is not available then insert it 
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
        If(!listofOpportunityLineItem.isEmpty()){
        	system.debug('listofOpportunityLineItem ->' + listofOpportunityLineItem);
            Insert listofOpportunityLineItem;
        }    
      }//tryblock end
      Catch(Exception E){
		system.debug('Error Message is:'+E.getMessage());  
	  }	  
    }//Method end
}