/**********************************************************************
Purpose: Helper class for OpportunityTrigger.
History :
VERSION AUTHOR         DATE          DETAIL Description
1.0     Accenture    04/April/2016     Created for Opp Package handling 
                     05/May/2016       Created UpdateOppField method for LEAF process
***********************************************************************/
public with sharing class NAFS_OpportunityHelper {

    //Purpose:  For after update trigger (Opp Package handling)
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
        try{
            insert listOppLineItem;
        }
        Catch(DmlException e){
            System.debug( 'The following exception has occurred: '+e.getMessage() );
            ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_OpportunityHelper', 'OppUpdate', e.getMessage(), e, '', '', '', 0,'Food Solution');
        }
        
    }
    
    //Purpose: For after insert trigger (Opp Package handling)
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
        
        //Need a pricebook, to be updated
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
            try{
                Insert listNewPbe;
            }
            Catch(DmlException e){
                System.debug( 'The following exception has occurred: '+e.getMessage() );
            }
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
        try{
            If(!listOppLineItem.isEmpty())
                Insert listOppLineItem;
        }
        Catch(DmlException e){
            System.debug( 'The following exception has occurred: '+e.getMessage() );
            ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_OpportunityHelper', 'OppInsert', e.getMessage(), e, '', '', '', 0,'Food Solution');
        }
    }
    
    //Purpose: For update trigger to update Opp with Opp Line Item Value (MABE process)
    public static void UpdateOppField(List<Opportunity> listNewTrigger){ 
      if(NAFS_Utility.runOnce()){
          List<Id> listOppId = new List<Id>();
          List<String> listPriceBook= new List<String>();
          List<OpportunityLineItem> OppLineItem = new List<OpportunityLineItem>();
          List<Opportunity> oppToUpdate = new List<Opportunity>();
          Map<Id,Integer> mapOppIdGP= new Map<Id,Integer>();
          Map<Id,Integer> mapOppIdMT= new Map<Id,Integer>();
          Integer GrossProfit = 0;
          Integer MarketTarget = 0;
          Integer count = 0;
          Integer averageGrossProfit =0;
          Integer averageMarketTarget =0;
          
          for(Opportunity opp : listNewTrigger){
              listPriceBook.add(opp.pricebook2id);
              listOppId.add(opp.Id);
          }
          
          if(!listOppId.isEmpty()){    
              OppLineItem = [select Id, NAFS_GPPercent__c, NAFS_MarketTarget__c, opportunityId from OpportunityLineItem where opportunityId in :listOppId];
              
          }
          For(Opportunity opp : listNewTrigger){
              For(OpportunityLineItem oli: OppLineItem ){
                  if(opp.id == oli.opportunityId){
                      if(oli.NAFS_GPPercent__c != null){
                          GrossProfit = GrossProfit + Integer.valueOf(oli.NAFS_GPPercent__c);
                      } 
                      if(oli.NAFS_MarketTarget__c != null){   
                          MarketTarget = MarketTarget + Integer.valueOf(oli.NAFS_MarketTarget__c);
                      }    
                      count = count + 1;
                  }
              }
              if(count>0){
                  averageGrossProfit = GrossProfit/count;
                  averageMarketTarget = MarketTarget/count;
                  mapOppIdGP.put(opp.Id,averageGrossProfit);
                  mapOppIdMT.put(opp.Id,averageMarketTarget);
                  count = 0;//resetting the variables
                  GrossProfit = 0;
                  MarketTarget= 0;
              }         
          }
          List<Opportunity> oppList = [Select Id, NAFS_AverageGrossProfit__c, NAFS_MarketTarget__c from Opportunity where Id in :listOppId];
          for(Opportunity opp : oppList){
              if(mapOppIdGP.get(opp.Id)!=null){
                  opp.NAFS_AverageGrossProfit__c = mapOppIdGP.get(opp.Id);
                  opp.NAFS_MarketTarget__c = mapOppIdMT.get(opp.Id);
                  oppToUpdate.add(opp);
              }    
          }
          try{
              if(!oppToUpdate.isEmpty()){
                  update oppToUpdate;
              }
          }
          Catch(DmlException e){
              System.debug( 'The following exception has occurred: '+e.getMessage() );
              ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_OpportunityHelper', 'UpdateOppField', e.getMessage(), e, '', '', '', 0,'Food Solution');
          }
      }
    }
}