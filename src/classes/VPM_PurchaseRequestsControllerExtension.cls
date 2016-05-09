public class VPM_PurchaseRequestsControllerExtension {
    public boolean flsInCountryFlag{get; set;}
    
    public VPM_PurchaseRequestsControllerExtension (ApexPages.StandardController stdController) {
        System.debug('-------inside constructor of extn-------'+stdController.getRecord().Id);
        System.debug('-------value of flag passed is-------'+flsInCountryFlag);
    }
    
    /*public Attachment attachment {
        get {
            if (attachment == null) {
                System.debug('-----created object of Attachment----');
                attachment = new Attachment();
            }
            return attachment;
        }
        set;
    }
    
    public PageReference upload() {
        
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = 'a0X19000001GxlD'; // the record the file is attached to
        attachment.IsPrivate = true;
        
        try {
            insert attachment;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            return null;
        } finally {
            attachment = new Attachment(); 
        }
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        return null;
    }
    
    public Flow.Interview.VPM_PurchasingRequestAdvancedForm myflow { get; set; }
public String purReqNewId {get; set;}*/
    
    // Empty constructor, to allow use as a controller extension
    /*public VPM_PurchaseRequestsControllerExtension (ApexPages.StandardController stdController) { 
if(myflow != null) {
System.debug('-------inside constructor of extn-------' + myflow.VPM_PurchasingRequestID);
purReqNewId = myflow.VPM_PurchasingRequestID;
}        
}*/
    
    // Flow support methods
    /*public String getInterviews() { return null; }

public String showList { get; set; }

public String getPurReqRecordId() {
// Access flow variables as simple member variables with get/set methods
if(myflow == null) {
purReqNewId ='Could not get record id';
return 'Could not get record id';
} else {        
purReqNewId =myflow.VPM_PurchasingRequestID;
return myflow.VPM_PurchasingRequestID;
}
}

public String getPausedId() {
String currentUser = UserInfo.getUserId();
List<FlowInterview> interviews = 
[SELECT Id FROM FlowInterview WHERE CreatedById = :currentUser AND InterviewLabel LIKE '%Purchasing%'];

if (interviews == null || interviews.isEmpty()) {
return null; // early out
}

// Return the ID for the first interview in the list
return interviews.get(0).Id;
}
}*/
}