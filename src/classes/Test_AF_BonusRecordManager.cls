/**
 * Test_AF_BonusRecordManager : This Test class for AF_BonusRecordManager apex class
 * @author 
 *
 */
@isTest(SeeAlldata=true)
public class Test_AF_BonusRecordManager  
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void bonusRecordManager ()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'test6', Email='standarduser6@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbm', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testuserbm@test123321.com',AF_Brand__c='Test Brandbm',AF_Category__c='Test Beveragesbm');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencybm';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesbm';
     cat.AF_Pilot_Model__c=true;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=true;    
     bran.Name='Test Brandfbm';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatebm';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q4';
     brandEst.AF_Fiscal_Year__c='2013';
     brandEst.AF_Pilot_Model__c=true;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     Set<Id> brandEstSet=new Set<Id>();
     brandEstSet.add(brandEst.Id);

     AF_Brand_Estimate__c brandEst1=new AF_Brand_Estimate__c();
     brandEst1.AF_Agency__c=acc.Id;               
     brandEst1.Name='Test BrandEstimatebm';
     brandEst1.AF_Status_Base_Fees__c='Initiate';  
     brandEst1.AF_Pilot_Model__c=false;

     brandEst1.Brand__c=bran.id;
     brandEst1.AF_Basefee_Estimate_Initial_Quarter__c='Q4';
     insert brandEst1;     
     
     System.assertEquals(brandEst1.Brand__c, bran.id);
     
     brandEstSet.add(brandEst1.Id);
     
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
     entity1.Name='Test Entitybm';        
     entity1.AF_Country__c='Australia'; 
     entity1.AF_Agency__c=acc.Id;
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     System.assertEquals(entity1.AF_Agency__c, acc.id);
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entitybm';   
     entity2.AF_Country__c='Austria';     
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     System.Assert(entity2.Id != null, 'The Unilever Entity record not inserted');
     
     //Insert Agency Estimate
     AF_Agency_Estimate__c agenEst=new AF_Agency_Estimate__c();
     agenEst.AF_Brand_Estimate__c=brandEst.Id;
     agenEst.AF_Agency_Entity__c=entity1.Id;
     agenEst.AF_Unilever_Entity__c=entity2.Id;
     agenEst.AF_Fiscal_Year__c='2013';
     agenEst.AF_Adaptation__c=324;
     agenEst.AF_Adaptation_Local__c=23;
     agenEst.AF_Digital__c=12;
     agenEst.AF_Digital_Local__c=12;
     agenEst.AF_Traditional__c=46;
     agenEst.AF_Traditional_Local__c=23;     
     insert agenEst;
     
     //Insert Bonus Summary
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Brand__c=bran.Id;
     bonSum.AF_Fiscal_Year__c='2013';   
     insert bonSum;
     
     System.assertEquals(bonSum.AF_Agency__c, acc.id);
     
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.id;
     bonThres.Year__c='2013';
     bonThres.AF_Digital__c=true;
     bonThres.AF_Traditional__c=true;
     insert bonThres;
     
     System.assertEquals(bonThres.Brand_Name__c, bran.Id);
     List<AF_Sub_Result__c> subResultList = new  List<AF_Sub_Result__c>();
      AF_Sub_Result__c subResult1 = new AF_Sub_Result__c();
     subResult1.AF_Bonus_Threshold__c = bonThres.Id;
     subResult1.AF_Digital__c = true;
     subResult1.AF_Traditional__c = true;
     subResult1.AF_country__c = entity2.id;
     subResult1.AF_Quant__c = 12;
     subResult1.AF_Minimum__c = 5;
     subResult1.AF_Outstanding__c = 7;
     subResult1.AF_Stretching__c = 6;
     subResult1.Bonus_Measure__c = 'BM1';
     insert subResult1;
     subResultList.add(subResult1);
     
     //Insert Bonus Results
     RecordType bonResRT = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Annual' Limit 1];
     AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
     bonRes.AF_Bonus_Thresholds__c=bonThres.Id;
     bonRes.RecordTypeId=bonResRT.Id;
     bonRes.AF_Total_Remuneration__c=45;
     insert bonRes;
     
     System.assertEquals(bonRes.AF_Bonus_Thresholds__c, bonThres.Id);
     
     
     //Insert Bonus Matrix
     AF_Bonus_Matrix__c bonMat=new AF_Bonus_Matrix__c();
     bonMat.AF_Agency_Entity__c=entity1.Id;
     bonMat.AF_Bonus_Results__c=bonRes.Id;
     bonMat.AF_Bonus_Summary__c=bonSum.Id;
     bonMat.AF_Unilever_Entity__c=entity2.Id;
     bonMat.AF_Fiscal_Year__c=currYear;
     insert bonMat;
     
     System.assertEquals(bonMat.AF_Agency_Entity__c, entity1.Id);      
     
     //Instantiating the class AF_BonusRecordManager 
     AF_BonusRecordManager bonMan=new AF_BonusRecordManager(brandEst);
     bonMan.CreateMultiObjectRecords();
     bonMan.BonusSummarySingleFactory(brandEst);
     bonMan.BonusMatrixSingleFactory(agenEst,bonSum,bonRes,bonThres,subResultList);
     Test.stopTest();
    }
  }  
    Static testMethod void bonusRecordManager1 ()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'test6', Email='standarduser61@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userbm1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testuserbm1@test123321.com',AF_Brand__c='Test Brandbm1',AF_Category__c='Test Beveragesbm1');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencybm1';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesbm1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandfbm1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatebm1';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     brandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q4';
     brandEst.AF_Fiscal_Year__c='2013';
     brandEst.AF_Pilot_Model__c=false;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
     Set<Id> brandEstSet=new Set<Id>();
     brandEstSet.add(brandEst.Id);

     AF_Brand_Estimate__c brandEst1=new AF_Brand_Estimate__c();
     brandEst1.AF_Agency__c=acc.Id;               
     brandEst1.Name='Test BrandEstimatebm1';
     brandEst1.AF_Status_Base_Fees__c='Initiate';  
     brandEst1.Brand__c=bran.id;
     brandEst1.AF_Basefee_Estimate_Initial_Quarter__c='Q4';
     insert brandEst1;     
     
     System.assertEquals(brandEst1.Brand__c, bran.id);
     
     brandEstSet.add(brandEst1.Id);
     
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
     entity1.Name='Test Entitybm1';        
     entity1.AF_Country__c='Australia'; 
     entity1.AF_Agency__c=acc.Id;
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     System.assertEquals(entity1.AF_Agency__c, acc.id);
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entitybm1';   
     entity2.AF_Country__c='Austria';     
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     System.Assert(entity2.Id != null, 'The Unilever Entity record not inserted');
     
     //Insert Agency Estimate
     AF_Agency_Estimate__c agenEst=new AF_Agency_Estimate__c();
     agenEst.AF_Brand_Estimate__c=brandEst.Id;
     agenEst.AF_Agency_Entity__c=entity1.Id;
     agenEst.AF_Unilever_Entity__c=entity2.Id;
     agenEst.AF_Fiscal_Year__c='2013';
     agenEst.AF_Adaptation__c=324;
     agenEst.AF_Adaptation_Local__c=23;
     agenEst.AF_Digital__c=12;
     agenEst.AF_Digital_Local__c=12;
     agenEst.AF_Traditional__c=46;
     agenEst.AF_Traditional_Local__c=23;     
     insert agenEst;
     
     //Insert Bonus Summary
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Brand__c=bran.Id;
     bonSum.AF_Fiscal_Year__c='2013';   
     insert bonSum;
     
     System.assertEquals(bonSum.AF_Agency__c, acc.id);
     
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.id;
     bonThres.Year__c='2013';
     bonThres.AF_Digital__c=true;
     bonThres.AF_Traditional__c=true;
     bonThres.AF_Country__c=entity2.Id;
     insert bonThres;
     
     System.assertEquals(bonThres.Brand_Name__c, bran.Id);
     
     //Insert Bonus Results
     RecordType bonResRT = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Annual' Limit 1];
     AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
     bonRes.AF_Bonus_Thresholds__c=bonThres.Id;
     bonRes.RecordTypeId=bonResRT.Id;
     bonRes.AF_Total_Remuneration__c=45;
     insert bonRes;
     
     System.assertEquals(bonRes.AF_Bonus_Thresholds__c, bonThres.Id);
     
     //Insert Bonus Matrix
     AF_Bonus_Matrix__c bonMat=new AF_Bonus_Matrix__c();
     bonMat.AF_Agency_Entity__c=entity1.Id;
     bonMat.AF_Bonus_Results__c=bonRes.Id;
     bonMat.AF_Bonus_Summary__c=bonSum.Id;
     bonMat.AF_Unilever_Entity__c=entity2.Id;
     bonMat.AF_BonusableFee__c=34;
     bonMat.AF_Fiscal_Year__c=currYear;
     
     insert bonMat;
     
     System.assertEquals(bonMat.AF_Agency_Entity__c, entity1.Id);      
     
     //Instantiating the class AF_BonusRecordManager 
     AF_BonusRecordManager bonMan1=new AF_BonusRecordManager(brandEstSet);
     bonMan1.CreateMultiObjectRecords();
     
     Test.stopTest();
    }
  }
}