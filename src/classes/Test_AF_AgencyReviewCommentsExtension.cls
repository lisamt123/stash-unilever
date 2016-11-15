/**
 * Test_AF_AgencyReviewCommentsExtension: This Test class for AF_AgencyReviewCommentsExtension apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_AgencyReviewCommentsExtension
{    
    Static Integer IcurrYear = System.Today().year()-1;
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void agencyReviewCommentsExtension()
    {
      
     Test.startTest();
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testarc', Email='standarduserarc@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userarc', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserarc@test123321.com',AF_Brand__c='Test Brandarc',AF_Category__c='Test Beveragesarc');
     insert u;        
      
     System.runAs(u)
     { 

     //Insert Account
     Account acc1=new Account();
     acc1.Name='Test Agencyarc';
     acc1.published__c=true;
     insert acc1;
     
     System.Assert(acc1.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='TestBeveragesarc';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='TestBrandarc';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc1.Id;               
     brandEst.Name='Test BrandEstimatearc';
     brandEst.Brand__c=bran.id;
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Pilot_Model__c=true;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     AF_Controller_Review__c conRev=new AF_Controller_Review__c();
     conRev.Brand_Estimate__c=brandEst.Id;
     conRev.AF_Comment__c='Test Comment';
     conRev.Controller_Group__c='Europe';
     conRev.Review_Completed__c=true;
     insert conRev;
     
     ApexPages.currentPage().getParameters().put('id',brandEst.Id);   
     
     //Instantiating the class AF_AgencyReviewCommentsExtension 
     ApexPages.StandardController sc = new ApexPages.StandardController(brandEst);
     AF_AgencyReviewCommentsExtension agencRevControl=new AF_AgencyReviewCommentsExtension (sc);
     agencRevControl.saveControllerReview();
     agencRevControl.checkReview=false;
     agencRevControl.saveControllerReview();
     
     Test.stopTest(); 
     }
    }    
  }