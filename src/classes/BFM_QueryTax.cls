public class BFM_QueryTax {

    private Id invoiceId;
	public static final string TYPE_CTE = 'CTE';    
    public static final string TYPE_NFS = 'NFS';
    public static final string TYPE_ND = 'ND';
    private boolean isSuccess;
    private List<String> errors;
    private BFM_QueryTaxRequest request;
    public BFM_QueryTax(Id invoiceId){
        this.invoiceId = invoiceId;
        this.isSuccess = true;
        this.errors = new List<String>();
    }
    
    @future(callout=true)
    public static void queryTaxFuture(Id invoiceId){
        new BFM_QueryTax(invoiceId).queryTax();
    }
    
    public void queryTax(){
        
        BFM_QueryTaxRequest queryTaxRequest;
        if(invoiceId.getSobjectType() == BFM_CT_e__c.sObjectType){
            
            queryTaxRequest = generateQueryTaxRequestCTE();
            if(queryTaxRequest == null){
                isSuccess = false;
                String errorMessage = 'Query Tax Request wasn\'t generated successfully';
                this.errors.add(errorMessage);
                System.debug(errorMessage);
            }
        }
        if(isSuccess){
            try{
                boolean suppressApexNulls = true;
                HttpResponse response = BFM_GeneralServiceCalls.queryTax(JSON.Serialize(queryTaxRequest, suppressApexNulls));
                if(response.getStatusCode() == 200 ||response.getStatusCode() == 201){
                	BFM_QueryTaxResponse objResponse = BFM_QueryTaxResponse.parse(response.getBody());
                    processResponse(objResponse);
                } else{
                    System.debug('Integration failure: ' + response.getStatusCode() + ' ' + response.getStatus());
                    createErrorLog('Integration failure', response.getStatusCode() + ' ' + response.getStatus());
                }
            } catch(Exception ex){
                isSuccess = false;
                System.debug('Integration Failure ' + ex.getMessage());
                createErrorLog('Integration Failure', ex.getMessage());
            }   
        } else{
           System.debug('not successful ' + errors[0]);
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
                              Cte_Emission_date_time__c,Receivable_Amount__c,Tax_Code_id__c,
                              ICMS_Base_Value__c,ICMS_Value__c,CT_e_key__c, Net_Value__c,
                              (SELECT SES_Number__c, Vendor_Code__c,
                             		Stage__r.Shipment__r.Carrier_Account__r.Vendor__c,
                                     Stage__r.Shipment__r.Carrier_Account__r.Tax_Jurisdiction__c,     
                             		Stage__r.Shipment__r.Unilever_Company__r.Company_Code__c
                             						FROM SESs__r)
                      							FROM BFM_CT_e__c
                             					WHERE Id =: invoiceId];
        if(theCTe.SESs__r.isEmpty()){
            isSuccess = false;
            errors.Add('There was no SES related to this CT-e');
        }else{
            BFM_SES__c theSes = theCte.SESs__r[0];
            request = new BFM_QueryTaxRequest();
            request.queryTaxCalculation = new BFM_QueryTaxRequest.QueryTaxCalculation();
            request.queryTaxCalculation.sesId = new List<String>();
            for(BFM_SES__c ses: theCte.SESs__r){
            	request.queryTaxCalculation.sesId.add(theSes.SES_Number__c);    
            }
                        
            request.queryTaxCalculation.vendorId = theSes.Vendor_Code__c;
            request.QueryTaxCalculation.companyCode = theSes.Stage__r.Shipment__r.Unilever_Company__r.Company_Code__c;
            request.queryTaxCalculation.taxCode = theCte.Tax_Code_id__c;
            request.queryTaxCalculation.taxJusrisdiction = theSes.Stage__r.Shipment__r.Carrier_Account__r.Tax_Jurisdiction__c;
            request.queryTaxCalculation.nfCategory = '57';
            request.QueryTaxCalculation.item = new BFM_QueryTaxRequest.Item();
            request.queryTaxCalculation.item.issueDate = Date.newInstance(theCte.Cte_Emission_date_time__c.year(),
                                                                          theCte.Cte_Emission_date_time__c.month(),
                                                                          theCte.Cte_Emission_date_time__c.day());
            
            request.queryTaxCalculation.item.totalValue = String.valueOf(theCte.Receivable_Amount__c);     
            request.queryTaxCalculation.item.baseValue = theCTe.ICMS_Base_Value__c;
            request.queryTaxCalculation.item.netValue = String.valueOf(theCte.Net_Value__c);
            request.queryTaxCalculation.item.icmsValue = theCTe.ICMS_Value__c;
            request.queryTaxCalculation.item.cteAccessKey = theCTE.CT_e_key__c;
            request.queryTaxCalculation.item.itemType = TYPE_CTE;
            
        } 
        return request;
    }
    
    public BFM_QueryTaxRequest generateQueryTaxRequestNFS(){
        BFM_QueryTaxRequest request;
        BFM_NFS__c theNFS = [SELECT Id, (SELECT SES_Number__c, 
                             		Stage__r.Shipment__r.Carrier_Account__r.Vendor__c,
                                     Stage__r.Shipment__r.Carrier_Account__r.Tax_Jurisdiction__c,     
                             		Stage__r.Shipment__r.Unilever_Company__r.Company_Code__c
                             						FROM SESNFSs__r)
                      							FROM BFM_NFS__c
                             					WHERE Id =: invoiceId];
        if(theNFS.SESNFSs__r.isEmpty()){
            isSuccess = false;
            errors.Add('There was no SES related to this CT-e');
        }else{
            BFM_SES__c theSes = theNFS.SESNFSs__r[0];
            
            request = new BFM_QueryTaxRequest();
            request.queryTaxCalculation = new BFM_QueryTaxRequest.QueryTaxCalculation();
            
            request.queryTaxCalculation.sesId = new List<String>();
            for(BFM_SES__c ses: theNFS.SESNFSs__r){
                request.queryTaxCalculation.sesId.add(ses.SES_Number__c);
            }
            
            request.queryTaxCalculation.vendorId = theSes.Vendor_Code__c;
            request.QueryTaxCalculation.companyCode = theSes.Stage__r.Shipment__r.Unilever_Company__r.Company_Code__c;
            request.queryTaxCalculation.taxCode = theSes.Tax_Code__c;
            request.queryTaxCalculation.taxJusrisdiction = theSes.Stage__r.Shipment__r.Carrier_Account__r.Tax_Jurisdiction__c;
            request.queryTaxCalculation.nfCategory = '57';
            request.QueryTaxCalculation.item = new BFM_QueryTaxRequest.Item();
            request.queryTaxCalculation.item.issueDate = Date.newInstance(theNFS.NFS_Emission_Date_Time__c.year(),
                                                                          theNFS.NFS_Emission_Date_Time__c.month(),
                                                                          theNFS.NFS_Emission_Date_Time__c.day());
            request.queryTaxCalculation.item.totalValue = String.valueOf(theNFS.NFS_Total_Value__c);     
            request.queryTaxCalculation.item.baseValue = theNFS.Base_Value__c;
            //public String netValue;
            request.queryTaxCalculation.item.icmsValue = theNFS.ISS_Value__c;
            request.queryTaxCalculation.item.nfsNumber = theNFS.NFS_Number__c;
            //public String debitNoteNumber;
            request.queryTaxCalculation.item.itemType = TYPE_NFS;
            
        } 
        return request;
    }
    
    private void createErrorLog(String reason, String errorMessage){
        BFM_Error_Log__c error = new BFM_Error_Log__c();
        error.Error_Log__c = errorMessage;
        error.Reason__c = reason;
        error.BFM_CT_e__c = this.invoiceId;
        insert error;
    }
}