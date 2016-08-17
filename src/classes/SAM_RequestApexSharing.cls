/**********************************************************************
Name: SAM_JobApexSharing()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This class is for shring Request record with created by uesr
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
1.0      Pooja Kanani   03/08/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public without sharing class SAM_RequestApexSharing {
    
    /*******************************************************************
    Purpose: This method is shring Request record with created by uesr
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
	public static void RequestApexSharing(List<SAM_Request__c> ReqList){  
        // Create a new list of sharing objects for Job
        List<SAM_Request__Share> jobShrs  = new List<SAM_Request__Share>();
        
        // Declare variables for recruiting and hiring manager sharing
        SAM_Request__Share recruiterShr;
        
        for(SAM_Request__c job : ReqList){
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
        Database.insert(jobShrs,false);
                 
    }
}