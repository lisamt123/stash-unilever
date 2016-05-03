/**********************************************************************
Name: WinAtPOS_SCH_FileFeedUrlUpdate
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Shedulable class which resposible for executing WinAtPOS_BatchFileFeedUrlUpdate
batchable class
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          01/12/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class WinAtPOS_SCH_FileFeedUrlUpdate implements Schedulable  {
	global void execute(SchedulableContext sc) {
      WinAtPOS_BatchFileFeedUrlUpdate b = new WinAtPOS_BatchFileFeedUrlUpdate(); 
      //process 100 records in each chunk  
      database.executebatch(b,100);
   }
}