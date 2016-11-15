/**
 * Test_AF_UpdateOopsEstimateCatApproverValues : This Test class for AF_UpdateOopsEstimateCatApproverValues apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_UpdOopsEstCatApproverValues  
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year()-1;
    Static string currYear1=string.valueof(IcurrYear1);
    Static testMethod void UpdOopsEstiCatApproverValues ()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testuo', Email='standarduseruo@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo@test123321.com',AF_Brand__c='Test Branduo',AF_Category__c='Test Beveragesuo');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyuo';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Con';
     con.AccountId=acc.Id;
     con.AF_Send_Email_Notification__c = true;
     con.Email='testcon@test123321.com';
     insert Con;
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesuo';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Branduo';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     List<AF_Brand_Estimate__c> brandEstList=new List<AF_Brand_Estimate__c> ();
     
     //Insert Brand Estimate                
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateuo';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q4';
     brandEst.AF_Fiscal_Year__c=currYear1;
     brandEst.AF_Pilot_Model__c=false;
     brandEstList.add(brandEst);
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     //Insert Brand Estimate                
     AF_Brand_Estimate__c brandEst1=new AF_Brand_Estimate__c();
     brandEst1.AF_Agency__c=acc.Id;               
     brandEst1.Name='Test BrandEstimateuo';
     brandEst1.AF_Status_Base_Fees__c='Initiate';  
     brandEst1.Brand__c=bran.id;
     brandEst1.AF_Basefee_Estimate_Initial_Quarter__c='Q4';
     brandEst1.AF_Fiscal_Year__c=currYear;
     brandEst1.AF_Pilot_Model__c=false;
     brandEstList.add(brandEst1);
     insert brandEstList;
     
     System.assertEquals(brandEst1.AF_Agency__c, acc.id);
     
          List<AF_OOPS_Actual__c> oopsActualList=new List<AF_OOPS_Actual__c>();
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     oopsActualList.add(oopsActual);
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual1=new AF_OOPS_Actual__c();
     oopsActual1.AF_Agency_lk__c=acc.Id;     
     oopsActual1.AF_Agency__c=acc.Id;
     oopsActual1.AF_BrandEstimateId__c=brandEst1.id;
     oopsActual1.AF_Brand__c=bran.Id;
     oopsActual1.AF_Fiscal_year__c=currYear1;
     oopsActualList.add(oopsActual1);
     Insert oopsActualList; 
     
     AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(oopsActualList);
     AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagency(oopsActual);
     Test.stopTest();
     }
  }
  Static testMethod void UpdOopsEstiCatApproverValues1 ()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testuo', Email='standarduseruo@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u;     
     
    User u1= new User(Alias = 'testuo1', Email='standarduseruo1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo1@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u1; 

     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyuo1';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Contact
     Contact con=new Contact();
     con.LastName='Test Con1';
     con.AccountId=acc.Id;
     con.AF_Send_Email_Notification__c = true;
     con.Email='testcon1@test123321.com';
     insert Con;
     
     //Insert Contact
     Contact con1=new Contact();
     con1.LastName='Test Con1';
     con1.AccountId=acc.Id;
     con1.AF_Send_Email_Notification__c = true;
     con1.Email='testcon2@test123321.com';
     insert Con1;
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesuo1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Branduo1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     List<AF_Brand_Estimate__c> brandEstList=new List<AF_Brand_Estimate__c> ();
     
     //Insert Brand Estimate                
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateuo1';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q4';
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Pilot_Model__c=false;
     brandEstList.add(brandEst);
     insert brandEstList;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     List<AF_OOPS_Actual__c> oopsActualList=new List<AF_OOPS_Actual__c>();
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     oopsActualList.add(oopsActual);
     Insert oopsActualList;
     
     AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(oopsActualList);
     AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagency(oopsActual);
     Test.stopTest();
     }
     }
     Static testMethod void UpdOopsEstiCatApproverValues2()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testuo', Email='standarduseruo@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u;     
     
    User u1= new User(Alias = 'testuo1', Email='standarduseruo1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo1@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u1; 
     
     User u2= new User(Alias = 'testuo2', Email='standarduseruo2@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo2@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u2;

     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyuo1';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Contact
     Contact con=new Contact();
     con.LastName='Test Con1';
     con.AccountId=acc.Id;
     con.AF_Send_Email_Notification__c = true;
     con.Email='testcon1@test123321.com';
     insert Con;
     
     //Insert Contact
     Contact con1=new Contact();
     con1.LastName='Test Con1';
     con1.AccountId=acc.Id;
     con1.AF_Send_Email_Notification__c = true;
     con1.Email='testcon2@test123321.com';
     insert Con1;
     
     //Insert Contact
     Contact con2=new Contact();
     con2.LastName='Test Con2';
     con2.AccountId=acc.Id;
     con2.AF_Send_Email_Notification__c = true;
     con2.Email='testcon3@test123321.com';
     insert Con2;
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesuo1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Branduo1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     List<AF_Brand_Estimate__c> brandEstList=new List<AF_Brand_Estimate__c> ();
     
     //Insert Brand Estimate                
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateuo1';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q4';
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Pilot_Model__c=false;
     brandEstList.add(brandEst);
     insert brandEstList;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     List<AF_OOPS_Actual__c> oopsActualList=new List<AF_OOPS_Actual__c>();
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     oopsActualList.add(oopsActual);
     Insert oopsActualList; 
     
     AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(oopsActualList);
     AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagency(oopsActual);
     Test.stopTest();
     }
  }
  Static testMethod void UpdOopsEstiCatApproverValues3()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testuo', Email='standarduseruo@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u;     
     
    User u1= new User(Alias = 'testuo1', Email='standarduseruo1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo1@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u1; 
     
     User u2= new User(Alias = 'testuo2', Email='standarduseruo2@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo2@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u2;
     
     User u3= new User(Alias = 'testuo3', Email='standarduseruo3@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo3@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u3;

     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyuo1';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Contact
     Contact con=new Contact();
     con.LastName='Test Con1';
     con.AccountId=acc.Id;
     con.AF_Send_Email_Notification__c = true;
     con.Email='testcon1@test123321.com';
     insert Con;
     
     //Insert Contact
     Contact con1=new Contact();
     con1.LastName='Test Con1';
     con1.AccountId=acc.Id;
     con1.AF_Send_Email_Notification__c = true;
     con1.Email='testcon2@test123321.com';
     insert Con1;
     
     //Insert Contact
     Contact con2=new Contact();
     con2.LastName='Test Con2';
     con2.AccountId=acc.Id;
     con2.AF_Send_Email_Notification__c = true;
     con2.Email='testcon3@test123321.com';
     insert Con2;
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesuo1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Branduo1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     List<AF_Brand_Estimate__c> brandEstList=new List<AF_Brand_Estimate__c> ();
     
     //Insert Brand Estimate                
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateuo1';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q4';
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Pilot_Model__c=false;
     brandEstList.add(brandEst);
     insert brandEstList;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
          List<AF_OOPS_Actual__c> oopsActualList=new List<AF_OOPS_Actual__c>();
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     oopsActualList.add(oopsActual);
     Insert oopsActualList;    
     
     AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(oopsActualList);
     AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagency(oopsActual);
     Test.stopTest();
     }
  }
  Static testMethod void UpdOopsEstiCatApproverValues4 ()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testuo', Email='standarduseruo@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u;     
     
    User u1= new User(Alias = 'testuo1', Email='standarduseruo1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo1@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u1; 
     
     User u2= new User(Alias = 'testuo2', Email='standarduseruo2@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo2@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u2;
     
     User u3= new User(Alias = 'testuo3', Email='standarduseruo3@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo3@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u3;
     
     User u4= new User(Alias = 'testuo4', Email='standarduseruo4@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo4', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo4@test123321.com',AF_Brand__c='Test Branduo1',AF_Category__c='Test Beveragesuo1');
     insert u4;

     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyuo1';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Contact
     Contact con=new Contact();
     con.LastName='Test Con1';
     con.AccountId=acc.Id;
     con.AF_Send_Email_Notification__c = true;
     con.Email='testcon1@test123321.com';
     insert Con;
     
     //Insert Contact
     Contact con1=new Contact();
     con1.LastName='Test Con1';
     con1.AccountId=acc.Id;
     con1.AF_Send_Email_Notification__c = true;
     con1.Email='testcon2@test123321.com';
     insert Con1;
     
     //Insert Contact
     Contact con2=new Contact();
     con2.LastName='Test Con2';
     con2.AccountId=acc.Id;
     con2.AF_Send_Email_Notification__c = true;
     con2.Email='testcon3@test123321.com';
     insert Con2;
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesuo1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Branduo1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     List<AF_Brand_Estimate__c> brandEstList=new List<AF_Brand_Estimate__c> ();
     
     //Insert Brand Estimate                
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateuo1';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q4';
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Pilot_Model__c=false;
     brandEstList.add(brandEst);
     insert brandEstList;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     List<AF_OOPS_Actual__c> oopsActualList=new List<AF_OOPS_Actual__c>();
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     oopsActualList.add(oopsActual);
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual1=new AF_OOPS_Actual__c();
     oopsActual1.AF_Agency_lk__c=acc.Id;     
     oopsActual1.AF_Agency__c=acc.Id;
     oopsActual1.AF_BrandEstimateId__c=brandEst.id;
     oopsActual1.AF_Brand__c=bran.Id;
     oopsActual1.AF_Fiscal_year__c=currYear1;
     oopsActualList.add(oopsActual1);
     Insert oopsActualList; 
     
     AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(oopsActualList);
     AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagency(oopsActual);
     Test.stopTest();
     }
  }
}