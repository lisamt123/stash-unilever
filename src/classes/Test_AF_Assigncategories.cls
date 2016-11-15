/**
 * Test_AF_Assigncategories : This Test class for AF_Assigncategories apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_Assigncategories 
{    
   /* Static testMethod void assigncategories()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testac', Email='standarduserac@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userac', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testuserac@test123321.com');
     insert u;       
     
      System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyac';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesac';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandac';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     Lead lea=new Lead();
     lea.user__c=u.Id;
     lea.Category_Brands__c=cat.Id;
     lea.brand__c=bran.Id;
     lea.LastName='Test Lead';
     lea.Company=acc.Id;
     insert lea;
     
     ApexPages.StandardController sc = new ApexPages.StandardController(lea);
     AF_Assigncategories assignCat=new AF_Assigncategories(sc);
     assignCat.update_user();
     
     //Insert Category
     AF_Category_Brand__c cat1=new AF_Category_Brand__c();
     cat1.RecordTypeId=catRT.Id;
     cat1.Name='Test Beveragesac1';
     cat1.AF_Pilot_Model__c=false;     
     cat1.AF_Super_category__c='Drinks';
     insert cat1;
     
     System.Assert(cat1.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     AF_Category_Brand__c bran1=new AF_Category_Brand__c();
     bran1.RecordTypeId=brandRT.Id;
     bran1.AF_Pilot_Model__c=false;    
     bran1.Name='Test Brandac1';
     bran1.AF_Category_Brands__c=cat.Id;
     insert bran1;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     Lead lea1=new Lead();
     lea1.user__c=u.Id;
     lea1.Category_Brands__c=cat1.Id;
     lea1.brand__c=bran1.Id;
     lea1.LastName='Test Lead1';
     lea1.Company=acc.Id;
     insert lea1;
     
     ApexPages.StandardController sc1 = new ApexPages.StandardController(lea1);
     AF_Assigncategories assignCat1=new AF_Assigncategories(sc1);
     
     assignCat1.update_user();
     
     Test.stopTest();
     }
    }
    Static testMethod void assigncategories1()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testac', Email='standarduserac@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userac', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testuserac@test123321.com');
     insert u;       
     
      System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyac';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesac';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandac';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     Lead lea=new Lead();
     lea.user__c=u.Id;
     lea.Category_Brands__c=cat.Id;
     lea.brand__c=bran.Id;
     lea.LastName='Test Lead';
     lea.Company=acc.Id;
     insert lea;
     
     ApexPages.StandardController sc = new ApexPages.StandardController(lea);
     AF_Assigncategories assignCat=new AF_Assigncategories(sc);
     assignCat.update_user();
     
     //Insert Category
     AF_Category_Brand__c cat1=new AF_Category_Brand__c();
     cat1.RecordTypeId=catRT.Id;
     cat1.Name='Test Beveragesac1';
     cat1.AF_Pilot_Model__c=false;     
     cat1.AF_Super_category__c='Drinks';
     insert cat1;
     
     System.Assert(cat1.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     AF_Category_Brand__c bran1=new AF_Category_Brand__c();
     bran1.RecordTypeId=brandRT.Id;
     bran1.AF_Pilot_Model__c=false;    
     bran1.Name='Test Brandac1';
     bran1.AF_Category_Brands__c=cat.Id;
     insert bran1;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     Lead lea1=new Lead();
     lea1.user__c=u.Id;
     lea1.Category_Brands__c=cat1.Id;
     lea1.brand__c=bran1.Id;
     lea1.LastName='Test Lead1';
     lea1.Company=acc.Id;
     insert lea1;
     
    
     ApexPages.StandardController sc2 = new ApexPages.StandardController(lea1);
     AF_Assign_Category_Brand assigncat2 = new AF_Assign_Category_Brand(sc2);
     
     assigncat2.update_user();
        assigncat2.categories_brands();
     Test.stopTest();
     }
    }*/
}