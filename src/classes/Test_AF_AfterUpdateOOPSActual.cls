/**
 * Test_AF_AfterUpdateOOPSActual: This Test class for AF_AfterUpdateOOPSActual apex trigger
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_AfterUpdateOOPSActual
{   
     Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void afterUpdateOOPSActual ()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'test5', Email='standarduser5@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test User123', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuser5@test123321.com',AF_Brand__c='Test Brand5',AF_Category__c='Test Beverages5');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc1=new Account();
     acc1.Name='Test Agency5';
     acc1.published__c=true;
     insert acc1;
     
     System.Assert(acc1.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverages5';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brand5';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc1.Id;               
     brandEst.Name='Test BrandEstimate5';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     Set<Id> branEstIds=new Set<Id>();
     branEstIds.add(brandEst.id);
     
     //Insert Users Category
     Users_Category__c userCat=new Users_Category__c();
     userCat.User__c=u.Id;
     userCat.Brand__c=bran.Id;
     userCat.Category__c=cat.Id;
     Insert userCat;
        
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual1=new AF_OOPS_Actual__c();
     oopsActual1.AF_Agency_lk__c=acc1.Id;     
     oopsActual1.AF_Agency__c=acc1.Id;
     oopsActual1.AF_BrandEstimateId__c=brandEst.id;
     oopsActual1.AF_Brand__c=bran.Id;
     oopsActual1.AF_iS_OOPS_Percentage__c=false;
     oopsActual1.Overall__c = 4;
     insert oopsActual1;
     
     //Update OOPS Actual with Brand Estimate Id
     oopsActual1.Overall__c = 5;
     update oopsActual1; 
     
     Test.stopTest(); 
   }
   
  }
  Static testMethod void afterUpdateOOPSActual1 ()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'test5', Email='standarduser5@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test User123', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuser5@test123321.com',AF_Brand__c='Test Brand5',AF_Category__c='Test Beverages5');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc1=new Account();
     acc1.Name='Test Agency5';
     acc1.published__c=true;
     insert acc1;
     
     System.Assert(acc1.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverages5';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brand5';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc1.Id;               
     brandEst.Name='Test BrandEstimate5';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     Set<Id> branEstIds=new Set<Id>();
     branEstIds.add(brandEst.id);
     
     AF_Currency__c curr = new AF_Currency__c();
     curr.AF_Country__c = 'Ecuador';
     curr.AF_Currency_Code__c = 'USD';
     curr.Country_Currency__c = 'Eucador-USD';
     curr.AF_Fiscal_Year_new__c = currYear;
     curr.Currency_Unit__c = 'US $';
     curr.AF_Fiscal_Year__c = system.today();
     curr.AF_Average_Exchange_Rate_To_EUR__c = 1.3253;
     curr.Ready_For_PO_Exchange_Rate_SGD_To_USD__c=1.0000;
     curr.Ready_For_PO_Exchange_Rate_To_EUR__c = 1.6112;
     insert curr;
     
     //Insert Agency Estimate
     AF_Agency_Estimate__c agEst=new AF_Agency_Estimate__c();
     agEst.AF_Brand_Estimate__c=brandEst.Id;
     insert agEst;
     
     Users_Category__c userCat=new Users_Category__c();
     userCat.User__c=u.Id;
     userCat.Brand__c=bran.Id;
     userCat.Category__c=cat.Id;
     Insert userCat;
     
     
     
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc1.Id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Agency__c=acc1.Id;
     
     insert oopsActual;
     
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopsEst=new AF_OOPS_Estimate__c();
     oopsEst.AF_Brand_Estimate__c=brandEst.Id;
     oopsEst.AF_OOPS_Actual__c=oopsActual.Id;
     insert oopsEst; 
     
     //Update OOPS Actual with Brand Estimate Id
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     update oopsActual;    
     
     //Instantiating AF_OOPSRecordManager Class
     AF_OOPSRecordManager oopsRM=new AF_OOPSRecordManager(brandEst);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst1=new AF_Brand_Estimate__c();
     brandEst1.AF_Agency__c=acc1.Id;               
     brandEst1.Name='Test BrandEstimate6';
     brandEst1.AF_Status_Base_Fees__c='Initiate';  
     brandEst1.Brand__c=bran.id;
     insert brandEst1;     
     branEstIds.add(brandEst1.id);
     
     //Instantiating AF_OOPSRecordManager Class with the Parameter of Brand Estimate Id Set
     //AF_OOPSRecordManager oopsRM1=new AF_OOPSRecordManager(branEstIds);
     //oopsRM1.CreateOOPSEstimateRecordsByCollection();
     //oopsRM1.DeleteOOPSActualRecordsByCollection();
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual1=new AF_OOPS_Actual__c();
     oopsActual1.AF_Agency_lk__c=acc1.Id;     
     oopsActual1.AF_Agency__c=acc1.Id;
     oopsActual1.AF_BrandEstimateId__c=brandEst.id;
     oopsActual1.AF_Brand__c=bran.Id;
     oopsActual1.AF_iS_OOPS_Percentage__c=false;
     oopsActual1.Overall__c = 4;
     insert oopsActual1;
     
     //Update OOPS Actual with Brand Estimate Id
     oopsActual1.Overall__c = 5;
     update oopsActual1; 
     
     Test.stopTest(); 
   }
   
  }
 }