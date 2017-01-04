/** 
 * This class is used to declare error .
 * @author  g.prajapat@accenture.com 
 * @version  2015-10-19  g.prajapat@accenture.com  creation 
 */
public with sharing class Constants {

    public static final String NAMESPACEPREFIX = '';

    public static final String STATUS = 'Active';
    public static final String TRANSACTION_TYPE_VOID = 'Void';

    public static final String DEDUCTION = 'Deduction';
    public static final String LUMPSUM = 'LumpSum';
    public static final String ONINVOICE = 'OnInvoice';
    public static final String PERCASE = 'PerCase';
    public static final String PRICEREDUCTION = 'PriceReduction';
    public static final String RETURN_URL = 'retURL';

    public static final Date MIN_DATE = Date.newInstance(1700, 1, 1); 
    public static final Date MAX_DATE = Date.newInstance(4000, 12, 31);

    public static final String MESSAGE_TYPE_SUCCESS = 'success';
    public static final String MESSAGE_TYPE_ERROR = 'error';
    public static final string EXCEPTION_NULL_TYPE = 'System.NullPointerException';
    //Apex Message severity declaration
    public enum SEVERITY{CONFIRM,ERROR,FATAL,INFO,WARNING}

    //Field's value for Inventory transaction template test factory.
    public static final String TRANSACTION_CONTROL_ADD = 'Add';
    public static final String TRANSACTION_CONTROL_WITHDRAW = 'Withdraw';
    public static final String TRANSACTION_TYPE_ADDITION = 'Addition';
    public static final Boolean CHECKBOX_TRUE = true;
    public static final String DESCRIPTION_LANGUAGE = 'TEST_LANG';
    public static final Boolean CHECKBOX_FALSE = false;

    //Language Master Values enum to be used in test class
    public enum LANGUAGE{en,fr,es,de,it}
    //Language_Postfix values
    public static final string LANG_1 = 'Language1';
    public static final string LANG_2 = 'Language2';
    public static final string LANG_3 = 'Language3';
    public static final string LANG_4 = 'Language4';

    public static final String FLS_VIEW = 'view';


    public static final String SYSTEM_SETTING_FIRST_WEEK_OF_YEAR = 'First_Week_Of_Year';
    public static final String SYSTEM_SETTING_FIRST_DAY_OF_WEEK = 'First_Day_Of_Week';
    public static final String SYSTEM_SETTING_CALL_START_TIME = 'Call_Start_Time';
    public static final String SYSTEM_SETTING_JWT_EXPIRATION_TIME = 'JWT_Expiration_Time';
    public static final String SYSTEM_SETTING_MAXIMUM_ACCOUNT_HIERARCHY_LEVELS = 'Maximum_Account_Hierarchy_Levels';

    public static final String PROMOTION_AGGREGATION_LEVEL_DEFAULT = 'Brand';
    public final static Integer DEFAULT_JWT_EXPIRATION_TIME = 10;
    public static final Integer DEFAULT_MAXIMUM_ACCOUNT_HIERARCHY_LEVEL = 8;


    public static final String ACCOUNT_CALL_SETTING_PLANNING_MODE_STARTWEEKYEAR ='StartWeekYear';
    public static final String ACCOUNT_CALL_SETTING_PLANNING_MODE_STARTWEEK ='StartWeek';
    public static final String ACCOUNT_CALL_SETTING_MONDAY = 'mon';
    public static final String ACCOUNT_CALL_SETTING_TUESDAY ='tue';
    public static final String ACCOUNT_CALL_SETTING_WEDNESDAY = 'wed';
    public static final String ACCOUNT_CALL_SETTING_THURSDAY = 'thu';
    public static final String ACCOUNT_CALL_SETTING_FRIDAY ='fri';
    public static final String ACCOUNT_CALL_SETTING_SATURDAY = 'sat';
    public static final String ACCOUNT_CALL_SETTING_SUNDAY = 'sun';

    public static final Map<String, Integer> ACCOUNT_CALL_SETTING_DAY_OF_WEEK = new Map<String, Integer> {
        ACCOUNT_CALL_SETTING_SUNDAY => 1,
        ACCOUNT_CALL_SETTING_MONDAY => 2,
        ACCOUNT_CALL_SETTING_TUESDAY => 3,
        ACCOUNT_CALL_SETTING_WEDNESDAY => 4,
        ACCOUNT_CALL_SETTING_THURSDAY => 5,
        ACCOUNT_CALL_SETTING_FRIDAY => 6,
        ACCOUNT_CALL_SETTING_SATURDAY => 7
    };

    public final static String JOB_DEFINITION_LIST_USER_POLICY_ALL = 'All';
    public final static String JOB_DEFINITION_LIST_USER_POLICY_ONLY_MAIN = 'OnlyMain';
    public final static String JOB_DEFINITION_LIST_USER_POLICY_FIRST = 'First';


    public final static String STRING_VALID_FROM='Valid_From__c';
    public final static String STRING_VALID_THRU='Valid_Thru__c';
    public final static String DISTRIBUTION_RELEVANT='Distribution_Relevant__c';

    // Developer names of the recordtypes for object 'Promotion__c'
    public final static String PROMOTION_RECORD_TYPE_PROMOTION = 'Promotion';
    public final static String PRODUCT_ASSORTMENT_TEMPLATE_RECORD_TYPE_PRODUCT_ASSORTMENT = 'Product_Assortment_Type';

    // Developer names of the recordtypes for object 'Data_Type__c'
    public final static String DataType_RecType_Toggle = 'Toggle';
    public final static String DataType_RecType_Date = 'Date';      
    public final static String DataType_RecType_Decimal = 'Decimal';
    public final static String DataType_RecType_LongText = 'LongText';
    public final static String DataType_RecType_Number = 'Number';
    public final static String STRING_UNDER_SCORE = '_';
    public final static String STRING_FRONT_SLASH = '/';

    // Presetting__c picklist values of object Job_Definition_Template__c
    public final static String JDT_PRESETTING_NO = 'No';
    public final static String JDT_PRESETTING_LAST_VALUE = 'LastValue';

    public static final String CALL_CREATION_MODE_AUTOMATIC = 'Automatically';
    public static final String CALL_CREATION_MODE_MANUALLY = 'Manually';
    public static final String CALL_FIXED_CALL_DATE_DEFAULT = 'No';
    // Status__c picklist values of object Call__c
    public final static String CALL_STATUS_UNSCHEDULED = 'Unscheduled';
    public final static String CALL_STATUS_PLANNED = 'Plan';
    public final static String CALL_STATUS_COMPLETED = 'Completed';
    public final static String CALL_STATUS_CANCELED = 'Canceled';
    public final static String CALL_STATUS_DENIED = 'Denied';
    public final static String CALL_TEMPLATE_HISTORICAL_PRODUCTS_SAMEMETA = 'SameMeta';
    // Approval_State__c picklist value of object Job_Definition_List__c
    public final static String JOB_DEFINITION_LIST_APPROVAL_STATE_APPROVED = 'Approved';
    public final static String JOB_DEFINITION_LIST_APPROVAL_STATE_CANCELED = 'Canceled';
    // Phase__c picklist value of Field_Sales_Activity__c
    public final static String FIELD_SALES_ACTIVITY_PHASE_CANCELED = 'Canceled';
    // Phase__c picklist value of Field_Sales_Activity__c
    public final static String FIELD_SALES_ACTIVITY_PHASE_COMMITED = 'Commited';
    // Phase__c picklist value of Field_Sales_Activity__c
    public final static String FIELD_SALES_ACTIVITY_PHASE_PLANNING = 'Planning';
    // Done__c picklist value of Job_List__c
    public final static String JOB_LIST_DONE_NOT_DONE = '0'; // not done
    // Done__c picklist value of Job_List__c
    public final static String JOB_LIST_DONE_DONE = '1'; // done
    // Done__c picklist value of Job_List__c
    public final static String JOB_LIST_DONE_CANCELED = '2'; // canceled

    // The Name of the CABO User Profile
    //public final static String PROFILE_CABO_USER = 'CABO_User_Profile';

    //Defect 275593: Changing the Naming convention to ACSF of the User Profile
    public final static String PROFILE_CABO_USER = 'ACSF_User_Profile';

    // The API Name of the Permission Set for Sales Users Supervisors
    // public final static String PERMISSION_SET_SUPERVISOR = 'ACSF_Supervisor';
    // public final static String PERMISSION_SET_RETAIL_ADMIN = 'ACSF_Retail_Admin';
    // public final static String PERMISSION_SET_SALES_USER = 'ACSF_Sales_User';
    public final static String ACSF_MD_ADMIN_PERMISSION_SET = 'ACSF_Master_Data_Admin';
    public final static String ACSF_USER_PROFILE = 'ACSF_User_Profile';
    public final static String ACSF_USER_PROFILE_NON_SALES = 'ACSF_User_Profile_Non_Sales';  
    public final static String ACSF_FM_PERMISSION_SET = 'ACSF_FM';    
    public final static String ACSF_FA_PERMISSION_SET = 'ACSF_FA';    
    public final static String ACSF_KAM_PERMISSION_SET = 'ACSF_KAM';

     //Defect 275593: Changing the Naming convention to ACSF of the Permission Set for Sales Users Supervisors
    public final static String PERMISSION_SET_SUPERVISOR = 'ACSF_Supervisor';
    public final static String PERMISSION_SET_RETAIL_ADMIN = 'ACSF_Retail_Admin';
    public final static String PERMISSION_SET_SALES_USER = 'ACSF_Sales_User';

    //Rounding_Rule__c picklist values of Unit_of_Measure__c
    public final static string RULE_NEVER = 'Never';
    public final static string RULE_UP  = 'Up';
    public final static string RULE_DOWN = 'Down';
    public final static string RULE_NEAREST = 'Nearest';
    public final static string RULE_USER_EXIT = 'User Exit';
    public final static boolean ROUNDING_TARGET = true;

    //Quantity_Rounding__c picklist values in Order Template
    public final static string ROUNDING_DEFAULT_ON = 'RoundingDefaultOn';
    public final static string ROUNDING_ALWAYS_ON = 'RoundingAlwaysOn';
    // Phase__c picklist values of object Promotion__c
    public final static String PROMOTION_PHASE_COMMITTED = 'Committed';

    //Picklist value Job_Action_Success__c for Job_DL_Job_Definition_Template__c
    public final static string JOB_ACTION_DETACH = 'Detach';

    // Phase__c picklist values of object Promotion__c
    public final static String PROMOTION_PHASE_CANCELLED = 'Cancelled';

    // Phase__c picklist values of object Promotion__c
    public final static String PROMOTION_PHASE_PLANNING = 'Planning';

    // Developer name of Account recordtype
    public final static String CUSTOMER_RECORD_TYPE = 'Customer';

    // Developer name of Locked Promotion recordtype
    public final static String PROMOTION_RECORD_TYPE_LOCKED = 'Locked';

    // Comparision for ProductAssortmentProductTriggerHandler and ProductAssortmentAccountTriggerHandler class
    public final static Integer BULK_HANDLE_CHECK = 1;

    //Trigger name object 'Product_Assortment_Product__c'
    public final static String PRODUCT_ASSORTMENT_PROD_TRIGGER = 'ProductAssortmentProductTrigger';

    //Trigger name object 'Product_Assortment_Account__c'
    public final static String PRODUCT_ASSORTMENT_ACC_TRIGGER = 'ProductAssortmentAccountTrigger';

    //Trigger name object 'Account_Wholesaler__c'
    public final static String ACCOUNT_WHOLESALER_TRIGGER = 'AccountWholesalerTrigger';

    // Account Multiplicity value 1 for ProductAssortmentAccountTriggerHandler class
     public final static String ACCOUNT_MULTI_ZERO = '0';

    // Account Multiplicity value 1 for ProductAssortmentAccountTriggerHandler class
     public final static String ACCOUNT_MULTI_ONE = '1';

    // Account Multiplicity value m for ProductAssortmentAccountTriggerHandler class
    public final static String ACCOUNT_MULTI_M = 'm';

    // Account Multiplicity value n for ProductAssortmentAccountTriggerHandler class
     public final static String ACCOUNT_MULTI_N = 'n';

    //Standard set controller limit- used for pagination
    public final static String PROD_ASSORTMENT_STANDARD_SET_CONTROLLER_LIMIT= '5000';

    //Trigger name object 'Product_Assortment'
    public final static String PRODUCT_ASSORTMENT_TRIGGER = 'ProductAssortmentTrigger';

    //Trigger name object 'Account_Delivery_Recipient__c'
    public final static String ACCOUNT_DELIVERY_RECIPIENT_TRIGGER = 'AccountDeliveryRecipientTrigger';

    //Trigger name object 'Account_Call_Setting__c'
    public final static String ACCOUNT_CALL_SETTING_TRIGGER = 'AccountCallSettingTrigger';

    //Trigger name object 'Account_Trade_Org_Hierarchy__c'
    public final static String ACCOUNT_TRADE_ORG_HIERARCHY_TRIGGER = 'AccountTradeOrgHierarchyTrigger';

    //Trigger name object 'Account_Org_Unit__c'
    public final static String ACCOUNT_ORG_UNIT_TRIGGER = 'AccountOrgUnitTrigger';

    //Trigger name object 'Org_Unit_User__c'
    public final static String ORG_UNIT_USER_TRIGGER = 'OrgUnitUserTrigger';

    //String value for Product_Assortment__c in class DateRangeValidationUtil
    public final static String STRING_PRODUCT_ASSORTMENT ='Product_Assortment__c';

    //Trigger name object 'Org_Unit_Hierarchy__c'
    public final static String ORG_UNIT_HIERARCHY_TRIGGER = 'OrgUnitHierarchyTrigger';

    //Trigger name object 'Promotion__c'
    public final static String PROMOTION_TRIGGER = 'Promotion';

    //Trigger name object 'Call__c'
    public final static String CALL_TRIGGER = 'CallTrigger';

    //Trigger name object 'Event'
    public final static String EVENT_TRIGGER = 'EventTrigger';

    //Trigger name object 'Attachment'
    public final static String ATTACHMENT_TRIGGER = 'AttachmentTrigger';

    //Trigger name object 'Call_Job__c'
    public final static String CALL_JOB_TRIGGER = 'CallJobTrigger';

    //Trigger name object 'Data_Type_Option__c'
    public final static String DATA_TYPE_OPTION_TRIGGER = 'DataTypeOptionTrigger';

    //Trigger name object 'Job_Definition_List_Account__c'
    public final static String JOB_DEFINITION_LIST_ACCOUNT_TRIGGER = 'JobDefinitionListAccountTrigger';

    //Trigger name object 'Job_Definition_List__c'
    public final static String JOB_DEFINITION_LIST_TRIGGER = 'JobDefinitionListTrigger';

    //Trigger name object 'User'
    public final static String USER_TRIGGER = 'UserTrigger';

    //Trigger name object 'User_Setting__c'
    public final static String USER_SETTING_TRIGGER = 'UserSettingTrigger';

    // Variable for Comma
    public final static String STRING_COMMA = ',';

    // Parent Account Sync Batch error src/email/unfiled$public/ columes
    public final static String BATCH_ERROR_FILE_COLUMNS = 'ID,ParentID,Error';    

    // Account Manager & Team Batch error src/email/unfiled$public/ columes
    public final static String BATCH_ERROR_FILE_COLUMNS_MANAGER = 'AccountID,UserId,AccountAccessLevel,TeamMemberRole,Error'; 

    // Batch error src/email/unfiled$public/ name
    public final static String BATCH_ERROR_FILE_NAME = 'Failed_AccountProcessing.csv';  

    // Variable for new Line
    public final static String STRING_NEW_LINE = '\n';

    // Variable for Account Team Role to be assigned for the ATM Created by Batch
    public final static String ACCOUNT_MANAGER_TEAM_ROLE = 'AccountManager';

    // Variable for DeveloperName
    public final static String DEVELOPERNAME = 'DeveloperName';

    // Account share Edit Access
    public final static String ACCOUNT_SHARE_EDIT = 'Edit';

    // Name for any object inside test classes
    public final static String NAME = 'TestClass_Testing';

    // Description Languages for any object inside test classes
    public final static String DESC_LAN_1 = 'English';
    public final static String DESC_LAN_2 = 'French';
    public final static String DESC_LAN_3 = 'Spanish';

    //Picklist value for any object inside test classes
    public final static String MANAGEMENT_TYPE = 'Sales';

    // Product Assortment Object API Name
    public final static String OBJECT_PRODUCT_ASSORTMENT = NAMESPACEPREFIX+'Product_Assortment__c';    
    // Product Assortment Account Object API Name
    public final static String OBJECT_PRODUCT_ASSORTMENT_ACCOUNT = NAMESPACEPREFIX+'Product_Assortment_Account__c';
    // Call Job Object API Name
    public final static String OBJECT_CALL_JOB = NAMESPACEPREFIX+'Call_Job__c';
    // Call Object API Name
    public final static String OBJECT_CALL = NAMESPACEPREFIX+'Call__c';
    // Job List Object API Name
    public final static String OBJECT_JOB_LIST = NAMESPACEPREFIX+'Job_List__c';
    // Event Object API Name
    public final static String OBJECT_EVENT = 'Event';
    // Account Object API Name
    public final static String OBJECT_ACCOUNT = 'Account';
    // Call Template Object API Name
    public final static String OBJECT_CALL_TEMPLATE = NAMESPACEPREFIX+'Call_Template__c';
    // Data Type Object API Name
    public final static String OBJECT_DATA_TYPE = NAMESPACEPREFIX+'Data_Type__c';
    // Data Type Option Object API Name
    public final static String OBJECT_DATA_TYPE_OPTION = NAMESPACEPREFIX+'Data_Type_Option__c';
    // Historic Product Object API Name
    public final static String OBJECT_HISTORIC_PRODUCT = NAMESPACEPREFIX+'Historic_Product__c';
    // Job Definition Object API Name
    public final static String OBJECT_JOB_DEFINITION = NAMESPACEPREFIX+'Job_Definition__c';
    // Job Definition List Object API Name
    public final static String OBJECT_JOB_DEFINITION_LIST = NAMESPACEPREFIX+'Job_Definition_List__c';
    // Job Definition Template Object API Name
    public final static String OBJECT_JOB_DEFINITION_TEMPLATE = NAMESPACEPREFIX+'Job_Definition_Template__c';
    // Job DL Job Definition Template Object API Name
    public final static String OBJECT_JOB_DL_JOB_DEFINITION_TEMPLATE = NAMESPACEPREFIX+'Job_DL_Job_Definition_Template__c';
    // Product Assortment Template Object API Name
    public final static String OBJECT_PRODUCT_ASSORTMENT_TEMPLATE = NAMESPACEPREFIX+'Product_Assortment_Template__c';

    // Payment Method field API Name
    public final static String FIELD_PAYMENT_METHOD = 'Payment_Method__c';

    // Compensation Model field API Name
    public final static String FIELD_COMPENSATION_MODEL = 'Compensation_Model__c';

    // Amount field API Name
    public final static String FIELD_AMOUNT = 'Amount__c';

    // Lift field API Name
    public final static String FIELD_LIFT = 'Lift__c';

    // Tactic Template field API Name
    public final static String FIELD_TACTIC_TEMPLATE = 'Tactic_Template__c';

    //Variable for Apex keyword
    public final static String APEX = 'apex';

    //Name for page DeletePromotionExceptionCheck
    public final static String PROMOTION_EXCEPTION_CHECK = 'DeletePromotionExceptionCheck';

    //Name for page DeleteProdAssortmentAccExceptionCheck
    public final static String PRODUCT_ASSORTMET_ACC_EXCEPTION_CHECK = 'DeleteProdAssortmentAccExceptionCheck';

    //Name for page DeletePromotionProductExceptionCheck
    public final static String PROMOTION_PRODUCT_EXCEPTION_CHECK = 'DeletePromotionProductExceptionCheck';

    //Name for permission set CABO_Master_Data_Admin
    //public final static String CABO_MD_ADMIN_PERMISSION_SET = 'CABO_Master_Data_Admin';

     //Defect 275593: Changing the Naming convention to ACSF of Permission set
    public final static String CABO_MD_ADMIN_PERMISSION_SET = 'ACSF_Master_Data_Admin';

    //Name for profile CABO_User_Profile_Non_Sales
    //public final static String CABO_USER_PROFILE_NON_SALES = 'CABO_User_Profile_Non_Sales';

    //Defect 275593: Changing the Naming convention to ACSF of the User Profile
    public final static String CABO_USER_PROFILE_NON_SALES = 'ACSF_User_Profile_Non_Sales';

    //Name for profile CABO_User_Profile
    //public final static String CABO_USER_PROFILE = 'CABO_User_Profile';

     //Defect 275593: Changing the Naming convention to ACSF of the User Profile
    public final static String CABO_USER_PROFILE = 'ACSF_User_Profile';

    //Name for permission set CABO_KAM
    public final static String CABO_KAM_PERMISSION_SET = 'ACSF_KAM';


    // Order Entry related constants

    //Product Search Listing Type
    public final static String SEARCH_LISTINGS = 'L';

    //Product Search Promotion Type
    public final static String SEARCH_PROMOTIONS = 'P';

    //Product Search Empty String or NONE string
    public final static String EMPTY_STRING = '';
    Public final static String NONE_STRING = '--None--';
    public final static String FIELD_TYPE_PICKLIST = 'Picklist';
    public final static String FIELD_TYPE_MULTIPICKLIST = 'MultiPicklist';
    public final static String PRODUCT_FIELDSET_TO_DISPLAY = NAMESPACEPREFIX+'ProductSearchDisplayFields';
    public final static string PRODUCT_UOM_FIELDSET = NAMESPACEPREFIX+'ProductUOMFields';

    //Picklist values for phases
    public final static String ORDER_PHASE_CANCELLED = 'Cancelled';
    public final static String ORDER_PHASE_RELEASED = 'Released';
    public final static String ORDER_PHASE_READY = 'Ready';
    public final static String ORDER_PHASE_INITIAL = 'Initial';

    //Picklist values for Closed Listing on Order Template
    public final static String CLOSED_LISTING_YES = '1';
    public final static String CLOSED_LISTING_USER_EXIT = '2';
    public final static string CONSIDER_LISTING_PROMOTION_NO = '0';

    //Picklist values for Consider Promotion on Order Template
    public final static String CONSIDER_PROMOTION_YES = '1';
    public final static String CONSIDER_PROMOTION_USER_EXIT = '2';

    //Picklist values for Consider Max History Days to add on Order Template
    public final static String MAX_HISTORY_DAYS = '180';

    //Order Interface names
    public final static String LISTING_FINDING_INTERFACE_NAME = 'ListingFinding';
    public final static String PROMOTION_FINDING_INTERFACE_NAME = 'PromotionFinding';
    Public final static string BASIC_PRICE_INTERFACE_NAME = 'BasicPriceCalc';

    // Order related Object API Name
    public final static String OBJECT_ORDER = 'Order__c';
    public final static String OBJECT_ORDER_ITEM = 'Order_Item__c';
    public final static String OBJECT_PRODUCT = 'Product__c'; 

    //Standard set controller limit- used for pagination
    public final static Integer ORDER_PRODUCTS_QUERY_LIMIT= 1000;

    //Discount Type on Order Line Items
    public final static String DISCOUNT_TYPE_AMOUNT = 'Amount';
    public final static String DISCOUNT_TYPE_PERCENTAGE = 'Percentage';

    //Picklist values for Price Effect on Order Item Template
    public final static String PRICE_EFFECT_ADDITIVE = '1';
    public final static String PRICE_EFFECT_NEUTRAL = '0';
    public final static String PRICE_EFFECT_SUBTRACTIVE = '-1';

    //Picklist values for Unit_Type__c of Unit_Of_Measure__c
    public final static string ConsumerUnit = 'ConsumerUnit';
    public final static string Layer = 'Layer';
    public final static string Pallet = 'Pallet';
    public final static string SalesUnit = 'SalesUnit';

    //Picklist value for Order_Item_Template Use Built in Prcing
    public final static string BUILT_IN_PRICING = 'Yes';
    public final static boolean EXCLUDE_ORDER_ROUNDING = False;

    //Picklist values for Done__c on Job_List__c
    public static final String JOB_LIST_DONE_STATUS_NOT_DONE = '0';
    public static final String JOB_LIST_DONE_STATUS_DONE = '1';
    public static final String JOB_LIST_DONE_STATUS_CANCELLED = '2';

    //Picklist values for Creation Platform
    public final static String CREATION_PLATFORM_LAPTOP = 'Laptop';
    public final static String CREATION_PLATFORM_MOBILITY = 'Mobility';
    public final static String CREATION_PLATFORM_BOTH = 'Both';

    //Null value for String in Url
    public final static String NULL_VALUE = 'null';
    public final static Decimal NULL_DECIMAL_VALUE = null;
    public final static String STRING_NULL = null;

    // Developer name of Product_Assortment_Template__c Assortment List recordtype
    public final static String PRODUCT_ASSORTMENT_TEMPLATE_AUTH_LIST_RT = 'Product_Assortment_Type';
    public final static String PROMOTION_AGGREGATION_BATCH= 'PromotionAggregationBatch';
    public final static String AUTH_LIST_AGGREGATION_BATCH = 'AuthorizationListAggregationBatch';

    //Picklist Level_1__c for Object Order_Template_Product_Selector_Group__c
    public final static String All = 'All';
    public final static String BASKET = 'Basket';
    public final static String NEW_P = 'New';
    public final static String OUT_OF_STOCK = 'OutOfStock';
    public final static String HISTORY = 'History';
    public final static String CATEGORY = 'Category';
    public final static String SUBCATEGORY = 'SubCategory';

    //Picklist Level_2__c for Object Order_Template_Product_Selector_Group__c
    public final static String LEVEL_2_CATEGORY = 'Category';
    public final static String LEVEL_2_PROMOION = 'Promotion';

    //Static values for Address Type DeliveryRecipient or WholeSaler
    Public final static string DELIVERY_RECP = 'DeliveryRecipient';
    Public final static string WHOLESALER = 'Wholesaler';

    //Picklist values for Price Type in Order_Template__c
    Public final static string FACTORY = 'factory';
    Public final static string CONSUMER = 'consumer';
    public final static string NotRelevant = 'NotRelevant';

    //Defect 273205: Naming Convention in Accenture Cloud
    public final static string ACSF_MOBILITY = 'ACSF_Mobility%';

    public final static string ACSF = 'ACSF%';


    //Picklist values for Anchor Type in Order_Template__c
    Public final static string ANCHOR_TYPE_CUSTOMER = 'Customer';
    Public final static string ANCHOR_TYPE_PRODUCT = 'Customer Product';

    //Picklist values for Status in Fund
    Public final static string FUND_STATUS_ACTIVE = 'Active';

    //Picklist values for Transaction Type in Transaction
    Public final static string TRANSACTION_TYPE_INITIAL = 'Initial';
    Public final static string TRANSACTION_TYPE_TRANSFER = 'Transfer';
    Public final static string TRANSACTION_TYPE_ADJUSTMENT = 'Adjustment';

    //Picklist values for Company Required
    public final static String COMPANY_REQUIRED_MANDATORY = 'Mandatory';
    public final static String COMPANY_REQUIRED_OPTIONAL = 'Optional';   

    //Trigger name object 'Sales_Organization_User__c'
    public final static String SALES_ORG_USER_TRIGGER = 'SalesOrgUserTrigger';
    //Trigger name object for Sales_Organization__c
    public final static String SALES_ORG_TRIGGER= 'SalesOrgtrigger ';

    //ProductList Size for Call Survey Execution
    public final static Integer PRODUCT_LIST_SIZE = 25;

    //ProductList Size for Order Execution
    public final static Integer PRODUCT_WRAPPER_SIZE = 15;

    //constant name for Custom setting  CallOrderDistribution
    public final static String CALL_DISTRIBUTION_SETTING = 'CallDistributionSetting';
    public final static String ORDER_DISTRIBUTION_SETTING = 'OrderDistributionSetting';
    public final static String DISTRIBUTION_SETTING = 'DistributionReorganizationBatch';
    public final static string DISTRIBUTION_INPUT = 'DistributionReorganizationInputView';
    public final static string DISTRIBUTION_BL = 'DistributionReorganizationExecution';
    public final static string CALL_START_TIME = 'Call_Start_Time';
    public final static string WORK_BEGINS = 'Work_Begins__c';

    //Sales Org Name 
    public final static String SALES_ORG_CANADA = 'Canada';
    public final static String SALES_ORG_USA = 'USA';
    public static final String NO_TRANSACTION_ID_PRESENT = 'No transaction id present';

    //Sales Org Curency Name 
    public final static String SALES_ORG_USA_CURRENCY = 'USD';

    //Sales Org Curency Name 
    public final static String SALES_ORG_CANADA_CURRENCY = 'CAD';

    //Tactic Template Name
    public final static String TACTIC_TEMPLATE = 'Sample Template';

    //Promotion Record Type Name
    public final static String PROMOTION_RECORDTYPE ='Promotion';
    public final static String SELLABLE_PROMOTION_RECORDTYPE ='SellablePromotion';
}