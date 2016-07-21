/**
 * Test_AF_BonusThresholdHelper : This Test class for AF_BonusThresholdHelper apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_BonusThresholdHelper 
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year()-1;
    Static string currYear1=string.valueof(IcurrYear1);
    Static testMethod void bonusThresholdHelper ()
    {
     Profile p=[Select Id from Profile where Name='System Administrator'];
     profile p1=[select id from profile where Name='Agency Fee Platform User'];//add

     
     
     //Insert User
     User u= new User(Alias = 'testbth', Email='standarduserbth@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbth', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p1.Id,
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Procurement',isActive=true,AF_UserTypeText__c='Regional Category Finance', 
      UserName='testuserbth@test123321.com',AF_Brand__c='Test Brandbth',AF_Category__c='Test Beveragesbth');
     insert u;  
     
     
     /**
     User__r.IsActive=True and User__r.Profile.Name!='System Administrator' AND User__r.AF_UserTypeText__c!=null AND User__r.AF_UserTypeText__c!='' AND User__r.AF_UserTypeText__c NOT IN ('Agency','CMCO Super User')];
        if(agencyNameList.size()>0){
     **/
     
     User u1= new User(Alias = 'testbth1', Email='standarduserbth1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbth1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p1.Id,
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
     bonThresList.add(bonThres);
     
     AF_Bonus_Threshold__c bonThres1=new AF_Bonus_Threshold__c();
     bonThres1.Agency_Name__c=acc.Id;
     bonThres1.AF_Brand_Estimate__c=brandEst.Id;
     bonThres1.Brand_Name__c=bran.Id;
     bonThres1.AF_Country__c=entity2.id;
     bonThres1.AF_Traditional__c=true;
     bonThres1.AF_Digital__c=true;
     bonThres.Year__c=currYear1;
     bonThres1.AF_Minimum__c=20;
     bonThres1.AF_Stretching__c=25;
     bonThres1.AF_Outstanding__c=30;
     bonThresList.add(bonThres1);
     
     
     Insert bonThresList;
     
      List<AF_Bonus_Threshold__c> a=new List<AF_Bonus_Threshold__c>();
     a.add(bonThres1);
     AF_BonusThresholdHelper.shareRecordToUser(bonThresList);
     
     Test.stopTest();

   }
 }
}