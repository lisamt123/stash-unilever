/**
 * Test_AF_MatrixAgencySummary: This Test class for AF_MatrixAgencySummary apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_MatrixAgencySummary
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYearOld = System.Today().year()-1;
    Static string currYearOld=string.valueof(IcurrYearOld);
    Static testMethod void addCommentCompController()
    {
    Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testc', Email='standarduserc@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userc', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='CMCO Super User',isActive=true, 
      UserName='testuserc@test123321.com',AF_Brand__c='Test Brandc',AF_Category__c='Test Beveragesc');
     insert u; 
        System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyc';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesc';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandc';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatec';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYearOld;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=u.Email;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
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
     
      string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear ;
     //oopsActual.AF_OOPS_Estimate__c = 200;
     //oopsActual.Total_Base_Fee__c = 2000;
     oopsActual.Quarter__c = 'Q1;Q2;Q3;Q4';
     oopsActual.AF_Q1__c = 30;
     oopsActual.AF_Q2__c = 40;
     oopsActual.AF_Q3__c = 50;
     oopsActual.AF_Q4__c = 60;
     oopsActual.Overall__c = 4;
     insert oopsActual;   
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entitym';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entitym';        
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
     oopEst.AF_Agency_Entity__c=entity1.Id;
     oopEst.AF_Brand_Estimate__c=brandEst.id;
     oopEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopEst.AF_Unilever_Entity__c=entity2.Id;
     oopEst.AF_Estimate__c=200;
     oopEst.AF_Agreed_Base_Fees__c = 2000;
     oopEst.AF_Fiscal_Year__c = currYear;
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
     insert bonThres;
     
     //Insert Bonus Results 
     AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
     bonRes.AF_Bonus_Thresholds__c=bonThres.Id;
     bonRes.AF_Total_Bonus_Value__c=23;
     insert bonRes;
     
     //Insert Bonus Matrix
     AF_Bonus_Matrix__c bonMat=new AF_Bonus_Matrix__c();
     bonMat.AF_Agency_Entity__c=entity1.Id;
     bonMat.AF_Bonus_Results__c=bonRes.Id;
     bonMat.AF_Bonus_Summary__c=bonSum.Id;
     bonMat.AF_Unilever_Entity__c=entity2.Id;
     bonMat.AF_Value__c=55;
     bonMat.AF_Base_Fee_Country_Total__c =35353;
     bonMat.AF_BonusableFee__c=86588;
     bonMat.AF_Fiscal_Year__c = currYear;   
     insert bonMat;
     
     ApexPages.currentPage().getParameters().put('id',oopsActual.id);
     ApexPages.currentPage().getParameters().put('bId',bran.id);
     ApexPages.currentPage().getParameters().put('aId',acc.id);
     ApexPages.currentPage().getParameters().put('fy',currYear );
     
     ApexPages.StandardController sc2 = new ApexPages.StandardController(oopsActual);
     AF_MatrixAgencySummary obj = new AF_MatrixAgencySummary(sc2);
     obj.backToHomePage();
     obj.backToChatter();
     //obj.save();
     obj.tempOopsRecord.AF_Q1__c = 35;
     obj.tempOopsRecord.AF_Q2__c = 41;
     obj.tempOopsRecord.AF_Q3__c = 51;
     obj.tempOopsRecord.AF_Q4__c = 61;
     obj.q1Flag = true;
     obj.q2Flag = true;
     obj.q3Flag = true;
     obj.q4Flag = true;
     obj.grApprove();
     obj.grReject();
     obj.SubmitOverall();
     Test.stopTest();
     }
    
    }
    Static testMethod void addCommentCompController1()
    {
    Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testc', Email='standarduserc@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userc', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='CMCO Super User',isActive=true, 
      UserName='testuserc@test123321.com',AF_Brand__c='Test Brandc',AF_Category__c='Test Beveragesc');
     insert u; 
        System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyc';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesc';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandc';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimatec';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=u.Email;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     
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
      
      string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;     
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear ;
     //oopsActual.AF_OOPS_Estimate__c = 200;
     //oopsActual.Total_Base_Fee__c = 2000;
     oopsActual.Quarter__c = 'Q1;Q2;Q3;Q4';
     oopsActual.AF_Q1__c = 30;
     oopsActual.AF_Q2__c = 40;
     oopsActual.AF_Q3__c = 50;
     oopsActual.AF_Q4__c = 60;
     oopsActual.Overall__c = 4;
     insert oopsActual;   
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entitym';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Australia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entitym';        
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
     oopEst.AF_Agency_Entity__c=entity1.Id;
     oopEst.AF_Brand_Estimate__c=brandEst.id;
     oopEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopEst.AF_Unilever_Entity__c=entity2.Id;
     oopEst.AF_Estimate__c=200;
     oopEst.AF_Agreed_Base_Fees__c = 2000;
     oopEst.AF_Fiscal_Year__c = currYear;
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
     insert bonThres;
     
     //Insert Bonus Results 
     AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
     bonRes.AF_Bonus_Thresholds__c=bonThres.Id;
     bonRes.AF_Total_Bonus_Value__c=23;
     insert bonRes;
     
     //Insert Bonus Matrix
     AF_Bonus_Matrix__c bonMat=new AF_Bonus_Matrix__c();
     bonMat.AF_Agency_Entity__c=entity1.Id;
     bonMat.AF_Bonus_Results__c=bonRes.Id;
     bonMat.AF_Bonus_Summary__c=bonSum.Id;
     bonMat.AF_Unilever_Entity__c=entity2.Id;
     bonMat.AF_Value__c=55;
     bonMat.AF_Base_Fee_Country_Total__c =35353;
     bonMat.AF_BonusableFee__c=86588; 
    bonMat.AF_Fiscal_Year__c = currYear;     
     insert bonMat;
     
     ApexPages.currentPage().getParameters().put('id',oopsActual.id);
     ApexPages.currentPage().getParameters().put('bId',bran.id);
     ApexPages.currentPage().getParameters().put('aId',acc.id);
     ApexPages.currentPage().getParameters().put('fy',currYear );
     
     ApexPages.StandardController sc2 = new ApexPages.StandardController(oopsActual);
     AF_MatrixAgencySummary obj = new AF_MatrixAgencySummary(sc2);
     //obj.backToHomePage();
     //obj.backToChatter();
     //obj.submit();
     obj.tempOopsRecord.AF_Q1__c = 35;
     obj.tempOopsRecord.AF_Q2__c = 41;
     obj.tempOopsRecord.AF_Q3__c = 51;
     obj.tempOopsRecord.AF_Q4__c = 61;
     
     obj.submit();
     obj.save();
     Test.stopTest();
     }
    
    }
    
}