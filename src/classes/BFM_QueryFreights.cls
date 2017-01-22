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
    private Map<String, String> stagesToShipments;
    private List<BFM_SES__c> sess;
    private Map<String, String> sesToShipments;
    private Map<String, BFM_Delivery__c> deliveriesByNumber = new Map<String, BFM_Delivery__c>();
    private Map<String, String> deliveriesToShipments;
    private List<BFM_Nf_e__c> nfes;
    private Map<String, String> nfesToShipments;
    private boolean isSuccess;
    private String errorMessage;    
    
    private String currentShipmentNumber;
    //private string whouse;
    private List<BFM_Error_Log__c> generatedErrors;
    
    public BFM_QueryFreights(Set<String> shipmentNumbers){
        this.shipmentNumbers = shipmentNumbers;
        shipments = new List<BFM_Shipment__c>();
        stages = new List<BFM_Stage__c>();
        stagesToShipments = new Map<String, String>();
        sess = new List<BFM_Ses__c>();
        sesToShipments = new Map<String, String>();
        deliveriesByNumber = new Map<String, BFM_Delivery__c>();
        deliveriesToShipments = new Map<String, String>();
        nfes = new List<BFM_NF_e__c>();
        nfesToShipments = new Map<String, String>();
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
        //shipid = shipmentId;
        
        BFM_Shipment__c shipment = [SELECT Shipment_Number__c FROM BFM_Shipment__c WHERE Id= :shipmentId LIMIT 1]; 
        BFM_QueryFreights queryFreights = new BFM_QueryFreights(new Set<String>{shipment.Shipment_Number__c});
        
        String returnMessage = 'Documento de Transporte atualizado';
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
    
    
    public  List<BFM_Shipment__c> callQueryFreightsCTeIssuing(){
        
        HttpResponse response = BFM_GeneralServiceCalls.requestQueryFreights(shipmentNumbers, QUERY_TYPE_CTE_ISSUING);
        
        List<BFM_Shipment__c> updatedShipments;
        if(response.getStatusCode() != 200 && response.getStatusCode() != 201){
            System.debug('There was an error with the response. \n Status Code: ' + response.getStatusCode() +' \n Status Description: '+ response.getStatus()+' \n body of the response ' +response.getBody());
            createErrorLogs(shipmentNumbers, 'Falha na integração: ' + response.getStatusCode() +' \n Status Description: '+ response.getStatus()+' \n body of the response ' +response.getBody(), 'Falha na Integração');
            errorMessage = 'Erro na integração: ' +response.getStatusCode();
            isSuccess = false;
        } else{
            //system.debug('response----->'+response);
            String jsonBodyResponse = response.getBody();
            //system.debug('JSON Body Response: ' +jsonBodyResponse);
            if( String.isEmpty(jsonBodyResponse)){
                System.debug('WARNING: null response');
                createErrorLogs(shipmentNumbers, 'null response JSON', 'Falha na Integração');
                errorMessage = 'Null response JSON';
                isSuccess = false;
            } else{
                updatedShipments = getQueryFreightsObjectsCreated(jsonBodyResponse);
                isSuccess = true;
            }
        }
        return updatedShipments;
    }
    @TestVisible
    private List<BFM_Shipment__c> getQueryFreightsObjectsCreated(String JSONbody){
        System.debug(jsonBody);
        jsonBody = jsonBody.removeStart('"');
        jsonBody = jsonBody.removeEnd('"');
        
        BFM_QueryFreightsResponse response = BFM_QueryFreightsResponse.parse(jsonBody);
        if(response.QueryFreightResponse.Shipment != null){
            for(BFM_QueryFreightsResponse.Shipment ship: response.QueryFreightResponse.Shipment){
                system.debug('ship:'+ship);
                BFM_Shipment__c newShipment = parseShipment(ship); 
                system.debug('NewShipment:'+newShipment);
                currentShipmentNumber = newShipment.shipment_number__c;
                if(ship.stage.get(0).originPlantCode != null) {newShipment.Origin_Plant_Code__c = ship.stage.get(0).originPlantCode.left(4);}
                shipments.add(newShipment); 
                system.debug('shipments data:'+shipments);
                if(ship.stage != null){
                    for(BFM_QueryFreightsResponse.Stage stage: ship.stage){                
                        BFM_Stage__c newStage = parseStage(stage, newShipment.Shipment_Number__c);
                        system.debug('newStage:'+newStage);
                        newStage.Shipping_Type__c = stage.shippingType;
                        newStage.Warehouse__c = stage.warehouse;
                        
                        stages.add(newStage);   
                        system.debug('stages:'+stages);
                        stagesToShipments.put(newStage.Stage_Number__c, newShipment.Shipment_Number__c);
                        if(stage.ses != null){
                            for(BFM_QueryFreightsResponse.Ses ses : stage.ses){
                                system.debug('ses:'+ses);
                                BFM_SES__c newSes = parseSes(ses, newStage.Stage_Number__c, newShipment.Shipment_Number__c);
                                system.debug('newSes:'+newSes);                                
                                sess.add(newSes);
                                system.debug('sess:'+sess);
                                sesToShipments.put(newSes.ses_number__c, newShipment.Shipment_Number__c);
                                system.debug('sesToShipments:'+sesToShipments);
                                if(ses.nfe != null){
                                    for(BFM_QueryFreightsResponse.Nfe nfe : ses.nfe){
                                        system.debug('nfe:'+nfe);
                                        system.debug('sess:11'+ses.sesNumber);
                                        BFM_NF_e__c newNfe = parseNFe(nfe, ses.sesNumber,newShipment.shipment_Number__c);
                                        system.debug('newNfe:'+newNfe);
                                        BFM_Stage__c relatedStage = newStage;
                                        BFM_Delivery__c relatedDelivery = new BFM_Delivery__c();
                                        relatedDelivery.Delivery_Number__c = nfe.deliveryNumber;
                                        relatedDelivery.stage__r = new BFM_Stage__c (Stage_Number__c = newStage.stage_number__c);
                                        deliveriesByNumber.put(nfe.deliveryNumber, relatedDelivery);
                                        deliveriesToShipments.put(relatedDelivery.Delivery_Number__c, newShipment.Shipment_Number__c);
                                        nfes.add(newNfe);
                                        system.debug('nfes:'+nfes);
                                        nfesToShipments.put(newNfe.NF_e_access_key__c, newShipment.Shipment_Number__c);  
                                        system.debug('nfesToShipments:'+nfesToShipments);
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
                for(Database.Error theError : results[i].getErrors()){
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
                for(Database.Error theError : results[i].getErrors()){
                    createUpsertErrorLog(stagesToShipments.get(theStage.Stage_Number__c), errorMessage+ theError.getMessage());
                }
            }
        }
    }
    
    private void processSesUpserts(Database.upsertResult[] results){
        for(Integer i = 0; i< results.size(); i++){
            if(!results[i].isSuccess()){
                String errorMessage = 'Failed updating Shipment: \n ';
                BFM_Stage__c theStage = stages[i];
                for(Database.Error theError : results[i].getErrors()){
                    createUpsertErrorLog(stagesToShipments.get(theStage.Stage_Number__c), 'Failed updating Shipment ' + theError.getMessage());
                }
            }
        }
    }
    @TestVisible
    private void callUpserts(){
        // upserts using Shipment_Number__c as external Id
        
        if(shipments!=null) {
            Database.upsertResult[] resultsShipment = database.upsert(shipments,Schema.getGlobalDescribe().get('BFM_Shipment__c')
                                                                      .getDescribe()
                                                                      .fields
                                                                      .getMap()
                                                                      .get('Shipment_Number__c'), false);
            processShipmentUpserts(resultsShipment);
        }
        
        if(stages!=null){
            Database.upsertResult[] resultsStage = database.upsert(stages, Schema.getGlobalDescribe().get('BFM_Stage__c')
                                                                   .getDescribe()
                                                                   .fields
                                                                   .getMap()
                                                                   .get('Stage_Number__c'), false); 
            processStageUpserts(resultsStage);
            
            for (Database.upsertResult sr : resultsStage ){
                if (sr.isSuccess()){
                    System.debug('----resultsStage---'+sr);
                    System.debug('resultsStage ' + sr.getId());
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        string Msg= ' The following error has occurred.'+err.getStatusCode() +': ' + err.getMessage()+' fields that affected this error: '+ err.getFields();
                        System.debug('Msg--->'+Msg);                           
                        
                    }
                }
                
            }
        }
        
        if(sess!=null){
            Database.upsertResult[] resultsSES = database.upsert(sess, Schema.getGlobalDescribe().get('BFM_SES__c')
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
            
        }
        
        if(deliveriesByNumber!=null){
            Database.upsertResult[] resultsDelivery = database.upsert(deliveriesByNumber.values(),Schema.getGlobalDescribe().get('BFM_Delivery__c')
                                                                      .getDescribe()
                                                                      .fields
                                                                      .getMap()
                                                                      .get('Delivery_Number__c'), false);
            
            for (Database.upsertResult sr : resultsDelivery ){
                if (sr.isSuccess()){
                    System.debug('----resultsDelivery---'+sr);
                    System.debug('resultsDelivery ' + sr.getId());
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        string Msg= ' The following error has occurred.'+err.getStatusCode() +': ' + err.getMessage()+' fields that affected this error: '+ err.getFields();
                        System.debug('Msg--->'+Msg);                           
                        
                    }
                }
            }       
            
        }
        
        if(nfes!=null){
            system.debug('nfes--->'+nfes);
            Database.upsertResult[] resultsNFe = database.upsert(nfes, Schema.getGlobalDescribe().get('BFM_NF_e__c')
                                                                 .getDescribe()
                                                                 .fields
                                                                 .getMap()
                                                                 .get('NF_e_access_key__c'), false);
            
            for (Database.upsertResult sr : resultsNFe ){
                if (sr.isSuccess()){
                    System.debug('----resultsNFe---'+sr);
                    System.debug('resultsNFe ' + sr.getId());
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        string Msg= ' The following error has occurred.'+err.getStatusCode() +': ' + err.getMessage()+' fields that affected this error: '+ err.getFields();
                        System.debug('Msg--->'+Msg);                           
                        
                    }
                }
            }
        }
        
        if(!generatedErrors.isEmpty()){
            database.insert(generatedErrors, false);
        }
    }
    
    /*
* Creates an error log related to the shipment being currently processed
* */
    private void treatTypeException(System.TypeException ex){
        BFM_Error_Log__c newError = new BFM_Error_Log__c();
        newError.BFM_Shipment__r = new BFM_Shipment__c(Shipment_Number__c = this.currentShipmentNumber);
        
        newError.Error_log__c = ex.getMessage() + ' ' + ex.getTypeName() +' ';
        newError.Reason__c = 'Type Error';
        this.generatedErrors.add(newError);
    }
    @TestVisible
    private void createUpsertErrorLog(String shipmentNumber, String errorMessage){
        BFM_Error_Log__c newError = new BFM_Error_Log__c();
        newError.BFM_Shipment__r = new BFM_Shipment__c(Shipment_Number__c = shipmentNumber);
        newError.Error_Log__c = errorMessage;
        newError.Reason__c = 'Upsert error';
        this.generatedErrors.add(newError);
    }
    @TestVisible
    private void createErrorLogs(Set<String> shipmentNumbers, String errorMessage, String errorType){
        for(String shipNumber :shipmentNumbers){
            BFM_Error_Log__c newError = new BFM_Error_Log__c();
            newError.BFM_Shipment__r = new BFM_Shipment__c(Shipment_Number__c = shipNumber);
            
            newError.Error_log__c = errorMessage;
            newError.Reason__c = errorType;
            this.generatedErrors.add(newError);
        }
    }
    
    
    //JSON Parsing into sObjects
    @TestVisible
    private BFM_Shipment__c parseShipment(BFM_QueryFreightsResponse.Shipment ship ){
        system.debug('@@@@@@@@'+ship.warehouse);
        BFM_Shipment__c newShipment = new BFM_Shipment__c(Shipment_Number__c = ship.shipmentNumber);
        newShipment.ANTT__c = ship.antt;
        try{
            if(ship.shipmentStart !=null)
                newShipment.Shipment_Start__c = Date.valueOf(ship.shipmentStart);
        } catch(System.TypeException ex){
            treatTypeException(ex);
        }
        try{
            if(ship.pricingCalculationDate != null)
                newShipment.Pricing_Calculation_Date__c = Date.valueOf(ship.pricingCalculationDate);
        } catch(System.TypeException ex){
            treatTypeException(ex);
        }
        newShipment.Shipment_Type__c = ship.shipmentType.left(4);
        newShipment.Warehouse__c = ship.warehouse;
        return newShipment;
        
    }
    @TestVisible
    private BFM_Stage__c parseStage(BFM_QueryFreightsResponse.Stage stage, String shipmentNumber){
        BFM_Shipment__c shipment = new BFM_Shipment__c(Shipment_Number__c = shipmentNumber);
        system.debug('--->'+shipment);
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
        //newStage.Free_freight__c = stage.freeFreight > 0 ? true : false;
        newStage.Free_freight__c = stage.freeFreight;
        newStage.stage_number__c = shipmentNumber + String.valueOf(stage.stageNumber);
        newStage.Stage_Number_Only__c = String.valueOf(stage.stageNumber);
        return newStage;
    }    
    @TestVisible
    private BFM_SES__c parseSes(BFM_QueryFreightsResponse.Ses ses, String stageNumber, String shipmentNumber){
        BFM_SES__c newSes = new BFM_SES__c();
        newSes.stage__r = new BFM_Stage__c(stage_number__c = stageNumber);
        newSes.ses_number__c = ses.sesNumber;
        newSes.PO_Umbrella_Number__c = ses.poUmbrellaNumber;
        newSes.PO_Type__c = ses.poType;
        newSes.Shipment__r = new BFM_Shipment__c (Shipment_Number__c = shipmentNumber);
        try{
            if(ses.modificationDate != null && ses.modificationDate!='0000-00-00')
                newSes.Modification_Date__c = Date.valueOf(ses.modificationDate);
        } catch(System.TypeException ex){
            treatTypeException(ex);
        }
        try{
            if(ses.creationDate != null && ses.creationDate!='0000-00-00')
                newSes.Creation_Date__c = Date.valueOf(ses.creationDate);
        } catch(System.TypeException ex){
            treatTypeException(ex);
        }
        newSes.Gross_Value_net_tax__c = ses.grossValue;
        //newSes.Tax_Code__c = ses.taxCode.left(2);
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
    @TestVisible
    private BFM_NF_e__c parseNFe(BFM_QueryFreightsResponse.Nfe nfe, String sesnumber,String shipmentNumber){
        BFM_Delivery__c delivery = new BFM_Delivery__c(Delivery_Number__c = nfe.deliveryNumber);
        
        BFM_NF_e__c newNfe = new BFM_NF_e__c(NF_e_access_key__c = nfe.nfeAccessKey);
        
        newNfe.NF_e_Total_Value__c = nfe.nfeTotalValue;
        newNfe.Delivery__r = delivery; 
        newNfe.shipment__r = new BFM_Shipment__c(Shipment_Number__c = shipmentNumber); 
        newNfe.NF_e_number__c = nfe.nfeNumber;
        newNfe.NF_e_number__c = nfe.nfeNumber;
        newnfe.NF_e_serie__c = nfe.nfeSerie.left(2);
        newNfe.Taker_CNPJ__c = nfe.cnpjTaker;
        newNfe.CNPJ_destination__c = nfe.cnpjDestination;
        newNfe.CPF_destination__c = nfe.cpfDestination;
        newNfe.Stage_registration_destination__c = nfe.stageRegistrationDestination;
        newNfe.Name_destination__c = nfe.nameDestination;
        newNfe.Phone_destination__c = nfe.phoneDestination;
        newNfe.SUFRAMA_registration__c = nfe.inscricaoSUFRAMA;
        newNfe.Address_destination__c = nfe.addressDestination;
        newNfe.Number_destination__c = nfe.numberDestination;
        newNfe.SES__r=new BFM_SES__c(SES_Number__c = sesnumber); 
        newNfe.Complement_destination__c = nfe.complementDestination;
        newNfe.District_destination__c = nfe.districtDestination;
        newNfe.Gross_weight__c=nfe.grossWeight;
        newNfe.Municipal_code_destination__c = nfe.municipalCodeDestination;
        newNfe.Municipal_Name_Destination__c = nfe.municipalNameDestination;
        newNfe.Postal_code_destination__c = nfe.postalCodeDestination;
        newNfe.State_destination__c = nfe.stateDestination;
        newNfe.Country_code_destination__c = nfe.countryCodeDestination.left(3);
        newNfe.Country_name_destination__c = nfe.countryNameDestination;
        
        try{
            newNfe.NF_e_creation_date__c = Date.valueOf(nfe.nfeCreationDate);
        } catch(System.TypeException ex){
            treatTypeException(ex);    
        }
        newNfe.Incoterms__c = nfe.incoterms.left(3);
        newNfe.Nf_e_total_quantity__c = nfe.nfeTotalQuantity;
        newNfe.NF_e_item_specie__c = nfe.nfeItemSpecie.left(2);
        newNfe.Predominant_product__c = nfe.predominantProduct;
        newNfe.Material_Usage__c = nfe.materialUsage.left(1);
        //public String complementaryInformation;
        return newNFe;
    }
}