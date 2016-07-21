/**
 * Test_AF_OopEstimateRemote : This Test class for AF_OopEstimateRemote  apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_OopEstimateRemote 
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void oopEstimateRemote()
    {          
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testo', Email='standardusero@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test User123', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testusero@test123321.com',AF_Brand__c='Test Brando',AF_Category__c='Test Beverageso');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyo';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beverageso';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brando';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateo';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     insert brandEst;
     
     System.assertEquals(brandEst.Brand__c, bran.id);

     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
     oopsActual.AF_Agency_lk__c=acc.Id;
     oopsActual.AF_Brand__c=bran.Id;
     oopsActual.AF_Agency__c=acc.Id;
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
     
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopsEst=new AF_OOPS_Estimate__c();
     oopsEst.AF_Brand_Estimate__c=brandEst.Id;
     oopsEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopsEst.AF_Estimate__c=75;
     insert oopsEst; 
     
     AF_OopEstimateRemote.getOOPSEstimateRecords(acc.Id,oopsActual.Id); 
     
     oopsEst.AF_Estimate__c=0;
     update oopsEst;
     
     AF_OopEstimateRemote.getOOPSEstimateRecords(acc.Id,oopsActual.Id); 
     }
  }
}