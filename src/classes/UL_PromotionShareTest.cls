/**
 * @author          Devesh Murdiya
 * @version         1.0
 * @date            12/16/2016
 * @description     Test class for Promotion Share
 */
@isTest
private class UL_PromotionShareTest {    
    /**
    * @author           Devesh Murdiya
    * @version          1.0
    * @date             12/16/2016
    * @description      Method to call PromotionshareTrigger handler class and UserCustomerTriggerHandler class
    */
    static testMethod void createPromotionShare() {
        test.starttest();
        /*User Record Creation*/
        Profile p = [select id from profile where name='System Administrator' Limit 1];                
        User u = new User(FirstName = 'test1',LastName = 'of Arendelle',Email = 'elsa@disney.com', Alias = 'elsa1',Username  = 'test1@disney.com',LocaleSidKey= 'en_US', TimeZoneSidKey='America/Los_Angeles',ProfileID=  p.id,LanguageLocaleKey = 'en_US',EmailEncodingKey  = 'UTF-8');
        User u1 = new User(FirstName = 'test2',LastName = 'of Arendelle1',Email = 'elsa1@disney.com', Alias = 'elsa2',Username  = 'test2@disney.com',LocaleSidKey= 'en_US', TimeZoneSidKey='America/Los_Angeles',ProfileID=  p.id,LanguageLocaleKey = 'en_US',EmailEncodingKey  = 'UTF-8'); 
        insert u;
        insert u1;
        
        /*Product Template Creation*/
        ACCL__Product_Template__c prodTemp = new ACCL__Product_Template__c();
        prodTemp.Name = 'testShareProductTeamp';
        prodTemp.ACCL__Description_Language_1__c = 'TestEnglish';
        //prodTemp.ACCL__Sales_Org__c = 'AR01';
        insert prodTemp;
       
        
        /*Product Record Creation*/
        ACCL__Product__c product = new ACCL__Product__c();
        product.Name = 'testShareProd';        
        product.ACCL__Description_1_Language_1__c = 'testdescription';
        product.ACCL__Product_Code__c = 'testProductCode';
        product.ACCL__Product_Template__c = prodTemp.Id;
        product.ACCL__Field_Valid_From__c=System.today();
        product.ACCL__Field_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__Delivery_Valid_From__c=System.today();
        product.ACCL__Delivery_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__KAM_Valid_From__c=System.today();
        product.ACCL__KAM_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__New_Item_Valid_From__c=System.today();
        product.ACCL__New_Item_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__Fund_Valid_From__c=System.today();
        product.ACCL__Fund_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__Category__c = null;
        insert product;
        
        /*recordtype*/
        RecordType rec = [select id,sobjecttype from recordtype where name='Customer' and sobjecttype='ACCL__Account_Template__c' limit 1];
        /*Insert Account Template*/
        ACCL__Account_Template__c accTem = new ACCL__Account_Template__c();
        accTem.recordtypeid = rec.id;
        accTem.ACCL__Active__c = true;
        accTem.Name = 'testAccountTemplate';
        accTem.ACCL__Description_Language_1__c = 'test';
        insert accTem;

        /*Insert Account*/
        Account acc = new Account();
        acc.Name = 'test Account';
        acc.ACCL__Account_Template__c = accTem.id;
        insert acc;
        
        /*promotion Record Creation*/         
        ACCL__Promotion__c prom = new ACCL__Promotion__c(); 
        prom.ACCL__Anchor_Account__c = acc.id; 
        insert prom;
                      
        
        /*Promotion Category Record creation*/
        UL_PromotionCategory__c promCat = new UL_PromotionCategory__c();
        promCat.Name = 'testSharePromCat';
        promCat.Product__c = product.id;
        promCat.Heroku_Product_Id__c = product.id;
        promCat.Promotion__c = prom.id;
        insert  promCat;
        
        /*UserCustomerProduct Record Creation*/
        List<UL_UserCustomerProduct__c> lstUsCus = new List<UL_UserCustomerProduct__c>();
        UL_UserCustomerProduct__c userCPobj = new UL_UserCustomerProduct__c();
        userCPobj.AccessType__c = 'Read';
        userCPobj.Product__c = product.id;
        userCPobj.User__c = u.id;
        lstUsCus.add(userCPobj);
        
        UL_UserCustomerProduct__c userCPobj1 = userCPobj.clone(false,false,false,false);
        userCPobj1.User__c = u1.id;
        lstUsCus.add(userCPobj1);
        insert lstUsCus;
        
        /*Fund Record Creation*/
        UL_PromotionCategory__c promCat1 =  promCat.clone(false,false,false,false);
        //promCat1.Heroku_Product_Id__c = 'testProdShare1';   
        insert promCat1;
        
        test.stoptest();
        
    }        
    /**
    * @author           Devesh Murdiya
    * @version          1.0
    * @date             12/16/2016
    * @description      Method to call PromotionshareTrigger handler class and UserCustomerTriggerHandler class
    */
    static testMethod void deletePromotionShare() {
        test.starttest();
        /*User Record Creation*/
        Profile p = [select id from profile where name='System Administrator' Limit 1];                
        User u = new User(FirstName = 'test1',LastName = 'of Arendelle',Email = 'elsa@disney.com', Alias = 'elsa1',Username  = 'test1@disney.com',LocaleSidKey= 'en_US', TimeZoneSidKey='America/Los_Angeles',ProfileID=  p.id,LanguageLocaleKey = 'en_US',EmailEncodingKey  = 'UTF-8');
        User u1 = new User(FirstName = 'test2',LastName = 'of Arendelle1',Email = 'elsa1@disney.com', Alias = 'elsa2',Username  = 'test2@disney.com',LocaleSidKey= 'en_US', TimeZoneSidKey='America/Los_Angeles',ProfileID=  p.id,LanguageLocaleKey = 'en_US',EmailEncodingKey  = 'UTF-8'); 
        insert u;
        insert u1;
        
        /*Product Template Creation*/
        ACCL__Product_Template__c prodTemp = new ACCL__Product_Template__c();
        prodTemp.Name = 'testShareProductTeamp';
        prodTemp.ACCL__Description_Language_1__c = 'TestEnglish';
        //prodTemp.ACCL__Sales_Org__c = 'AR01';
        insert prodTemp;
        
        /*Product Record Creation*/
        ACCL__Product__c product = new ACCL__Product__c();
        product.Name = 'testShareProd';        
        product.ACCL__Description_1_Language_1__c = 'testdescription';
        product.ACCL__Product_Code__c = 'testProductCode';
        product.ACCL__Product_Template__c = prodTemp.Id;
        product.ACCL__Field_Valid_From__c=System.today();
        product.ACCL__Field_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__Delivery_Valid_From__c=System.today();
        product.ACCL__Delivery_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__KAM_Valid_From__c=System.today();
        product.ACCL__KAM_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__New_Item_Valid_From__c=System.today();
        product.ACCL__New_Item_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__Fund_Valid_From__c=System.today();
        product.ACCL__Fund_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__Category__c = null;
        insert product;               
        
        /*recordtype*/
        RecordType rec = [select id,sobjecttype from recordtype where name='Customer' and sobjecttype='ACCL__Account_Template__c' limit 1];
        /*Insert Account Template*/
        ACCL__Account_Template__c accTem = new ACCL__Account_Template__c();
        accTem.recordtypeid = rec.id;
        accTem.ACCL__Active__c = true;
        accTem.Name = 'testAccountTemplate';
        accTem.ACCL__Description_Language_1__c = 'test';
        insert accTem;

        /*Insert Account*/
        Account acc = new Account();
        acc.Name = 'test Account';
        acc.ACCL__Account_Template__c = accTem.id;
        insert acc;
        
        /*promotion Record Creation*/         
        ACCL__Promotion__c prom = new ACCL__Promotion__c(); 
        prom.ACCL__Anchor_Account__c = acc.id; 
        insert prom;
        
        /*Promotion Category Record creation*/
        UL_PromotionCategory__c promCat = new UL_PromotionCategory__c();
        promCat.Name = 'testSharePromCat';
        promCat.Product__c = product.id;
        promCat.Heroku_Product_Id__c = product.id;
        promCat.Promotion__c = prom.id;     
        insert  promCat;
        
        /*UserCustomerProduct Record Creation*/
        List<UL_UserCustomerProduct__c> lstUsCus = new List<UL_UserCustomerProduct__c>();
        UL_UserCustomerProduct__c userCPobj = new UL_UserCustomerProduct__c();
        userCPobj.AccessType__c = 'Read';
        userCPobj.Product__c = product.id;
        userCPobj.User__c = u.id;
        lstUsCus.add(userCPobj);
        
        UL_UserCustomerProduct__c userCPobj1 = userCPobj.clone(false,false,false,false);
        userCPobj1.User__c = u1.id;
        lstUsCus.add(userCPobj1);
        insert lstUsCus;
        
        /*Promotion category Record Creation*/
        UL_PromotionCategory__c promCat1 =  promCat.clone(false,false,false,false);
        //promCat1.Heroku_Product_Id__c = product.id;   
        insert promCat1;
        
        /*Insert Customer Manager*/
        ACCL__Account_Manager__c cm = new ACCL__Account_Manager__c();
        cm.ACCL__Active__c = true;
        cm.UL_Create_Type__c = 'Manual';
        cm.ACCL__Account__c = acc.id;
        cm.ACCL__User__c = u1.id;
        cm.ACCL__Valid_From__c = system.today();
        cm.ACCL__Valid_Thru__c = system.today().addMonths(5);
        insert cm;
        ACCL__Account_Manager__c cm1 = cm.clone(false,false,false,false);
        cm1.ACCL__User__c = u.id;
        insert cm1;
        
        /*Promotion Share*/
        ACCL__Promotion__share pmshare = new ACCL__Promotion__share();
        pmshare.parentid= prom.id;
        pmshare.UserOrGroupId = u.id;
        pmshare.accesslevel = 'Read';
        insert pmshare;
        
        /*Delete UserCustomerProduct record*/
        delete lstUsCus;
        test.stoptest();
        
    }
    
    /*******************************************************************
    Purpose: Test method to validate promotion product insertion/deletion 
    Version: 1.0
    Parameters: N/A
    Returns: N/A
    Throws N/A
    ********************************************************************/
    @isTest
    private static void promotionProductTest(){
    
        /*Get Account template record type*/
        RecordType accountRecordType = [select id,sobjecttype from recordtype where name='Customer' and sobjecttype='ACCL__Account_Template__c' limit 1];
        
        /*Insert Account Template*/
        ACCL__Account_Template__c accountTeam = new ACCL__Account_Template__c();
        accountTeam.recordtypeid = accountRecordType.id;
        accountTeam.ACCL__Active__c = true;
        accountTeam.Name = 'testAccountTemplate';
        accountTeam.ACCL__Description_Language_1__c = 'test';
        insert accountTeam;
    
        /*Insert Account*/
        Account account = new Account();
        account.Name = 'PromotionShareTest-Account';
        account.ACCL__Account_Template__c = accountTeam.id;
        insert account;
        
        /*promotion Record Creation*/         
        ACCL__Promotion__c promotion = new ACCL__Promotion__c(); 
        promotion.ACCL__Anchor_Account__c = account.id; 
        insert promotion;
    
        /*Product Template Creation*/
        ACCL__Product_Template__c testProductTemplate = new ACCL__Product_Template__c();
        testProductTemplate.Name = 'Test Product-Template';
        testProductTemplate.ACCL__Description_Language_1__c = 'en';
        insert testProductTemplate ;
        
        /*Product -  Record Creation for Criterion level 2*/
        ACCL__Product__c criterionProduct = new ACCL__Product__c();
        criterionProduct.Name = 'testProduct3';        
        criterionProduct.ACCL__Description_1_Language_1__c = 'en-Us';
        criterionProduct.ACCL__Product_Code__c = '9999';
        criterionProduct.ACCL__Product_Template__c = testProductTemplate.Id;
        criterionProduct.ACCL__Field_Valid_From__c=System.today();
        criterionProduct.ACCL__Field_Valid_Thru__c = System.today().addMonths(5);
        criterionProduct.ACCL__Delivery_Valid_From__c=System.today();
        criterionProduct.ACCL__Delivery_Valid_Thru__c = System.today().addMonths(5);
        criterionProduct.ACCL__KAM_Valid_From__c=System.today();
        criterionProduct.ACCL__KAM_Valid_Thru__c = System.today().addMonths(5);
        criterionProduct.ACCL__New_Item_Valid_From__c=System.today();
        criterionProduct.ACCL__New_Item_Valid_Thru__c = System.today().addMonths(5);
        criterionProduct.ACCL__Fund_Valid_From__c=System.today();
        criterionProduct.ACCL__Fund_Valid_Thru__c = System.today().addMonths(5);
        criterionProduct.ACCL__Category__c = null;
        insert criterionProduct;
        
    
        /*Product1 - Record Creation*/
        ACCL__Product__c product1 = new ACCL__Product__c();
        product1.Name = 'testProduct1';
        product1.ACCL__Criterion_2_Product__c   = criterionProduct.id;      
        product1.ACCL__Description_1_Language_1__c = 'en-Us';
        product1.ACCL__Product_Code__c = '1234';
        product1.ACCL__Product_Template__c = testProductTemplate.Id;
        product1.ACCL__Field_Valid_From__c=System.today();
        product1.ACCL__Field_Valid_Thru__c = System.today().addMonths(5);
        product1.ACCL__Delivery_Valid_From__c=System.today();
        product1.ACCL__Delivery_Valid_Thru__c = System.today().addMonths(5);
        product1.ACCL__KAM_Valid_From__c=System.today();
        product1.ACCL__KAM_Valid_Thru__c = System.today().addMonths(5);
        product1.ACCL__New_Item_Valid_From__c=System.today();
        product1.ACCL__New_Item_Valid_Thru__c = System.today().addMonths(5);
        product1.ACCL__Fund_Valid_From__c=System.today();
        product1.ACCL__Fund_Valid_Thru__c = System.today().addMonths(5);
        product1.ACCL__Category__c = null;
        insert product1;  
        
        /*Product2 -  Record Creation*/
        ACCL__Product__c product2 = new ACCL__Product__c();
        product2.Name = 'testProduct2'; 
        product2.ACCL__Criterion_2_Product__c   = criterionProduct.id;        
        product2.ACCL__Description_1_Language_1__c = 'en-Us';
        product2.ACCL__Product_Code__c = '5678';
        product2.ACCL__Product_Template__c = testProductTemplate.Id;
        product2.ACCL__Field_Valid_From__c=System.today();
        product2.ACCL__Field_Valid_Thru__c = System.today().addMonths(5);
        product2.ACCL__Delivery_Valid_From__c=System.today();
        product2.ACCL__Delivery_Valid_Thru__c = System.today().addMonths(5);
        product2.ACCL__KAM_Valid_From__c=System.today();
        product2.ACCL__KAM_Valid_Thru__c = System.today().addMonths(5);
        product2.ACCL__New_Item_Valid_From__c=System.today();
        product2.ACCL__New_Item_Valid_Thru__c = System.today().addMonths(5);
        product2.ACCL__Fund_Valid_From__c=System.today();
        product2.ACCL__Fund_Valid_Thru__c = System.today().addMonths(5);
        product2.ACCL__Category__c = null;
        insert product2;
        
        test.startTest();
        Set<Id> productSet = null;
        
        //Check with null promotionId, no record should be created
        UL_PromotionUtility.updatePromotionProduct(UL_Utility.NULL_ID, productSet);
        List<UL_PromotionCategory__c> promotionCategoryList = [SELECT id FROM UL_PromotionCategory__c WHERE Promotion__c=: promotion.id];
        //system.assertEquals(0, promotionCategoryList.size());
        
        //Do not pass any product, no record should be created 
        UL_PromotionUtility.updatePromotionProduct(promotion.id, productSet);
        promotionCategoryList = [SELECT id FROM UL_PromotionCategory__c WHERE Promotion__c=: promotion.id];
        //system.assertEquals(0, promotionCategoryList.size());
       
        productSet = new Set<Id>();            
        //Insert a new record to PromotionCategory
        productSet.add(product1.id);
        UL_PromotionUtility.updatePromotionProduct(promotion.id, productSet);
        promotionCategoryList = [SELECT id FROM UL_PromotionCategory__c WHERE Promotion__c=: promotion.id];
        //system.assertEquals(1, promotionCategoryList.size());
        
        //Insert a second record to PromotionCategory, no duplication 
        productSet.add(product2.id);
        UL_PromotionUtility.updatePromotionProduct(promotion.id, productSet);
        promotionCategoryList = [SELECT id,Heroku_Product_Id__c FROM UL_PromotionCategory__c WHERE Promotion__c=: promotion.id];
        //system.assertEquals(2, promotionCategoryList.size());
        
        //Remove 1 record with Product 1 and retain only 1 record with Product 2
        productSet.clear();
        productSet.add(product2.id);
        UL_PromotionUtility.updatePromotionProduct(promotion.id, productSet);
        
        
        test.stopTest();
        
        promotionCategoryList = [SELECT Heroku_Product_Id__c FROM UL_PromotionCategory__c WHERE Promotion__c=: promotion.id];
        system.assertEquals(1, promotionCategoryList.size());
        system.assertEquals(promotionCategoryList[0].Heroku_Product_Id__c, product2.id);
    }
}