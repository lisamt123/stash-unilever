/**
 * Test_AF_SendEmailToCatFinance: This Test class for AF_SendEmailToCatFinance apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_SendEmailToCatFinance
{    
    Static testMethod void AFCallingSchedulable()
    {
    Test.StartTest();
    AF_CatFinanceThreshold__c customList = new AF_CatFinanceThreshold__c();
    customList.AF_Date__c = system.today();
    insert customList;
    AF_SendEmailToCatFinance obj = new AF_SendEmailToCatFinance();
    //obj.query=null;
     Datetime dt = Datetime.now().addMinutes(1);
     String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
     String jobId = System.schedule('Sample_Heading', CRON_EXP, obj); 
     Database.BatchableContext BC ;
     obj.finish(BC);
     Test.stopTest();
    
    }
}