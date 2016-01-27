/* -----------------------------------------------------------------------------------------------------------------------
   Name:        uw_BET_schedule_recalculatemembersbatch.cls 
   Description: 1) Class to schedule  batch,Uw_BET_Batch_Recalculatemembers, which populate the existing BET records' total
                    number of members
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   December 2013     1.0        Teenu Pius         Initial Release for BET 2.0
  ------------------------------------------------------------------------------------------------------------------------ */
global class uw_BET_schedule_recalculatemembersbatch Implements Schedulable
{
public string query;
global void execute(SchedulableContext sc)
    {
        //Forming the query which fetches all existing bets
        query = 'select id,Total_Number_of_Members__c from uw_bet__c';
        Uw_BET_Batch_Recalculatemembers b = new Uw_BET_Batch_Recalculatemembers(query); 
        //Batch size is fixed as 50
        database.executebatch(b,50);                                             
    }//End of method
 
}//End of class