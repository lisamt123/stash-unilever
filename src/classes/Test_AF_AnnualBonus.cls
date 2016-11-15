@isTest(SeeAlldata=false)
public class Test_AF_AnnualBonus
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void annualBonus()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testab', Email='standarduserab@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userab', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserab@test123321.com',AF_Brand__c='Test Brandab',AF_Category__c='Test Beveragesab');
     insert u;        
     
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyab';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     system.debug('catRT.Id...'+catRT.Id);
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesab';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandab';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateab';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=u.Email;
     insert brandEst;
     
     
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
      AF_AnnualBonus_Qual__c customRecord = new AF_AnnualBonus_Qual__c();
     customRecord.Name='5';
     customRecord.X5__c = 15;
     insert customRecord;
     
     AF_AnnualBonus_Qual__c customRecord1 = new AF_AnnualBonus_Qual__c();
     customRecord1.Name = 'Qualitative Value';
     customRecord1.X1__c = 0;
     customRecord1.X2__c = 0;
     customRecord1.X3__c = 5;
     customRecord1.X4__c = 10;
     customRecord1.X5__c = 15;
     insert customRecord1;
     
     AF_QuarterlyBonus__c QB = new AF_QuarterlyBonus__c();
     QB.Name = 'Bonus Threshold';
     QB.Minimum__c = 5;
     QB.Outstanding__c = 15;
     QB.Stretching__c = 10;
     insert QB;
     
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
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     insert oopsActual;   
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entityab';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
      AF_Entity__c entity3=new AF_Entity__c();
     entity3.Name='Test Entityab3';        
     entity3.AF_Agency__c=acc.Id;
     entity3.AF_Country__c='Singapore';
     entity3.RecordTypeId=entiRT1.Id;         
     insert entity3;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Austria';
     entity2.AF_Country__c='Austria';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     
      AF_Entity__c entity4=new AF_Entity__c();
     entity4.Name='Test Entityab4';        
     entity4.AF_Agency__c=acc.Id;
     entity4.AF_Country__c='India';
     entity4.RecordTypeId=entiRT2.Id;         
     insert entity4;
     
     //Insert Agency Estimate 
     AF_Agency_Estimate__c agency=new AF_Agency_Estimate__c();
     agency.AF_Brand_Estimate__c=brandEst.Id;
     agency.AF_Agency_Entity__c=entity1.id;
     agency.AF_Unilever_Entity__c=entity2.Id;  
     agency.AF_Fiscal_Year__c=currYear;
     agency.AF_Adaptation__c=22;
     agency.AF_Digital__c=22;
     agency.AF_Traditional__c=22; 
     agency.AF_Status__c='With Agency';
     insert agency;
     
     //Insert Agency Estimate 
     AF_Agency_Estimate__c agency1=new AF_Agency_Estimate__c();
     agency1.AF_Brand_Estimate__c=brandEst.Id;
     agency1.AF_Agency_Entity__c=entity3.id;
     agency1.AF_Unilever_Entity__c=entity2.Id;  
     agency1.AF_Fiscal_Year__c=currYear;
     agency1.AF_Adaptation__c=22;
     agency1.AF_Digital__c=22;
     agency1.AF_Traditional__c=22; 
     agency1.AF_Status__c='With Agency';
     insert agency1;
     
    
         
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopEst=new AF_OOPS_Estimate__c();
     oopEst.AF_Agency_Entity__c=entity1.Id;
     oopEst.AF_Brand_Estimate__c=brandEst.id;
     oopEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopEst.AF_Unilever_Entity__c=entity2.Id;
     oopEst.AF_Estimate__c=55;
     insert oopEst;
     
     //Insert Bonus Summary
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Brand__c=bran.Id;
     bonSum.AF_Fiscal_Year__c=currYear;   
     insert bonSum;
     
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.id;
     bonThres.AF_Traditional__c=true;
     bonThres.AF_Digital__c=true;
     bonThres.Year__c=currYear;
     insert bonThres;
     
     AF_Sub_Result__c subResult = new AF_Sub_Result__c();
     subResult.AF_Bonus_Threshold__c = bonThres.Id;
     //subResult.AF_Period__c = 'Q1';
     subResult.AF_Digital__c = true;
     subResult.AF_Traditional__c = false;
     subResult.AF_country__c = entity2.id;
     subResult.AF_Quant__c = 12;
     subResult.AF_Minimum__c = 1;
     subResult.AF_Outstanding__c = 3;
     subResult.AF_Stretching__c = 2;
     subResult.Bonus_Measure__c = 'BM1';
     insert subResult;
     
     
      AF_Sub_Result__c subResult1 = new AF_Sub_Result__c();
     subResult1.AF_Bonus_Threshold__c = bonThres.Id;
     //subResult.AF_Period__c = 'Q1';
     subResult1.AF_Digital__c = true;
     subResult1.AF_Traditional__c = false;
     subResult1.AF_country__c = entity2.id;
     subResult1.AF_Quant__c = 12;
     subResult1.AF_Minimum__c = 5;
     subResult1.AF_Outstanding__c = 7;
     subResult1.AF_Stretching__c = 6;
     subResult1.Bonus_Measure__c = 'BM1';
     subResult1.AF_Quant_Bonus_Value__c = 156;
     subResult1.AF_Total_Bonus_Value__c = 3800;
     subResult1.AF_Bonusable_Fees__c = 35;
     insert subResult1;
          
     //Insert Bonus Results 
     RecordType bonResRT = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Annual' Limit 1]; 
     AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
     bonRes.AF_Bonus_Thresholds__c=bonThres.Id;
     bonRes.RecordTypeId=bonResRT.Id;
     bonRes.AF_Total_Bonus_Value__c=23;
     bonRes.AF_Qual__c=1;
     bonRes.AF_Status__c='Draft';
     bonRes.AF_Quant_Bonus__c=13;
     bonRes.AF_Quant_Bonus_Value__c=156;
     bonRes.AF_Total_Bonus__c=3800;
     //bonRes.AF_Total_Remuneration__c=8;
     bonRes.AF_Bonusable_Fees__c=35;
     //bonRes.AF_Remuneration_Rating__c =1;
     //bonRes.AF_Remuneration_Percentage__c=15;
     insert bonRes;
     
     ApexPages.currentPage().getParameters().put('Brandid',bran.id);
     ApexPages.currentPage().getParameters().put('Agencyid',acc.id);
     ApexPages.currentPage().getParameters().put('Year',currYear);
     AF_AnnualBonus annulBonus=new AF_AnnualBonus();
     annulBonus.UpdateBonus();
     annulBonus.ConfirmBonus();
     annulBonus.Calculate_Remun();
     annulBonus.Calculate_Remun_Per();
     Test.stopTest();

   }
 }
 
 Static testMethod void annualBonus1()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testab1', Email='standarduserab1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userab1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserab1@test123321.com',AF_Brand__c='Test Brandab1',AF_Category__c='Test Beveragesab1');
     insert u;        
     
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyab1';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesab1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandab1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateab1';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Active__c = true;
     brandEst.AF_Pilot_Model__c=false;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=u.Email;
     insert brandEst;
     
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
      AF_AnnualBonus_Qual__c customRecord = new AF_AnnualBonus_Qual__c();
     customRecord.Name='5';
     customRecord.X5__c = 15;
     insert customRecord;
     
     AF_AnnualBonus_Qual__c customRecord1 = new AF_AnnualBonus_Qual__c();
     customRecord1.Name = 'Qualitative Value';
     customRecord1.X1__c = 0;
     customRecord1.X2__c = 0;
     customRecord1.X3__c = 5;
     customRecord1.X4__c = 10;
     customRecord1.X5__c = 15;
     insert customRecord1;
     
      AF_QuarterlyBonus__c QB = new AF_QuarterlyBonus__c();
     QB.Name = 'Bonus Threshold';
     QB.Minimum__c = 5;
     QB.Outstanding__c = 15;
     QB.Stretching__c = 10;
     insert QB;
     
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
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     insert oopsActual;   
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entityab1';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
      AF_Entity__c entity3=new AF_Entity__c();
     entity3.Name='Test Entityab3';        
     entity3.AF_Agency__c=acc.Id;
     entity3.AF_Country__c='Singapore';
     entity3.RecordTypeId=entiRT1.Id;         
     insert entity3;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Austria';
     entity2.AF_Country__c='Austria';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     //Insert Agency Estimate 
     AF_Agency_Estimate__c agency=new AF_Agency_Estimate__c();
     agency.AF_Brand_Estimate__c=brandEst.Id;
     agency.AF_Agency_Entity__c=entity1.id;
     agency.AF_Unilever_Entity__c=entity2.Id;  
     agency.AF_Fiscal_Year__c=currYear;
     agency.AF_Adaptation__c=22;
     agency.AF_Digital__c=22;
     agency.AF_Traditional__c=22; 
     agency.AF_Status__c='With Agency';
     insert agency;
     
      //Insert Agency Estimate 
     AF_Agency_Estimate__c agency1=new AF_Agency_Estimate__c();
     agency1.AF_Brand_Estimate__c=brandEst.Id;
     agency1.AF_Agency_Entity__c=entity3.id;
     agency1.AF_Unilever_Entity__c=entity2.Id;  
     agency1.AF_Fiscal_Year__c=currYear;
     agency1.AF_Adaptation__c=22;
     agency1.AF_Digital__c=22;
     agency1.AF_Traditional__c=22; 
     agency1.AF_Status__c='With Agency';
     insert agency1;
         
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopEst=new AF_OOPS_Estimate__c();
     oopEst.AF_Agency_Entity__c=entity3.Id;
     oopEst.AF_Brand_Estimate__c=brandEst.id;
     oopEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopEst.AF_Unilever_Entity__c=entity2.Id;
     oopEst.AF_Estimate__c=55;
     insert oopEst;
     
     //Insert Bonus Summary
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Brand__c=bran.Id;
     bonSum.AF_Fiscal_Year__c=currYear;   
     insert bonSum;
     
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.Id; 
     bonThres.AF_Traditional__c=true;
     bonThres.AF_Digital__c=true;
     bonThres.Year__c=currYear;
     insert bonThres;
     
     
     AF_Sub_Result__c subResult = new AF_Sub_Result__c();
     subResult.AF_Bonus_Threshold__c = bonThres.Id;
     //subResult.AF_Period__c = 'Q1';
     subResult.AF_Digital__c = true;
     subResult.AF_Traditional__c = false;
     subResult.AF_country__c = entity2.id;
     subResult.AF_Quant__c = 12;
     subResult.AF_Minimum__c = 1;
     subResult.AF_Outstanding__c = 3;
     subResult.AF_Stretching__c = 2;
     subResult.Bonus_Measure__c = 'BM1';
     insert subResult;
     
     
      AF_Sub_Result__c subResult1 = new AF_Sub_Result__c();
     subResult1.AF_Bonus_Threshold__c = bonThres.Id;
     //subResult.AF_Period__c = 'Q1';
     subResult1.AF_Digital__c = false;
     subResult1.AF_Traditional__c = true;
     subResult1.AF_country__c = entity2.id;
     subResult1.AF_Quant__c = 12;
     subResult1.AF_Minimum__c = 5;
     subResult1.AF_Outstanding__c = 7;
     subResult1.AF_Stretching__c = 6;
     subResult.Bonus_Measure__c = 'BM1';
     insert subResult1;
         
     //Insert Bonus Results 
     RecordType bonResRT = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Annual' Limit 1]; 
     AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
     bonRes.AF_Bonus_Thresholds__c=bonThres.Id;
     bonRes.RecordTypeId=bonResRT.Id;
     bonRes.AF_Total_Bonus_Value__c=23;
     bonRes.AF_Qual__c=1;
     bonRes.AF_Status__c='Draft';
     bonRes.AF_Quant_Bonus__c=13;
     bonRes.AF_Quant_Bonus_Value__c=156;
     bonRes.AF_Total_Bonus__c=3800;
     /*bonRes.AF_Total_Remuneration__c=8;
     bonRes.AF_Remuneration_Percentage__c=15;
     bonRes.AF_Remuneration_Rating__c =3;*/
     insert bonRes;
     
     ApexPages.currentPage().getParameters().put('Brandid',bran.id);
     ApexPages.currentPage().getParameters().put('Agencyid',acc.id);
     ApexPages.currentPage().getParameters().put('Year',currYear);
     AF_AnnualBonus annulBonus1=new AF_AnnualBonus();
     annulBonus1.UpdateBonus();
     //annulBonus1.UpdateBonus2();
     annulBonus1.ConfirmBonus();
     //annulBonus1.ConfirmBonus2();
     //annulBonus1.Calculate_Remun();
     //annulBonus1.Calculate_Remun2();
     //annulBonus1.Calculate_Remun_Per();
     Test.stopTest();
   }
 }
 
 Static testMethod void annualBonus2()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testab1', Email='standarduserab1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userab1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserab1@test123321.com',AF_Brand__c='Test Brandab1',AF_Category__c='Test Beveragesab1');
     insert u;        
     
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyab1';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesab1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandab1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateab1';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Active__c = true;
     brandEst.AF_Pilot_Model__c=true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=u.Email;
     insert brandEst;
     
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
      AF_AnnualBonus_Qual__c customRecord = new AF_AnnualBonus_Qual__c();
     customRecord.Name='5';
     customRecord.X5__c = 15;
     insert customRecord;
     
     AF_AnnualBonus_Qual__c customRecord1 = new AF_AnnualBonus_Qual__c();
     customRecord1.Name = 'Qualitative Value';
     customRecord1.X1__c = 0;
     customRecord1.X2__c = 0;
     customRecord1.X3__c = 5;
     customRecord1.X4__c = 10;
     customRecord1.X5__c = 15;
     insert customRecord1;
     
      AF_QuarterlyBonus__c QB = new AF_QuarterlyBonus__c();
     QB.Name = 'Bonus Threshold';
     QB.Minimum__c = 5;
     QB.Outstanding__c = 15;
     QB.Stretching__c = 10;
     insert QB;
     
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
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     insert oopsActual;   
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entityab1';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
      AF_Entity__c entity3=new AF_Entity__c();
     entity3.Name='Test Entityab3';        
     entity3.AF_Agency__c=acc.Id;
     entity3.AF_Country__c='Singapore';
     entity3.RecordTypeId=entiRT1.Id;         
     insert entity3;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Austria';
     entity2.AF_Country__c='Austria';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     //Insert Agency Estimate 
     AF_Agency_Estimate__c agency=new AF_Agency_Estimate__c();
     agency.AF_Brand_Estimate__c=brandEst.Id;
     agency.AF_Agency_Entity__c=entity1.id;
     agency.AF_Unilever_Entity__c=entity2.Id;  
     agency.AF_Fiscal_Year__c=currYear;
     agency.AF_Adaptation__c=22;
     agency.AF_Digital__c=22;
     agency.AF_Traditional__c=22; 
     agency.AF_Status__c='With Agency';
     insert agency;
         
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopEst=new AF_OOPS_Estimate__c();
     oopEst.AF_Agency_Entity__c=entity3.Id;
     oopEst.AF_Brand_Estimate__c=brandEst.id;
     oopEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopEst.AF_Unilever_Entity__c=entity2.Id;
     oopEst.AF_Estimate__c=55;
     insert oopEst;
     
     //Insert Bonus Summary
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Brand__c=bran.Id;
     bonSum.AF_Fiscal_Year__c=currYear;   
     insert bonSum;
     
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     //bonThres.AF_Country__c=entity2.Id; 
     bonThres.AF_Traditional__c=true;
     bonThres.AF_Digital__c=true;
     bonThres.Year__c=currYear;
     insert bonThres;
     
     
     
     
     
     
         
     //Insert Bonus Results 
     RecordType bonResRT = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Annual' Limit 1]; 
     AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
     bonRes.AF_Bonus_Thresholds__c=bonThres.Id;
     bonRes.RecordTypeId=bonResRT.Id;
     bonRes.AF_Total_Bonus_Value__c=23;
     /*bonRes.AF_Qual__c=1;
     bonRes.AF_Status__c='Draft';
     bonRes.AF_Quant_Bonus__c=13;
     bonRes.AF_Quant_Bonus_Value__c=156;
     bonRes.AF_Total_Bonus__c=3800;*/
     bonRes.AF_Bonusable_Fees__c=35;
     bonRes.AF_Total_Remuneration__c=8;
     bonRes.AF_Remuneration_Percentage__c=15;
     bonRes.AF_Remuneration_Rating__c =3;
     insert bonRes;
     
     ApexPages.currentPage().getParameters().put('Brandid',bran.id);
     ApexPages.currentPage().getParameters().put('Agencyid',acc.id);
     ApexPages.currentPage().getParameters().put('Year',currYear);
     AF_AnnualBonus annulBonus1=new AF_AnnualBonus();
     //annulBonus1.UpdateBonus();
     annulBonus1.UpdateBonus2();
     //annulBonus1.ConfirmBonus();
     annulBonus1.ConfirmBonus2();
     annulBonus1.Calculate_Remun();
     annulBonus1.Calculate_Remun2();
     annulBonus1.Calculate_Remun_Per();
     Test.stopTest();
   }
 }
 
 Static testMethod void annualBonus3()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testab', Email='standarduserab@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userab', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserab@test123321.com',AF_Brand__c='Test Brandab',AF_Category__c='Test Beveragesab');
     insert u;        
     
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyab';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     system.debug('catRT.Id...'+catRT.Id);
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesab';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandab';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateab';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=u.Email;
     insert brandEst;
     
     
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
      AF_AnnualBonus_Qual__c customRecord = new AF_AnnualBonus_Qual__c();
     customRecord.Name='5';
     customRecord.X5__c = 15;
     insert customRecord;
     
     AF_AnnualBonus_Qual__c customRecord1 = new AF_AnnualBonus_Qual__c();
     customRecord1.Name = 'Qualitative Value';
     customRecord1.X1__c = 0;
     customRecord1.X2__c = 0;
     customRecord1.X3__c = 5;
     customRecord1.X4__c = 10;
     customRecord1.X5__c = 15;
     insert customRecord1;
     
     AF_QuarterlyBonus__c QB = new AF_QuarterlyBonus__c();
     QB.Name = 'Bonus Threshold';
     QB.Minimum__c = 5;
     QB.Outstanding__c = 15;
     QB.Stretching__c = 10;
     insert QB;
     
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
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     insert oopsActual;   
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entityab';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
      AF_Entity__c entity3=new AF_Entity__c();
     entity3.Name='Test Entityab3';        
     entity3.AF_Agency__c=acc.Id;
     entity3.AF_Country__c='Singapore';
     entity3.RecordTypeId=entiRT1.Id;         
     insert entity3;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Austria';
     entity2.AF_Country__c='Austria';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     
      AF_Entity__c entity4=new AF_Entity__c();
     entity4.Name='Test Entityab4';        
     entity4.AF_Agency__c=acc.Id;
     entity4.AF_Country__c='India';
     entity4.RecordTypeId=entiRT2.Id;         
     insert entity4;
     
     //Insert Agency Estimate 
     AF_Agency_Estimate__c agency=new AF_Agency_Estimate__c();
     agency.AF_Brand_Estimate__c=brandEst.Id;
     agency.AF_Agency_Entity__c=entity1.id;
     agency.AF_Unilever_Entity__c=entity2.Id;  
     agency.AF_Fiscal_Year__c=currYear;
     agency.AF_Adaptation__c=22;
     agency.AF_Digital__c=22;
     agency.AF_Traditional__c=22; 
     agency.AF_Status__c='With Agency';
     insert agency;
     
     
     
     //Insert Agency Estimate 
     AF_Agency_Estimate__c agency2=new AF_Agency_Estimate__c();
     agency2.AF_Brand_Estimate__c=brandEst.Id;
     agency2.AF_Agency_Entity__c=entity3.id;
     agency2.AF_Unilever_Entity__c=entity4.Id;
     //agency2.AF_Agency_Entity__c = acc.Id;
     agency2.AF_Fiscal_Year__c=currYear;
     agency2.AF_Adaptation__c=22;
     agency2.AF_Digital__c=22;
     agency2.AF_Traditional__c=22; 
     agency2.AF_Status__c='With Agency';
     insert agency2;
         
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopEst=new AF_OOPS_Estimate__c();
     oopEst.AF_Agency_Entity__c=entity1.Id;
     oopEst.AF_Brand_Estimate__c=brandEst.id;
     oopEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopEst.AF_Unilever_Entity__c=entity2.Id;
     oopEst.AF_Estimate__c=55;
     insert oopEst;
     
     //Insert Bonus Summary
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Brand__c=bran.Id;
     bonSum.AF_Fiscal_Year__c=currYear;   
     insert bonSum;
     
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.id;
     bonThres.AF_Traditional__c=true;
     bonThres.AF_Digital__c=true;
     bonThres.Year__c=currYear;
     insert bonThres;
     
     AF_Sub_Result__c subResult = new AF_Sub_Result__c();
     subResult.AF_Bonus_Threshold__c = bonThres.Id;
     //subResult.AF_Period__c = 'Q1';
     subResult.AF_Digital__c = true;
     subResult.AF_Traditional__c = false;
     subResult.AF_country__c = entity2.id;
     subResult.AF_Quant__c = 12;
     subResult.AF_Minimum__c = 1;
     subResult.AF_Outstanding__c = 3;
     subResult.AF_Stretching__c = 2;
     subResult.Bonus_Measure__c = 'BM1';
     insert subResult;
     
     
      AF_Sub_Result__c subResult1 = new AF_Sub_Result__c();
     subResult1.AF_Bonus_Threshold__c = bonThres.Id;
     //subResult.AF_Period__c = 'Q1';
     subResult1.AF_Digital__c = true;
     subResult1.AF_Traditional__c = false;
     subResult1.AF_country__c = entity2.id;
     subResult1.AF_Quant__c = 12;
     subResult1.AF_Minimum__c = 5;
     subResult1.AF_Outstanding__c = 7;
     subResult1.AF_Stretching__c = 6;
     subResult.Bonus_Measure__c = 'BM1';
     subResult.AF_Quant_Bonus_Value__c = 156;
     subResult.AF_Total_Bonus_Value__c = 3800;
     subResult.AF_Bonusable_Fees__c = 35;
     insert subResult1;
          
     //Insert Bonus Results 
     RecordType bonResRT = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Annual' Limit 1]; 
     AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
     bonRes.AF_Bonus_Thresholds__c=bonThres.Id;
     bonRes.RecordTypeId=bonResRT.Id;
     bonRes.AF_Total_Bonus_Value__c=23;
     bonRes.AF_Qual__c=1;
     bonRes.AF_Status__c='Draft';
     bonRes.AF_Quant_Bonus__c=13;
     bonRes.AF_Quant_Bonus_Value__c=156;
     bonRes.AF_Total_Bonus__c=3800;
     //bonRes.AF_Total_Remuneration__c=8;
     bonRes.AF_Bonusable_Fees__c=35;
     //bonRes.AF_Remuneration_Rating__c =1;
     //bonRes.AF_Remuneration_Percentage__c=15;
     insert bonRes;
     
     ApexPages.currentPage().getParameters().put('Brandid',bran.id);
     ApexPages.currentPage().getParameters().put('Agencyid',acc.id);
     ApexPages.currentPage().getParameters().put('Year',currYear);
     AF_AnnualBonus annulBonus=new AF_AnnualBonus();
     annulBonus.UpdateBonus();
     annulBonus.ConfirmBonus();
     //annulBonus.Calculate_Remun();
     //annulBonus.Calculate_Remun_Per();
     Test.stopTest();

   }
 }
 }