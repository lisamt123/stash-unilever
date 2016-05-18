global class VPM_PurchaseRequestsControllerExtension {
    public String vendorReqId {get; set;}
    public String usrRole {get; set;}
    public boolean RenderSAPBtn {get; set;}
    public boolean ManuallyMarkasCompletebtn  {get; set;}
    public boolean ReworkBtn  {get; set;}
    public boolean enableSendToSAPBtn {get; set;}
    public String venReqStatus {get; set;}
    public string callJavaScriptAlert{get;set;}
    public string recId{get;set;}
    public boolean ManuallyMarkAsCompleteFlag {get;set;}

    
    public VPM_PurchaseRequestsControllerExtension (ApexPages.StandardController stdController) {
        recId = stdController.getRecord().Id;
        // callJavaScriptAlert='<script> func(); </script>';
        venReqStatus = fetchRecordStatus(recId);
        System.debug('-------inside constructor of extn-------'+stdController.getRecord().Id + '  ' + venReqStatus);
        if(String.isNotBlank(venReqStatus) && (venReqStatus.equalsIgnoreCase('MDM Ops Review') || 
                                            venReqStatus.equalsIgnoreCase('MDM Ops Review - SAP BPM submit Failed'))){
                                                enableSendToSAPBtn = true;
                                            } else {
                                                enableSendToSAPBtn = false;  
                                            }
        
        usrRole = checkLoggedInUserRole();
        EnableManuallyMarkAsCompleteBtn();
        if(usrRole == 'MDM') {
            RenderSAPBtn = true;
            ManuallyMarkasCompletebtn= true;
        }
        else if(usrRole == 'Procurement' || usrRole ==  'Finance' || usrRole ==  'FLS') {
            ReworkBtn=true;
        }
        vendorReqId = stdController.getRecord().Id;
    }
    
    public PageReference callCreateVendorAPI() {
        System.debug('-----id of vendor request record is-----'+vendorReqId);
        VPM_CreateVendorServiceHelper.createVendor(vendorReqId);
        return new PageReference('/' + vendorReqId);
    }
    
    @RemoteAction
    global static map<string,string> checkForBusinessReqUser() {
        
        boolean brUser = false;
         String userRole;
        // List<PermissionSetAssignment> lstcurrentUserPerSet= new  List<PermissionSetAssignment>();
        List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.Label, AssigneeId
                                                              FROM PermissionSetAssignment
                                                              WHERE AssigneeId = :Userinfo.getUserId() order by PermissionSet.Label DESC];
        //System.Debug('----list of permission sets assigned to logged in user------' + lstcurrentUserPerSet);
        
       // for (PermissionSetAssignment psa: lstcurrentUserPerSet) {
           // system.debug('---------psa.PermissionSet.Label---------' + psa.PermissionSet.Label);
            if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('FLS')) {
                brUser = false;
                 userRole = 'FLS';
                //return brUser;
            } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('MDM')) {
                brUser = false;
                  userRole = 'MDM';
               // return brUser;
            } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Finance')) {
                brUser = false;
                userRole = 'FIN';
               // return brUser;
            } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Procurement')) {
                brUser = false;
                userRole = 'PRO';
                //return brUser;
            } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Business Requestor')) {
                brUser = true;
                 userRole = 'BUR';
               // System.debug('----is user brUser----'+brUser);
                //return brUser;
            }
       // }
        map<string,string> returnResult = new map<string,string>{'brUser'=>brUser==true?'true':'false','userRole'=>userRole};
        return returnResult;
    }
    
    @RemoteAction
    global static String checkLoggedInUserRole() {
        
        String userRole;
        // List<PermissionSetAssignment> lstcurrentUserPerSet= new  List<PermissionSetAssignment>();
        List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.Label, AssigneeId
                                                              FROM PermissionSetAssignment
                                                              WHERE AssigneeId = :Userinfo.getUserId() order by PermissionSet.Label DESC];
        //System.Debug('----list of permission sets assigned to logged in user------' + lstcurrentUserPerSet);
        
        for (PermissionSetAssignment psa: lstcurrentUserPerSet) {
            system.debug('---------psa.PermissionSet.Label---------' + psa.PermissionSet.Label);
            if(psa.PermissionSet.Label.contains('FLS')) {
                userRole = 'FLS';
                return userRole;
            } else if(psa.PermissionSet.Label.contains('MDM')) {
                userRole = 'MDM';
                return userRole;
            } else if(psa.PermissionSet.Label.contains('Finance')) {
                userRole = 'FIN';
                return userRole;
            } else if(psa.PermissionSet.Label.contains('Procurement')) {
                userRole = 'PRO';
                return userRole;
            } else if(psa.PermissionSet.Label.contains('Business Requestor')) {
                userRole = 'BUR';
                return 'BUR';
            }
        }
        return userRole;
    }
    
    public String fetchRecordStatus(String recId) {
        String reqStatus;
        List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_Status__c FROM VPM_PurchasingRequests__c WHERE
                                                      Id = :recId LIMIT 1];        
        if(vendorList != null && vendorList.size() >0) {
            reqStatus = vendorList.get(0).VPM_Status__c;
        }
        return reqStatus;
    }
    
    public void ManuallyMarkAsCompleteAction(){
        //PageReference congratsPage = null; 
        List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_Status__c,OwnerId, CreatedById, VPM_DeletionBlockFlag__c FROM VPM_PurchasingRequests__c WHERE
                                                      Id = :recId LIMIT 1];
        list<PermissionSetAssignment> permissionAssigned =[SELECT Assignee.Name, PermissionSet.Name ,id FROM PermissionSetAssignment
                                                          WHERE AssigneeId =:recId AND PermissionSet.Name ='VPM_MDM_Ops' limit 1];
        if(vendorList[0].VPM_Status__c.contains('Block') || vendorList[0].VPM_Status__c.contains('Unblock')
           || vendorList[0].VPM_Status__c.contains('Delete') || vendorList[0].VPM_Status__c.contains('Undelete')) {
            vendorList[0].VPM_Status__c = 'Request Completed';
            vendorList[0].OwnerId = vendorList[0].CreatedById;
             vendorList[0].VPM_DeletionBlockFlag__c=null;
            update vendorList;
               callJavaScriptAlert='<script> PageReload(); </script>';
              //congratsPage =  new PageReference('/' + recID);
              
          
        }
        else
            callJavaScriptAlert='<script> func(); </script>';
        
        //system.debug('@@congratsPage' + congratsPage);
       // return congratsPage;
    }

    public void EnableManuallyMarkAsCompleteBtn(){
        try
        {
            list<VPM_PurchasingRequests__c> vendorList = [SELECT RecordTypeId from VPM_PurchasingRequests__c where id=:recId limit 1];
            list<RecordType> RecordTypeList =[SELECT Name from RecordType where id=:vendorList[0].RecordTypeId limit 1];
            if(RecordTypeList[0].Name.contains('(Create)'))
            {
                ManuallyMarkAsCompleteFlag =false;
            }
            else
                 ManuallyMarkAsCompleteFlag =true;
        }
        catch(exception ex){}
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