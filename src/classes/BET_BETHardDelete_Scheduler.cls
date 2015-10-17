/*****************************************************************************************************************************
Name: BET_BETHardDelete_Scheduler
Copyright © 2015 Unilever. 

Purpose: Scheduler for Bet hard delete batch

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            17/10/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
global class BET_BETHardDelete_Scheduler implements Schedulable {

	global void execute(SchedulableContext sc) {
		BET_BETHardDelete_Batch batch = new BET_BETHardDelete_Batch();
		database.executebatch(batch);
   	}

}