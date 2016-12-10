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
        public static final String HYPHEN= ' - ';   
        public static final String APPLICATION_NAME = 'TPM';
        
        public static final String PROMOTION_TYPE_ONE= 'Volume and Value';
        public static final String PROMOTION_TYPE_TWO= 'Value Only';
        public static final String MANAGEDPACKAGE_NAMESPACE= 'ACSFUL001__';
        public static final String EMPTY_STRING = '';
        public static final String FORWARD_SLASH = '/';
        public static final Id NULL_ID = null;
        public static final SObject NULL_OBJECT = null;
        public static final String NULL_VALUE = 'null';
        public static final String STRING_NULL = null;
        public static final Date NULL_DATE = null;
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
  }