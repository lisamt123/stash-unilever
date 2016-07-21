/**
 * Test_AF_BonusSummaryRemote  : This Test class for AF_BonusSummaryRemote  apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_BonusSummaryRemote  
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void bonusSummaryRemote()
    {
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testr', Email='standarduserr@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Userr', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testuserr@test123321.com',AF_Brand__c='Test Brandr',AF_Category__c='Test Beveragesr');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyr';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesr';
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
     bran.Name='Test Brandr';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimater';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
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
     entity1.Name='Test Entityr';        
     entity1.AF_Country__c='Australia'; 
     entity1.AF_Agency__c=acc.Id;
     entity1.RecordTypeId=entiRT1.Id;         
     insert entity1;
    
     System.assertEquals(entity1.AF_Agency__c, acc.id);
     
     //Insert Unilever Entity
     RecordType entiRT2 = [select id,Name from RecordType where SobjectType='AF_Entity__c' and Name='Unilever Entity' Limit 1];       
     AF_Entity__c entity2=new AF_Entity__c();
     entity2.Name='Test Unilever Entityr';   
     entity2.AF_Country__c='Austria';     
     entity2.RecordTypeId=entiRT2.Id;         
     insert entity2; 
     
     System.Assert(entity2.Id != null, 'The Unilever Entity record not inserted');     
     
     //Insert Bonus Summary
     AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
     bonSum.AF_Agency__c=acc.Id;
     bonSum.AF_Brand__c=bran.Id;
     bonSum.AF_Fiscal_Year__c='2013';   
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
     bonmat.AF_BonusableFee__c=86588;     
     insert bonMat;
     
     //Invoking getBonusMatrixRecords method    
     AF_BonusSummaryRemote.getBonusMatrixRecords(acc.Id,bonSum.Id);
          
     Test.stopTest();
    }
  }  
}