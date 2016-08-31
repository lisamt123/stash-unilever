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
        /*String profile='Unilever - Salesforce MultiApp Standard';        
        String permissionset='FS_Sales_Rep';        
        Profile p = [SELECT Id FROM Profile WHERE Name=:profile];
        Userrole role=[SELECT Id FROM UserRole WHERE Name = 'FS 59040 Sales Rep'];
        User SalesRepUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=role.id,
        TimeZoneSidKey='America/Los_Angeles', UserName='newuseropphelper@testorg.com');
        insert SalesRepUser;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =:permissionset];
        PermissionSetAssignment psetassignment = new PermissionSetAssignment();
        psetassignment.AssigneeId = SalesRepUser.Id;
        psetassignment.PermissionSetId = ps.Id;
        insert psetassignment;*/
        String profile='Unilever - Salesforce MultiApp Standard';
        String permissionset='FS_Sales_Rep';         
        Profile p = [SELECT Id FROM Profile WHERE Name=:profile];
        Userrole role=[SELECT Id FROM UserRole WHERE Name = 'FS 59040 Sales Rep'];
        User SalesRepUser1 = new User(Alias = 'newUser', Email='newuser1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=role.id,
        TimeZoneSidKey='America/Los_Angeles', UserName='newuseropphelper1@testorg.com');
        insert SalesRepUser1;
        User SalesRepUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=role.id,ManagerId = SalesRepUser1.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='newuseropphelper@testorg.com');
        insert SalesRepUser;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =:permissionset];
        PermissionSetAssignment psetassignment = new PermissionSetAssignment();
        psetassignment.AssigneeId = SalesRepUser.Id;
        psetassignment.PermissionSetId = ps.Id;
        insert psetassignment;           
        system.runAs(SalesRepUser){
            //Set up Custom settings for Opportunity Trigger
            FSOpportunityTriggerSettings__c OppCustomSettings=new FSOpportunityTriggerSettings__c(name='isEnabled',Enabled__c=true);
            insert OppCustomSettings;            
            // Set up the Account records
            List<Account> accounts = new List<Account>();
            RecordType rt=[select id,name from RecordType where SObjectType='Account'and Name='Operator'];
            for(Integer i=0;i < 100;i++){
               accounts.add(new Account(Name = 'FS Test Acc_'+i,recordtypeid=rt.Id));
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
               pricebookentries.add(new priceBookEntry ( pricebook2id = pricebookId,Product2Id = prod.id,  unitPrice = 1000, IsActive = true,UseStandardPrice = false,FS_Bracket_1__c=1)); 
            }
            insert pricebookentries;
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
            List<opportunity> opportunities2= new List<opportunity>();
            list<OpportunityLineItem> oli=new list<OpportunityLineItem>();
            
            pricebookentries2=[select id,unitPrice from pricebookentry where product2.name like 'FS Test Product%'];
            opportunities2=[select id,name,AverageGrossProfit__c,MarketTarget__c,accountid,FS_TotalNumberOfCases__c from opportunity where name='FS Test Opportunity'];
                                   
            //Set up Opportunity Line Item
            for (Opportunity opportunity:opportunities2){
                i++;
                if(i>10){     //To keep few Opportunity records without Opportunity Line item
                    for (pricebookentry pbookentry : pricebookentries2){
                        oli.add(new OpportunityLineItem(Opportunityid = opportunity.id,PricebookentryId =pbookentry.id,quantity=i/2+1,totalPrice=pbookentry.unitPrice,Distributor__c='CA GFS'));
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
            
            olilist=[select id,name,FS_MarketTarget__c,OpportunityId,GPPercent__c,GrossProfit__c, FS_Sample__c,Turnover__c from OpportunityLineItem where opportunity.Name='FS Test Opportunity'];
            system.debug(olilist);
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
                 system.debug(opplineItem);
                 //To check if the opportunity is having Opportunity Line Item             
                 if(opplineItem.size()>0)
                 {
                    system.debug(opplineItem);
                    for(OpportunityLineItem opplitem:opplineItem){
                        system.debug(opplitem.FS_MarketTarget__c);
                        system.debug(opplitem.GPPercent__c);
                        //GrossProfit=GrossProfit+Integer.valueOf(opplitem.GPPercent__c);
                        //MrktTarget=MrktTarget+Integer.valueOf(opplitem.FS_MarketTarget__c);
                        GrossProfit=GrossProfit+opplitem.GPPercent__c;
                        MrktTarget=MrktTarget+opplitem.FS_MarketTarget__c;
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