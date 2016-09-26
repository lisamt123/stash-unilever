public class BFM_QueryOccurrence {

    private List<String> occurrenceNumbers;
    
    public BFM_QueryOccurrence(Set<String> occurrenceNumbers){
    	this.occurrenceNumbers = new List<String>(occurrenceNumbers);
        
    }
    
    public boolean callQueryOccurrencesCTeIssuing(){
        BFM_QueryOccurrencesRequest request = new BFM_QueryOccurrencesRequest(occurrenceNumbers, 'CT-e');
        boolean querySuccessful = true;
        HttpResponse integrationResponse = BFM_GeneralServiceCalls.requestQueryOccurrence(request);
        if(integrationResponse.getStatusCode() == 200){
            BFM_QueryOccurrencesResponse queryOccurrenceResponse = BFM_QueryOccurrencesResponse.parse(integrationResponse.getBody());
            parseResponse(queryOccurrenceResponse);
            querySuccessful = true;
        } else{
            querySuccessful = false;
            createErrorLogs(occurrenceNumbers, 'Falha na integração: ' + integrationResponse.getStatusCode() +
                            					' \n Status Description: '+ integrationResponse.getStatus()+
                            					' \n body of the response ' +integrationResponse.getBody(),
                            	'Falha na Integração');
        }
        
        return querySuccessful;
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
    
    public List<BFM_Occurrence__c> parseResponse(BFM_QueryOccurrencesResponse queryResponse){
        List<BFM_Occurrence__c> upsertOccurrences = new List<BFM_Occurrence__c>();
        List<BFM_SES__c> upsertSESs = new List<BFM_SES__c>();
        List<BFM_NF_e__c> upsertNFEs = new List<BFM_Nf_e__c>();
        Integer countOccurrence = 0;
        for(BFM_QueryOccurrencesResponse.Occurrences currentOcc: queryResponse.QueryOccurrenceResponse.occurrences){
            BFM_Occurrence__c newOcc = processOccurrenceFields(currentOcc);
            upsertOccurrences.add(newOcc);
            for(BFM_QueryOccurrencesResponse.Ses currentSes : currentOcc.ses){
                BFM_SES__c newSes = processSESfields(currentSES);
				upsertSESs.add(newSes);    				
                for(BFM_QueryOccurrencesResponse.Nfe currentNfe : currentSES.nfe){
                    BFM_NF_e__c newNfe = processNFeFields(currentNfe);
                    upsertNFEs.add(newNfe);
                }
            }
            
            countOccurrence++;
        }
        
        Database.upsert(upsertOccurrences, Schema.getGlobalDescribe().get('BFM_Occurrence__c')
                        									.getDescribe()
                        									.fields
                        									.getMap()
                        									.get('Occurrence_Number__c'), true);
        Database.upsert(upsertOccurrences, Schema.getGlobalDescribe().get('BFM_SES__c')
                        									.getDescribe()
                        									.fields
                        									.getMap()
                        									.get('SES_Number__c'), true);
        Database.upsert(upsertNFEs, Schema.getGlobalDescribe().get('BFM_NF_e__c')
                       										  .getDescribe()
                       										  .fields
                       										  .getMap()
                                                              .get('NF_e_access_key__c'), true);
        return upsertOccurrences;
    }
    
    private void treatValueException(Exception ex){
        
    }
    
    private BFM_NF_e__c processNFeFields(BFM_QueryOccurrencesResponse.NFe currentNFe){
        BFM_NF_e__c newNfe = new BFM_NF_e__c(NF_e_access_key__c = currentNfe.nfeAccessKey);
        newNfe.Delivery__r = new BFM_Delivery__c(Delivery_Number__c = currentNfe.deliveryNumber);
        
        newNfe.Gross_weight__c = convertNumber(currentNfe.grossWeight);
        newNfe.NF_e_Total_Value__c = convertNumber(currentNfe.nfeTotalValue);
        newNfe.NF_e_number__c = currentNfe.nfeNumber;
        newNfe.NF_e_serie__c = currentNfe.nfeSerie;
        newNfe.Taker_CNPJ__c = currentNfe.cnpjTaker;
        newNfe.CNPJ_destination__c = currentNfe.cnpjDestination;
        newNfe.CPF_destination__c = currentNfe.cpfDestination;
        newNfe.Stage_registration_destination__c = currentNfe.stageRegistrationDestination;
        newNfe.Name_destination__c = currentNfe.nameDestination;
        newNfe.Phone_destination__c = currentNfe.phoneDestination;
        newNfe.SUFRAMA_registration__c = currentNfe.inscricaoSuframa;
        newNfe.Address_destination__c = currentNfe.addressDestination;
        newNfe.Number_destination__c = currentNfe.numberDestination;
        newNfe.Complement_destination__c = currentNfe.complementDestination;
        newNfe.District_destination__c = currentNfe.districtDestination;
        newNfe.Municipal_code_destination__c = currentNfe.municipalCodeDestination;
        newNfe.Municipal_Name_Destination__c = currentNfe.municipalNameDestination;
        newNfe.Postal_code_destination__c = currentNfe.postalCodeDestination;
        newNfe.State_destination__c = currentNfe.stateDestination;
        newNfe.Country_code_destination__c = currentNfe.countryCodeDestination;
        newNfe.Country_name_destination__c = currentNfe.countryNameDestination;
//		public String nfeCreationDate;
		newNfe.Incoterms__c = currentNfe.incoterms;
        newNfe.Nf_e_total_quantity__c = convertNumber(currentNfe.nfeTotalQuantity);
        newNfe.NF_e_item_specie__c = currentNfe.nfeItemSpecie;
        newNfe.Predominant_product__c = currentNfe.predominantProduct;
        newNfe.Complement_destination__c = currentNfe.complementaryInformation;
        newNfe.Material_Usage__c = currentNfe.materialUsage;
        newNfe.Billing_Document__c = currentNfe.billingDocument;
        return newNfe;
    }
    
    private BFM_Occurrence__c processOccurrenceFields(BFM_QueryOccurrencesResponse.Occurrences currentOcc){
        BFM_Occurrence__c newOcc = new BFM_Occurrence__c();
        newOcc.Status__c = currentOcc.status;
        newOcc.Status_Description__c = currentOcc.statusDescription;
        newOcc.Shipment_Document_Number__c = currentOcc.shipmentDocumentNumber;
        newOcc.Range_of_Extent_of_Occurrence_From__c = currentOcc.rangeExtentOccurrenceFrom != null ? Date.valueOf(currentOcc.rangeExtentOccurrenceFrom) : null;
        newOcc.Range_of_Extent_of_Occurrence_To__c = currentOcc.rangeExtentOccurrenceTo != null ?  Date.valueOf(currentOcc.rangeExtentOccurrenceTo) : null;
        newOcc.Equip_Type__c = currentOcc.equipType;
        newOcc.Equip_Type_description__c = currentOcc.equipTypeDescription;
        newOcc.Load_Type__c = currentOcc.loadType;
		newOcc.Load_Type_Description__c = currentOcc.loadTypeDescription;
		newOcc.Occurrence_Value__c = currentOcc.occurrenceValue;
        newOcc.Tax__c = currentOcc.tax;
        newOcc.Occurrence_Quantity__c = currentOcc.occurrenceQuantity;
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
        
			//public String deliverySystem;
			//public String deliverySystemDescription;
		newOcc.Approval_Date_1__c = (currentOcc.approvalDate1 != null) ? Date.valueOf(currentOcc.approvalDate1) : null;
        newOcc.Approval_Date_2__c = (currentOcc.approvalDate2 != null) ? Date.valueOf(currentOcc.approvalDate2) : null;
        newOcc.Approval_Date_3__c = (currentOcc.approvalDate3 != null) ? Date.valueOf(currentOcc.approvalDate3) : null;
        newOcc.Approval_Date_4__c = (currentOcc.approvalDate4 != null) ? Date.valueOf(currentOcc.approvalDate4) : null;
        newOcc.Approval_Date_5__c = (currentOcc.approvalDate5 != null) ? Date.valueOf(currentOcc.approvalDate5) : null;
        newOcc.Approval_Date_6__c = (currentOcc.approvalDate6 != null) ? Date.valueOf(currentOcc.approvalDate6) : null;
		newOcc.Fiscal_Documents__c = (currentOcc.fiscalDocuments != null) ? Date.valueOf(currentOcc.fiscalDocuments) : null;
        return newOcc;
    }
    
    private BFM_SES__c processSESFields(BFM_QueryOccurrencesResponse.Ses currentSes){
        BFM_SES__c newSes = new BFM_SES__c();
        newSES.Occurrence__r = new BFM_Occurrence__c(occurrence_Number__c = currentSes.occurrenceNumber); 
        newSes.SES_Number__c = currentSes.sesNumber;
        newSes.PO_Umbrella_Number__c = currentSes.poUmbrellaNumber;
        newSes.PO_Type__c = currentSes.poType;
        //public String creationDate;
        newSes.Modification_Date__c = currentSes.modificationDate;
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
        newSes.COFINS_Value__c = convertNumber(currentSes.cofinsValue);
        newSes.COFINS_Calculation_Base__c = convertNumber(currentSes.cofinsCalculationBase);
        newSes.COFINS_Aliquot__c = convertNumber(currentSes.cofinsAliquot);
        newSes.Simple_Option__c = currentSes.simpleOption;
        newSes.ICMS_Reduzed_base_percentage__c = convertNumber(currentSes.icmsReduzedBasePercentage);
        newSes.ICMS_Exempt__c = convertNumber(currentSes.icmsExempt);
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
        return newSes;
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