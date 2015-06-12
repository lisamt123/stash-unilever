/**
 * Test_SchedulableToBrandEstimatesBatch: This Test class for SchedulableToBrandEstimatesBatch apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_SchedulableToBrandEstimatesBatch
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year()-1;
    Static string currYear1=string.valueof(IcurrYear1);
    Static testMethod void schedulableToBrandEstimatesBatch()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testst', Email='standarduserst@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userst', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserst@test123321.com',AF_Brand__c='Test Brandst',AF_Category__c='Test Beveragesst');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyst';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesst';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandst';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatest';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Fiscal_year__c=currYear1; 
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     AF_BrandEstimate_TriggerDate__c ABT = new AF_BrandEstimate_TriggerDate__c();
         ABT.AF_Currency_Uploaded__c = false;
         insert ABT;
     
//String jobId = System.schedule('Test_SchedulableToBrandEstimatesBatch', 
  //   new SchedulableToBrandEstimatesBatch());
     
SchedulableToBrandEstimatesBatch stb = new SchedulableToBrandEstimatesBatch();
String sch =  '0 30 11 * * ?';
system.schedule('Test Check', sch, stb);
     //SchedulableToBrandEstimatesBatch stb = new SchedulableToBrandEstimatesBatch();
     //ID batchprocessid =database.executeBatch(stb,1);
 //    SchedulableContext sc;
 //    stb.execute(sc);
     Test.stopTest();
    }
  }
}