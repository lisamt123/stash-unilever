/*Class : im_IssueCreationDialogueController
 Author : Sachin Chincholi Date:25/09/2013 Version:1.0
Purpose : On Click of the Submit for Approval, on the Issue detail Page,
should convert the Status of the Issue_Status__c in the record to Submitted and also copy the 
data in Issue_Severity__c to Issue_Severity_on_submission__c and update the record */

/* Ben Edwards - Added sharing to ensure record creator always has read access to the record */

global class im_IssueCreationDialogueController{
 
    // This variable to hold the currently queried issue.
    public  static im_Issue__c iss {get;set;}
    
    //Constructor, as it is also used as an extension to im_issueCreationDialogue Page,Thus to be included.
    public im_IssueCreationDialogueController(ApexPages.StandardController controller) {
        
    } 
    // This is a method called on a button click using Javascript
    webService static String updateIssueFields(Id issueid) {
        //Variable to return the success/error on javascript alert to test.
        String results;
        try{
            iss =[SELECT id,name,Issue_Status__c,Issue_Severity__c,Issue_Severity_on_submission__c, createdbyid from im_Issue__c where id=:issueid];
            system.debug('###Before Updating'+iss);
            iss.Issue_Status__c = 'Submitted';
            iss.Issue_Severity_on_submission__c = iss.Issue_Severity__c;
            update iss;
            system.debug('###After Updating'+iss);
            results = 'Issue Updated'; 
            
            return results;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            results = e.getMessage();
            return results;
        }
    }
    
}