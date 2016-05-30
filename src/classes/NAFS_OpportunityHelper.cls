/**********************************************************************
Purpose: Helper class for OpportunityTrigger.
History :
VERSION AUTHOR         DATE          DETAIL Description
1.0     Accenture    04/April/2016     Created
                     25/May/2016       Updated handleOpportunityPackage
***********************************************************************/
public with sharing class NAFS_OpportunityHelper {

    //Purpose: To update Opportunity with Opp Line Item Value (MABE process)
    public static void rollUpOpportunityLineItem(List<Opportunity> listNewTrigger){ 
      //To avoid recurson in trigger used static variable NAFS_Utility.runOnce
      if(NAFS_Utility.runOnce()){
          List<Id> listOppId = new List<Id>();
          List<String> listPriceBook= new List<String>();
          List<OpportunityLineItem> OppLineItem = new List<OpportunityLineItem>();
          List<Opportunity> oppToUpdate = new List<Opportunity>();
          Map<Id,Integer> mapOppIdGP= new Map<Id,Integer>();
          Map<Id,Integer> mapOppIdMT= new Map<Id,Integer>();
          Integer grossProfit = 0;
          Integer marketTarget = 0;
          Integer recordCount = 0;
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
                          grossProfit = grossProfit + Integer.valueOf(oli.NAFS_GPPercent__c);
                      } 
                      if(oli.NAFS_MarketTarget__c != null){   
                          marketTarget = marketTarget + Integer.valueOf(oli.NAFS_MarketTarget__c);
                      }    
                      recordCount = recordCount + 1;
                  }
              }
              if(recordCount>0){
                  averageGrossProfit = grossProfit/recordCount;
                  averageMarketTarget = marketTarget/recordCount;
                  mapOppIdGP.put(opp.Id,averageGrossProfit);
                  mapOppIdMT.put(opp.Id,averageMarketTarget);
                  recordCount = 0;//resetting the variables
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
              ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_OpportunityHelper', 'UpdateOppField', e.getMessage(), e, null, null, null, 0,'Food Solution');
          }
      }
    }               
}