@isTest
private class FS_MABETest {       
    //Set up Test Data for unit test    
    @testSetup static void setupTestData(){        
        FS_UtilTestDataSetup testData= new FS_UtilTestDataSetup();
        User testUser = testData.createTestUser();
        system.runAs(testUser){
            //Set up custom settings for opportunity stages
            testData.setUpOpportunityStages();
            //Enable for opportunity trigger
            testdata.enableOpportunityTrigger();            
            List<Account> accounts = testData.setUpAccountData();           
            List<Contract> listContract=testData.setUpContractData(accounts);
            List<Opportunity> opportunities=testData.setUpMABEOpportunityData(listContract);  
            List<Opportunity> listNewOpp=new List<Opportunity>();
            Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NAFS Opportunity MABE').getRecordTypeId();
            listNewOpp=[select id,ContractId,DealApproved__c,stagename from Opportunity where recordtypeId=:newRecordTypeId and Name='FS Test Opportunity' and id in : opportunities];
            testdata.setUpOpportunityLineItemData(listNewOpp);
            List<OpportunityLineItem> listOli;
            listNewOpp=[select id,ContractId,DealApproved__c,stagename from Opportunity where recordtypeId=:newRecordTypeId and Name='FS Test Opportunity' limit 1];
            listOli=[select id from OpportunityLineItem where opportunityId=:listNewOpp];
            testData.setUpSchedule(listoli);                    
            listNewOpp=testdata.closeOpportunity(listNewOpp);            
        }        
    }
    
    static testMethod void testCopyOliToExisting(){
        FS_OpportunityStages__c stages=FS_OpportunityStages__c.getinstance('FS_Stages');
        string STATUS_WON=stages.FS_Stage_Won__c;
        user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
        system.runAs(SalesRepUser){
            Test.startTest();
            List<Opportunity> listNewOpp=new List<Opportunity>();
            Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NAFS Opportunity MABE').getRecordTypeId();
            listNewOpp=[select id,ContractId,DealApproved__c,stagename from Opportunity where recordtypeId=:newRecordTypeId and DealApproved__c=true and Name = 'FS Test Opportunity'];
            system.assertEquals(true,!listNewOpp.isEmpty());
            List<Opportunity> listNewOppToBeclosed=new List<Opportunity>();            
            Set<Id> contractList=New Set<Id>();
            For(Opportunity opp: listNewOpp){
                opp.AgreementDate__c=system.today();
                opp.StageName=STATUS_WON;
                contractList.add(opp.contractId);
                listNewOppToBeclosed.add(Opp);
            }
            List<Contract> listContract=[select id from Contract where id in : contractList];
            system.assertEquals(true,!contractList.isEmpty());            
            Update listNewOppToBeclosed;            
            List<Opportunity> listExistingOpp=new List<Opportunity>();
            Id existingRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NAFS Existing Business').getRecordTypeId();
            //Get list of Existing Opportunities
            listExistingOpp=[select id,ContractId from Opportunity where recordtypeId=:existingRecordTypeId and ContractId in :contractList];
            system.assertEquals(true,!listContract.isEmpty());
            List<OpportunityLineItem> listOppLineItemCreated=New List<OpportunityLineItem>();
            listOppLineItemCreated=[select Id,OpportunityId,Product2Id,Opportunity.ContractId,contract_product__c,Quantity from OpportunityLineItem where opportunityId in : listExistingOpp];
            List<Contract_Product__c> listNewContractProduct=New List<Contract_Product__c>();
            listNewContractProduct=[select contract__c,product__c from contract_product__c where contract__c in :contractList];        
            system.assertEquals(true,!listOppLineItemCreated.isEmpty());
            system.assertEquals(true,!listNewContractProduct.isEmpty());        
            For(OpportunityLineItem oli : listOppLineItemCreated){
                system.assertNotEquals(null,oli.contract_product__c);
                system.assertNotEquals(null,oli.Quantity);
            }
            Test.stopTest(); 
        }               
    }
    
    static TestMethod void testCalculateForecast(){
        FS_OpportunityStages__c stages=FS_OpportunityStages__c.getinstance('FS_Stages');
        string STATUS_WON=stages.FS_Stage_Won__c;
        test.startTest();
        List<Opportunity> listNewOpp=new List<Opportunity>();
        Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NAFS Opportunity MABE').getRecordTypeId();
        listNewOpp=[select id,ContractId from Opportunity where recordtypeId=:newRecordTypeId];
        List<Opportunity> listNewOppToBeclosed=new List<Opportunity>();
        listNewOppToBeclosed=new List<Opportunity>();
        Set<Id> contractList=New Set<Id>();
        listNewOpp=[select id,ContractId,DealApproved__c,stagename from Opportunity where recordtypeId=:newRecordTypeId and DealApproved__c=true and Name='FS Test Opportunity' limit 1];
        
        For(Opportunity opp: listNewOpp){
            opp.AgreementDate__c=system.today();
            opp.StageName=STATUS_WON;
            contractList.add(opp.ContractId);
            listNewOppToBeclosed.add(opp);
        }
        List<Contract_Product__c> listNewContractProduct=New List<Contract_Product__c>();
        listNewContractProduct=[select contract__c,product__c from contract_product__c where contract__c in : contractList limit 2];
        system.assertEquals(true,listNewContractProduct.isEmpty());
        Update listNewOppToBeclosed;
        system.assertEquals(1, contractList.size());      
        listNewContractProduct=[select contract__c,product__c from contract_product__c where contract__c in : contractList limit 2];
        List<FS_Monthly_Claimed_Cases__c> listclaimed_case=new List<FS_Monthly_Claimed_Cases__c>();     
        listclaimed_case=[SELECT Id, FS_First_of_Month__c, Account__c, Contract_Product__c, FS_Planned_Quantity__c, Product__c,FS_Claimed_Cases_Paid__c,FS_Forecast_Quantity__c  FROM FS_Monthly_Claimed_Cases__c where contract_product__c in :listNewContractProduct];
        List<OpportunityLineItemSchedule> listScheduletoinsert=new List<OpportunityLineItemSchedule>();
        listScheduletoinsert=[select id from OpportunityLineItemSchedule where OpportunityLineItem.Opportunity.ContractId in :contractList];        
        system.assertequals(listScheduletoinsert.size(),listclaimed_case.size());     
        List<FS_Monthly_Claimed_Cases__c> listclaimed_case_Update=new List<FS_Monthly_Claimed_Cases__c>();
        
        For(FS_Monthly_Claimed_Cases__c claimed_Case : listclaimed_case){
            claimed_Case.FS_Claimed_Cases_Paid__c=10;
            listclaimed_case_Update.add(claimed_Case);
        }
        
        Update(listclaimed_case_Update); 
        
        system.assertNotEquals(null, listclaimed_case_Update.size());
        
        FS_MonthlyClaimCases_Batch ClaimCaseForecast=new FS_MonthlyClaimCases_Batch();        
        ClaimCaseForecast.start(null);
        ClaimCaseForecast.execute(null,listclaimed_case_Update);
        ClaimCaseForecast.finish(null);
        Test.stopTest();        
    }//End for TestCreateContractProduct
    
    static TestMethod void testCreateClaimedCase(){
        FS_OpportunityStages__c stages=FS_OpportunityStages__c.getinstance('FS_Stages');
        string STATUS_WON=stages.FS_Stage_Won__c; 
        List<Opportunity> ListNewOpp=new List<Opportunity>();
        Id newRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NAFS Opportunity MABE').getRecordTypeId();
        ListNewOpp=[select id,ContractId,DealApproved__c,stagename from Opportunity where recordtypeId=:newRecordTypeId and DealApproved__c=true and Name = 'FS Test Opportunity' limit 2];
        List<Opportunity> ListNewOppToBeclosed=new List<Opportunity>();       
        Set<Id> ContractList=New Set<Id>();
        For(Opportunity Opp: ListNewOpp){
            Opp.AgreementDate__c=system.today();
            Opp.StageName=STATUS_WON;
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
            mapClaimCase.put(claimed_case.Contract_Product__c,tempList);            
        }
        FS_NewMonthlyClaimCase_Batch claimCaseForecast=new FS_NewMonthlyClaimCase_Batch();
        claimCaseForecast.start(null);
        claimCaseForecast.execute(null,listClaimed_Case);
        claimCaseForecast.finish(null);
        Test.stopTest();
        listNewClaimed_Case=[SELECT Id, FS_First_of_Month__c, Account__c, Contract_Product__c, FS_Planned_Quantity__c, Product__c,FS_Claimed_Cases_Paid__c  FROM FS_Monthly_Claimed_Cases__c where contract_product__c in :ListNewContractProduct];
        system.assertEquals(listClaimed_Case.size()+listNewContractProduct.size(),listNewClaimed_Case.size());   
    }
}