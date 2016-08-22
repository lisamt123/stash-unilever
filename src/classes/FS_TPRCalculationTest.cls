/**********************************************************************
Purpose: Test class for TPR Calculation.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     07/July/2016     Created
***********************************************************************/

@isTest(seealldata=false)
public class FS_TPRCalculationTest {

    static Opportunity opp;
    static PriceBookEntry pbe;
    static Product2 prod;
    static Account distributorAccount;
    
    //Add new OppProduct
    static testMethod void testAddOppProduct() {
        System.debug('start');
        
        setAllData();
                
        //Fetch Test User Data     
        user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
        system.runAs(SalesRepUser){
        
            Test.startTest();
            //set Opportunity Product
            OpportunityLineItem oppProd = new OpportunityLineItem();
            oppProd.OpportunityId = opp.Id;
            oppProd.Quantity = 500;
            oppProd.PricebookEntryId = pbe.Id;
            oppProd.TotalPrice = 3946725;
            oppProd.FS_tprPercent__c = 2;
            //oppProd.FS_valueNecessaryWithVAT__c = 500;
            //oppProd.FS_DistributorMarkup__c = 10;
            insert oppProd;
            
            System.debug('>>> opp: ' + opp);
            
            Test.stopTest();
            
            OpportunityLineItem oppProd1 = new OpportunityLineItem();
            oppProd1 = [SELECT id,
                                FS_tprPercent__c,
                                FS_additionalDiscount__c,
                                FS_grossSalesValue__c,
                                FS_netInvoiceValue__c,
                                FS_temporaryPriceReduction__c,
                                FS_turnover__c,
                                FS_productCost__c,
                                FS_supplyCost__c,
                                FS_supplyCostChain__c,
                                FS_grossProfit__c,
                                FS_grossMargin__c,
                                FS_gmWhenTPREqualsZero__c                    
                        FROM OpportunityLineItem
                        WHERE id =: oppProd.Id];
            
            
            
            System.debug('oppProd1: ' + oppProd1);
            
            System.debug('oppProd.FS_tprPercent__c: ' + oppProd1.FS_tprPercent__c);
            System.assertEquals(2.00, oppProd1.FS_tprPercent__c.setScale(2));
            
            System.debug('oppProd.FS_additionalDiscount__c: ' + oppProd1.FS_additionalDiscount__c);
            System.assertEquals(3.00, oppProd1.FS_additionalDiscount__c.setScale(2));
            
            System.debug('oppProd.FS_grossSalesValue__c: ' + oppProd1.FS_grossSalesValue__c);
            System.assertEquals(328893.75, oppProd1.FS_grossSalesValue__c.setScale(2));
            
            System.debug('oppProd.FS_netInvoiceValue__c: ' + oppProd1.FS_netInvoiceValue__c);
            System.assertEquals(274955.18, oppProd1.FS_netInvoiceValue__c.setScale(2));
            
            System.debug('oppProd.FS_temporaryPriceReduction__c: ' + oppProd1.FS_temporaryPriceReduction__c);
            System.assertEquals(16444.69, oppProd1.FS_temporaryPriceReduction__c.setScale(2));
            
            System.debug('oppProd.FS_turnover__c: ' + oppProd1.FS_turnover__c);
            System.assertEquals(244710.11, oppProd1.FS_turnover__c.setScale(2));
            
            System.debug('oppProd.FS_productCost__c: ' + oppProd1.FS_productCost__c);
            System.assertEquals(166615.00, oppProd1.FS_productCost__c.setScale(2));
            
            System.debug('oppProd.FS_supplyCost__c: ' + oppProd1.FS_supplyCost__c);
            System.assertEquals(19576.81, oppProd1.FS_supplyCost__c.setScale(2));
            
            System.debug('oppProd.FS_supplyCostChain__c: ' + oppProd1.FS_supplyCostChain__c);
            System.assertEquals(186191.81, oppProd1.FS_supplyCostChain__c.setScale(2));
            
            System.debug('oppProd.FS_grossProfit__c: ' + oppProd1.FS_grossProfit__c);
            System.assertEquals(58518.30, oppProd1.FS_grossProfit__c.setScale(2));
            
            System.debug('oppProd.FS_grossMargin__c: ' + oppProd1.FS_grossMargin__c);
            System.assertEquals(23.91, oppProd1.FS_grossMargin__c.setScale(2));
            
            System.debug('oppProd.FS_gmWhenTPREqualsZero__c: ' + oppProd1.FS_gmWhenTPREqualsZero__c);
            System.assertEquals(27.32, oppProd1.FS_gmWhenTPREqualsZero__c.setScale(2));
        
        }
        System.debug('end');
    }
    
    //Update existing OppProduct
    static testMethod void testUpdateOppProduct() {
        System.debug('start');
        
        setAllData();
        System.debug('pbe.Id: ' + pbe.Id);
        System.debug('pbe: ' + pbe);
        
        //Fetch Test User Data     
        user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
        system.runAs(SalesRepUser){
        
            Test.startTest();
            //set Opportunity Product
            OpportunityLineItem oppProd = new OpportunityLineItem();
            oppProd.OpportunityId = opp.Id;
            oppProd.Quantity = 400;
            oppProd.PricebookEntryId = pbe.Id;
            oppProd.TotalPrice = 3946725;
            oppProd.FS_tprPercent__c = 2;
            //oppProd.FS_valueNecessaryWithVAT__c = 500;
            //oppProd.FS_DistributorMarkup__c = 10;
            insert oppProd;
            
            opp.FS_casesPiece__c = 'cases';
            update opp;
            
            oppProd.Quantity = 500;
            update oppProd;
                    
            Test.stopTest();
            
            OpportunityLineItem oppProd1 = new OpportunityLineItem();
            oppProd1 = [SELECT id,
                                OpportunityId,
                                FS_tprPercent__c,
                                FS_additionalDiscount__c,
                                FS_grossSalesValue__c,
                                FS_netInvoiceValue__c,
                                FS_temporaryPriceReduction__c,
                                FS_turnover__c,
                                FS_productCost__c,
                                FS_supplyCost__c,
                                FS_supplyCostChain__c,
                                FS_grossProfit__c,
                                FS_grossMargin__c,
                                FS_gmWhenTPREqualsZero__c                    
                        FROM OpportunityLineItem
                        WHERE id =: oppProd.Id];
            
            System.debug('>>> opp: ' + opp);
            Opportunity opp1 = new Opportunity();
            opp1 = [SELECT id,
                            FS_casesPiece__c
                    FROM Opportunity
                    WHERE Id =: oppProd1.OpportunityId];
            System.debug('>>> opp1A: ' + opp1);
            
            
            System.debug('oppProd2: ' + oppProd1);
            
            System.debug('oppProd.FS_tprPercent__c: ' + oppProd1.FS_tprPercent__c);
            System.assertEquals(2.00, oppProd1.FS_tprPercent__c.setScale(2));
            
            System.debug('oppProd.FS_additionalDiscount__c: ' + oppProd1.FS_additionalDiscount__c);
            System.assertEquals(3.00, oppProd1.FS_additionalDiscount__c.setScale(2));
            
            System.debug('oppProd.FS_grossSalesValue__c: ' + oppProd1.FS_grossSalesValue__c);
            System.assertEquals(1315575.00, oppProd1.FS_grossSalesValue__c.setScale(2));
            
            System.debug('oppProd.FS_netInvoiceValue__c: ' + oppProd1.FS_netInvoiceValue__c);
            System.assertEquals(1099820.70, oppProd1.FS_netInvoiceValue__c.setScale(2));
            
            System.debug('oppProd.FS_temporaryPriceReduction__c: ' + oppProd1.FS_temporaryPriceReduction__c);
            System.assertEquals(65778.75, oppProd1.FS_temporaryPriceReduction__c.setScale(2));
            
            System.debug('oppProd.FS_turnover__c: ' + oppProd1.FS_turnover__c);
            System.assertEquals(978840.42, oppProd1.FS_turnover__c.setScale(2));
            
            System.debug('oppProd.FS_productCost__c: ' + oppProd1.FS_productCost__c);
            System.assertEquals(666460.00, oppProd1.FS_productCost__c.setScale(2));
            
            System.debug('oppProd.FS_supplyCost__c: ' + oppProd1.FS_supplyCost__c);
            System.assertEquals(78307.23, oppProd1.FS_supplyCost__c.setScale(2));
            
            System.debug('oppProd.FS_supplyCostChain__c: ' + oppProd1.FS_supplyCostChain__c);
            System.assertEquals(744767.23, oppProd1.FS_supplyCostChain__c.setScale(2));
            
            System.debug('oppProd.FS_grossProfit__c: ' + oppProd1.FS_grossProfit__c);
            System.assertEquals(234073.19, oppProd1.FS_grossProfit__c.setScale(2));
            
            System.debug('oppProd.FS_grossMargin__c: ' + oppProd1.FS_grossMargin__c);
            System.assertEquals(23.91, oppProd1.FS_grossMargin__c.setScale(2));
            
            System.debug('oppProd.FS_gmWhenTPREqualsZero__c: ' + oppProd1.FS_gmWhenTPREqualsZero__c);
            System.assertEquals(27.32, oppProd1.FS_gmWhenTPREqualsZero__c.setScale(2));
        
        }
        System.debug('end');
    }
    
    //Add OppProduct with Given Price
    static testMethod void testAddOppProductWithGivenPrice() {
        System.debug('start');
        
        setAllData();
        
        //Fetch Test User Data     
        user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
        system.runAs(SalesRepUser){
        
            Test.startTest();
            //set Opportunity Product
            OpportunityLineItem oppProd = new OpportunityLineItem();
            oppProd.OpportunityId = opp.Id;
            oppProd.Quantity = 500;
            oppProd.PricebookEntryId = pbe.Id;     
            oppProd.TotalPrice = 3946725;
            oppProd.FS_tprPercent__c = 2;
            oppProd.FS_valueNecessaryWithVAT__c = 500;
            oppProd.FS_DistributorMarkup__c = 10;
            
            insert oppProd;
            
            System.debug('>>> opp: ' + opp);
            
            Test.stopTest();
            
            OpportunityLineItem oppProd1 = new OpportunityLineItem();
            oppProd1 = [SELECT id,
                                FS_tprPercent__c,
                                FS_additionalDiscount__c,
                                FS_grossSalesValue__c,
                                FS_netInvoiceValue__c,
                                FS_temporaryPriceReduction__c,
                                FS_turnover__c,
                                FS_productCost__c,
                                FS_supplyCost__c,
                                FS_supplyCostChain__c,
                                FS_grossProfit__c,
                                FS_grossMargin__c,
                                FS_gmWhenTPREqualsZero__c,
                                FS_valueNecessaryWithVAT__c,
                                FS_DistributorMarkup__c,
                                FS_necessaryTPR__c,
                                FS_vat__c
                        FROM OpportunityLineItem
                        WHERE id =: oppProd.Id];
            
            
            
            System.debug('oppProd1: ' + oppProd1);
            
            System.debug('oppProd.FS_valueNecessaryWithVAT__c: ' + oppProd1.FS_valueNecessaryWithVAT__c);
            System.assertEquals(500, oppProd1.FS_valueNecessaryWithVAT__c.setScale(2));
            
            System.debug('oppProd.FS_DistributorMarkup__c: ' + oppProd1.FS_DistributorMarkup__c);
            System.assertEquals(10, oppProd1.FS_DistributorMarkup__c.setScale(2));
            
            System.debug('oppProd.FS_vat__c: ' + oppProd1.FS_vat__c);
            //System.assertEquals(18, oppProd1.FS_vat__c.setScale(2));
            
            System.debug('oppProd.FS_necessaryTPR__c: ' + oppProd1.FS_necessaryTPR__c);
            System.assertEquals(33.45, oppProd1.FS_necessaryTPR__c.setScale(2));
        
        }
        System.debug('end');
    }
    
    //Update OppProduct with Given Price
    static testMethod void testUpdateOppProductWithGivenPrice() {
    
		System.debug('start this');
        
        setAllData();
        //Fetch Test User Data     
        user SalesRepUser=[select id from user where UserName='newuseropphelper@testorg.com'];
        system.runAs(SalesRepUser){
            
            Test.startTest();
            //set Opportunity Product
            OpportunityLineItem oppProd = new OpportunityLineItem();
            oppProd.OpportunityId = opp.Id;
            oppProd.Quantity = 400;
            oppProd.PricebookEntryId = pbe.Id;     
            oppProd.TotalPrice = 3946725;
            oppProd.FS_tprPercent__c = 2;
            oppProd.FS_valueNecessaryWithVAT__c = 500;
            oppProd.FS_DistributorMarkup__c = 10;
            
            insert oppProd;
            
            System.debug('>>> opp: ' + opp);
            
            distributorAccount.FS_onInvoice__c = 0;
            update distributorAccount;
            
            opp.FS_casesPiece__c = 'cases';
            update opp;
            
            prod.FS_VATRU__c = 1;
            update prod;
            
            oppProd.Quantity = 500;
            update oppProd;        
            
            Test.stopTest();
            
            OpportunityLineItem oppProd1 = new OpportunityLineItem();
            oppProd1 = [SELECT id,
                                FS_tprPercent__c,
                                FS_additionalDiscount__c,
                                FS_grossSalesValue__c,
                                FS_netInvoiceValue__c,
                                FS_temporaryPriceReduction__c,
                                FS_turnover__c,
                                FS_productCost__c,
                                FS_supplyCost__c,
                                FS_supplyCostChain__c,
                                FS_grossProfit__c,
                                FS_grossMargin__c,
                                FS_gmWhenTPREqualsZero__c,
                                FS_valueNecessaryWithVAT__c,
                                FS_DistributorMarkup__c,
                                FS_necessaryTPR__c,
                                FS_vat__c
                        FROM OpportunityLineItem
                        WHERE id =: oppProd.Id];
            
            
            
            System.debug('oppProd3: ' + oppProd1);
            
            System.debug('oppProd.FS_valueNecessaryWithVAT__c: ' + oppProd1.FS_valueNecessaryWithVAT__c);
            System.assertEquals(500, oppProd1.FS_valueNecessaryWithVAT__c.setScale(2));
            
            System.debug('oppProd.FS_DistributorMarkup__c: ' + oppProd1.FS_DistributorMarkup__c);
            System.assertEquals(10, oppProd1.FS_DistributorMarkup__c.setScale(2));
            
            System.debug('oppProd.FS_vat__c: ' + oppProd1.FS_vat__c);
            //System.assertEquals(18, oppProd1.FS_vat__c.setScale(2));
            
            System.debug('oppProd.FS_necessaryTPR__c1: ' + oppProd1.FS_necessaryTPR__c);
            System.assertEquals(84.29, oppProd1.FS_necessaryTPR__c.setScale(2));
            
        }
        System.debug('end');        
    }
    
    //Data setting
    //@testSetup
    static void setAllData() {
        System.debug('start data setup');
        //Set up Custom settings for Opportunity Trigger
        //FSOpportunityTriggerSettings__c OppCustomSettings=new FSOpportunityTriggerSettings__c(name='isEnabled',Enabled__c=true);
        //insert OppCustomSettings; 
        
        Id operatorAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        Id distributorAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        //set custom settings
        /*
        FS_casePiece__c cp = FS_casePiece__c.getOrgDefaults();
        cp.FS_Case__c = 'box';
        cp.FS_Piece__c = 'piece';
        insert cp;
         */
        
        
        
        //Set User info START
        String profile='Unilever Food Solution - Russia';
        //String permissionset='FS_Sales_Rep';
        Profile p = [SELECT Id FROM Profile WHERE Name=:profile];
        Userrole role=[SELECT Id FROM UserRole WHERE Name = 'Field Sales Rep NDM'];
        User SalesRepUser1 = new User(Alias = 'newUser1', 
                                      Email='newuser1@testorg.com',
        							  EmailEncodingKey='UTF-8', 
                                      LastName='Testing', 
                                      LanguageLocaleKey='en_US',
        							  LocaleSidKey='en_US', 
                                      ProfileId = p.Id,
                                      UserRoleId=role.id,
        							  TimeZoneSidKey='America/Los_Angeles', 
                                      UserName='newuseropphelper1@testorg.com');
        insert SalesRepUser1;
        User SalesRepUser = new User(Alias = 'newUser', 
                                     Email='newuser@testorg.com',
        							 EmailEncodingKey='UTF-8', 
                                     LastName='Testing', 
                                     LanguageLocaleKey='en_US',
        							 LocaleSidKey='en_US', 
                                     ProfileId = p.Id,
                                     UserRoleId=role.id,
                                     ManagerId = SalesRepUser1.Id,
        							 TimeZoneSidKey='America/Los_Angeles', 
                                     UserName='newuseropphelper@testorg.com');
        insert SalesRepUser;
        //Set User info END
        
        system.runAs(SalesRepUser){
        
        
        	//Set up Custom settings for Opportunity Trigger
            FSOpportunityTriggerSettings__c OppCustomSettings=new FSOpportunityTriggerSettings__c(name='isEnabled',Enabled__c=true);
            insert OppCustomSettings;
            
            insert new FS_casePiece__c(FS_Case__c = 'cases', FS_Piece__c = 'piece');        
            FS_casePiece__c cp = [SELECT FS_Case__c, FS_Piece__c FROM FS_casePiece__c];
            insert new FSVATRU__c(FS_Value_1__c = 10, FS_Value_2__c = 18);        
            insert new FS_SalesOrgCode__c(FS_RU_Code__c = 'R', FS_UA_Code__c = 'U');
        
            //set operatorAccount
            Account operatorAccount = new Account();
            operatorAccount.RecordTypeId = operatorAccountRecordType;
            operatorAccount.Name = 'FS_Test Account Operator';
            insert operatorAccount;
            
            //set distributorAccount
            distributorAccount = new Account();
            distributorAccount.RecordTypeId = distributorAccountRecordType;
            distributorAccount.Name = 'FS_Test Account Distributor';
            distributorAccount.FS_supplyCost__c = 8;
            distributorAccount.FS_Distributor_Type__c = 'Strategic';
            distributorAccount.FS_onInvoice__c = 12;
            distributorAccount.FS_offInvoice__c = 11;
            insert distributorAccount;
            
            //set Product
            prod = new Product2();
            prod.Name = 'Product Test';
            //prod.Active__c = true;
            prod.StartDate__c = date.today();
            prod.EndDate__c = date.today() + 30;
            prod.MarketType__c='BOH MAYO';
            prod.IsActive = true;
            prod.FS_stdPerUnit__c = 333.23;
            prod.FS_temporaryTPR__c = 0.00;
            prod.FS_VATRU__c = 2;
            prod.FS_VATUA__c = 2;
            prod.FS_ZSU__c = 4;
            insert prod;
            
            //Fetch standard Price Book     
            System.debug('Test.getStandardPricebookId(): ' + Test.getStandardPricebookId());
            Id pricebookId = Test.getStandardPricebookId();
            
            //set PricebookEntry
            pbe = new PriceBookEntry();
            pbe.Pricebook2Id = pricebookId;
            pbe.Product2Id = prod.Id;
            pbe.UnitPrice = 2631.15;
            pbe.IsActive = true;
            pbe.UseStandardPrice = false;
            pbe.CurrencyIsoCode = 'RUB';
            pbe.FS_salesOrgCode__c = 'R002';
            //pbe.FS_VAT__c = 18;
            insert pbe;     
            
            //set Opportunity
            opp = new Opportunity();
            opp.Name = 'Test Opportunity';
            opp.AccountId = operatorAccount.Id;
            opp.StageName = '01 – Universe';
            //opp.StageName = 'Closed Won';
            opp.CloseDate = date.today() + 30;
            opp.CurrencyIsoCode = 'RUB';
            opp.FS_casesPiece__c = 'piece';
            opp.FS_DateOfSend__c = date.today();
            opp.FS_endDateTPR__c = date.today() + 30;
            opp.FS_distributor__c = distributorAccount.Id;
            opp.FS_selfCollection__c = true;
            opp.FS_prePaid__c = true;
            insert opp;  
        
            System.debug('operatorAccount: ' + operatorAccount);
            System.debug('distributorAccount: ' + distributorAccount);
            System.debug('prod: ' + prod);
            System.debug('pbe: ' + pbe);
            System.debug('opp: ' + opp);            
    	}
        
    }
}