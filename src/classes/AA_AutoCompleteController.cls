public class AA_AutoCompleteController {
/**
     * Aura enabled method to search a specified SObject for a specific string
     */
    @AuraEnabled
    public static Result[] lookup(String searchString, String sObjectAPIName, String recordType)
    {
        // Sanitize the input
        String sanitizedSearchString = String.escapeSingleQuotes(searchString);
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);
        String sanitizedSObjectFieldName = String.escapeSingleQuotes(recordType);
        String searchQuery='';
        
        system.debug('Recieved Search value is==> '+sanitizedSearchString);
        List<Result> results = new List<Result>();
 		
         // Build our SOSL query
        if(sanitizedSObjectFieldName == 'null' )
        {
            searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name) Limit 50'; 
        }
        else {
             searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name where RecordType.Name=\''+ sanitizedSObjectFieldName +'\' ) Limit 50'; 
        }
       
 
        // Execute the Query
        List<List<SObject>> searchList = search.query(searchQuery);
 
        // Create a list of matches to return
        for (SObject so : searchList[0])
        {
            results.add(new Result((String)so.get('Name'), so.Id));
        }
         
        return results;
    }
     
    /**
     * Inner class to wrap up an SObject Label and its Id
     */
    public class Result
    {
        @AuraEnabled public String SObjectLabel {get; set;}
        @AuraEnabled public Id SObjectId {get; set;}
         
        public Result(String sObjectLabel, Id sObjectId)
        {
            this.SObjectLabel = sObjectLabel;
            this.SObjectId = sObjectId;
        }
    }
    
}