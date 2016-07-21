/**
 * Test_AF_BonusQuaterlyEmailToCatFinance: This Test class for AF_BonusQuaterlyEmailToCatFinance apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_BonusQuaterlyEmailToCatFinance
{    
    Static testMethod void AFCallingSchedulable()
    {
    Test.StartTest();
    AF_BonusQuarterly__c customList = new AF_BonusQuarterly__c();
    customList.AF_BonusQuarterlyDate__c = system.today();
    insert customList;
    AF_BonusQuaterlyEmailToCatFinance obj = new AF_BonusQuaterlyEmailToCatFinance();
     Datetime dt = Datetime.now().addMinutes(1);
     String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
     String jobId = System.schedule('Sample_Heading', CRON_EXP, obj); 
     Database.BatchableContext BC ;
     obj.finish(BC);
     //obj.start(BC);
     Test.stopTest();
    
    }
}