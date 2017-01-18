/**********************************************************************
Purpose: Test class for OpportunityTrigger.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     10/June/2016     Created

***********************************************************************/
@isTest
private class FS_OpportunityHelperTest {
    
    //Set up Test Data for unit test    
    @testSetup static void setupTestData(){        
        FS_UtilTestDataSetup testData=new FS_UtilTestDataSetup();
        User testUser=testData.createTestUser();        
        system.runAs(testUser){
            //set up custom setting for opportunity stages
            testData.setUpOpportunityStages();
            testdata.enableOpportunityTrigger();
            List<Account> accounts = testData.setUpAccountData();            
            testData.setUpAccountPlan(accounts);
            List<FS_Defined_Objective__c> objList=[select id,FS_No_of_Opportunities__c,FS_Opportunity_Amount__c,FS_Customer__c,FS_Account_Plan__c from FS_Defined_Objective__c limit 100];
            List<Opportunity> opportunities=testData.setUpOppforAccPlan(objList);
            opportunities.clear();
        }
    }
    
    //Test Method for Opportunity Helper Class
    static testMethod void OpportunityTriggerUnitTest() {
        //Fetch Test User Data     
        user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
        system.runAs(SalesRepUser){
            Decimal GrossProfit;
            Decimal AvgGrossProfit;
            Decimal MrktTarget;
            Decimal AvgMrktTarget;
            Integer i = 0;
            List<priceBookEntry> pricebookentries2= new List<priceBookEntry>();
            List<opportunity> oppList= new List<opportunity>();
            list<OpportunityLineItem> oli=new list<OpportunityLineItem>();
            
            pricebookentries2=[select id,unitPrice from pricebookentry where product2.name like 'FS Test Product%'];
            oppList=[select id,name,FS_MarketTarget__c,FS_AverageGrossProfit__c,accountid,FS_TotalNumberOfCases__c from opportunity where name='FS Test Opportunity'];
            //Set up Opportunity Line Item
            for (Opportunity opportunity:oppList){
                i++;
                if(i>10){//To keep few Opportunity records without Opportunity Line item
                    for (pricebookentry pbookentry : pricebookentries2){
                        oli.add(new OpportunityLineItem(Opportunityid = opportunity.id,PricebookentryId =pbookentry.id,quantity=i/2+1,totalPrice=pbookentry.unitPrice,Distributor__c='CA GFS'));
                    }               
                } 
            }             
            
            Test.startTest();
            //Insert opportunity line items
            Insert oli;
            Test.stopTest();
            
            //Validate if correct record is inserted or not 
            List<OpportunityLineItem> olilist = new List<OpportunityLineItem>();
            List<opportunity> newOppList= new List<opportunity>();
            Map<opportunity,list<OpportunityLineItem>> mapOppOli = new Map<opportunity,list<OpportunityLineItem>>(); 
            
            olilist=[select id,name,FS_MarketTarget__c,OpportunityId,GPPercent__c,GrossProfit__c, FS_Sample__c,Turnover__c from OpportunityLineItem where opportunity.Name='FS Test Opportunity'];
            
            newOppList=[select id,name,FS_MarketTarget__c,FS_AverageGrossProfit__c, AccountId,FS_TotalNumberOfCases__c from opportunity where name='FS Test Opportunity']; 
                        
            //Set up Map for all Opportunity records and associated Opportunity Line Item records
            for (Opportunity opportunity:newOppList)
            {
                list<OpportunityLineItem> olineitem=new list<OpportunityLineItem>();
                for (OpportunityLineItem olitem: olilist){
                    if(olitem.OpportunityId==opportunity.id){
                        olineitem.add(olitem);
                    }
                    mapOppOli.put(opportunity, olineitem);
                }
            }
            i=0;          
            for (Opportunity opportunity:newOppList){
                i++;
                GrossProfit=0;
                MrktTarget=0;
                List<OpportunityLineItem> opplineItem = new List<OpportunityLineItem>();
                opplineItem=mapOppOli.get(opportunity);                
                //To check if the opportunity is having Opportunity Line Item             
                if(opplineItem.size()>0)
                {
                    system.debug(opplineItem);
                    for(OpportunityLineItem opplitem:opplineItem){
                        system.debug(opplitem.FS_MarketTarget__c);
                        system.debug(opplitem.GPPercent__c);                        
                        GrossProfit=GrossProfit+opplitem.GPPercent__c;
                        MrktTarget=MrktTarget+opplitem.FS_MarketTarget__c;
                    }            
                    AvgGrossProfit=GrossProfit/opplineItem.size();
                    AvgMrktTarget=MrktTarget/opplineItem.size();
                    
                    //Check if opportunity records got updated as expected
                    system.assertEquals(AvgGrossProfit, opportunity.FS_AverageGrossProfit__c);
                    system.assertEquals(AvgMrktTarget, opportunity.FS_MarketTarget__c);
                }
            }
        }
    }
    
}