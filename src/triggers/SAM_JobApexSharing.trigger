trigger SAM_JobApexSharing on SAM_Request__c (after insert) {
    
    if(trigger.isInsert){
        // Create a new list of sharing objects for Job
        List<SAM_Request__Share> jobShrs  = new List<SAM_Request__Share>();
        
        // Declare variables for recruiting and hiring manager sharing
        SAM_Request__Share recruiterShr;
        
        for(SAM_Request__c job : trigger.new){
            // Instantiate the sharing objects
            recruiterShr = new SAM_Request__Share();
            
            // Set the ID of record being shared
            recruiterShr.ParentId = job.Id;
            
            // Set the ID of user or group being granted access
            recruiterShr.UserOrGroupId = job.createdbyid;
            
            // Set the access level
            recruiterShr.AccessLevel = 'read';
            
            // Set the Apex sharing reason for hiring manager and recruiter
            recruiterShr.RowCause = Schema.SAM_Request__Share.RowCause.SAM_creator__c;
            
            // Add objects to list for insert
            jobShrs.add(recruiterShr);
        }
        
        // Insert sharing records and capture save result 
        // The false parameter allows for partial processing if multiple records are passed 
        // into the operation 
        Database.SaveResult[] lsr = Database.insert(jobShrs,false);
        
        // Create counter
        Integer i=0;
        
        // Process the save results
        for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                // Get the first save result error
                Database.Error err = sr.getErrors()[0];
                
                // Check if the error is related to a trivial access level
                // Access levels equal or more permissive than the object's default 
                // access level are not allowed. 
                // These sharing records are not required and thus an insert exception is 
                // acceptable. 
                if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                                               &&  err.getMessage().contains('AccessLevel'))){
                    // Throw an error when the error is not related to trivial access level.
                    trigger.newMap.get(jobShrs[i].ParentId).
                      addError(
                       'Unable to grant sharing access due to following exception: '
                       + err.getMessage());
                }
            }
            i++;
        }   
    }
    
}