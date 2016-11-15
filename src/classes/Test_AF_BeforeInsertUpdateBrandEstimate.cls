/**
 * Test_AF_BeforeInsertUpdateBrandEstimate: This Test class for AF_BeforeInsertUpdateBrandEstimate apex trigger
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_BeforeInsertUpdateBrandEstimate
{    
    Static Integer IcurrYear = System.Today().year()-1;
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void beforeInsertUpdateBrandEstimate()
    {
     Test.startTest();
     
     //Insert Account
     Account acc1=new Account();
     acc1.Name='Test Agency';
     acc1.published__c=true;
     insert acc1;
     
     System.Assert(acc1.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='TestBeverages';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='TestBrand';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc1.Id;               
     brandEst.Name='Test BrandEstimate';
     brandEst.Brand__c=bran.id;
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Pilot_Model__c=true;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     Test.stopTest(); 
     }
  }