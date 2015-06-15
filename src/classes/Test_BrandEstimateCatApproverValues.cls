/**
 * Test_UpdateBrandEstimateCatApproverValues : This Test class for UpdateBrandEstimateCatApproverValues  apex class
 * @author 
 *
 */
 @isTest(SeeAlldata=false)
public class Test_BrandEstimateCatApproverValues 
{    
public string userid='005c0000001L88A';
//qa '005c0000001L88A';
//pilot '005c0000001MYGb'
    
      Static testMethod void catApprovervalues1()
    {
        Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standarduserbec@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u;
    User u1= new User(Alias = 'testo', Email='standarduserbec1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec1@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u1;
User u2= new User(Alias = 'testo', Email='standarduserbec2@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec2@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u2;
User u3= new User(Alias = 'testo', Email='standarduserbec3@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec3@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u3;
User u4= new User(Alias = 'testo', Email='standarduserbec4@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec4', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec4@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u4;
User u5= new User(Alias = 'testo', Email='standarduserbec5@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec5', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec5@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u5;
User u6= new User(Alias = 'testo', Email='standarduserbec6@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec6', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec6@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u6;
User u7= new User(Alias = 'testo', Email='standarduserbec7@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec7', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec7@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u7;
User u8= new User(Alias = 'testo', Email='standarduserbec8@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec8', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec8@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u8;
User u9= new User(Alias = 'testo', Email='standarduserbec9@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec9', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec9@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u9;
     
    System.runAs(u)
     {
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Cono';
     con.AccountId=acc.Id;
     con.email = 'standarduserbec@unilever.com';
     con.AF_Send_Email_Notification__c = true;
     insert Con;
     
     Contact con1=new Contact();
     con1.LastName='Test Cono';
     con1.AccountId=acc.Id;
     con1.email = 'standarduserbec1@unilever.com';
     con1.AF_Send_Email_Notification__c = true;
     insert Con1;
     
     Contact con2=new Contact();
     con2.LastName='Test Cono';
     con2.AccountId=acc.Id;
     con2.email = 'standarduserbec2@unilever.com';
     con2.AF_Send_Email_Notification__c = true;
     insert Con2;
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     //insert brandEst;
     
     List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
     brandEstimateList.add(brandEst);
     insert brandEstimateList;
     
     AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
     
     string userid='005c0000001MYGb';
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //UpdateBrandEstimateCatApproverValues obj = new UpdateBrandEstimateCatApproverValues();
     //AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
     Test.stopTest();
     
     }
    
   }
   
   Static testMethod void catApprovervalues2()
    {
        Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standarduserbec@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u;
    User u1= new User(Alias = 'testo', Email='standarduserbec1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec1@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u1;
User u2= new User(Alias = 'testo', Email='standarduserbec2@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec2@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u2;
User u3= new User(Alias = 'testo', Email='standarduserbec3@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec3@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u3;
User u4= new User(Alias = 'testo', Email='standarduserbec4@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec4', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec4@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u4;
User u5= new User(Alias = 'testo', Email='standarduserbec5@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec5', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec5@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u5;
User u6= new User(Alias = 'testo', Email='standarduserbec6@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec6', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec6@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u6;
User u7= new User(Alias = 'testo', Email='standarduserbec7@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec7', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec7@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u7;
User u8= new User(Alias = 'testo', Email='standarduserbec8@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec8', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec8@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u8;
  
 
    System.runAs(u)
     {
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Cono';
     con.AccountId=acc.Id;
     con.email = 'standarduserbec@unilever.com';
     con.AF_Send_Email_Notification__c = true;
     insert Con;
     
     Contact con1=new Contact();
     con1.LastName='Test Cono';
     con1.AccountId=acc.Id;
     con1.email = 'standarduserbec1@unilever.com';
     con1.AF_Send_Email_Notification__c = true;
     insert Con1;
     
     
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     //insert brandEst;
     
     List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
     brandEstimateList.add(brandEst);
     insert brandEstimateList;
     
     AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
     
     string userid='005c0000001MYGb';
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //UpdateBrandEstimateCatApproverValues obj = new UpdateBrandEstimateCatApproverValues();
     //AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
     Test.stopTest();
     
     }
    }
    Static testMethod void catApprovervalues3()
    {
        Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standarduserbec@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u;
    User u1= new User(Alias = 'testo', Email='standarduserbec1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec1@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u1;
User u2= new User(Alias = 'testo', Email='standarduserbec2@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec2@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u2;
User u3= new User(Alias = 'testo', Email='standarduserbec3@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec3@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u3;
User u4= new User(Alias = 'testo', Email='standarduserbec4@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec4', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec4@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u4;
User u5= new User(Alias = 'testo', Email='standarduserbec5@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec5', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec5@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u5;
User u6= new User(Alias = 'testo', Email='standarduserbec6@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec6', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec6@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u6;
User u7= new User(Alias = 'testo', Email='standarduserbec7@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec7', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec7@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u7;

  
    System.runAs(u)
     {
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Cono';
     con.AccountId=acc.Id;
     con.email = 'standarduserbec@unilever.com';
     con.AF_Send_Email_Notification__c = true;
     insert Con;
     
     
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     //insert brandEst;
     
     List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
     brandEstimateList.add(brandEst);
     insert brandEstimateList;
     
     AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
     
     string userid='005c0000001MYGb';
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //UpdateBrandEstimateCatApproverValues obj = new UpdateBrandEstimateCatApproverValues();
     //AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
     Test.stopTest();
     
     }
    }
    
    Static testMethod void catApprovervalues4()
    {
        Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standarduserbec@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u;
    User u1= new User(Alias = 'testo', Email='standarduserbec1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec1@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u1;
User u2= new User(Alias = 'testo', Email='standarduserbec2@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec2@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u2;
User u3= new User(Alias = 'testo', Email='standarduserbec3@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec3@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u3;
User u4= new User(Alias = 'testo', Email='standarduserbec4@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec4', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec4@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u4;
User u5= new User(Alias = 'testo', Email='standarduserbec5@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec5', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec5@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u5;
User u6= new User(Alias = 'testo', Email='standarduserbec6@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec6', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec6@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u6;


    System.runAs(u)
     {
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Cono';
     con.AccountId=acc.Id;
     con.email = 'standarduserbec@unilever.com';
     con.AF_Send_Email_Notification__c = true;
     insert Con;
     
     Contact con1=new Contact();
     con1.LastName='Test Cono';
     con1.AccountId=acc.Id;
     con1.email = 'standarduserbec1@unilever.com';
     con1.AF_Send_Email_Notification__c = true;
     insert Con1;
     
     Contact con2=new Contact();
     con2.LastName='Test Cono';
     con2.AccountId=acc.Id;
     con2.email = 'standarduserbec2@unilever.com';
     con2.AF_Send_Email_Notification__c = true;
     insert Con2;
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     //insert brandEst;
     
     List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
     brandEstimateList.add(brandEst);
     insert brandEstimateList;
     
     AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
     
     string userid='005c0000001MYGb';
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //UpdateBrandEstimateCatApproverValues obj = new UpdateBrandEstimateCatApproverValues();
    // AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
     Test.stopTest();
     
     }
    }
    Static testMethod void catApprovervalues5()
    {
        Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standarduserbec@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u;
    User u1= new User(Alias = 'testo', Email='standarduserbec1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec1@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u1;
User u2= new User(Alias = 'testo', Email='standarduserbec2@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec2@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u2;
User u3= new User(Alias = 'testo', Email='standarduserbec3@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec3@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u3;
User u4= new User(Alias = 'testo', Email='standarduserbec4@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec4', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec4@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u4;
User u5= new User(Alias = 'testo', Email='standarduserbec5@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec5', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec5@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u5;


    System.runAs(u)
     {
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Cono';
     con.AccountId=acc.Id;
     con.email = 'standarduserbec@unilever.com';
     con.AF_Send_Email_Notification__c = true;
     insert Con;
     
    
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     //insert brandEst;
     
     List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
     brandEstimateList.add(brandEst);
     insert brandEstimateList;
     
     AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
     
     string userid='005c0000001MYGb';
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //UpdateBrandEstimateCatApproverValues obj = new UpdateBrandEstimateCatApproverValues();
    // AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
     Test.stopTest();
     
     }
    
    
    
    }
    
    Static testMethod void catApprovervalues6()
    {
        Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standarduserbec@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u;
    User u1= new User(Alias = 'testo', Email='standarduserbec1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec1@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u1;
User u2= new User(Alias = 'testo', Email='standarduserbec2@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec2@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u2;
User u3= new User(Alias = 'testo', Email='standarduserbec3@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec3@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u3;
User u4= new User(Alias = 'testo', Email='standarduserbec4@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec4', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec4@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u4;

  
    System.runAs(u)
     {
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Cono';
     con.AccountId=acc.Id;
     con.email = 'standarduserbec@unilever.com';
     con.AF_Send_Email_Notification__c = true;
     insert Con;
     
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     //insert brandEst;
     
     List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
     brandEstimateList.add(brandEst);
     insert brandEstimateList;
     
     AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
     
     string userid='005c0000001MYGb';
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //UpdateBrandEstimateCatApproverValues obj = new UpdateBrandEstimateCatApproverValues();
     UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
     
     Test.stopTest();
     }
    }
    
    Static testMethod void catApprovervalues7()
    {
        Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standarduserbec@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u;
    User u1= new User(Alias = 'testo', Email='standarduserbec1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec1@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u1;
User u2= new User(Alias = 'testo', Email='standarduserbec2@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec2@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u2;
User u3= new User(Alias = 'testo', Email='standarduserbec3@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec3', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec3@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u3;
    
     

  
    System.runAs(u)
     {
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Cono';
     con.AccountId=acc.Id;
     con.email = 'standarduserbec@unilever.com';
     con.AF_Send_Email_Notification__c = true;
     insert Con;
     
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     //insert brandEst;
     
     List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
     brandEstimateList.add(brandEst);
     insert brandEstimateList;
     
     AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
     
     string userid='005c0000001MYGb';
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //UpdateBrandEstimateCatApproverValues obj = new UpdateBrandEstimateCatApproverValues();
     //AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
     Test.stopTest();
     
     }
    
    }
    
    Static testMethod void catApprovervalues8()
    {
        Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standarduserbec@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u;
    User u1= new User(Alias = 'testo', Email='standarduserbec1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec1@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u1;
User u2= new User(Alias = 'testo', Email='standarduserbec2@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec2@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u2;

  
    System.runAs(u)
     {
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Cono';
     con.AccountId=acc.Id;
     con.email = 'standarduserbec@unilever.com';
     con.AF_Send_Email_Notification__c = true;
     insert Con;
     
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     //insert brandEst;
     
     List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
     brandEstimateList.add(brandEst);
     insert brandEstimateList;
     
     AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
     
     string userid='005c0000001MYGb';
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //UpdateBrandEstimateCatApproverValues obj = new UpdateBrandEstimateCatApproverValues();
    // AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
     Test.stopTest();
     
     }
    
    }
    Static testMethod void catApprovervalues9()
    {
        Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standarduserbec@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u;
    User u1= new User(Alias = 'testo', Email='standarduserbec1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec1@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u1;


  
    System.runAs(u)
     {
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Cono';
     con.AccountId=acc.Id;
     con.email = 'standarduserbec@unilever.com';
     con.AF_Send_Email_Notification__c = true;
     insert Con;
     
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     //insert brandEst;
     
     List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
     brandEstimateList.add(brandEst);
     insert brandEstimateList;
     
     AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
     
     string userid='005c0000001MYGb';
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //UpdateBrandEstimateCatApproverValues obj = new UpdateBrandEstimateCatApproverValues();
     //AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
     Test.stopTest();
     
     }
     }
     Static testMethod void catApprovervalues10()
    {
        Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standarduserbec@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbec', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbec@test123321.com',AF_Brand__c='Test Brander',AF_Category__c='Test Beverageser');
     insert u;
   


  
    System.runAs(u)
     {
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Cono';
     con.AccountId=acc.Id;
     con.email = 'standarduserbec@unilever.com';
     con.AF_Send_Email_Notification__c = true;
     insert Con;
     
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     //insert brandEst;
     
     List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
     brandEstimateList.add(brandEst);
     insert brandEstimateList;
     
     AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
     
     string userid='005c0000001MYGb';
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //UpdateBrandEstimateCatApproverValues obj = new UpdateBrandEstimateCatApproverValues();
     //AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
     UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
     Test.stopTest();
     
     }
     }
   
}