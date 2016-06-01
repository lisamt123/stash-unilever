public class DMS_GlobalConstants {
    
    /* Commom Variables */ 
    public static final String VALUE_CURLY_BRACKET_OPEN = '{';
    public static final String VALUE_CURLY_BRACKET_CLOSE = '}';
    public static final String VALUE_BLANK =  ' ';
    public static final String VALUE_NULL = 'null';
    
    
    /*IDs used*/
    public static final String ID_COMMUNITY = '0DBE0000000GmsN';
    
    /* Community variables */
    public static final String URL_COMMUNITY = 'https://acfrdmsld-unilever.cs24.force.com/UID/apex/DMS_Dashboards?sfdc.tabName=01r190000008kUz';
	
    //Exception Message
  	public static final String exceptionMsg = 'Exception occured on the code: ';
    
    //User TestClass
    public static final String USER_TEST_USERNAME = 'test@test.com';               
    public static final String USER_TEST_ALIAS = 'test123';
    public static final String USER_TEST_EMAIL= 'test@test.com';
    public static final String USER_TEST_EMAIL_KEY = 'UTF-8';
    public static final String USER_TEST_LAST_NAME = 'McTesty';
    public static final String USER_TEST_COMMUNITY_NICKNAME = 'test';
    public static final String USER_TEST_TIME_ZONE = 'America/Los_Angeles';
    public static final String USER_TEST_LOCALE_KEY = 'en_US';
    
    //Account Test Class
    public static final String ACCOUNT_NAME = 'name';
    public static final String ACCOUNT_STATUS_APROV = 'APROV';
    public static final String ACCOUNT_RECTYPE_STORE = '01219000000CiAY';
    public static final String ACCOUNT_RECTYPE_DISTRIBUTOR = '01219000000CiAT';
    public static final String ACCOUNT_SALES_CHANNEL = '001';
    public static final String ACCOUNT_EXTERNAL_CODE = 'DMS_Distributor';
    public static final String ACCOUNT_EXTERNAL_CODE_STORE = 'DMS_Account';
    
    //Contact Test class
    public static final String CONTACT_FIRSTNAME = 'Test';
    public static final String CONTACT_LASTNAME = 'McTesty';
    public static final String CONTACT_EMAIL = 'test@test.com';
    
    // OAuth Autentication Infos
	public static final String GRANT_TYPE = 'password';
	
	//REST API Format
	public static final String METHOD_POST = 'POST';
	public static final String METHOD_GET = 'GET';
	public static final String HEADER_CONTENT_TYPE = 'Content-type';
	public static final String CONTENT_TYPE_JSON = 'application/json';
	public static final String HEADER_AUTHORIZATION = 'Authorization';
	public static final String AUTHORIZATION_OAUTH = 'OAuth ';
	public static final String ENDPOINT_QUERY = 'https://unilever--acfrdmsld.cs24.my.salesforce.com/services/data/v36.0/wave/query';
	public static final String ENDPOINT_GET_ID_DATASET = 'https://unilever--acfrdmsld.cs24.my.salesforce.com/services/data/v36.0/wave/datasets/';
	public static final String ENDPOINT_GET_OAUTH = 'https://unilever--acfrdmsld.cs24.my.salesforce.com/services/oauth2/token';
    public static final String ACCESS_TOKEN = 'access_token';
    public static final String HEADER_BEARER = 'Bearer ';
    
    //DMS_AccountUserRole_CC
    public static final String USER_PORTAL_TYPE = 'Partner';
    public static final String EDIT = 'Edit';
    public static final String READ = 'Read';
    public static final STRING ERROR_CREATE_PARTNER = 'Exception occured on the code: ';
    public static final STRING ERROR_GET_USER_ROLE = 'Error in getUserRole(List<Id> id): ';
    public static final STRING ERROR_PARTNER_RESULT = 'Error in getPartnerResult(List<Id> id): ';
    public static final STRING RETURN_GET_USER_ROLE = 'Return query in getUserRole(List<Id> id): ';
    public static final STRING RETURN_GET_PARTNER_RESULT = 'Return query in getPartnerResult(List<Id> id): ';
    
    //DMS_WaveRestCall_CC
    public static final String ERROR_GET_RECORDS = 'Exception occured in getRecords(String DataSetId1, String DataSetId2): '; 
	public static final String ERROR_GET_ID_VERSION = 'Exception occured in getIdVersion(String idDataSet): ';
    
    //DMS_WaveHexagonRestCall
	public static final String ERROR_RECORDS = 'Error getRecords ';
    public static final String ERROR_GET_ID = 'Error getIdDataSet: ';	
    
    //DMS_ConnectApiHelper_CC
    public static final String MSG_PARAMETER_NOT_EMPTY = ' parameter must be non-empty.';
    public static final String MSG_PARAMETER_NOT_NULL = ' The inputText parameter cannot be null.';
    
    
    //DMS_Hexagon_CC
    public static final String MSG_EXCEPTION_FILL_LABEL = 'Error in fillLabel';
    public static final String MSG_EXCEPTION_DEFINE_META = 'Error in defineMeta';
    public static final String MSG_EXCEPTION_OPTION_DISTRIBUTOR = 'Error in optionDistributor'; 
    public static final String MSG_EXCEPTION_OPTION_DATE = 'Error in optionDate';
    public static final String MSG_EXCEPTION_OPTION_CHANNEL = 'Error in optionSalesChannel';
    public static final String MSG_EXCEPTION_QUERY_DISTRIBUTOR = 'Error in selectDistributor';
    public static final String MSG_EXCEPTION_QUERY_SALES_CHANNEL = 'Error in selectSalesChannel';
    public static final String MSG_EXCEPTION_QUERY_TARGET_DATE = 'Error in selectDateTarget';
    public static final String MSG_EXCEPTION_HEXAGON = 'Error in generateHexagon';
    public static final String MSG_EXCEPTION_HEXAGON_GRAPHIC = 'Error in dataForGraphic';
    public static final String MSG_EXCEPTION_HEXAGON_SUBMIT = 'Error in submitRequest';
    public static final String HEXAGON_VALUES = 'Hexagon values';
    //Labels
    public static final String HEXAGON_LABEL_CLIENTES = '"CLIENTES IMPACTADOS (UN)"';
    public static final String HEXAGON_LABEL_DEVOLUCIONES = '"DEVOLUCIONES (%)"';
    public static final String HEXAGON_LABEL_DROPSIZE = '"DROPSIZE ($/PEDIDO)"';
    public static final String HEXAGON_LABEL_FRECUENCIA = '"FRECUENCIA (UN / tienda)"';
    public static final String HEXAGON_LABEL_PEDIDOS = '"PEDIDOS (UN)"';
    public static final String HEXAGON_LABEL_SELLOUT = '"SELLOUT ($)"';
    
    
    //DMS_ConnectApiHelper_CC
    //Exception Message
    public static final String MSG_EXCEPTION_API_HELPER_SEGMENT_SPECIAL_FORMATTING = 'Error in postFeedItemWithSpecialFormatting:';
    public static final String MSG_EXCEPTION_API_HELPER_SEGMENT_INPUTS = 'Error in getMessageSegmentInputs:';
    public static final String MSG_EXCEPTION_API_HELPER_TEXT_SEGMENT = 'Error in addTextSegment:';
    public static final String MSG_EXCEPTION_API_HELPER_TEXT_SEGMENT_INPUT = 'Error in makeTextSegmentInput:';
    public static final String MSG_EXCEPTION_API_HELPER_MENTIONS_SEGMENT_INPUT = 'Error in makeMentionSegmentInput:';        
    
    
}