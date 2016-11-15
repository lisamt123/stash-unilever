/**
 * Test_AF_updateBonusThreshold : This Test class for AF_updateBonusThreshold trigger class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_updateBonusThreshold 
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year()-1;
    Static string currYear1=string.valueof(IcurrYear1);
    Static testMethod void AF_updateBonusThreshold()
    {
     Profile p=[Select Id from Profile where Name='System Administrator'];
     //profile p1=[select id from profile where Name='Agency Fee Platform User'];//add

     
     
     //Insert User
     User u= new User(Alias = 'testbth', Email='standarduserbth@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbth', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Procurement',isActive=true,AF_UserTypeText__c='Regional Category Finance', 
      UserName='testuserbth@test123321.com',AF_Brand__c='Test Brandbth',AF_Category__c='Test Beveragesbth');
     insert u;  
     
     
     /**
     User__r.IsActive=True and User__r.Profile.Name!='System Administrator' AND User__r.AF_UserTypeText__c!=null AND User__r.AF_UserTypeText__c!='' AND User__r.AF_UserTypeText__c NOT IN ('Agency','CMCO Super User')];
        if(agencyNameList.size()>0){
     **/
     
     User u1= new User(Alias = 'testbth1', Email='standarduserbth1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbth1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true,AF_UserTypeText__c='Regional Category Finance', 
      UserName='testuserbth1@test123321.com',AF_Brand__c='Test Brandbth1',AF_Category__c='Test Beveragesbth1');
     insert u1; 
         
   User t=[Select Id,AF_UserTypeText__c,Email,IsActive from User where Id=:u.Id];
   User t1=[Select Id,AF_UserTypeText__c,Email,IsActive from User where Id=:u1.Id];
   
   System.runAs(t)
     { 
     Test.startTest();
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencybth';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');  
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Conbth';
     con.AccountId=acc.Id;
     insert Con;
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesabth';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandabth';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateabth';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=t.Email;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);  
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entityabth';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Austria';
     entity2.AF_Country__c='Austria';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
             
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
             
     //Insert Bonus Threshold
     List<AF_Bonus_Threshold__c> bonThresList=new List<AF_Bonus_Threshold__c>();
     
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.id;
     bonThres.AF_Traditional__c=true;
     bonThres.AF_Digital__c=true;
     bonThres.Year__c=currYear;
     bonThres.AF_Minimum__c=10;
     bonThres.AF_Stretching__c=15;
     bonThres.AF_Outstanding__c=20;
     insert bonThres;
     bonThresList.add(bonThres);
     
     
     
     //insert subresult
     AF_Sub_Result__c subres=new AF_Sub_Result__c();
     subres.AF_Bonus_Threshold__c=bonThres.id;
     subres.AF_Traditional__c=true;
     subres.AF_Digital__c=true;
     subres.AF_Minimum__c=20;
     subres.AF_Stretching__c=25;
     subres.AF_Outstanding__c=30;
     Insert subres;
     
  
     
     
      List<AF_Sub_Result__c > sub=new List<AF_Sub_Result__c >();
     sub.add(subres);
   
     
     delete sub;
     Test.stopTest();

   }
 }
 Static testMethod void UpdateQuantBonus()
    {
     Profile p=[Select Id from Profile where Name='System Administrator'];
     

     
     
     //Insert User
     User u= new User(Alias = 'testbth', Email='standarduserbth@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbth', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Procurement',isActive=true,AF_UserTypeText__c='Regional Category Finance', 
      UserName='testuserbth@test123321.com',AF_Brand__c='Test Brandbth',AF_Category__c='Test Beveragesbth');
     insert u;  
     
     
     /**
     User__r.IsActive=True and User__r.Profile.Name!='System Administrator' AND User__r.AF_UserTypeText__c!=null AND User__r.AF_UserTypeText__c!='' AND User__r.AF_UserTypeText__c NOT IN ('Agency','CMCO Super User')];
        if(agencyNameList.size()>0){
     **/
         
   User t=[Select Id,AF_UserTypeText__c,Email,IsActive from User where Id=:u.Id];
   
   System.runAs(t)
     { 
     Test.startTest();
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencybth';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');  
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Conbth';
     con.AccountId=acc.Id;
     insert Con;
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesabth';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandabth';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateabth';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=t.Email;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);  
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entityabth';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Austria';
     entity2.AF_Country__c='Austria';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
             
  
             
     //Insert Bonus Threshold
     List<AF_Bonus_Threshold__c> bonThresList=new List<AF_Bonus_Threshold__c>();
     
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.id;
     bonThres.AF_Traditional__c=true;
     bonThres.AF_Digital__c=true;
     bonThres.Year__c=currYear;
     bonThres.AF_Minimum__c=10;
     bonThres.AF_Stretching__c=15;
     bonThres.AF_Outstanding__c=20;
     bonThresList.add(bonThres);
     
     insert bonThresList;
     
     //Insert Bonus Results 
     AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
     bonRes.AF_Bonus_Thresholds__c=bonThres.Id;
     bonRes.AF_Total_Bonus_Value__c=23;
     bonRes.AF_Status__c='Draft';
     bonRes.RecordTypeId = Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Quarterly').getRecordTypeId();
     insert bonRes;
     
     
     
     //insert subresult
     AF_Sub_Result__c subres=new AF_Sub_Result__c();
     subres.AF_Bonus_Threshold__c=bonThres.id;
     subres.AF_Traditional__c=true;
     subres.AF_Digital__c=true;
     subres.AF_Period__c=bonRes.AF_Period__c;
     subres.AF_Bonusable_Fees__c=bonRes.AF_Bonusable_Fees__c;
     subres.AF_Minimum__c=20;
     subres.AF_Stretching__c=25;
     subres.AF_Outstanding__c=30;
     subres.AF_Status__c='Draft';
     Insert subres;

     
      List<AF_Sub_Result__c > sub=new List<AF_Sub_Result__c >();
      sub.add(subres);
     
     
     delete sub;
     Test.stopTest();

   }
 }
  Static testMethod void OOPsBaseFeeMatrix ()
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
     
     //Insert User 
     User u1= new User(Alias = 'testuo1', Email='standarduseruo@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruo', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseruo1@test123321.com',AF_Brand__c='Test Branduo',AF_Category__c='Test Beveragesuo');
     insert u1;
     
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
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entityabth';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Austria';
     entity2.AF_Country__c='Austria';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     AF_Currency__c curr = new AF_Currency__c();
     curr.AF_Country__c = 'Ecuador';
     curr.AF_Currency_Code__c = 'USD';
     curr.Country_Currency__c = 'Eucador-USD';
     curr.AF_Fiscal_Year_new__c = currYear ;
     curr.Currency_Unit__c = 'US $';
     curr.AF_Fiscal_Year__c = system.today();
     curr.AF_Average_Exchange_Rate_To_EUR__c = 1.3253;
     curr.Ready_For_PO_Exchange_Rate_SGD_To_USD__c=1.0000;
     curr.Ready_For_PO_Exchange_Rate_To_EUR__c = 1.6112;
     insert curr;
     
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
     
      List<AF_OOPS_Estimate__c> agencOopsEstList=new List<AF_OOPS_Estimate__c>();
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
    // oopEst.AF_Brand_Estimate__r.AF_Agency__c=oopsActual.AF_BrandEstimateId__c;
     //oopEst.AF_OOPS_Actual__r.Name=oopsActual.name;
    
     
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopEst1=new AF_OOPS_Estimate__c();
     oopEst1.AF_Agency_Entity__c=entity1.Id;
     oopEst1.AF_Brand_Estimate__c=brandEst.id;
     oopEst1.AF_OOPS_Actual__c=oopsActual1.Id;
     oopEst1.AF_Unilever_Entity__c=entity2.Id;
     oopEst1.AF_Estimate__c=55;
     oopEst1.AF_Status__c='Ready for PO';
     oopEst1.AF_Ready_For_PO_Entry_Currency__c = 'USD';
     oopEst1.AF_Ready_For_PO_Exchange_Rate__c = 1.6112;
     //oopEst1.AF_Brand_Estimate__r.AF_Agency__c=oopsActual.AF_BrandEstimateId__c;
     //oopEst1.AF_OOPS_Actual__r.Name=oopsActual.name;
     
     agencOopsEstList.add(oopEst1);       
    insert agencOopsEstList;
     
     delete agencOopsEstList;
     
     Test.stopTest();
     }
  }
   Static testMethod void AFBaseFeeMatrix()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testat', Email='standarduserat@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userat', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testuserat@test123321.com',AF_Brand__c='Test Brandat',AF_Category__c='Test Beveragesat');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyat';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesat';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandat';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateat';  
     brandEst.AF_Status_Base_Fees__c='With Agency';
     brandEst.Brand__c=bran.id;
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
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='UK1';        
     entity1.AF_Country__c='UK1'; 
     entity1.AF_Agency__c=acc.Id;
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='USA2';   
     entity2.AF_Country__c='USA2';     
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
   /*  AF_Currency__c curr=new AF_Currency__c();
     curr.AF_Agency_entity__c=entity1.Id;
     curr.Country_Currency__c='Argentina-ARS';
     curr.Ready_For_PO_Exchange_Rate_To_EUR__c=7.1346;
     insert curr;*/
     
     AF_Matrix_Table__c matTable=new AF_Matrix_Table__c();
     matTable.AF_Agency_Country__c='UK1';
     matTable.AF_Matrix_Country__c='UK';
     matTable.AF_Matrix_country_Currency__c='UK-GBP';
     matTable.AF_Matrix_Currency_Code__c='GBP';
     matTable.Ready_For_PO_Conversion__c='GBP';
     matTable.AF_Ready_For_PO_Country__c='UK';
     matTable.AF_Ready_For_PO_Country_Currency__c='UK-GBP';
     matTable.AF_Ready_For_PO_Currency_Code__c='GBP';
     matTable.AF_Unilver_Country__c='USA2';
     Insert matTable;
     
     //Insert Agency Estimate
     AF_Agency_Estimate__c agenEst=new AF_Agency_Estimate__c();
     agenEst.AF_Brand_Estimate__c=brandEst.Id;
     agenEst.AF_Agency_Entity__c=entity1.Id;
     agenEst.AF_Unilever_Entity__c=entity2.Id;
     agenEst.AF_Adaptation__c=324;
     agenEst.AF_Agency_Spot_Rate__c=1.8492;
     agenEst.AF_Digital__c=12;
     agenEst.AF_Traditional__c=46; 
     agenEst.AF_Agency_Exchange_Rate__c=1.8492;
     agenEst.AF_Status__c='Ready for PO';
     agenEst.AF_Fiscal_Year__c=currYear;   
     insert agenEst;
         
     List<AF_Agency_Estimate__c> agencyEstList=new List<AF_Agency_Estimate__c>();
     agencyEstList.add(agenEst);
     
     delete agencyEstList;
     
     AF_UpdateAgencyEstimatesValues.UpdateExchageRates(agencyEstList);
     
     Test.stopTest();
    }
  }
 
}