/**
 * Test_AFBrandEstimateStCtrlExtSummary: This Test class for AFBrandEstimateStCtrlExtSummary apex class
 * @author 
 *
 */
@isTest(seeAllData=false)
public class Test_AFBrandEstimateStCtrlExtSummary
{    
   Static Integer IcurrYear = System.Today().year();
   Static string currYear=string.valueof(IcurrYear);
    Static testMethod void afBrandEstimateStCtrlExtSummary()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test User123', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuser@test123321.com',AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc1=new Account();
     acc1.Name='Test Agency1';
     acc1.published__c=true;
     insert acc1;
     
     System.Assert(acc1.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     system.debug('catRT...'+catRT);
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverages1';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brand1';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     string userid=u.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brand1=new AF_Brand_Estimate__c();
     brand1.AF_Agency__c=acc1.Id;               
     brand1.Name='Test Brand1';
     brand1.AF_Status_Base_Fees__c='Initiate';  
     brand1.AF_Fiscal_Year__c=currYear;
     brand1.Brand__c=bran.id;
     brand1.AF_Adaptive__c=22;
     brand1.AF_Digital__c=22;
     brand1.AF_Traditional__c=22;    
     brand1.AF_Cat_Finance_Approver_1__c=u.Id;    
     insert brand1;
    
     System.assertEquals(brand1.Brand__c, bran.id);
     
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
     oopsActual.AF_Agency_lk__c=acc1.Id;     
     oopsActual.AF_Agency__c=acc1.Id;
     oopsActual.AF_BrandEstimateId__c=brand1.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     insert oopsActual;
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entity1';        
     entity1.AF_Country__c='Australia'; 
     entity1.AF_Agency__c=acc1.Id;
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entity1';   
     entity2.AF_Country__c='Austria';     
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     //Insert Agency Estimate                
     AF_Agency_Estimate__c agency1=new AF_Agency_Estimate__c();
     agency1.AF_Brand_Estimate__c=brand1.Id;
     agency1.AF_Agency_Entity__c=entity1.id;
     agency1.AF_Unilever_Entity__c=entity2.Id;  
     agency1.AF_Fiscal_Year__c=currYear;
     agency1.AF_Adaptation__c=22;
     agency1.AF_Digital__c=22;
     agency1.AF_Traditional__c=22;  
     insert agency1;
     
     //Insert Agency Estimate 
     AF_Agency_Estimate__c agency2=new AF_Agency_Estimate__c();
     agency2.AF_Brand_Estimate__c=brand1.Id;
     agency2.AF_Agency_Entity__c=entity1.id;
     agency2.AF_Unilever_Entity__c=entity2.Id;  
     agency2.AF_Fiscal_Year__c=currYear;
     agency2.AF_Adaptation__c=22;
     agency2.AF_Digital__c=22;
     agency2.AF_Traditional__c=22; 
     insert agency2;
     
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopEst=new AF_OOPS_Estimate__c();
     oopEst.AF_Agency_Entity__c=entity1.Id;
     oopEst.AF_Brand_Estimate__c=brand1.id;
     oopEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopEst.AF_Unilever_Entity__c=entity2.Id;
     oopEst.AF_Estimate__c=55;
     insert oopEst;
     
     //Insert Bonus Summary
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc1.Id;
     bonSum.AF_Brand__c=bran.Id;
     bonSum.AF_Fiscal_Year__c=currYear;   
     insert bonSum;
     
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc1.Id;
     bonThres.AF_Brand_Estimate__c=brand1.Id;
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
     insert bonMat;
     
     //Insert Comment
     AF_Comments__c comm=new AF_Comments__c();
     comm.AF_Parent_Object_Type__c='AF_Brand_Estimate__c';
     comm.AF_Parent_Record_Id__c=brand1.id;
     comm.AF_Agency_Estimate__c=agency1.Id;
     comm.AF_Bonus__c=bonMat.Id;
     comm.AF_Brand_Estimate__c=brand1.id;
     comm.AF_Comments__c='Comment';
     comm.AF_OOPS_Actual__c=oopsActual.Id;
     comm.AF_OOPS_Estimate__c=oopEst.Id;
     insert comm;
     
     
     
     AF_Controller_Review__c cw = new AF_Controller_Review__c();
     cw.Brand_Estimate__c = brand1.id;
     cw.Controller_Group__c = 'LATAM';
     cw.Review_Completed__c = true;
     insert cw;
     
     ApexPages.StandardController sc = new ApexPages.StandardController(brand1);
     ApexPages.currentPage().getParameters().put('id',brand1.id);      
     
     //Instantiating the Class AFBrandEstimateStCtrlExtSummary    
     AFBrandEstimateStCtrlExtSummary bes=new AFBrandEstimateStCtrlExtSummary(sc);  
     bes.financialYear=currYear;
     bes.getbrandEstimateDetailList();      
     bes.categoryStr='Test Beverages1::'+cat.Id;
     bes.changeCatName();
     
     Test.stopTest(); 
     }
   }
   Static testMethod void afBrandEstimateStCtrlExtSummary1()
    {
     Test.startTest();
     
     Profile p1=[Select Id from Profile where Name='System Administrator'];       
     //Insert User 
     User u1= new User(Alias = 'test1123', Email='standarduser1@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test User1231', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p1.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuser1@test123321.com',AF_Brand__c='Test Brand2',AF_Category__c='Test Beverages2');
     insert u1;        
      
     System.runAs(u1)
     { 
     //Insert Account   
     Account acc1=new Account();
     acc1.Name='Test Agency2';
     acc1.published__c=true;
     insert acc1;
     
     System.Assert(acc1.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverages2';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brand2';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     string userid=u1.id;
     DummyUser__c dummyuser = new DummyUser__c();
     dummyuser.User_id__c = userid;
     insert dummyuser;
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brand1=new AF_Brand_Estimate__c();
     brand1.AF_Agency__c=acc1.Id;               
     brand1.Name='Test Brand2';
     brand1.AF_Status_Base_Fees__c='Initiate';  
     brand1.AF_Fiscal_Year__c=currYear;
     brand1.Brand__c=bran.id;   
     brand1.AF_Cat_Finance_Approver_1__c=u1.Id;    
     insert brand1;
    
     System.assertEquals(brand1.Brand__c, bran.id);
     
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
     oopsActual.AF_Agency_lk__c=acc1.Id;     
     oopsActual.AF_Agency__c=acc1.Id;
     oopsActual.AF_BrandEstimateId__c=brand1.id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Fiscal_year__c=currYear;
     insert oopsActual;
     
     //Insert Agency Entity
     RecordType entiRT1 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Agency Entity' Limit 1];       
     AF_Entity__c entity1=new AF_Entity__c();
     entity1.Name='Test Entity2';        
     entity1.AF_Country__c='Australia';
     entity1.AF_Agency__c=acc1.Id;
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entity2';        
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
                    
     //Insert Agency Estimate                
     AF_Agency_Estimate__c agency1=new AF_Agency_Estimate__c();
     agency1.AF_Brand_Estimate__c=brand1.Id;
     agency1.AF_Agency_Entity__c=entity1.id;
     agency1.AF_Unilever_Entity__c=entity2.Id;  
     agency1.AF_Fiscal_Year__c=currYear; 
     insert agency1;
     
     //Insert Agency Estimate 
     AF_Agency_Estimate__c agency2=new AF_Agency_Estimate__c();
     agency2.AF_Brand_Estimate__c=brand1.Id;
     agency2.AF_Agency_Entity__c=entity1.id;
     agency2.AF_Unilever_Entity__c=entity2.Id;  
     agency2.AF_Fiscal_Year__c=currYear;
     insert agency2;
     
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopEst=new AF_OOPS_Estimate__c();
     oopEst.AF_Agency_Entity__c=entity1.Id;
     oopEst.AF_Brand_Estimate__c=brand1.id;
     oopEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopEst.AF_Unilever_Entity__c=entity2.Id;
     oopEst.AF_Estimate__c=55;
     insert oopEst;
     
     //Insert Bonus Summary
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc1.Id;
     bonSum.AF_Brand__c=bran.Id;
     bonSum.AF_Fiscal_Year__c=currYear;   
     insert bonSum;
     
     //Insert Bonus Threshold
     AF_Bonus_Threshold__c bonThres=new AF_Bonus_Threshold__c();
     bonThres.Agency_Name__c=acc1.Id;
     bonThres.AF_Brand_Estimate__c=brand1.Id;
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
     insert bonMat;
     
     //Insert Comment
     AF_Comments__c comm=new AF_Comments__c();
     comm.AF_Parent_Object_Type__c='AF_Brand_Estimate__c';
     comm.AF_Parent_Record_Id__c=brand1.id;
     comm.AF_Agency_Estimate__c=agency1.Id;
     comm.AF_Bonus__c=bonMat.Id;
     comm.AF_Brand_Estimate__c=brand1.id;
     comm.AF_Comments__c='Comment';
     comm.AF_OOPS_Actual__c=oopsActual.Id;
     comm.AF_OOPS_Estimate__c=oopEst.Id;
     insert comm;
     

     
     AF_Controller_Review__c cw = new AF_Controller_Review__c();
     cw.Brand_Estimate__c = brand1.id;
     cw.Controller_Group__c = 'LATAM';
     cw.Review_Completed__c = true;
     insert cw;
     
     ApexPages.StandardController sc = new ApexPages.StandardController(brand1);
     ApexPages.currentPage().getParameters().put('id',brand1.id);         

     //Instantiating the Class AFBrandEstimateStCtrlExtSummary    
     AFBrandEstimateStCtrlExtSummary bes=new AFBrandEstimateStCtrlExtSummary(sc);  
     bes.financialYear=currYear;
     bes.getbrandEstimateDetailList(); 
     bes.categoryStr='Test Beverages2::'+cat.Id;
     bes.changeCatName();
     
     Test.stopTest(); 
     }
    }         
}