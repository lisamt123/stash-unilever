/**
 * Test_AF_OOPSEstimateController : This Test class for AF_OOPSEstimateController apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_OOPSEstimateController 
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static testMethod void oopsEstimateController()
    {          
     Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testoc', Email='standarduseroc@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Useroc', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
      UserName='testuseroc@test123321.com',AF_Brand__c='Test Brandoc',AF_Category__c='Test Beveragesoc');
     insert u;        
      
     System.runAs(u)
     { 
     
     //Insert Account
     Account acc=new Account();
     acc.Name='Test Agencyoc';
     acc.published__c=true;
     insert acc;
     
     System.Assert(acc.Id != null, 'The account record not inserted');
     
     //Insert Category
     RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
     AF_Category_Brand__c cat=new AF_Category_Brand__c();
     cat.RecordTypeId=catRT.Id;
     cat.Name='Test Beveragesoc';
     cat.AF_Pilot_Model__c=false;     
     cat.AF_Super_category__c='Drinks';
     insert cat;
     
     System.Assert(cat.Id != null, 'The Category record not inserted');
     
     //Insert Brand
     RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
     AF_Category_Brand__c bran=new AF_Category_Brand__c();
     bran.RecordTypeId=brandRT.Id;
     bran.AF_Pilot_Model__c=false;    
     bran.Name='Test Brandoc';
     bran.AF_Category_Brands__c=cat.Id;
     insert bran;
     
     System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
     
     //Insert Brand Estimate                  
     AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
     brandEst.AF_Agency__c=acc.Id;               
     brandEst.Name='Test BrandEstimateoc';
     brandEst.AF_Status_Base_Fees__c='Initiate';  
     brandEst.Brand__c=bran.id;
     insert brandEst;
     
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
     
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopsEst=new AF_OOPS_Estimate__c();
     oopsEst.AF_Brand_Estimate__c=brandEst.Id;
     oopsEst.AF_OOPS_Actual__c=oopsActual.Id;
     oopsEst.AF_Estimate__c=75;
     oopsEst.AF_Status__c='Ready for PO';
     insert oopsEst; 
     
     ApexPages.currentPage().getParameters().put('id',oopsEst.id);         
     AF_OOPSEstimateController oopsEstCtrl=new AF_OOPSEstimateController();
     oopsEstCtrl.Save();
     oopsEstCtrl.SavePO();
     
     //Insert OOPS Actual
     AF_OOPS_Actual__c oopsActual1=new AF_OOPS_Actual__c();
     oopsActual1.AF_Agency_lk__c=acc.Id;
     oopsActual1.AF_Brand__c=bran.Id;
     oopsActual1.AF_Agency__c=acc.Id;
     oopsActual1.AF_Status__c='Ready For PO ';
     oopsActual1.Name = 'Axe-Q1-2015';
     oopsActual1.Quarter__c='Q1';
     insert oopsActual1;
     
     //Insert OOPS Estimate
     AF_OOPS_Estimate__c oopsEst1=new AF_OOPS_Estimate__c();
     oopsEst1.AF_Brand_Estimate__c=brandEst.Id;
     oopsEst1.AF_OOPS_Actual__c=oopsActual1.Id;
     oopsEst1.AF_Estimate__c=75;
     oopsEst1.AF_Status__c='Ready For PO';
     
     insert oopsEst1; 
     
     ApexPages.currentPage().getParameters().put('id',oopsEst1.id);         
     AF_OOPSEstimateController oopsEstCtrl1=new AF_OOPSEstimateController();
     oopsEstCtrl1.Save();
     oopsEstCtrl1.SavePO();
     
     delete oopsActual1;
     
     }
  }
}