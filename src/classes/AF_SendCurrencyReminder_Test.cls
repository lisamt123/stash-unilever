/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_SendCurrencyReminder
@Created Date : 08/08/2014.
@Description : This Test class for  AF_SendCurrencyReminder  apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_SendCurrencyReminder_Test 
{   
 private static string SEND_EMAIL='The send email record inserted';
 static user userForSendCurrency;
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : AFCurrencySchedulable
*  @param : none
*  @return : none
*************************************************************************/  
    static testmethod void AFCurrencySchedulable()
    {
        Test.startTest();
        userForSendCurrency=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForSendCurrency.id LIMIT 1];
        System.runAs(u)
        {
            List<Send_Email__c> sendEmail = AF_TestFactory_Helper.insertSendEmail(1,true);
            List<Send_Email__c> sendEmailQuery = [SELECT Id FROM Send_Email__c LIMIT 1];
            System.assert(sendEmailQuery[0].Id!=null ,SEND_EMAIL);
            AF_SendCurrencyReminder_schedule  EmailtoCatFinance =new AF_SendCurrencyReminder_schedule();
            String CRON_VALUE = '0 0 3 ? * *';
            system.schedule('AF_SendCurrencyReminder_schedule-yearly (TEST)', CRON_VALUE, EmailtoCatFinance);
            Test.stopTest();
        }
    }
}