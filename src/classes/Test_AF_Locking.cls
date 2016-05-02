/**
 * Test_AF_Locking: This Test class for AF_Locking Trigger
 * @author 
 *
 */
 
 @isTest(SeeAlldata=false)
public class Test_AF_Locking
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void aflocking()
    {
     Test.startTest();
     Profile p=[Select Id from Profile where Name='Agency Fee Platform User'];       
     
     //Insert User 
     User u= new User(Alias = 'testuv', Email='standarduseruv@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruv', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Agency',isActive=true, 
      UserName='testuseruv@test123321.com',AF_Brand__c='Test Branduv',AF_Category__c='Test Beveragesuv');
     insert u;    

        PermissionSet ps = [SELECT Id,Name FROM PermissionSet where Name='AF_CMCO_Super_User'];
         
        PermissionSetAssignment pa = new PermissionSetAssignment();
        pa.PermissionSetId = ps.id;
        pa.AssigneeId = u.id;
        insert pa;
     
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
     brandEst.AF_Locked__c = true;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=u.Email;
     insert brandEst;
     
     brandEst.AF_Locked__c = true;
     update brandEst;
     Test.stopTest();
     }
     }
     
}