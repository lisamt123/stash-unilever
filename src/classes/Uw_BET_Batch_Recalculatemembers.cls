/* -----------------------------------------------------------------------------------------------------------------------
   Name:        Uw_BET_Batch_Recalculatemembers.cls 
   Description: 1) Batch Class to populate the existing BET records' total number of members
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   December 2013     1.0        Teenu Pius         Initial Release for BET 2.0
  ------------------------------------------------------------------------------------------------------------------------ */

global class Uw_BET_Batch_Recalculatemembers implements database.batchable<sobject>{

 public final string query;
 
 //Get the query in constructor
    global Uw_BET_Batch_Recalculatemembers(string q)
     {
     query = q; 
    
     }
 
 //Get the records in start method
    global Database.querylocator start(database.batchablecontext bc)
     {     
        return database.getquerylocator(query);
     }
//get the team members size in execute method and update to DB
    global void execute(database.batchablecontext bc,list<uw_bet__C> betrecords)
    {
     map<id,uw_bet__C> bets = new map<id,uw_bet__C>(betrecords);
     for(uw_bet__c item:[select id,(select id from BET_Team_Members__r) from uw_bet__c where id in :bets.keyset()])
             bets.get(item.id).Total_Number_of_Members__c = item.BET_Team_Members__r.size();
    update bets.values();
    }

 //Final finish method
    global void finish(database.batchablecontext bc)
    {
    
    }
}//End of class