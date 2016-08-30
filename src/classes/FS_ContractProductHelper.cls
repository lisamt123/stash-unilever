/**********************************************************************
Purpose: Helper Class of Contract Product Trigger.
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    12/Jul/2016     Draft                     
***********************************************************************/
public class FS_ContractProductHelper {
    public void createClaimedCases(List<Contract_Product__c> ContractProdList){
        List<ID> ConProIdList = new List<ID>();
        List<ID> ProductIdList = new List<ID>();
        List<ID> ContractIdList = new List<ID>();
        List<Opportunity> OppList=new List<Opportunity>();
        List<OpportunityLineItem> OLIList=new List<OpportunityLineItem>();
        List<FS_Monthly_Claimed_Cases__c> MCCList = new List<FS_Monthly_Claimed_Cases__c>();
        List<OpportunityLineItemSchedule> ScheduleList = new List<OpportunityLineItemSchedule>();
        
        For(Contract_Product__c cp : ContractProdList){
            ConProIdList.add(cp.Id);
            ContractIdList.add(cp.Contract__c);
            ProductIdList.add(cp.Product__c);
        }
        
        Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity with Pricing (MA-BE)').getRecordTypeId();
        OppList = [SELECT Id FROM Opportunity WHERE RecordTypeId =:newRecordTypeId and isWOn = true and ContractId in : ContractIdList];
        system.debug('OppList -->'+OppList ); 
        OLIList = [select id, Opportunity.AccountId, Product2Id, Contract_Product__c from OpportunityLineItem where OpportunityId in : OppList and Product2Id in : ProductIdList];
        ScheduleList = [SELECT OpportunityLineItemId,Quantity,ScheduleDate FROM OpportunityLineItemSchedule where OpportunityLineItemId in : OLIList AND Quantity > 0];
        
        for(OpportunityLineItem oli : OLIList){
            for(Contract_Product__c conPro : ContractProdList){
                if(oli.Product2Id == conPro.Product__c){
                    for(OpportunityLineItemSchedule Schedule : ScheduleList){
                        if(oli.Id == Schedule.OpportunityLineItemId){
                            FS_Monthly_Claimed_Cases__c mccObj = new FS_Monthly_Claimed_Cases__c ();
                            mccObj.Account__c = oli.Opportunity.AccountId;
                            mccObj.Contract_Product__c = conPro.Id;
                            mccObj.FS_Planned_Quantity__c = Schedule.Quantity;
                            mccObj.Product__c = oli.Product2Id;
                            mccObj.FS_First_of_Month__c= (Schedule.ScheduleDate).toStartOfMonth();
                            MCCList.add(mccObj);
                        }
                    }        
                }
            }    
        }
        system.debug('Insert - >'+ MCCList);
        Insert MCCList;        
    } 
    
    public void updateClaimedCases(List<Contract_Product__c> ContractProdList){
         if(FS_Utility.run4Once()){
            List<ID> ProductIdList = new List<ID>();
            List<ID> ContractIdList = new List<ID>();
            List<ID> OppIdList = new List<ID>();
            List<Opportunity> OppList=new List<Opportunity>();
            List<OpportunityLineItem> OLIList=new List<OpportunityLineItem>();
            List<FS_Monthly_Claimed_Cases__c> MCCList = new List<FS_Monthly_Claimed_Cases__c>();
            List<OpportunityLineItemSchedule> ScheduleList = new List<OpportunityLineItemSchedule>();
            List<FS_Contract_Product_Opportunity_Map__c> CustomSettingList = new List<FS_Contract_Product_Opportunity_Map__c>();
            
            For(Contract_Product__c cp : ContractProdList){
                ContractIdList.add(cp.Contract__c);
                ProductIdList.add(cp.Product__c);
                OppIdList.add(cp.FS_ReferenceOpportunity__c);
            }
            system.debug(ContractIdList);
            Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity with Pricing (MA-BE)').getRecordTypeId();
            //CustomSettingList = [select FS_Opportunity__c from FS_Contract_Product_Opportunity_Map__c];
            CustomSettingList = FS_Contract_Product_Opportunity_Map__c.getall().values();
            system.debug('CustomSettingList -->'+CustomSettingList);
            OppIdList.clear();
            for(FS_Contract_Product_Opportunity_Map__c cs :CustomSettingList ){
                OppIdList.add(id.ValueOf(cs.FS_Opportunity__c));
            }
            system.debug('OppIdList-->'+OppIdList);
            OppList = [SELECT Id FROM Opportunity WHERE ContractId IN : ContractIdList and Id in : OppIdList];
            system.debug('OppList -->'+OppList);
            OLIList = [select id, Opportunity.AccountId, Product2Id from OpportunityLineItem where OpportunityId in : OppList and Product2Id in : ProductIdList];
            system.debug('OLIList -->'+OLIList);
            ScheduleList = [SELECT OpportunityLineItemId,Quantity,ScheduleDate FROM OpportunityLineItemSchedule where OpportunityLineItemId in : OLIList AND Quantity > 0];
            system.debug('ScheduleList -->'+ScheduleList);
            MCCList = [SELECT Id, FS_First_of_Month__c, Account__c, FS_Planned_Quantity__c, Product__c  FROM FS_Monthly_Claimed_Cases__c where Contract_Product__r.Contract__c in : ContractIdList];
                    
            for(OpportunityLineItem oli : OLIList){
                for(OpportunityLineItemSchedule Schedule : ScheduleList){
                    if(oli.Id == Schedule.OpportunityLineItemId){
                        for(FS_Monthly_Claimed_Cases__c MCCObj: MCCList){
                            if(MCCObj.Account__c == oli.Opportunity.AccountId && MCCObj.Product__c == oli.Product2Id && mccObj.FS_First_of_Month__c == (Schedule.ScheduleDate).toStartOfMonth()){
                                mccObj.FS_Planned_Quantity__c = mccObj.FS_Planned_Quantity__c + Schedule.Quantity;
                            }
                        }        
                    }
                } 
            }
            system.debug(MCCList);
            Update MCCList;
            Delete CustomSettingList ;      
        }  
    }
}