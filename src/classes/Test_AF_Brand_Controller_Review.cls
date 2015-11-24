/**
 * Test_AF_Brand_Controller_Review  : This Test class for AF_Brand_Controller_Review  apex trigger
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_Brand_Controller_Review  
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void brandControllerReview()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testbcr', Email='standarduserbcr@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbcr', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserbcr@test123321.com',AF_Brand__c='Test Brandbcr',AF_Category__c='Test Beveragesbcr');
     insert u; 
     
            
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencybcr';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesbcr';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandbcr';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatebcr';
     brandEst.AF_Status_Base_Fees__c='With CMCO';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q4';     
     //brandEst.AF_Category_Finance_Approved__c=true;
     brandEst.AF_Pilot_Model__c=false;
     insert brandEst;
     
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
     
     AF_Controller_Review__c conRev1=new AF_Controller_Review__c();
     conRev1.Brand_Estimate__c=brandEst.Id;
     conRev1.Controller_Group__c='test';
     insert conRev1;
     
     AF_Controller_Review__c conRev=new AF_Controller_Review__c();
     conRev.Brand_Estimate__c=brandEst.Id;
     conRev.Controller_Group__c='test2';
     insert conRev;
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Australia';        
     entity1.AF_Country__c='Australia'; 
     entity1.AF_Agency__c=acc.Id;
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
           
     AF_Entity__c entity3=new AF_Entity__c();
     entity3.Name='Brazil';        
     entity3.AF_Country__c='Brazil'; 
     entity3.AF_Agency__c=acc.Id;
     entity3.RecordTypeId=entiRT1.Id;         
     insert entity3;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Austria';   
     entity2.AF_Country__c='Austria';     
     entity2.RecordTypeId=entiRT2.Id; 
     entity2.Controller_Group__c='North Asia;Europe';    
     insert entity2;

     //Insert Unilever Entity
        
     AF_Entity__c entity5=new AF_Entity__c();
     entity5.Name='Argentina';   
     entity5.AF_Country__c='Argentina';     
     entity5.RecordTypeId=entiRT2.Id; 
     entity5.Controller_Group__c='North Asia;Europe';    
     insert entity5; 
     
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
     
     AF_Agency_Estimate__c agenEst1=new AF_Agency_Estimate__c();
     agenEst1.AF_Brand_Estimate__c=brandEst.Id;
     agenEst1.AF_Agency_Entity__c=entity3.Id;
     agenEst1.AF_Unilever_Entity__c=entity5.Id;
     agenEst1.AF_Adaptation__c=324;
     agenEst1.AF_Adaptation_Local__c=23;
     agenEst1.AF_Digital__c=12;
     agenEst1.AF_Digital_Local__c=12;
     agenEst1.AF_Agency_Exchange_Rate__c=21;
     agenEst1.AF_Traditional__c=46;
     agenEst1.AF_Traditional_Local__c=23;     
     insert agenEst1;
     
     //AF_Agency_Estimate__c ae=[select id,AF_Total__c,AF_Brand_Estimate__c,AF_Unilever_Entity__r.Controller_Group__c from AF_Agency_Estimate__c where AF_Total__c > 0 and AF_Brand_Estimate__c=:brandEst.Id];
     //System.debug('---------> Agency Estimate Total'+ae.AF_Total__c);
     
     brandEst.AF_Fiscal_Year__c=currYear ;
     update brandEst;
     
     Set<Id> brandEstIdSet=new Set<Id>();
     brandEstIdSet.add(brandEst.Id);
     
     AF_Brand_Controller_Review brandCtrlRev=new AF_Brand_Controller_Review();
     brandCtrlRev.Create_Review(brandEstIdSet);
          
     Test.stopTest();
     }
   }    
}