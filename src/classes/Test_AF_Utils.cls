/**
 * Test_AF_Utils: This Test class for AF_Utils Trigger
 * @author 
 *
 */
 
 @isTest(SeeAlldata=false)
public class Test_AF_Utils
{    
    Static testMethod void afutil()
    {
     Test.startTest();
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testuv', Email='standarduseruv@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useruv', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testuseruv@test123321.com',AF_Brand__c='Test Branduv',AF_Category__c='Test Beveragesuv');
     insert u;  
     System.runAs(u)
     {
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyer';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageser';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brander';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateer';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Locked__c=false; 
     brandEst.AF_Pilot_Model__c=true;
     insert brandEst;
     
       //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entityer';        
     entity1.AF_Country__c='Australia'; 
     entity1.AF_Agency__c=acc.Id;
     
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     Id i = AF_Utils.getRecordId('Brand Estimate');
     Id j = AF_Utils.getEntityRecordId('Agency Entity');
     Id k=AF_Utils.getBonusResRecordId('Bonus Annual');
     Boolean agency = AF_Utils.isAgencyUser(u.id);
     String res = AF_Utils.getResourceURL('AF_isComment');
     Boolean b = AF_Utils.isValidID(u.id);
     Map<Id,sObject> maptest = new  Map<Id,sObject>();
      AF_Brand_Estimate__c obj = new AF_Brand_Estimate__c();
     maptest.put(brandEst.id,obj );
     List<AF_Brand_Estimate__c> brand = AF_Utils.ConvertMapValuesToList(maptest);
     String s = AF_Utils.EntityNameValue(entity1.id);
     
    
     }
     Test.stopTest();
     }
     }