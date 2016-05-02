/**
 * Test_AF_BrandEstimateUpdate : This Test class for AF_BrandEstimateUpdate apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_BrandEstimateUpdate
{    
    Static testMethod void SchedulableContext()
    {
    //custom setting
    AF_AgencyDate__c be = new AF_AgencyDate__c();
     be.Agency_Trigger_Date__c = system.today();
     insert be;
     
     //Insert Account
     Account acc1=new Account();
     acc1.Name='Test Agency';
     acc1.published__c=true;
     insert acc1;
     
     System.Assert(acc1.Id != null, 'The account record not inserted');
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='TestBeverages';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='TestBrand';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate    
     //list<AF_Brand_Estimate__c > brand= new list<AF_Brand_Estimate__c>();           
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc1.Id;               
     brandEst.Name='Test BrandEstimate';
     brandEst.Brand__c=bran.id;
     brandEst.AF_Pilot_Model__c=true;
     brandEst.AF_Status_Base_Fees__c='Initiate';
     //brandEst.AF_Active__c=true;
     //brand.add(brandEst);
     insert brandEst;   
    
     Test.StartTest();
     AF_BrandEstimateUpdate_schedule reminder =new AF_BrandEstimateUpdate_schedule();
     String CRON_EXP = '0 0 3 ? * *';
     system.schedule('AF_Bonusquarterly_Reminder-yearly (TEST)', CRON_EXP, reminder );
     
     
     test.stopTest();
  }
}