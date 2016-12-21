/**
 * Class for deserializing the JSON sent by Mulesoft in response of the Query Freights (Ct-e Issuing) request.
 * It was generated using a sample JSON provided by Mulesoft team and the JSON2Apex tool http://json2apex.herokuapp.com/
 * */

public class BFM_QueryFreightsResponse_backup {

    public class Ses {
        public String sesNumber {get;set;}
        public String poUmbrellaNumber {get;set;}
        public String poType {get;set;}
        public String creationDate {get;set;}
        public String modificationDate{get;set;}
        public Decimal grossValue{get;set;}
        public String taxCode{get;set;}
        public Decimal icmsPresumedCredit{get;set;}
        public Decimal icmsST{get;set;}
        public Decimal icmsValue{get;set;}
        public Decimal icmsCalculationBase{get;set;}
        public Decimal icmsAliquot{get;set;}
        public Decimal pisValue{get;set;}
        public Decimal pisCalculationBase{get;set;}
        public Decimal pisAliquot{get;set;}
        public Decimal cofinsValue{get;set;}
        public Decimal cofinsCalculationBase{get;set;}
        public Decimal cofinsAliquot{get;set;}
        public String simpleOption{get;set;}
        public Decimal icmsReduzedBasePercentage{get;set;}
        public Decimal icmsExempt{get;set;}
        public Decimal netValue{get;set;}
        public String sesCurrency{get;set;}
        public String sesLineDescription{get;set;}
        public String costDocumentNumber{get;set;}
        public String occurrenceNumber{get;set;}
        public String acctountAssingmentCategory{get;set;}
        public String costCenter{get;set;}
        public String sesPlantCode{get;set;}
        public String accoutingAccount{get;set;}
        public String internalOrder{get;set;}
        public List<Nfe> nfe{get;set;}
    }

    public QueryFreightResponse QueryFreightResponse;

    public class Stage {
        public Integer stageNumber{get;set;}
        public String originCity{get;set;}
        public String originPostalCode{get;set;}
        public String originCountry{get;set;}
        public String originPlantCode{get;set;}
        public String originPlantDescription{get;set;}
        public String destinationCity{get;set;}
        public String destinationPostalCode{get;set;}
        public String destinationCountry{get;set;}
        public String loadType{get;set;}
        public String shippingProcess{get;set;}
        public String deliverySystem{get;set;}
        public String loadFM{get;set;}
        public String equipType{get;set;}
        public String grouping{get;set;}
        public Decimal palletCount{get;set;}
        public Decimal grossValueCostPreview{get;set;}
        public Decimal tollCostPreview{get;set;}
        public Decimal freeFreight{get;set;}
        public String shippingType{get;set;}
        public String warehouse{get;set;}
        public String otmShipment{get;set;}
        public Integer distance{get;set;}
        public List<Ses> ses{get;set;}
    }

    public class Shipment {
        public String shipmentNumber;
        public String pricingCalculationDate;
        public String shipmentType;
        public String antt;
        public String shipmentStart;
        public List<Stage> stage;
    }

    public class QueryFreightResponse {
        public List<Shipment> Shipment;
    }

    public class Nfe {
        public Integer nfeTotalValue;
        public String deliveryNumber;
        public String nfeNumber;
        public String nfeSerie;
        public String nfeAccessKey;
        public String cnpjTaker;
        public String cnpjDestination;
        public String cpfDestination;
        public String stageRegistrationDestination;
        public String nameDestination;
        public String phoneDestination;
        public String inscricaoSUFRAMA;
        public String addressDestination;
        public String numberDestination;
        public String complementDestination;
        public String districtDestination;
        public String municipalCodeDestination;
        public String municipalNameDestination;
        public String postalCodeDestination;
        public String stateDestination;
        public String countryCodeDestination;
        public String countryNameDestination;
        public String nfeCreationDate;
        public String incoterms;
        public Integer nfeTotalQuantity;
        public String nfeItemSpecie;
        public String predominantProduct;
        public String complementaryInformation;
        public String materialUsage;
    }

    
    public static BFM_QueryFreightsResponse parse(String json) {
        return (BFM_QueryFreightsResponse) System.JSON.deserialize(json, BFM_QueryFreightsResponse.class);
    }
}