/*@Author Jayprakash Bharti(M1033242)
    Schedular class to schedule the Batch process for Pworf Ageing calculation
*/

global class CPA_ScheduleBatchProrfAgeUpdate implements Schedulable
{
    global void execute(SchedulableContext sc)
    {   
        
        CPA_batchProrfAgeUpdate b = new CPA_batchProrfAgeUpdate();
        database.executebatch(b,200);
    }
   
}