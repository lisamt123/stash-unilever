@isTest
public class FS_ClaimedCasesForeCastingSchedule_Test {
public static String CRON_EXP = '0 0 0 3 9 ? 2022';
    Static testmethod void testSchedule(){
        test.startTest();
        String jobId = System.schedule('FS_ClaimedCasesForeCasting_Test',CRON_EXP,new FS_ClaimedCasesForeCasting_BatchSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,
                          NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP,ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        test.stopTest();
    }
}