/**
 * Test_AF_BrandEstimate_Statuschange: This Test class for AF_BrandEstimate_Statuschange apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_BrandEstimate_Statuschange
{    
    Static testMethod void statuschange()
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
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brand1=new AF_Brand_Estimate__c();
     brand1.AF_Agency__c=acc1.Id;               
     brand1.Name='Test Brand1';
     brand1.AF_Status_Base_Fees__c='Initiate';  
     brand1.AF_Fiscal_Year__c='2014';
     brand1.Brand__c=bran.id;
     brand1.AF_Adaptive__c=22;
     brand1.AF_Digital__c=22;
     brand1.AF_Traditional__c=22;    
     brand1.AF_Cat_Finance_Approver_1__c=u.Id;    
     insert brand1;
     
     List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
     brandEstimateList = [select AF_Status_Base_Fees__c,Brand__c from AF_Brand_Estimate__c where id=:brand1.id];
     //brandEstimateList.add(brand1);
    AF_BrandEstimate_Statuschange obj = new AF_BrandEstimate_Statuschange('select AF_Status_Base_Fees__c,Brand__c from AF_Brand_Estimate__c where id=:'+brand1.id);
    Database.BatchableContext BC ;
    //obj.start(BC);
    obj.execute(BC,brandEstimateList);
    obj.finish(BC);
    Test.stopTest();
    }
    }
    
}