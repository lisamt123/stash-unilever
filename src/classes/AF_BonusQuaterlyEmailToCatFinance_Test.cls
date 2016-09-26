/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BonusQuaterlyEmailToCatFinance_Test
@CreateDate : 22/9/2014
@Description : This is a Test class for AF_BonusQuaterlyEmailToCatFinance class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_BonusQuaterlyEmailToCatFinance_Test
{ 
    public static string BONUS_QUARTERLY_DATES=' The BonusQuarterly record inserted';
    static user userforBonusQuaterlyEmailToCatFinance;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_SchedulableContext
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_SchedulableContext()
    {
        Test.startTest();
        userforBonusQuaterlyEmailToCatFinance=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBonusQuaterlyEmailToCatFinance.id LIMIT 1];
        System.Assert(u.Id != null, AF_TestFactory_Helper.USER_RECORD);
        System.runAs(u)
        {
            // insert custom setting.
            List<AF_BonusQuarterly_Quarterdates__c> BonusQuarterlyList = AF_TestFactory_Helper.insertBonusQuarterlyQuarterdate(1,false);
            List<AF_BonusQuarterly_Quarterdates__c> QuarterlyList=new List<AF_BonusQuarterly_Quarterdates__c>(); 
            for(AF_BonusQuarterly_Quarterdates__c bonus:BonusQuarterlyList ){
            bonus.AF_Q1__c=system.today();
            QuarterlyList.add(bonus);
            }
            insert QuarterlyList;
            AF_BonusQuaterEmailToCatfinance_Schedule  EmailtoCatFinance =new AF_BonusQuaterEmailToCatfinance_Schedule();
            String CRON_VALUE = '0 0 3 ? * *';
            system.schedule('AF_Bonusquarterly_Reminder-yearly (TEST)', CRON_VALUE, EmailtoCatFinance);
            Test.stopTest();
        }
    }
}