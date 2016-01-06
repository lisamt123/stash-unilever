/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_SendCurrencyReminder
@Created Date : 08/08/2014.
@Description : This Test class for  AF_SendCurrencyReminder  apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class Test_AF_SendCurrencyReminder 
{
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : AFCurrencySchedulable
*  @param : none
*  @return : none
*************************************************************************/  
    static testmethod void SchedulableContext()
    {
        test.starttest();
        String DayofMonth;
        DayofMonth=string.valueOf(system.now().day());
        Send_Email__c  email=new Send_Email__c();   
        email.AF_CurrencyUpdateRequired__c=true;
        insert email;
        System.Assert(email.Id != null, 'The record inserted');
        af_SendCurrencyReminder_schedule  EmailtoCatFinance =new af_SendCurrencyReminder_schedule();
        String CRON_VALUE = '0 0 3 ? * *';
        system.schedule('af_SendCurrencyReminder_schedule-yearly (TEST)', CRON_VALUE, EmailtoCatFinance);
        test.stopTest();
    }
}