/**
 * Test_AF_BrandEstimate_SelController: This Test class for AF_BrandEstimate_SelController apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_BrandEstimate_SelController
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year()-1;
    Static string currYear1=string.valueof(IcurrYear1);
    Static testMethod void selController()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testb', Email='standarduserb@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userb', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testuserb@test123321.com',AF_Brand__c='Test Brandb',AF_Category__c='Test Beveragesb');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyb';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesb';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandb';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateb';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Fiscal_year__c=currYear1; 
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     /* Adding parameters to page URL */
     //For Brand Id
     ApexPages.currentPage().getParameters().put('bId',bran.id);         
        
     //For Agency Id
     ApexPages.currentPage().getParameters().put('aId',acc.Id);
        
     //For Fiscal year
     ApexPages.currentPage().getParameters().put('fy',currYear1);   
     
     //Instantiate AF_OOPS_SelectionController  Class
     AF_BrandEstimate_SelController selCtrl=new AF_BrandEstimate_SelController();
     
     Test.stopTest();
    }
  }  
}