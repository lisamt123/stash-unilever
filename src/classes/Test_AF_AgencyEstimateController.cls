/**
 * Test_AF_AgencyEstimateController: This Test class for AF_AgencyEstimateController apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_AgencyEstimateController
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
   Static testMethod void agencyEstimateController()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testa', Email='standardusera@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Usera', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testusera@test123321.com',AF_Brand__c='Test Brandea',AF_Category__c='Test Beveragesea');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyea';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesea';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandea';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatea';  
     brandEst.AF_Status_Base_Fees__c='Initiate';
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
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     //Insert Agency Estimate
     AF_Agency_Estimate__c agenEst=new AF_Agency_Estimate__c();
     agenEst.AF_Brand_Estimate__c=brandEst.Id;
     agenEst.AF_Agency_Entity__c=entity1.Id;
     agenEst.AF_Unilever_Entity__c=entity2.Id;
     agenEst.AF_Adaptation__c=324;
     agenEst.AF_Adaptation_Local__c=23;
     agenEst.AF_Digital__c=12;
     agenEst.AF_Digital_Local__c=12;
     agenEst.AF_Agency_Exchange_Rate__c=21;
     agenEst.AF_Traditional__c=46;
     agenEst.AF_Traditional_Local__c=23;     
     insert agenEst;
     
     //Insert Entity Exception 
     AF_Entity_Exception__c entiExcep=new AF_Entity_Exception__c();
     entiExcep.AF_Agency_Estimate__c=agenEst.Id;
     entiExcep.AF_Value_Euro__c=122;
     entiExcep.AF_Value__c=10;
     entiExcep.AF_Country__c='Australia';
     insert entiExcep;
            
     //Instantiate AF_AgencyEstimateController Class
     ApexPages.currentPage().getParameters().put('id',agenEst.id);
     ApexPages.currentPage().getParameters().put('aid',entity1.id);
     ApexPages.currentPage().getParameters().put('bid',brandEst.id);
     ApexPages.currentPage().getParameters().put('uid',entity2.id);
     
     AF_AgencyEstimateController agenEstCtrl=new AF_AgencyEstimateController();
     
     agenEstCtrl.ExceptionId=entiExcep.Id;
     agenEstCtrl.getDisplayEntityException();
     agenEstCtrl.clearErrorMsg();
     agenEstCtrl.getupdatedC_breakdown();
     agenEstCtrl.getUnileverEntities();
     agenEstCtrl.UpdatPO();  
     agenEstCtrl.Save();
     agenEstCtrl.JustSave();
     agenEstCtrl.SaveEntityException();
     agenEstCtrl.SaveEntityExceptionRecords();
     agenEstCtrl.Reload();
     
    // agenEstCtrl.DeleteException();
     agenEstCtrl.AddComment();
     agenEstCtrl.AddNewRow();
     agenEstCtrl.UpdateDisplayTotal();
     agenEstCtrl.NowInEditMode();
   //  agenEstCtrl.CalculateCountryValue();
     agenEstCtrl.delCountryId=entiExcep.Id;
     agenEstCtrl.delCounrtyRecord();
     
          
     Test.stopTest();
    }
  }  
  Static testMethod void agencyEstimateController1()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testa1', Email='standardusera1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Usera1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testusera1@test123321.com',AF_Brand__c='Test Brandea1',AF_Category__c='Test Beveragesea1');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyea1';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesea1';
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
     bran.Name='Test Brandea1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatea1';  
     brandEst.AF_Status_Base_Fees__c='Ready for PO';
     brandEst.Brand__c=bran.id;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
   
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entitya1';        
     entity1.AF_Country__c='Australia'; 
     entity1.AF_Agency__c=acc.Id;
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entitya1';   
     entity2.AF_Country__c='Austria';     
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
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
     
     //Insert Agency Estimate
     AF_Agency_Estimate__c agenEst=new AF_Agency_Estimate__c();
     agenEst.AF_Brand_Estimate__c=brandEst.Id;
     agenEst.AF_Agency_Entity__c=entity1.Id;
     agenEst.AF_Unilever_Entity__c=entity2.Id;
     agenEst.AF_Adaptation__c=324;
     agenEst.AF_Adaptation_Local__c=23;
     agenEst.AF_Digital__c=12;
     agenEst.AF_Digital_Local__c=12;
     agenEst.AF_Traditional__c=46;
     agenEst.AF_Traditional_Local__c=23;     
     insert agenEst;
     
     //Insert Entity Exception 
     AF_Entity_Exception__c entiExcep=new AF_Entity_Exception__c();
     entiExcep.AF_Agency_Estimate__c=agenEst.Id;
     entiExcep.AF_Value_Euro__c=122;
     entiExcep.AF_Value__c=10;
     entiExcep.AF_Country__c='Australia';
     insert entiExcep;
            
     //Instantiate AF_AgencyEstimateController Class
     ApexPages.currentPage().getParameters().put('aid',entity1.id);
     ApexPages.currentPage().getParameters().put('bid',brandEst.id);
     ApexPages.currentPage().getParameters().put('uid',entity2.id);
     AF_AgencyEstimateController agenEstCtrl1=new AF_AgencyEstimateController();
     agenEstCtrl1.ExceptionId=entiExcep.Id;
     agenEstCtrl1.DeleteException();
         
     Test.stopTest();
    }
  }  
    Static testMethod void agencyEstimateController2()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testa2', Email='standardusera2@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Usera2', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='CMCO Super User',isActive=true, 
      UserName='testusera2@test123321.com',AF_Brand__c='Test Brandea2',AF_Category__c='Test Beveragesea2');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyea2';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesea2';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandea2';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatea2';  
     brandEst.AF_Status_Base_Fees__c='Ready for PO';
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
     entity1.Name='Test Entitya2';        
     entity1.AF_Country__c='Australia'; 
     entity1.AF_Agency__c=acc.Id;
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entitya2';   
     entity2.AF_Country__c='Austria';     
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     //Insert Agency Estimate
     AF_Agency_Estimate__c agenEst=new AF_Agency_Estimate__c();
     agenEst.AF_Brand_Estimate__c=brandEst.Id;
     agenEst.AF_Agency_Entity__c=entity1.Id;
     agenEst.AF_Unilever_Entity__c=entity2.Id;
     agenEst.AF_Adaptation__c=0;
     agenEst.AF_Adaptation_Local__c=23;
     agenEst.AF_PO_Number__c='343';
     agenEst.AF_Digital__c=0;
     agenEst.AF_Digital_Local__c=12;
     agenEst.AF_Traditional__c=0;
     agenEst.AF_Traditional_Local__c=23;     
     insert agenEst;
     
     //Insert Entity Exception 
     AF_Entity_Exception__c entiExcep=new AF_Entity_Exception__c();
     entiExcep.AF_Agency_Estimate__c=agenEst.Id;
     entiExcep.AF_Value_Euro__c=122;
     entiExcep.AF_Value__c=10;
     entiExcep.AF_Country__c='Australia';
     insert entiExcep;
            
     //Instantiate AF_AgencyEstimateController Class
     ApexPages.currentPage().getParameters().put('id',agenEst.id);
     ApexPages.currentPage().getParameters().put('aid',entity1.id);
     ApexPages.currentPage().getParameters().put('bid',brandEst.id);
     ApexPages.currentPage().getParameters().put('uid',entity2.id);
     
     AF_AgencyEstimateController agenEstCtrl2=new AF_AgencyEstimateController();
     agenEstCtrl2.ExceptionId=entiExcep.Id;
     agenEstCtrl2.DeleteEntityException();   
     
     Test.stopTest();
    }
  } 
}