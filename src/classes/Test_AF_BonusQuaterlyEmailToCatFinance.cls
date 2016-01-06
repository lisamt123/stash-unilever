/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_BonusQuaterlyEmailToCatFinance
@CreateDate : 22/9/2014
@Description : This is a Test class for AF_BonusQuaterlyEmailToCatFinance class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class Test_AF_BonusQuaterlyEmailToCatFinance
{     /***********************************************************************************
*  @Description: this method will the test data
*  @name : AFCallingSchedulable
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void SchedulableContext()
    {
        Test.StartTest();
        AF_BonusQuarterly_Quarterdates__c customList = new AF_BonusQuarterly_Quarterdates__c();
        customList.Name='quaterly';
        customList.AF_Q1__c= system.today();
        customList.AF_Q2__c= system.today();
        customList.AF_Q3__c= system.today();
        insert customList;
        System.Assert(customList.Id != null, 'The custom record not inserted');
        AF_BonusQuaterEmailToCatfinance_Schedule  EmailtoCatFinance =new AF_BonusQuaterEmailToCatfinance_Schedule();
        String CRON_VALUE = '0 0 3 ? * *';
        system.schedule('AF_Bonusquarterly_Reminder-yearly (TEST)', CRON_VALUE, EmailtoCatFinance);
        test.stopTest();
    }
}