@isTest
public class FS_ProductSubSector_Test {
    @testSetup static void setupTestData(){
        FS_UtilTestDataSetup testdata=new FS_UtilTestDataSetup();     
        User user =  testData.createTestUser();     
        system.runAs(user){
            //set up custom setting for opportunity stages
            testData.setUpOpportunityStages();
            testdata.enableOpportunityTrigger();
            List<Account> accounts = testData.setUpAccountData();            
            testData.setUpAccountPlan(accounts);
            List<FS_Defined_Objective__c> objList=[select id,FS_No_of_Opportunities__c,FS_Opportunity_Amount__c,FS_Customer__c,FS_Account_Plan__c from FS_Defined_Objective__c limit 100];
            List<Opportunity> opportunities=testData.setUpOppforAccPlan(objList);
            testData.setUpOpportunityLineItemData(opportunities);            
        } 
    }
    Static TestMethod void testRisk_SubSector_Picklist (){
        List<Risk__c> riskList=[select id from Risk__c limit 1];
        test.startTest();
        For (Risk__c risk : riskList){           
            ApexPages.StandardController sc=new ApexPages.StandardController(risk);
            FS_RiskProductSubSector_CX product_Sector=new FS_RiskProductSubSector_CX(sc);      
            product_Sector.autorun();
            product_sector.updateSubSector();           
            system.assertEquals((Risk__c)sc.getRecord(),risk);
        }
        test.stopTest();
    }
    Static TestMethod void testOpportunity_SubSector_Picklist(){
        List<opportunity> oppList=[select id from opportunity limit 1];
        test.startTest();
        For (Opportunity opp : oppList){           
            ApexPages.StandardController sc=new ApexPages.StandardController(opp);
            FS_OpportunityProductSubSector_CX product_Sector=new FS_OpportunityProductSubSector_CX(sc);      
            product_Sector.autorun();
            product_sector.updateSubSector();          
            system.assertEquals((opportunity)sc.getRecord(),opp);
        }
        test.stopTest();
    }
}