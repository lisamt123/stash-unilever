/**
* @author Vinicius Zanquini
* @date 24/08/2016
* @description: Class for calling the Query Freights webservice exposed by mulesoft.
* Calling the method updates the requested Shipments and objects under them (Delivery, Stage, NF-e and SES) 
* and returns a list of the Shipments' references.                                                                                    
/Class Header Starts
//Class Name:[BFM_QueryFreights]
---------------------------------------------------------------------------------------------------------------------------------
//        DateTime           |  Email_id                    |     Description
---------------------------------------------------------------------------------------------------------------------------------
//        24/08/2016        |~:vinicius.zanquini@unilever.com |    Class for calling the Query Freights webservice exposed by mulesoft.   
**/
global class BFM_QueryFreights {
    private Set<String> shipmentNumbers;
    
    private static final String QUERY_TYPE_CTE_ISSUING = 'ALL';
    global id shipid;
    // created/updated objects in result of the JSON parsing
    private List<BFM_Shipment__c> shipments;
    private List<BFM_Stage__c> stages;
    private List<BFM_SES__c> frs;
    private List<BFM_Delivery__c> deliveries;
    private List<BFM_Nf_e__c> nfes;
    private Map<String, String> mapDeliveries;   
    private boolean isSuccess;
    private String errorMessage;    
    
    private String currentShipmentNumber;
    private List<BFM_Error_Log__c> generatedErrors;
    
    public BFM_QueryFreights(Set<String> shipmentNumbers){
        System.debug('BFM_QueryFreights shipmentNumbers : ' + shipmentNumbers);
        this.shipmentNumbers = shipmentNumbers;
        shipments = new List<BFM_Shipment__c>();
        stages = new List<BFM_Stage__c>();
        frs = new List<BFM_Ses__c>();
        deliveries = new List<BFM_Delivery__c>();
        nfes = new List<BFM_NF_e__c>();
        mapDeliveries = new Map<String, String>();
        generatedErrors = new List<BFM_Error_Log__c>();        
        isSuccess = false;
    }
    
    public boolean isSuccess(){
        return this.isSuccess;
    }
    
    public String getErrorMessage(){
        return this.errorMessage;
    }
    
    webservice static string callQueryFreightsButton(Id shipmentId){
        System.debug('BFM_QueryFreights shipmentId : ' + shipmentId);
        
        BFM_Shipment__c shipment = [SELECT Shipment_Number__c FROM BFM_Shipment__c WHERE Id =:shipmentId LIMIT 1]; 
        BFM_QueryFreights queryFreights = new BFM_QueryFreights(new Set<String>{shipment.Shipment_Number__c});
        
        String returnMessage = Label.BFM_Freight_Ok;
        try{
            queryFreights.callQueryFreightsCTeIssuing();
            if(!queryFreights.isSuccess()){
                returnMessage = queryFreights.getErrorMessage();
            }
        } catch(Exception ex){
            returnMessage =  ex.getMEssage() + ' '+ex.getStackTraceString();
        }
        return returnMessage;
    }
    
    
    public List<BFM_Shipment__c> callQueryFreightsCTeIssuing(){
        
        HttpResponse response = BFM_GeneralServiceCalls.requestQueryFreights(shipmentNumbers, QUERY_TYPE_CTE_ISSUING);
        
        List<BFM_Shipment__c> updatedShipments;
        if(response.getStatusCode() != 200 && response.getStatusCode() != 201){
            System.debug('There was an error with the response. \n Status Code: ' + response.getStatusCode() +' \n Status Description: '+ response.getStatus()+' \n body of the response ' +response.getBody());
            createErrorLogs(shipmentNumbers, 'Falha na integração: ' + response.getStatusCode() +' \n Status Description: '+ response.getStatus()+' \n body of the response ' +response.getBody(), 'Falha na Integração');
            errorMessage = 'Erro na integração: ' +response.getStatusCode();
            isSuccess = false;
        } else {
            String jsonBodyResponse = response.getBody();

            if(String.isEmpty(jsonBodyResponse)){
                System.debug('WARNING: null response');
                createErrorLogs(shipmentNumbers, 'null response JSON', 'Falha na Integração');
                errorMessage = 'Null response JSON';
                isSuccess = false;
            }  else {
                updatedShipments = getQueryFreightsObjectsCreated(jsonBodyResponse);
                isSuccess = true;
            }
        }
        return updatedShipments;
    }
    
    private List<BFM_Shipment__c> getQueryFreightsObjectsCreated(String JSONbody){
        System.debug(jsonBody);
        jsonBody = jsonBody.removeStart('"');
        jsonBody = jsonBody.removeEnd('"');
        
        BFM_QueryFreightsResponse response = BFM_QueryFreightsResponse.parse(jsonBody);
        if(response.QueryFreightResponse.message != null) {
            System.debug('WARNING: Something is not ok in the message');
            createErrorLogs(shipmentNumbers, response.QueryFreightResponse.message, 'Falha no Shipment');
        }
        
        if(response.QueryFreightResponse.Shipment != null) {
            for(BFM_QueryFreightsResponse.Shipment ship: response.QueryFreightResponse.Shipment) {
                BFM_Shipment__c newShipment = parseShipment(ship); 
                currentShipmentNumber = newShipment.shipment_number__c;
                newShipment.Last_Shipment_Update__c = System.now();
                shipments.add(newShipment); 
                system.debug('shipments: ' + shipments);
                if(ship.stage != null){
                    for(BFM_QueryFreightsResponse.Stage stage: ship.stage) {                
                        BFM_Stage__c newStage = parseStage(stage, newShipment.Shipment_Number__c);
                        newStage.Shipping_Type__c = stage.shippingType;
                        newStage.Warehouse__c = stage.warehouse;                        
                        stages.add(newStage);   
                        System.debug('stages: ' + stages);
                        if(stage.ses != null) {
                            for(BFM_QueryFreightsResponse.Ses ses : stage.ses) {
                                BFM_SES__c newSes = parseSes(ses, newStage.Stage_Number__c, newShipment.Shipment_Number__c);
                                if(newSes.SES_Number__c != '') {
                                    frs.add(newSes);
                                }
                                System.debug('frs: ' + frs);
                                if(ses.nfe != null){
                                    for(BFM_QueryFreightsResponse.Nfe nfe : ses.nfe) {
                                        if(!mapDeliveries.containsKey(nfe.deliveryNumber)) {
                                            mapDeliveries.put(nfe.deliveryNumber, nfe.deliveryNumber);
                                            BFM_Delivery__c relatedDelivery = createDelivery(nfe.deliveryNumber, newStage.stage_number__c, newShipment.Shipment_Number__c);
                                            deliveries.add(relatedDelivery);   
                                            System.debug('deliveries: ' + deliveries);
                                        }
                                        BFM_NF_e__c newNfe = parseNFe(nfe, ses.sesNumber, newShipment.shipment_Number__c);
                                        if(newNfe.NF_e_access_key__c != ''){
                                            nfes.add(newNfe);
                                        }
                                        System.debug('nfes: ' + nfes);
                                    }
                                }
                            }
                        }
                    }   
                }
            }
        }
        callUpserts();
        return shipments;
    }
    
    private void processShipmentUpserts(Database.upsertResult[] results){
        for(Integer i = 0; i< results.size(); i++){
            if(!results[i].isSuccess()){
                BFM_Shipment__c theShipment = shipments[i];
                String errorMessage = 'Failed updating Shipment: '+ theShipment.Shipment_Number__c +' \n ';
                System.debug('processShipmentUpserts errorMessage ' + errorMessage);
                for(Database.Error theError : results[i].getErrors()){
                    System.debug('processShipmentUpserts theError.getMessage() ' + theError.getMessage());
                    createUpsertErrorLog(shipments[i].Shipment_Number__c, errorMessage + theError.getMessage());
                }
            }
        }
    }
    
    private void processStageUpserts(Database.upsertResult[] results){
        for(Integer i = 0; i< results.size(); i++){
            if(!results[i].isSuccess()){
                BFM_Stage__c theStage = stages[i];                
                String errorMessage = 'Failed updating Stage: ' + theStage.Stage_Number__c+' \n' ;
                System.debug('processStageUpserts errorMessage ' + errorMessage);
                System.debug('processStageUpserts stages[i].shipment__r.Shipment_Number__c ' + stages[i].shipment__r.Shipment_Number__c);
                for(Database.Error theError : results[i].getErrors()){
                    System.debug('processStageUpserts theError.getMessage() ' + theError.getMessage());
                    createUpsertErrorLog(stages[i].shipment__r.Shipment_Number__c, errorMessage+ theError.getMessage());
                }
            }
        }
    }
    
    private void processSesUpserts(Database.upsertResult[] results){
        for(Integer i = 0; i< results.size(); i++){
            if(!results[i].isSuccess()){
                BFM_SES__c theSes = frs[i];
                String errorMessage = 'Failed updating Ses' + theSes.Ses_Number__c + '\n';
                System.debug('processSesUpserts errorMessage ' + errorMessage);     
                System.debug('processSesUpserts frs[i].Shipment__r.Shipment_Number__c ' + frs[i].Shipment__r.Shipment_Number__c);
                for(Database.Error theError : results[i].getErrors()){
                    System.debug('processSesUpserts theError.getMessage() ' + theError.getMessage());
                    createUpsertErrorLog(frs[i].Shipment__r.Shipment_Number__c, errorMessage + theError.getMessage());
                }
            }
        }
    }
    
    private void processDeliveryUpserts(Database.upsertResult[] results){
        for(Integer i = 0; i< results.size(); i++){
            if(!results[i].isSuccess()){
                BFM_Delivery__c theDeliveries = deliveries[i];
                String errorMessage = 'Failed updating Deliveries:' +theDeliveries.delivery_number__c + '\n ';
                System.debug('processDeliveryUpserts errorMessage ' + errorMessage);
                System.debug('processDeliveryUpserts deliveries[i].Shipment__r.Shipment_Number__c ' + deliveries[i].Shipment__r.Shipment_Number__c);
                for(Database.Error theError : results[i].getErrors()){
                    System.debug('processDeliveryUpserts theError.getMessage() ' + theError.getMessage());
                    createUpsertErrorLog(deliveries[i].Shipment__r.Shipment_Number__c, errorMessage + theError.getMessage());
                }
            }
        }
    }

    private void processNfeUpserts(Database.upsertResult[] results){
        for(Integer i = 0; i< results.size(); i++){
            if(!results[i].isSuccess()){
                BFM_NF_e__c theNfes = nfes[i];
                String errorMessage = 'Failed updating Nfes:' + theNfes.NF_e_access_key__c + '\n ';
                System.debug('processNfeUpserts errorMessage ' + errorMessage);
                System.debug('processNfeUpserts nfes[i].Shipment__r.Shipment_Number__c ' + nfes[i].Shipment__r.Shipment_Number__c);
                for(Database.Error theError : results[i].getErrors()){
                    System.debug('processNfeUpserts theError.getMessage() ' + theError.getMessage());
                    createUpsertErrorLog(nfes[i].Shipment__r.Shipment_Number__c, errorMessage + theError.getMessage());
                }
            }
        }
    }    
    
    private void callUpserts(){
        if(shipments != null) {
            Database.upsertResult[] resultsShipment = database.upsert(shipments,Schema.getGlobalDescribe().get('BFM_Shipment__c')
                                                                      .getDescribe()
                                                                      .fields
                                                                      .getMap()
                                                                      .get('Shipment_Number__c'), false);
            processShipmentUpserts(resultsShipment);
        }
        
        if(stages != null) {
            Database.upsertResult[] resultsStage = database.upsert(stages, Schema.getGlobalDescribe().get('BFM_Stage__c')
                                                                   .getDescribe()
                                                                   .fields
                                                                   .getMap()
                                                                   .get('Stage_Number__c'), false); 
            processStageUpserts(resultsStage);
        }
        
        if(deliveries != null){
            Database.upsertResult[] resultsDelivery = database.upsert(deliveries,Schema.getGlobalDescribe().get('BFM_Delivery__c')
                                                                      .getDescribe()
                                                                      .fields
                                                                      .getMap()
                                                                      .get('Delivery_Number__c'), false);
            
            processDeliveryUpserts(resultsDelivery);
        }        
        
        if(frs != null) {
            Database.upsertResult[] resultsSES = database.upsert(frs, Schema.getGlobalDescribe().get('BFM_SES__c')
                                                                 .getDescribe()
                                                                 .fields
                                                                 .getMap()
                                                                 .get('SES_Number__c'), false);
            
            processSesUpserts(resultsSES);
        }
        
        if(nfes!=null){
            Database.upsertResult[] resultsNFe = database.upsert(nfes, Schema.getGlobalDescribe().get('BFM_NF_e__c')
                                                                 .getDescribe()
                                                                 .fields
                                                                 .getMap()
                                                                 .get('NF_e_access_key__c'), false);
            
            processNfeUpserts(resultsNFe);
        }
        
        if(!generatedErrors.isEmpty()){
            database.insert(generatedErrors, false);
        }
    }
    
    /*
    * Creates an error log related to the shipment being currently processed
    * */
    private void treatTypeException(System.TypeException ex){
        System.debug('treatTypeException getStackTraceString: ' + ex.getStackTraceString());
        BFM_Error_Log__c newError = new BFM_Error_Log__c();
        newError.BFM_Shipment__r = new BFM_Shipment__c(Shipment_Number__c = this.currentShipmentNumber);
        newError.Error_log__c = ex.getMessage() + ' ' + ex.getTypeName() +' ';
        newError.Reason__c = 'Type Error';
        this.generatedErrors.add(newError);
    }
    
    private void createUpsertErrorLog(String shipmentNumber, String errorMessage){
        BFM_Error_Log__c newError = new BFM_Error_Log__c();
        newError.BFM_Shipment__r = new BFM_Shipment__c(Shipment_Number__c = shipmentNumber);
        newError.Error_Log__c = errorMessage;
        newError.Reason__c = 'Upsert error';
        this.generatedErrors.add(newError);
    }
    
    private void createErrorLogs(Set<String> shipmentNumbers, String errorMessage, String errorType){
        for(String shipNumber :shipmentNumbers) {
            BFM_Error_Log__c newError = new BFM_Error_Log__c();
            newError.BFM_Shipment__r = new BFM_Shipment__c(Shipment_Number__c = shipNumber);
            newError.Error_log__c = errorMessage;
            newError.Reason__c = errorType;
            this.generatedErrors.add(newError);
        }
    }
    
    private BFM_Shipment__c parseShipment(BFM_QueryFreightsResponse.Shipment ship ){
        BFM_Shipment__c newShipment = new BFM_Shipment__c(Shipment_Number__c = ship.shipmentNumber);
        newShipment.Shipment_Type__c = ship.shipmentType;
        newShipment.ANTT__c = ship.antt;
        newShipment.Vehicle_Plate__c = ship.vehicleplt;
        
        try{
            if(ship.shipmentStart !=null)
                newShipment.Shipment_Start__c = Date.valueOf(ship.shipmentStart);
        } catch(System.TypeException ex){
            treatTypeException(ex);
        }
        
        try{
            if(ship.pricingCalculationDate != null && ship.pricingCalculationDate != '')
                newShipment.Pricing_Calculation_Date__c = Date.valueOf(ship.pricingCalculationDate);
        } catch(System.TypeException ex){
            treatTypeException(ex);
        }
        
        return newShipment;
    }
    
    private BFM_Stage__c parseStage(BFM_QueryFreightsResponse.Stage stage, String shipmentNumber){
        BFM_Shipment__c shipment = new BFM_Shipment__c(Shipment_Number__c = shipmentNumber);
        BFM_Stage__c newStage = new BFM_Stage__c();
        newStage.shipment__r = shipment;
        newStage.Origin_city__c = stage.originCity;
        newStage.Origin_postal_code__c = stage.originPostalCode;
        newStage.Origin_country__c = stage.originCountry.left(3);
        newStage.Origin_plant_code__c = stage.originPlantCode.left(4);
        newStage.Origin_plant_description__c = stage.originPlantDescription;
        newStage.Destination_city__c = stage.destinationCity;
        newStage.Destination_postal_code__c = stage.destinationPostalCode;
        newStage.Destination_country__c = stage.destinationCountry.left(3);
        newStage.Load_type__c = stage.loadType;
        newStage.OTM_Shipment__c = stage.otmshipment;
        newStage.Shipping_process__c = stage.shippingProcess;
        newStage.Shipping_Type__c = stage.shipngtype;
        newStage.Delivery_system__c = stage.deliverySystem;
        newStage.Load_FM__c = stage.loadFM;
        newStage.Equip_Type__c = stage.equipType;
        newStage.Grouping__c = stage.grouping.left(2);
        newStage.Pallet_count__c = stage.palletCount;
        newStage.Gross_value_from_cost_preview__c = stage.grossValueCostPreview;
        newStage.Toll_from_cost_preview__c = stage.tollCostPreview;
        newStage.Distance__c = stage.distance;
        newStage.Free_freight__c = stage.freeFreight;
        newStage.stage_number__c = shipmentNumber + String.valueOf(stage.stageNumber);
        newStage.Stage_Number_Only__c = String.valueOf(stage.stageNumber);
        return newStage;
    }    
    
    private BFM_SES__c parseSes(BFM_QueryFreightsResponse.Ses ses, String stageNumber, String shipmentNumber){
        BFM_SES__c newSes = new BFM_SES__c();
        newSes.stage__r = new BFM_Stage__c(stage_number__c = stageNumber);
        newSes.ses_number__c = ses.sesNumber;
        newSes.PO_Umbrella_Number__c = ses.poUmbrellaNumber;
        newSes.PO_Type__c = ses.poType;
        newSes.Shipment__r = new BFM_Shipment__c (Shipment_Number__c = shipmentNumber);
        
        try{
            System.debug('ses.modificationDate' + ses.modificationDate);
            if(ses.modificationDate != null && ses.modificationDate!= '')
                newSes.Modification_Date__c = Date.valueOf(ses.modificationDate);
        } catch(System.TypeException ex){
            treatTypeException(ex);
        }
        
        try{
            System.debug('ses.creationDate' + ses.creationDate);
            if(ses.creationDate != null && ses.creationDate!='')
                newSes.Creation_Date__c = Date.valueOf(ses.creationDate);
        } catch(System.TypeException ex){
            treatTypeException(ex);
        }
        
        newSes.Gross_Value_net_tax__c = ses.grossValue;
        newSes.Tax_Code__c = ses.taxCode;
        newSes.ICMS_Presumed_Credit__c = ses.icmsPresumedCredit;
        newSes.icms_ST__c = ses.icmsST;
        newSes.ICMS_Value__c = ses.icmsValue;
        newSes.ICMS_Calculation_Base__c = ses.icmsCalculationBase;
        newSes.ICMS_Aliquot__c = ses.icmsAliquot;
        newSes.PIS_Value__c = ses.pisValue;
        newSes.PIS_Calculation_Base__c = ses.pisCalculationBase;
        newSes.PIS_Aliquot__c = ses.pisAliquot;
        newSes.COFINS_Value__c = ses.cofinsValue;
        newSes.COFINS_Calculation_Base__c = ses.cofinsCalculationbase;
        newSes.COFINS_Aliquot__c = ses.cofinsAliquot;
        newSes.Simple_Option__c = ses.simpleOption.left(1);
        newSes.ICMS_Reduzed_base_percentage__c = ses.icmsReduzedBasePercentage;
        newSes.ICMS_Exempt__c = ses.icmsExempt;
        newSes.Net_Value__c = ses.netValue;
        newSes.SES_Currency__c = ses.sesCurrency.left(5);
        newSes.SES_Line_Description__c = ses.sesLineDescription;
        newSes.Cost_Document_Number__c = ses.costDocumentNumber;
        newSes.Occurrence_Number__c = ses.occurrenceNumber;
        newSes.Acctount_Assingment_Category__c = ses.acctountAssingmentCategory.left(1);
        newSes.Cost_Center__c = ses.costCenter;
        newSes.SES_Plant_Code__c = ses.sesPlantCode.left(4);
        newSes.Accouting_Account__c = ses.accoutingAccount;
        newSes.Internal_Order__c = ses.internalOrder;
        newSes.ISS_Aliquot__c = ses.issAliquot;
        newSes.ISS_Calculation_base__c = ses.issCalculationBase;
        newSes.ISS_Value__c = ses.issValue;
        return newSes;
    }
    
    private BFM_Delivery__c createDelivery(String deliveryNumber, String stageNumber, String shipmentNumber) {
        BFM_Delivery__c delivery = new BFM_Delivery__c();
        delivery.Delivery_Number__c = deliveryNumber;
        delivery.stage__r = new BFM_Stage__c (Stage_Number__c = stageNumber);     
        delivery.Shipment__r = new BFM_Shipment__c (Shipment_Number__c = shipmentNumber);
        return delivery;
    }
    
    private BFM_NF_e__c parseNFe(BFM_QueryFreightsResponse.Nfe nfe, String sesnumber, String shipmentNumber){
        BFM_Delivery__c delivery = new BFM_Delivery__c(Delivery_Number__c = nfe.deliveryNumber);
        BFM_NF_e__c newNfe = new BFM_NF_e__c();
        newNfe.NF_e_access_key__c = nfe.nfeAccessKey;   
        newNfe.NF_e_Total_Value__c = nfe.nfeTotalValue;
        newNfe.Delivery__r = delivery; 
        newNfe.shipment__r = new BFM_Shipment__c(Shipment_Number__c = shipmentNumber); 
        newNfe.NF_e_number__c = nfe.nfeNumber;
        newNfe.NF_e_number__c = nfe.nfeNumber;
        newnfe.NF_e_serie__c = nfe.nfeSerie;
        newNfe.Taker_CNPJ__c = nfe.cnpjTaker;
        newNfe.CNPJ_destination__c = nfe.cnpjDestination;
        newNfe.CPF_destination__c = nfe.cpfDestination;
        newNfe.State_registration_destination__c = nfe.stageRegistrationDestination;
        newNfe.Name_destination__c = nfe.nameDestination;
        newNfe.Phone_destination__c = nfe.phoneDestination;
        newNfe.SUFRAMA_registration__c = nfe.inscricaoSUFRAMA;
        newNfe.Street_Destination__c = nfe.addressDestination;
        newNfe.Address_Number_Destination__c = nfe.numberDestination;
        newNfe.Complementary_information__c = nfe.complementaryInformation;
        
        if(sesnumber != ''){
            newNfe.SES__r = new BFM_SES__c(SES_Number__c = sesnumber);   
        }
        
        newNfe.Complement_destination__c = nfe.complementDestination;
        newNfe.District_destination__c = nfe.districtDestination;
        newNfe.Gross_weight__c=nfe.grossWeight;
        newNfe.City_Code_Destination__c = nfe.municipalCodeDestination;
        newNfe.City_Destination__c = nfe.municipalNameDestination;
        newNfe.Postal_code_destination__c = nfe.postalCodeDestination;
        newNfe.State_destination__c = nfe.stateDestination;
        newNfe.Country_code_destination__c = nfe.countryCodeDestination.left(3);
        newNfe.Country_name_destination__c = nfe.countryNameDestination;
        
        try{
            if(nfe.nfeCreationDate != null && nfe.nfeCreationDate != '')
            newNfe.NF_e_creation_date__c = Date.valueOf(nfe.nfeCreationDate);
        } catch(System.TypeException ex){
            treatTypeException(ex);    
        }
        
        newNfe.Incoterms__c = nfe.incoterms.left(3);
        newNfe.Nf_e_total_quantity__c = nfe.nfeTotalQuantity;
        newNfe.NF_e_item_specie__c = nfe.nfeItemSpecie.left(2);
        newNfe.Predominant_product__c = nfe.predominantProduct;
        newNfe.Material_Usage__c = nfe.materialUsage.left(1);
        return newNFe;
    }
}