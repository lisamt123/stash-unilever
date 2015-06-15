/**********************************************************************
Name: WINatPOS_SCH_BatchAssetDelete_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WINatPOS_SCH_BatchAssetDelete
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          17/09/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class WINatPOS_SCH_BatchAssetDelete_Test {     
    public static string CRON_EXP = '0 0 0 15 3 ? 2022';

  /*******************************************************************
    Purpose: Method to test scheduling Apex class for batch asset delete
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void testScheduledJob(){
        Test.startTest();
    
        // schedule the test job
        String jobId = System.schedule('Scheduled Job to Delete WINatPOS Assets', 
                                        CRON_EXP, new WINatPOS_SCH_BatchAssetDelete());  
        // get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE id =: jobId];
        
        Test.stopTest();
        
           // Verify the expressions are the same
        System.assertEquals(CRON_EXP,ct.CronExpression);
    
        // Verify the job has not run 
        System.assertEquals(0,ct.TimesTriggered);
    
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));
    
    }   
}