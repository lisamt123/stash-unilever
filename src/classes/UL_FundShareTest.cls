/**
 * @author          Devesh Murdiya
 * @version         1.0
 * @date            12/15/2016
 * @description     Test class for Fund Share
 */
@isTest
private class UL_FundShareTest {    
    /**
    * @author           Devesh Murdiya
    * @version          1.0
    * @date             12/15/2016
    * @description      Method to call FundshareTrigger handler class and UserCustomerTriggerHandler class
    */
    static testMethod void createfundShare() {
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
        
        /*Fund Template Creation*/
        ACCL__Fund_Template__c fundTemplate = new ACCL__Fund_Template__c();
        fundTemplate.Name = 'testfundTemaplate'; 
        fundTemplate.ACCL__Active__c = True;
        fundTemplate.ACCL__Anchor_Type__c= 'Customer Product';
        fundTemplate.ACCL__Description_Language_1__c ='English';
        fundTemplate.ACCL__Sort__c= 1  ;        
        insert fundTemplate;
        
        /*Fund Record Creation*/
        ACCL__Fund__c fundRecord = new ACCL__Fund__c(); 
        ACCL__Fund__c fundRecord2 = new ACCL__Fund__c();
        fundRecord.ACCL__Anchor_Product__c=product.id;        
        fundRecord.ACCL__Fund_Template__c=fundTemplate.id;
        fundRecord.ACCL__Status__c='Active';
        fundRecord.ACCL__Valid_From__c=System.today();
        fundRecord.ACCL__Valid_Thru__c=System.today().addMonths(5);                
        insert fundRecord;
        
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
        fundRecord2 = fundRecord.clone(false,false,false,false);
        insert fundRecord2;             
        
        test.stoptest();
        
    }    
    
    /**
    * @author           Devesh Murdiya
    * @version          1.0
    * @date             12/15/2016
    * @description      Method to call FundshareTrigger handler class and UserCustomerTriggerHandler class
    */
    static testMethod void deletefundShare() {
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
        
        /*Fund Template Creation*/
        ACCL__Fund_Template__c fundTemplate = new ACCL__Fund_Template__c();
        fundTemplate.Name = 'testfundTemaplate'; 
        fundTemplate.ACCL__Active__c = True;
        fundTemplate.ACCL__Anchor_Type__c= 'Customer Product';
        fundTemplate.ACCL__Description_Language_1__c ='English';
        fundTemplate.ACCL__Sort__c= 1  ;
        //fundTemplate.ACCL__Sales_Org__c = 'AR01';
        insert fundTemplate;
        
        /*Fund Record Creation*/
        ACCL__Fund__c fundRecord = new ACCL__Fund__c(); 
        ACCL__Fund__c fundRecord2 = new ACCL__Fund__c();
        fundRecord.ACCL__Anchor_Product__c=product.id;        
        fundRecord.ACCL__Fund_Template__c=fundTemplate.id;
        fundRecord.ACCL__Status__c='Active';
        fundRecord.ACCL__Valid_From__c=System.today();
        fundRecord.ACCL__Valid_Thru__c=System.today().addMonths(5);                
        insert fundRecord;
        
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
                
        /*Fund Share Record*/
        ACCL__Fund__share fundshare = new ACCL__Fund__share();
        fundshare.parentid = fundRecord.id;
        fundshare.userorgroupid = u.id;
        fundshare.accesslevel = 'Read';
        insert fundshare;
        
        /*Delete the UserCustomerProduct record*/
        delete lstUsCus;
        test.stoptest();
        
        
    }
    
}