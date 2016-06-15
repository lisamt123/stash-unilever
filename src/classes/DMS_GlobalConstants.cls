public class DMS_GlobalConstants {
    
    /*IDs used*/
    public static final String ID_Dataset1 = '0Fb19000000A42BCAS';
    public static final String ID_Dataset2 = '0Fb19000000A3xaCAC';
    
    //Exception Message
    public static final String EXCEPTION_MESSAGE = 'Exception occured on the code: ';
    public static final String exceptionPostChatter = 'Exception occured on the Post Chatter';
    
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
    public static final STRING ERROR_GET_USER_ROLE = 'Exception occured on the getUserRole(List<Id> id): ';
    public static final STRING ERROR_PARTNER_RESULT = 'Exception occured on the getPartnerResult(List<Id> id): ';
    public static final STRING RETURN_GET_USER_ROLE = 'Return query in getUserRole(List<Id> id): ';
    public static final STRING RETURN_GET_PARTNER_RESULT = 'Return query in getPartnerResult(List<Id> id): ';
    
    //DMS_CreationUser
    public static final String ERROR_USERCREATION = 'Exception occured on UserCreation: ';
    
    //DMS_WaveRestCall_CC
    public static final String ERROR_GET_RECORDS = 'Exception occured on the getRecords: '; 
    public static final String ERROR_GET_ID_VERSION = 'Exception occured on the getIdVersion: ';
    
    //DMS_WaveHexagonRestCall
    public static final String ERROR_RECORDS = 'Error getRecords ';
    public static final String ERROR_GET_ID = 'Error getIdDataSet: ';	
    
    //DMS_UserCreation
    public static final String MSG_EXCEPTION_USERCREATION = 'Exception UserCreation occured on ';
    
    //DMS_ConnectApiHelper_CC
    public static final String MSG_PARAMETER_NOT_EMPTY = ' parameter must be non-empty.';
    public static final String MSG_PARAMETER_NOT_NULL = ' The inputText parameter cannot be null.';   
    
    //DMS_Hexagon_CC
    public static final String MSG_EXCEPTION_HEXAGON = 'Exception occured on the Class Hexagon_CC: ';
    public static final String HEXAGON_VALUES = 'Hexagon values';
    
    //DMS_ConnectApiHelper
    //Exception Message 
    public static final String MSG_EXCEPTION_API_HELPER = 'Exception occured on the Class ConnectApiHelper: ';                
    
    //using in test class    
    public static final String USER_TEST_USERNAME = 'newuser@testorg.com';
    public static final String USER_TEST_LAST_NAME = 'Testing';
    public static final String USER_TEST_EMAIL = 'standarduser@testorg.com';			 
    public static final String USER_TEST_ALIAS ='standt'; 
    public static final String USER_TEST_COMMUNITY_NICKNAME = ' nickTest';			
    public static final String USER_TEST_TIME_ZONE = 'America/Los_Angeles'; 			
    public static final String USER_TEST_LOCALE_KEY = 'en_US';			 
    public static final String USER_TEST_EMAIL_KEY = 'UTF-8'; 
    public static final String CONTACT_TEST_EMAIL = 'contactEmail@test.com';
    public static final String ACCOUNT_SALES_CHANNEL = '001';
    public static final String ACCOUNT_EXTERNAL_CODE = 'DMS_DISTRIBUTOR';
    public static final String ACCOUNT_EXTERNAL_CODE_STORE = 'DMS_STORE';
    public static final String ACCOUNT_NAME = 'account Test';
    public static final String ACCOUNT_STATUS_APROV = 'APROV';
    
}