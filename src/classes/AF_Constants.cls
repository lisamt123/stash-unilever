/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Constants
@CreateDate : 2/10/2014
@Description : This is a common class used in the application to refer the user types and standard variables 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public class AF_Constants 
{
    public static final String APP_NAME = 'Unilever Agencies';
    public static final String BASE_FEES_WITH_AGENCY = 'With Agency';
    public static final String BASE_FEES_READYFORPO = 'Ready for PO';
    public static final String BASE_FEES_WIHTCMCO = 'With CMCO';
    public static final String BASE_FEES_INITIATE = 'Initiate';
    public static final String BASE_FEES_PROCUREMENT = 'Procurement';
    public static final String OOPS_ACTUAL_READYFORPO = 'Ready for PO';
    public static final String BONUS_SUMMARY_READYFORPO = 'Ready for PO';
    public static final String ANNUAL_BONUS_QUAL = '5';
    public static final String CATEGORY_FINANCE = 'With Category Finance'; 
    public static final string CATEGORY_FINANCE_Bonus_Quarterly='W/Cat Finance';
    public static final string BASE_FEES_WITH_AGENCY_DRAFT='With Agency (Draft)';
    public static final String STATUS_DRAFT = 'Draft';
    public static final String STATUS_NONE = 'None';
    public static final String STATUS_SUBMITTED = 'Submitted';
    public static final String IS_PILOT = 'IsPilot';
    public static final String NULL_Key = 'Null';
    public static final String TRADITIONAL='Trad';
    public static final String DIGITAL='Digital';
    public static final String TRADITIONAL_DIGITAL='TD';
    public static final String CATEGORY_OPTION='SCC';
    public static final String FISCALYEAR='2014';
    public static final String YTG_RED='red';
    public static final String YTG_BLACK='black';
    public static final String COUNTRY='AF_Country__c';
    public static final String BRANDVALUE='brandvalue';
    public static final String BRANDID='Brandid';
    public static final String AGENCYID='Agencyid';
    public static final String PARENTID='parentId';
    public static final String QUARTER='quarter';
    public static final String COUNTRY_TOTAL='CountryTotal';
    public static final String COUNTRY_NAME='CountryName';
    public static final String IS_ERROR='IsError';
    public static final String ERRORMESSAGE='ErrorMessage';
    public static final String TOTAL='total';
    public static final String USERID='userid';
    //public static final String YEAR = 'year';
    /*Attachment Types*/
    public static final String SOW='SOW';
    public static final String SCOPE_OF_WORK='Scope Of Work';
    public static final String FEE_TEMPLATE='Fee Template Summary';
    public static final String DOCUMENTS='Other Documents';
    public static final String OTHER='Other';
    /* SObject API Name */
    public static final String SOBJECT_BRANDESTIMATE_APINAME = 'AF_Brand_Estimate__c';
    public static final String SOBJECT_AGENCYESTIMATE_APINAME = 'AF_Agency_Estimate__c';
    public static final String SOBJECT_BONUS_SUMMARY_APINAME = 'AF_Bonus_Summary__c';
    public static final String SOBJECT_BONUS_MATRIX_APINAME = 'AF_Bonus_Matrix__c';
    public static final String SOBJECT_CONTROLLER_REVIEW_APINAME = 'AF_Controller_Review__c';
    public static final String SOBJECT_OOPSESTIMATE_APINAME = 'AF_OOPS_Estimate__c';
    public static final String SOBJECT_OOPSACTUAL_APINAME = 'AF_OOPS_Actual__c';
    public static final String SOBJECT_BONUSRESULT_APINAME='AF_Bonus_Results__c';
    public static final String SOBJECT_CATEGORY_BRAND = 'AF_Category_Brand__c';
    /* Permission Set */
    public static final String PERM_CMCO_SUPERUSER = 'AF_CMCO_Super_User';
    public static final String PERM_FINANCE_CAT = 'AF_Category_Finance';
    public static final String PERM_FINANCE_REG_CAT = 'AF_Category_Finance_Regional';
    public static final String PERM_CMCO='CMCO';
    public static final String PERM_CONTROLLER='Controllers';
    public static final String PERM_PROCURMENT='AF_Procurement';
    /* User Types*/
    public static final String UT_CMCO_USER = 'CMCO User';
    public static final String UT_CATEGORY_FINANCE = 'Category Finance';
    public static final String UT_AGENCY = 'Agency';
    public static final String UT_CONTROLLER = 'Controller';
    public static final String UT_CMCP_SUPERUSER = 'CMCO Super User';
    public static final String UT_REGIONAL_CATEGORY_FINANCE = 'Regional Category Finance';
    public static final String UT_PROCUREMENT = 'Procurement';
    /* Access Level*/
    public static final String AL_EDIT = 'Edit';
    public static final String AL_READ = 'Read';
    /* Record Type Name*/
    public static final String QUARTERLY_BONUS_REC_TYPE = 'Bonus Quarterly';
    public static final String ANNUAL_BONUS_REC_TYPE = 'Bonus Annual';
    public static final String RT_UNILEVER_ENTITY = 'Unilever Entity';
    public static final String RT_BRAND = 'Brand';  
    public static final String RT_AGENCY_FEE = 'Agency Fee';
    public static final String RT_CATEGORY = 'Category';
    public static final string AF_Category_Brand_RECORDTYPE_CATEGORY = 'Category';
    /*Delimiter*/
    public static final String DELIMITER = '::';
    public static final String AF_STRING_DELIMITER = ',';
    public static final String AF_SEMICOLON_DELIM = ';';
    public static final String AF_HYPHEN_DELIM = '-';
    public static final String AF_NONE_DELIM = '--None--';
    public static final String AF_BRAND_DELIM='--Brand--';
    public static final String AF_Agency_DELIM='--Agency--';
    public static final String AF_COUNTRY_DELIM='--Country--';
    /*Page Reference*/
    public static final String CLOSE_REFRESH='/apex/AF_CloseAndRefresh?IsError=true';
    public static final String ADD_COMMENT='/apex/AF_AddComment?Id=';
    public static final String REDIRECT='/00O/o';
    public static final String SEND_EMAIL_CATEGORYFINANCE='/apex/AF_Sendemail_categoryfinance';
    public static final String AGENCY_MATRIX='/apex/AF_UL_AgencyMatrix?Id=';
    public static final String EDIT_COMMENT='/apex/AF_EditComment';
    public static final String USER_SEARCHPAGE='/apex/AF_Usersearch';
    
    /*Page Parameters*/
    public static final String CATEGORY = 'category'; 
    public static final String ALL_BRANDS='All Brands';
    public static final String MY_BRANDS='My Brands';
    public static final String AGENCYPROCESS_IMAGE='/resource/x25Progress';
    public static final String CATEGORYPROCESS_IMAGE='/resource/x50Progress';
    public static final String CMCOPROCESS_IMAGE='/resource/x75Progress';
    public static final String READYFORPO_IMAGE='/resource/x100Progress';
    public static final String ZIPCODE_FOCUS='zipCodeFocus();';
    public static final String YEAR = 'Year';
    /*Quarters*/
    public static final String QUARTER1 = 'Q1';
    public static final String QUARTER2 = 'Q2';
    public static final String QUARTER3 = 'Q3';
    public static final String QUARTER4 = 'Q4';
    /*AF Currencies */
    public static final string AF_CURRENCY_EUR ='EUR';
    public static final string AF_CURRENCY_EUR1 ='EUR ';
    public static final string AF_CURRENCY_USD ='USD';
    public static final string AF_CURRENCY_GBP ='GBP';
    /*AF Countries */
    public static final string AF_ALGERIA ='Algeria';
    public static final string AF_AUSTRILIA ='austrila';
    /* BOOLEANS */
    public static final String AF_TRUE = 'true';
    public static final String AF_FALSE = 'false';
    /* Sort Order */
    public static final String  SORT_ORDER_ASC = 'asc';
    public static final String  SORT_ORDER_DESC = 'desc';
    /* REport Type */
    public static final String  BASEFEES_REPORT_TYPE = 'Base Fees';
    public static final String  OOPS_REPORT_TYPE = 'OOPS';
    public static final String  AGENCY_ESTIMATE = 'Agency Estimate';
    public static final String  COUNTRY_BREAKDOWN = 'Country Breakdown';
    public static final String  VALIDATION_ERROR = 'Manaul adjustment to Bonusablefees must reconcile back to Base Fee Matrix.';
    public static final String  TARGET = 'Target ';
    public static final String  EXCEEDED_BY = ' exceeded by ';
    public static final String  MISSING_BY = ' missing by ';
    public static final String  EURO = ' Euro';
    public static final String  RESULT_TYPE_QUARTERLY='Quarterly';
    /*Status */
    public static final String  STATUS_APPROVED = 'Approved';
    public static final String  STATUS_REJECTED = 'Rejected';
    /*Scheduler params*/
    public static final String SCHEDULERJOB_SENDEMAILTOCSCOSUPERUSER='Send Email to CSCO super user';
    public static final String SCHEDULERJOB_SENDEMAILTOCSCOSUPERUSER_SCH='0 25 15 * * ?';
    public static final String SCHEDULERJOB_STATUSCHANGEBATCH ='Status Change Batch';
    /*User Profiles*/
    public static final String USERPROFILE_SYSTEMADMIN ='System Administrator';
    public static final String USERPROFILE_AF_AGENCYPORTALUSER ='AF - Agency Portal User';
    /*Email Templates*/
    public static final String EMAIL_TEMPLATE_FINANCE = 'AF_Email_CatFinance';
    public static final String EMAIL_TEMPLATE_AF_Sendemail = 'AF_Sendemail';
    public static final String EMAIL_TEMPLATE_BATCH_TEMPLATE_CMCO = 'Batch template CMCO';
    /*Exception Messages*/
    public static final String EXCEPTION_FIELD_CUSTOM_VALIDATION_EXCEPTION = 'FIELD_CUSTOM_VALIDATION_EXCEPTION';
    public static final String EXCEPTION_ENTITY_IS_LOCKED = 'ENTITY_IS_LOCKED';
    public static final String EXCEPTION_MSG_SUBRESULT='Please ensure the values entered in the target threshold fields are ascending from minimum to outstanding';
    /*Exceptions*/
    public static final String DML_EXCEPTION = 'DMLException';
    public static final String NO_ACCESS_EXCEPTION = 'NoAccessException';
    public static final String REQUIRED_FIELD_MISSING = 'REQUIRED_FIELD_MISSING';
    public static final string REJECTED_ENTER_ACTUALS = 'Rejected - Enter Actuals';
    public static final string NOACTION = 'NoAction';
    public static final string ENTERACTUALS = 'EnterActuals';
    /*URL*/
    public static final string URL_HOMEPAGE = '/apex/AgencyHomePage?brandvalue=';
    /*Test Class*/
    public static final string TEST_ASSERT_MSG = 'The account record is inserted';
    public static final String LocaleKey = 'en_US';
    public static final String TEST_LanguageLocaleKey='en_US';
    public static final String TEST_SUPER_CATEGORY = 'Drinks';
    public static final string TEST_ASSERT_MSG_CATEGORY = 'The Category record is inserted';
    public static final string TEST_QUAL_VALUE ='Qualitative Value';
    public static final string TEST_BONUS_THRESHOLD ='Bonus Threshold';
    public static final string TEST_ANNUAL_BONUS='AF_AnnualBonus';
    public static final string TEST_CURRENCY_COUNTRY = 'Ecuador';
    public static final string TEST_COUNTRY_CODE = 'Eucador-USD';
    public static final string TEST_CURRENCY_UNIT ='US $';
    public static final string TEST_AGENCY_ENTITY_COUNTRY = 'Australia';
    public static final string TEST_UNILEVER_ENTITY_COUNTRY = 'Austria';
    public static final string TEST_USER_ALIAS_NAME = 'testc';
    public static final string TEST_USER_EMAIL ='standarduserc@unilever.com';
    public static final string TEST_EMAIL_ENCODING_KEY ='EmailEncodingKey';
    public static final string TEST_USER_LASTNAME ='Test Userc';
    public static final string TEST_USER_FIRSTNAME ='test';
    public static final string TEST_EmailEncodingKey ='UTF-8';
    public static final string TEST_TimeZoneSidKey ='Europe/London';
    public static final string TEST_AF_Category ='Test Beveragesc';
    public static final string TEST_UserName='testuseruo@test123321.com';
    public static final string TEST_BRAND='Test Brandc';
    public static final string TEST_FISCALYEAR='2013';
    public static final string TEST_Alias='testa';
    public static final string TEST_BRANDNAME='BrandName';
    public static final string TEST_CATEGORYNAME='SCC & Dressing';
    public AF_Constants()
    {
    }
}