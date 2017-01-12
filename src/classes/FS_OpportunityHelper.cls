/**********************************************************************
Purpose: Helper class for OpportunityTrigger.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     04/April/2016     Created
25/May/2016       Updated handleOpportunityPackage
01/July/2016      Updated for account planning
***********************************************************************/

public with sharing class FS_OpportunityHelper {
    //Fetch custom settings for opportunity stages
    
    Private string ERROR_MESSAGE='The following exception has occurred: ';
    Private string FOOD_SOLUTION='Food Solution';
    Private string CLASS_NAME='FS_OpportunityHelper';
    Private Map<String, String> recordIdBasedonDeveloperName=FS_Utility.recordTypewithName('Opportunity');
    Private final String FS_ExistingBusiness='FS_ExistingBusiness';
    Private final String FS_OpportunityMABE='FS_OpportunityMABE';
    Private final String FS_OpportunityTPR='FS_OpportunityTPR';
    
/* * Method rollUpOpportunityLineItem to update Opportunity with Opp Line Item Value (Gross Profit and Market Target)
*  @name rollUpOpportunityLineItem
*  @param List<Opportunity> listNewTrigger
*  @return 
*  @throws
*/    
    public void rollUpOpportunityLineItem(List<Opportunity> listNewTrigger){ 
        if(FS_Utility.runOnceOppProduct()){ //To avoid recurson in trigger used static variable NAFS_Utility.runOnce
            List<Id> listOppId = new List<Id>();
            List<String> listPriceBook= new List<String>();
            List<OpportunityLineItem> OppLineItem = new List<OpportunityLineItem>();
            List<Opportunity> oppToUpdate = new List<Opportunity>();
            Map<Id,Decimal> mapOppIdGP= new Map<Id,Decimal>();
            Map<Id,Decimal> mapOppIdMT= new Map<Id,Decimal>();
            Map<Id,Decimal> mapOppIdTurnover= new Map<Id,Decimal>();
            Decimal grossProfit = 0;
            Decimal marketTarget = 0;
            Integer recordCount = 0;
            Decimal averageGrossProfit =0;
            Decimal averageMarketTarget =0;
            Decimal totalTurnoverNA = 0;
            
            for(Opportunity opp : listNewTrigger){
                if(recordIdBasedonDeveloperName.get(FS_ExistingBusiness) == opp.RecordTypeID || recordIdBasedonDeveloperName.get(FS_OpportunityMABE) == opp.RecordTypeID || recordIdBasedonDeveloperName.get(FS_OpportunityTPR) == opp.RecordTypeID )
                {
                listPriceBook.add(opp.pricebook2id);
                listOppId.add(opp.Id);
                }
            }
            
            if(!listOppId.isEmpty() && isEnabled()){  
            
            OppLineItem = [select Id, GPPercent__c, FS_MarketTarget__c, opportunityId, Turnover__c from OpportunityLineItem where opportunityId in :listOppId];
              //Calculate average grossProfit and MarketTarget of all opp prod
            For(Opportunity opp : listNewTrigger){
                For(OpportunityLineItem oli: OppLineItem ){
                    if(opp.id == oli.opportunityId){
                        if(oli.GPPercent__c!= null){
                            grossProfit = grossProfit + oli.GPPercent__c;
                        } 
                        if(oli.FS_MarketTarget__c!= null){   
                            marketTarget = marketTarget + oli.FS_MarketTarget__c;
                        }
                        if(oli.Turnover__c!= null){   
                            totalTurnoverNA = totalTurnoverNA + oli.Turnover__c;
                        }    
                        recordCount = recordCount + 1;
                    } 
                } 
                if(recordCount>0){
                    averageGrossProfit = grossProfit/recordCount;
                    averageMarketTarget = marketTarget/recordCount;
                    mapOppIdGP.put(opp.Id,averageGrossProfit);
                    mapOppIdMT.put(opp.Id,averageMarketTarget);
                    mapOppIdTurnover.put(opp.Id,totalTurnoverNA);
                    recordCount = 0;//resetting the variables
                    GrossProfit = 0;
                    MarketTarget= 0;
                    totalTurnoverNA=0;
                }         
            } 
            List<Opportunity> oppList = [Select Id, FS_AverageGrossProfit__c, FS_MarketTarget__c, FS_TotalTurnoverNA__c from Opportunity where Id in :listOppId];
            for(Opportunity opp : oppList){
                if(mapOppIdGP.get(opp.Id)!=null){
                    opp.FS_AverageGrossProfit__c= mapOppIdGP.get(opp.Id);
                    opp.FS_MarketTarget__c= mapOppIdMT.get(opp.Id);
                    opp.FS_TotalTurnoverNA__c = mapOppIdTurnover.get(opp.Id);
                    oppToUpdate.add(opp);
                }    
            }
            try{
                if(!oppToUpdate.isEmpty()){
                    update oppToUpdate;
                }
            }
            Catch(DmlException e){
                System.debug( ERROR_MESSAGE +e.getMessage() );
                ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(),CLASS_NAME,'UpdateOppField', e.getMessage(), e, null, null, null, 0,FOOD_SOLUTION);
            }
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
    
    boolean varFS_Record=false;
        if(FS_Utility.runaccPlanOnce()){
            Integer opportunity_Gain = 0;
            Integer opportunity_Potential=0;
            Integer record_Count;
            List<Id> listAccPlanId = new List<Id>();         
            List<FS_Account_Plan__c> accPlanToUpdate = new List<FS_Account_Plan__C>();         
            for(Opportunity opp : listNewTrigger2){
            if(recordIdBasedonDeveloperName.get(FS_ExistingBusiness) == opp.RecordTypeID || recordIdBasedonDeveloperName.get(FS_OpportunityMABE) == opp.RecordTypeID || recordIdBasedonDeveloperName.get(FS_OpportunityTPR) == opp.RecordTypeID )
                {
                varFS_Record =true;
                if(opp.Account_Plan__c !=null){
                    listAccPlanId.add(opp.Account_Plan__c);
                }
              }
            }
            
            
            if(varFS_Record && isEnabled())
            {
           
            FS_OpportunityStages__c oppStages=FS_OpportunityStages__c.getInstance('FS_Stages');    
            string STATUS_CLOSED_LOST=oppStages.FS_Stage_Closed__c;    
            //Get Accoun Plan deatils where associated opportunities that have been modified        
            Map<Id,List<Opportunity>> mapAccPlanOpportunity=New Map<Id,List<Opportunity>>();
            List<Opportunity> tempOppList=new List<Opportunity>();
            for(Opportunity opp : [select id,name,StageName,Amount,Account_Plan__c,isWon,isClosed from Opportunity where Account_Plan__c in :listAccPlanId]){
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
                tempOppList=mapAccPlanOpportunity.get(AccPlan.Id);           
                for(Opportunity opp : tempOppList)
                {                    
                    if(opp.amount !=null){
                        record_Count=record_Count+1;
                        //If opportunity stage is Won then add amount to Gain on account plan                        
                        if(opp.isWon){
                            opportunity_Gain=opportunity_Gain+Integer.valueOf(opp.Amount);
                        }
                        //If opportunity stage is not eual to Closed as amount to potential on account plan
                        if(opp.stagename!=STATUS_CLOSED_LOST){
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
                System.debug( ERROR_MESSAGE +e.getMessage() );
                ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(),CLASS_NAME,'UpdateOppField', e.getMessage(), e, null, null, null, 0,FOOD_SOLUTION);
            }
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
     boolean varFS_Record=false;
        if(FS_Utility.runObjOnce()){
            List<Id> listObjId = new List<Id>();
            Integer gross_Amount;
            Integer record_Count;         
            List<FS_Defined_Objective__c> objToUpdate = new List<FS_Defined_Objective__c>();         
            for(Opportunity opp : listNewTrigger2){
             if(recordIdBasedonDeveloperName.get(FS_ExistingBusiness) == opp.RecordTypeID || recordIdBasedonDeveloperName.get(FS_OpportunityMABE) == opp.RecordTypeID || recordIdBasedonDeveloperName.get(FS_OpportunityTPR) == opp.RecordTypeID )
                {
                  varFS_Record=true;
                if(opp.Defined_Objective__c !=null){
                    listObjId.add(opp.Defined_Objective__c);
                }
              }
            } 
            
            if(varFS_Record && isEnabled())
            {
           
            FS_OpportunityStages__c oppStages=FS_OpportunityStages__c.getInstance('FS_Stages');    
            string STATUS_CLOSED_LOST=oppStages.FS_Stage_Closed__c;    
            //Get Accoun Plan deatils where associated opportunities have been modified        
            Map<Id,List<Opportunity>> mapObjOpportunity=New Map<Id,List<Opportunity>>();
            List<Opportunity> tempOppList=new List<Opportunity>();
            for(Opportunity Opp : [select id,name,StageName,Amount,Defined_Objective__c,isClosed from Opportunity where defined_objective__C in :listObjId]){
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
                    If(opp.amount !=null){
                        record_Count=record_Count+1;
                        If(opp.stagename!=STATUS_CLOSED_LOST){
                            gross_Amount=gross_Amount+Integer.valueOf(opp.Amount);                  
                        } 
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
                System.debug( ERROR_MESSAGE +e.getMessage() );
                ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(),CLASS_NAME,'UpdateOppField', e.getMessage(), e, null, null, null, 0,FOOD_SOLUTION);
            } 
           }        
       } 
    }
    /* * Method copyLineItemToExistingOpp for MABE process to copy line item ,create contract product
*  @name copyLineItemToExistingOpp
*  @param List<Opportunity> listNewTrigger,Map<id,Opportunity> OppOldMap
*  @return 
*  @throws 
*/
    public void copyLineItemToExistingOpp(List<Opportunity> listNewTrigger,Map<id,Opportunity> oppOldMap){              
        
        List<Opportunity> listNewOpportunity=new List<Opportunity>();//List of opportunities which marked as 'Closed Won'
        List<Opportunity> listExistingOpportunity=new List<Opportunity>();//List of Existing opportunities associated with closed New opportunities
        List<OpportunityLineItem> listExistingOppLineItem = new List<OpportunityLineItem>();//List of line items for existing opportunities       
        List<OpportunityLineItem> oppLineItemforExisting = new List<OpportunityLineItem>();//Temporary variable used in loop for each existing opportunity
        List<OpportunityLineItem> oppLineItemToUpdate = new List<OpportunityLineItem>();//Opportunity line items to be updated
        List<OpportunityLineItem> oppLineItemUpsert = new List<OpportunityLineItem>();//Opportunity line items that are updated               
        List<Contract_Product__c>  listContractProductInsert=new  List<Contract_Product__c>(); 
        List<Contract_Product__c>  listContractProductUpdate=new  List<Contract_Product__c>();        
        List<Opportunity> listNewOpp = new List<Opportunity>();
        List<Contract_Product__c> contractProductList=new List<Contract_Product__c>();
        List<Contract_Product__c> listContractProduct=new List<Contract_Product__c>();        
        List<FS_Contract_Product_Opportunity_Map__c> listNewCustomSetting=New List<FS_Contract_Product_Opportunity_Map__c>();
        List<Opportunity> listOpp=new List<Opportunity>();
        //List<OpportunityLineItem> tempOli = new List<OpportunityLineItem>();
        
        Set<Id> setContractId=new Set<Id>();       
        
        Map<Id,List<OpportunityLineItem>> mapRelatedOppLineItem=new Map<Id,List<OpportunityLineItem>>();        
        Map<Id,List<OpportunityLineItem>> mapContractRelatedOppLineItem=new Map<Id,List<OpportunityLineItem>>();
        Map<Id,List<Contract_Product__c>> mapExistingContractConProd=new Map<Id,List<Contract_Product__c>>();
        Map<Id,List<Contract_Product__c>> mapContractConProd=new Map<Id,List<Contract_Product__c>>();    
        
        //Get record type ids for Existing and MA-BE        
        
        Id newRecordTypeId=recordIdBasedonDeveloperName.get('FS_OpportunityMABE');
        Id existingRecordTypeId=recordIdBasedonDeveloperName.get('FS_ExistingBusiness');
        
        //Id newRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType='Opportunity' and DeveloperName = 'NAFSMABETool'].Id;
        //Id existingRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType='Opportunity' and DeveloperName = 'Existing'].Id;       
        
        FS_UtilMABETool utilMabe=new FS_UtilMABETool();//create new instance for MABE util class
        
        listNewOpportunity=utilMabe.getNewClosedOpportunity(listNewTrigger,oppOldMap,newRecordTypeId);//Get list of opportunities with New record type which has been closed          
        
        if(!listNewOpportunity.isEmpty() && isEnabled()){
       
            setContractId=utilMabe.getContractList(listNewOpportunity);//Get list of contracts for closed opportunities           
            //Get list of oppotunities with Existing recordtype
            listExistingOpportunity=[select id,stagename,accountid,ContractId from Opportunity where recordtypeid=:existingRecordTypeId and contractId in :setContractId];
            //Add both existing and closed new opportunities to one list
            listOpp.addAll(listNewOpportunity);
            listOpp.addAll(listExistingOpportunity);
            //Get list of line items for Opportunities with both Existing and New
            listExistingOppLineItem = [select Id,opportunityId,Quantity,TotalPrice,PricebookentryId,Distributor__c,
                                       Product2Id,Opportunity.contractId,Contract_Product__c,Product2.Name
                                       from OpportunityLineItem where opportunityId in :listOpp];
                   
        
        mapRelatedOppLineItem=utilMabe.createMapOliOpp(listExistingOppLineItem);//Create map of opportunity line items for each existing and new opportunity
        //Create map of opportunity line item for each contract associated with closed new opportunity
        mapContractRelatedOppLineItem=utilMabe.createMapOliOppContract([select Id,opportunityId,Quantity,TotalPrice,PricebookentryId,Distributor__c,                                                                  Product2Id,Opportunity.contractId,Contract_Product__c
                                                                        from OpportunityLineItem where opportunityId in :listNewOpportunity]);
        //Get list of contract product which already exists
        contractProductList=[select id,Contract__c,Product__c,Product__r.Name from Contract_Product__c where Contract__c in : setContractId];
        //Create map for contract product with associated contracts
        mapExistingContractConProd=utilMABE.getMapExistingConProduct(contractProductList);
        
        //Open loop for each existing opportunity        
        For(Opportunity existingOpp : listExistingOpportunity){                
            listNewOpp = new List<Opportunity>();                           
            listNewOpp=utilMabe.getRelatedNewOpp(existingOpp,listNewOpportunity);  //Get related new opportunities                         
            oppLineItemforExisting.addall(utilMabe.getOlifromNewOpp(existingOpp,listNewOpp,mapRelatedOppLineItem));//Add list of line items to list for upsert          
            listContractProduct.addall(utilMABE.getContractProduct(existingOpp,listNewOpp,mapRelatedOppLineItem));//Get list of contract product to be created           
        }          
        
        listContractProductInsert.addall(utilMABE.getContractProductInsert(listContractProduct,mapExistingContractConProd));//Get list of contract product to insert
        
        listContractProductUpdate.addall(utilMABE.getContractProductUpdate(listContractProduct,mapExistingContractConProd));//Get list of contract product to update
        
        try{              
            If(!oppLineItemforExisting.isEmpty() && listContractProductInsert.isEmpty()){                    
                Upsert oppLineItemforExisting;//Insert line items for opportunity with Existing record type
            }            
            Else If(!oppLineItemforExisting.isEmpty()&&!listContractProductInsert.isEmpty()){
                Upsert oppLineItemforExisting;//Insert line items for opportunity with Existing record type
                Insert listContractProductInsert;//Insert contract product
            }                  
        }
        
        Catch(DmlException e){
            System.debug( ERROR_MESSAGE +e.getMessage() );
            ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(),CLASS_NAME,'MA-BE Process', e.getMessage(), e, null, null, null, 0,FOOD_SOLUTION);
        } 
        
        //**Contract product has to be mapped on opportunity line items which has just been created for existing Opportunity**//        
        //Fetch list of line items which have been copied to opportunity with Existing record type
        oppLineItemUpsert=[select Id,opportunityId,Product2Id,Product2.name,Opportunity.contractId,Contract_Product__c,Pricebookentry.Product2Id from OpportunityLineItem where opportunityId in : listExistingOpportunity];          
        
        listContractProduct=[select id,Contract__c,Product__c,Product__r.Name from Contract_Product__c where Contract__c in : SetContractId];//Fetch contract products
        
        mapContractConProd=utilMABE.getMapExistingConProduct(listcontractProduct);//Prepare map for contract products for each contract
        
        oppLineItemToUpdate=utilMABE.getOlitoUpdate(oppLineItemUpsert,mapContractConProd);//Prepare list on opportunity line item to look up on contract product  
        
        listNewCustomsetting=utilMABE.getCustomSetting(listContractProductUpdate,mapContractRelatedOppLineItem);//Prepare list of custom settings to insert for monthly claim cases creation         
        
        //**Custom settings data has been prepared**//        
        try{              
            If(!oppLineItemToUpdate.isEmpty()){                    
                update oppLineItemToUpdate;//Update line items to look up on contract product
            }                
            If(!listContractProductUpdate.isEmpty()){
                Insert listNewCustomsetting;//Insert custom settings for monthly claim case calculation                    
                Update listContractProductUpdate;//Update contract product which already exists but monthly claim cases need to be re calculated                
            }            
        }        
        Catch(DmlException e){
            System.debug( ERROR_MESSAGE +e.getMessage() );
            ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(),CLASS_NAME,'MA-BE Process', e.getMessage(), e, null, null, null, 0,FOOD_SOLUTION);
        } 
      }        
    }
    
    public void validateOpportunity(List<Opportunity> listOpp){
        List<Opportunity> existingOppId = new List<Opportunity>();
        List<Id> listAccId = new List<Id>();
        List<Id> listConId = new list<Id>();
        Map<Id,Opportunity> mapAccOpp= new Map<Id,Opportunity>();
        //Map<String, String> recordIdBasedonDeveloperName=FS_Utility.recordTypewithName('Opportunity');        
        Id oppRecordTypeId=recordIdBasedonDeveloperName.get(FS_ExistingBusiness);         
        for(Opportunity opp: listOpp){
            if(opp.RecordTypeId==oppRecordTypeId){
                listAccId.add(opp.AccountId);
                listConId.add(opp.ContractId);
                mapAccOpp.put(opp.AccountId, opp);
            }
        }
        if(listAccId.size()>0 && isEnabled()){
         
           
            existingOppId = [Select ID, AccountId from Opportunity where RecordTypeId =: oppRecordTypeId and AccountId =: listAccId and ContractId =: listConId];
            for(Opportunity opp :existingOppId){
                if(mapAccOpp.get(opp.AccountId) != null){
                    mapAccOpp.get(opp.AccountId).addError('Only one Existing type of Opportunity allowed for the same Account and Contract');
                }
            }  
         }
    }
    
    Private boolean isEnabled()
    {
    //Check 'NAFS Opportunity Trigger Settings'in custom settings. If enabled then call the method
            FSOpportunityTriggerSettings__c Settings=FSOpportunityTriggerSettings__c.getinstance('isEnabled');
            if(Settings!=null)
            {
            return Settings.Enabled__c;
            }
            else 
            return False;
    }
}