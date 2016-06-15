/**********************************************************************
Name: DMS_WaveHexagonRestCall
Copyright © 2016 Salesforce

Purpose: 
Class used to manage requests for the Wave using REST

History 

VERSION 	AUTHOR		 		DATE  		Description
1.0		DIMITRI M. SANTANA	 25/05/2016		INITIAL DEVELOPMENT
1.2		CHACL 				 07/06/2016  	Perform class with reusability
***********************************************************************/
public class DMS_WaveHexagonRestCall {    
    
    /*******************************************************************
* Purpose: Get a list of Records containing the data for Hexagon
* Parameters: Dataset Id 1, distributor, period, salesChannel
* Returns: List<Records> 
********************************************************************/
    public List<Records> getRecords(String Id1,String dsCountry,String distributor,String period ,String salesChannel)
    {	
        List<Records> records;
        try {
            String filtro = 'hexagono = filter hexagono by \'dsCountry\' == '+'\\"' + dsCountry + '\\" && \'cdDistributor\' == '+'\\"' + distributor + '\\" && \'dtPeriod\' in ' + '[\\"' + period + '\\"] && \'cdSalesChannel\' == ' + '\\"' + salesChannel + '\\";';
            String body = '{"query":"hexagono = load \\"'+Id1+'/'+this.getIdDataSet(Id1)+'\\"; ';        
            String forEach = 'hexagono = foreach hexagono generate \'cdDistributor\',\'cdSalesChannel\',\'cdSalesRep\',\'devolutionAc\',\'devolutionPrev\', \'dropsizeAc\',\'dropsizePrev\',\'dsCountry\', \'dsDistributor\',\'dsSalesRep\', \'dtPeriod\',\'frequencyAc\',\'frequencyPrev\',\'impactedStoreAc\',\'impactedStorePrev\',\'ordersAc\', \'ordersPrev\', \'perforDevolutionAc\',\'perforDevolutionPrev\',\'perforDropsizeAc\', \'perforDropsizePrev\', \'perforFrequencyAc\', \'perforFrequencyPrev\', \'perforImpactedStoreAc\', \'perforImpactedStorePrev\', \'perforOrdersAc\', \'perforOrdersPrev\', \'perforSelloutAc\', \'perforSelloutPrev\', \'selloutAc\', \'selloutPrev\', \'targetDevolutionAc\', \'targetDevolutionPrev\', \'targetDropsizeAc\', \'targetDropsizePrev\', \'targetFrequencyAc\', \'targetFrequencyPrev\', \'targetImpactedStoreAc\', \'targetImpactedStorePrev\', \'targetOrderAc\', \'targetOrderPrev\', \'targetSelloutAc\', \'targetSelloutPrev\', \'variacDevolution\', \'variacDropsize\', \'variacFrequency\', \'variacImpactedStore\', \'variacOrders\', \'variacSellout\';"}';
            //String forEach = 'hexagono = foreach hexagono generate \'Actual\', \'Distributor_Country\',\'Distributor_ExternalCode\',\'Distributor_AccountName\',\'Indicator_Type\',\'Performance\',\'Periodo\',  \'Previous\',\'SalesChannel\',\'SalesRep\', \'Target\',\'Variation\',\'dsCategory\',\'Target_Previous\';"}';
            body = body + filtro + forEach;
            
            Map<String, String> headerValues = new Map<String, String>();
            headerValues.put(DMS_GlobalConstants.HEADER_AUTHORIZATION, DMS_GlobalConstants.HEADER_BEARER + UserInfo.getSessionId());
            headerValues.put(DMS_GlobalConstants.HEADER_CONTENT_TYPE, DMS_GlobalConstants.CONTENT_TYPE_JSON);
            System.debug('String request:  ' + body);
            DMS_RestApiHelper dmsWaveRest = new DMS_RestApiHelper(DMS_GlobalConstants.ENDPOINT_QUERY, DMS_GlobalConstants.METHOD_POST, headerValues,body);
            System.debug('Response aqui!!! : ' + dmsWaveRest.responseBody);
            JSONParser parser = Json.createParser(dmsWaveRest.responseBody);
            Distribuidor distribuidor = (DMS_WaveHexagonRestCall.Distribuidor) parser.readValueAs(DMS_WaveHexagonRestCall.Distribuidor.class);
            records = distribuidor.results.records;
            
        } catch(Exception e) {
            System.debug(DMS_GlobalConstants.ERROR_RECORDS + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        return records;
    }         
    
    /*******************************************************************
* Purpose: Gets the idVersion, by id DataSet
* Parameters: idVersion
* Returns: String 
********************************************************************/
    private String getIdDataSet(String idVersion)
    {
        String idDataSet;
        
        try {
            
            Map<String, String> headerValues = new Map<String, String>();
            headerValues.put(DMS_GlobalConstants.HEADER_AUTHORIZATION, DMS_GlobalConstants.HEADER_BEARER + UserInfo.getSessionId());
            headerValues.put(DMS_GlobalConstants.HEADER_CONTENT_TYPE, DMS_GlobalConstants.CONTENT_TYPE_JSON);
            
            DMS_RestApiHelper dmsWaveRest = new DMS_RestApiHelper(DMS_GlobalConstants.ENDPOINT_GET_ID_DATASET + idVersion, DMS_GlobalConstants.METHOD_GET, headerValues,'');
            
            JSONParser parser = Json.createParser(dmsWaveRest.responseBody);
            User user = (DMS_WaveHexagonRestCall.User) parser.readValueAs(DMS_WaveHexagonRestCall.User.class);
            idDataSet = User.currentVersionId;
            
        } catch(Exception e) {
            System.debug(DMS_GlobalConstants.ERROR_GET_ID + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        return idDataSet;
    }
    
    
    // Inner Classes
    public Class Records
    {                    
        public string dsSalesRep {get;set;}
        public String cdDistributor{get;set;}
        public String cdSalesChannel{get;set;}
        public String cdSalesRep{get;set;}
        public String dsCountry{get;set;}
        public String dsDistributor{get;set;}
        public String dtPeriod{get;set;}
        public Decimal devolutionAc{get;set;}
        public Decimal devolutionPrev{get;set;}
        public Decimal dropsizeAc{get;set;}
        public Decimal dropsizePrev{get;set;}       
        public Decimal frequencyAc{get;set;}
        public Decimal frequencyPrev{get;set;}
        public Decimal impactedStoreAc{get;set;}
        public Decimal impactedStorePrev{get;set;}
        public Decimal ordersAc{get;set;}
        public Decimal ordersPrev{get;set;}
        public Decimal perforDevolutionAc{get;set;}
        public Decimal perforDevolutionPrev{get;set;}
        public Decimal perforDropsizeAc{get;set;}
        public Decimal perforDropsizePrev{get;set;}
        public Decimal perforFrequencyAc{get;set;}
        public Decimal perforFrequencyPrev{get;set;}
        public Decimal perforImpactedStoreAc{get;set;}
        public Decimal perforImpactedStorePrev{get;set;}
        public Decimal perforOrdersAc{get;set;}
        public Decimal perforOrdersPrev{get;set;}
        public Decimal perforSelloutAc{get;set;}
        public Decimal perforSelloutPrev{get;set;}
        public Decimal selloutAc{get;set;}
        public Decimal selloutPrev{get;set;}
        public Decimal targetDevolutionAc{get;set;}
        public Decimal targetDevolutionPrev{get;set;}
        public Decimal targetDropsizeAc{get;set;}
        public Decimal targetDropsizePrev{get;set;}
        public Decimal targetFrequencyAc{get;set;}
        public Decimal targetFrequencyPrev{get;set;}
        public Decimal targetImpactedStoreAc{get;set;}
        public Decimal targetImpactedStorePrev{get;set;}
        public Decimal targetOrderAc{get;set;}
        public Decimal targetOrderPrev{get;set;}
        public Decimal targetSelloutAc{get;set;}
        public Decimal targetSelloutPrev{get;set;}
        public Decimal variacDevolution{get;set;}
        public Decimal variacDropsize{get;set;}
        public Decimal variacFrequency{get;set;}
        public Decimal variacImpactedStore{get;set;}
        public Decimal variacOrders{get;set;}
        public Decimal variacSellout{get;set;}
        
    }
    
    Class Results
    {
        public List<Records> records;
    }
    
    Class Distribuidor
    {
        public DMS_WaveHexagonRestCall.Results results;
    }
    
    Class User
    {
        public String currentVersionId;
    }
}