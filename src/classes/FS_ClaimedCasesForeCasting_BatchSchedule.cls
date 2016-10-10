/* * ClaimedCasesForeCasting_BatchSchedule class to schedule MonthlyClaimCasesBatch
*  @name ClaimedCasesForeCasting_BatchSchedule
*  @param
*  @return 
*  @throws
*/ 
Global with sharing class FS_ClaimedCasesForeCasting_BatchSchedule implements Schedulable{
/* * Execute Method for ClaimedCasesForeCasting_BatchSchedule scheduler class
*  @name Execute
*  @param SchedulableContext SC
*  @return 
*  @throws 
*/ 
    Global Void execute(SchedulableContext SC){
        FS_MonthlyClaimCases_Batch claimCaseForecast=new FS_MonthlyClaimCases_Batch();
        Database.executeBatch(claimCaseForecast);
    }     
}