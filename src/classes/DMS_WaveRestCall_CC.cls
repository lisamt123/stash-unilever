/**********************************************************************
Name: DMS_WaveRestCall_CC
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class used to manage requests for the Wave using REST
====================================================== 
======================================================
History 

VERSION AUTHOR DATE DETAIL Description
1.0     DFSM  25/05/2016  INITIAL DEVELOPMENT.
1.1		CHACL 02/06/2016  Changed Autenthication format.
***********************************************************************/
global class DMS_WaveRestCall_CC
{   
    
    global static List<DMS_WaveRestCall_CC.Records> listRecords = new List<DMS_WaveRestCall_CC.Records>();
    public String sessionId;
    
    /*******************************************************************
    * Purpose: Get a list of Records containing the Account Owner and DistributorCode through Dataset Id
    * Parameters: Dataset Id 1, Dataset Id 2
    * Returns: List<Records> 
    ********************************************************************/
    public static void getRecords(String DataSetId1, String DataSetId2, String vSession)
    {
        try { 
     
            Http http = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setMethod(DMS_GlobalConstants.METHOD_POST);
 
            httpReq.setHeader(DMS_GlobalConstants.HEADER_AUTHORIZATION, DMS_GlobalConstants.HEADER_BEARER + vSession);            
            httpReq.setHeader(DMS_GlobalConstants.HEADER_CONTENT_TYPE, DMS_GlobalConstants.CONTENT_TYPE_JSON);
            httpReq.setEndpoint(DMS_GlobalConstants.ENDPOINT_QUERY);
            httpReq.setBody('{"query":"impactStore = load \\"'+ DataSetId1 +'/'+ DMS_WaveRestCall_CC.getIdVersion(DataSetId1,vSession) +'\\"; impactStore = filter impactStore by \'Days_without_invoice\' >= 15; impactStore = foreach impactStore generate \'Account_ExternalCode\',\'Owner.Id\',\'Parent_Account_ExternalCode\'; account = load \\"'+DataSetId2+'/'+ DMS_WaveRestCall_CC.getIdVersion(DataSetId2,vSession)+'\\"; account = filter account by \'RecordTypeId.Id\' == \\"01219000000CiAYAA0\\" and \'StoreStatus__c\' ==\\"APROV\\";account = group impactStore by (\'Parent_Account_ExternalCode\',\'Account_ExternalCode\'), account by (\'ExternalCode__c\',\'StoreCode__c\'); forSeller = foreach account generate impactStore[\'Account_ExternalCode\'] as \'Account_ExternalCode\',first(impactStore[\'Owner.Id\']) as \'Account_Owner\', impactStore[\'Parent_Account_ExternalCode\'] as \'DistributorCode\'; forSeller = group forSeller by (\'DistributorCode\',\'Account_Owner\');forSeller = foreach forSeller generate  \'DistributorCode\',\'Account_Owner\';"}');
            
            HttpResponse resp = http.send(httpReq);
            String strJson = resp.getBody();
            JsonParser parser = Json.createParser(strJson);
            
            Distribuidor distribuidor = (DMS_WaveRestCall_CC.Distribuidor) parser.readValueAs(DMS_WaveRestCall_CC.Distribuidor.class);
            listRecords = distribuidor.results.records;
        } 
        catch (Exception e) 
        {
            System.debug(DMS_GlobalConstants.ERROR_GET_RECORDS + e.getCause() + e.getMessage() + e.getLineNumber());
        }
    }
    
    /*******************************************************************
    * Purpose: Gets the idVersion, by id DataSet
    * Parameters: id of Dataset
    * Returns: The version from the DataSet 
    ********************************************************************/
    public static String getIdVersion(String idDataSet, String vSession)
    {        
       User user; 
        try 
        {

        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod(DMS_GlobalConstants.METHOD_GET);
        httpReq.setHeader(DMS_GlobalConstants.HEADER_AUTHORIZATION, DMS_GlobalConstants.HEADER_BEARER + vSession);//Authorization - Bearer       
        httpReq.setEndpoint(DMS_GlobalConstants.ENDPOINT_GET_ID_DATASET + idDataSet);
        
        HttpResponse resp = http.send(httpReq);
        String strJson = resp.getBody();
        JsonParser parser = Json.createParser(strJson);
        user = (DMS_WaveRestCall_CC.User) parser.readValueAs(DMS_WaveRestCall_CC.User.class);
        
        }  catch (Exception e) 
        {
            System.debug(DMS_GlobalConstants.ERROR_GET_ID_VERSION + e.getCause() + e.getMessage() + e.getLineNumber());
        }  
        return User.currentVersionId;
    }
    
    /*******************************************************************
	* Purpose: Class to map the response json method "getRecords(String DataSetId1, String DataSetId2)"
	********************************************************************/
    global Class Records
    {
        public String Account_Owner;
        public String DistributorCode;
    }
    
    /*******************************************************************
	* Purpose: Class to map the response json method "getRecords(String DataSetId1, String DataSetId2)"
	********************************************************************/ 
    Class Results
    {
        public List<Records> records;
    }
    
    /*******************************************************************
	* Purpose: Class to map the response json method "getRecords(String DataSetId1, String DataSetId2)"
	********************************************************************/
    Class Distribuidor
    {
        public DMS_WaveRestCall_CC.Results results;
    }
    
    /*******************************************************************
	* Purpose: Class to map the response json method "getIdVersion(String idDataSet)"
	********************************************************************/
    Class User
    {
        public String currentVersionId;
    }
}