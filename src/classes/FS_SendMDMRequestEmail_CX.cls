/**********************************************************************
Name: FS_SendMDMRequestEmail_CX()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
-------Use as controller for sending MDM request email
======================================================
======================================================
History
-------
VERSION AUTHOR         DATE         DETAIL                  Description
1.0     Accenture      20/07/2016   INITIAL DEVELOPMENT     CSR: FS-501
***********************************************************************/
public with sharing class FS_SendMDMRequestEmail_CX{
    
    private Opportunity opportunityRecord;
    private Id opportunityId;
    
    private static final FS_MDMEmailRequestDefaultValue__c MDMDefaultValue = FS_MDMEmailRequestDefaultValue__c.getOrgDefaults(); //Holds the attachment's default values
        
    private static final String SystemAdmin = 'System Administrator';
    private static final String RoleUFSRussia = 'UFS Russia';
    private static final String StepStatusStarted = 'Started';
    
    //Holds the System Administrator profile id
    private static final Id SYS_ADMIN_PROFILE_ID = [SELECT ProfileId FROM User WHERE Profile.Name = :SystemAdmin Limit 1].ProfileId;

    /*******************************************************************
	Purpose: Constructor method
	Parameters: ApexPages.StandardController
	Returns: N/A
	Throws [Exceptions]: N/A
	********************************************************************/
    public FS_SendMDMRequestEmail_CX(ApexPages.StandardController stdController) {
            opportunityId = stdController.getId();
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
    	String attachmentBody = null;
    	
    	try{
    	    opportunityRecord =[SELECT Id,
                                    FS_startDateTPR__c,
                                    FS_endDateTPR__c,
                                    FS_internalOrder__c,
                                    Owner.Email,
                                    FS_TPRApproved__c,
                                    FS_MDMRequestSent__c
                                FROM Opportunity
                                WHERE Id=:opportunityId 
                                LIMIT 1];
    	
            if (!opportunityRecord.FS_TPRApproved__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, mdmPageMessages.FS_NotApprovedMessage__c));
            }else if (opportunityRecord.FS_MDMRequestSent__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, mdmPageMessages.FS_AlreadySentMessage__c));
            }else {
                        UserRole uRole = [SELECT Id, Name  
                                            FROM UserRole 
                                            WHERE Id = :UserInfo.getUserRoleId() Limit 1];
                        if (uRole.Name.equalsIgnoreCase(RoleUFSRussia) || UserInfo.getProfileId().equals(SYS_ADMIN_PROFILE_ID) ){
                            attachmentBody = createExcelAttachment();  //format the string for excel attachment
       						sendExcelAttachment(attachmentBody, String.Valueof(opportunityRecord.Owner.Email));    //Call Send Email    
       						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, mdmPageMessages.FS_SuccessfullySentMessage__c));                          
                        }else{
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, mdmPageMessages.FS_NoAccessMessage__c));
                        }
                    }
    	}catch(DmlException e){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'FS_SendMDMRequestEmail_CX', 'identifyAction', e.getMessage(), e, null, null, null, 0,'Food Solution');
    	}
    }
            
    /*******************************************************************
	Purpose: Method that will format the attachment from a string
	Parameters: None
	Returns: finalAttachmentBody (String)
	Throws [Exceptions]: N/A
	********************************************************************/
    public String createExcelAttachment(){        
        String finalAttachmentBody = null; //will be used for the attachment body
        FS_MDMEmailRequestTemplate__c mdmHeader = FS_MDMEmailRequestTemplate__c.getOrgDefaults(); //Used Custom Settings for the table header values on attachment
        try{
        //Retrieve the latest date when approval has been submitted
        ProcessInstanceStep pis = [SELECT CreatedDate
                                    FROM ProcessInstanceStep
                                    WHERE StepStatus = :StepStatusStarted
                                    AND ProcessInstance.TargetObjectId = :opportunityRecord.Id
                                    ORDER By CreatedDate Desc Limit 1];
        
        //Compose the upper part of the attachment before the table format of the attachment
        finalAttachmentBody = mdmDefaultValue.FS_CompanyName__c + '\n' 
                            + mdmDefaultValue.FS_CompanyAddress__c + '\n' 
                            + mdmDefaultValue.FS_CompanyPhoneText__c + mdmDefaultValue.FS_CompanyPhone__c + '\t' 
                            + mdmDefaultValue.FS_CompanyFaxText__c + mdmDefaultValue.FS_CompanyFax__c + '\n \n \n \n \n' 
                            + pis.CreatedDate + '\t \t \t \t \t \t \t \t' 
                            + mdmDefaultValue.FS_CompanyCity__c + '\n \n \n \n \n' 
                            + mdmDefaultValue.FS_Title__c + '\n \n \n';
        
        //Compose the Header of the Opportunity table format
        finalAttachmentBody = finalAttachmentBody
                                + mdmHeader.FS_TargetOfDiscount__c + '\t' 
                                + mdmHeader.FS_ConditionType__c + '\t' 
                                + mdmHeader.FS_SalesOrganisation__c + '\t' 
                                + mdmHeader.FS_ValidityStart__c + '\t' 
                                + mdmHeader.FS_ValidityEnd__c + '\t' 
                                + mdmHeader.FS_InternalOrder__c + '\n 1 \t 2 \t 3 \t 4 \t 5 \t 6 \n';
        
        //Compose the Values of the Opportunity table format 
        finalAttachmentBody = finalAttachmentBody
                            + mdmDefaultValue.FS_TargetOfDiscountValue__c + '\t'
                            + mdmDefaultValue.FS_ConditionTypeValue__c + '\t' 
                            + mdmDefaultValue.FS_SalesOrganisation__c + '\t'
                            + opportunityRecord.FS_startDateTPR__c + '\t' 
                            + opportunityRecord.FS_endDateTPR__c + '\t' 
                            + opportunityRecord.FS_internalOrder__c + '\n \n';


        //Compose the Opportunity Line Item Header table format
        finalAttachmentBody =  finalAttachmentBody
                                    + mdmHeader.FS_HierarchyLevel__c
                                    + '\t' + mdmHeader.FS_CustomerCode__c
                                    + '\t' + mdmHeader.FS_CustomerCodeDescription__c
                                    + '\t' + mdmHeader.FS_ProductHierarchy__c
                                    + '\t' + mdmHeader.FS_MaterialCode__c
                                    + '\t' + mdmHeader.FS_MaterialDescription__c
                                    + '\t' + mdmHeader.FS_ProductExpirationDate__c
                                    + '\t' + mdmHeader.FS_Amount__c
                                    + '\t' + mdmHeader.FS_Unit__c + '\n 7 \t 8 \t 9 \t 10 \t 11 \t 12 \t 13 \t 14 \t 15 \n';
    
       //get the set of product ids for opportunity line item
       Map<Id, Product2> product2Map = new Map<Id, Product2>([SELECT Name
                                                                FROM Product2
                                                                WHERE Id IN (
                                                                	SELECT Product2Id
							                                    	FROM OpportunityLineItem
							                                    	WHERE OpportunityId = :opportunityRecord.Id
                                                                )]);
       
       //Compose the Values of the Opportunity Line Item table format
       for(OpportunityLineItem oli:[SELECT id,
                                        FS_totalTPRPercentage__c,
                                        ProductCode,
                                        Product2Id
                                    FROM OpportunityLineItem
                                    WHERE OpportunityId = :opportunityRecord.Id]){
            
                finalAttachmentBody = finalAttachmentBody                            
                                    + '7 \t 8 \t 9 \t \t'
                                    + oli.ProductCode +'\t'
                                    + product2Map.get(oli.Product2Id).Name +'\t \t'
                                    + oli.FS_totalTPRPercentage__c +'\t % \n';                          
       }
       
       //Compose the bottom part of the attachment after the table format
       finalAttachmentBody = finalAttachmentBody + '\n '
                                    + mdmDefaultValue.FS_CompanyNote__c + '\n \n \n'
                                    + mdmDefaultValue.FS_CaptionText__c + '\n \n'
                                    + mdmDefaultValue.FS_ApprovedByText__c + '\t \t \t \t' 
                                    + mdmDefaultValue.FS_SalesManagerName__c + '\t'
                                    + mdmDefaultValue.FS_SalesManagerPosition__c + '\n \t \t \t'
                                    + mdmDefaultValue.FS_SignatureText__c + '\t'
                                    + mdmDefaultValue.FS_NameText__c + '\t'
                                    + mdmDefaultValue.FS_PositionText__c +'\n \n \t \t \t \t'
                                    + mdmDefaultValue.FS_FinanceManagerName__c + '\t'
                                    + mdmDefaultValue.FS_FinanceManagerPosition__c + '\n \t \t \t'
                                    + mdmDefaultValue.FS_SignatureText__c + '\t'
                                    + mdmDefaultValue.FS_NameText__c + '\t'
                                    + mdmDefaultValue.FS_PositionText__c;
        } catch(Exception ex){
 			     ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'FS_SendMDMRequestEmail_CX', 'createExcelAttachment', ex.getMessage(), ex, null, null, null, 0,'Food Solution');  
        }
       return finalAttachmentBody;     
    }
    
     
    /*******************************************************************
	Purpose: Method that will send the email with attachment 
	Parameters: 
				String finalAttachmentBody
				String ownerEmail
	Returns: N/A
	Throws [Exceptions]: N/A
	********************************************************************/
     public void sendExcelAttachment(String finalAttachmentBody, String ownerEmail){

     	FS_MDMRequestRecipient__c emailRecipients = FS_MDMRequestRecipient__c.getOrgDefaults(); //Hold the email recipients from custom setting
        List<String> emailRecipientList = new List<String>(); 	//Holds the list of email recipient
        
        //Construct the excel file as attachment
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        blob excel = blob.valueOf(finalAttachmentBody);          
        attach.setBody(excel);
        attach.setFileName(MDMDefaultValue.FS_AttachmentFileName__c);
        
        
        for(FS_MDMRequestRecipient__c emailRecipient : FS_MDMRequestRecipient__c.getAll().values()){
            emailRecipientList.add(emailRecipient.FS_emailaddress__c);
        }
        //Retrieve list of email recipient
        emailRecipientList.add(ownerEmail); //Add the Opportunity Owner's Email address
        
        //Email Creation
        Messaging.singleEmailMessage emailWithAttach = new Messaging.singleEmailMessage();
        emailWithAttach.setToaddresses(emailRecipientList);
        emailWithAttach.setSubject(MDMDefaultValue.FS_EmailSubject__c);
        emailWithAttach.setPlainTextBody(MDMDefaultValue.FS_EmailBody__c);
        
        //Attach the excel in the email to be sent
        emailWithAttach.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
        
        // Sends the email
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailWithAttach});
        
        opportunityRecord.FS_MDMRequestSent__c = true;
        try {
	        update opportunityRecord;   //tag opportunity as MDM request email sent
	        system.assertEquals(opportunityRecord.FS_MDMRequestSent__c,true);	        
        }catch(DmlException e){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'FS_SendMDMRequestEmail_CX', 'sendExcelAttachment', e.getMessage(), e, null, null, null, 0,'Food Solution');
    	}
     }
     
     
    /*******************************************************************
	Purpose: Method for command button to navigate to opportunity detail view.
	Parameters: None
	Returns: N/A
	Throws [Exceptions]: N/A
	********************************************************************/
     public PageReference returnToOpportunity(){
        // Send the user to the detail page of opportunity.
        PageReference opportunityPage = null;
        try{
        	opportunityPage = new ApexPages.StandardController(opportunityRecord).view();
        	opportunityPage.setRedirect(true);
        }catch(Exception ex) {
        	ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'FS_SendMDMRequestEmail_CX', 'returnToOpportunity', ex.getMessage(), ex, null, null, null, 0,'Food Solution');
        }
        return opportunityPage;
     }
     
}