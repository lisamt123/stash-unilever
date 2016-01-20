/**********************************************************************
Name: BET_SoslFieldsBatch 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class for populating fields on BET object for SOSL porpose.
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/12/2014      INITIAL DEVELOPMENT
**********************************************************************/
global class BET_SoslFieldsBatch implements Database.Batchable<uw_BET__c> {
    global final String query;
    private Boolean isFirst;
    
    global Iterable<uw_BET__c> start(Database.batchableContext BC){
        System.Debug('***BET_SoslFieldsBatch start invoked***');
        // LIMIT value below in SOQL is subject to how many BETs we have in the Production system
        List<uw_BET__c> betList = [SELECT Id, Name, Inoplan_Project__r.Name, Sub_Category__r.Name, Owner.Name, uw_Brand__r.Name FROM uw_BET__c LIMIT 20000];  
        return betList; 
    }

    global void execute(Database.BatchableContext BC, List<uw_BET__c> scope) {
    	List<uw_BET__c> betList = new List<uw_BET__c>();
        for(uw_BET__c bet : scope){
        	if ( bet.Inoplan_Project__r.Name != null && bet.Inoplan_Project__r.Name != ''){
        		bet.Inoplan_Project_Keyword_Search__c = bet.Inoplan_Project__r.Name;
        	}

        	if ( bet.Sub_Category__r.Name != null && bet.Sub_Category__r.Name != ''){
        		bet.Category_Keyword_Search__c = bet.Sub_Category__r.Name;
        	}

        	if ( bet.uw_Brand__r.Name != null && bet.uw_Brand__r.Name != ''){
        		bet.Brand_Keyword_Search__c = bet.uw_Brand__r.Name;
        	}

        	if ( bet.Owner.Name != null && bet.Owner.Name != ''){
        		bet.Owner_Keyword_Search__c = bet.Owner.Name;
        	}

        	betList.add(bet);
        }

        try {
            update betList;
        }
        catch ( Exception e ) {
            System.Debug('Update BET Exception. ' + e.GetLineNumber() + ': ' + e.GetMessage());
        }
    }    
    
    global void finish(Database.BatchableContext BC) {
        System.Debug('***BET_SoslFieldsBatch finish invoked***');
    }
}