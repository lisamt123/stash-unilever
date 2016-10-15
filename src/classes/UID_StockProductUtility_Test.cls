/**********************************************************************
 Name: UID_StockProductUtility_Test() 
 Copyright © 2016 Salesforce 
 ====================================================== 
 ====================================================== 
 Purpose: 
 1. Test class utility for Stock Product
 ====================================================== 
 ====================================================== 
 History 
 ------- 
 VERSION AUTHOR DATE DETAIL Description 
 1.0 Barcenas 03/22/2015 INITIAL DEVELOPMENT 
 ***********************************************************************/
@isTest
public class UID_StockProductUtility_Test {
	
	public static String STATUS_DRAFT = 'Draft';
	public static Id pricebookId;
	
    public static UID_Stocked_Product__c createStockedProduct(Account AccDetail, Integer addMonth) {
        UID_Stocked_Product__c stockedProduct 	= new UID_Stocked_Product__c();
	        stockedProduct.UID_Start_Date__c 	= System.today().AddMonths(addMonth);
	        stockedProduct.UID_End_Date__c 		= System.today().AddMonths(addMonth);
	        stockedProduct.UID_Distributor__c 	= AccDetail.Id;
	        stockedProduct.UID_Stock_Cover_Calculation_Flag__c = false;
	        stockedProduct.UID_Report_Date__c 	= System.today().AddMonths(addMonth);
            
        return stockedProduct;
    }
    
    public static List<UID_Stocked_Product__c> createListStockedProduct(Account AccDetail, Integer sProdCtr) {
          List<UID_Stocked_Product__c> stockedProductList = new List<UID_Stocked_Product__c>(); 
          for(Integer i=0; i< sProdCtr; i++) {
	        UID_Stocked_Product__c stockedProduct 	= new UID_Stocked_Product__c();
		        stockedProduct.UID_Start_Date__c 	= System.today().AddMonths(i);
		        stockedProduct.UID_End_Date__c 		= System.today().AddMonths(i);
		        stockedProduct.UID_Distributor__c 	= AccDetail.Id;
		        stockedProduct.UID_Stock_Cover_Calculation_Flag__c = false;
		        stockedProduct.UID_Report_Date__c 	= System.today().AddMonths(i);
	        
	        stockedProductList.add(stockedProduct); 
          }
        return stockedProductList;
    }
    
    public static UID_Stocked_Product_Summary__c createStockedSummary(Product2 productDetail, Integer netQuantity, Integer inQuantity, Id stockedProductId) {

        UID_Stocked_Product_Summary__c testStockedSummary = new UID_Stocked_Product_Summary__c();
            testStockedSummary.UID_Avail_Quantity__c = netQuantity;
            testStockedSummary.UID_Net_Quantity__c = netQuantity;
            testStockedSummary.UID_Material__c = productDetail.Id;
            testStockedSummary.UID_Stocked_Product__c = stockedProductId;           
            testStockedSummary.UID_In_Quantity__c = inQuantity;
        
        return testStockedSummary;
    }

    
    
    public static Product2 createProduct() {
   		 Product2 testProduct = new Product2();
            testProduct.Name = 'testProduct00';
            testProduct.UID_Material_ID__c = '920151111';
            testProduct.UID_Brand__c = 'PEPSODENT';
            testProduct.UID_Category__c = 'ORAL CARE';
            
        return testProduct;
    }
    
   public static PricebookEntry createPricebookEntry(Integer unitPrice, Product2 productDetail) {
   
   		pricebookId = Test.getStandardPricebookId();
   		
   		PricebookEntry productStandardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = productDetail.Id,
            UnitPrice = unitPrice, 
            IsActive = true);
            
        return productStandardPrice;
    }
    
	public static Account createAccount(String accountRecordType) {
   		
   		Account testAccount = new Account();
   		 	testAccount.RecordTypeId = accountRecordType;
            testAccount.Name = 'testAccount00';
            testAccount.UID_Region__c = 'SOUTH EAST ASIA';
            testAccount.UID_Segment__c = 'PI CUSTOMERS';
            testAccount.UID_Geography__c = 'OTHERS';
            testAccount.AccountNumber = '915113204';
            
        return testAccount;
    } 
    
    public static Order createOrder(Account AccDetail, Integer addMonthValue, String salesRecordType, String invoiceNumber) {
   		 
   		 pricebookId = Test.getStandardPricebookId();
   		 
   		 Order testOrder = new Order();
   			testOrder.AccountId = AccDetail.Id;
            testOrder.UID_Distributor__c = AccDetail.Id;
            testOrder.EffectiveDate = System.today().AddMonths(addMonthValue);
            testOrder.Status = STATUS_DRAFT;
            testOrder.UID_Invoice_Number__c = invoiceNumber;
            testOrder.RecordTypeId = salesRecordType;
            testOrder.Pricebook2Id = pricebookId; 
            
        return testOrder;
    }
    
    public static UID_Order_Product__c createOrderProduct(Order orderDetail, Product2 productDetail) {
   		 
   		 UID_Order_Product__c testOrderProduct = new UID_Order_Product__c();
            testOrderProduct.UID_Order__c = orderDetail.Id;
            testOrderProduct.UID_Product__c = productDetail.Id;
            testOrderProduct.UID_Invoice_Value__c = 100;
            testOrderProduct.UID_Order_Quantity__c = 10;
            
        return testOrderProduct;
    }
}