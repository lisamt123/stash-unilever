@isTest(seeAllData=true)
private class FS_OpportunityTrigger_Test {
    static testMethod void OppUnitTest() {        
            
            Account acc= [select id,name from Account where name=: 'Test_Account_PB'];
            Pricebook2 pb = [select id, name from Pricebook2 where name LIKE 'Standard%' and isActive = true and IsStandard=true limit 1];
            //Pricebook2 pb = [select id,name from Pricebook2 where name =: 'RFS_RUS_RUB' and isActive = true limit 1];    
            //Product2 prod1=[select id,name,COGS__c from Product2 where name in ('NAFS_Product_Test_Class')];
            //Product2 prod2=[select id,name,COGS__c from Product2 where name in ('NAFS_Product_Test_Class2')]; 
            Product2 prod1 = new Product2(Name='FS_Prod_Test_Class',COGS__c=2,isActive=true,MarketType__c='BOH MAYO');
            insert prod1;
            Product2 prod2 = new Product2(Name='FS_Prod_Test_Class2',COGS__c=3,isActive=true,MarketType__c='F1 SPREADS AND TOPPING');
            insert prod2;
            system.debug(prod1); 
            system.debug(prod2);
            system.debug(pb);     
            priceBookEntry pbe1=new priceBookEntry ( pricebook2id = pb.id,Product2Id = prod1.id,  unitPrice = 1100, IsActive = true,UseStandardPrice = false);
            insert pbe1;    
            priceBookEntry pbe2=new priceBookEntry ( pricebook2id = pb.id,Product2Id = prod2.id,  unitPrice = 1200, IsActive = true,UseStandardPrice = false);
            insert pbe2;    
            //priceBookEntry pbn1=new priceBookEntry ( Product2Id = prod1.id, pricebook2id = pb.id, unitPrice = 1200, IsActive = true);
            //priceBookEntry pbn2=new priceBookEntry ( Product2Id = prod2.id, pricebook2id = pb.id, unitPrice = 1500, IsActive = true);
            //insert spbn1;
            //insert spbn2;         
            
            Opportunity opp = new Opportunity();
            opp.AverageGrossProfit__c=0;
            opp.MarketTarget__c=0;
            opp.Name = 'Test Opportunity Triggers';
            //opp.CurrencyIsoCode='RUB';
            opp.StageName = '01 – Universe';
            opp.CloseDate = System.today();
            opp.AccountId = acc.id;
            insert opp;                     
            Test.startTest();
            OpportunityLineItem oppLineItem1 = new OpportunityLineItem(Opportunityid = opp.id, PricebookentryId = pbe1.Id, quantity=2,totalPrice=pbe1.unitPrice,Distributor__c='Reinhart');
            OpportunityLineItem oppLineItem2 = new OpportunityLineItem(Opportunityid = opp.id, PricebookentryId = pbe2.Id, quantity=3,totalPrice=pbe2.unitPrice,Distributor__c='US GFS');
            Insert oppLineItem1;
            Insert oppLineItem2;
            Test.stopTest();
            Opportunity opp1 =[select id,name,AverageGrossProfit__c,MarketTarget__c,FS_TotalNumberOfCases__c from opportunity where id=:opp.id];
            system.debug(opp1);
            //system.debug(oppLineItem1.GPPercent__c);
            //system.debug(oppLineItem1.FS_MarketTarget__c);
            system.assertnotEquals(0, opp1.AverageGrossProfit__c);
            system.assertnotEquals(0, opp1.MarketTarget__c);
            
    }          
      
    }