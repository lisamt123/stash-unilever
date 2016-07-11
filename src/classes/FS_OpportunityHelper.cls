/**********************************************************************
Purpose: Helper class for OpportunityTrigger.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     04/April/2016     Created
                      25/May/2016       Updated handleOpportunityPackage
                      01/July/2016      Updated for account planning
***********************************************************************/
public with sharing class FS_OpportunityHelper {

    //Purpose: To update Opportunity with Opp Line Item Value (MABE process)
    public static void rollUpOpportunityLineItem(List<Opportunity> listNewTrigger){ 
      //To avoid recurson in trigger used static variable NAFS_Utility.runOnce
      if(FS_Utility.runOnce()){
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
              OppLineItem = [select Id, GPPercent__c, FS_MarketTarget__c, opportunityId from OpportunityLineItem where opportunityId in :listOppId];
              
          }
          For(Opportunity opp : listNewTrigger){
              For(OpportunityLineItem oli: OppLineItem ){
                  if(opp.id == oli.opportunityId){
                      if(oli.GPPercent__c!= null){
                          grossProfit = grossProfit + Integer.valueOf(oli.GPPercent__c);
                      } 
                      if(oli.FS_MarketTarget__c!= null){   
                          marketTarget = marketTarget + Integer.valueOf(oli.FS_MarketTarget__c);
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
         List<Opportunity> oppList = [Select Id, AverageGrossProfit__c, MarketTarget__c from Opportunity where Id in :listOppId];
          for(Opportunity opp : oppList){
              if(mapOppIdGP.get(opp.Id)!=null){
                  opp.AverageGrossProfit__c= mapOppIdGP.get(opp.Id);
                  opp.MarketTarget__c= mapOppIdMT.get(opp.Id);
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
   //Purpose: To update Account Plan object to roll up Opportunity 
   public static void rollUptoAccountPlan(List<Opportunity> listNewTrigger2){ 
        if(FS_Utility.run2Once()){
         Integer Opportunity_Gain = 0;
         Integer Opportunity_Potential=0;
         Integer recordCount = 0;
         List<Id> listAccPlanId = new List<Id>();
         List<FS_Account_Plan__c> AccPlanList = new List<FS_Account_Plan__C>();
         List<FS_Account_Plan__c> AccPlanToUpdate = new List<FS_Account_Plan__C>();
         List<Opportunity> OppList = new List<Opportunity>();
         for(Opportunity opp : listNewTrigger2){
              if(opp.Account_Plan__c !=null){
                  listAccPlanId.add(opp.Account_Plan__c);
              }
            }
        //Get Accoun Plan deatils where associated opportunities have been modified
        AccPlanList=[select id,name,Opportunity_Gain__c,No_of_Opportunities__c,Opportunity_Amount__c from FS_Account_Plan__c where id in : listAccPlanId ];
        OppList=[select id,name,StageName,Amount,Account_Plan__c from Opportunity where Account_Plan__c in :listAccPlanId]  ;
        //Roll up opportunity details up to account plan object
        for(FS_Account_Plan__c AccPlan : AccPlanList )
        {
            Opportunity_Gain=0;
            recordCount=0;
            Opportunity_Potential=0;             
             for(Opportunity Opp : OppList)
             {
                 if(AccPlan.id==Opp.Account_Plan__c && opp.amount !=null){                 
                 IF(opp.StageName=='Closed Won'){
                 Opportunity_Gain=Opportunity_Gain+Integer.valueOf(opp.Amount);
                 }
                 if(opp.StageName!='Closed Lost'){
                  Opportunity_Potential=Opportunity_Potential+Integer.valueOf(opp.Amount); 
                 }
                 }
                }
            //Update roll up fields on account plan object
            AccPlan.Opportunity_Gain__c=Opportunity_Gain;
            AccPlan.No_of_Opportunities__c=OppList.size();
            accPlan.Opportunity_Amount__c=Opportunity_Potential;
            AccPlanToUpdate.add(accPlan);
            OppList.clear();
         }
            try{
              if(!AccPlanToUpdate.isEmpty()){
                 update(AccPlanToUpdate);
              }
          }
          Catch(DmlException e){
              System.debug( 'The following exception has occurred: '+e.getMessage() );
              ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_OpportunityHelper', 'UpdateOppField', e.getMessage(), e, null, null, null, 0,'Food Solution');
          }
        
        }
}
    public static void rollUptoDefinedObjective(List<Opportunity> listNewTrigger2){ 
        if(FS_Utility.run3Once()){
         List<Id> listObjId = new List<Id>();
         Integer Gross_Amount;
         List<FS_Defined_Objective__c> ObjList = new List<FS_Defined_Objective__c>();
         List<FS_Defined_Objective__c> ObjToUpdate = new List<FS_Defined_Objective__c>();
         List<Opportunity> OppList = new List<Opportunity>();
         for(Opportunity opp : listNewTrigger2){
              if(opp.Defined_Objective__c !=null){
                  listObjId.add(opp.Defined_Objective__c);
              }
            }
        //Get Accoun Plan deatils where associated opportunities have been modified
        ObjList=[select id,name,No_of_Opportunities__c from FS_Defined_Objective__c where id in : listObjId];
        OppList=[select id,name,StageName,Amount,Defined_Objective__c from Opportunity where defined_objective__C in :listObjId];
        //Roll up opportunity details up to account plan object
        for(FS_Defined_Objective__c Obj : ObjList )
        {
            Gross_Amount=0;
            //Update total no of opportunities on defined objective
            for(Opportunity Opp : OppList){
                  If(opp.amount !=null && opp.StageName!='Closed Lost' && obj.Id==opp.Defined_Objective__c){
                  Gross_Amount=Gross_Amount+Integer.valueOf(opp.Amount);
                 }
             }
            Obj.No_of_Opportunities__c=OppList.size();
            Obj.Opportunity_Amount__c=Gross_Amount;
            ObjToUpdate.add(obj);
            OppList.clear();
         }
            try{
              if(!ObjToUpdate.isEmpty()){
                 update ObjToUpdate;
              }
          }
          Catch(DmlException e){
              System.debug( 'The following exception has occurred: '+e.getMessage() );
              ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_OpportunityHelper', 'UpdateOppField', e.getMessage(), e, null, null, null, 0,'Food Solution');
          }
        
        }
 }
}