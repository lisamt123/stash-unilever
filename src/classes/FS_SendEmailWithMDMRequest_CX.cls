/**********************************************************************
Name: FS_SendEmailWithMDMRequest_CX()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
-------Controller used for sending the MDM request with attachments (PDF and Excel)
======================================================
======================================================
History
-------
VERSION AUTHOR         DATE         DETAIL                  Description
1.0     Accenture      22/08/2016   INITIAL DEVELOPMENT     CSR: FS-501
***********************************************************************/
public with sharing class FS_SendEmailWithMDMRequest_CX{
    
    
    private Id opportunityId;
    public final static FS_MDMEmailRequestDefaultValue__c MDMDefaultValue = FS_MDMEmailRequestDefaultValue__c.getOrgDefaults();
    
    private static final String SystemAdmin = 'System Administrator';
    private static final String RoleUFSRussia = 'UFS Russia';
    //Holds the System Administrator profile id
    private static final Id SYS_ADMIN_PROFILE_ID = [SELECT ProfileId FROM User WHERE Profile.Name = :SystemAdmin Limit 1].ProfileId;
    public boolean sendButton{get; set;}
    
        /*******************************************************************
        Purpose: Constructor
        Parameters: 
        Returns: N/A
        Throws [Exceptions]: N/A
        ********************************************************************/
    public FS_SendEmailWithMDMRequest_CX(ApexPages.StandardController stdController){
         opportunityId = stdController.getId();
         emailSubject = null;
         emailBody=null;       
    }
    
    /*******************************************************************
    Purpose: Variable for opportunity record 
    Parameters: N/A
    Returns: N/A
    Throws [Exceptions]: N/A
    ********************************************************************/
    public Opportunity opportunityRecord{
            get{ 
                if(opportunityRecord == null){
                    try{
                            opportunityRecord = [SELECT Id,
                                                    Owner.Email,
                                                    FS_MDMRequestSent__c,
                                                    FS_TPRApproved__c 
                                                 FROM Opportunity
                                                 WHERE Id=:opportunityId
                                                 LIMIT 1];
                    }catch(Exception e){
                           ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'FS_GenerateMDMRequest_CX', 'opportunityRecord', e.getMessage(), e, null, null, null, 0,'Food Solution');
                        }
                 }    
                 return opportunityRecord;
            }
            set;
    }
    
    /*******************************************************************
    Purpose: Action method called from vfpage that will serve as a validation
                                            for the opportunity action.
    Parameters: None
    Returns: N/A
    Throws [Exceptions]: N/A
    ********************************************************************/
    public void identifyAction(){
        FS_MDMRequestPageMessages__c mdmPageMessages = FS_MDMRequestPageMessages__c.getOrgDefaults();
        sendButton = false;
        try{    
            if (!opportunityRecord.FS_TPRApproved__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, mdmPageMessages.FS_NotApprovedMessage__c));
            }else if (opportunityRecord.FS_MDMRequestSent__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, mdmPageMessages.FS_AlreadySentMessage__c));
            }else {
                        UserRole uRole = [SELECT Id, Name  
                                            FROM UserRole 
                                            WHERE Id = :UserInfo.getUserRoleId() Limit 1];
                        if (uRole.Name.equalsIgnoreCase(RoleUFSRussia) || UserInfo.getProfileId().equals(SYS_ADMIN_PROFILE_ID) ){
                                sendButton = true;
                        }else{
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, mdmPageMessages.FS_NoAccessMessage__c));
                        }
                    }
        }catch(DmlException e){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'FS_GenerateMDMRequest_CX', 'identifyAction', e.getMessage(), e, null, null, null, 0,'Food Solution');
        }
    }
    
    /*******************************************************************
    Purpose: Get method for MDMDefaultValue
    Parameters: 
    Returns: N/A
    Throws [Exceptions]: N/A
    ********************************************************************/
    public FS_MDMEmailRequestDefaultValue__c getMDMDefaultValue(){
        system.debug('MDMDefaultValue --------->'+MDMDefaultValue);
        return MDMDefaultValue;
    }
    
    /*******************************************************************
    Purpose: Variable for email Subject 
    Parameters: N/A
    Returns: N/A
    Throws [Exceptions]: N/A
    ********************************************************************/
    public String emailSubject{
        get{ if(emailSubject == null){
                emailSubject = MDMDefaultValue.FS_EmailSubject__c;
            }
            return emailSubject;
        }
        set;
    }
    
    /*******************************************************************
    Purpose: Variable for email Body 
    Parameters: N/A
    Returns: N/A
    Throws [Exceptions]: N/A
    ********************************************************************/
    public String emailBody{
        get{
            if (emailBody == null){
                emailBody = MDMDefaultValue.FS_EmailBody__c;
            }
            return emailBody;
        }
        set;
    }
    
    /*******************************************************************
    Purpose: Method that will send the email with attachment 
    Parameters: 
    Returns: PageReference opportunityPage
    Throws [Exceptions]: N/A
    ********************************************************************/
     public PageReference sendEmailAttachment(){
        
        PageReference opportunityPage = null;

        FS_MDMRequestRecipient__c emailRecipients = FS_MDMRequestRecipient__c.getOrgDefaults(); //Hold the email recipients from custom setting
        List<String> emailRecipientList = new List<String>();   //Holds the list of email recipient
        
        PageReference pdfPage = Page.FS_GenerateMDMRequest;
        pdfPage.setRedirect(True);
        pdfPage.getParameters().put('id',opportunityId);

        blob pdfFile = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pdfPage.getContent();
        
        //Construct the pdf file as attachment
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        
        attach.setBody(pdfFile);
        attach.setFileName(MDMDefaultValue.FS_AttachmentFileName__c);
        
        PageReference excelPage = Page.FS_GenerateMDMRequestExcel;
        excelPage.setRedirect(True);
        excelPage.getParameters().put('id',opportunityId);

        blob excelFile = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : excelPage.getcontent();

        //Construct the excel file as attachment
        Messaging.EmailFileAttachment attachExcel = new Messaging.EmailFileAttachment();
        
        attachExcel.setBody(excelFile);
        attachExcel.setFileName(MDMDefaultValue.FS_ExcelAttachmentFileName__c);
        
        for(FS_MDMRequestRecipient__c emailRecipient : FS_MDMRequestRecipient__c.getAll().values()){
            emailRecipientList.add(emailRecipient.FS_emailaddress__c);
        }
        //Retrieve list of email recipient
        emailRecipientList.add(opportunityRecord.Owner.Email); //Add the Opportunity Owner's Email address
        
        //Email Creation
        Messaging.singleEmailMessage emailWithAttach = new Messaging.singleEmailMessage();
        emailWithAttach.setToaddresses(emailRecipientList);
        emailWithAttach.setSubject(emailSubject);
        emailWithAttach.setPlainTextBody(emailBody);
        
        //Attach the excel in the email to be sent
        emailWithAttach.setFileAttachments(new Messaging.EmailFileAttachment[]{attach, attachExcel});
        
        // Sends the email
        if(!Test.isRunningTest()){
        	Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailWithAttach});
        	}
        opportunityRecord.FS_MDMRequestSent__c = true;
        try {
                //tag opportunity as MDM request email sent
            update opportunityRecord;   
            system.assertEquals(opportunityRecord.FS_MDMRequestSent__c,true);
            
            //redirect the page to opportunity page
            opportunityPage = returnToOpportunity();
                       
        }catch(DmlException e){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'FS_SendEmailWithMDMRequest_CX', 'sendEmailAttachment', e.getMessage(), e, null, null, null, 0,'Food Solution');
        }
        
        return opportunityPage;
     }
     
    /*******************************************************************
    Purpose: Method for command button to navigate to opportunity detail view.
    Parameters: None
    Returns: PageReference opportunityPage
    Throws [Exceptions]: N/A
    ********************************************************************/
     public PageReference returnToOpportunity(){
        // Send the user to the detail page of opportunity.
        PageReference opportunityPage = null;
        try{
            opportunityPage = new ApexPages.StandardController(opportunityRecord).view();
            opportunityPage.setRedirect(true);
        }catch(Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'FS_SendEmailWithMDMRequest_CX', 'returnToOpportunity', ex.getMessage(), ex, null, null, null, 0,'Food Solution');
        }
        return opportunityPage;
     }
     
}