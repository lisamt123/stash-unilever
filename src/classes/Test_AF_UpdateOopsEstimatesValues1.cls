/**
 * Test_AF_UpdateOopsEstimatesValues1: This Test class for AF_UpdateOopsEstimatesValues1 apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_UpdateOopsEstimatesValues1
{    
   Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
   Static testMethod void updateOopsEstimatesValues1()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testuv', Email='standarduseruv@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruv', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Agency',isActive=true, 
      UserName='testuseruv@test123321.com',AF_Brand__c='Test Branduv',AF_Category__c='Test Beveragesuv');
     insert u;        
     
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyuv';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesuv';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Branduv';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateuv';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=u.Email;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
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
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     insert oopsActual;

    
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Algeria';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Algeria';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Indonesia';        
     entity2.AF_Country__c='Indonesia';
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     
         
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopEst=new AF_OOPS_Estimate__c();
     oopEst.AF_Agency_Entity__c=entity1.Id;
     oopEst.AF_Brand_Estimate__c=brandEst.id;
     oopEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopEst.AF_Unilever_Entity__c=entity2.Id;
     oopEst.AF_Estimate__c=55;
     oopEst.AF_Status__c='Ready for PO';
     oopEst.AF_Ready_For_PO_Entry_Currency__c = 'USD';
     oopEst.AF_Ready_For_PO_Exchange_Rate__c = 1.6112;
     //insert oopEst;       
    
     List<AF_OOPS_Estimate__c> agencOopsEstList=new List<AF_OOPS_Estimate__c>();
     agencOopsEstList.add(oopEst);
     
     
    AF_Matrix_Table__c mtable = new AF_Matrix_Table__c();
    mtable.AF_Agency_Country__c = 'Algeria';
     mtable.AF_Unilver_Country__c = 'Indonesia';
     mtable.AF_Matrix_Country__c = 'Ecuador';
     mtable.AF_Matrix_Currency_Code__c = 'USD';
     mtable.AF_Ready_For_PO_Currency_Code__c = 'USD';
     mtable.AF_Ready_For_PO_Country__c ='Algeria';
    mtable.Ready_For_PO_Conversion__c = 'USD';
    insert mtable;   
     
     /*AF_BrandEstimate_TriggerDate__c branEstTriDt=new AF_BrandEstimate_TriggerDate__c();
     branEstTriDt.AF_Currency_Uploaded__c=false;
     branEstTriDt.AF_Trigger_Date__c=date.today();
     insert branEstTriDt;
     
     AF_Currency__c curr=new AF_Currency__c();
     curr.Locked__c=false;
     curr.Country_Currency__c=entity2.Name+'-'+'AUD';
     curr.AF_Fiscal_Year_new__c=currYear;
     curr.AF_Average_Exchange_Rate_To_EUR__c=2.3546;
     insert curr;*/
     
   
     AF_UpdateOopsEstimatesValues5.UpdateExchageRates(agencOopsEstList);
     
     Test.stopTest();
    }
  }
  Static testMethod void updateOopsEstimatesValues2()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testuv', Email='standarduseruv@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruv', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Agency',isActive=true, 
      UserName='testuseruv@test123321.com',AF_Brand__c='Test Branduv',AF_Category__c='Test Beveragesuv');
     insert u;        
     
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyuv';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesuv';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Branduv';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateuv';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=u.Email;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
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
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     insert oopsActual;

    
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Algeria';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Algeria';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Indonesia';        
     entity2.AF_Country__c='Indonesia';
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     
         
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopEst=new AF_OOPS_Estimate__c();
     oopEst.AF_Agency_Entity__c=entity1.Id;
     oopEst.AF_Brand_Estimate__c=brandEst.id;
     oopEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopEst.AF_Unilever_Entity__c=entity2.Id;
     oopEst.AF_Estimate__c=55;
     oopEst.AF_Status__c='With Agency';
     oopEst.AF_Ready_For_PO_Entry_Currency__c = 'USD';
     oopEst.AF_Ready_For_PO_Exchange_Rate__c = 1.6112;
     oopEst.AF_Fiscal_Year__c = currYear;
     //insert oopEst;       
    
     List<AF_OOPS_Estimate__c> agencOopsEstList=new List<AF_OOPS_Estimate__c>();
     agencOopsEstList.add(oopEst);
     
     
    AF_Matrix_Table__c mtable = new AF_Matrix_Table__c();
    mtable.AF_Agency_Country__c = 'Algeria';
     mtable.AF_Unilver_Country__c = 'Indonesia';
     mtable.AF_Matrix_Country__c = 'Ecuador';
     mtable.AF_Matrix_Currency_Code__c = 'USD';
     mtable.AF_Ready_For_PO_Currency_Code__c = 'USD';
     mtable.AF_Ready_For_PO_Country__c ='Algeria';
    mtable.Ready_For_PO_Conversion__c = 'USD';
    insert mtable;   
     
     /*AF_BrandEstimate_TriggerDate__c branEstTriDt=new AF_BrandEstimate_TriggerDate__c();
     branEstTriDt.AF_Currency_Uploaded__c=false;
     branEstTriDt.AF_Trigger_Date__c=date.today();
     insert branEstTriDt;
     
     AF_Currency__c curr=new AF_Currency__c();
     curr.Locked__c=false;
     curr.Country_Currency__c=entity2.Name+'-'+'AUD';
     curr.AF_Fiscal_Year_new__c=currYear;
     curr.AF_Average_Exchange_Rate_To_EUR__c=2.3546;
     insert curr;*/
     
   
     AF_UpdateOopsEstimatesValues5.UpdateExchageRates(agencOopsEstList);
     
     Test.stopTest();
    }
  }
}