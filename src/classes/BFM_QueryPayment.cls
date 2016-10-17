global class BFM_QueryPayment {
	
    private Set<Id> miroHeaderIds;
    private String TYPE_CTE = 'cte';
    private string TYPE_NFS = 'nfs';
    private String objectType;
    public BFM_QueryPayment(Set<Id> miroHeaderIds){
        this.miroHeaderIds = miroHeaderIds;
        
    }
    webservice static String callQueryPaymentFromButton(Id miroHeaderId){
        try{
            new BFM_QueryPayment(new Set<Id> {miroHeaderId}).queryPayments();
        }catch(Exception ex){
            return 'Error ' + ex.getMessage();
        }
        return 'ok';
    }
    public void queryPayments(){
        Set<String> miroHeaderAccessKeys = new Set<String>();
        for(BFM_Miro_Header__c header: [SELECT Access_Key__c FROM BFM_MIRO_Header__c WHERE Id IN: miroHeaderIds]){
            miroHeaderAccessKeys.add(header.Access_Key__c);
        }
    	HttpResponse response = BFM_GeneralServiceCalls.queryPayments(new List<String>(miroHeaderAccessKeys));
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            if(String.isEmpty(response.getBody())){
            	createErrorLogs(miroHeaderAccessKeys);
            } else{
                BFM_QueryPaymentsResponse queryPaymentsResponse = BFM_QueryPaymentsResponse.parse(response.getBody());
                try{
                	updateQueryPayment(queryPaymentsResponse);
                } catch (Exception ex){
                    System.debug('Exception: ' +ex.getMessage());
                    System.debug(ex.getStackTraceString());
                }
            }
        }
    }


    private void createErrorLogs(Set<String> miroHeaderAccessKeys){
        List<BFM_Error_Log__c> errorLogs = new List<BFM_Error_Log__c>();
        for(String headerAccessKey: miroHeaderAccessKeys){
            BFM_Error_Log__c errorLog = new BFM_Error_Log__c();
            errorLog.error_log__c = 'Integration Error: Response was null';
            errorLog.Reason__c = 'Integration Error';
            errorLog.BFM_MIRO_Header__r = new BFM_Miro_Header__c(Access_Key__c = headerAccessKey);
            errorLogs.add(errorLog);
        }
        insert errorLogs;
    }    
    private Date convertDate(String strDate){
        return Date.valueOf(strDate);
    }
    private String convertFlag(boolean boolFlag){
        return boolFlag ? 'X' : '';
    }
    private List<BFM_Miro_Header__c> updateQueryPayment(BFM_QueryPaymentsResponse queryPaymentsResponse){
        List<BFM_MIRO_Header__c> headers = new List<BFM_MIRO_Header__c>();
        List<BFM_MIRO_Item__c> miroItems = new List<BFM_Miro_Item__c>();
        for(BFM_QueryPaymentsResponse.Payments paymentResponse : QueryPaymentsResponse.queryPaymentResponse.payments){
            BFM_MIRO_Header__c header = new BFM_MIRO_Header__c();
            header.Access_Key__c = paymentResponse.accessKey;
            
            //public String objectType {get;set;} 
            if(objectType == TYPE_CTE){
                header.Ct_e__r = new BFM_CT_e__c(CT_e_key__c = paymentResponse.accessKey);
            } /**else if(objectType == TYPE_NFS){
                header.NFS__r = new BFM_NFS__c(NFS_Key__c = paymentResponse.accessKey);
            } */
            header.MIRO_Number__c = paymentResponse.miroNumber;
            header.Invoice_Number__c = paymentResponse.invoiceDocNumberFI;
            header.Posting_Date_in_the_Document__c = paymentResponse.postingDate;
            //header.Payment_Term__c = paymentResponse.paymentTerm
            header.Payment_Block__c = paymentResponse.paymentBlock;
            
            header.Annulment_Fiscal_Doc_No__c = paymentResponse.annulationDocument;
            header.Annulment_Fiscal_Posting_Date__c = convertDate(paymentResponse.annulationPostingDate);
            header.Cancellation_Document_No__c = paymentResponse.cancellationDocument;
            header.Cancellation_Posting_Date__c = paymentResponse.cancellationPostingDate;
            header.Annulment_NF_e_reference__c = paymentResponse.accessKeyAnnulationInvoice;
            header.NF_Writer_Document_Number__c = paymentResponse.nfWriterDocument;
            
            header.payment_Document__c = paymentResponse.paymentDocument;
            
            header.Posting_Date_in_the_Document__c = paymentResponse.postingDate;
            header.Net_Due_Date__c = Date.valueOf(paymentResponse.netDueDate);
            header.payment_method__c = paymentResponse.paymentMethod;
            
            
            header.Cancellation_Flag__c = convertFlag(paymentResponse.cancellationFlag);
            header.Annulment_Flag__c = convertFlag(paymentResponse.annulmentFlag);
            header.Payment_amount__c = paymentResponse.paymentAmount;
            for(BFM_QueryPaymentsResponse.PaidDocuments item: paymentResponse.paidDocuments){
                BFM_Miro_Item__c miroItem = new BFM_Miro_Item__c();
                System.debug('access key ' + paymentResponse.accessKey  + ' (lenght: ' + paymentResponse.accessKey.length() +')');
                System.debug('reference number ' +  item.referenceNumber  + ' (lenght: ' +  item.referenceNumber.length() +')');
                System.debug('document number ' +  item.documentNumber  + ' (lenght: ' +  item.documentNumber.length() +')');
                miroItem.MIRO_Header__r = new BFM_MIRO_Header__c(Access_Key__c = paymentResponse.accessKey);
                miroItem.Access_Key__c = paymentResponse.accessKey + ''+ item.documentNumber;
                miroItem.Payment_document_Amount__c = item.amount;
                miroItem.Reference_number__c = item.referenceNumber;
                miroItem.Document_issue_date__c = !String.isEmpty(item.date_z) ? null : Date.valueOf(item.date_z);
                miroItem.Document_Number__c = item.documentNumber;
                miroItems.add(miroItem);
                // date
                // referenceNumber
                // 
                
                	
            }
            headers.add(header);
            //public String logMessage {get;set;} 
            
        }
        Database.UpsertResult[] srHeaders =  Database.upsert(headers, Schema.getGlobalDescribe().get('BFM_MIRO_Header__c')
                        									.getDescribe()
                        									.fields
                        									.getMap()
                        									.get('Access_Key__c'), true);
        Database.UpsertResult[] srItems = Database.upsert(miroItems, Schema.getGlobalDescribe().get('BFM_MIRO_Item__c')
                        									.getDescribe()
                        									.fields
                        									.getMap()
                        									.get('Access_Key__c'), true);
        for(Database.UpsertResult srHeader: srHeaders){
            if(!srHeader.isSuccess()){
                for(Database.Error error :srheader.getErrors()){
                    System.debug('error upserting header ' + error.getMessage());
                }
            }
        }
        for(Database.UpsertResult srItem: srItems){
            if(!srItem.isSuccess()){
                for(Database.Error error :srItem.getErrors()){
                    System.debug('error upserting header ' + error.getMessage());
                }
            }
        }
        System.debug('Header Id ' + headers[0].Id);
        return headers;
    }
}