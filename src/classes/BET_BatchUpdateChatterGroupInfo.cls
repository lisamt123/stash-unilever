/**********************************************************************
Name: BET_BatchUpdateChatterGroupInfo 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class for updating BET chatter group information
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Wojciech Migas          05/02/2015      INITIAL DEVELOPMENT
**********************************************************************/
global class BET_BatchUpdateChatterGroupInfo implements Database.Batchable<sObject>, Database.Stateful {
    
    global pattern myPattern;
    
    global BET_BatchUpdateChatterGroupInfo() {
        String brandObjectPrefix = uw_Brand__c.sObjectType.getDescribe().getKeyPrefix();
        myPattern = pattern.compile('(<a href="(?:/apex/brandexper|/' + brandObjectPrefix + ')[^>]+>.+?</a>)');
    }
    /*******************************************************************
    Purpose: Method to generate the list of BET chatter groups to be updated
    Parameters: BatchableContext
    Returns: List of BET chatter groups 
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global Database.QueryLocator start(Database.batchableContext BC){
        String query = 'SELECT Studio_Chatter_Group__c FROM uw_BET__c WHERE Studio_Chatter_Group__c != null';    
        return Database.getQueryLocator(query); 
    }    

    /*******************************************************************
    Purpose: Method to execute a batch Apex process to update BET chatter group information
    Parameters: Database.BatchableContext, list of assets for scope
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    global void execute(Database.BatchableContext BC, List<uw_BET__c> scope) {
        system.debug('---execute--');
        Set<Id> chatterGroupIds = new Set<Id>();
        for (uw_BET__C BET : scope) {
            chatterGroupIds.add(BET.Studio_Chatter_Group__c);
        }
        LIST<CollaborationGroup> chatterGroups = [SELECT Id, InformationBody FROM CollaborationGroup WHERE Id =: chatterGroupIds];
        for(CollaborationGroup chatterGroup : chatterGroups) {
            if (String.isNotEmpty(chatterGroup.InformationBody)) {
                chatterGroup.InformationBody = myPattern.matcher(chatterGroup.InformationBody).replaceAll('');
            }
        }
        update chatterGroups;
    }    
    
    global void finish(Database.BatchableContext BC) {       
    }
}