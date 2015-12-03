/**
 * Test_AFCustomSetting: This Test class for AFCustomSetting apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AFCustomSetting
{    
    Static testMethod void afAFCustomSetting()
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
     AF_QuarterlyBonus__c qd = new AF_QuarterlyBonus__c();
     qd.Name = 'Bonus Threshold';
     qd.Minimum__c =5;
     qd.Stretching__c = 10;
     qd.Outstanding__c = 15;
     insert qd;
     
     AF_TriggerDate__c td = new AF_TriggerDate__c();
     td.Date__c = system.today();
     insert td;
     
     AF_AgencyEmailAlerts__c ae = new AF_AgencyEmailAlerts__c();
     ae.Name = 'Agency Reminder';
     ae.Q1__c = system.today();
     ae.Q2__c = system.today();
     ae.Q3__c = system.today();
     ae.Q4__c = system.today();
     insert ae;
     
     AF_Agency_Bonus_Access__c ab = new AF_Agency_Bonus_Access__c();
     ab.Name='2014';
     ab.AF_Access_Date__c = system.today();
     ab.AF_Fiscal_Year__c = '2014';
     insert ab;
     
     AF_isBonusLinkForAgency__c bl = new AF_isBonusLinkForAgency__c();
     bl.Name ='Bonus Quarterly';
     bl.Bonus_Date__c = system.today();
     insert bl;
     
     DummyUser__c du = new DummyUser__c();
     du.User_id__c = '005L0000001FiKA';
     insert du;
     
     AF_CMCO__c ac = new AF_CMCO__c();
     ac.AF_CMCO_Rights__c = true;
     insert ac;
     
     AF_CatFinanceThreshold__c cf = new AF_CatFinanceThreshold__c();
     cf.AF_Date__c = system.today();
     insert cf;
     
     AF_BrandEstimate_TriggerDate__c be = new AF_BrandEstimate_TriggerDate__c();
     be.AF_Currency_Uploaded__c = true;
     be.AF_Trigger_Date__c = system.today();
     insert be;
     
     AF_BonusQuarterly__c bq = new AF_BonusQuarterly__c();
     bq.AF_BonusQuarterlyDate__c = system.today();
     
     
     insert bq;
     
     
     
     AF_AnnualBonus_Qual__c abq = new AF_AnnualBonus_Qual__c();
     abq.Name = 'Qualitative Value';
     abq.X1__c = 0;
     abq.X2__c=0;
     abq.X3__c =5;
     abq.X4__c = 10;
     abq.X5__c = 15;
     insert abq;
     
     AF_AnnualBonus_Qual__c abq1 = new AF_AnnualBonus_Qual__c();
     abq1.Name = '5';
     abq1.X1__c = 0;
     abq1.X2__c=0;
     abq1.X3__c =5;
     abq1.X4__c = 10;
     abq1.X5__c = 15;
     insert abq1;
     
     AF_OOPS_Settings__c oops = new AF_OOPS_Settings__c();
     oops.Overall_Percentage__c = 4;
     insert oops;
     
     AF_Links__c link = new AF_Links__c();
     link.AF_Community_Link__c = 'https://agfeecog2-unilever.cs8.force.com/AgencyFees';
     insert link;
     
     
     
     
     
     AF_CustomSetting cs = new AF_CustomSetting();
     cs.submitCustomSetting();
     //cs.submitTriggerDate();
     //cs.submitAgencyEmailAlerts();
     //cs.submitAgencyBonusMap();
     cs.submitBonusLink();
     cs.submitDummyUserId();
     cs.submitAFCMCO();
     //cs.submitCatFinThreshold();
     //cs.submitbrandTriggerDate();
     //cs.submitBonusQuarterly();
     
     cs.submitAnnualBonusQual();
     cs.submitoopsPercentage();
     cs.submitAFLinks();
     
     
    }
    Test.stopTest(); 
    }
    
}