/**********************************************************************
Purpose: Test class for OpportunityTrigger.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     10/June/2016     Created
                          
***********************************************************************/
@isTest
private class FS_OpportunityHelper_Test {
     
    //Set up Test Data for unit test    
     @testSetup static void setupTestData(){
        String profile='Unilever - Salesforce MultiApp Standard';
        String permissionset='NAFS_Sales_Rep';
        //Call Utility method to create test user
        user SalesRepUser=FS_Utility.CreateTestUser(profile,permissionset);
            
        system.runAs(SalesRepUser){
            //Set up Custom settings for Opportunity Trigger
            FSOpportunityTriggerSettings__c OppCustomSettings=new FSOpportunityTriggerSettings__c(name='isEnabled',Enabled__c=true);
            insert OppCustomSettings;
            
            // Set up the Account records
            List<Account> accounts = new List<Account>();
            for(Integer i=0;i < 100;i++){
               accounts.add(new Account(Name = 'FS Test Acc_'+i,recordtype=new recordtype(name='Operator')));
            }
            insert accounts;
            
            //Set up Opportunity records
            List<Opportunity> opportunities = new List<Opportunity>();
            for(Account acc:accounts){
                 opportunities.add(new Opportunity(Name = 'FS Test Opportunity',AccountId = acc.Id,StageName = '01 – Universe',CloseDate = Date.today()));
                 }
            insert opportunities;
            
            //Set up Product records     
            List<Product2> products=new  List<Product2>();
            for(Integer i=0;i < 2;i++){
                products.add(new Product2(Name = 'FS Test Product_'+i,COGS__c=(i+1),isActive=true,MarketType__c='BOH MAYO',StartDate__c=date.today(),EndDate__c=date.today()+1));
            }
            insert products;
            
            //Fetch standard Price Book     
            Id pricebookId = Test.getStandardPricebookId();
            
            //Set up Price Book Entry records
            List<priceBookEntry> pricebookentries= new List<priceBookEntry>();
            for(Product2 prod : products)
            {
               pricebookentries.add(new priceBookEntry ( pricebook2id = pricebookId,Product2Id = prod.id,  unitPrice = 1000, IsActive = true,UseStandardPrice = false)); 
            }
            insert pricebookentries;
        }     
     }
    
     //Test Method for Opportunity Helper Class
     static testMethod void OpportunityTriggerUnitTest() {
         //Fetch Test User Data     
         user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
         system.runAs(SalesRepUser){
            Integer GrossProfit;
            Integer AvgGrossProfit;
            Integer MrktTarget;
            Integer AvgMrktTarget;
            Integer i = 0;
            List<priceBookEntry> pricebookentries2= new List<priceBookEntry>();
            List<opportunity> opportunities2= new List<opportunity>();
            list<OpportunityLineItem> oli=new list<OpportunityLineItem>();
            
            pricebookentries2=[select id,unitPrice from pricebookentry where product2.name like 'FS Test Product%'];
            opportunities2=[select id,name,AverageGrossProfit__c,MarketTarget__c,accountid,FS_TotalNumberOfCases__c from opportunity where name='FS Test Opportunity'];
                                   
            //Set up Opportunity Line Item
            for (Opportunity opportunity:opportunities2){
                i++;
                if(i>10){     //To keep few Opportunity records without Opportunity Line item
                    for (pricebookentry pbookentry : pricebookentries2){
                        oli.add(new OpportunityLineItem(Opportunityid = opportunity.id,PricebookentryId =pbookentry.id,quantity=i/2+1,totalPrice=pbookentry.unitPrice,Distributor__c='Reinhart'));
                    }               
                } 
            }             
             
            Test.startTest();
            //Cause Opportunity trigger to fire
            Insert oli;
            Test.stopTest();
            
            //Validate if correct record is inserted or not 
            List<OpportunityLineItem> olilist = new List<OpportunityLineItem>();
            List<opportunity> opportunities3= new List<opportunity>();
            Map<opportunity,list<OpportunityLineItem>> mapOppOli = new Map<opportunity,list<OpportunityLineItem>>(); 
            
            olilist=[select id,name,GPPercent__c,FS_MarketTarget__c,OpportunityId from OpportunityLineItem where opportunity.Name='FS Test Opportunity'];
            opportunities3=[select id,name,AccountId,AverageGrossProfit__c,MarketTarget__c,FS_TotalNumberOfCases__c from opportunity where name='FS Test Opportunity']; 
            system.debug('Size:'+opportunities3.size());
            
            //Set up Map for all Opportunity records and associated Opportunity Line Item records
            for (Opportunity opportunity:opportunities3)
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
            for (Opportunity opportunity:opportunities3){
                 i++;
                 GrossProfit=0;
                 MrktTarget=0;
                 List<OpportunityLineItem> opplineItem = new List<OpportunityLineItem>();
                 opplineItem=mapOppOli.get(opportunity);
                 //To check if the opportunity is having Opportunity Line Item             
                 if(opplineItem.size()>0)
                 {
                    for(OpportunityLineItem opplitem:opplineItem){
                        GrossProfit=GrossProfit+Integer.valueOf(opplitem.GPPercent__c);
                        MrktTarget=MrktTarget+Integer.valueOf(opplitem.FS_MarketTarget__c);
                    }            
                    AvgGrossProfit=GrossProfit/opplineItem.size();
                    AvgMrktTarget=MrktTarget/opplineItem.size();
                    
                    //Check if opportunity records got updated as expected
                    system.assertEquals(AvgGrossProfit, opportunity.AverageGrossProfit__c);
                    system.assertEquals(AvgMrktTarget, opportunity.MarketTarget__c);
                 }
            }
         }//end of system.runAs() 
     }//end of method  
}