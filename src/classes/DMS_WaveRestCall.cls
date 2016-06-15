/**********************************************************************
Name: DMS_WaveRestCall_CC

Purpose: 
Class used to manage requests for the Wave using REST

History 

VERSION AUTHOR DATE DETAIL Description
1.0     DFSM  25/05/2016  INITIAL DEVELOPMENT.
1.1		CHACL 02/06/2016  Changed Autenthication format.
1.2		CHACL 07/06/2016  Perform class with reusability
***********************************************************************/
global class DMS_WaveRestCall
{   
    
    global static List<DMS_WaveRestCall.Records> listRecords = new List<DMS_WaveRestCall.Records>();
    public String sessionId;
    
    /*******************************************************************
    * Purpose: Get a list of Records containing the Account Owner and DistributorCode through Dataset Id
    * Parameters: Dataset Id 1, Dataset Id 2
    * Returns: List<Records> 
    ********************************************************************/
    public static void getRecords(String DataSetId1, String DataSetId2, String vSession)
    {
        try { 
     
            String body = '{"query":"impactStore = load \\"'+ DataSetId1 +'/'+ DMS_WaveRestCall.getIdVersion(DataSetId1,vSession) +'\\"; impactStore = filter impactStore by \'Days_without_invoice\' >= 15; impactStore = foreach impactStore generate \'Account_ExternalCode\',\'Owner.Id\',\'Parent_Account_ExternalCode\'; account = load \\"'+DataSetId2+'/'+ DMS_WaveRestCall.getIdVersion(DataSetId2,vSession)+'\\"; account = filter account by \'RecordTypeId.Id\' == \\"01219000000CiAYAA0\\" and \'StoreStatus__c\' ==\\"APROV\\";account = group impactStore by (\'Parent_Account_ExternalCode\',\'Account_ExternalCode\'), account by (\'ExternalCode__c\',\'StoreCode__c\'); forSeller = foreach account generate impactStore[\'Account_ExternalCode\'] as \'Account_ExternalCode\',first(impactStore[\'Owner.Id\']) as \'Account_Owner\', impactStore[\'Parent_Account_ExternalCode\'] as \'DistributorCode\'; forSeller = group forSeller by (\'DistributorCode\',\'Account_Owner\');forSeller = foreach forSeller generate  \'DistributorCode\',\'Account_Owner\';"}';   
            Map<String, String> headerValues = new Map<String, String>();
            headerValues.put(DMS_GlobalConstants.HEADER_AUTHORIZATION, DMS_GlobalConstants.HEADER_BEARER + vSession);
            headerValues.put(DMS_GlobalConstants.HEADER_CONTENT_TYPE, DMS_GlobalConstants.CONTENT_TYPE_JSON);
                       
            DMS_RestApiHelper dmsWaveRest = new DMS_RestApiHelper(DMS_GlobalConstants.ENDPOINT_QUERY, DMS_GlobalConstants.METHOD_POST, headerValues,body);
            
            JSONParser parser = Json.createParser(dmsWaveRest.responseBody);
            Distribuidor distribuidor = (DMS_WaveRestCall.Distribuidor) parser.readValueAs(DMS_WaveRestCall.Distribuidor.class);
            listRecords = distribuidor.results.records;
           
        } 
        catch (Exception e) 
        {
            System.debug(DMS_GlobalConstants.EXCEPTION_MESSAGE + e.getCause() + e.getMessage() + e.getLineNumber());
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

        Map<String, String> headerValues = new Map<String, String>();
        headerValues.put(DMS_GlobalConstants.HEADER_AUTHORIZATION, DMS_GlobalConstants.HEADER_BEARER + vSession);
         
        DMS_RestApiHelper dmsWaveRest = new DMS_RestApiHelper(DMS_GlobalConstants.ENDPOINT_GET_ID_DATASET + idDataSet, DMS_GlobalConstants.METHOD_GET, headerValues,'');    
        JsonParser parser = Json.createParser(dmsWaveRest.responseBody);
        user = (DMS_WaveRestCall.User) parser.readValueAs(DMS_WaveRestCall.User.class);
        
        }  catch (Exception e) 
        {
            System.debug(DMS_GlobalConstants.EXCEPTION_MESSAGE + e.getCause() + e.getMessage() + e.getLineNumber());
        }  
        return User.currentVersionId;
    }
    
    
	//Inner classes 
	
    global Class Records
    {
        public String Account_Owner;
        public String DistributorCode;
    }
    
    Class Results
    {
        public List<Records> records;
    }
    
    Class Distribuidor
    {
        public DMS_WaveRestCall.Results results;
    }
    
    Class User
    {
        public String currentVersionId;
    }
}