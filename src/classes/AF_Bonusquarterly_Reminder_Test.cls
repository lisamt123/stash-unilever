/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Bonusquarterly_Reminder_Test
@Created Date : 05/08/2014.
@Description : This Test class for AF_Bonusquarterly_Reminder apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_Bonusquarterly_Reminder_Test
{   
    public static string BONUSQUARTER_DATES=' The BonusQuarterly record inserted';
    public static string SEND_EMAIL='The send_email record inserted ';
    static user userforBonusQuarterly;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : SchedulableContext
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void SchedulableContext()
    {
        Test.startTest();
        userforBonusQuarterly=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBonusQuarterly.id LIMIT 1];
        System.runAs(u)
        {
            // insert custom setting.
            List<AF_BonusQuarterly_Quarterdates__c> BonusQuarterlyList = AF_TestFactory_Helper.insertBonusQuarterlyQuarterdate(1,true);
            List<AF_BonusQuarterly_Quarterdates__c> BonusQuarterlyQuery = [SELECT Id From AF_BonusQuarterly_Quarterdates__c limit 1];
            System.assertEquals(BonusQuarterlyQuery[0].Id!=null,BonusQuarterlyList!=null,BONUSQUARTER_DATES);
            //insert send Email.
            List<Send_Email__c> sendEmail = AF_TestFactory_Helper.insertSendEmail(1,true);
            List<Send_Email__c> sendEmailQuery = [SELECT Id From Send_Email__c Limit 1];
            System.assertEquals(sendEmailQuery[0].Id!=null,sendEmail!=null,SEND_EMAIL);
            AF_BonusQuarterly_Reminder_schedule  BonusQuarterly =new AF_BonusQuarterly_Reminder_schedule();
            String CRON_VALUE = '0 0 3 ? * *';
            system.schedule('AF_Bonusquarterly_Reminder-yearly (TEST)', CRON_VALUE, BonusQuarterly);
            Test.stopTest();
        }
    }
}