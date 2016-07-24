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
        Opportunity opportunityRecord2 =[SELECT Id,
                                                FS_startDateTPR__c,
                                                FS_endDateTPR__c,
                                                FS_internalOrder__c
                                            FROM Opportunity
                                            WHERE Id=:opportunityRecord.Id
                                            LIMIT 1];
        String attachmentHeader;
        String opportunityHeader;   //will be used for the opportunity header
        String opportunityValue; //will be used for the opportunity values
        String opportunityLineItemHeader; //will be used for the opportunity line item header
        String opportunityLineItemValue = ''; //will be used for the opportunity line item values
        Set<Id> productIdsSet = new Set<Id>(); //will be used for getting the product details
        String finalAttachmentBody; 
        Date dateSent;
        
        FS_MDMEmailRequestDefaultValue__c MDMDefaultValue = FS_MDMEmailRequestDefaultValue__c.getOrgDefaults();
        
        //Retrieve the latest date when approval has been submitted
        ProcessInstanceStep PIS = [SELECT CreatedDate
									FROM ProcessInstanceStep
		                          	WHERE StepStatus = 'Started'
		                          	AND ProcessInstance.ProcessDefinition.DeveloperName = 'FS_TPR_Opportunity_Process'
		                          	AND ProcessInstance.TargetObjectId = :opportunityRecord.Id
		                          	ORDER By CreatedDate Desc Limit 1];
        
        //Compose the upper part of the attachment for excel
        attachmentHeader = MDMDefaultValue.FS_CompanyName__c + '\n' 
        					+ MDMDefaultValue.FS_CompanyAddress__c + '\n' 
        					+ MDMDefaultValue.FS_CompanyPhoneText__c + MDMDefaultValue.FS_CompanyPhone__c + '\t' 
        					+ MDMDefaultValue.FS_CompanyFaxText__c + MDMDefaultValue.FS_CompanyFax__c + '\n \n \n \n \n' 
        					+ PIS.CreatedDate + '\t \t \t \t \t \t \t \t' 
        					+ MDMDefaultValue.FS_CompanyCity__c + '\n \n \n \n \n' 
        					+ MDMDefaultValue.FS_Title__c + '\n \n \n';
        					
        
        List<String> emailList = new List<String>();
        for(FS_MDMRequestRecipient__c emailRecipient : FS_MDMRequestRecipient__c.getAll().values()){
        	emailList.add(emailRecipient.FS_emailaddress__c);
        }
        
        //Used Custom Settings for the values of the headers on excel
        FS_MDMEmailRequestTemplate__c MDMHeader = FS_MDMEmailRequestTemplate__c.getOrgDefaults();
        
        //Compose the Header of the Opportunity for Excel
        opportunityHeader =  MDMHeader.FS_TargetOfDiscount__c + '\t' 
        						+ MDMHeader.FS_ConditionType__c + '\t' 
        						+ MDMHeader.FS_SalesOrganisation__c + '\t' 
        						+ MDMHeader.FS_ValidityStart__c + '\t' 
        						+ MDMHeader.FS_ValidityEnd__c + '\t' 
        						+ MDMHeader.FS_InternalOrder__c + '\n 1 \t 2 \t 3 \t 4 \t 5 \t 6 \n';
        
        //Compose the Values of the Opportunity for Excel
        opportunityValue = MDMDefaultValue.FS_TargetOfDiscountValue__c + '\t'
        					+ MDMDefaultValue.FS_ConditionTypeValue__c + '\t' 
        					+ MDMDefaultValue.FS_SalesOrganisation__c + '\t'
        					+ opportunityRecord2.FS_startDateTPR__c + '\t' 
        					+ opportunityRecord2.FS_endDateTPR__c + '\t' 
        					+ opportunityRecord2.FS_internalOrder__c + '\n';


        //Compose the Opportunity Line Item Header
        opportunityLineItemHeader =   MDMHeader.FS_HierarchyLevel__c
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
       
       //Compose the Values of the Opportunity Line Item for Excel
       for(OpportunityLineItem oli2:[SELECT id,
                                        FS_totalTPRPercentage__c,
                                        ProductCode,
                                        Product2Id
                                    FROM OpportunityLineItem
                                    WHERE OpportunityId = :opportunityRecord2.Id]){
                                        
            opportunityLineItemValue = opportunityLineItemValue + '7 \t 8 \t 9 \t 10 \t'
            							+ oli2.ProductCode +'\t'
                                        + product2Map.get(oli2.Product2Id).Name +'\t 13 \t'
                                        + oli2.FS_totalTPRPercentage__c +'\t % \n';                          
       }
       
       
       String attachmentFooter = '\n ' + MDMDefaultValue.FS_CompanyNote__c + '\t \t \t \t' 
       								+ MDMDefaultValue.FS_SalesManagerName__c + '\t'
       								+ MDMDefaultValue.FS_SalesManagerPosition__c + '\n \t \t \t \t \t'
       								+ MDMDefaultValue.FS_SalesDevelopmentManagerCaption__c +'\n \t \t \t \t \t'
       								+ MDMDefaultValue.FS_FinanceManagerName__c + '\t'
       								+ MDMDefaultValue.FS_FinanceManagerPosition__c + '\n \t \t \t \t \t'
       								+ MDMDefaultValue.FS_FinanceServiceManagerCaption__c;
       
       //concatenate all messages
       finalAttachmentBody = attachmentHeader + opportunityHeader + opportunityValue + opportunityLineItemHeader + opportunityLineItemValue + attachmentFooter;
       
       //Call Send Email
       sendExcelAttachment(finalAttachmentBody);
    }
    
     //method that will send the email with attachment 
     public static void sendExcelAttachment(String finalAttachmentBody){
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        blob excel = blob.valueOf(finalAttachmentBody);          
        attach.setBody(excel);
        attach.setFileName('MDM Request.xls');
        
        string[] address = new string[]{'joed.n.barcenas@accenture.com'};
   
        Messaging.singleEmailMessage Emailwithattch = new Messaging.singleEmailMessage();
        Emailwithattch.setToaddresses(address);
        Emailwithattch.setSubject(emailSubject);
        Emailwithattch.setPlainTextBody(emailBody);
        
        Emailwithattch.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
        // Sends the email
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {Emailwithattch}); 
     }    
}