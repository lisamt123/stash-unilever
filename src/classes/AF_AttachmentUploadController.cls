/** Created By :Pratyusha Penugondla 
This class is to upload a document and associate it to the parent record
**/

Public with sharing class AF_AttachmentUploadController{
// Declaration of getters and setters 

public boolean UploadDocument{get;set;}
public boolean CloseButton{get;set;}
public List<AF_OOPS_Actual__c> oopsRecord{get;set;}
public List<AF_OOPS_Actual__c> oopsUpdateRecord{get;set;}
public List<SelectOption> CtTypes{get;set;}

public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
      return attachment;
    }
  set;
  }
String Pid=ApexPages.currentPage().getParameters().get('parentId');
String quarter = ApexPages.currentPage().getParameters().get('quarter');
//system.debug('quarter....'+quarter);
//Constructor
public AF_AttachmentUploadController()
{
CtTypes = new List<SelectOption>();
UploadDocument=true;
CloseButton=false;
CtTypes.add(new SelectOption('SOW','Scope Of Work'));
CtTypes.add(new SelectOption('Fee Template Summary','Fee Template Summary'));
if(quarter != null) {
    for(String eachQuarter : AF_ApproveActualsCtrl.docQuarterMap.keySet()) {
        if(eachQuarter == quarter) {
            CtTypes.add(new SelectOption(AF_ApproveActualsCtrl.docQuarterMap.get(eachQuarter),AF_ApproveActualsCtrl.docQuarterMap.get(eachQuarter)));   
        }
    }
}else {
    for(String eachQuarter : AF_ApproveActualsCtrl.docQuarterMap.keySet()) {
        CtTypes.add(new SelectOption(AF_ApproveActualsCtrl.docQuarterMap.get(eachQuarter),AF_ApproveActualsCtrl.docQuarterMap.get(eachQuarter)));   
    }
}
CtTypes.add(new SelectOption('Other Documents','Other'));
}

/**** This method will be called on click of Upload Document and it try to 
save the attachment to the corresponding parent and will throw the respective 
page mesages, we will store the type value on the page to ContentType field ****/

public PageReference UploadFile()
{  
  
oopsRecord = new List<AF_OOPS_Actual__c>();
oopsUpdateRecord = new List<AF_OOPS_Actual__c>();
system.debug('inside upload file');
   if(attachment.ContentType=='')
   {
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Type is mandatory,Please Select Type'));
   }
   else if(attachment.description=='')
   {
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Add Comments is mandatory,Please Enter Description'));
   }
   else
   {
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = Pid; // specify the record Id to which the attachment is to.
        attachment.IsPrivate = false;
        
        if(Pid.startsWith(System.Label.AF_oopsActualId)){
        system.debug('quarter....'+quarter);
            oopsRecord = [SELECT Name, Quarter__c, AF_Status_Q1__c, AF_Status_Q2__c, AF_Status_Q3__c, AF_Status_Q4__c,
                                AF_Q1__c, AF_Q2__c, AF_Q3__c, AF_Q4__c,AF_Status__c,AF_Cat_Finance_Action_Q1__c,AF_Cat_Finance_Action_Q2__c,
                                AF_Cat_Finance_Action_Q3__c,AF_Cat_Finance_Action_Q4__c,AF_Agency_Action_Q1__c,AF_Agency_Action_Q2__c,AF_Agency_Action_Q3__c,AF_Agency_Action_Q4__c 
                                FROM AF_OOPS_Actual__c where id=:Pid];
            if(oopsRecord.size()>0){
                
                    if(quarter=='Q1'){
                    
                    oopsRecord[0].AF_Q1_Backup__c = true;
                    oopsUpdateRecord.add(oopsRecord[0]);
                    }
                    else if(quarter=='Q2'){
                    oopsRecord[0].AF_Q2_Backup__c = true;
                    oopsUpdateRecord.add(oopsRecord[0]);
                    }
                    else if(quarter=='Q3'){
                    oopsRecord[0].AF_Q3_Backup__c = true;
                    oopsUpdateRecord.add(oopsRecord[0]);
                    }
                    else if(quarter=='Q4'){
                   oopsRecord[0].AF_Q4_Backup__c = true;
                    oopsUpdateRecord.add(oopsRecord[0]);
                    }
                
                if(oopsUpdateRecord.size()>0){
                    update oopsUpdateRecord;
                }
            }
        }
    
    try 
    {
      insert attachment;
      UploadDocument=false;
      CloseButton=true;
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'The document has been successfully uploaded'));
    } 
    
    catch (Exception e) 
    {
    
    // As of now we are able to upload all kind of attachments whoes size is below 5 10mb , will be update the code if we are
    // not able to upload any kind of files like .htm etc.,
      String str = e.getMessage();
      system.debug('Print the error'+str);
      if(str.contains('REQUIRED_FIELD_MISSING'))
      {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please attach a file and then try to upload'));
      }
      
    } 
    
    finally 
    {
      attachment = new Attachment(); 
    }
        
       
        
  }//end of else
  //PageReference pg =  new PageReference('/apex/AF_UploadAnAttachment?parentId='+Pid);
 // pg.setredirect(true);
//  return pg;
return null;
}//end of the method



 

}