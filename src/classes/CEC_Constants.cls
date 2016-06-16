/***********************************************************************************
Name:  CEC_Constants
Copyright@: 2016  Unilever
====================================================================================
====================================================================================
Purpose: All the constants for CEC app.                                                                                        

=====================================================================================
=====================================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Sathish           Dec-2015      New class refactored from CEC_AlertActionHelper Class.   
1.1      Koti              Dec-2015      Added page size values.
1.2      Masood            Jan-2016      Added static values for TASK and Drafts.
*************************************************************************************/
public with sharing class CEC_Constants {
    public static final String ALERT_ACTION_COUNTRYGROUP = 'CountryChatterGroup';
    public static final String ALERT_ACTION_CATEGORYGROUP = 'CategoryChatterGroup';

    // Alert Action Types.
    public static final String ALERT_ACTION_TYPE_EMAIL = 'Email';
    public static final String ALERT_ACTION_TYPE_CHATTER = 'Chatter Post';
    
    //Page size in CEC_IRIProductLocator.
    public static final String VALUE_FIVE = '5';
    public static final String VALUE_TEN = '10';
    public static final String VALUE_TWENTY = '20';
    public static final String VALUE_THIRTY = '30';
    public static final String VALUE_FOURTY = '40';
    public static final String VALUE_FIFTY = '50';
    public static final String VALUE_ZERO = '0';
    public static final String VALUE_TWO = '2';
    public static final String VALUE_FOUR = '4';
    
    //Constants for CEC_TH1_DraftTrigger
    public static final String DRAFT_STATUS ='Approved';
    public static final String PRIORITY ='High';
    public static final String TASK_STATUS='Not Started';
    
    //Constants for CEC_FulfilmentHelper
    public static final String CANCELLED ='Cancelled';
    public static final String REACTIVATED ='Reactivated';
    public static final String ISSUED ='Issued';
    public static final String STATUS_NEW ='New';
    
    public static final String LOCALIDENTIFIER_CPF = 'CPF';
    
    // Constants for Case Description Parser.
    public static final String ADDRESS1 = 'ADDRESS1';
    public static final String ADDRESS2 = 'ADDRESS2';
    public static final String CITY = 'CITY';
    public static final String PROVINCE = 'PROVINCE';
    public static final String STATE = 'STATE';
    public static final String POSTAL = 'POSTAL';
    public static final String ZIPCODE = 'ZIP CODE';
    public static final String ZIP = 'ZIP';
    public static final String COUNTRY = 'COUNTRY';
    public static final String LASTNAME_v1 = 'LASTNAME';
    public static final String LASTNAME_v2 = 'LAST NAME';
    public static final String FIRSTNAME_v1 = 'FIRSTNAME';
    public static final String FIRSTNAME_v2 = 'FIRST NAME';
    public static final String EMAIL_ADDRESS = 'EMAIL ADDRESS';
    public static final String EMAIL = 'EMAIL';
    public static final String BRAND = 'BRAND';
    public static final String UPC = 'UPC';
    public static final String STORE_NAME= 'STORE NAME';
    
    
    //String literals for using in test class
    public static final String UK = 'United Kingdom';
    public static final String unknownEmail ='unknown@unilever.com';
    public static final String languageUS ='en_us';
    public static final String cmmCountry ='Brazil';
    public static final String caseStatus = 'New';
    public static final String caseOrigin = 'Email';
    public static final String suppliedName = 'Test Abc';
    public static final String none = '-None-';
    public static final String PersonMailingPostalCode = 'TA10 0AB';
    public static final String issuedDebitCardNumber = '82472182382234';
    public static final String newDebitCardNumber = '23847238497238';
    public static final String chequebookName = 'CB1';
    
}