public class DMS_GlobalConstants {
    
    /* Commom Variables */ 
    public static final String VALUE_CURLY_BRACKET_OPEN = '{';
    public static final String VALUE_CURLY_BRACKET_CLOSE = '}';
    public static final String VALUE_BLANK =  ' ';
    public static final String VALUE_NULL = 'null';
    
    
    /*IDs used*/
    public static final String ID_COMMUNITY = '0DBE0000000GmsN';
    public static final String ID_Dataset1 = '0Fb19000000A42BCAS';
    public static final String ID_Dataset2 = '0Fb19000000A3xaCAC';
    
    /* Community variables */
    public static final String URL_COMMUNITY = 'https://acfrdmsld-unilever.cs24.force.com/UID/apex/DMS_Dashboards?sfdc.tabName=01r190000008kUz';
	
    //Exception Message
  	public static final String exceptionMsg = 'Exception occured on the code: ';
    public static final String exceptionPostChatter = 'Exception occured on the Post Chatter';
    
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
    public static final STRING ERROR_GET_USER_ROLE = 'Exception occured on the getUserRole(List<Id> id): ';
    public static final STRING ERROR_PARTNER_RESULT = 'Exception occured on the getPartnerResult(List<Id> id): ';
    public static final STRING RETURN_GET_USER_ROLE = 'Return query in getUserRole(List<Id> id): ';
    public static final STRING RETURN_GET_PARTNER_RESULT = 'Return query in getPartnerResult(List<Id> id): ';
    
    //DMS_WaveRestCall_CC
    public static final String ERROR_GET_RECORDS = 'Exception occured on the getRecords: '; 
	public static final String ERROR_GET_ID_VERSION = 'Exception occured on the getIdVersion: ';
    
    //DMS_WaveHexagonRestCall
	public static final String ERROR_RECORDS = 'Error getRecords ';
    public static final String ERROR_GET_ID = 'Error getIdDataSet: ';	
    
    //DMS_ConnectApiHelper_CC
    public static final String MSG_PARAMETER_NOT_EMPTY = ' parameter must be non-empty.';
    public static final String MSG_PARAMETER_NOT_NULL = ' The inputText parameter cannot be null.';
    
    
    //DMS_Hexagon_CC
    public static final String MSG_EXCEPTION_FILL_LABEL = 'Exception occured on the fillLabel';
    public static final String MSG_EXCEPTION_DEFINE_META = 'Exception occured on the defineMeta';
    public static final String MSG_EXCEPTION_OPTION_DISTRIBUTOR = 'Exception occured on the optionDistributor'; 
    public static final String MSG_EXCEPTION_OPTION_DATE = 'Exception occured on the optionDate';
    public static final String MSG_EXCEPTION_OPTION_CHANNEL = 'Exception occured on the optionSalesChannel';
    public static final String MSG_EXCEPTION_QUERY_DISTRIBUTOR = 'Exception occured on the selectDistributor';
    public static final String MSG_EXCEPTION_QUERY_SALES_CHANNEL = 'Exception occured on the selectSalesChannel';
    public static final String MSG_EXCEPTION_QUERY_TARGET_DATE = 'Exception occured on the selectDateTarget';
    public static final String MSG_EXCEPTION_HEXAGON = 'Exception occured on the generateHexagon';
    public static final String MSG_EXCEPTION_HEXAGON_GRAPHIC = 'Exception occured on the dataForGraphic';
    public static final String MSG_EXCEPTION_HEXAGON_SUBMIT = 'Exception occured on the submitRequest';
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
    public static final String MSG_EXCEPTION_API_HELPER_SEGMENT_SPECIAL_FORMATTING = 'Exception occured on the postFeedItemWithSpecialFormatting:';
    public static final String MSG_EXCEPTION_API_HELPER_SEGMENT_INPUTS = 'Exception occured on the getMessageSegmentInputs:';
    public static final String MSG_EXCEPTION_API_HELPER_TEXT_SEGMENT = 'Exception occured on the addTextSegment:';
    public static final String MSG_EXCEPTION_API_HELPER_TEXT_SEGMENT_INPUT = 'Exception occured on the makeTextSegmentInput:';
    public static final String MSG_EXCEPTION_API_HELPER_MENTIONS_SEGMENT_INPUT = 'Exception occured on the makeMentionSegmentInput:';        
    
    
}