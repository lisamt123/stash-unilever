/**********************************************************************
Name: BET_SCH_BatchDeniedMemberRequestDel_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for BET_SCH_BatchDeniedMemberRequestDelete
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          17/09/2014      INITIAL DEVELOPMENT
1.1 -   Michal Bluj             30/09/2015      SONAR ISSUES
***********************************************************************/

@isTest
public class BET_SCH_BatchDeniedMemberRequestDel_Test {     
   //public static string CRON_EXP = '0 0 0 15 3 ? 2022'; commented due to sonar issue

  /*******************************************************************
    Purpose: Method to test scheduling Apex class for batch asset delete
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void testScheduledJob(){
        // Custom settings
        BET_ManageMembersSettings__c betMembersSettings = BET_ManageMembersSettings__c.getValues('BETManageMembersConfig');
          
        if ( betMembersSettings == null ) {       
            betMembersSettings = new BET_ManageMembersSettings__c();
         
            betMembersSettings.Name = 'BETManageMembersConfig';
            betMembersSettings.ManagerRole__c = 'Manager'; 
            betMembersSettings.MemberRole__c = 'Member';
            betMembersSettings.ExternalRole__c = 'External Agency User';
            betMembersSettings.ApprovedStatus__c = 'Approved';
            betMembersSettings.DeniedStatus__c = 'Denied';
            betMembersSettings.ToolkitAccessLevel__c = 'Toolkit Experience (Toolkit only)';
            betMembersSettings.ExternalAccessLevel__c = 'External View (Chatter group only)';
            betMembersSettings.InternalUserRecordType__c = 'InternalUser';
            betMembersSettings.BET_Member_Object_Name__c = 'uw_BET_Team_Member__c';
              
            insert betMembersSettings;
        }
    
        Test.startTest();
    
        // schedule the test job
        String jobId = System.schedule('Scheduled Job to Delete BET Denied Member Requests', 
                                        '0 0 0 15 3 ? 2022', new BET_SCH_BatchDeniedMemberRequestDelete());  
        // get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE id =: jobId];
        
        Test.stopTest();
        
           // Verify the expressions are the same
        System.assertEquals('0 0 0 15 3 ? 2022',ct.CronExpression);
    
        // Verify the job has not run 
        System.assertEquals(0,ct.TimesTriggered);
    
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));
    
    }   
}