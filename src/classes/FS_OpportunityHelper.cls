/**********************************************************************
Purpose: Helper class for OpportunityTrigger.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     04/April/2016     Created
                      25/May/2016       Updated handleOpportunityPackage
                      01/July/2016      Updated for account planning
***********************************************************************/
/* * Class FS_OpportunityHelper helper class for Opportunity trigger
*  @name FS_OpportunityHelper
*  @param
*  @return 
*  @throws 
*/ 
public without sharing class FS_OpportunityHelper {
Private static final string STATUS_WON='05 – Won';
Private static final string STATUS_CLOSED_WON='Closed Won';
Private static final string STATUS_CLOSED_LOST='Closed Lost';
/* * Method rollUpOpportunityLineItem to update Opportunity with Opp Line Item Value (MABE process)
*  @name rollUpOpportunityLineItem
*  @param List<Opportunity> listNewTrigger
*  @return 
*  @throws
*/    
    public void rollUpOpportunityLineItem(List<Opportunity> listNewTrigger){ 
      //To avoid recurson in trigger used static variable NAFS_Utility.runOnce
      if(FS_Utility.runOnce()){
          List<Id> listOppId = new List<Id>();
          List<String> listPriceBook= new List<String>();
          List<OpportunityLineItem> OppLineItem = new List<OpportunityLineItem>();
          List<Opportunity> oppToUpdate = new List<Opportunity>();
          Map<Id,Decimal> mapOppIdGP= new Map<Id,Decimal>();
          Map<Id,Decimal> mapOppIdMT= new Map<Id,Decimal>();
          Decimal grossProfit = 0;
          Decimal marketTarget = 0;
          Integer recordCount = 0;
          Decimal averageGrossProfit =0;
          Decimal averageMarketTarget =0;
          
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
                          grossProfit = grossProfit + oli.GPPercent__c;
                      } 
                      if(oli.FS_MarketTarget__c!= null){   
                          marketTarget = marketTarget + oli.FS_MarketTarget__c;
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
/* * Method rollUptoAccountPlan to update rollup fields on account plan
*  @name rollUptoAccountPlan
*  @param List<Opportunity> listNewTrigger2
*  @return 
*  @throws 
*/
   //Purpose: To update Account Plan object to roll up Opportunity 
   public void rollUptoAccountPlan(List<Opportunity> listNewTrigger2){ 
        if(FS_Utility.runaccPlanOnce()){
         Integer opportunity_Gain = 0;
         Integer opportunity_Potential=0;
         Integer record_Count;
         List<Id> listAccPlanId = new List<Id>();
         List<FS_Account_Plan__c> accPlanList = new List<FS_Account_Plan__C>();
         List<FS_Account_Plan__c> accPlanToUpdate = new List<FS_Account_Plan__C>();
         List<Opportunity> oppList = new List<Opportunity>();
         for(Opportunity opp : listNewTrigger2){
              if(opp.Account_Plan__c !=null){
                  listAccPlanId.add(opp.Account_Plan__c);
              }
            }
        //Get Accoun Plan deatils where associated opportunities have been modified
        //accPlanList=[select id,name,FS_Opportunity_Gain__c,FS_No_of_Opportunities__c,FS_Opportunity_Amount__c from FS_Account_Plan__c where id in : listAccPlanId ];
        //oppList=[select id,name,StageName,Amount,Account_Plan__c from Opportunity where Account_Plan__c in :listAccPlanId];
        Map<Id,List<Opportunity>> mapAccPlanOpportunity=New Map<Id,List<Opportunity>>();
        List<Opportunity> tempOppList=new List<Opportunity>();
            for(Opportunity opp : [select id,name,StageName,Amount,Account_Plan__c from Opportunity where Account_Plan__c in :listAccPlanId]){
              tempOppList=new List<Opportunity>();
                If(mapAccPlanOpportunity.containsKey(opp.Account_Plan__c)){
                   tempOppList=mapAccPlanOpportunity.get(Opp.Account_Plan__c);
                }
              tempOppList.add(Opp);
              mapAccPlanOpportunity.put(Opp.Account_Plan__c, tempOppList);
            }
        //Roll up opportunity details up to account plan object
        for(FS_Account_Plan__c accPlan : [select id,name,FS_Opportunity_Gain__c,FS_No_of_Opportunities__c,FS_Opportunity_Amount__c from FS_Account_Plan__c where id in : listAccPlanId ])
        {
            opportunity_Gain=0;            
            opportunity_Potential=0;
            record_Count=0;
            tempOppList=new List<Opportunity>();
            tempOppList=MapAccPlanOpportunity.get(AccPlan.Id);           
             for(Opportunity opp : tempOppList)
             {
                 if(opp.amount !=null){
                 record_Count=record_Count+1;
                 if(opp.StageName.equals(STATUS_CLOSED_WON) || opp.StageName.equals(STATUS_WON)){
                 opportunity_Gain=opportunity_Gain+Integer.valueOf(opp.Amount);
                 }
                 if(opp.StageName!='STATUS_CLOSED_LOST'){
                  opportunity_Potential=opportunity_Potential+Integer.valueOf(opp.Amount); 
                 }
                 }
                }
            //Update roll up fields on account plan object
            accPlan.FS_Opportunity_Gain__c=Opportunity_Gain;
            accPlan.FS_No_of_Opportunities__c=Record_Count;
            accPlan.FS_Opportunity_Amount__c=Opportunity_Potential;
            accPlanToUpdate.add(accPlan);            
         }
            try{
              if(!accPlanToUpdate.isEmpty()){
                 update(accPlanToUpdate);
              }
          }
          Catch(DmlException e){
              System.debug( 'The following exception has occurred: '+e.getMessage() );
              ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_OpportunityHelper', 'UpdateOppField', e.getMessage(), e, null, null, null, 0,'Food Solution');
          }
        
        }
}
/* * Method rollUptoDefinedObjective to update roll up fields on defined objective record
*  @name rollUptoDefinedObjective
*  @param List<Opportunity> listNewTrigger2
*  @return 
*  @throws 
*/
    public void rollUptoDefinedObjective(List<Opportunity> listNewTrigger2){ 
        if(FS_Utility.runObjOnce()){
         List<Id> listObjId = new List<Id>();
         Integer gross_Amount;
         Integer record_Count;
         List<FS_Defined_Objective__c> objList = new List<FS_Defined_Objective__c>();
         List<FS_Defined_Objective__c> objToUpdate = new List<FS_Defined_Objective__c>();
         List<Opportunity> oppList = new List<Opportunity>();
         for(Opportunity opp : listNewTrigger2){
              if(opp.Defined_Objective__c !=null){
                  listObjId.add(opp.Defined_Objective__c);
              }
            }
        //Get Accoun Plan deatils where associated opportunities have been modified
        ObjList=[select id,name,FS_No_of_Opportunities__c from FS_Defined_Objective__c where id in : listObjId];
        //OppList=[select id,name,StageName,Amount,Defined_Objective__c from Opportunity where defined_objective__C in :listObjId];
        Map<Id,List<Opportunity>> mapObjOpportunity=New Map<Id,List<Opportunity>>();
        List<Opportunity> tempOppList=new List<Opportunity>();
            for(Opportunity Opp : [select id,name,StageName,Amount,Defined_Objective__c from Opportunity where defined_objective__C in :listObjId]){
              tempOppList=new List<Opportunity>();
                If(mapObjOpportunity.containsKey(Opp.Defined_Objective__c)){
                   tempOppList=mapObjOpportunity.get(Opp.Defined_Objective__c);
                }
              tempOppList.add(Opp);
              mapObjOpportunity.put(Opp.Defined_Objective__c, tempOppList);
            }
        //Roll up opportunity details up to account plan object        
        for(FS_Defined_Objective__c Obj : [select id,name,FS_No_of_Opportunities__c from FS_Defined_Objective__c where id in : listObjId] )
        {
            gross_Amount=0;
            record_Count=0;
            tempOppList=new List<Opportunity>();
            tempOppList=MapObjOpportunity.get(Obj.Id);
            //Update total no of opportunities on defined objective
            for(Opportunity opp : tempOppList){                
                  record_Count=record_Count+1;
                  If(opp.amount !=null && opp.StageName!=STATUS_CLOSED_LOST){
                  gross_Amount=gross_Amount+Integer.valueOf(opp.Amount);                  
                 }
             }            
            obj.FS_No_of_Opportunities__c=record_Count;
            obj.FS_Opportunity_Amount__c=gross_Amount;
            objToUpdate.add(obj);            
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
/* * Method copyLineItemToExistingOpp for MABE process to copy line item ,create contract product
*  @name copyLineItemToExistingOpp
*  @param List<Opportunity> listNewTrigger,Map<id,Opportunity> OppOldMap
*  @return 
*  @throws 
*/
    public void copyLineItemToExistingOpp(List<Opportunity> listNewTrigger,Map<id,Opportunity> OppOldMap){ 
      //To avoid recurson in trigger used static variable NAFS_Utility.runOnce
      //if(FS_Utility.runOnce()){          
          List<Id> listOppId = new List<Id>();
          List<Id> listAccountId= new List<Id>();
          List<Opportunity> tempOppList=new List<Opportunity>();
          List<Opportunity> listNewOpportunity=new List<Opportunity>();//List of opportunities which marked as 'Closed Won'
          List<Opportunity> listExistingOpportunity=new List<Opportunity>();//List of Existing opportunities associated with closed New opportunities
          List<OpportunityLineItem> listExistingOppLineItem = new List<OpportunityLineItem>();//List of line items for existing opportunities
          List<OpportunityLineItem> listNewOppLineItem = new List<OpportunityLineItem>();//List of line items created for New opportunities
          List<OpportunityLineItem> oppLineItemToInsert = new List<OpportunityLineItem>();//Opporutnity line item to be created for existing opportunties
          List<OpportunityLineItem> oppLineItemforExisting = new List<OpportunityLineItem>();//Temporary variable used in loop for each existing opportunity
          List<OpportunityLineItem> oppLineItemToUpdate = new List<OpportunityLineItem>();//Opportunity line items to be updated
          List<OpportunityLineItem> oppLineItemUpsert = new List<OpportunityLineItem>();//Opportunity line items that are updated   
          List<Contract_Product__c>  listNewContractProduct=new  List<Contract_Product__c>();
          List<Contract_Product__c>  listExistingContractProduct=new  List<Contract_Product__c>();
          List<Contract_Product__c>  listContractProductInsert=new  List<Contract_Product__c>(); 
          List<Contract_Product__c>  listContractProductUpdate=new  List<Contract_Product__c>();
          Set<Id> listExistingOli=new Set<Id>();
          Set<Id> listPriceBookEntry=new Set<Id>();
          Set<Id> setContractId=new Set<Id>();
          Set<Id> setProductId=new Set<Id>();
          Set<Id> setoppLineItemUpsert=new Set<Id>();
          Map<Id,List<Opportunity>> mapRelatedOpportunity=new Map<Id,List<Opportunity>>();
          Map<Id,List<OpportunityLineItem>> mapRelatedOppLineItem=new Map<Id,List<OpportunityLineItem>>();
          Map<Id,List<OpportunityLineItem>> mapRelatedExistingOppLineItem=new Map<Id,List<OpportunityLineItem>>();
          Map<Id,List<OpportunityLineItem>> mapRelatedNewOppLineItem=new Map<Id,List<OpportunityLineItem>>();
          
          Integer total_Quantity;
          Integer total_Price;
          Integer unit_Price;
          Integer existing_Oli_Flag;
          Integer existing_Contract_Product_Flag;
          Id oliId;      
        
          OpportunityLineItem oppLineItem=new OpportunityLineItem();
          List<OpportunityLineItem> tempOppLineItemList=new List<OpportunityLineItem>();
          List<FS_Contract_Product_Opportunity_Map__c> listNewCustomSetting=New List<FS_Contract_Product_Opportunity_Map__c>();
          //Get record type ids for Existing and MA-BE
          Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity with Pricing (MA-BE)').getRecordTypeId();
          Id existingRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Existing').getRecordTypeId();
                
          for(Opportunity opp : listNewTrigger){
              //Check if stage has been changed to Closed Won for New opportunities
              if(OppOldMap.get(opp.id).stagename!=opp.stagename && opp.StageName.equals(STATUS_WON) && opp.recordtypeid==newRecordTypeId && opp.ContractId!=Null){               
                 listNewOpportunity.add(opp);
                 //system.debug(ListNewOpportunity);
                 listAccountId.add(opp.AccountId);
                 setContractId.add(opp.ContractId);
              }             
           }
          
          if(!listNewOpportunity.isEmpty()){
              listExistingOpportunity=[select id,stagename,accountid,ContractId from Opportunity where recordtypeid=:existingRecordTypeId and accountid in :listAccountId limit 49999];
              listExistingOppLineItem = [select Id,opportunityId,Quantity,TotalPrice,PricebookentryId,Distributor__c,
                                         Product2Id,Opportunity.contractId,Contract_Product__c
                                         from OpportunityLineItem where opportunityId in : listExistingOpportunity limit 49999];              
              }          
              
            Map<Id,OpportunityLineItem> mapListExistingOppLineItem=new Map<Id,OpportunityLineItem>(listExistingOppLineItem);
            
            //Create Map between New Closed Opportunity and corresponding line items
            For(OpportunityLineItem oli: [select Id,opportunityId,Quantity,TotalPrice,PricebookentryId,Distributor__c,UnitPrice,
                                          ListPrice,GrossProfit__c,FS_MarketTarget__c,Discount,FS_Sample__c,
                                          Product2Id,Product2.name,Opportunity.contractId,Pricebookentry.Product2Id,Contract_Product__c 
                                          from OpportunityLineItem where opportunityId in :listNewOpportunity limit 49999]){
              tempOppLineItemList=new List<OpportunityLineItem>();
              if(mapRelatedOppLineItem.containskey(oli.Opportunity.contractId))
                    {
                        tempOppLineItemList=mapRelatedOppLineItem.get(oli.Opportunity.contractId);
                    }               
                    tempOppLineItemList.add(oli);
                    mapRelatedOppLineItem.put(oli.Opportunity.contractId,tempOppLineItemList);
               }             
             //Create Map between Contract and related New Closed Opportunities
              List<Opportunity> tempOpportunityList=new List<Opportunity>();       
              Map<Id,List<OpportunityLineItem>> mapExistingOppLineItemOpportunity=new Map<Id,List<OpportunityLineItem>>();
              
              //Create Map between Existing Opportunity and related line items which already exists
              For(OpportunityLineItem oli: [select Id,opportunityId,Quantity,TotalPrice,PricebookentryId,Distributor__c,
                                         Product2Id,Opportunity.contractId,Contract_Product__c
                                         from OpportunityLineItem where opportunityId in :ListExistingOpportunity limit 49999]){
                tempOppLineItemList=new List<OpportunityLineItem>();
                //system.debug(oli.Opportunity.contractId);
                if(mapExistingOppLineItemOpportunity.containskey(oli.Opportunity.contractId))
                    {
                        tempOppLineItemList=mapExistingOppLineItemOpportunity.get(oli.Opportunity.contractId);
                    }               
                    tempOppLineItemList.add(oli);
                    //system.debug(tempOppLineItemList);
                    mapExistingOppLineItemOpportunity.put(oli.Opportunity.contractId,tempOppLineItemList);
               }             
              //Open loop for each existing opportunity
              For(Opportunity existingOpp : [select id,stagename,accountid,ContractId 
                                             from Opportunity where recordtypeid=:existingRecordTypeId 
                                             and contractid in :setContractId limit 49999]){
              oppLineItemforExisting = new List<OpportunityLineItem>();
              tempOppLineItemList = new List<OpportunityLineItem>();
              ListPriceBookEntry=new Set<Id>();                    
                     //Get related line items for new opportunity
                     If(mapRelatedOppLineItem.containsKey(existingOpp.ContractId) && existingOpp.ContractId!=Null){
                     tempOppLineItemList=mapRelatedOppLineItem.get(existingOpp.ContractId);
                     //system.debug(tempOppLineItemList);                  
                      For(OpportunityLineItem oli: tempOppLineItemList ){                      
                      //Create list of opportunity line items to be created for existing opportunties
                      oppLineItemforExisting.add(new OpportunityLineItem(Opportunityid = existingOpp.Id,
                                                                         PricebookentryId =oli.PricebookentryId,quantity=oli.Quantity,
                                                                         totalPrice=oli.TotalPrice,Distributor__c=oli.Distributor__c,                                                                                                                                               
                                                                         Discount=oli.Discount,FS_Sample__c=oli.FS_Sample__c));
                      //Create list of contract product to created on contract for current Existing opportunity
                      listNewContractProduct.add(new Contract_Product__c(contract__c=existingOpp.ContractId,Product__c=oli.Product2Id,name=String.valueof(oli.Product2.name)));
                      listPriceBookEntry.add(oli.PricebookentryId);                      
                  }//End of For loop for line item 
                  }
                  
                  //Open loop for each price book entry for which line items needs to be created on existing opportunity
                    For(Id Pbe : listPriceBookEntry){
                    total_Quantity=0;
                    total_Price=0;
                    existing_Oli_Flag=0;                    
                        If(mapExistingOppLineItemOpportunity.containsKey(existingOpp.ContractId))
                        {                         
                        //Open loop for line items which already exist for current Existing Opportunity
                        for(OpportunityLineItem existingOli : mapExistingOppLineItemOpportunity.get(existingOpp.ContractId))
                        {
                        //Check if new opportunity having line item for this price book entry
                        If(existingOli.pricebookentryid==pbe){                  
                        total_Quantity=Integer.Valueof(existingOli.Quantity);
                        total_Price=Integer.Valueof(existingOli.TotalPrice);    
                        existing_Oli_Flag=1;
                        oliId=existingOli.id;                        
                        }
                        } 
                        }//If closed
                    
                    for(OpportunityLineItem oli : oppLineItemforExisting){//For 1                        
                        if(oli.pricebookentryid==Pbe){
                            total_Quantity=total_Quantity+Integer.Valueof(oli.Quantity);
                            total_Price=total_Price+Integer.Valueof(oli.TotalPrice);                            
                        }
                    }//For 1                    
                    if(existing_Oli_Flag==0){
                    //Preparing list for Insert
                    oppLineItemToInsert.add(new OpportunityLineItem(Opportunityid = existingOpp.Id,
                                                                         PriceBookEntryId=Pbe,quantity=total_Quantity,
                                                                         TotalPrice=total_Price));
                    setoppLineItemUpsert.add(existingOpp.Id);                                         
                    }
                          //Prepare list for update
                          if(existing_Oli_Flag>0){
                          //Preparing list for update
                          oppLineItem=new OpportunityLineItem();
                          oppLineItem=mapListExistingOppLineItem.get(oliId);
                          oppLineItem.quantity=total_Quantity;
                          oppLineItem.TotalPrice=total_Price;
                          oppLineItemToUpdate.add(oppLineItem);                          
                        }                   
                    }
    }//End loop for Existing opportunities          
        
        Map<Id,List<Contract_Product__c>> mapExistingContractConProd=new Map<Id,List<Contract_Product__c>>();
        List<Contract_Product__c> tempExistingConProductList=new List<Contract_Product__c>();
        for(Contract_Product__c newContractProduct : [select id,Contract__c,Product__c,Product__r.Name from Contract_Product__c where Contract__c in : SetContractId limit 49999])
        {
            tempExistingConProductList  = new List<Contract_Product__c>();
            if(mapExistingContractConProd.containskey(newContractProduct.Contract__c))
                    {
                        tempExistingConProductList   = mapExistingContractConProd.get(newContractProduct.Contract__c);
                    }
                    tempExistingConProductList.add(newContractProduct);
                    mapExistingContractConProd.put(newContractProduct.Contract__c,tempExistingConProductList);            
        }
        
        List<Contract_Product__c> tempConProductList=new List<Contract_Product__c>();
        for(Contract_Product__c newContractProduct : ListNewContractProduct)
        {
            tempConProductList  = new List<Contract_Product__c>();
            existing_Contract_Product_Flag=0;
            if(mapExistingContractConProd.containskey(newContractProduct.Contract__c)){
            tempConProductList=mapExistingContractConProd.get(newContractProduct.Contract__c);                               
            For(Contract_Product__c existingContractProduct : tempConProductList){
                If(existingContractProduct.product__c==newContractProduct.product__c){
                    existing_Contract_Product_Flag=1;
                    listContractProductUpdate.add(existingContractProduct);
                    Break;
                }                
            }
            }
                if(existing_Contract_Product_Flag==0)
                    {           
                    listContractProductInsert.add(newContractProduct);
                    tempConProductList  = new List<Contract_Product__c>();
                    If(mapExistingContractConProd.containsKey(newContractProduct.Contract__c)){                        
                    tempConProductList = mapExistingContractConProd.get(newContractProduct.Contract__c);
                    }
                    tempConProductList.add(newContractProduct);
                    mapExistingContractConProd.put(newContractProduct.Contract__c,tempConProductList);                    
                    } 
            }        
        //Set up Map between Contract and corresponding contract product which already exists        
              try{              
              if(!oppLineItemToInsert.isEmpty()){
                  insert oppLineItemToInsert;
              }
              if(!oppLineItemToUpdate.isEmpty()){
                  update oppLineItemToUpdate;
              }
              If(!listContractProductInsert.isEmpty()){
                insert ListContractProductInsert;
              }                  
              }           
          Catch(DmlException e){
              System.debug( 'The following exception has occurred: '+e.getMessage() );
              ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_OpportunityHelper', 'MA-BE Process', e.getMessage(), e, null, null, null, 0,'Food Solution');
          } 
       
        oppLineItemUpsert=[select Id,opportunityId,Quantity,TotalPrice,PricebookentryId,
                           Distributor__c,UnitPrice,ListPrice,GrossProfit__c,FS_MarketTarget__c,
                           Discount,FS_Sample__c,Product2Id,Product2.name,Opportunity.contractId,Pricebookentry.Product2Id,Contract_Product__c
                           from OpportunityLineItem where opportunityId in : setoppLineItemUpsert limit 49999];        
              
        Map<Id,List<Contract_Product__c>> mapContractConProd=new Map<Id,List<Contract_Product__c>>();       
                
        for(Contract_Product__c newContractProduct : [select id,Contract__c,Product__c,Product__r.Name from Contract_Product__c where Contract__c in : SetContractId limit 49999])
        {
            tempConProductList  = new List<Contract_Product__c>();            
            if(mapContractConProd.containskey(newContractProduct.Contract__c))
                    {
                        tempConProductList=mapContractConProd.get(newContractProduct.Contract__c);
                    }
                    tempConProductList.add(newContractProduct);
                    mapContractConProd.put(newContractProduct.Contract__c,tempConProductList);          
        }
        oppLineItemToUpdate=new List<OpportunityLineItem>();
        
        For(opportunityLineItem oli: oppLineItemUpsert){
            
            If(oli.Contract_Product__c==null){
                tempConProductList=new List<Contract_Product__c>();
                tempConProductList=MapContractConProd.get(oli.Opportunity.contractId);
                
            For(Contract_Product__c newContractProduct : tempConProductList){
                
                IF(oli.Pricebookentry.Product2Id==newContractProduct.Product__c){
                    oli.Contract_Product__c=newContractProduct.Id;
                    oppLineItemToUpdate.add(oli);                    
                    Break;
                }                
            }                          
        }//End if for contract product on oli        
        }
    //Create custom settings for monthly claimed case calculation        
    For(Contract_Product__c ConProd : ListContractProductUpdate){
        tempOppLineItemList=new List<OpportunityLineItem>();
        tempOppLineItemList=MapRelatedOppLineItem.get(ConProd.Contract__c);  
        For(OpportunityLineItem Oli : tempOppLineItemList){
            If(Oli.Product2Id==ConProd.Product__c){              
              listNewCustomsetting.add(New FS_Contract_Product_Opportunity_Map__c(Name=String.valueof(ConProd.Id),FS_Contract_Product__c=ConProd.Id,FS_Opportunity__c=OLi.OpportunityId));
            }
        }
    }
             try{              
             If(!oppLineItemToUpdate.isEmpty()){
                  update oppLineItemToUpdate;
              }
             If(!listNewCustomSetting.isEmpty()){
                  Insert listNewCustomSetting;                 
              }
             If(!listContractProductUpdate.isEmpty()){
                Update listContractProductUpdate;                
             }
                     
          }
          Catch(DmlException e){
              System.debug( 'The following exception has occurred: '+e.getMessage() );
              ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_OpportunityHelper', 'MA-BE Process', e.getMessage(), e, null, null, null, 0,'Food Solution');
          }
      }//End of method for MA-BE
      
      public void validateOpportunity(List<Opportunity> listOpp){
          List<Opportunity> existingOppId = new List<Opportunity>();
          List<Id> listAccId = new List<Id>();
          List<Id> listConId = new list<Id>();
          Map<Id,Opportunity> mapAccOpp= new Map<Id,Opportunity>();
          Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Existing').getRecordTypeId();
          for(Opportunity opp: listOpp){
              if(opp.RecordTypeId==oppRecordTypeId){
                  listAccId.add(opp.AccountId);
                  listConId.add(opp.ContractId);
                  mapAccOpp.put(opp.AccountId, opp);
              }
          }
          if(listAccId.size()>0){
              existingOppId = [Select ID, AccountId from Opportunity where RecordTypeId =: oppRecordTypeId and AccountId =: listAccId and ContractId =: listConId];
              for(Opportunity opp :existingOppId){
                  if(mapAccOpp.get(opp.AccountId) != null){
                      mapAccOpp.get(opp.AccountId).addError('Only one Existing type of Opportunity allowed for the same Account and Contract');
                  }
              }
              
          }
      }
}