/**********************************************************************
Name: DMS_WaveHexagonRestCall
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class used to manage requests for the Wave using REST
====================================================== 
======================================================
History 

VERSION 	AUTHOR		 		DATE  		Description
1.0		DIMITRI M. SANTANA	 25/05/2016		INITIAL DEVELOPMENT

***********************************************************************/
public class DMS_WaveHexagonRestCall {    
    
    /*******************************************************************
    * Purpose: Get a list of Records containing the data for Hexagon
    * Parameters: Dataset Id 1, distributor, period, salesChannel
    * Returns: List<Records> 
    ********************************************************************/
    public List<Records> getRecords(String Id1,String distributor,String period ,String salesChannel)
    {	
        List<Records> records;
        try{
            String filtro = 'hexagono = filter hexagono by \'dsCategory\' == \\"Actual\\" && \'Distributor_ExternalCode\' == '+'\\"' + distributor + '\\" && \'Periodo\' in ' + '[\\"' + period + '\\"] && \'SalesChannel\' == ' + '\\"' + salesChannel + '\\";';
            String query = '{"query":"hexagono = load \\"'+Id1+'/'+this.getIdDataSet(Id1)+'\\"; ';        
            String forEach = 'hexagono = foreach hexagono generate \'Actual\', \'Distributor_Country\',\'Distributor_ExternalCode\',\'Distributor_AccountName\',\'Indicator_Type\',\'Performance\',\'Periodo\',  \'Previous\',\'SalesChannel\',\'SalesRep\', \'Target\',\'Variation\',\'dsCategory\',\'Target_Previous\';"}';
            query= query + filtro + forEach;
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            
            req.setMethod(DMS_GlobalConstants.METHOD_POST);
            req.setHeader(DMS_GlobalConstants.HEADER_AUTHORIZATION, DMS_GlobalConstants.HEADER_BEARER + UserInfo.getSessionId());
            req.setHeader(DMS_GlobalConstants.HEADER_CONTENT_TYPE, DMS_GlobalConstants.CONTENT_TYPE_JSON);       
            req.setEndpoint(DMS_GlobalConstants.ENDPOINT_QUERY);
            req.setBody(query);
            
            HttpResponse resp = http.send(req);
            String strJson = resp.getBody();       
            JsonParser parser = Json.createParser(strJson);
            Distribuidor distribuidor = (DMS_WaveHexagonRestCall.Distribuidor) parser.readValueAs(DMS_WaveHexagonRestCall.Distribuidor.class);        
            records = distribuidor.results.records;
        }catch(Exception e){
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
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        try{
            req.setMethod(DMS_GlobalConstants.METHOD_GET);
            req.setHeader(DMS_GlobalConstants.HEADER_AUTHORIZATION, DMS_GlobalConstants.HEADER_BEARER + UserInfo.getSessionId());
            req.setHeader(DMS_GlobalConstants.HEADER_CONTENT_TYPE, DMS_GlobalConstants.CONTENT_TYPE_JSON);       
            req.setEndpoint(DMS_GlobalConstants.ENDPOINT_GET_ID_DATASET + idVersion);
            
            HttpResponse resp = http.send(req);
            String strJson = resp.getBody();
            JsonParser parser = Json.createParser(strJson);
            User user = (DMS_WaveHexagonRestCall.User) parser.readValueAs(DMS_WaveHexagonRestCall.User.class);
            idDataSet = User.currentVersionId;
        }catch(Exception e){
            System.debug(DMS_GlobalConstants.ERROR_GET_ID + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        return idDataSet;
    }
    /*******************************************************************
* Purpose: Class to map the response json method 
********************************************************************/
    public Class Records
    {        
        public String Actual;
        public String Distributor_Country;
        public String Distributor_ExternalCode;
        public String Distributor_AccountName;
        public String Indicator_Type;
        public String Performance;
        public String Periodo;
        public String Previous;
        public String SalesChannel;
        public String SalesRep;
        public String Target;
        public String Variation;
        public String dsCategory;
        public String Target_Previous;
        
    }
    /*******************************************************************
	* Purpose: Class to map the response json method 
	********************************************************************/
    Class Results
    {
        public List<Records> records;
    }
    /*******************************************************************
	* Purpose: Class to map the response json method 
	********************************************************************/
    Class Distribuidor
    {
        public DMS_WaveHexagonRestCall.Results results;
    }
    /*******************************************************************
	* Purpose: Class to map the response json method 
	********************************************************************/
    Class User
    {
        public String currentVersionId;
    }
}