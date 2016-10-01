@isTest
public class FS_NewMonthlyClaimCaseSchedule_Test {
public static String CRON_EXP = '0 0 0 3 9 ? 2022';
    Static testmethod void testSchedule(){
     Contract_Product__c varContract=new Contract_Product__c ();
    varContract.name='test';
    insert varContract;
    
    FS_Monthly_Claimed_Cases__c varClaim=new FS_Monthly_Claimed_Cases__c ();
    varClaim.Contract_Product__c=varContract.id;
    varClaim.FS_First_of_Month__c=Date.newInstance(2015,05,05);
    insert varClaim;
    
        test.startTest();
        String jobId = System.schedule('FS_NewMonthlyClaimCase_Test',CRON_EXP,new FS_NewMonthlyClaimCase_BatchSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,
                          NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP,ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        test.stopTest();
    }
}