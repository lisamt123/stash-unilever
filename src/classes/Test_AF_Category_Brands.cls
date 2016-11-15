/**
 * Test_AF_Category_Brands : This Test class for  apex class
 * @author 
 *
 */
 
 @isTest(SeeAlldata=false)
public class Test_AF_Category_Brands
{ 

   /* Static testMethod void categoryBrands()
    {
    Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testcr', Email='standardusercr@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Usercr', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testusercr@test123321.com',AF_Brand__c='Test Brandcb',AF_Category__c='Test Beveragescb');
     insert u;        
     
     System.runAs(u)
     { 
        //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencycb';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragescb';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandcb';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     ApexPages.StandardController sc = new ApexPages.StandardController(bran);
     AF_Category_Brands catBrand=new AF_Category_Brands(sc);
     catBrand.BrandValue='Test Brand';
     catBrand.getRecTypes();
     catBrand.Save_Record();
     AF_Category_Brands catBrand1=new AF_Category_Brands();
     catBrand1.BrandValue='Test Brand1';
     catBrand1.getRecTypes();
     catBrand1.Save_Record();
     
     }
    Test.stopTest();
    }
     Static testMethod void categoryBrands1()
    {
    Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testcr1', Email='standardusercr1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Usercr', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testusercr1@test123321.com',AF_Brand__c='Test Brandcb1',AF_Category__c='Test Beveragescb1');
     insert u;        
     
     System.runAs(u)
     { 
        //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencycb1';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragescb1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     ApexPages.StandardController sc1 = new ApexPages.StandardController(cat);
     AF_Category_Brands catBrand2=new AF_Category_Brands(sc1);
     catBrand2.CategoryValue='Test Category1';
     catBrand2.RecTypeValue='Category';
     catBrand2.getRecTypes();
     catBrand2.Save_Record();
     AF_Category_Brands catBrand3=new AF_Category_Brands();
     catBrand3.CategoryValue='Test Category1';
     catBrand3.getRecTypes();
     catBrand3.Save_Record();
     }
    Test.stopTest();
    }*/

}