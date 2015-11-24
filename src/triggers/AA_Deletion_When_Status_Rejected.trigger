trigger AA_Deletion_When_Status_Rejected on aa_Agent_Report__c (after update) {
	    
    List<Id> agentReportIDList =  new List<Id>();
    Set<Id> recordTypeIds = new Set<Id>();
    
    for(aa_Agent_Report__c  agentReportObj:Trigger.new){
        recordTypeIds.add(agentReportObj.RecordTypeId);
    }
    
    List<RecordType> recordtypeNameList = [select name,id from RecordType where id =:recordTypeIds];
    system.debug('Record Type======>'+recordtypeNameList);
    
    for(aa_Agent_Report__c agentReportObj:Trigger.new){
        
        for(RecordType recordtypeObject:recordtypeNameList ){
        	  
        	if((agentReportObj.Status__c == 'Rejected' && recordtypeObject.name == 'ETS Members Record Type' && agentReportObj.Approve_Reject__c == 'Reject')
                ||
               (agentReportObj.Status__c == 'Rejected' && recordtypeObject.name == 'CI Manger Record type'))
                {
                	system.debug('all condition satisfied=====>');
                    agentReportIDList.add(agentReportObj.id);    
                }
        
        }
    
    }
                    
    system.debug('agentNeed to be deleted=======>'+agentReportIDList);          
    List<aa_Agent_Report__c> agentReportNeedToDelete = [select id,name from aa_Agent_Report__c where id = :agentReportIDList];
    system.debug(agentReportNeedToDelete);

    List<Database.DeleteResult> deletedList = Database.delete(agentReportNeedToDelete);
    for(Database.DeleteResult dr : deletedList) {
    	if (dr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
        	System.debug('Successfully deleted account with ID: ' + dr.getId());
        }else {
        	      // Operation failed, so get all errors               
            for(Database.Error err : dr.getErrors()) {
                    System.debug('The following error has occurred.');                   
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
        }

    }
    
}