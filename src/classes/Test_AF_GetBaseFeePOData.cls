/**
 * Test_AF_GetBaseFeePOData : This Test class for AF_GetBaseFeePOData apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_GetBaseFeePOData 
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void getBaseFeePOData()
    {          
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testgb', Email='standarduserGetBaseFeePOData@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Usergb', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testusergb@test123321.com',AF_Brand__c='Test Brandgb',AF_Category__c='Test Beveragesgb');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencygb';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesgb';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandgb';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimategb';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Fiscal_Year__c=currYear ;
     brandEst.AF_Basefee_Estimate_Initial_Quarter__c ='Q1';
     insert brandEst;
     
     AF_Brand_Estimate__c brandEst1=new AF_Brand_Estimate__c();
     brandEst1.AF_Agency__c=acc.Id;               
     brandEst1.Name='Test BrandEstimategb';
     brandEst1.AF_Status_Base_Fees__c='Initiate';  
     brandEst1.Brand__c=bran.id;
     brandEst1.AF_Fiscal_Year__c=currYear ;
     brandEst.AF_Basefee_Estimate_Initial_Quarter__c ='Q2';
     insert brandEst1;
     
     System.assertEquals(brandEst.Brand__c, bran.id);

     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_Status__c='with agency';
     insert oopsActual;
     
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
     //agenEst.AF_PO_Report_Type__c  = 'Base Fees'; 
     insert agenEst;
     
     AF_Agency_Estimate__c agenEst1=new AF_Agency_Estimate__c();
     agenEst1.AF_Brand_Estimate__c=brandEst1.Id;
     agenEst1.AF_Agency_Entity__c=entity1.Id;
     agenEst1.AF_Unilever_Entity__c=entity2.Id;
     agenEst1.AF_Adaptation__c=324;
     agenEst1.AF_Adaptation_Local__c=23;
     agenEst1.AF_Digital__c=12;
     agenEst1.AF_Digital_Local__c=12;
     agenEst1.AF_Agency_Exchange_Rate__c=21;
     agenEst1.AF_Traditional__c=46;
     agenEst1.AF_Traditional_Local__c=23;
     //agenEst.AF_PO_Report_Type__c  = 'Base Fees'; 
     insert agenEst1;
     
     
     
      
     Set<Id> agencEstId=new Set<Id>();
     agencEstId.add(agenEst.Id);
     
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopsEst=new AF_OOPS_Estimate__c();
     oopsEst.AF_Brand_Estimate__c=brandEst.Id;
     oopsEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopsEst.AF_Estimate__c=75;
     oopsEst.AF_Status__c='Ready for PO';
     oopsEst.AF_Digital__c =0;
     oopsEst.AF_Traditional__c =0;
     oopsEst.AF_Adaptation__c =0;
    // oopsEst.AF_Adaptation_Local__c =0;
    // oopsEst.AF_Traditional_Local__c =0;
    // oopsEst.AF_Digital_Local__c=0;
     insert oopsEst; 
     
     Set<Id> oopEstId=new Set<Id>();
     oopEstId.add(oopsEst.Id);
     
     AF_GetBaseFeePOData.CreatePOReportFromAgencyEstimate(agencEstId,false);
     agenEst1.AF_Adaptation_Local__c=500;
     update agenEst1;
     Set<Id> agencEstId1=new Set<Id>();
     agencEstId1.add(agenEst1.Id);
     
     AF_GetBaseFeePOData.CreatePOReportFromAgencyEstimate(agencEstId1,false);
     AF_GetBaseFeePOData.CreatePOReportFromAgencyEstimate(agencEstId,true);
     AF_GetBaseFeePOData.CreatePOReportFromOopsEstimate(oopEstId,false);
     AF_GetBaseFeePOData.CreatePOReportFromOopsEstimate(oopEstId,true);
     }
     Test.stopTest();
  }
  }