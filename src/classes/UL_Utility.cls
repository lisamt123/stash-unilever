/***************************************************************
    Name: UL_Utility
    Copyright © 2016 Accenture Pvt. Ltd.
    ======================================================
    Purpose:
    Utility class to manage generic project keywords and methods.
    ======================================================
    History
    -------
    VERSION     AUTHOR         DATE         DETAIL             Description
    1.0         Ketan Mehta    15/10/2016   INITIAL DEV        Generic project keywords defined. 
    ***************************************************************/
    public with sharing class UL_Utility{ 
      
        public static final String ESCAPE_QUOTE= '\'';
        public static final String SPACE= ' ';
        public static final String HYPHEN= '-'; 
        public static final String UNDERSCORE= '_';  
        public static final String APPLICATION_NAME = 'TPM';
        public static final String NEWLINE_CHAR= '\n';
        public static final String RECORD_OPEN_PARAM= '/o';
        public static final String RECORD_EDIT_PARAM= '/e';
        public static final String PROMOTION_TYPE_ONE= 'Volume and Value';
        public static final String PROMOTION_TYPE_TWO= 'Value Only';
        public static final String MANAGEDPACKAGE_NAMESPACE= 'ACCL__';
        public static final String EMPTY_STRING = '';
        public static final String FORWARD_SLASH = '/';
        public static final Id NULL_ID = null;
        public static final SObject NULL_OBJECT = null;
        public static final String NULL_VALUE = 'null';
        public static final String STRING_NULL = null;
        public static final Date NULL_DATE = null;
        public static final Double NULL_DOUBLE = null;
        public static final Boolean BOOLEAN_TRUE = true;
        public static final Boolean BOOLEAN_FALSE = false;
        public static final String FIELD_SPLITTER = ',';
        public static final String BOM_PRODUCT = 'BoM';
        public static final String DATE_FORMAT_YYYY_MM_DD = 'yyyy-MM-dd';
        
        //Customer Org Hierarchy Levels - SOCO
        public static final String CUSTOMER_ORG_HIERARCHY_LEVEL_REGION = 'Region';
        public static final String CUSTOMER_ORG_HIERARCHY_LEVEL_SUB_REGION = 'Sub Region';
        public static final String CUSTOMER_ORG_HIERARCHY_LEVEL_MCO = 'MCO Customer Name';
        public static final String CUSTOMER_ORG_HIERARCHY_LEVEL_COUNTRY = 'Country';
        public static final String CUSTOMER_ORG_HIERARCHY_LEVEL_HOLDING = 'Holding';
        public static final String CUSTOMER_ORG_HIERARCHY_LEVEL_BANNER = 'Banner';
        public static final String CUSTOMER_ORG_HIERARCHY_LEVEL_SOLD_TO_GROUP = 'Sold To Group';
        public static final String CUSTOMER_ORG_HIERARCHY_LEVEL_SOLD_TO = 'Sold To';
        
        //Levels
        public static final String LEVEL1= 'Level 1';
        public static final String LEVEL2= 'Level 2';
        public static final String LEVEL3= 'Level 3';
        public static final String LEVEL4= 'Level 4';
        public static final String LEVEL5= 'Level 5';
        public static final String LEVEL6= 'Level 6';
        public static final String LEVEL7= 'Level 7';
        public static final String LEVEL8= 'Level 8';
        public static final String LEVEL9= 'Level 9';
        
        // The API Name of the Permission Set
        public static final String ACSF_FM_PERMISSION_SET = 'ACSF_FM';    
        public static final String ACSF_FA_PERMISSION_SET = 'ACSF_FA';    
        public static final String ACSF_KAM_PERMISSION_SET = 'ACSF_KAM';
        
        //Picklist values for Transaction Type in Transaction
        Public static final string TRANSACTION_TYPE_INITIAL = 'Initial';
        Public static final string TRANSACTION_TYPE_TRANSFER = 'Transfer';
        Public static final string TRANSACTION_TYPE_ADJUSTMENT = 'Adjustment'; 
        
        //Approval Process workflow
        Public static final string FUND_TRANSFER_TRANSACTION_APPROVAL_PROCESS = 'UL_Fund_Transaction_Approval';
        
        //Promotion Copy and Delete
        Public static final set<string> PROMOTIONSTATUS = new set<string>{'Planning'};
        Public static final string STATUS = 'status';
        Public static final string CUSTOMER = 'Customer';
        Public static final string PROMOTION_STATUS= 'Planning';
        
        //UKI
        public static final String NONE= 'None';
        public static final String SPECIAL_HOLIDAY= 'SpecialHoliday';
        public static final String MARKETING_EVENT= 'MarketingEvent';
        public static final String Qulon= ':';
        public static final String UK_SO = 'UK SO';
        public static final String Ireland_SO = 'Ireland SO';
        public static final String LTA = 'LTA';
        public static final String PARENT_PROMOTION = 'Parent Promotion';
        public static final String ACCOUNT_SPECIFIC_PROMOTION = 'Account Specific Promotion';
        
        //Boolean flags for Bypassing Triggers
        public static boolean bypassAccountTrigger = false;
        public static boolean bypassApprovalThresholdTrigger = false;
        public static boolean bypassCannibalisationRateTrigger = false;
        public static boolean bypassDeliveryProfileTrigger = false;
        public static boolean bypassFundShareTrigger = false;
        public static boolean bypassFundTransactionTrigger = false;
        public static boolean bypassProductTrigger = false;
        public static boolean bypassProductPartTrigger = false;
        public static boolean bypassPromotionShareTrigger = false;
        public static boolean bypassPromotionTrigger = false;
        public static boolean bypassTacticTrigger = false;
        public static boolean bypassUserCustomerPromFundShareTriggerTrigger = false;
        
        //Heroku webservice setup
        public static final String END_POINT= 'callout:ACSF_Service_Url/ACSF/GetPromotionKPIs';
        public static final Integer SERVICE_TIMEOUT = 12000;
        public static final String REQUEST_TYPE = 'POST';
        public static final String CONTENT_TYPE = 'application/json';
        public static final String TOKEN_URL = '/ACSF/GetPromotionKPIs';
        public static final String CONTENT_TYPE_TEXT = 'Content-Type';
        public static final List<String> KPI_REQUEST = new List<String>{'GMV','INVT','ROIP','ONCT','INCV','BASE'};
        
        //Comparison
        public static final String COMPARE_LESS_THEN = '<';
        public static final String COMPARE_GREATER_THEN = '>';
        public static final String COMPARE_NOT_EQUAL = '<>';
        public static final String COMPARE_EQUALS = '=';
        
        //Status
        public static final String STATUS_APPROVE = 'Approve';
        public static final String STATUS_REJECT = 'Reject';
        public static final String STATUS_ACTIVE = 'Active';
        public static final String STATUS_APPROVED = 'Approved';
        public static final String STATUS_SUBMIT = 'Submit';
        public static final String STATUS_SUBMITED = 'Submitted';
        public static final String STATUS_PENDING = 'Pending';
        public static final String STATUS_PLANNING = 'Planning';
        public static final String STATUS_FINANCE_CHECK = 'Finance Check';
        public static final String STATUS_MANAGER_CHECK = 'Manager Check';
		public static final String STATUS_SUBMITTED_FOR_APPROVAL = 'Submitted for Approval';		
               
        //User Org Role
        public static final String ROLE_CATEGORY_MANAGER = 'category manager';
        public static final String ROLE_FINANCE_MANAGER = 'finance manager';
        public static final String ROLE_ACCOUNT_MANAGER = 'account manager';
       

        //Exception Status Codes
        public static final String FIELD_CUSTOM_VALIDATION_EXCEPTION = 'FIELD_CUSTOM_VALIDATION_EXCEPTION';
        
        //Sales Org
        public enum SalesOrg{
            AR01,
            CL01,
            CL03,
            SoCo
        }
        
    /** ------------------------------------------------------------------ Public methods Section  ------------------------------------------------------------------/** 
    
    /*******************************************************************
    Purpose: Generic error logging method
    Version: 1.0
    Parameters: Exception ex, loggedIn userId
    Returns: Void
    Throws N/A
    ********************************************************************/
    public static void logError(Exception ex, Id currentUserId){
    try{
        if(ex!= null){
            String errorClassName, errorMethodName;
            string exceptionMessage = ex.getStackTraceString();
            exceptionMessage = exceptionMessage.subStringAfter('Class.');
            exceptionMessage = exceptionMessage.subStringBefore(UL_Utility.Qulon);
            errorClassName = exceptionMessage.subStringBefore('.');
            errorMethodName = exceptionMessage.subStringAfter('.');
            ExceptionLoggingHelper.createErrorLog(currentUserId, errorClassName, errorMethodName, ex.getMessage(), ex, NULL, NULL, NULL, NULL,  UL_Utility.APPLICATION_NAME);
            
        }
    }
    catch(Exception e){
        system.debug('An error occured while logging error message');
    }
   }
   
   /*******************************************************************
    Purpose: Generic method to create SFDC object
    Version: 1.0
    Parameters: ObjectSchemaResult
    Returns: SObject
    Throws N/A
    ********************************************************************/
   public static SObject getNewObject(Schema.DescribeSObjectResult obj){
       SObject newObject = UL_Utility.NULL_OBJECT;
        if(obj != null){
            try{
                Schema.SObjectType objectType = Schema.getGlobalDescribe().get(obj.getName());
                newObject = objectType.newSobject();
            }catch(Exception ex){
                UL_Utility.logError(ex, UserInfo.getUserId());
            }
        }
        return newObject;
    }
    
    /*******************************************************************
    Purpose: Generic method to create dropdown option
    Version: 1.0
    Parameters: N/A
    Returns: SelectOption object
    Throws N/A
    ********************************************************************/ 
        public static SelectOption getNewOption(Boolean isDisabled){
        SelectOption selectOption = null;
        try{
            selectOption = new SelectOption(UL_Utility.EMPTY_STRING, UL_Utility.EMPTY_STRING, isDisabled);
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        return selectOption;
    }
   
   /*****************************
    Purpose: Generic method to get parent sales org. E.g SoCo is the parent sales org for AR01 or CL01 child sales org etc.
    Version: 1.0
    Parameters: String child sales org
    Returns: String parent sales org
    Throws: Exception
   ******************************/ 
   public static String getParentSalesOrg(String childSalesOrg){
        String parentSalesOrg = UL_Utility.STRING_NULL;
        try{
        if(!String.isEmpty(childSalesOrg)){
            Map<String, UL_Sales_Org_Mapping__c> salesOrgSettings = UL_Sales_Org_Mapping__c.getAll();
              Map<String, UL_Sales_Org_Mapping__c> internalMap = new Map<String, UL_Sales_Org_Mapping__c>();
              for(String key: salesOrgSettings.keyset()){
                internalMap.put(key.toLowerCase(), salesOrgSettings.get(key));
              }
            
            if(internalMap.containsKey(childSalesOrg.toLowerCase())){
           parentSalesOrg = internalMap.get(childSalesOrg.toLowerCase()).UL_Sales_Org__c;
            }
        }
        }catch(Exception ex){
            UL_Utility.logError(ex, userInfo.getUserId());
        }
        return parentSalesOrg;
    }
    
    /*****************************
    Purpose: Get generic product from system
    Version: 1.0
    Parameters: N/A
    Returns: Product Record
    Throws: N/A
    ******************************/
    public static ACCL__Product__c returnGenericProduct(){
        return [SELECT Id, Name FROM ACCL__Product__c WHERE UL_Generic_Product__c=TRUE LIMIT 1];
    }
    
    /*****************************
    Purpose: Get generic customer planning level from system
    Version: 1.0
    Parameters: N/A
    Returns: Product Record
    Throws: N/A
    ******************************/
    public static UL_Planning_Level__c returnGenericCustomer(){
        return [SELECT Id, Name, UL_Customer__c FROM UL_Planning_Level__c WHERE UL_Customer__r.UL_Generic_Customer__c=TRUE LIMIT 1];
    }
  }