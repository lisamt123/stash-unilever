@isTest
private class FA_Test_PWTreminderMailScheduler
{
    static testmethod void testSchedule()
    {
        Test.startTest();
        final String jobId = System.schedule('FA_PWTreminderMailScheduler','0 0 0 3 9 ? 2022',new FA_PWTreminderMailScheduler());
        Test.stopTest();
        System.assertEquals('0 0 0 3 9 ? 2022',[select CronExpression from CronTrigger where id = :jobId].CronExpression);
    }
}