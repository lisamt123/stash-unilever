/**********************************************************************
Name: FS_SendMDMRequestEmail_CE()
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
public with sharing class FS_SendMDMRequestEmail_CE{
    
    public final Opportunity opportunityRecord;
    private static final String emailSubject = 'MDM Request';
    private static final String emailBody = 'Please find attached MDM Request.'; 
    
    //Constructor
    public FS_SendMDMRequestEmail_CE(ApexPages.StandardController stdController) {
            opportunityRecord = (Opportunity)stdController.getRecord();
    }
    
    //method that will create the excel to be attached
    public void createExcelAttachment(){        

        Set<Id> productIdsSet = new Set<Id>(); //will be used for getting the product details
        String finalAttachmentBody; //will be used for the attachment body
        Date dateSent; //Date of the last submission of the approval request for TPR Opportunity approval

        Opportunity opportunityRecord2 =[SELECT Id,
                                                FS_startDateTPR__c,
                                                FS_endDateTPR__c,
                                                FS_internalOrder__c,
                                                Owner.Email
                                            FROM Opportunity
                                            WHERE Id=:opportunityRecord.Id
                                            LIMIT 1];
                                            
        //Holds the attachment's default values
        FS_MDMEmailRequestDefaultValue__c MDMDefaultValue = FS_MDMEmailRequestDefaultValue__c.getOrgDefaults();
        
        //Retrieve the latest date when approval has been submitted
        ProcessInstanceStep PIS = [SELECT CreatedDate
									FROM ProcessInstanceStep
		                          	WHERE StepStatus = 'Started'
		                          	AND ProcessInstance.ProcessDefinition.DeveloperName = 'FS_TPR_Opportunity_Process'
		                          	AND ProcessInstance.TargetObjectId = :opportunityRecord.Id
		                          	ORDER By CreatedDate Desc Limit 1];
        
        //Compose the upper part of the attachment before the table format of the attachment
        finalAttachmentBody = MDMDefaultValue.FS_CompanyName__c + '\n' 
        					+ MDMDefaultValue.FS_CompanyAddress__c + '\n' 
        					+ MDMDefaultValue.FS_CompanyPhoneText__c + MDMDefaultValue.FS_CompanyPhone__c + '\t' 
        					+ MDMDefaultValue.FS_CompanyFaxText__c + MDMDefaultValue.FS_CompanyFax__c + '\n \n \n \n \n' 
        					+ PIS.CreatedDate + '\t \t \t \t \t \t \t \t' 
        					+ MDMDefaultValue.FS_CompanyCity__c + '\n \n \n \n \n' 
        					+ MDMDefaultValue.FS_Title__c + '\n \n \n';
        					
        
        //Used Custom Settings for the table header values on attachment
        FS_MDMEmailRequestTemplate__c MDMHeader = FS_MDMEmailRequestTemplate__c.getOrgDefaults();
        
        //Compose the Header of the Opportunity table format
        finalAttachmentBody = finalAttachmentBody
        						+ MDMHeader.FS_TargetOfDiscount__c + '\t' 
        						+ MDMHeader.FS_ConditionType__c + '\t' 
        						+ MDMHeader.FS_SalesOrganisation__c + '\t' 
        						+ MDMHeader.FS_ValidityStart__c + '\t' 
        						+ MDMHeader.FS_ValidityEnd__c + '\t' 
        						+ MDMHeader.FS_InternalOrder__c + '\n 1 \t 2 \t 3 \t 4 \t 5 \t 6 \n';
        
        //Compose the Values of the Opportunity table format 
        finalAttachmentBody = finalAttachmentBody
        					+ MDMDefaultValue.FS_TargetOfDiscountValue__c + '\t'
        					+ MDMDefaultValue.FS_ConditionTypeValue__c + '\t' 
        					+ MDMDefaultValue.FS_SalesOrganisation__c + '\t'
        					+ opportunityRecord2.FS_startDateTPR__c + '\t' 
        					+ opportunityRecord2.FS_endDateTPR__c + '\t' 
        					+ opportunityRecord2.FS_internalOrder__c + '\n \n';


        //Compose the Opportunity Line Item Header table format
        finalAttachmentBody =  finalAttachmentBody
         							+ MDMHeader.FS_HierarchyLevel__c
                                    + '\t' + MDMHeader.FS_CustomerCode__c
                                    + '\t' + MDMHeader.FS_CustomerCodeDescription__c
                                    + '\t' + MDMHeader.FS_ProductHierarchy__c
                                    + '\t' + MDMHeader.FS_MaterialCode__c
                                    + '\t' + MDMHeader.FS_MaterialDescription__c
                                    + '\t' + MDMHeader.FS_ProductExpirationDate__c
                                    + '\t' + MDMHeader.FS_Amount__c
                                    + '\t' + MDMHeader.FS_Unit__c + '\n 7 \t 8 \t 9 \t 10 \t 11 \t 12 \t 13 \t 14 \t 15 \n';
    
       //get the set of product ids for opportunity line item
       for(OpportunityLineItem oli:[SELECT id,
                                        FS_totalTPRPercentage__c,
                                        ProductCode,
                                        Product2Id
                                    FROM OpportunityLineItem
                                    WHERE OpportunityId = :opportunityRecord2.Id]){
                                        productIdsSet.add(oli.Product2Id);
                                    }
       
       //Map the Product Name of each product listed from Opportunity line Item                             
       Map<Id, Product2> product2Map = new Map<Id, Product2>([SELECT Name
                                                                FROM Product2
                                                                WHERE Id IN :productIdsSet]);
       
       //Compose the Values of the Opportunity Line Item table format
       for(OpportunityLineItem oli2:[SELECT id,
                                        FS_totalTPRPercentage__c,
                                        ProductCode,
                                        Product2Id
                                    FROM OpportunityLineItem
                                    WHERE OpportunityId = :opportunityRecord2.Id]){
            
            	finalAttachmentBody = finalAttachmentBody                            
            						+ '7 \t 8 \t 9 \t \t'
            						+ oli2.ProductCode +'\t'
            						+ product2Map.get(oli2.Product2Id).Name +'\t \t'
            						+ oli2.FS_totalTPRPercentage__c +'\t % \n';                          
       }
       
       //Compose the bottom part of the attachment after the table format
       finalAttachmentBody = finalAttachmentBody + '\n '
   									+ MDMDefaultValue.FS_CompanyNote__c + '\n \n \n'
       								+ MDMDefaultValue.FS_CaptionText__c + '\n \n'
       								+ MDMDefaultValue.FS_ApprovedByText__c + '\t \t \t \t' 
       								+ MDMDefaultValue.FS_SalesManagerName__c + '\t'
       								+ MDMDefaultValue.FS_SalesManagerPosition__c + '\n \t \t \t \t'
       								+ MDMDefaultValue.FS_NameText__c + '\t'
       								+ MDMDefaultValue.FS_PositionText__c +'\n \n \t \t \t \t'
       								+ MDMDefaultValue.FS_FinanceManagerName__c + '\t'
       								+ MDMDefaultValue.FS_FinanceManagerPosition__c + '\n \t \t \t \t'
       								+ MDMDefaultValue.FS_NameText__c + '\t'
       								+ MDMDefaultValue.FS_PositionText__c;
       
     
       //Call Send Email
       sendExcelAttachment(finalAttachmentBody, String.Valueof(opportunityRecord2.Owner.Email));
    }
    
     //method that will send the email with attachment 
     public static void sendExcelAttachment(String finalAttachmentBody, String ownerEmail){
        //Holds the list of email recipient
        List<String> emailRecipientList = new List<String>();
        
        //Construct the excel file as attachment
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        blob excel = blob.valueOf(finalAttachmentBody);          
        attach.setBody(excel);
        attach.setFileName('MDM Request.xls');
        
        //Retrieve list for email recipient set up on Custom Settings
        for(FS_MDMRequestRecipient__c emailRecipient : FS_MDMRequestRecipient__c.getAll().values()){
        	emailRecipientList.add(emailRecipient.FS_emailaddress__c);
        }
        
        //Add the Opportunity Owner's Email address
        emailRecipientList.add(ownerEmail);
        
   		//Email Creation
        Messaging.singleEmailMessage Emailwithattch = new Messaging.singleEmailMessage();
        Emailwithattch.setToaddresses(emailRecipientList);
        Emailwithattch.setSubject(emailSubject);
        Emailwithattch.setPlainTextBody(emailBody);
        
        //Attach the excel in the email to be sent
        Emailwithattch.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
        
        // Sends the email
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {Emailwithattch}); 
     }    
}