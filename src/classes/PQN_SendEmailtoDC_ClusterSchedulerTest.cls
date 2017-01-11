@isTest
private class PQN_SendEmailtoDC_ClusterSchedulerTest{
    static testmethod void  testschedule(){
        Test.StartTest();
            PQN_SendEmailtoDC_ClusterScheduler sh1 = new PQN_SendEmailtoDC_ClusterScheduler();
            String sch = '0 0 23 * * ?'; 
            system.schedule('Test', sch, sh1);
        Test.stopTest();
    }
}