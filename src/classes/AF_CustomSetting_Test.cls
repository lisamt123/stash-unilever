/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_CustomSetting_Test
@CreateDate : 26/9/2014
@Description : This is a Test class for AF_CustomSetting class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_CustomSetting_Test
{ 
    public static string QuarterlyBonu=' QuarterlyBonus Record is inserted';
    public static string Triggerdate='Triggerdate Record is inserted';
    public static string AgencyEmail='The Agency_Email_alerts record inserted';
    public static string Agency_Bonus='The Agency_Bonus_Access record inserted';
    public static string AF_isBonusLink='The Bonus Link Agency Record is inserted';
    public static string AF_CMCO='CMCO Record is inserted';
    public static string AF_CatFinanceThreshold='CatFinanceThreshold Record is inserted';
    public static string AF_BrandEstimate_TriggerDate=' The BrandEstimateTriggerDate is inserted';
    public static string AF_BonusQuarterly=' The BonusQuarterly record is inserted';
    public static string AF_AnnualBonus_Qual='The AnnualBonus records are inserted';
    public static string AF_OOPS_Settings='The oopssetting records are inserted';
    public static string AF_Links=' The link record is inserted';
    static user userforcustomsetting;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : afAFCustomSetting
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void afAFCustomSetting()
    {
        Test.startTest();
        userforcustomsetting=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforcustomsetting.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert QuarterlyBonus.
            List<AF_QuarterlyBonus__c> QuarterlyBonus = AF_TestFactory_Helper.insertQuarterlyBonus(1,false);
            List<AF_QuarterlyBonus__c> QuarterlyBonuslist=new List<AF_QuarterlyBonus__c>();
            for(AF_QuarterlyBonus__c QB : QuarterlyBonus){
                QB.Minimum__c =5;
                QB.Stretching__c = 10;
                QB.Outstanding__c = 15;
                QuarterlyBonuslist.add(QB);
            }
            insert QuarterlyBonuslist;
            List<AF_QuarterlyBonus__c> QuarterlyBonusQuery = [SELECT ID FROM AF_QuarterlyBonus__c LIMIT 1];
            System.assert(QuarterlyBonusQuery[0].id!=null,QuarterlyBonu);
            // insert Trigger date.
            List<AF_TriggerDate__c> TriggerdateList = AF_TestFactory_Helper.insertTriggerdate(1,true);
            List<AF_TriggerDate__c> TriggerdateListQuery = [SELECT Id FROM AF_TriggerDate__c where id IN:TriggerdateList LIMIT 1];
            System.assert(TriggerdateListQuery[0].id!=null,Triggerdate);
            //insert Agency Email alerts.
            AF_AgencyEmailAlerts__c ae = new AF_AgencyEmailAlerts__c();
            ae.Name = 'Agency Reminder';
            ae.Q1__c = system.today();
            ae.Q2__c = system.today();
            ae.Q3__c = system.today();
            ae.Q4__c = system.today();
            insert ae;
            System.Assert(ae.Id != null,AgencyEmail );
            // insert Agency Bonus.
            AF_Agency_Bonus_Access__c ab = new AF_Agency_Bonus_Access__c();
            ab.Name='2014';
            ab.AF_Access_Date__c = system.today();
            ab.AF_Fiscal_Year__c = '2014';
            insert ab;
            System.Assert(ab.Id != null,Agency_Bonus );
            // insert bonusLink for Agency.
            List<AF_isBonusLinkForAgency__c> bonusLinkforAgency = AF_TestFactory_Helper.insertBonusLinkforAgency(1,true);
            List<AF_isBonusLinkForAgency__c> bonusLinkforAgencyQuery = [SELECT Id FROM AF_isBonusLinkForAgency__c where id IN:bonusLinkforAgency LIMIT 1];
            system.assert(bonusLinkforAgencyQuery[0].id!=null,AF_isBonusLink);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            // insert CMCO
            List<AF_CMCO__c> cmcoLst = AF_TestFactory_Helper.insertCMCO(1,true);
            List<AF_CMCO__c> cmcoLstQuery = [SELECT Id FROM AF_CMCO__c where id IN:cmcoLst LIMIT 1];
            system.assert(cmcoLstQuery[0].id!=null,AF_CMCO);
            // insert AF_Cat_Thershold
            List<AF_CatFinanceThreshold__c> CatFinanceThreshold = AF_TestFactory_Helper.insertcatfinancethreshold(1,true);
            List<AF_CatFinanceThreshold__c> CatFinanceThresholdQuery = [SELECT Id FROM AF_CatFinanceThreshold__c where id IN:CatFinanceThreshold LIMIT 1];
            system.assert(CatFinanceThresholdQuery[0].id!=null,AF_CatFinanceThreshold);
            //insert BonusEstimateTriggerDate.
            List<AF_BrandEstimate_TriggerDate__c> BonusEstimateTriggerDate =AF_TestFactory_Helper.insertBrandEstimateTriggerDate(1,true);
            List<AF_BrandEstimate_TriggerDate__c> BonusEstimateTriggerDateQuery = [SELECT Id FROM AF_BrandEstimate_TriggerDate__c where id IN:BonusEstimateTriggerDate LIMIT 1];
            System.assert(BonusEstimateTriggerDateQuery[0].id!=null,AF_BrandEstimate_TriggerDate);
            //insertBonus Quarterly.
            List<AF_BonusQuarterly__c> bonusQuarterly = AF_TestFactory_Helper.insertAnnualBonusQuarterly(true,1);
            List<AF_BonusQuarterly__c> bonusQuarterlyQuery = [SELECT Id FROM AF_BonusQuarterly__c where id IN:bonusQuarterly LIMIT 1];
            System.assert(bonusQuarterlyQuery[0].id!=null,AF_BonusQuarterly);
            //insert Anuual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,true);
            List<AF_AnnualBonus_Qual__c> AnnualBs = AF_TestFactory_Helper.insertAnnualBonus(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBslist=new List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  AnnualBonus : AnnualBs)
            {
                AnnualBonus.X5__c = 15;
                AnnualBonus.X1__c = 0;
                AnnualBonus.X2__c = 0;
                AnnualBonus.X3__c = 5;
                AnnualBonus.X4__c = 10;
                AnnualBslist.add(AnnualBonus);
            }
            insert AnnualBslist;
            List<AF_AnnualBonus_Qual__c> AnnualBsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c LIMIT 1];
            System.AssertEquals(AnnualBsQuery[0].Id != null,AnnualBns!=null,AF_AnnualBonus_Qual );
            //insert oopsSettings.
            List<AF_OOPS_Settings__c> OOPsettingLst = AF_TestFactory_Helper.insertOOPsetting(true,1);
            List<AF_OOPS_Settings__c> OOPsettingLstQuery = [SELECT Id FROM AF_OOPS_Settings__c where id IN:OOPsettingLst LIMIT 1 ];
            System.Assert(OOPsettingLstQuery[0].Id != null,AF_OOPS_Settings );
            //insert Link.
            List<AF_Links__c> LinkList = AF_TestFactory_Helper.insertlink(1,true);
            List<AF_Links__c> LinkListQuery = [SELECT ID FROM AF_Links__c where id IN:LinkList LIMIT 1];
            system.assert(LinkListQuery[0].id!=null ,AF_Links);
            AF_CustomSetting cs = new AF_CustomSetting();
            cs.submitCustomSetting();
            cs.submitTriggerDate();
            cs.submitAgencyEmailAlerts();
            cs.submitAgencyBonusMap();
            cs.submitBonusLink();
            cs.submitDummyUserId();
            cs.submitAFCMCO();
            cs.submitCatFinThreshold();
            cs.submitbrandTriggerDate();
            cs.submitBonusQuarterly();
            cs.submitAnnualBonusQual();
            cs.submitoopsPercentage();
            cs.submitAFLinks();
            Test.stopTest(); 
        }
    }
}