@isTest
public class TEL_ProductInfo_CC_Test {
    
    @testSetup
    public static void createData() {
        Account accObj = new Account();
        accObj.Name = 'Acc 1';
        //accObj.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'TEL_Telesales_Account' LIMIT 1].Id;
        System.Database.insert(accObj);
        
        Campaign campObj = new Campaign();
        campObj.Name = 'Campaign 1';
        campObj.CurrencyIsoCode = 'EUR';
        campObj.IsActive = true;
        System.Database.insert(campObj);
        
        TEL_Campaign_Accounts__c campAccObj = new TEL_Campaign_Accounts__c();
        campAccObj.TEL_Account__c = accObj.Id;
        campAccObj.TEL_Campaign__c = campObj.Id;
        System.Database.insert(campAccObj);
        
        Product2 prodObj = new Product2();
        prodObj.Name = 'Product 15';
        prodObj.IsActive = true;
        System.Database.insert(prodObj);
        
        Product2 prodObj1 = new Product2();
        prodObj1.Name = 'Product 5';
        prodObj1.IsActive = true;
        System.Database.insert(prodObj1);
        
        TEL_Campaign_Products__c campProdObj = new TEL_Campaign_Products__c();
        campProdObj.TEL_Campaign__c = campObj.Id;
        campProdObj.TEL_Product_Name__c = prodObj.Id;
        System.Database.insert(campProdObj);
        
        TEL_Campaign_Products__c campProdObj1 = new TEL_Campaign_Products__c();
        campProdObj1.TEL_Campaign__c = campObj.Id;
        campProdObj1.TEL_Product_Name__c = prodObj.Id;
        System.Database.insert(campProdObj1);
        
        String priceBook2Id = Test.getStandardPricebookId();            
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = priceBook2Id;
        pbe.Product2Id = prodObj.Id;
        pbe.UnitPrice = 1.0;
        pbe.UseStandardPrice = false;
        pbe.IsActive = true;
        System.Database.insert(pbe);
        
        PricebookEntry pbe1 = new PricebookEntry();
        pbe1.Pricebook2Id = priceBook2Id;
        pbe1.Product2Id = prodObj1.Id;
        pbe1.UnitPrice = 5.0;
        pbe1.UseStandardPrice = false;
        pbe1.IsActive = true;
        System.Database.insert(pbe1);
        
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'Opp 1';
        oppObj.AccountId = accObj.Id;
        oppObj.StageName = 'Transmitted';
        oppObj.CloseDate = Date.today().addDays(15);
        oppobj.Pricebook2Id = priceBook2Id;
        System.Database.insert(oppObj);
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = oppObj.Id;
        oli.PricebookEntryId = pbe.Id;
        oli.Quantity = 15;
        oli.UnitPrice = 1.0;
        oli.TEL_Associated_Campaigns__c = 'Campanha Teste OLI 1';
        System.Database.insert(oli);
        
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.OpportunityId = oppObj.Id;
        oli1.PricebookEntryId = pbe1.Id;
        oli1.Quantity = 10;
        oli1.UnitPrice = 5.0;
        oli1.TEL_Associated_Campaigns__c = 'Campanha Teste OLI 2';
        System.Database.insert(oli1);
    }
    
    static testMethod void getOpp() {
        System.Test.startTest();
        Opportunity opp = TEL_ProductInfo_CC.getOpportunity([SELECT Id FROM Opportunity LIMIT 1].Id);
        System.assert(opp != null);
        System.Test.stopTest();
    }
    
    static testMethod void getOpenOrderProducts() {
        System.Test.startTest();
        List<TEL_TelesalesWrapper.ProductInfo> wrapperList = TEL_ProductInfo_CC.getOpenOrderProducts([SELECT Id, AccountId, CloseDate FROM Opportunity LIMIT 1]);
        System.assert(!wrapperList.isEmpty());
        System.Test.stopTest();
    }
    
    static testMethod void getFullProductList() {
        System.Test.startTest();
        List<TEL_TelesalesWrapper.ProductInfo> wrapperList = TEL_ProductInfo_CC.getFullProductsList([SELECT Id FROM Opportunity LIMIT 1].Id);
        System.assert(!wrapperList.isEmpty());
        System.Test.stopTest();
    }
    
    static testMethod void getClosedOrderProducts() {
        System.Test.startTest();
        List<TEL_TelesalesWrapper.ProductInfo> wrapperList = TEL_ProductInfo_CC.getClosedOrderProducts([SELECT Id FROM Opportunity LIMIT 1]);
        System.assert(!wrapperList.isEmpty());
        System.Test.stopTest();
    }
    
    static testMethod void getLostOrderProducts() {
        System.Test.startTest();
        List<TEL_TelesalesWrapper.ProductInfo> wrapperList = TEL_ProductInfo_CC.getLostOrderProducts();
        System.assert(!wrapperList.isEmpty());
        System.Test.stopTest();
    }
    
    static testMethod void getSelectedItems() {
        List<TEL_TelesalesWrapper.ProductInfo> wrapperList = new List<TEL_TelesalesWrapper.ProductInfo>();
        TEL_TelesalesWrapper.ProductInfo wrapperProd = new TEL_TelesalesWrapper.ProductInfo();
        wrapperProd.isSelected = true;
        wrapperList.add(wrapperProd);
        String wrapperListJSON = JSON.serialize(wrapperList);
        
        System.Test.startTest();
        List<TEL_TelesalesWrapper.ProductInfo> wrapperListReturned = TEL_ProductInfo_CC.getSelectedItems(wrapperListJSON);
        System.assert(!wrapperListReturned.isEmpty());
        System.Test.stopTest();
    }
    
    static testMethod void createOrder() {
        String oppId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        
        List<TEL_TelesalesWrapper.ProductInfo> wrapperList = new List<TEL_TelesalesWrapper.ProductInfo>();
        TEL_TelesalesWrapper.ProductInfo wrapperProd = new TEL_TelesalesWrapper.ProductInfo();
        wrapperProd.opportunityId = oppId;
        wrapperProd.productId = [SELECT Id FROM Product2 LIMIT 1].Id;
        wrapperProd.isSelected = true;
        wrapperProd.amount = 15;
        wrapperProd.price = '1';
        wrapperList.add(wrapperProd);
        String wrapperListJSON = JSON.serialize(wrapperList);
        
        System.Test.startTest();
        TEL_ProductInfo_CC.createOrder(wrapperListJSON);
        System.assert(!wrapperList.isEmpty());
        System.Test.stopTest();
    }
    
    static testMethod void getCampaignIdsElse() {
        System.Test.startTest();
        TEL_OpenProductOrder openProd = new TEL_OpenProductOrder([SELECT Id, AccountId, CloseDate FROM Opportunity LIMIT 1]);
        System.assert(openProd.getCampaignIds(new List<TEL_Campaign_Accounts__c>()).isEmpty());
        System.Test.stopTest();
    }
 
    static testMethod void getOppLineItemsElse() {
        System.Test.startTest();
        TEL_OpenProductOrder openProd = new TEL_OpenProductOrder([SELECT Id, AccountId, CloseDate FROM Opportunity LIMIT 1]);
        System.assert(openProd.getOppLineItems(new List<Opportunity>()).isEmpty());
        System.Test.stopTest();
    }
    
    static testMethod void checkLastOrderAmount() {
        Product2 prodObj = new Product2();
        prodObj.Name = 'Product 1515';
        prodObj.IsActive = true;
        System.Database.insert(prodObj);
        
        Campaign campObj = new Campaign();
        campObj.Name = 'Campaign 15';
        campObj.CurrencyIsoCode = 'EUR';
        campObj.IsActive = true;
        System.Database.insert(campObj);
        
        TEL_Campaign_Products__c campProdObj = new TEL_Campaign_Products__c();
        campProdObj.TEL_Campaign__c = campObj.Id;
        campProdObj.TEL_Product_Name__c = prodObj.Id;
        System.Database.insert(campProdObj);
        
        System.Test.startTest();
        TEL_OpenProductOrder openProd = new TEL_OpenProductOrder([SELECT Id, AccountId, CloseDate FROM Opportunity LIMIT 1]);
        System.assert(String.isBlank(openProd.checkLastOrderAmount(campProdObj)));
        System.Test.stopTest();
    }
    
    static testMethod void checkCampaignDuplicity() {
        Product2 prodObj = new Product2();
        prodObj.Name = 'Product 151515';
        prodObj.IsActive = true;
        System.Database.insert(prodObj);
        
        Campaign campObj = new Campaign();
        campObj.Name = 'Campaign 1515';
        campObj.CurrencyIsoCode = 'EUR';
        campObj.IsActive = true;
        System.Database.insert(campObj);
        
        TEL_Campaign_Products__c campProdObj = new TEL_Campaign_Products__c();
        campProdObj.TEL_Campaign__c = campObj.Id;
        campProdObj.TEL_Product_Name__c = prodObj.Id;
        System.Database.insert(campProdObj);
        
        List<TEL_TelesalesWrapper.ProductInfo> wrapperList = new List<TEL_TelesalesWrapper.ProductInfo>();
        TEL_TelesalesWrapper.ProductInfo prodInfo = new TEL_TelesalesWrapper.ProductInfo();
        prodInfo.productId = prodObj.Id;
        wrapperList.add(prodInfo);
        
        System.Test.startTest();
        TEL_OpenProductOrder openProd = new TEL_OpenProductOrder([SELECT Id, AccountId, CloseDate FROM Opportunity LIMIT 1]);
        System.assert(!openProd.checkCampaignDuplicity(wrapperList, campProdObj));
        System.Test.stopTest();
    }
    
}