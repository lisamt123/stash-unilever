global class BFM_QueryOccurrence {
    
    private List<String> occurrenceNumbers;
    private static final String QUERY_TYPE_CTE_ISSUING = 'ALL';
    private List<BFM_Occurrence__c> upsertOccurrences;
    private List<BFM_Shipment__c> upsertShipments;
    private List<BFM_Stage__c> upsertStages;
    Public  List<BFM_NF_e__c> upsertNFEs= New List<BFM_NF_e__c>();
    private List<BFM_Occurrence_SES__c> upsertSESs;
	Public List<BFM_Fiscal_Documents__c> upsertFiscalDoc= new List<BFM_Fiscal_Documents__c>();
    private Map<String, String> stagesToShipments;
    private Map<String, String> sesToSOccs;
    private List<String> errors;	
    private boolean isSuccess;
    private String errorMessage;
    private List<BFM_Error_Log__c> generatedErrors;
    private boolean isSuccess(){
        return this.isSuccess;
    }
    
    private List<String> getErrors(){
        return this.errors;
    }
    public BFM_QueryOccurrence(Set<String> occurrenceNumbers){
        this.occurrenceNumbers = new List<String>(occurrenceNumbers);
        errors = new List<String>();
        upsertOccurrences = new List<BFM_Occurrence__c>();
        upsertShipments = new List<BFM_Shipment__c>();
        upsertStages = new List<BFM_Stage__c>();
        upsertSESs = new List<BFM_Occurrence_SES__c>();
        sesToSOccs = new Map<String, String>();
        generatedErrors = new List<BFM_Error_Log__c>();
        isSuccess = true;        
    }
    public String getErrorMessage(){
        return this.errorMessage;
    }
    webservice static string callQueryOccurrenceButton(Id occurrenceId){
        BFM_Occurrence__c occ = [SELECT Occurrence_Number__c FROM BFM_Occurrence__c WHERE id=: occurrenceId LIMIT 1];
        system.debug('BFM_QueryOccurrence callQueryOccurrenceButton occ : '+occ);
        BFM_QueryOccurrence queryOcc = new BFM_QueryOccurrence(new Set<String> {occ.occurrence_Number__c});
        system.debug('BFM_QueryOccurrence callQueryOccurrenceButton occ ' + queryOcc);
        String returnMessage = Label.BFM_Occurrence_OK;
        
        try{
            queryOcc.callQueryOccurrencesCTeIssuing();
            if(!queryOcc.isSuccess()){
                
                returnMessage = queryOcc.getErrorMessage();
                system.debug(queryOcc.getErrors());
            }
        } catch(Exception ex){
            
            returnMessage =  ex.getMEssage() + ' '+ex.getStackTraceString();
            System.debug(returnMessage);
        }
        return returnMessage;
    }
    
    public List<BFM_Occurrence__c> callQueryOccurrencesCTeIssuing(){
        
        HttpResponse response = BFM_GeneralServiceCalls.requestQueryOccurrence(occurrenceNumbers,QUERY_TYPE_CTE_ISSUING);
        List<BFM_Occurrence__c> updatedOccurs;
        if(response.getStatusCode() != 200 && response.getStatusCode() != 201){
            System.debug('There was an error with the response. \n Status Code: ' + response.getStatusCode() +' \n Status Description: '+ response.getStatus()+' \n body of the response ' +response.getBody());
            createErrorLogs(occurrenceNumbers, 'Falha na integração: ' + response.getStatusCode() +' \n Status Description: '+ response.getStatus()+' \n body of the response ' +response.getBody(), 'Falha na Integração');
            errorMessage = 'Erro na integração: ' +response.getStatusCode();
            isSuccess = false;
        } else {
            //system.debug('response----->'+response);
            String jsonBodyResponse = response.getBody();
            //system.debug('JSON Body Response: ' +jsonBodyResponse);
            if( String.isEmpty(jsonBodyResponse)){
                System.debug('WARNING: null response');
                createErrorLogs(occurrenceNumbers, 'null response JSON', 'Falha na Integração');
                errorMessage = 'Null response JSON';
                isSuccess = false;
            } else{
                updatedOccurs = parseResponse(jsonBodyResponse);
                isSuccess = true;
            }
        }
        return updatedOccurs;
    }
    
    private List<BFM_Occurrence__c> parseResponse(String JSONbody){
        System.debug(JSONbody);
        //List<BFM_NF_e__c> upsertNFEs = new List<BFM_Nf_e__c>();
        Integer countOccurrence = 0;
        jsonBody = jsonBody.removeStart('"');
        jsonBody = jsonBody.removeEnd('"');
        
        BFM_QueryOccurrencesResponse response = BFM_QueryOccurrencesResponse.parse(jsonBody);       
        system.debug('BFM_Occurrence__c parseResponse ' + response.QueryOccurrenceResponse.occurrences);
        for(BFM_QueryOccurrencesResponse.Occurrences currentOcc: response.QueryOccurrenceResponse.occurrences){
            BFM_Occurrence__c newOcc = processOccurrenceFields(currentOcc);            
            upsertOccurrences.add(newOcc);
            system.debug('upsertOccurrences'+upsertOccurrences);
            system.debug('------>'+currentOcc.ses);
            
			          
            //system.debug('currentOcc.fiscalDocuments---->'+currentOcc.fiscalDocuments);
			if(currentOcc.fiscalDocuments!=null){
			for(BFM_QueryOccurrencesResponse.fiscalDocuments fsDoc: currentOcc.fiscalDocuments){
			BFM_Fiscal_Documents__c newFisDoc =  new BFM_Fiscal_Documents__c();
			newFisDoc.Fiscal_Document_Number__c=fsDoc.fiscalDocuments;
                for(BFM_QueryOccurrencesResponse.Ses sesOccNum : currentOcc.ses){
			newFisDoc.Occurrence__r= new BFM_Occurrence__c(Occurrence_Number__c = sesOccNum.occurrenceNumber);
                }
			upsertFiscalDoc.add(newFisDoc);
			}
			}
            system.debug('upsertFiscalDoc--->'+upsertFiscalDoc);
			
            for(BFM_QueryOccurrencesResponse.Ses currentSes : currentOcc.ses){
                BFM_Occurrence_SES__c newSes = processSESFields(currentSES);
                newOcc.Occurrence_Number__c = newSes.Occurrence_Number__c;
                
                upsertSESs.add(newSes);
                sesToSOccs.put(newSes.ses_number__c, newOcc.Occurrence_Number__c);
                system.debug('sesToSOccs--->'+sesToSOccs);
                if(currentSes.nfe!=null) {
                    for(BFM_QueryOccurrencesResponse.nfe currentNfe:currentSes.nfe){
                        
                        BFM_NF_e__c newNfes1=processNFeFields(currentNfe,currentSes.sesNumber);
                        //newSes.SES_Number__c=newNfe1.SES_Number__c;
                        upsertNFEs.add(newNfes1);
                    }
                }             
            }

            system.debug('upsertNFEs------>'+upsertNFEs);
        }
        callUpserts();
        return upsertOccurrences;
    }
    
    private void processOccurUpserts(Database.upsertResult[] results){
        for(Integer i = 0; i< results.size(); i++){
            if(!results[i].isSuccess()){
                BFM_Occurrence__c theOcc = upsertOccurrences[i];
                String errorMessage = 'Failed updating Occurrence: '+ theOcc.Occurrence_Number__c +' \n ';
                for(Database.Error theError : results[i].getErrors()){
                    createUpsertErrorLog(upsertOccurrences[i].Occurrence_Number__c, errorMessage + theError.getMessage());
                }
            }
        }
    }
    
    private void callUpserts(){
        if(upsertOccurrences!=null) {
            
            Database.upsertResult[] resultsOccurnce = database.upsert(upsertOccurrences,Schema.getGlobalDescribe().get('BFM_Occurrence__c')
                                                                      .getDescribe()
                                                                      .fields
                                                                      .getMap()
                                                                      .get('Occurrence_Number__c'), false);
            
            for (Database.upsertResult sr : resultsOccurnce ){
                if (sr.isSuccess()){
                    System.debug('----resultsOccurnce---'+sr);
                    System.debug('resultsOccurnce ' + sr.getId());
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        string Msg= ' The following error has occurred.'+err.getStatusCode() +': ' + err.getMessage()+' fields that affected this error: '+ err.getFields();
                        System.debug('Msg--->'+Msg);                           
                        
                    }
                }
            }														  
            processOccurUpserts(resultsOccurnce);
        }
        
        if(upsertSESs!=null){
            system.debug('upsertSESs--->'+upsertSESs);
            Database.upsertResult[] resultsSES = database.upsert(upsertSESs, Schema.getGlobalDescribe().get('BFM_Occurrence_SES__c')
                                                                 .getDescribe()
                                                                 .fields
                                                                 .getMap()
                                                                 .get('SES_Number__c'), false);
            
            for (Database.upsertResult sr : resultsSES ){
                if (sr.isSuccess()){
                    System.debug('----resultsSES---'+sr);
                    System.debug('resultsSES ' + sr.getId());
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        string Msg= ' The following error has occurred.'+err.getStatusCode() +': ' + err.getMessage()+' fields that affected this error: '+ err.getFields();
                        System.debug('Msg--->'+Msg);                           
                        
                    }
                }
            } 
            
            if(upsertNFEs!=null){
                system.debug('upsertNFEs---->'+upsertNFEs);
                Database.upsertResult[] resultsnfe = database.upsert(upsertNFEs, Schema.getGlobalDescribe().get('BFM_NF_e__c')
                                                                     .getDescribe()
                                                                     .fields
                                                                     .getMap()
                                                                     .get('NF_e_access_key__c'), false);
                for (Database.upsertResult sr : resultsnfe ){
                    if (sr.isSuccess()){
                        System.debug('----resultsnfe---'+sr);
                        System.debug('resultsnfe ' + sr.getId());
                    } else {
                        for(Database.Error err : sr.getErrors()) {
                            string Msg= ' The following error has occurred.'+err.getStatusCode() +': ' + err.getMessage()+' fields that affected this error: '+ err.getFields();
                            System.debug('nfeMsg--->'+Msg);                           
                            
                        }
                    }
                }            
            }
			      if(upsertFiscalDoc!=null){
                system.debug('upsertNFEs---->'+upsertFiscalDoc);
                Database.upsertResult[] resultsFisDoc = database.upsert(upsertFiscalDoc, Schema.getGlobalDescribe().get('BFM_Fiscal_Documents__c')
                                                                     .getDescribe()
                                                                     .fields
                                                                     .getMap()
                                                                     .get('Fiscal_Document_Number__c'), false);
                for (Database.upsertResult sr : resultsFisDoc ){
                    if (sr.isSuccess()){
                        System.debug('----resultsFisDoc---'+sr);
                        System.debug('resultsFisDocid ' + sr.getId());
                    } else {
                        for(Database.Error err : sr.getErrors()) {
                            string Msg= ' The following error has occurred.'+err.getStatusCode() +': ' + err.getMessage()+' fields that affected this error: '+ err.getFields();
                            System.debug('FisDocMsg--->'+Msg);                           
                            
                        }
                    }
                }            
            }
        }
        
        if(!generatedErrors.isEmpty()){
            database.insert(generatedErrors, false);
        }
    }
    
    private void treatValueException(Exception ex){
        
    }
    private void createErrorLogs(List<String> occurrenceNumbers, String errorMessage, String errorType){
        List<BFM_Error_Log__c> errorlogsCreated = new List<BFM_Error_Log__c>();
        for(String occNumber :occurrenceNumbers){
            BFM_Error_Log__c newError = new BFM_Error_Log__c();
            newError.BFM_Occurrence__r = new BFM_Occurrence__c(Occurrence_Number__c = occNumber);
            
            newError.Error_log__c = errorMessage;
            newError.Reason__c = errorType;
            errorLogsCreated.add(newError);
        }
        if(!errorLogsCreated.isEmpty()){
            insert errorLogsCreated;
        }
    } 
    private void createUpsertErrorLog(String occurNumber, String errorMessage){
        BFM_Error_Log__c newError = new BFM_Error_Log__c();
        newError.BFM_Occurrence__r = new BFM_Occurrence__c(Occurrence_Number__c = occurNumber);
        newError.Error_Log__c = errorMessage;
        newError.Reason__c = 'Upsert error';
        this.generatedErrors.add(newError);
    }
    
    
    private BFM_Occurrence__c processOccurrenceFields(BFM_QueryOccurrencesResponse.Occurrences currentOcc){
        BFM_Occurrence__c newOcc = new BFM_Occurrence__c();
        newOcc.Status__c = currentOcc.status;
        newOcc.Occurrence_Number__c = currentOcc.occurrenceNumber;
        newOcc.Status_Description__c = currentOcc.statusDescription;
        if(currentOcc.shipmentDocumentNumber!=''){
            newOcc.Shipment__r = new BFM_Shipment__c(Shipment_Number__c = currentOcc.shipmentDocumentNumber);
            newOcc.Shipment_Document_Number__c = currentOcc.shipmentDocumentNumber;
        }
        try{
            if(currentOcc.rangeExtentOccurrenceFrom != null && currentOcc.rangeExtentOccurrenceFrom !='0000-00-00')
                newOcc.Range_of_Extent_of_Occurrence_From__c = Date.valueof(currentOcc.rangeExtentOccurrenceFrom);
        } catch(Exception ex){
            treatValueException(ex);
        }
        try{
            if(currentOcc.rangeExtentOccurrenceTo != null && currentOcc.rangeExtentOccurrenceTo !='0000-00-00')
                newOcc.Range_of_Extent_of_Occurrence_To__c = Date.valueof(currentOcc.rangeExtentOccurrenceTo);
        } catch(Exception ex){
            treatValueException(ex);
        }
        newOcc.Equip_Type__c = currentOcc.equipType;
        newOcc.Equip_Type_description__c = currentOcc.equipTypeDescription;
        newOcc.Load_Type__c = currentOcc.loadType;
        newOcc.Load_Type_Description__c = currentOcc.loadTypeDescription;
        newOcc.Occurrence_Value__c = currentOcc.occurrenceValue;
        newOcc.Tax__c = currentOcc.tax;
        newOcc.Occurrence_Quantity__c = currentOcc.occurrenceQuantity;
        newOcc.Occurrence_Number__c = currentOcc.occurrenceNumber;
        newOcc.Reason_Code__c = currentOcc.reasonCode;
        newOcc.Reason_Description__c = currentOcc.reasonDescription;
        newOcc.Plate_Number__c = currentOcc.plateNumber;
        newOcc.Reason_for_Rejection__c = currentOcc.reasonRejection;
        newOcc.Rejection_Description__c = currentOcc.rejectionDescription;
        try{
            newOcc.Total__c = Decimal.valueOf(currentOcc.total);
        } catch(Exception ex){
            treatValueException(ex);
        }
        newOcc.Shipment_Type__c = currentOcc.shipmentType;
        newOcc.Shipping_Process__c = currentOcc.shippingProcess;
        newOcc.Shipping_Process_Description__c = currentOcc.shippingProcessDescription;
        
        try{
            if(currentOcc.approvalDate1!=null && currentOcc.approvalDate1!='0000-00-00')
                newOcc.Approval_Date_1__c = Date.valueof(currentOcc.approvalDate1);
        } catch(Exception ex){
            treatValueException(ex);
        }
        
        try{
            if(currentOcc.approvalDate2!=null && currentOcc.approvalDate2!='0000-00-00')
                newOcc.Approval_Date_2__c = Date.valueof(currentOcc.approvalDate2);
        } catch(Exception ex){
            treatValueException(ex);
        }
        
        try{
            if(currentOcc.approvalDate3!=null && currentOcc.approvalDate3!='0000-00-00')
                newOcc.Approval_Date_3__c = Date.valueof(currentOcc.approvalDate3);
        } catch(Exception ex){
            treatValueException(ex);
        }
        
        try{
            if(currentOcc.approvalDate4!=null && currentOcc.approvalDate4!='0000-00-00')
                newOcc.Approval_Date_4__c = Date.valueof(currentOcc.approvalDate4);
        } catch(Exception ex){
            treatValueException(ex);
        }
        
        try{
            if(currentOcc.approvalDate5!=null && currentOcc.approvalDate5!='0000-00-00')
                newOcc.Approval_Date_5__c = Date.valueof(currentOcc.approvalDate5);
        } catch(Exception ex){
            treatValueException(ex);
        }
        
        try{
            if(currentOcc.approvalDate6!=null && currentOcc.approvalDate6!='0000-00-00')
                newOcc.Approval_Date_6__c = Date.valueof(currentOcc.approvalDate6);
        } catch(Exception ex){
            treatValueException(ex);
        }
        //newOcc.Fiscal_Documents__c = currentOcc.fiscalDocuments.item.FISCAL_DOC;
        return newOcc;
    }
    
    private BFM_Occurrence_SES__c processSESFields(BFM_QueryOccurrencesResponse.Ses currentSes){
        BFM_Occurrence_SES__c newSes = new BFM_Occurrence_SES__c();
        newSES.Occurrence__r = new BFM_Occurrence__c(occurrence_Number__c = currentSes.occurrenceNumber); 
        system.debug('currentSes.sesNumber---->'+currentSes.sesNumber);
        newSes.SES_Number__c = currentSes.sesNumber;
        newSes.PO_Umbrella_Number__c = currentSes.poUmbrellaNumber;
        newSes.PO_Type__c = currentSes.poType;
        //public String creationDate;
        //newSes.Modification_Date__c = !String.isEmpty(currentSes.modificationDate) ? Date.valueOf(currentSes.modificationDate) : null;
        try{
            if(currentSes.modificationDate !=null)
                newSes.Modification_Date__c = Date.valueOf(currentSes.modificationDate);
        } catch(System.TypeException ex){
            treatValueException(ex);
        }
        try{
            if(currentSes.creationDate != null && currentSes.creationDate!='0000-00-00')
                newSes.Creation_Date__c= Date.valueOf(currentSes.creationDate);
        } catch(System.TypeException ex){
            treatValueException(ex);
        }
        newSes.Gross_Value_net_tax__c = convertNumber(currentSes.grossValue);
        newSes.Tax_Code__c = currentSes.taxCode;
        newSes.ICMS_Presumed_Credit__c = convertNumber(currentSes.icmsPresumedCredit);
        newSes.ICMS_ST__c = convertNumber(currentSes.icmsST);
        newSes.ICMS_Value__c= convertNumber(currentSes.icmsValue);
        newSes.ICMS_Calculation_Base__c = convertNumber(currentSes.icmsCalculationBase);
        newSes.ICMS_Aliquot__c = convertNumber(currentSes.icmsAliquot);
        newSes.PIS_Value__c = convertNumber(currentSes.pisValue);
        newSes.PIS_Calculation_Base__c = convertNumber(currentSes.pisCalculationBase);
        newSes.PIS_Aliquot__c = convertNumber(currentSes.pisAliquot);
        newSes.COFINS_Value__c = convertNumber(currentSes.cofinsValueo);
        newSes.COFINS_Calculation_Base__c = convertNumber(currentSes.cofinsCalculationBase);
        newSes.COFINS_Aliquot__c = convertNumber(currentSes.cofinsAliquot);
        newSes.Simple_Option__c = currentSes.simpleOption;
        newSes.ICMS_Reduzed_base_percentage__c = convertNumber(currentSes.icmsReduzedBasePercentage);
        newSes.ICMS_Exempt__c = currentSes.icmsExempt;
        newSes.Net_Value__c = convertNumber(currentSes.netValue);
        newSes.SES_Currency__c = currentSes.sesCurrency;
        newSes.SES_Line_Description__c = currentSes.sesLineDescription;
        newSes.Cost_Document_Number__c = currentSes.costDocumentNumber;
        newSes.Occurrence_Number__c = currentSes.occurrenceNumber;
        newSes.Acctount_Assingment_Category__c = currentSes.acctountAssingmentCategory;
        newSes.Cost_Center__c = currentSes.costCenter;
        newSes.SES_Plant_Code__c = currentSes.sesPlantCode;
        newSes.Accouting_Account__c = currentSes.accoutingAccount;
        newSes.Internal_Order__c = currentSes.internalOrder;
        newSes.ISS_Aliquot__c = currentSes.issAliquot;
        newSes.ISS_Calculation_base__c = currentSes.issCalculationBase;
        newSes.ISS_Value__c = currentSes.issValue;
        return newSes;
    }
    
    private BFM_NF_e__c processNFeFields(BFM_QueryOccurrencesResponse.NFe currentNFe, String sesnumber){
        BFM_NF_e__c newNfe = new BFM_NF_e__c(NF_e_access_key__c = currentNfe.nfeAccessKey);
        //newNfe.Delivery__r = new BFM_Delivery__c(Delivery_Number__c = currentNfe.deliveryNumber); 
     
        newNfe.Gross_weight__c = convertNumber(currentNfe.grossWeight);
        newNfe.NF_e_Total_Value__c = convertNumber(currentNfe.nfeTotalValue);
        newNfe.NF_e_number__c = currentNfe.nfeNumber;
        newNfe.NF_e_serie__c = currentNfe.nfeSerie;
        newNfe.Taker_CNPJ__c = currentNfe.cnpjTaker;
        newNfe.CNPJ_destination__c = currentNfe.cnpjDestination;
        newNfe.CPF_destination__c = currentNfe.cpfDestination.left(11);
        newNfe.Stage_registration_destination__c = currentNfe.stageRegistrationDestination;
        newNfe.Name_destination__c = currentNfe.nameDestination;
        newNfe.Phone_destination__c = currentNfe.phoneDestination;
        newNfe.Occurrence_SES__r=new BFM_Occurrence_SES__c(SES_Number__c = sesnumber);
        //newNfe.SES__r=new BFM_SES__c(SES_Number__c = sesnumber);
        newNfe.SUFRAMA_registration__c = currentNfe.inscricaoSuframa;
        newNfe.Street_destination__c = currentNfe.addressDestination;
        newNfe.Address_Number_Destination__c = currentNfe.numberDestination;
        newNfe.Complement_destination__c = currentNfe.complementDestination;
        newNfe.District_destination__c = currentNfe.districtDestination;
        newNfe.City_Code_Destination__c = currentNfe.municipalCodeDestination;
        newNfe.City_Destination__c = currentNfe.municipalNameDestination;
        newNfe.Postal_code_destination__c = currentNfe.postalCodeDestination;
        newNfe.State_destination__c = currentNfe.stateDestination;
        newNfe.Country_code_destination__c = currentNfe.countryCodeDestination;
        newNfe.Country_name_destination__c = currentNfe.countryNameDestination;
        //      public String nfeCreationDate;
        newNfe.Incoterms__c = currentNfe.incoterms;
        newNfe.Nf_e_total_quantity__c = convertNumber(currentNfe.nfeTotalQuantity);
        newNfe.NF_e_item_specie__c = currentNfe.nfeItemSpecie;
        newNfe.Predominant_product__c = currentNfe.predominantProduct;
        newNfe.Complement_destination__c = currentNfe.complementaryInformation;
        newNfe.Material_Usage__c = currentNfe.materialUsage;
        newNfe.Billing_Document__c = currentNfe.billingDocument;
	
        return newNfe;
    }
    
    private Decimal convertNumber(String textValue){
        try{
            return Decimal.valueOf(textValue);
        } catch(Exception ex){
            treatValueException(ex);
            return null;    
        }
    }
}