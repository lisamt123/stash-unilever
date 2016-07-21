/**
 * Test_AF_BrandEstimateRemote : This Test class for AF_BrandEstimateRemote  apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_BrandEstimateRemote 
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void brandEstimateRemote ()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testber', Email='standarduserber@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userber', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserber@test123321.com',AF_Brand__c='Test Brandber',AF_Category__c='Test Beveragesber');
     insert u;        
     
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyber';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesber';    
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;   
     bran.Name='Test Brandber';
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
     brandEst.Name='Test BrandEstimateber';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear ;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.AF_Pilot_Model__c=false;
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
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Indonesia';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Indonesia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     List<String> cols=new List<String>();
     cols.add(entity1.Name);
     
     Set<String> agencyNames=new Set<string>();
     agencyNames.add(entity1.Name);
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Algeria';
     entity2.AF_Country__c='Algeria';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     List<String> rows=new List<String>();
     rows.add(entity2.Name);

     
     //Insert Agency Estimate 
     AF_Agency_Estimate__c agency=new AF_Agency_Estimate__c();
     agency.AF_Brand_Estimate__c=brandEst.Id;
     agency.AF_Agency_Entity__c=entity1.id;
     agency.AF_Unilever_Entity__c=entity2.Id;  
     agency.AF_Fiscal_Year__c=currYear ;
     agency.AF_Adaptation__c=22;
     agency.AF_Digital__c=22;
     agency.AF_Traditional__c=22; 
     agency.AF_Status__c='With Agency';
     insert agency;     
     
     /*AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     insert oopsActual;
     
     AF_OOPS_Estimate__c oopsEst=new AF_OOPS_Estimate__c();
     oopsEst.AF_Agency_Entity__c=entity1.Id;
     oopsEst.AF_Brand_Estimate__c=brandEst.Id;
     oopsEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopsEst.AF_Unilever_Entity__c=entity2.Id;
     insert oopsEst;*/
    
     AF_AnnualBonus_Qual__c customRecord = new AF_AnnualBonus_Qual__c();
     customRecord.Name='5';
     customRecord.X5__c = 15;
     insert customRecord;
     
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Fiscal_Year__c=currYear ;
     bonSum.AF_Brand__c=bran.Id;     
     insert bonSum;
             
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.Id;
     bonThres.AF_Traditional__c=true;
     bonThres.AF_Digital__c=true;
     bonThres.Year__c=currYear ;
     bonThres.AF_Minimum__c=10;
     bonThres.AF_Stretching__c=15;
     bonThres.AF_Outstanding__c=20;
     insert bonThres;
          
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
     bonRes.AF_Total_Remuneration__c=8;
     bonRes.AF_Remuneration_Percentage__c=15;
     bonRes.AF_Quant__c=18;
     insert bonRes;

     AF_BrandEstimateRemote.getAgencyEstimateRecords(acc.Id,brandEst.Id);
     
     AF_BrandEstimateRemote.getAgencyEntitiesFromName(agencyNames,acc.id);
     
     AF_BrandEstimateRemote.addAgencyEntityToEstimates(brandEst.Id,'AF_Brand_Estimate__c',rows,acc.Id);
     //AF_BrandEstimateRemote.addAgencyEntityToEstimates(bonSum.Id,'AF_Bonus_Summary__c',rows,acc.Id);
     
     AF_BrandEstimateRemote.addUnileverEntityToEstimates(brandEst.Id,'AF_Brand_Estimate__c',cols,acc.Id);
     AF_BrandEstimateRemote.addUnileverEntityToEstimates(bonSum.Id,'AF_Bonus_Summary__c',cols,acc.Id); 
         
     AF_BrandEstimateRemote.addSingleULAGEntity(brandEst.Id,'AF_Brand_Estimate__c', entity2.Name, entity1.Name, acc.Id);
     
     AF_BrandEstimateRemote.archiveAgencyEntityToEstimates(brandEst.Id,'AF_Brand_Estimate__c',entity2.Name);
     AF_BrandEstimateRemote.archiveUnileverEntityToEstimates(bonSum.Id,'AF_Bonus_Summary__c',entity1.Name,acc.Id);
    
     test.stoptest();

   }
 }
 Static testMethod void brandEstimateRemote1 ()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testber1', Email='standarduserber1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userber1', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuserber1@test123321.com',AF_Brand__c='Test Brandber1',AF_Category__c='Test Beveragesber1');
     insert u;        
     
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyber1';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesber1';    
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;   
     bran.Name='Test Brandber1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateber1';
     brandEst.AF_Status_Base_Fees__c='Ready for PO';  
     brandEst.AF_Fiscal_Year__c=currYear ;
     brandEst.AF_Active__c = true;
     brandEst.AF_Copied__c= false;
     brandEst.AF_Locked__c = false;  
     brandEst.AF_Pilot_Model__c=true;
     brandEst.Brand__c=bran.id;
     brandEst.AF_AgencyUsers1__c=u.Email;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;  
     
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
     entity1.Name='Indonesia';        
     entity1.AF_Agency__c=acc.Id;
     entity1.AF_Country__c='Indonesia';
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     List<String> cols=new List<String>();
     cols.add(entity1.Name);
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Algeria';
     entity2.AF_Country__c='Algeria';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     List<String> rows=new List<String>();
     rows.add(entity2.Name);

     
     //Insert Agency Estimate 
     AF_Agency_Estimate__c agency=new AF_Agency_Estimate__c();
     agency.AF_Brand_Estimate__c=brandEst.Id;
     agency.AF_Agency_Entity__c=entity1.id;
     agency.AF_Unilever_Entity__c=entity2.Id;  
     agency.AF_Fiscal_Year__c=currYear ;
     agency.AF_Adaptation__c=22;
     agency.AF_Digital__c=22;
     agency.AF_Traditional__c=22; 
     agency.AF_Status__c='With Agency';
     insert agency;     
     
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Agency__c=acc.Id;
     oopsActual.AF_BrandEstimateId__c=brandEst.id;
     insert oopsActual;
     
     /*AF_OOPS_Estimate__c oopsEst=new AF_OOPS_Estimate__c();
     oopsEst.AF_Agency_Entity__c=entity1.Id;
     oopsEst.AF_Brand_Estimate__c=brandEst.Id;
     oopsEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopsEst.AF_Unilever_Entity__c=entity2.Id;
     insert oopsEst;*/
     
     AF_AnnualBonus_Qual__c customRecord = new AF_AnnualBonus_Qual__c();
     customRecord.Name='5';
     customRecord.X5__c = 15;
     insert customRecord;
     
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Fiscal_Year__c=currYear ;
     bonSum.AF_Brand__c=bran.Id;     
     insert bonSum;
             
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc.Id;
     bonThres.AF_Brand_Estimate__c=brandEst.Id;
     bonThres.Brand_Name__c=bran.Id;
     bonThres.AF_Country__c=entity2.id;
     bonThres.AF_Traditional__c=true;
     bonThres.AF_Digital__c=true;
     bonThres.Year__c=currYear ;
     bonThres.AF_Minimum__c=10;
     bonThres.AF_Stretching__c=15;
     bonThres.AF_Outstanding__c=20;
     insert bonThres;
          
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
     bonRes.AF_Total_Remuneration__c=8;
     bonRes.AF_Remuneration_Percentage__c=15;
     bonRes.AF_Quant__c=18;
     insert bonRes;
     
     //Insert Bonus Matrix
     AF_Bonus_Matrix__c bonMat=new AF_Bonus_Matrix__c();
     bonMat.AF_Agency_Entity__c=entity1.Id;
     bonMat.AF_Bonus_Results__c=bonRes.Id;
     bonMat.AF_Bonus_Summary__c=bonSum.Id;
     bonMat.AF_Unilever_Entity__c=entity2.Id;
     bonMat.AF_Value__c=decimal.valueOf(5500);
     bonMat.AF_Base_Fee_Country_Total__c =35353;
     bonMat.AF_BonusableFee__c=86588;     
     insert bonMat;
     
     
     
     //AF_BrandEstimateRemote.buildBonusMatrix(entity1.Id,entity2.Id,bonSum.Id,bonRes.Id);  
     //AF_BrandEstimateRemote.buildBonusResult(bonThres.Id);
     AF_BrandEstimateRemote.buildOopsEstimate(entity1.Id,entity2.Id,oopsActual.Id);  
      
     AF_BrandEstimateRemote.getAgencyEstimateRecords(acc.Id,brandEst.Id);
     
     AF_BrandEstimateRemote.addAgencyEntityToEstimates(brandEst.Id,'AF_Brand_Estimate__c',rows,acc.Id);     
     AF_BrandEstimateRemote.addAgencyEntityToEstimates(oopsActual.Id,'AF_OOPS_Actual__c',rows,acc.Id);
     AF_BrandEstimateRemote.addAgencyEntityToEstimates(bonSum.Id,'AF_Bonus_Summary__c',rows,acc.Id);
     
     AF_BrandEstimateRemote.addUnileverEntityToEstimates(brandEst.Id,'AF_Brand_Estimate__c',cols,acc.Id);
     AF_BrandEstimateRemote.addUnileverEntityToEstimates(bonSum.Id,'AF_Bonus_Summary__c',cols,acc.Id);
     AF_BrandEstimateRemote.addUnileverEntityToEstimates(oopsActual.Id,'AF_OOPS_Actual__c',cols,acc.Id);
     
     AF_BrandEstimateRemote.addSingleULAGEntity(brandEst.Id,'AF_Brand_Estimate__c', entity2.Name, entity1.Name, acc.Id);
      
     AF_BrandEstimateRemote.archiveAgencyEntityToEstimates(bonSum.Id,'AF_Bonus_Summary__c',entity2.Name);
     
     Test.stopTest();
     

   }
 }
}