/**
 * Test_AF_EmailToCatFinance: This Test class for AF_EmailToCatFinance apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_EmailToCatFinance
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void EmailToCat()
    {
    Test.StartTest();
    
    Profile p=[Select Id from Profile where Name='Agency Fee Platform User'];       
     
     //Insert User 
     User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test User123', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuser@test123321.com',AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1');
     insert u; 
    
    PermissionSet ps = [SELECT Id,Name FROM PermissionSet where Name='AF_Category_Finance'];
         
        PermissionSetAssignment pa = new PermissionSetAssignment();
        pa.PermissionSetId = ps.id;
        pa.AssigneeId = u.id;
        insert pa;
      System.runAs(u)
     { 
      //Insert Account
     Account acc1=new Account();
     acc1.Name='Test Agency1';
     acc1.published__c=true;
     insert acc1;
     
     System.Assert(acc1.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     system.debug('catRT...'+catRT);
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverages1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brand1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brand1=new AF_Brand_Estimate__c();
     brand1.AF_Agency__c=acc1.Id;               
     brand1.Name='Test Brand1';
     brand1.AF_Status_Base_Fees__c='Initiate';  
     brand1.AF_Fiscal_Year__c=currYear;
     brand1.AF_Active__c = true;
     brand1.AF_Locked__c  = false;
     brand1.AF_Created_By_Batch__c = true;
     brand1.AF_Notified_To_CatFinance__c  = false;
     brand1.Brand__c=bran.id;
     brand1.AF_Cat_Finance_Approver_1__c=u.Id;    
     insert brand1;
     
     AF_Brand_Estimate__c  b=[select AF_Status_Base_Fees__c from AF_Brand_Estimate__c where id=:brand1.id];
     system.debug('b...'+b);
     ApexPages.currentPage().getParameters().put('Year',currYear);
     AF_EmailToCatFinance obj = new AF_EmailToCatFinance();
     obj.confirm();
     obj.closePopup();
     }
    Test.stopTest();
    }
    
    Static testMethod void EmailToCat1()
    {
    Test.StartTest();
    
    Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test User123', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuser@test123321.com',AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1');
     insert u; 
    
    
      System.runAs(u)
     { 
      //Insert Account
     Account acc1=new Account();
     acc1.Name='Test Agency1';
     acc1.published__c=true;
     insert acc1;
     
     System.Assert(acc1.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     system.debug('catRT...'+catRT);
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverages1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brand1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
    
     ApexPages.currentPage().getParameters().put('Year',currYear);
     AF_EmailToCatFinance obj = new AF_EmailToCatFinance();
     obj.confirm();
     obj.closePopup();
     }
    Test.stopTest();
    }
}