/*===========================================================================
  Name:  WINatPOSMovePostsToInternalSchedulerTest                                                        
  Copyright notice:                                                          
  ===========================================================================
  ===========================================================================
   Purpose: WINatPOSMovePostsToInternalSchedulerTest test class for  WINatPOSMovePostsToInternalScheduler
  ===========================================================================
  ===========================================================================
  History                                                                   
  -------                                                                   
  VERSION  AUTHOR           DATE              DETAIL          RELEASE/CSR   
   1.0 -  Karol Szepietowski   24/11/2015      INITIAL DEVELOPMENT               
  ===========================================================================*/

@isTest
private class WINatPOSMovePostsToInternalSchedulerTest {
    
    /*******************************************************************
    Purpose: Testing WINatPOSMovePostsToInternalScheduler initialization
             in CronTrigger table
    ********************************************************************/
    static testMethod void testSchedule(){
        
        test.startTest();
        String CRON_EXP = '0 1 0 * * ?';
        String jobId = System.schedule('test schedule for WINatPOSMovePostsToInternalScheduler',
                                       CRON_EXP,
                                       new WINatPOSMovePostsToInternalScheduler());
        
		system.assertEquals(true, jobId != null, 'Batch Apex class should be scheduled');
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
        system.debug(JSON.serialize(ct)); 
			
        test.stopTest();
    }

}