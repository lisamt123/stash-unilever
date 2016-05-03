/**
 * Test_AF_BrandEstimateHelper : This Test class for AF_BrandEstimateHelper apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_BrandEstimateHelper 
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void BrandEstimateHelper ()
   
    
    {
    Test.startTest();

     
     Profile p=[Select Id from Profile where Name='System Administrator'];
     Profile p1=[Select Id from Profile where Name='Agency Fee Platform User'];//add
     
     
     

     
     
     //Insert User
     User u= new User(Alias = 'testbh', Email='standarduserbh@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbh', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p1.Id,//add
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Procurement',isActive=true,AF_UserTypeText__c='Regional Category Finance',
      UserName='testuserbh@test123321.com',AF_Brand__c='Test Brandbh',AF_Category__c='Test Beveragesbh');
     insert u;
    
          
     User u1= new User(Alias = 'testbh1', Email='standarduserbh1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbh1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p1.Id,
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true,AF_UserTypeText__c='Regional Category Finance', 
     UserName='testuserbh1@test123321.com',AF_Brand__c='Test Brandbh',AF_Category__c='Test Beveragesbh');
     insert u1;
         
   User t=[Select Id,AF_UserTypeText__c,Email,IsActive from User where Id=:u.Id];
   User t1=[Select Id,AF_UserTypeText__c,Email,IsActive from User where Id=:u1.Id];
   
   System.runAs(t)
   
     { 
    
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencybh';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Con';
     con.AccountId=acc.Id;
     insert Con;
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesbh';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
      AF_OOPS_Settings__c custRecord = new AF_OOPS_Settings__c();
     custRecord.Overall_Percentage__c = 5;
     insert custRecord;
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandbh';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
    
    //category user
     
     Users_Category__c userCat=new Users_Category__c();
     userCat.Brand__c=bran.Id;
     userCat.Category__c=cat.Id;
     userCat.User__c=t.Id;
    
     insert userCat;
     
     Users_Category__c userCat1=new Users_Category__c();
     userCat1.Brand__c=bran.Id;
     userCat1.Category__c=cat.Id;
     userCat1.User__c=t.Id;
     insert userCat1;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatebh';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.AF_Fiscal_Year__c=currYear ;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=t.Email;
     
     
     insert brandEst;
     System.assertEquals(brandEst.Brand__c, bran.id);
     
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
     
     
          //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entitya';        
     entity1.AF_Country__c='Australia'; 
     entity1.AF_Agency__c=acc.Id;
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
    
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entitya';   
     entity2.AF_Country__c='Austria';
     entity1.AF_Agency__c=acc.Id;     
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     //Insert Agency Estimate
     AF_Agency_Estimate__c agenEst=new AF_Agency_Estimate__c();
     agenEst.AF_Brand_Estimate__c=brandEst.Id;
     agenEst.AF_Agency_Entity__c=entity1.Id;
     agenEst.AF_Unilever_Entity__c=entity2.Id;
     agenEst.AF_Status__c='With Category Finance';
     agenEst.AF_Adaptation__c=324;
     agenEst.AF_Adaptation_Local__c=23;
     agenEst.AF_Digital__c=12;
     agenEst.AF_Digital_Local__c=12;
     agenEst.AF_Agency_Exchange_Rate__c=21;
     agenEst.AF_Traditional__c=46;
     agenEst.AF_Traditional_Local__c=23;     
     insert agenEst;
     
     brandEst.AF_Status_Base_Fees__c='Ready For PO';
     brandEst.AF_Fiscal_Year__c='2013';
     update brandEst;
      
     
     }
     System.runAs(t1)
     
     {
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencybh';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
      
     
     //inser Contact
     Contact con=new Contact();
     con.LastName='Test Con';
     con.AccountId=acc.Id;
     insert Con;
     AF_Category_Brand__c bran1=[Select Id from AF_Category_Brand__c where Name='Test Brandbh'];
     AF_Category_Brand__c cat1=[Select Id from AF_Category_Brand__c where Name='Test Beveragesbh'];
     List<AF_Brand_Estimate__c> brandEstList=new List<AF_Brand_Estimate__c>();
     
      AF_OOPS_Settings__c custRecord = new AF_OOPS_Settings__c();
     custRecord.Overall_Percentage__c = 6;
    // insert custRecord;
     
     Users_Category__c userCat=new Users_Category__c();
     userCat.Brand__c=bran1.Id;
     userCat.Category__c=cat1.Id;
     userCat.User__c=t.Id;
     insert userCat;
     
     
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatebh';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear ;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran1.id;
     brandEst.AF_AgencyUsers1__c=t.Email;
    // insert brandEst;
                 
     brandEstList.add(brandEst);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst1=new AF_Brand_Estimate__c();
     brandEst1.AF_Agency__c=acc.Id;               
     brandEst1.Name='Test BrandEstimatebh1';
     brandEst1.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst1.AF_Fiscal_Year__c=currYear ;
     brandEst1.AF_Active__c = true;
     brandEst1.AF_Copied__c= false;
     brandEst1.AF_Locked__c = false;  
     brandEst1.Brand__c=bran1.id;
     brandEst1.AF_AgencyUsers1__c=t1.Email;
     
     brandEstList.add(brandEst1);
     insert brandEstList;
     
     //AF_BrandEstimateHelper a=new AF_BrandEstimateHelper();
     AF_BrandEstimateHelper.shareRecordToUser(brandEstList);
     Test.stoptest();
       
     }
  }
}