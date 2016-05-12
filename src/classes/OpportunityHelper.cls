/**********************************************************************
Purpose: Helper class for OpportunityTrigger.
History :
VERSION AUTHOR         DATE          DETAIL Description
1.0     Accenture    04/April/2016     Created for Opp Package handling 
                     05/May/2016       Created UpdateOppField method for LEAF process
***********************************************************************/
public with sharing class OpportunityHelper {

    /******************* For after update trigger (Opp Package handling)**************************/
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
        }
        
    }
    
    /******************* For after insert trigger (Opp Package handling)***************************/
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
        
        //Need a pricebook, to be update
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
            }
    }
    
    /*******************For update trigger to update Opp with Opp Line Item Value (MABE process)*********************/
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
                  count = 0;
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
              }
      }
    }
    
    /************************** Update parent opportunity (LEAF process)****************************/
     public static void UpdateParentField(List<Opportunity> listNewTrigger, Map<Id,Opportunity> mapOld){ 
      if(NAFS_Utility.runOnce1()){
          List<Id> listOppId = new List<Id>();
          List<Id> listParentOppId= new List<Id>();
          //Map<Id,Integer> mapParentNSV = new Map<Id,Integer>();
          Map<Opportunity,List<Opportunity>> parentChild = new Map<Opportunity,List<Opportunity>>();
          List<Opportunity> listChildOpp = new List<Opportunity>();
          List<Opportunity> listOppToUpdate = new List<Opportunity>();
          Integer totalNSV = 0;
          Integer totalTMI = 0;
          Integer totalCase = 0;
          Integer totalLocation = 0;
          Integer totalMarketSpend = 0;
          Integer totalInstall = 0;
          Integer totalServiceCost = 0;
          Integer totalDepriciation = 0;
          Integer totalDistributorTMI = 0;
          Integer totalTurnover = 0;
          Integer totalGrossProfit = 0;
          Integer totalProfitBeforeIndirect = 0;
          Integer totalProfitBeforeIndirectPercentage = 0;
          for(Opportunity opp : listNewTrigger){
            if(opp.Parent_Opportunity__c != null){
              listParentOppId.add(opp.Parent_Opportunity__c);
              listOppId.add(opp.Id);
            }
          }
          List<Opportunity> childOpp = [select Id, Parent_Opportunity__c, NFS_TotalNSV__c, NFS_TotalOpportunityTMI__c, NFS_SumofCases__c, NFS_SumofLocations__c, NFS_MarketingSpend__c, NFS_TotalInstallation__c, NFS_TotalServiceCost__c, NFS_TotalEquipmentDepreciation__c, NFS_DistributorTMI__c, NFS_Turnover__c, NFS_GrossProfitLEAF__c, NFS_ProfitBeforeIndirect__c,NFS_ProfitBeforeIndirectPercentage__c from Opportunity where id in : listOppId];
          List<Opportunity> parentOpp = [select Id, NFS_NSVOfChildOpportunities__c,NFS_TradeMarketingInvestment__c, NFS_NumberOfCasesInChild__c,  NSV_NumberOfLocationsChild__c , NFS_MarketingSpendOfChild__c, NFS_TotalInstallationChild__c, NFS_ServiceCostChild__c, NFS_EquipmentDepreciationChild__c, NFS_DistributorTradeMarketingInvestment__c,NFS_TurnoverForchildOpportunity__c, NFS_GrossProfitforchildOpportunity__c, NFS_ProfitbeforeIndirectforchildOpp__c, NFS_ProfitbeforeIndirectpercentageChild__c from Opportunity where id in : listParentOppId];
          
          
          
          For(Opportunity pOpp : parentOpp){
              for(Opportunity cOpp : childOpp){
                if(cOpp.Parent_Opportunity__c == pOpp.Id){
                  listChildOpp.add(cOpp);
                }
              }
              parentChild.put(pOpp, listChildOpp);
              //need to empty listChildOpp
          }
          
          For(Opportunity pOpp : parentOpp){
            for(Opportunity cOpp : parentChild.get(pOpp)){
              if (cOpp.NFS_TotalNSV__c != null){
              totalNSV = totalNSV + Integer.valueOf(cOpp.NFS_TotalNSV__c);
              }
              if (cOpp.NFS_TotalOpportunityTMI__c != null){
              totalTMI = totalTMI + Integer.valueOf(cOpp.NFS_TotalOpportunityTMI__c);
              }
              if (cOpp.NFS_SumofCases__c != null){
              totalCase = totalCase + Integer.valueOf(cOpp.NFS_SumofCases__c);
              }
              if (cOpp.NFS_SumofLocations__c != null){
              totalLocation = totalLocation + Integer.valueOf(cOpp.NFS_SumofLocations__c);
              }
              if (cOpp.NFS_MarketingSpend__c != null){
              totalMarketSpend = totalMarketSpend + Integer.valueOf(cOpp.NFS_MarketingSpend__c);
              }
              if (cOpp.NFS_TotalInstallation__c != null){
              totalInstall = totalInstall + Integer.valueOf(cOpp.NFS_TotalInstallation__c);
              }
              if (cOpp.NFS_TotalServiceCost__c != null){
              totalServiceCost = totalServiceCost + Integer.valueOf(cOpp.NFS_TotalServiceCost__c);
              }
              if (cOpp.NFS_TotalEquipmentDepreciation__c != null){
              totalDepriciation = totalDepriciation + Integer.valueOf(cOpp.NFS_TotalEquipmentDepreciation__c);
              }
              if (cOpp.NFS_DistributorTMI__c != null){
              totalDistributorTMI = totalDistributorTMI + Integer.valueOf(cOpp.NFS_DistributorTMI__c);
              }
              if (cOpp.NFS_Turnover__c != null){
              totalTurnover = totalTurnover + Integer.valueOf(cOpp.NFS_Turnover__c);
              }
              if (cOpp.NFS_GrossProfitLEAF__c != null){
              totalGrossProfit = totalGrossProfit + Integer.valueOf(cOpp.NFS_GrossProfitLEAF__c);
              }
              if (cOpp.NFS_ProfitBeforeIndirect__c != null){
              totalProfitBeforeIndirect = totalProfitBeforeIndirect + Integer.valueOf(cOpp.NFS_ProfitBeforeIndirect__c);
              }
              if (cOpp.NFS_ProfitBeforeIndirectPercentage__c != null){
              totalProfitBeforeIndirectPercentage = totalProfitBeforeIndirectPercentage + Integer.valueOf(cOpp.NFS_ProfitBeforeIndirectPercentage__c);
              }
              
            }
            pOpp.NFS_NSVOfChildOpportunities__c = totalNSV;
            pOpp.NFS_TradeMarketingInvestment__c = totalTMI;
            pOpp.NFS_NumberOfCasesInChild__c = totalCase;
            pOpp.NSV_NumberOfLocationsChild__c = totalLocation;
            pOpp.NFS_MarketingSpendOfChild__c = totalMarketSpend;
            pOpp.NFS_TotalInstallationChild__c = totalInstall;
            pOpp.NFS_ServiceCostChild__c = totalServiceCost;
            pOpp.NFS_EquipmentDepreciationChild__c = totalDepriciation;
            pOpp.NFS_DistributorTradeMarketingInvestment__c = totalDistributorTMI;
            pOpp.NFS_TurnoverForchildOpportunity__c = totalTurnover;
            pOpp.NFS_GrossProfitforchildOpportunity__c = totalGrossProfit;
            pOpp.NFS_ProfitbeforeIndirectforchildOpp__c = totalProfitBeforeIndirect;
            pOpp.NFS_ProfitbeforeIndirectpercentageChild__c = totalProfitBeforeIndirectPercentage;
            listOppToUpdate.add(pOpp);
            //mapParentNSV.put(pOpp,totalNSV);
            totalNSV = 0; totalTMI=0; totalCase=0; totalLocation=0; totalMarketSpend=0; totalInstall=0; totalServiceCost=0; totalDepriciation=0; totalDistributorTMI=0;totalTurnover=0;totalGrossProfit=0;totalProfitBeforeIndirect = 0;totalProfitBeforeIndirectPercentage = 0;
          }
          
          /*For(Opportunity pOpp : parentOpp){
            pOpp.NFS_NSVOfChildOpportunities__c = mapParentNSV.get(pOpp)
          }*/
           try{
          if(!listOppToUpdate.isEmpty()){    
              update listOppToUpdate;
          }
          }
          Catch(DmlException e){
            System.debug( 'The following exception has occurred: '+e.getMessage() );
          }
      }  
     }              
}