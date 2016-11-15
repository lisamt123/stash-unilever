/**
 * Test_AF_OopsActualHelper : This Test class for AF_OopsActualHelper apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_OopsActualHelper 
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year()-1;
    Static string currYear1=string.valueof(IcurrYear1);
    Static testMethod void oopsActualHelper ()
    {
     Profile p=[Select Id from Profile where Name='Agency Fee Platform User'];

     
     
     //Insert User
     User u= new User(Alias = 'testoo', Email='standarduseroo@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useroo', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Procurement',isActive=true, 
      UserName='testuseroo@test123321.com',AF_Brand__c='Test Brandoo',AF_Category__c='Test Beveragesoo');
     insert u;  
     
     User u1= new User(Alias = 'testoo1', Email='standarduseroo1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useroo1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseroo1@test123321.com',AF_Brand__c='Test Brandoo',AF_Category__c='Test Beveragesoo');
     insert u1;
         
   User t=[Select Id,AF_UserTypeText__c,Email,IsActive from User where Id=:u.Id];
   User t1=[Select Id,AF_UserTypeText__c,Email,IsActive from User where Id=:u1.Id];
   
   System.runAs(t)
     { 
     Test.startTest();
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyoo';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');  
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Cono';
     con.AccountId=acc.Id;
     insert Con;
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesoo';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandoo';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateoo';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear ;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=t.Email;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);  
     
     Users_Category__c userCat=new Users_Category__c();
     userCat.Brand__c=bran.Id;
     userCat.Category__c=cat.Id;
     userCat.User__c=t.Id;
     insert userCat;
     
     Users_Category__c userCat1=new Users_Category__c();
     userCat1.Brand__c=bran.Id;
     userCat1.Category__c=cat.Id;
     userCat1.User__c=t1.Id;
     insert userCat1;
     
     
     List<AF_OOPS_Actual__c> oopsActualList=new List<AF_OOPS_Actual__c>();
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear ;
     
     oopsActualList.add(oopsActual);
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual1=new AF_OOPS_Actual__c();
     oopsActual1.AF_Agency_lk__c=acc.Id;     
     oopsActual1.AF_Agency__c=acc.Id;
     oopsActual1.AF_BrandEstimateId__c=brandEst.id;
     oopsActual1.AF_Brand__c=bran.Id;
     oopsActual1.AF_Fiscal_year__c=currYear1 ;
     
     oopsActualList.add(oopsActual1);
     Insert oopsActualList; 
    }
  }
}