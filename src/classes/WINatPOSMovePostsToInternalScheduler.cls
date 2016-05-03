/*===========================================================================
  Name:  WINatPOSMovePostsToInternalScheduler                                                        
  Copyright notice:                                                          
  ===========================================================================
  ===========================================================================
   Purpose: WINatPOSMovePostsToInternalScheduler scheduler class resposible for 
			to schedule batch class WINatPOSMovePostsToInternalBatchable
  ===========================================================================
  ===========================================================================
  History                                                                   
  -------                                                                   
  VERSION  AUTHOR           DATE              DETAIL          RELEASE/CSR   
   1.0 -  Karol Szepietowski   24/11/2015      INITIAL DEVELOPMENT               
  ===========================================================================*/

global class WINatPOSMovePostsToInternalScheduler implements Schedulable {
	
    global void execute(SchedulableContext sc) {
        
        WINatPOSMovePostsToInternalBatchable batchable = new WINatPOSMovePostsToInternalBatchable();
        database.executeBatch(batchable,100);
    }

}