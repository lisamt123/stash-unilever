/* * NewMonthlyClaimCase_BatchSchedule class to schedule NewMonthlyClaimCase_Batch
*  @name NewMonthlyClaimCase_BatchSchedule
*  @param
*  @return 
*  @throws
*/
Global with sharing class FS_NewMonthlyClaimCase_BatchSchedule implements Schedulable {
/* * Execute Method for NewMonthlyClaimCase_BatchSchedule scheduler class
*  @name Execute
*  @param SchedulableContext SC
*  @return 
*  @throws 
*/
    Global Void Execute(SchedulableContext SC){
        FS_NewMonthlyClaimCase_Batch newClaimCase=new FS_NewMonthlyClaimCase_Batch();
        Database.executeBatch(newClaimCase);
    }  
}