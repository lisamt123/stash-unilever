Global with sharing Class PQNBatchDeleteRecords implements Database.Batchable<sobject>{
    /* This batch class in used to fetch the PQN records that are created 5 years back and delete the PQN records
    A scheduler class will be there that runs this class */
    
    Public List<sObject> pqnDeleteList1 = new List<sObject> ();
    
    //Implementing the "START" method
    global Database.Querylocator start(Database.BatchableContext bc){
        // String query = 'select Id, Name from PQN_Pallet_Quality_Non_Conformance__c where CreatedDate < LAST_N_YEARS:4 '; 
        String query = 'select Id, Name from PQN_Pallet_Quality_Non_Conformance__c where CreatedDate < Tomorrow ';
        system.debug('start method');
        return Database.getQueryLocator(query);

    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<sObject> pqnDeleteList = new List<sObject>(scope);
        system.debug('PQN List is' + pqnDeleteList);
        system.debug('the size is ' + pqnDeleteList.size());
        pqnDeleteList1.addAll(pqnDeleteList);
       // delete pqnDeleteList;
        system.debug('execute method');
    }
    
    global void finish(Database.BatchableContext bc){
        system.debug('this is the finish method');
        system.debug('the size is ' + pqnDeleteList1.size());
    }
    
    
    
}