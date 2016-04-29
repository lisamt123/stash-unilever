/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_SendEmailToCatFinance_Test
@Created Date : 08/08/2014.
@Description : This Test class for  AF_SendEmailToCatFinance apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_SendEmailToCatFinance_Test
{ 
    private static string EMAIL_CATFINANCE=' The CatFinanceThreshold Record is inserted';
    static User userforemailtocatFinance;
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : AFCallingSchedulable
*  @param : none
*  @return : none
*************************************************************************/  
    Static testMethod void AFCallingSchedulable()
    {
        Test.startTest();
        userforemailtocatFinance=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforemailtocatFinance.id LIMIT 1];
        System.runAs(u)
        {
            // insert catFinance threshold.
            System.assert(u.id!=null,AF_TestFactory_Helper.USER_RECORD);
            List<AF_CatFinanceThreshold__c> catFinanceLst = AF_TestFactory_Helper.insertcatfinancethreshold(1,true);
            List<AF_CatFinanceThreshold__c> catFinanceLstQuery = [SELECT Id FROM AF_CatFinanceThreshold__c LIMIT 1];
            System.assert(catFinanceLstQuery[0].Id!=null,EMAIL_CATFINANCE);
            Datetime dt = Datetime.now().addMinutes(1);
            AF_SendEmailToCatFinance_schedule  EmailtoCatFinance =new AF_SendEmailToCatFinance_schedule();
            String CRON_VALUE = '0 0 3 ? * *';
            system.schedule('AF_SendEmailToCatFinance_schedule', CRON_VALUE, EmailtoCatFinance);
            Test.stopTest();
        }
    }
}