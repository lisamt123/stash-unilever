@isTest
private class FS_MABETest {
//Set up Test Data for unit test    
     @testSetup static void setupTestData(){        
        FS_UtilTestDataSetup testData= new FS_UtilTestDataSetup();
        User user = testData.createTestUser();
        testData.setUpTestData(user);
}
    
static testMethod void TestCopyOliToExisting(){
//user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
//system.runAs(SalesRepUser){

    List<Opportunity> listNewOpp=new List<Opportunity>();
    Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity with Pricing (MA-BE)').getRecordTypeId();
    listNewOpp=[select id,ContractId,DealApproved__c,stagename from Opportunity where recordtypeId=:newRecordTypeId and DealApproved__c=true and Name = 'FS Test Opportunity'];
    List<Opportunity> listNewOppToBeclosed=new List<Opportunity>();
    listNewOppToBeclosed=new List<Opportunity>();
    Set<Id> contractList=New Set<Id>();
    For(Opportunity opp: listNewOpp){
    opp.AgreementDate__c=system.today();
    opp.StageName='05 – Won';
    contractList.add(opp.ContractId);
    listNewOppToBeclosed.add(Opp);
    }

    Test.startTest();
    Update listNewOppToBeclosed;
    Test.stopTest();
    

    List<Opportunity> listExistingOpp=new List<Opportunity>();
    Id existingRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Existing').getRecordTypeId();
    //Get list of Existing Opportunities
    listExistingOpp=[select id,ContractId from Opportunity where recordtypeId=:existingRecordTypeId and ContractId in :ContractList];
//List<OpportunityLineItem> listNewOppLineItem=New List<OpportunityLineItem>();
//listNewOppLineItem=[select Id,OpportunityId,Product2Id,Opportunity.ContractId from OpportunityLineItem where opportunityId in : ListNewOpp];
List<OpportunityLineItem> listOppLineItemCreated=New List<OpportunityLineItem>();
listOppLineItemCreated=[select Id,OpportunityId,Product2Id,Opportunity.ContractId,contract_product__c,Quantity from OpportunityLineItem where opportunityId in : ListExistingOpp];
List<Contract_Product__c> listNewContractProduct=New List<Contract_Product__c>();
listNewContractProduct=[select contract__c,product__c from contract_product__c where contract__c in : ContractList];
//List<FS_Monthly_Claimed_Cases__c> listclaimed_case=new List<FS_Monthly_Claimed_Cases__c>();
//listclaimed_case=[SELECT Id, FS_First_of_Month__c, Account__c, Contract_Product__c, FS_Planned_Quantity__c, Product__c  FROM FS_Monthly_Claimed_Cases__c where contract_product__c in :ListNewContractProduct];
system.assertEquals(true, !ListOppLineItemCreated.isEmpty());
system.assertEquals(true, !ListNewContractProduct.isEmpty());
//system.assertequals(true,!listclaimed_case.isEmpty());
    For(OpportunityLineItem oli : listOppLineItemCreated){
        system.assertNotEquals(null,oli.contract_product__c);
        system.assertNotEquals(null,oli.Quantity);
    }
//}
}//End for TestCopyOliToExisting
    
 static TestMethod void testCalculateForecast(){
 List<Opportunity> listNewOpp=new List<Opportunity>();
 Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity with Pricing (MA-BE)').getRecordTypeId();
 listNewOpp=[select id,ContractId from Opportunity where recordtypeId=:newRecordTypeId];
 List<Opportunity> listNewOppToBeclosed=new List<Opportunity>();
 listNewOppToBeclosed=new List<Opportunity>();
 Set<Id> contractList=New Set<Id>();
 listNewOpp=[select id,ContractId,DealApproved__c,stagename from Opportunity where recordtypeId=:newRecordTypeId and DealApproved__c=true and Name='FS Test Opportunity' limit 1];
 
     For(Opportunity opp: listNewOpp){
     opp.AgreementDate__c=system.today();
     opp.StageName='05 – Won';
     contractList.add(opp.ContractId);
     listNewOppToBeclosed.add(opp);
     }
     test.startTest();
     Update listNewOppToBeclosed;
     system.assertEquals(1, contractList.size());     
     List<Contract_Product__c> listNewContractProduct=New List<Contract_Product__c>();
     listNewContractProduct=[select contract__c,product__c from contract_product__c where contract__c in : contractList limit 1];
     List<FS_Monthly_Claimed_Cases__c> listclaimed_case=new List<FS_Monthly_Claimed_Cases__c>();     
     listclaimed_case=[SELECT Id, FS_First_of_Month__c, Account__c, Contract_Product__c, FS_Planned_Quantity__c, Product__c,FS_Claimed_Cases_Paid__c,FS_Forecast_Quantity__c  FROM FS_Monthly_Claimed_Cases__c where contract_product__c in :listNewContractProduct];
     List<OpportunityLineItemSchedule> listScheduletoinsert=new List<OpportunityLineItemSchedule>();
     listScheduletoinsert=[select id from OpportunityLineItemSchedule where OpportunityLineItem.Opportunity.ContractId in :contractList];
     system.assertEquals(24, listScheduletoinsert.size());
     system.assertequals(12,listclaimed_case.size());     
     List<FS_Monthly_Claimed_Cases__c> listclaimed_case_Update=new List<FS_Monthly_Claimed_Cases__c>();
     For(FS_Monthly_Claimed_Cases__c claimed_Case : listclaimed_case){
       claimed_Case.FS_Claimed_Cases_Paid__c=10;
       listclaimed_case_Update.add(claimed_Case);
    }
Update(listclaimed_case_Update);
system.assertNotEquals(null, listclaimed_case_Update.size());
//ClaimCaseForecast.ClaimCaseList=[SELECT Id, FS_First_of_Month__c, Account__c, Contract_Product__c, FS_Planned_Quantity__c, Product__c,FS_Claimed_Cases_Paid__c  FROM FS_Monthly_Claimed_Cases__c where contract_product__c in :ListNewContractProduct];
FS_MonthlyClaimCases_Batch ClaimCaseForecast=new FS_MonthlyClaimCases_Batch();
//Database.executeBatch(ClaimCaseForecast,1);
Database.QueryLocator ql = ClaimCaseForecast.start(null);
ClaimCaseForecast.execute(null,listclaimed_case_Update);
ClaimCaseForecast.finish(null);
Test.stopTest();

    //For(FS_Monthly_Claimed_Cases__c claimed_Case : listclaimed_case){     
    //system.debug(claimed_Case.FS_Forecast_Quantity__c);
    //system.assertNotEquals(Null,claimed_Case.FS_Forecast_Quantity__c);
    //}
//}
    //}
}//End for TestCreateContractProduct

static TestMethod void testCreateClaimedCase(){
List<Opportunity> ListNewOpp=new List<Opportunity>();
Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity with Pricing (MA-BE)').getRecordTypeId();
ListNewOpp=[select id,ContractId,DealApproved__c,stagename from Opportunity where recordtypeId=:newRecordTypeId and DealApproved__c=true and Name = 'FS Test Opportunity' limit 2];
//ListNewOpp=[select id,ContractId from Opportunity where recordtypeId=:newRecordTypeId];
List<Opportunity> ListNewOppToBeclosed=new List<Opportunity>();
//ListNewOppToBeclosed=new List<Opportunity>();
Set<Id> ContractList=New Set<Id>();
For(Opportunity Opp: ListNewOpp){
Opp.AgreementDate__c=system.today();
Opp.StageName='05 – Won';
ContractList.add(Opp.ContractId);
ListNewOppToBeclosed.add(Opp);
}
test.startTest();
Update ListNewOppToBeclosed;
List<Contract_Product__c> ListNewContractProduct=New List<Contract_Product__c>();
ListNewContractProduct=[select contract__c,product__c from contract_product__c where contract__c in : ContractList];
List<FS_Monthly_Claimed_Cases__c> listClaimed_Case=new List<FS_Monthly_Claimed_Cases__c>();
List<FS_Monthly_Claimed_Cases__c> listNewClaimed_Case=new List<FS_Monthly_Claimed_Cases__c>();
listClaimed_Case=[SELECT Id, FS_First_of_Month__c, Account__c, Contract_Product__c, FS_Planned_Quantity__c, Product__c,FS_Claimed_Cases_Paid__c  FROM FS_Monthly_Claimed_Cases__c where contract_product__c in :ListNewContractProduct];
Map<id,List<FS_Monthly_Claimed_Cases__c>> MapClaimCase=new Map<id,List<FS_Monthly_Claimed_Cases__c>>();
        List<FS_Monthly_Claimed_Cases__c> tempList  = new List<FS_Monthly_Claimed_Cases__c>();
        //set<id> tempSet = new set<id>();
        for(FS_Monthly_Claimed_Cases__c claimed_case : listclaimed_case)
        {
            tempList  = new List<FS_Monthly_Claimed_Cases__c>();
            if(MapClaimCase.containskey(claimed_case.Contract_Product__c))
                    {
                        tempList   = MapClaimCase.get(claimed_case.Contract_Product__c);
                    }
            If(claimed_case.FS_First_of_Month__c!=Null){
            tempList.add(claimed_case);
            }            		
                    MapClaimCase.put(claimed_case.Contract_Product__c,tempList);
            //tempSet.add(claimed_case.Contract_Product__c);
        }
FS_NewMonthlyClaimCase_Batch claimCaseForecast=new FS_NewMonthlyClaimCase_Batch();
claimCaseForecast.start(null);
claimCaseForecast.execute(null,listClaimed_Case);
claimCaseForecast.finish(null);
Test.stopTest();
listNewClaimed_Case=[SELECT Id, FS_First_of_Month__c, Account__c, Contract_Product__c, FS_Planned_Quantity__c, Product__c,FS_Claimed_Cases_Paid__c  FROM FS_Monthly_Claimed_Cases__c where contract_product__c in :ListNewContractProduct];
system.assertEquals(listClaimed_Case.size()+listNewContractProduct.size(),listNewClaimed_Case.size());   
}//End for TestLinkOlitoConProd
}//End for test class