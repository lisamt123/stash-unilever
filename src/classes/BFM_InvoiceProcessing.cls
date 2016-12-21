public class BFM_InvoiceProcessing {
    
    private String objectType;
    private Id miroId;
    
    public BFM_InvoiceProcessing(Id miroId){
        this.miroId = miroId;
        if(miroId.getSobjectType() == BFM_CT_e__c.SobjectType){
            objectType = 'BFM_CT_e__c';
        }
        
    }
    
    @future(callout=true)
    public static void performInvoiceProcessing(Id miroId,String objectType){
        boolean isSuccess = true;
        BFM_InvoiceProcessingRequest requestObj = generateJSONInvoiceProcessingRequest(miroId,objectType);
        try{
            HttpResponse response = BFM_GeneralServiceCalls.performInvoiceProcessing(requestObj);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201 ){
                isSuccess = true;
            } else{
                isSuccess = false;
                BFM_Error_Log__c errorLog = new BFM_Error_Log__C();
                errorLog.BFM_MIRO_Header__c = miroId;
                errorLog.Error_log__c = response.getBody();
                errorLog.Reason__c = 'Integration failure';
                insert errorLog;
            }
        } catch (Exception ex){
            system.debug(ex.getMessage() + ' ' + ex.getStackTraceString());
            isSuccess = false;
            BFM_Error_Log__c errorLog = new BFM_Error_Log__C();
            errorLog.BFM_MIRO_Header__c = miroId;
            errorLog.Error_log__c = ex.getMessage() + ' \n '+ ex.getStackTraceString();
            errorLog.Reason__c = 'Integration failure';
            insert errorLog;
        }
        //return isSuccess;
    }
    
    public static BFM_InvoiceProcessingRequest generateJSONInvoiceProcessingRequest(Id miroId,string objectType){
        
        BFM_MIRO_Header__c miroHeader = [SELECT Access_Key__c, /*Annulment_Flag__c,*/ Annulment_Reason__c,
                                         Baseline_Date_for_Due_Date_Calculation__c, /*Cancellation_Flag__c,*/
                                         Check_Digit_in_Access_Key__c,COFINS_Law__c, Company_Code__c, Complement_SES_Flag__c,
                                         Header_Text__c, ICMS_Law__c, In_State_Out_State__c, Invoice_Number__c,
                                         IPI_Law__c, PIS_Law__c,Posting_Date_in_the_Document__c, /*Net_Value__c,*/Total_Amount__c,
                                         Protocol_Number__c, Cte_Random_number__c, Reference_Document_Category__c,
                                         Header_Text_Summary__c,Free_Freight_Flag__c,Invoice_Date__c,
                                         NF_e_Issuing_Type__c,NF_Type__c,Transaction__c,
                                         (SELECT Id, Entry_Sheet_Number__c, SES_Net_Value__c,
                                          Tax_on_Sales_Purchases_Code__c
                                          FROM BFM_Miro_Items__r),
                                         (SELECT Id, Apply__c, Tax_Type__c, Tax_Code__c, Base_Amount__c FROM MIRO_Withhold_Taxes__r)
                                         
                                         FROM BFM_MIRO_Header__c 
                                         WHERE Id =: miroId];
        Set<Id> miroItemIds = new Set<Id>();
        for(BFM_Miro_Item__c miroItem: miroHeader.BFM_Miro_Items__r){
            miroItemIds.add(miroItem.Id);
        }
        Map<Id, List<BFM_Miro_Item_Tax__c>> taxItemsByMiroItem = new Map<Id, List<BFM_Miro_Item_Tax__c>>();
        for(BFM_Miro_Item_Tax__c tax: [SELECT Id, CFOP_Entry__c,
                                       Fiscal_Right_ICMS__c,
                                       Fiscal_Right_IPI__c,
                                       Tax_type__c,
                                       Tax_Rate__c,
                                       Other_Base__c,
                                       Excluded_Base__c,
                                       Original_Tax_Base_Amount__c,
                                       MIRO_Item__c,
                                       Tax_amount__c
                                       FROM BFM_Miro_Item_Tax__c WHERE MIRO_Item__c IN: miroItemIds]){
                                           if(!taxItemsByMiroItem.containsKey(tax.MIRO_Item__c)){
                                               taxItemsByMiroItem.put(tax.MIRO_Item__c, new List<BFM_Miro_Item_Tax__c>());
                                           }
                                           taxItemsByMiroItem.get(tax.MIRO_Item__c).add(tax);
                                       }
        
        BFM_InvoiceProcessingRequest envelope = new BFM_InvoiceProcessingRequest();
        
        envelope.RequestInvoiceProcessing = new BFM_InvoiceProcessingRequest.RequestInvoiceProcessing();
        envelope.RequestInvoiceProcessing.accessKey = miroHeader.Access_Key__c;
        //envelope.RequestInvoiceProcessing.annulationFlag = miroHeader.Annulment_Flag__c;
        envelope.RequestInvoiceProcessing.annulationReason = miroHeader.Annulment_Reason__c;
        envelope.RequestInvoiceProcessing.baselineDate = miroHeader.Baseline_Date_for_Due_Date_Calculation__c;
        //envelope.RequestInvoiceProcessing.cancellationFlag = miroHeader.Cancellation_Flag__c;
        envelope.RequestInvoiceProcessing.checkDigit = miroHeader.Check_Digit_in_Access_Key__c;
        envelope.RequestInvoiceProcessing.cofinsLaw = miroHeader.COFINS_Law__c;
        envelope.RequestInvoiceProcessing.companyCode = miroHeader.Company_Code__c;
        envelope.RequestInvoiceProcessing.complementSESFlag = miroHeader.Complement_SES_Flag__c != null ? true : false;
        envelope.RequestInvoiceProcessing.freeFreightFlag = miroHeader.Free_Freight_Flag__c;
        envelope.RequestInvoiceProcessing.headerText = miroHeader.Header_Text__c;
        envelope.RequestInvoiceProcessing.headerTextSummary = miroHeader.Header_Text_Summary__c;
        envelope.RequestInvoiceProcessing.icmsLaw = miroHeader.ICMS_Law__c;
        envelope.RequestInvoiceProcessing.inOutState = miroHeader.In_State_Out_State__c;
        envelope.RequestInvoiceProcessing.invoiceDate = miroHeader.Invoice_Date__c;
        envelope.RequestInvoiceProcessing.invoiceNumber = miroHeader.reference_number__c;
        envelope.RequestInvoiceProcessing.ipiLaw = miroHeader.IPI_Law__c;
        envelope.RequestInvoiceProcessing.nfeIssType = miroHeader.NF_e_Issuing_Type__c;
        envelope.RequestInvoiceProcessing.nfType = miroHeader.NF_Type__c;
        envelope.RequestInvoiceProcessing.objectName = objectType;
        envelope.RequestInvoiceProcessing.pisLaw = miroHeader.PIS_Law__c;
        envelope.RequestInvoiceProcessing.postingDate = String.valueOf(miroHeader.Posting_Date_in_the_Document__c);
        envelope.RequestInvoiceProcessing.protocolNumber = miroHeader.Protocol_Number__c;
        envelope.RequestInvoiceProcessing.randomNumber = miroHeader.Cte_Random_number__c;
        envelope.RequestInvoiceProcessing.referenceDocumentCategory = miroHeader.Reference_Document_Category__c;
        envelope.RequestInvoiceProcessing.transactionCode = miroHeader.Transaction__c;
        envelope.RequestInvoiceProcessing.totalAmount = miroHeader.Total_Amount__c;
        //envelope.RequestInvoiceProcessing.valueNet = String.valueOf(miroHeader.Net_Value__c);
        if(!miroHeader.MIRO_Withhold_Taxes__r.isEmpty()){
            envelope.RequestInvoiceProcessing.withholdItems = new List<BFM_InvoiceProcessingRequest.WithholdItems>();
            for(BFM_MIRO_Withhold_Tax__c tax: miroHeader.MIRO_Withhold_Taxes__r ){
                BFM_InvoiceProcessingRequest.WithholdItems wthItem = new BFM_InvoiceProcessingRequest.WithholdItems();
                wthItem.withholdingTaxCode = tax.Tax_Code__c;
                wthItem.withholdingTaxType = tax.Tax_Type__c;
                wthItem.withholdingTaxApplyFlag = tax.Apply__c;
                wthItem.withholdingTaxBaseAmount = tax.Base_Amount__c;
                envelope.RequestInvoiceProcessing.withholdItems.add(wthItem);
            }
        }
        
        if(!miroHeader.BFM_Miro_Items__r.isEmpty()){
            envelope.RequestInvoiceProcessing.items = new List<BFM_InvoiceProcessingRequest.Items>();
            for(BFM_Miro_Item__c miroItem : miroHeader.BFM_Miro_Items__r){
                BFM_InvoiceProcessingRequest.Items requestItem = new BFM_InvoiceProcessingRequest.Items();	
                requestItem.sesNumber = miroItem.Entry_Sheet_Number__c;
                requestItem.sesNetValue = String.valueof(miroItem.SES_Net_Value__c);
                requestItem.taxCode = miroItem.Tax_on_Sales_Purchases_Code__c;
                envelope.RequestInvoiceProcessing.items.add(requestItem);
                if(taxItemsByMiroItem.containsKey(miroItem.Id)){
                    requestItem.taxes = new List<BFM_InvoiceProcessingRequest.Taxes>();
                    for(BFM_Miro_Item_Tax__c itemTax: taxItemsByMiroItem.get(miroItem.Id)){
                        BFM_InvoiceProcessingRequest.Taxes requestTaxItem = new BFM_InvoiceProcessingRequest.Taxes();
                        requestTaxItem.cfopInbound= itemTax.CFOP_Entry__c;
                        requestTaxItem.fiscalRightICMS = itemTax.Fiscal_Right_ICMS__c;
                        requestTaxItem.fiscalRightIPI = itemTax.Fiscal_Right_IPI__c;
                        requestTaxItem.taxType = itemTAx.Tax_type__c;
                        requestTaxItem.taxValue = itemTax.Tax_Amount__c;
                        requestTaxItem.rate = itemTax.Tax_Rate__c;
                        requestTaxItem.baseAmount = itemTax.Original_Tax_Base_Amount__c;
                        requestTaxItem.otherBase = itemTax.Other_Base__c;
                        requestTaxItem.excludedBase = itemTax.Excluded_Base__c;
                        requestItem.taxes.add(requestTaxItem);
                    } 
                }
            }
        }
        return envelope;
    }
}