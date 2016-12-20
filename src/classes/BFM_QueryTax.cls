public class BFM_QueryTax {
    
    private Id invoiceId;
    public static final string TYPE_CTE = 'CTE';    
    public static final string TYPE_NFS = 'NFS';
    public static final string TYPE_ND = 'ND';
    private boolean isSuccess;
    private List<String> errors;
    private List<BFM_Error_Log__c> errorLogsCreated;
    private BFM_QueryTaxRequest request;
    public BFM_QueryTax(Id invoiceId){
        this.invoiceId = invoiceId;
        this.isSuccess = true;
        this.errors = new List<String>();
        errorLogsCreated = new List<BFM_Error_Log__c>();
    }
    
    @future(callout=true)
    public static void queryTaxFuture(Id invoiceId){
        new BFM_QueryTax(invoiceId).queryTax();
    }
    
    public void queryTax(){
        
        BFM_QueryTaxRequest queryTaxRequest;
        System.debug('invoiceId ' + invoiceId);
        if(invoiceId.getSobjectType() == BFM_CT_e__c.sObjectType){
            
            queryTaxRequest = generateQueryTaxRequestCTE();
            if(queryTaxRequest == null){
                String errorMessage = 'Query Tax Request wasn\'t generated successfully';
                raiseError(errorMessage, errorMessage, invoiceId.getSobjectType());
            }
        } else if (invoiceId.getSobjectType() == BFM_NFS__c.sObjectType) {
            queryTaxRequest = generateQueryTaxRequestNFS();
            if(queryTaxRequest == null){
                String errorMessage = 'Query Tax Request wasn\'t generated successfully';
                raiseError(errorMessage, errorMessage, invoiceId.getSobjectType());
            }
        }
        System.debug('Tax Request' + queryTaxRequest);
        System.debug('Type Of Request ' + invoiceId.getSobjectType());
        if(isSuccess){
            try{
                boolean suppressApexNulls = true;
                HttpResponse response = BFM_GeneralServiceCalls.queryTax(JSON.Serialize(queryTaxRequest, suppressApexNulls));
                if(response.getStatusCode() == 200 ||response.getStatusCode() == 201){
                    BFM_QueryTaxResponse objResponse = BFM_QueryTaxResponse.parse(response.getBody());
                    processResponse(objResponse);
                } else{
                    String errorMessage = 'Integration failure: ' + response.getStatusCode() + ' ' + response.getStatus();
                    raiseError('Integration Failure', errorMessage, invoiceId.getSobjectType());
                }
            } catch(Exception ex){
                String errorMessage = 'Integration Failure ' + ex.getMessage();
                raiseError('Integration Failure', errorMessage, invoiceId.getSobjectType());
            }   
        } 
        if(!isSuccess){
            if(!errorLogsCreated.isEmpty()){
                insert errorLogsCreated;
            }
        }
    }
    
    public void processResponse(BFM_QueryTaxResponse response ){
        BFM_QueryTaxResponse.QueryTaxCalculationResponse responseQueryTax = response.queryTaxCalculationResponse;
        
        List<BFM_SES__c> sesList = new List<BFM_SES__c>(); 
        List<BFM_IVA__c> ivaList = new List<BFM_IVA__c>();
        
        for(BFM_QueryTaxResponse.SESList sesResponse: responseQueryTax.SesList){
            BFM_SES__c ses = new BFM_SES__c();
            if(responseQueryTax.itemType == 'CTe'){
                ses.CT_E__r = new BFM_CT_e__c(CT_e_Key__c = responseQueryTax.cteAccessKey);
            }
            ses.SES_Number__c = sesResponse.id;
            ses.Tax_Code__c = sesResponse.taxCode;
            ses.CFOP__c = sesResponse.cfop;
            ses.ICMS_Law__c = sesResponse.icmsLaw;
            ses.IPI_law__c = sesResponse.ipiLaw;
            ses.COFINS_law__c = sesResponse.cofinsLaw;
            ses.PIS_law__c = sesResponse.pisLaw;
            sesList.add(ses);
            for(BFM_QueryTaxResponse.IvaList ivaResponse: sesResponse.ivaList){
                BFM_IVA__c iva = new BFM_IVA__c();
                iva.Tax_Type__c = ivaResponse.taxType;
                iva.tax_group__c = ivaResponse.taxGroup;
                iva.description__c = ivaResponse.description;
                iva.tax_base__c = ivaResponse.taxBase;
                iva.tax_rate__c = ivaResponse.taxRate;
                iva.tax_Amount__c = ivaResponse.taxAmount;
                iva.other_base__c = ivaResponse.otherBase;
                iva.Excluded_base__c = ivaResponse.excludedBase;
                ivaList.add(iva);
            }
        }
        database.upsert(sesList, Schema.getGlobalDescribe().get('BFM_SES__c')
                        .getDescribe()
                        .fields
                        .getMap()
                        .get('SES_Number__c') );
        database.upsert(ivaList);
    }
    
    public BFM_QueryTaxRequest generateQueryTaxRequestCTE(){
        BFM_QueryTaxRequest request;
        BFM_CT_e__c theCte = [SELECT Id, Tax_Code__r.Name,
                              Cte_Emission_date_time__c,Receivable_Amount__c, Tax_Code_id__c,
                              ICMS_Base_Value__c,ICMS_Value__c,CT_e_key__c, Net_Value__c,
                              (SELECT SES_Number__c, Vendor_Code__c,
                               Stage__r.Shipment__r.Carrier_Account__r.Vendor__c,
                               Stage__r.Shipment__r.Carrier_Account__r.Tax_Jurisdiction__c,     
                               Stage__r.Shipment__r.Company_Code__c
                               FROM SESs__r)
                              FROM BFM_CT_e__c
                              WHERE Id =: invoiceId];
        if(theCTe.SESs__r.isEmpty()){
            String errorMessage = 'There was no SES related to this CT-e';
            raiseError(errorMessage, errorMessage, theCte.getSobjectType());
            
        }else{
            BFM_SES__c theSes = theCte.SESs__r[0];
            request = new BFM_QueryTaxRequest();
            request.queryTaxCalculation = new BFM_QueryTaxRequest.QueryTaxCalculation();
            request.queryTaxCalculation.sesId = new List<String>();
            if(!theCte.SESs__r.isEmpty()){
                for(BFM_SES__c ses: theCte.SESs__r){
                    request.queryTaxCalculation.sesId.add(theSes.SES_Number__c);    
                }
            } else{
                String errorMessage = 'There was no SES linked to this CT-e';
                raiseError(errorMessage, errorMessage, theCte.getSobjectType());
            }
            
            request.queryTaxCalculation.vendorId = theSes.Vendor_Code__c;
            if(!String.isEmpty(theSes.Stage__r.shipment__r.Company_Code__c)){
                request.QueryTaxCalculation.companyCode = theSes.Stage__r.Shipment__r.Company_Code__c;
            } else{
                String errorMessage = 'Company Code on the SES was empty';
                raiseError(errorMessage, errorMessage, theCte.getSobjectType());
            }
            request.queryTaxCalculation.taxCode = theCte.Tax_Code_id__c;
            if(!String.isEmpty(theSes.Stage__r.Shipment__r.Carrier_Account__r.Tax_Jurisdiction__c)){
                request.queryTaxCalculation.taxJusrisdiction = theSes.Stage__r.Shipment__r.Carrier_Account__r.Tax_Jurisdiction__c;
            } else{
                String errorMessage = 'Tax classification failed: Missing tax jurisdiction';
                raiseError(errorMessage, errorMessage, theCte.getSobjectType());
            }
            request.queryTaxCalculation.nfCategory = 'CE'; // CE For CTe
            request.QueryTaxCalculation.item = new BFM_QueryTaxRequest.Item();
            if(theCte.CTe_Emission_date_Time__c != null){
                Date dt = Date.newInstance(theCte.Cte_Emission_date_time__c.year(),
                                           theCte.Cte_Emission_date_time__c.month(),
                                           theCte.Cte_Emission_date_time__c.day()); 
                
                request.queryTaxCalculation.item.issueDate = String.valueOf(dt);
                
            } else {
                String errorMessage = 'CTe didn\'t have emission date time';
                raiseError(errorMessage, errorMessage, theCte.getSobjectType());
            }
            
            if(theCte.Receivable_Amount__c != null){
                request.queryTaxCalculation.item.totalValue = String.valueOf(theCte.Receivable_Amount__c);     
            } else{
                String errorMessage = 'CTe didn\'t have total value ("receivable amount" field)';
                raiseError(errorMessage, errorMessage, theCte.getSobjectType());
                
            }
            request.queryTaxCalculation.item.baseValue = String.valueof(theCTe.ICMS_Base_Value__c);
            request.queryTaxCalculation.item.netValue = String.valueOf(theCte.Net_Value__c);
            request.queryTaxCalculation.item.icmsValue = String.valueOf(theCTe.ICMS_Value__c);
            request.queryTaxCalculation.item.cteAccessKey = String.valueOf(theCTE.CT_e_key__c);
            request.queryTaxCalculation.item.itemType = TYPE_CTE;
            
        } 
        return request;
    }
    
    public BFM_QueryTaxRequest generateQueryTaxRequestNFS(){
        BFM_QueryTaxRequest request;
        BFM_NFS__c theNFS = [SELECT Id, NFS_Emission_Date_Time__c, NFS_Total_Value__c,
                             Base_Value__c, ISS_Value__c, NFS_Number__c, (SELECT SES_Number__c, 
                                                                          Stage__r.Shipment__r.Carrier_Account__r.Vendor__c,
                                                                          Stage__r.Shipment__r.Carrier_Account__r.Tax_Jurisdiction__c,     
                                                                          Stage__r.Shipment__r.Unilever_Company__r.Company_Code__c,
                                                                          Vendor_Code__c,
                                                                          Tax_Code__c
                                                                          FROM SESNFSs__r)
                             FROM BFM_NFS__c
                             WHERE Id =: invoiceId];
        if(theNFS.SESNFSs__r.isEmpty()){
            isSuccess = false;
            String errorMessage = 'There was no SES related to this CT-e';
            System.debug(errorMessage);
            errors.Add(errorMessage);
        }else{
            BFM_SES__c theSes = theNFS.SESNFSs__r[0];
            
            request = new BFM_QueryTaxRequest();
            request.queryTaxCalculation = new BFM_QueryTaxRequest.QueryTaxCalculation();
            
            request.queryTaxCalculation.sesId = new List<String>();
            for(BFM_SES__c ses: theNFS.SESNFSs__r){
                request.queryTaxCalculation.sesId.add(ses.SES_Number__c);
            }
            
            if(!String.isEmpty(theSes.vendor_code__c)){
                request.queryTaxCalculation.vendorId = theSes.Vendor_Code__c;
            } else{
                String errorMessage = 'Vendor Code was empty on the related SES';
                raiseError(errorMessage, errorMessage, theNFS.getSobjectType());
            }
            request.QueryTaxCalculation.companyCode = theSes.Stage__r.Shipment__r.Unilever_Company__r.Company_Code__c;
            request.queryTaxCalculation.taxCode = theSes.Tax_Code__c;
            if(!String.isEmpty(theSes.Stage__r.Shipment__r.Carrier_Account__r.Tax_Jurisdiction__c)){
                request.queryTaxCalculation.taxJusrisdiction = theSes.Stage__r.Shipment__r.Carrier_Account__r.Tax_Jurisdiction__c;
            } else{
                String errorMessage = 'Tax classification failed: Missing tax jurisdiction';
                System.debug(errorMessage);
                createErrorLog(errorMessage, errorMessage, theNFS.getSobjectType());
            }
            request.queryTaxCalculation.nfCategory = 'Z5'; //Z5 for NFS
            request.QueryTaxCalculation.item = new BFM_QueryTaxRequest.Item();
            
            Date dt = Date.newInstance(theNFS.NFS_Emission_Date_Time__c.year(),
                                       theNFS.NFS_Emission_Date_Time__c.month(),
                                       theNFS.NFS_Emission_Date_Time__c.day()); 
            
            request.queryTaxCalculation.item.issueDate = String.valueOf(dt);
            
            request.queryTaxCalculation.item.totalValue = String.valueOf(theNFS.NFS_Total_Value__c);     
            request.queryTaxCalculation.item.baseValue = String.valueOf(theNFS.Base_Value__c);
            request.queryTaxCalculation.item.icmsValue = String.valueOf(theNFS.ISS_Value__c);
            request.queryTaxCalculation.item.nfsNumber = String.valueOf(theNFS.NFS_Number__c);
            request.queryTaxCalculation.item.itemType = TYPE_NFS;
        } 
        return request;
    }
    
    private BFM_Error_Log__c createErrorLog(String reason, String errorMessage, Schema.SObjectType objectType){
        BFM_Error_Log__c error = new BFM_Error_Log__c();
        error.Error_Log__c = errorMessage;
        error.Reason__c = reason;
        if(objectType == BFM_CT_e__c.sObjectType) {
            error.BFM_CT_e__c = this.invoiceId;            
        } else if (objectType == BFM_NFS__c.sObjectType) {
            error.BFM_NFS__c = this.invoiceId;
        }
        
        return error;
    }
    
    private void raiseError(String reason, String errorMessage, Schema.SObjectType objectType){
        this.isSuccess = false;
        System.debug('Error was captured: ' + reason + ' ' + errorMessage);
        BFM_Error_Log__c errorLog = createErrorLog(reason, errorMessage, objectType);
        this.errors.add(errorMessage);
        errorLogsCreated.add(errorLog);
    }
}