/**
 * Test_AF_UpdateAgencyEstimatesValues: This Test class for AF_UpdateAgencyEstimatesValues apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_UpdateAgencyEstimatesValues
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void updateAgencyEstimatesValues()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testat', Email='standarduserat@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userat', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testuserat@test123321.com',AF_Brand__c='Test Brandat',AF_Category__c='Test Beveragesat');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyat';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesat';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandat';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateat';  
     brandEst.AF_Status_Base_Fees__c='With Agency';
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
     entity1.Name='UK1';        
     entity1.AF_Country__c='UK1'; 
     entity1.AF_Agency__c=acc.Id;
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='USA2';   
     entity2.AF_Country__c='USA2';     
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
   /*  AF_Currency__c curr=new AF_Currency__c();
     curr.AF_Agency_entity__c=entity1.Id;
     curr.Country_Currency__c='Argentina-ARS';
     curr.Ready_For_PO_Exchange_Rate_To_EUR__c=7.1346;
     insert curr;*/
     
     AF_Matrix_Table__c matTable=new AF_Matrix_Table__c();
     matTable.AF_Agency_Country__c='UK1';
     matTable.AF_Matrix_Country__c='UK';
     matTable.AF_Matrix_country_Currency__c='UK-GBP';
     matTable.AF_Matrix_Currency_Code__c='GBP';
     matTable.Ready_For_PO_Conversion__c='GBP';
     matTable.AF_Ready_For_PO_Country__c='UK';
     matTable.AF_Ready_For_PO_Country_Currency__c='UK-GBP';
     matTable.AF_Ready_For_PO_Currency_Code__c='GBP';
     matTable.AF_Unilver_Country__c='USA2';
     Insert matTable;
     
     //Insert Agency Estimate
     AF_Agency_Estimate__c agenEst=new AF_Agency_Estimate__c();
     agenEst.AF_Brand_Estimate__c=brandEst.Id;
     agenEst.AF_Agency_Entity__c=entity1.Id;
     agenEst.AF_Unilever_Entity__c=entity2.Id;
     agenEst.AF_Adaptation__c=324;
     agenEst.AF_Agency_Spot_Rate__c=1.8492;
     agenEst.AF_Digital__c=12;
     agenEst.AF_Traditional__c=46; 
     agenEst.AF_Agency_Exchange_Rate__c=1.8492;
     agenEst.AF_Status__c='Ready for PO';
     agenEst.AF_Fiscal_Year__c=currYear;   
     insert agenEst;
         
     List<AF_Agency_Estimate__c> agencyEstList=new List<AF_Agency_Estimate__c>();
     agencyEstList.add(agenEst);
     
     AF_UpdateAgencyEstimatesValues.UpdateExchageRates(agencyEstList);
     
     Test.stopTest();
    }
  }
}