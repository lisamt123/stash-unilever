/**********************************************************************
Name:BET_BatchDeniedMemberRequestDelete
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class to execute batch Apex method to delete denied member request records
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi           17/09/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class BET_BatchDeniedMemberRequestDelete implements Database.Batchable<uw_BET_Team_Member__c>{
    /*******************************************************************
    Purpose: Method to generate the list of member records to be deleted
    Parameters: Void
    Returns: List of Assets
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global Iterable<uw_BET_Team_Member__c> start(Database.batchableContext BC){
        System.Debug('***BET_BatchDeniedMemberRequestDelete start invoked***');
        BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues('BETManageMembersConfig');
        String deniedStatus = BETManageMembersConfig.DeniedStatus__c;
      
        List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Request_Status__c, Scheduled_Delete_Date__c FROM uw_BET_Team_Member__c WHERE  Request_Status__c = :deniedStatus AND Scheduled_Delete_Date__c = TODAY];
        return teamMemberList; 
    }
    
    /*******************************************************************
    Purpose: Method to execute a batch Apex process to delete assets
    Parameters: Database.BatchableContext, list of assets for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, List<uw_BET_Team_Member__c> scope){ 
        System.Debug('***BET_BatchDeniedMemberRequestDelete execute invoked***');
        
        // Force DML Exception for Delete operation
        if ( Test.isRunningTest() ) {
           List<uw_BET_Team_Member__c> dummyTeamMemberList = [SELECT Id, Team_Member__c FROM uw_BET_Team_Member__c WHERE Role__c = 'InvalidRole'];
           if ( dummyTeamMemberList.size() != 0 ) {
               delete dummyTeamMemberList[0];
           }
        }  
        
        try {
            delete scope;
        }
         catch ( Exception e ) {
              System.Debug('Delete BET Team Member Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        }
    }
    
    /*******************************************************************
    Purpose: Method to finish the batch Apex process to delete assets
    Parameters: Database.BatchableContext
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void finish(Database.BatchableContext BC){
       System.Debug('***BET_BatchDeniedMemberRequestDelete finish invoked***');
       //### No finish operations
    }
}