/**
* @author Cognizant
* @date 23/09/2015
* @description This class is used for holding the string constants being referenced across
*              all the classes 
*/
public class IPM_ConstantUtils {
     
    //UI Compatibilty
    public static String UA_COMPATIBLE='X-UA-Compatible';
    public static String IE_EDGE='IE=edge';
    //General Apex Exception variables starts
    public static String DUPLICATE_EXCEPTION='DUPLICATE_VALUE';
    public static String CUSTOM_VALIDATION_EXCEPTION='FIELD_CUSTOM_VALIDATION_EXCEPTION';
    public static String EXCEPTION_CAUGHT ='Exception caught: ';
    //General Apex Exception variables ends
    //Space between two values
    public static String IPM_SPACE=' ';
    //Rollouts variables starts
    public static String ROLLOUT_LEADER = 'First';
    public static String ROLLOUT_FOLLOWER = 'Follower';
    public static String PROJECT_LEADER = 'Project Leader';
    public static String NO_ROLLOUT='No Rollout';
    //Rollouts variables ends
    
    //For Group Management variable starts
    public static String IPM= 'IPM';
    
    //Gate Document variables starts
    public static String STATUS_ALL = 'All';
    public static String STATUS_EXCLUDED = 'Excluded';
    public static String STATUS_NOT_STARTED = 'Not Started';
    public static String STATUS_STARTED = 'Started';
    public static String STATUS_NOT_FILLED = 'Filled-in';
    public static String STATUS_APPROVED = 'Approved';
    public static String PD_STATUS_STOPPED = 'Stopped';
    public static String GD_ATTACHMENT_SUFFIX = 'Gate_Document';
    public static final String COMMENT_TYPE='TextPost';
    
    //used across classes to get the gate document type
    public static final String CHARTER_GATE='Charter';
    public static final String CONTRACT_GATE='Contract';
    public static final String MARKET_READY_GATE='Market Ready';
    public static final String MARKET_DEPLOYMENT_GATE='Market Deployment';
    
    //used across classes to get the Section Status
    public static final String GATE='Gate';
    public static final String GATEKEEPING_MODEL_GCLT='GCLT';
    public static final String GATEKEEPING_MODEL_RCLT='RCLT';
    public static final String GATEKEEPING_MODEL_BOTH='GCLT & RCLT';
    
    public static final String COMPLEXITY_FULL='Full';
    public static final String COMPLEXITY_LITE='Lite';
    public static final String SECTION_STATUS_FILLED ='Filled-in';
    
    
    public static final String SECTION_TYPE_HEADER='Header';
    public static final String SECTION_TYPE_SUBHEADER='Sub Header';
    
    public static final String PROJECT_SPAN_GLOBAL='Global';
    public static final String PROJECT_SPAN_REGIONAL='Regional';
    public static final String PROJECT_SPAN_LOCAL='Local';
    
    public static final String COMPANY_CARD_GLOBAL='Global';
    public static final String COMPANY_CARD_REGIONAL='Regional';
    public static final String COMPANY_CARD_LOCAL='Local';
    
    // to store the section External ID used in IPM_CreateGateDocuments controller
    public static final  String OTIF_SECTION_EXTERNAL_ID='OTIF_Status';
    
    //to store the CRRT Statuses
    public static final String CRRT_STATUS_NO_CHANGE='No Change';
    public static final String CRRT_STATUS_DISCONTINUED='Discontinued';
    public static final String CRRT_STATUS_REPLACE='Replace';
    
    //to store OTIF Sections
    public static final String STATIC_TABLE='Static Table';
    public static final String OTIF_STATUS='OTIF Status';
    public static final String OTIF='OTIF';
    public static final String OTIF_TABLE='Table';
    public static final String OTIF_SECTION='Section';   
    public static final String OTIF_YES='Yes';
    public static final String OTIF_NO='No'; 
    public static final String OTIF_PARTLY='Partly';
    public static final String OTIF_NOT_APPLICABLE='Not Applicable';
    public static final String OTIF_STATUS_GREEN='Green';
    public static final String OTIF_STATUS_RED='Red';
    public static final String OTIF_STATUS_AMBER='Amber';
    
    //to store OTIF report related values
    public static final String OTIF_SCOPING_COMPLETE='Scoping Complete';
    public static final String OTIF_TECHNICAL_ACTION_STANDARDS_ACHIEVED_BY_LEAD_REGION='Technical Action Standards Achieved by Lead Region';
    public static final String OTIF_MATERIALS_SOURCING_STRATEGIES_AGREED='Materials Sourcing Strategies Agreed';
    public static final String OTIF_ATTRACTIVE_BUSINESS_CASE='Attractive Business Case';
    public static final String OTIF_TECHNICAL_FEASIBILITY='Technical Feasibility';
    public static final String OTIF_CAPEX_APPROVED='Capex Approved';
    public static final String OTIF_CUSTOMER_APPEAL='Customer Appeal';
    public static final String OTIF_BASES_I='Bases I';
    public static final String OTIF_BASES_II='Bases II';
    public static final String OTIF_BASES_III='Bases III';
    public static final String OTIF_SPEC_BILLS_OF_MATERIALS_IN_INTERSPEC='Spec/Bills of Materials in Interspec';
    public static final String OTIF_TECHNICAL_AND_PRODUCTION_CAPABILITY_CONFIRMED='Technical and Production Capability Confirmed';
    public static final String OTIF_COMMUNICATION_BET_FINAL_RELEASE_AVAILABILITY='Communication: BET Final Release Availability';
    public static final String OTIF_COMMUNICATION_FULL_THINK_BIG_PACK_AVAILABLE='Communication: Full Think Big Pack Available';    
    public static final String OTIF_CONCEPT_TEST='Concept Test';    
    public static final String OTIF_FIRST_PROD_CONF_SPEC_FINALISED='First Production Confirmed and Specifications Finalised';        
    public static final String OTIF_TECH_PROD_CAPABILITY_CONF_MAIN_PLANT='Technical and Production Capability Confirmed at Main Plant';    
    
     //for gate Document
    public static final String INTRODUCTION_HEADER_SEQUENCE='1';
    public static final String EXTERNAL_HEADER_SEQUENCE='2';
    public static final String MIX_HEADER_SEQUENCE='3';
    public static final String DEPLOYMENT_HEADER_SEQUENCE='4';
    public static final String TECHNICAL_HEADER_SEQUENCE='5';
    public static final String FINANCE_HEADER_SEQUENCE='6';
    public static final String PROJECT_MANAGEMENT_HEADER_SEQUENCE='7';
    public static final String APPENDIX_HEADER_SEQUENCE='8';
    public static final String APPENDIX_HEADER_SEQUENCE_FOR_QUERY='8.%';
    public static final String PERCENTAGE='%';
    public static final String EIGHT_PERCENTAGE='8%';
    public static final String SECTION_TYPE_TEXT='Text';
    public static final String SPECIAL_CHARACTERS='<[^>]+>';
    public static final String OPTION_NONE='--None--';
    public static final String APPENDIX='Appendix';
    public static final String RISK_SECTION='Risk';
    public static final String CMI_SECTION='Mix_Qualification_Plan_and_Action_Standards';
    public static final String CUSTOMER_CHANNEL_SECTION='Customer Channels';
    public static final String UNDERSCORE='_';
    public static final String BLANK='';
    public static final String SLASH='/';
    public static final String YES='/';
    public static final String NO='/';
    //Gate Document variables ends
    
    //Bosscard variables starts
    //used for bosscard status
    public static final String STATUS_IN_PROGRESS = 'In Progress';
    public static final String STATUS_NOT_APPROVED = 'Not Approved';
    public static final String STATUS_DISCARD = 'Discard';
    //Bosscard variables ends
    
    //CoreParameter field variables starts
    public static final String CORE_MARKET_DEFAULT='Dishwash';
    public static final String CORE_SECTOR_DEFAULT='Cleaning Tools';
    public static final String CORE_SUB_SECTOR_DEFAULT='Machine Wash'; 
    public static final String CORE_REGION_DEFAULT='Europe'; 
    public static final String CORE_PLATFORM_DEFAULT='Sample 1';
    public static final String CORE_COMPANY_DEFAULT='GIC HHC'; 
    
    public static final String CORE_STRATEGIC_BLG ='BLG';
    public static final String CORE_STRATEGIC_INNOVATION='Innovation';
    public static final String CORE_STRATEGIC_RENOVATION ='Renovation';
    public static final String CORE_STRATEGIC_OPERATIONAL ='Operational';
    
    public static final String CORE_QUESTION_ONE='Question1';
    public static final String CORE_QUESTION_TWO='Question2';
    public static final String CORE_QUESTION_THREE='Question3';
    public static final String CORE_QUESTION_ONE_W='Question one';
    public static final String CORE_QUESTION_TWO_W='Question two';
    public static final String CORE_QUESTION_THREE_W='Question three';
    
    //to store project phase
    public static final String FEASIBILITY_PHASE='Feasibility';
    //error variable for all classes
    public static final String ERROR='Error';
    //to store BOSSCARD sections
    public static final String CONSUMER_NEED='Consumer Need';
    public static final String ENVIRONMENTAL_IMPACT='Environmental Impact';
    public static final String STRATEGIC_FIT='Strategic Fit';
    public static final String FEEDBACK_FROM_BOSSCARD='Feedback from BOSSCARD';
    
     //to store BOSSCARD external Id
    public static final String CONSUMER_NEED_EXTERNAL_ID='Consumer_Need';
    public static final String ENVIRONMENTAL_IMPACT_EXTERNAL_ID='Environmental_Impact';
    public static final String STRATEGIC_FIT_EXTERNAL_ID='Strategic_Fit';
    
    public static final String POS_QUESTIONNAIRE_RECORDTYPE='POS Questionnaire';
    public static final String RQS_QUESTIONNAIRE_RECORDTYPE='RQS Questionnaire';
    public static final String CORPORATE_RISK_QUESTIONNAIRE_RECORDTYPE='Corporate Risk';
    public static final integer RISK_QUESTIONNAIRE_SCORE=3;
    public static final integer POS_QUESTIONNAIRE_SCORE=3;
    
    // financial constant
    
    public static final string YEAR_3='3';
    public static final string YEAR_5='5';
    public static final string EXCEPTION_CHANGESUSTAINABILITY='changeSustainabilityPeriod';
    public static final string EXCEPTION_CHECKSUSTAINABILITY= 'checkSustainabilityPeriodChanged';
    public static final string EXCEPTION_UPLOADDOWNLOADTEMPLATE ='uploadDownloadTemplate';
    public static final string EXCEPTION_IPM_FINANCIALCOPYPASTEGRID='IPM_FinancialCopyPasteGrid';
    public static final string EXCEPTION_GOTOSECTION='goToSection';
    public static final string EXCEPTION_REFRESHFINANCIALS='refreshFinancials';
    public static final string EXCEPTION_CHANGETABS='changeTabs';
    public static final string EXCEPTION_EDITFINANCIALS='editFinancials';
    public static final string EXCEPTION_SAVEFINANCIALS='saveFinancials';
    public static final string EXCEPTION_REFRESHFROMLOCAL='refreshFromLocal';
    public static final string EXCEPTION_REFRESHFROMREGIONAL='refreshFromRegional';
    
    
    
    
    public static String PHASE_IDEAS='Ideas';
    public static String PHASE_FEASIBILITY='Feasibility';
    public static String PHASE_CAPABILITY='Capability';
    public static String PHASE_MARKET_READY='Market Ready';
    public static String PHASE_MARKET_DEPLOYMENT='Market Deployment';
    public static String PHASE_PLE='PLE';
    
    public static String IPMGLOBAL = 'Global';
    public static String IPMREGIONAL = 'Regional';
    
    public static String FUNCTIONAL_ROLE_ALL='All';
    public static String FUNCTIONAL_ROLE_BD='BD';
    public static String FUNCTIONAL_ROLE_CMI='CMI';
    public static String FUNCTIONAL_ROLE_CD='CD';
    public static String FUNCTIONAL_ROLE_RD='R&D';
    public static String FUNCTIONAL_ROLE_RnD='RnD';
    public static String FUNCTIONAL_ROLE_FINANCE='Finance';
    public static String FUNCTIONAL_ROLE_BB='BB';
    public static String FUNCTIONAL_ROLE_SC='SC';
    public static String FUNCTIONAL_ROLE_PL='PL';
    
    public static String TYPE_ALL='All';
    public static String TYPE_NON_NEGOTIABLE='Non-negotiable';
    public static String TYPE_NEGOTIABLE='Negotiable';
    public static String TYPE_OPTIONAL='Optional';
    public static String FUNCTIONAL_ROLE_TYPE_SUPPLY_CHAIN='Supply Chain';
    //BOSSCARD PDF Format
     public static final String BOSSCARD_PDF_FORMAT ='_BOSSCARD-'; 
    
    //Servlet URL
     public static final String SERVLET_URL='/servlet/servlet.FileDownload?file='; 
    //CoreParameter field variables ends
    
    //Functional Variable for role type starts
    public static final String IPM_ROLE_BD='BD';
    public static final String IPM_ROLE_CMI='CMI';
    public static final String IPM_ROLE_CD='CD';
    public static final String IPM_ROLE_RD='R&D';
    public static final String IPM_ROLE_SUPPLY_CHAIN='Supply Chain';
    public static final String IPM_ROLE_FINANCE='Finance';
    public static final String IPM_ROLE_BB='BB';
    public static final String IPM_ROLE_GUEST='Guest';
    public static final String IPM_ROLE_BD_MARKETING='BD Marketing';
    public static String RND_SECTION='R&D Initial Outline (Product/Pack)';
    //Functional Variable for role type ends
    
    //All the phases & their respective Gates
    public static final Map<String, String> phaseGateDocumentMap = new Map<String, String>{'Ideas' => 'Charter', 'Feasibility' => 'Contract',
                                                                                      'Capability' => 'Market Ready', 'Market Ready' => 'Market Deployment',
                                                                                      'Market Deployment' => 'n/a','PLE' => 'n/a','Stopped' => 'n/a'};
    
    public static final Map<String,Integer> phaseSequence = new Map<String,Integer>{'Ideas' => 1,'Feasibility' => 2,'Capability' => 3,'Market Ready' => 4,'Market Deployment' => 5,'PLE' => 6};
    
    public static final List<String> DEFAULT_PHASE_SEQ = new List<String>{'Ideas','Feasibility','Capability','Market Ready','Market Deployment','PLE'};
                                                                                      
    //Permission set variables starts
    public static final String PERMISSION_CENTRAL='IPM_Central_Team';
    public static final String PERMISSION_BUSINESS='IPM_Business_Partners';
    public static final String PERMISSION_BBPL='IPM_BB_PL';
    public static final String PERMISSION_DEPUTY_LEADER='IPM_Deputy_Project_Leader';
    public static final String PERMISSION_PROJECT_LEADER='IPM_ProjectLeader';
    public static final String PERMISSION_SYSTEM_ADMINISTRATOR='System Administrator';
    public static final String PERMISSION_FINANCE_TEAM='IPM_Finance_Team';
    public static final String PERMISSION_BASIC='IPMNG_Basic';
    public static final String PERMISSION_GATEKEEPER='IPM_Gatekeeper';
    public static final String PERMISSION_REPORTING='IPM_Reporting';
    
    public static final String PERMISSION_USER_ROLE_CENTRAL='Central Team';
    public static final String PERMISSION_USER_ROLE_REPORTING='Reporting';
    public static final String PERMISSION_USER_ROLE_NONE='None';
    public static final String PERMISSION_USER_ROLE_BUSINESS_PARTNER='Business Partner';
    public static final String PERMISSION_USER_ROLE_DEPUTY_BUSINESS_PARTNER='Deputy Business Partner';
    
    public static final String EDIT_ACCESS_ON_RECORDS='Edit';
    //Permission set variables ends
    
    //Image variables starts
    //used for storing the static methods  for Customer channel Image controller (to be updated to logical names. Is refered in the component also)
    public static final  String PREPOSITION_FIRST_IMAGE='p1';
    public static final  String PREPOSITION_SECOND_IMAGE='p2';
    public static final  String PROMOTION_FIRST_IMAGE='p3';
    public static final  String PROMOTION_SECOND_IMAGE='p4';
    public static final  String PRODUCT_FIRST_IMAGE='p5';
    public static final  String PRODUCT_SECOND_IMAGE='p6';
    public static final  String PACK_FIRST_IMAGE='p7';
    public static final  String PACK_SECOND_IMAGE='p8';
    public static final  String PRICE_FIRST_IMAGE='p9';
    public static final  String PRICE_SECOND_IMAGE='p10';
    public static final  String PLACE_FIRST_IMAGE='p11';
    public static final  String PLACE_SECOND_IMAGE='p12';
    public static final  String FILE_TYPE_JPG='.jpg';
    public static final  String FILE_TYPE_JPEG='.jpeg';
    public static final  String FILE_TYPE_PNG='.png';
    public static final  String FILE_TYPE_GIF='.gif';
    public static final  String FILE_TYPE_BMP='.bmp';
    public static final  String FILE_TYPE_PDS='.pds';
    public static final  String FILE_TYPE_PSP='.psp';
    public static final  String FILE_TYPE_THM='.thm';
    public static final  String FILE_TYPE_TIF='.tif';
    public static final  String FILE_TYPE_YUV='.yuv';
    
    public static final String USER_REGION='Global' ;
    //Image variables ends
    
    //Financial variables starts
    //Financial Year Variables
    public static final String Y0_YEARINDEX = '0';
    public static final String Y1_YEARINDEX = '1';
    public static final String Y2_YEARINDEX = '2';
    public static final String Y3_YEARINDEX = '3';
    public static final String Y4_YEARINDEX = '4';
    public static final String Y5_YEARINDEX = '5';

    public static final String Y0_LABEL = 'Y0';
    public static final String Y1_LABEL = 'Y1';
    public static final String Y2_LABEL = 'Y2';
    public static final String Y3_LABEL = 'Y3';
    public static final String Y4_LABEL = 'Y4';
    public static final String Y5_LABEL = 'Y5';
    
    public static final String YEAR_TYPE_INNOVATION = 'Innovation';
    public static final String YEAR_TYPE_CALENDAR = 'Calendar';
    public static final String PL_TYPE_GROSS = 'Gross';
    public static final String PL_TYPE_INCREMENTAL = 'Incremental';

    //Financial Tabs - OLD
    public static final String TAB_MYVIEW_NAME = 'myview'; // current selected tab
    public static final String TAB_TOPDOWN_NAME = 'topdown';
    public static final String TAB_ROLLUP_NAME = 'rollup';
    public static final String OPERATIONAL_SUSTAINABILITY = '5';
     
    //public static final String TAB_TOPDOWN_LABEL = 'TOP DOWN';
    public static final String TAB_BOTTOMUP_LABEL = 'BOTTOM UP';
    public static final String TAB_LOCALROLLUP_LABEL = 'LOCAL ROLLUP';
    
    //Financial Tabs - NEW for future name changes
    //Global
    public static final String TAB_TOPDOWN_LABEL = 'Top Down'; // for original
    public static final String TAB_MARKETCLUSTERBOTTOMUP_LABEL = 'Market Cluster Bottom Up';
    //Regional
    public static final String TAB_CHARTER_LABEL = 'Charter';
    public static final String TAB_GLOBALCHARTER_LABEL = 'Global Charter';
    public static final String TAB_LOCALBBROLLUP_LABEL = 'Local BB rollup';
    //Local
    public static final String TAB_MYVIEW_LABEL = 'My View'; 
     
    public static final String VOLUME_UNIT_TONS = 'Total Tons';
    public static final String VOLUME_UNIT_000_UNITS = 'Total \'000 Units';
    public static final String INVALID_DATA_TO_SAVE = 'Please rectify the values indicated in red in the table. The Business case cannot be submitted until the values are modified.';
    public static final Decimal INVALID_VALUE = 0;
    //Financial variables ends
    
    //Miscelanious variables starts
    //Default options
    public static String GATEKEEPER_CONSTANT ='Gatekeeper';
    public static String FINANCE_MEMBER_CONSTANT ='Finance Member';
    public static String HHC_CONSTANT = 'HHC';
    public static String HOUSEHOLDCARE_CONSTANT = 'Household Care';
    
    //For Financial
    public static String FINANCIAL_CONSOLIDATE = '_CONSOLIDATED';
    public static String FINANCIAL_NONKEY = '_NONKEY';
    public static String FINANCIAL_DEFAULT = '_DEFAULT';
    //For Attachment Download
    public static String ATTACHMENT_CONTENT_DISPOSITION='content-disposition';
    public static String ATTACHMENT_FILE_NAME='attachment; filename=';
    public static String ATTACHMENT_DOCUMENT='document-';
    public static String ATTACHMENT_FILE_TYPE='.pdf';
    
    // for the 6P types in Customer Channel
    public static final String PROPOSITION_TYPE='prepos';
    public static final String PROMOTION_TYPE='promo';
    public static final String PACK_TYPE='pack';
    public static final String PLACE_TYPE='place';
    public static final String PRICE_TYPE='price';
    public static final String PRODUCT_TYPE='product';
    //for the priority arrow
    public static final String UP_ARROW='up';
    public static final String DOWN_ARROW='down';
    
    public static final integer CHANNEL_PRIORITY_ONE=1;
    public static final integer CHANNEL_PRIORITY_TWO=2;
    public static final integer CHANNEL_PRIORITY_THREE=3;
    public static final integer CHANNEL_PRIORITY_FOUR=4;
    public static final integer CHANNEL_PRIORITY_FIVE=5;
    
    //for project type
    public static final String PROJECT_TYPE_ROLLOUT='Rollout';
    public static final String PROJECT_TYPE_ORIGINAL = 'Original';
    public static final String PROJECT_TYPE_OPERATIONAL = 'Operational';
    public static final String CUSTOMER_CHANNEL='Customers_Channels';
    
    public static final String RISK_SECTION_CHARTER = '7.2';
    public static final String RISK_SECTION_CONTRACT = '7.4';
    
    public static final String RISK_SECTION_CHARTER_APPENDIX = '8.9';
    public static final String RISK_SECTION_CONTRACT_APPENDIX = '8.7';
    
    public static final String RND_OUTLINE_SECTION = '5.1';
    
    public static final String ENVIRONMENTAL_IMPACT_SEQUENCE = '5.3';
    
    public static final String DYNAMIC_SECTION_SEQUENCE='7.2.1';
    
    public static final String FINANCIAL_ACTION_STANDARDS_SEQUENCE = '6.1';
    
    public static final String BB_BD_ALIGNMENT = '6.3';
    public static final String BB_BD_ALIGNMENT_APPENDIX = '8.10';
    
    public static final String INITIAL_ESTIMATE_OPPORTUNITY_SEC = '6.2';
    
    public static final String CMI_CHARTER_SECTION = '3.3';
    public static final String CMI_CONTRACT_SECTION = '3.7';
    
    public static final String CMI_CHARTER_SECTION_APPENDIX = '8.4';
    public static final String CMI_CONTRACT_SECTION_APPENDIX = '8.8';
    
    
    //for IPM approach type
    public static final String IPM_APPROACH_INTERNAL='Internal';
    public static final String IPM_APPROACH_EXTERNAL='External';
    
    //for Milestones record type
    public static final String MILESTONES_RECORDTYPE='IPM Project Milestones';
    public static final Integer MILESTONES_DUE_DATE = 21;   
    //CRRT section Sequence
    public static final String CHARTER_CRRT_SECTION_SEQUENCE='3.2.1';
    public static final String CONTRACT_CRRT_SECTION_SEQUENCE='3.3.3';
    
    public static final String CHARTER_CRRT_SECTION_SEQUENCE_APPENDIX = '8.3';
    public static final String CONTRACT_CRRT_SECTION_SEQUENCE_APPENDIX = '8.1';
    
    
    public static final String IDEAS_SEQUENCE='1.1';
     
    //Delimitor
    public static final String Delimiter=';';
     
   
    //Miscellanious variables ends

    //used in IPM_Coreparemetersview controller
    public static final String CORE_PARAMETER_STRATEGIC_TEXT ='IPM CoreParameter Strategic text';

    //used in IPM_CoreparemetersRevampTestClass 
    public static final String IPM_CORE_PARAMETER_HELPS ='Does iCONST_14t better meet the consumer needs or meet more needs?';
    public static final integer CONST_7 = 7;
    public static final integer CONST_21 = 21;
     //Financial Field Literals
     public static final String FIELD_LITERAL_VOLUME_UNIT = 'Volume_Unit_';
     public static final String FIELD_LITERAL_NPV = 'NPV_';
     public static final String FIELD_LITERAL_IRR = 'IRR_';
     public static final String FIELD_LITERAL_BIC = 'BIC_';
     public static final String FIELD_LITERAL_CAPEX = 'CAPEX_';
     public static final String FIELD_LITERAL_PAYBACK = 'Payback_';

     public static final String FIELD_LITERAL_GM_BPS = 'GM_Y1_bps_vs_DNDS_';
     public static final String FIELD_LITERAL_PBO_BPS = 'PBO_Y1_bps_vs_DNDS_';

     public static final String FIELD_LITERAL_LAST_SAVED = 'Last_Saved_';
     public static final String FIELD_LITERAL_LAST_SAVED_BY = 'Last_Saved_By_';

     //Financial Year Field Literals
     public static final String FIELD_LITERAL_VALUE_MARKET_SHARE = 'Value_Market_Share_';
     public static final String FIELD_LITERAL_VOLUME = 'Volume_';
     public static final String FIELD_LITERAL_VOLUME_TONS = 'Volume_Tons_';
     public static final String FIELD_LITERAL_TURNOVER = 'Turnover_';
     public static final String FIELD_LITERAL_GROSS_PROFIT = 'Gross_Profit_';
     public static final String FIELD_LITERAL_ADVERTISING_PROMOTIONS = 'Advertising_Promotions_';
     public static final String FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS = 'Profit_Before_Overheads_';
     public static final String FIELD_LITERAL_GM_OF_TO = 'GM_of_TO_';
     public static final String FIELD_LITERAL_AP_OF_TO = 'AP_of_TO_';
     public static final String FIELD_LITERAL_PBO_OF_TO = 'PBO_of_TO_';

     public static final String FIELD_SUFFIX_CHARTER = 'Charter';
     public static final String FIELD_SUFFIX_CONTRACT = 'Contract';
     public static final String FIELD_SUFFIX_MARKET_READY = 'MR';
     public static final String FIELD_SUFFIX_MARKET_DEPLOYMENT = 'MD';
    
     //Custom Field Suffix
     public static final String CUSTOM_FIELD_SUFFIX = '__c';
     
     //Record Type Name
     public static final String GATEKEEPER_CHECKLIST_RECORD_TYPE = 'GateKeeperChecklist';
     public static final String RNDQUESTION_RECORD_TYPE = 'RNDQuestion';
     public static final String GATEKEEPER_ANSWER='0';
     public static final String RNDFEASIBILITYQUESTION_RECORD_TYPE = 'R&D Feasibility';
     public static final String SCFEASIBILITY_RECORD_TYPE = 'Supply Chain Feasibility';
     public static final String RISKQUESTION_RECORD_TYPE = 'Corporate Risk';
     public static final String TRADEMARK_RECORD_TYPE='TradeMark';

     public static final String DEFAULT_FINANCIAL_RT = 'Default';
     public static final String CONSOLIDATED_FINANCIAL_RT = 'Consolidated';
     public static final String REGIONAL_ROLLOUT_RT = 'Regional Rollout';
     public static final String LOCAL_ROLLOUT_RT = 'Local Rollouts';
     
     //coreParameters
     public static final String BLG = 'BLG';
     public static final String Question1 ='Question1';
     public static final String STRATEGIC_TEXT='IPM CoreParameter Strategic text';
     public static final String BET_TOOLKIT='IPM_BET_Toolkit__c';
     
     //Milestones
     public static final String PHASE_POSTLAUNCHEVAL = 'Post Launch Evaluation';
     public static final String STANDARD = 'Standard';
     public static final String COMMA = ',';
     public static final String ADHOC = 'Adhoc';
     public static final String MINI = 'Mini';
     public static final String BET = 'BET';
     
     public static final String MARKETREADYWARNINGMONTHS_FIRST = '6';
     public static final String MARKETREADYWARNINGMONTHS_SECOND = '4';
     public static final String MARKETREADYWARNINGDAYS_FIRST = '180';
     public static final String MARKETREADYWARNINGDAYS_SECOND = '120';
     
     
      //Constant Declaration
    public static String DATE_FORMAT='yyyy-MM-dd' ;
    public static String PROJECT_MILESTONES='IPM Project Milestones';
    
    //Gate document various status
    public static final String DOCUMENT_STATUS_STOPPED='Stopped';
    public static final String DOCUMENT_STATUS_POSTPONED='Postponed';
    public static final String DOCUMENT_STATUS_PROPOSED='Proposed';
    public static final String DOCUMENT_STATUS_APPROVED='Approved';
     public static final String DOCUMENT_STATUS_APPROVEDWITHEDITS = 'Approved with Edits';
    //For Section History
    public static final String HISTORY_SECTION_NAME = 'IPM_Section_Name__c';
    public static final String HISTORY_SECTION_SEQUENCE = 'IPM_Section_Sequence__c';
    
    public static final String GD_CONTENT_TYPE ='application/pdf';
    public static final String GD_PDF_POSTFIX= ' Gate Document';
    public static final String GD_PDF_EMAIL_SUBJECT= 'Project';
    public static final String GD_PDF_EMAIL_BODY= 'Hi, Please find the attachment for Project ';
    
    // Project setUp
    public static final String IPM_CHARTER_APPROVER='IPM_Approver_of_Charter__c';
    public static final String IPM_GATEKEEPING_MODEL='IPM_GateKeeping_Model__c';
    public static final String IPM_CHILD_COMPLEXITY='IPM_Child_Complexity__c';
    public static final Integer IPM_PROJECT_DESC_LENGTH = 255;
    public static final String IPM_PROJECTNAME_PATTERN ='[a-zA-Z0-9_ ]+';
    public static final String IPM_PROJECT_TYPE='IPM_Project_Type__c';
    public static final String IPM_PROJECT_MARKET_TYPE_DEVELOPED = 'Developed';
    public static final String IPM_PROJECT_MARKET_TYPE_EMERGING ='Developing & Emerging';
    public static final Date IPM_TargetLaunchDate=System.today().addMonths(6);
    
    //Team Assignment variables
    public static final String TEAM_MYCATEGORY='mycategory';
    public static final String TEAM_PL='PLeader';
    public static final String TEAM_DPL='DPLeader';
    public static final String TEAM_TRUE='true';
    public static final String TEAM_PROJECTID='id';
    public static final String TEAM_ROLETYPE='RoleType';
    public static final String TEAM_CATEGORY='Category';
    public static final String TEAM_COREMEMBER='CoreMember';
    public static final String TEAM_COREGATEK='GateK';
    public static final String TEAM_CORETPL='TPL';
    public static final String TEAM_PROJECT_LEADER='Project Leader';//used in assign permissions also
    public static final String TEAM_GATEKEEPER='Gatekeeper';
    public static final String TEAM_RESEARCH_DEVELOPMENT='R&D';
    public static final String TEAM_RND='RND';
    public static final String TEAM_GUEST='Guest';
    public static final String TEAM_ALLCATEGORY='allcategory';
    public static final String TEAM_DEPUTY_PROJECT_LEADER='Deputy Project Leader';
    public static final String TEAM_TECHNICAL_PROJECT_LEADER='Technical Project Leader';
    public static final String TEAM_COREDPL='DPL';
    public static final String TEAM_COREPL='PL';
    public static final String TEAM_LAUNDRY='LAUNDRY';
    public static final String TEAM_PROJECT_LEAD='ProjectLead';
    public static final String TEAM_TEST1='Test1';
    public static final String TEAM_TEST2='Test2';
    public static final String EXPECTED_TO_FILLED_IN='Team members are expected to filled in';
    public static final String EXPECTED_TO_INCREASE_NOW='Assigned Team members are expected to increase now';
    public static final String INCREASE_BY_NOW='List of user profile members will be increased by now';
   
    //Gatedocuemt Validations URLs
    public static final String REDIRECT_URL_FOR_TASK='apex/ipm_TaskList?id=';
    public static final String REDIRECT_URL_FOR_ROLLOUT_ADD='apex/ipm_rolloutplansadd?id=';
    public static final String REDIRECT_URL_FOR_ROLLOUT_PLAN='apex/ipm_rolloutplans?id=';
    public static final String REDIRECT_URL_FOR_FINANCIAL='apex/ipm_Financial?id=';
    public static final String REDIRECT_URL_FOR_RISK='apex/IPM_ProjectDocumentSectionEditor?id=';
    public static final String REDIRECT_URL_PROJECT_DECUMENT_SECTION='&projDocSecId=';
    public static final String REDIRECT_URL_FOR_CORE_PARAMETER='apex/IPM_Core_Parameters_Revamp?id=';
    public static final String REDIRECT_URL_FOR_ROLLOUT_REDIRECT='apex/ipmrolloutplansadd?cancelRedirect=false';
   
    
    
    //For Object History
    public static final String HISTORY='History';
    public static final String FIELD='Field';
    public static final String NEW_VALUE='newValue';
    public static final String OLD_VALUE='oldValue';
    public static final String HISTORY_USER_ID='005';
    public static final String HISTORY_USER_GROUP='00G';
    public static final String HISTORY_CREATED_DATE='CreatedDate';
    public static final String HISTORY_CREATED_BY_ID='CreatedById';
    public static final String HISTORY_CREATED_BY='Created By';
    public static final String HISTORY_CREATED='created';
    public static final String HISTORY_PARENT='Parent';
    public static final String HISTORY_INSERTED='Inserted';
    public static final String HISTORY_UPDATED='Updated';
    public static final String HISTORY_DELETED='Deleted ';
    public static final String HISTORY_CHANGED='Changed ';
    public static final String HISTORY_UPDATED_BY='Updated By';
    public static final String HISTORY_HAS_UPDATED=' has updated ';
    public static final String HISTORY_HAS_CREATED='has created';
    

    //Rollouts
    public static final String ROLLOUT_TYPE_MCO = 'MCO';
    public static final String ROLLOUT_TYPE_COUNTRY = 'Country';

    public static final String ROLLOUT_STATUS_WITH_MCO = 'With MCO';
    public static final String ROLLOUT_STATUS_SEPERATE = 'Seperate';

    public static final String USER_FUNCTON_PL = 'Project Leader';
    public static final String USER_FUNCTON_FINANCE = 'Finance';
    public static final String USER_FUNCTON_FL = 'Finance Leader';
    public static final String INVOKED_FROM = 'invokedFrom';
    public static final String INVOKED_FROM_ROLLOUTS = 'Rollouts';
    public static final String ROLLOUT_LEADER_TYPE = 'RolloutLeaderType';
    public static final String ROLLOUT_PL_TYPE = 'Project';
    public static final String ROLLOUT_FL_TYPE = 'Finance';
    public static final String ROLLOUT_CNTRY_TYPE = 'Country';
    public static final String USER_FUNCTON_CL = 'Country Leader';
    public static final String ROLLOUTID = 'RolloutId';
    public static final String LEADERMEMID = 'LeaderMemid';
    public static final String EDITMODE = 'EditMode';
    public static final String EDITMODE_TRUE = 'true';
    public static final String EDITMODE_FALSE = 'false';
    public static final String ROLLOUT_SPAN = 'RolloutSpan';
    public static final String ROLLOUT_SPAN_REGIONAL = 'Regional';
    public static final String ROLLOUT_SPAN_LOCAL = 'Local';
    public static final String ROLLOUT_COPYOVER_ELIGIBLE_PHASE = 'Ideas';
    public static final string IPM_GEOGRAPHY_COUNTRY = 'Country';
    public static final string IPM_GEOGRAPHY_UNILEVERCLUSTER = 'Unilever Cluster';
    public static final string IPM_GEOGRAPHY_COUNTRYGROUP = 'country group';
    
    //ipm company card
    //Constant Declaration
    public static final String CC_RECORD_TYPE_GLOBAL='Global';
    public static final String CC_RECORD_TYPE_REGIONAL='Regional';
    public static final String CC_RECORD_TYPE_LOCAL='Local';
    public static final String SELECT_UNILEVER_CLUSTER='Select Unilever Cluster';
    public static final String SELECT_COUNTRY_CLUSTER='Select Country Cluster';
    public static final String SELECT_REGION='Select Region';
    public static final String COMPANY_CARD_RECORD_TYPE_GLOBAL='Global Company Card';
    public static final String COMPANY_CARD_RECORD_TYPE_REGIONAL='Regional Company Card';
    public static final String SELECT_COUNTRY_ISO_NAME='Select ISO Country Dependency Name';
    public static final String COMPANY_CARD_RECORD_TYPE_LOCAL='Local Company Card';
    //Upto here
    
    //team assignment
    public static final String IPM_Edit_Show_Team='showedit';
    public static final String IPM_Checktoshowedit='true';
    public static final String IPM_Project_PID='Pid';
    public static final String IPM_X_UA_Compatible='X-UA-Compatible';
    public static final String IPM_IE_9='IE=9';
    public static final String IPM_Select_Option='Select';
    public static final String IPM_Technical_Leader='Technical Leader';
    public static final String IPM_User_License='Salesforce';
    public static final String IPM_Copy_Team_From_Other_Projects='Copy Team From Other Projects';
    
    //permissions
    public static final String EDIT_ACCESS = 'Edit';
    public static final String READ_ACCESS = 'Read';
    public static final String WL_TWO = 'WL2+';
    
    //For Gate CMI
    public static final String TEST_BOSSCARD_NAME ='TestGate1';
    public static final String TEST_TASK_NAME ='testtask';
    public static final String CMI_SECTION_SEQUENCE='3.7';
    public static final String ELEMENT_FIELD='Element__c';
    public static final String TEST_FIELD='Test__c';
    public static final String THIS_FIELD='thisFld';
    public static final String TEST_STR='Test';
    public static final String GATE_FIELD='Gate__c';
    public static final String ELEMENT_CONCEPT='Concept';
    public static final String ELEMENT_PRODUCT_TEST='Product Test';
    public static final String ELEMENT_PACK_TEST='Pack Test';
    public static final String ELEMENT_FULL_MIX_VOLUME='Full Mix-Volume';
    public static final String ELEMENT_COMMUNICATION='Communication';
    public static final String TEST_IDEA_SCREENER_NIELSEN='Idea Screener - Nielsen';
    public static final String TEST_INNOSCREEN_IDEAS='Innoscreen * ideas - Ipsos';
    public static final String TEST_SNAPSHOT='Snapshot - Nielsen';
    public static final String TEST_INNOSCREEN_CONCEPTS='Innoscreen * Concepts - Ipsos';
    public static final String TEST_BUNDLE_BUILDER='Bundle Builder -Nielsen';
    public static final String TEST_BASES_I='Bases I - Nielsen';
    public static final String TEST_DESIGNER_PRE_USE='Designor pre use - Ipsos';
    public static final String TEST_BLIND_PRODUCT='Blind Product Test - Ipsos';
    public static final String TEST_BRANDED_PRODUCT='Branded Product Test - Ipsos';
    public static final String TEST_CONCEPT_PRODUCT='Concept Product test - Ipsos';
    public static final String TEST_QUANT_PACK='Quant Pack test - PRS PackEval';
    public static final String TEST_BASES_II='Bases II - Nielsen';
    public static final String TEST_BASES_III='Bases III - Nielsen';
    public static final String TEST_DESIGNER_POST_USE='Designor post use - Ipsos';
    public static final String TEST_DESIGNER_POST_USE_MIX='Designor post use with full mix - Ipsos';
    public static final String TEST_PREVIEW_MWB='Preview - MWB';
    public static final String TEST_QUAL_CONCEPT='Qual Concept';
    public static final String TEST_QUAL_PACK_TEST='Qual Pack Test';
    
    //Project Resource 
    public static final String IPM_PROJECT_RESOURCE_SHARE='IPM_ProjectResourceShare';
    public static final String DELETE_PROJECT_RESOURCE='deleteProjectResource';
    public static final String INSERT_PROJECT_RESOURCE='insertProjectResource';
    public static final String IPM_COMPLEXITY_FULL = 'Full';
    
    //Task share
    public static final String IPM_TASK_RECORDTYPE='IPM Project Tasks';
    // Task Object
    
     public static String INVALIDPROJECT ='Invalid project';
     public static String ATTACHMENT ='pdf';
     
     //For Project Overview
     public static final String FAST_TRACK_FIELD='IPM_Fast_Track_Project__c';
     public static final String CHATTER='Chatter';
     public static final String FIN_MISALIGNED_ALERT1 = 'The financials for project ';
     public static final String FIN_MISALIGNED_ALERT2 = ' and ';
     public static final String FIN_MISALIGNED_ALERT3 = ' are  misaligned.';
     public static final String FIN_TLDMISALIGNED_ALERT1 = 'The Target Launch Date on ';
     public static final String FIN_TLDMISALIGNED_ALERT2 = ' is no longer aligned with the Target Launch Date of the Regional Project, ';     
               
     //User specific literals
     public static final String USER_LOCALEKEY = 'en_US';
     public static final String USER_IPM_ROLE = 'Gate Keeper';
     public static final String USER_EMAIL_ENCODE = 'UTF-8';
     public static final String USER_TIMEZONEKEY = 'America/Los_Angeles';
     
     //Years
     public static final String YEAR_2012 = '2012';
     public static final String YEAR_2013 = '2013';
     public static final String YEAR_2014 = '2014';
     public static final String YEAR_2015 = '2015';
     public static final String YEAR_2016 = '2016';
     public static final String YEAR_2017 = '2017';
     public static final String YEAR_2018 = '2018';
     public static final String YEAR_2019 = '2019';
     public static final String YEAR_2020 = '2020';
     
     //for test classes
     public static final String IMPROVEMENT = 'Improvement';
     public static final String RADICAL='Radical';
     public static final String NEWCOREPRODUCT='New Core Product';
     public static final String NEWBENEFIT='New Benefit';
     public static final String VARIANT='Variant';
     public static final String NEXTGENERATION='Next Generation';
     public static final String BASE='Base';
     public static final String NOCHANGE='No Change';
     
     // Test class assertion messagees
     public static final String MSG_SHOULD_NOT_NULL = 'Should not be null';
     public static final String MSG_SHOULD_BE_SAME = 'Should be same';
     public static final String MSG_ISEDITABLE_SHOULD_NOT_NULL = 'isEditable should not be null.';
     
     // Record Access Level
     public static final String ACCESS_EDIT = 'Edit';
     public static final String ACCESS_SAVE = 'Save';
     
     //For Consumer Evidence
     public static final String CONCEPT_TEST_ONE='Concept 1';
     public static final String CONCEPT_TEST_TWO='Concept 2';
     public static final String CONCEPT_TEST='Concept ';
     public static final String CONSUMER_EVIDENCE_CONCEPT='Consumer_Evidence_Concept';
     public static final String CONSUMER_EVIDENCE_COMMUNICATION='Consumer_Evidence_Communication';
     
     //for Project Type
     public static final String ProjectType_Operational='Operational';
     //For Catch Block
     public static final String IPM_CONSUMER_EVIDENCE_CONTROLLER_STR='IPM_Consumer_Evidence_Controller'; 
     public static final String CREATECONCEPT_STR='crateConcept';
     public static final String SAVECONCEPT_STR='saveConcept';
     public static final String DELETECOUNTRY_STR='deleteSelectedCountry';
     public static final String ADDCONCEPT_STR='addConcept';
     public static final String SEMICOLON=';';
     public static final String CARRY_TO_CONTRACT_STR='carrytoContract';
     public static final String CARRY_TO_MARKET_READY_STR='carrytoMarketReady';
     public static final String DELETE_IMAGE_STR='deleteImage';
     public static final String DELETE_CONCEPT_STR='deleteConcept';

     public static final String GATE_KEEPER_CHECKLIST = 'Gate Keeper Checklist';
     public static final String FINANCIAL_ACTION_STANDARDS = 'Financial Action Standards';  
     public static final String ROLL_OUT_PLANS = 'Rollout Plans';
     public static final String RD_OUTLINE = 'R&D Initial Outline (Product/Pack)';
     public static final String INITIAL_ESTIMATE_OPPORTUNITY = 'Initial Estimate of Opportunity';
     public static final String CUSTOMER_CHANNELS = 'Customers/Channels';
     
    public static final Set<String> PDF_SECTION_LIST = new Set<String>{'Text','Checklist','Static Table','Dynamic Complex Table','Dynamic Simple Table'};
    
    public static final String DEFAULT_CSS_KEY = 'default';
    
    public static final String DEPLOYMENT_SECTION_NAME = 'Deployment';
    
    //Bosscard Operational parameters
    public static final String IPM_TYPE_OF_PROJECT='Type_of_Project__c';
    public static final String IPM_TYPE_OF_PROJECTCONCAT='Original,Innovation/Renovation,Operational,Brand LED Growth(BLG)';
    public static final String IPM_TYPE_OF_PROJECTCONCAT2='Innovation/Renovation,Operational,Brand LED Growth(BLG)';
    public static final String PROJECT_TYPE_ORIGINAL_VALUE1='Innovation/Renovation';
    public static final String PROJECT_TYPE_ORIGINAL_VALUE2='Brand Led Growth(BLG)';
   
    
       
    //BET approval status 
    public static final String BET_APPROVAL_APPROVED = 'Approved';
    public static final String BET_APPROVAL_REJECTED = 'Rejected';
    
    //BET Toolkit Options 
    public static final String CREATE_NEW_BET = 'Create new BET';
    public static final String NO_BET = 'No BET';
    public static final String LINK_EXISTING_BET = 'Link to existing BET';    
    
    //BET Access
    public static String BET_MANAGER_ACCESS = 'Manager';
    public static String BET_MEMBER_ACCESS = 'Member';
    
    //BET Status
    public static String BET_FIRST_RELEASE = 'First Release';
    public static String BET_FINAL_RELEASE = 'Final Release';
    public static String BET_UNRELEASED = 'Unreleased';           
     // BET Milestones related constants
    public final static string BET_MS_FIRST_RELEASE = 'BET First Release';
    public final static string BET_MS_FINAL_RELEASE = 'BET Final Release';
    public final static string STRING_BET = 'BET';
    public final static string STRING_MS_BET_FIRSTRELEASE = 'Brand Experience Toolkit(BET) First Release';
    public final static string STRING_MS_BET_FINALRELEASE = 'Brand Experience Toolkit(BET) Final Release';
    public final static string SYMBOL_PERCENTAGE = '%';
    public final static string STRING_REGIONAL_ROLES = 'BD;CD';
    public final static string STRING_LOCAL_ROLES = 'BB;CD';
    public final static string STRING_STATUS_ACTIVE = 'Active';        
    //Countries Market Type
    public static final String MARKETTYPE_DEVELOPED = 'Developed';
    public static final String MARKETTYPE_DEVELOPING = 'Developing & Emerging';
    public static final String MARKETTYPE_EMERGING = 'Emerging';
    
    public static final String EMPTY_STRING_INITIAL = '';
    public static final String EMPTY_STRING_DELIMITER = ' ';
    public static final String HYPHEN_DELIMITER = '-';     
    public static final String NEXT_LINE_STRING = '\n';
    public static final String TILDA_DELIMITER = '~';
    public static final String  EQUALS_DELIMITER = '=';
    public static final String DOT_DELIMITER = '.';
    public static final String COMMA_DELIMITER = ',';
    public static final Integer BET_DUEDATE_MONTH=7;
    public static final Integer BET_DUEDATE_YEAR=1;
    public static final Integer BET_DUEDATE_H1_MONTH=4;
    public static final Integer BET_DUEDATE_H1_DAY=15;
    public static final Integer BET_DUEDATE_H2_MONTH=6;
    public static final Integer BET_DUEDATE_H2_DAY=30;
    
    
    
     
    
    public static final String SF_ID = 'Id';
    public static final String ACTIVE_STRING = '\'Active\'';
    public static final String OUTPUTPANEL_LAYOUT_INLINE = 'inline'; 
    public static final String OUTPUTPANEL_LAYOUT_BLOCK = 'block'; 
    
    /* Map for defining copy over logic. Possible values are Project(this would copy values from previousGate) and 
    Parent(which would copy values from previous gate of Parent) */ 
    public static final Map<String,Set<String>> componentCopyOverSequence = new Map<String,Set<String>>{
                                                                            GATEKEEPER_CHECKLIST_RECORD_TYPE => new Set<String>{},
                                                                            RNDQUESTION_RECORD_TYPE => new Set<String>{},
                                                                            POS_QUESTIONNAIRE_RECORDTYPE => new Set<String>{},
                                                                            RQS_QUESTIONNAIRE_RECORDTYPE => new Set<String>{'Parent'},                              
                                                                            CORPORATE_RISK_QUESTIONNAIRE_RECORDTYPE => new Set<String>{} 
                                                                            };
   // Financial Grid implementation
   public static final Integer col_one = 1;
   public static final Integer col_four = 4;
   public static final Integer col_five = 5;
   public static final Integer col_six = 6;
   public static final Integer col_seven = 7;
   public static final Integer col_eight = 8; 
   public static final Integer col_nine = 9;
   public static final Integer col_ten = 10;
   public static final Integer col_eleven = 11;
   public static final Integer col_twelve = 12;
   public static final Integer col_thirteen = 13;
   public static final Integer col_fourteen = 14;
   public static final Integer fifteen = 15; 
   
   public static final String rowValue1 = '4';
   public static final String rowValue2 = '5';
   public static final String rowValue3 = '6';
   public static final String rowValue4 = '7';
   public static final String rowValue5 = '8';
   public static final String rowValue6 = '9';
   public static final String rowValue7 = '10';
   public static final String rowValue8 = '11';
   public static final String rowValue9 = '12';
   public static final String rowValue10 = '13';
   public static final Integer rowValue19 = 19;
   public static final Integer rowValue20 = 20;
   public static final Integer rowValue21 = 21;
   public static final String rowValue28 = '28';
    public static final String rowValue29 = '29';
    public static final String rowValue30 = '30';
    public static final String rowValue31 = '31';
    public static final String rowValue32 = '32';
    public static final String rowValue33 = '33';
    public static final String rowValue34 = '34';
    public static final String rowValue35 = '35';
    public static final String rowValue36 = '36';
    public static final String rowValue37 = '37';
   public static final String Colon = ':';
   public static final Integer intialVal = 0;
   public static final Integer MaxLimit = 49999;
   public static final String smallBI = 'Small';
   //row
   public static final Integer row_seven = 7;
   public static final Integer row_twentyseven = 27;
   //Innovation 
   public static final String SpanGlobal = 'Global';
   public static final String Regional = 'Regional';
   public static final String Local = 'Local';
   public static final String Volume = 'Volume';
   public static final String TotalTons = 'Total Tons';
   public static final String TotalTons0 = 'Total 000 Units';
   public static final String Y0Innovation = 'Y0-Innovation-';                                                                 
   public static final String Y0Calendar = 'Y0-Calendar-';
   public static final String Y1InnovationGross = 'Y1-Innovation-Gross';
   public static final String Y5InnovationGross = 'Y5-Innovation-Gross';
   public static final String Y2InnovationGross = 'Y2-Innovation-Gross';
   public static final String Y3InnovationGross = 'Y3-Innovation-Gross';
   public static final String Y4InnovationGross = 'Y4-Innovation-Gross';
   public static final String CalendarGross = '-Calendar-Gross';
   public static final String CalendarIncremental = '-Calendar-Incremental';
   public static final String Y1InnovationIncremental = 'Y1-Innovation-Incremental';
   public static final String Y2InnovationIncremental = 'Y2-Innovation-Incremental';
   public static final String Y3InnovationIncremental = 'Y3-Innovation-Incremental';
   public static final String Y4InnovationIncremental = 'Y4-Innovation-Incremental';
   public static final String Y5InnovationIncremental = 'Y5-Innovation-Incremental';
   public static final Integer QueryLimt = 22;
   public static final Integer CntField = 2;
   public static final String ClassCopyPaste = IPM_FinancialCopyPasteGrid.Class.getName();
   public static final String NullString = null;
   public static final Integer fileSize = 25000000;
   public static final String FINANCIAL_CONTROLLER_STR = '/apex/IPM_FinancialCopyPasteGrid?id=';
   public static final String BI = 'Bi';
   // Phase Change Job Status 
    public static final String JOB_STATUS_NA = 'Not Applicable';
    public static final String JOB_STATUS_PROCESSING = 'Processing';
    public static final String JOB_STATUS_FAILED = 'Failed';
    public static final String JOB_STATUS_COMPLETED = 'Completed';
    public static final String JOB_STATUS_ELIGIBLE = 'Eligible For Processing';
   
   //For Assumptions Section
   public static final String ASSUMPTIONS='Assumptions';
   public static final String MARKET_SIZE='mktSize';
   public static final String AP='ap';
   public static final String CAPEX='capex';
   public static final String COUNTRIES='countries';
   public static final String GM='gm';
   public static final String VOLUME_ASSUMPTION='vol';
   public static final String PRICING='pricing';
   public static final String RESTAGES='rest';
   public static final String CANNIBALIZATION='cannib';
   public static final String VOLUME_YEAR_2='vol2';
   //For Risk Module
   public static final String IPM_GATE_DOCUMENT_RISK_MANAGEMENT = IPM_GateDocumentRiskManagement.class.getName();
   public static final string SAVE_SCORE = 'saveScore';
   public static final string PROCEED_METHOD = 'proceed';
   public static final string CHARTER_TO_CONTRACT_RISK_QUESTIONS = 'charterToContractRiskQuestions';
   public static final string LOCAL_PROJECT_RISK_QUESTIONS = 'localProjectsRiskQuestions';
   public static final string DELETE_QUESTION = 'deleteQuestion';
   public static final string ADD_QUESTION = 'addQuestion';
   public static final string SAVE_RQS_SCORE = 'saveRQSScore';
   public static final string GENEREATE_POS_FROR_PROJECT = 'generatePOSforProject';
   public static final string GET_RECORDTYPE_ID = 'getRecordTypeId';
   public static final string GET_RECORDS = 'getRecords';
   
   //For CU Complexity
   public static final String CU_COMPLEXITY='Cu_Complexity';
   public static final String INCREASE_IN_COM_BY='Increase in complexity by';
   public static final String DECREASE_IN_COM_BY='Decrease in complexity by';
   public static final String PROJECT_EFFECT='IPM_Project_Effect__c';
   public static final String IPM_CU_COMPLEXITY='CU_And_Complexity';
      
  
  //Coreparameter operational design
   public static final string IPM_INNOVATION_RENOVATION = 'Innovation/Renovation';
   public static final string IPM_BLG = 'Brand Led Growth(BLG)';
   public static final string IPM_OPERATIONAL = 'Operational';
   public static final string IPM_BACKSLASH= '/';
   public static final string NO_TOOLKIT= 'No BET';
   public static final string CHECKED= 'checked';
   public static final string UNCHECKED= 'unchecked';
   public static final string EDITPARAMETER='EditCoreParameter';
   public static final string ADDITIONALPARAMETER='AddCoreParameter';
   //Dynamic Image Url
    public static final string IMAGE_URL= String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
    
   // Content Type for Sections
   public static final String CMIGATE_CONTENT_TYPE = 'CMI Gate';
   public static final String OTIF_CONTENT_TYPE = 'OTIF';
   public static final String EVIDENCE_CONTENT_TYPE = 'Consumer Evidence Concepts';
   public static final String CUSTOMERCHANNELS_CONTENT_TYPE = 'Customer Channels';
   public static final String ASSORTMENT_CONTENT_TYPE = 'Assortment Strategy';
   public static final String ASSUMPTIONS_CONTENT_TYPE = 'Assumptions';
   public static final String CUCOMPLEXITY_CONTENT_TYPE = 'Cu_Complexity'; 
   public static final String SF_PROJ_DOC_SEC_ID='projDocSecId';
   public static final String SF_CONTENT_ID='contentId';
   public static final String SF_PROJ_DOC_SEC_CON_ID='projDocSecConId';
   public static final String SF_DESC='desc';
   public static final String SF_SECTION_TYPE='sectionType';
   
   //task pagination size
   public static final integer NO_OF_RECORDS =5;
   

   
   //BET Field API Name : To be used while querying History Table
   public final static string STRING_PROJECT_PHASE_API = 'IPM_Phase__c';
  
   // Rollout Background Process Job Types
   public static final String JOBTYPE_PROJECTCREATION_ADHOC = 'Adhoc - Rollout Project Creation'; 
   public static final String JOBTYPE_PROJECTCREATION_PHASECHANGE = 'Phase Change - Rollout Project Creation ';
   
   // Project Background Process Job Types
   public static final String JOBTYPE_PHASECHANGE = 'Phase Change';
   public static final String JOBTYPE_PROJECTCREATION =' Project Creation';
   
   //For Gatekeeper Checklist
   public static final String RND='rnd';
   public static final String RND_FEASIBILITY='rndFeasibility';
   public static final String SC_FEASIBILITY='scFeasibility';  
   
   //For custom permission
   public static final String IPM_CENTRALTEAM_PERMISSION='IPM_CentralTeam';
   public static final String IPM_BUSINESSPARTNER_PERMISSION='IPM_Business_Partner'; 
   public static final String IPM_SYNC_TLD='SyncTLD';
   
   //For exception handling
   public static final String IPM_NG_APPLICATION='IPM NG';
   //Company Card details
   public static final String COMPANY_CARD_OBJECT='IPM_Company_Card__c';
   public static final String UNILIVER_CLUSTER='Unilever Cluster';
   public static final String COUNTRY_CLUSTER='Country Cluster';
   
  //For Financial Action Standards Component
   public static final String IPM_FINANCIAL_ACTION_STANDARD='Business_Case_Action_Standards';
   public static final Decimal IPM_FINANCIAL_ACTION_STANDARD_VALUE=0;
   
   //core parameter market and sub sector
   public static final String IPM_MARKET='Market';
   public static final String IPM_SUBSECTOR='Sub Sector';
   public static final String FEEDBACK_FROM_LAST_GATE='Feedback_from_Last_Gate';
   public static final String MASTER_PROJECT_NAME = 'IPM_MasterProject';
   
    
   //For BET release date messages
   public static final String BET_FIRST_RELEASE_MESSAGE_STR1 = ' will be launching on ';
   public static final String BET_FIRST_RELEASE_MESSAGE_STR2 = ' and hence the BET 1st release should be delivered by ';
   public static final String BET_FINAL_RELEASE_MESSAGE_STR1 = ' will be launching on ';
   public static final String BET_FINAL_RELEASE_MESSAGE_STR2 = ' and hence the BET Final release should be delivered by ';
   
   // Notifiaction Constants 
   public static final String PLANNED = 'The planned ';
   public static final String DUE_DATE = 'The due date for';
   public static final String DUE_DATE_STR2='If your timeline has changed then update the expected Contract approval date in the Milestones table and state the reason for the change in the OTIF summary box in gate section 7.6.';
   public static final String OF_MSG = 'of ';

   public static final String PASSED_WITHOUT_GATE_APPROVAL = ' has been passed without Gate Approval. Please update your due date.';
   public static final String GATE_APPROVAL_DATE = ' gate approval date for ';
   public static final String MAIL_SENT_RESPONSE = 'Mail sent!';
   public static final String ERROR_STR = 'Error';
   public static final String SUCCESS_STR = 'Success';
   public static final String EXECUTE_METHOD = 'execute IPM_DueDateNotificationBatch';
   public static final String EMAIL_EXCEPTION = 'EmailException';
   public static final String GENERALIZED_EXCEPTION = 'GeneralizedException';
   public static final Integer minDueDaysDiffrence = 0; // Due days minimum diffrence with milstone due date 
   public static final Integer maxDueDaysDiffrence = 21; // Due days maxixmum diffrence with milstone due date
   public static final String BUSINESS_CASE_SAVED='The Business Case was just saved.';
   
   
   //files size limit
    public static final String FILESIZE_LIMIT='exceeds the maximum size limit';
     //security model strings
   public static final String IPM_IPMNNAME='IPM_';
   public static final String IPM_QUEUE='Queue';
   public static final String IPM_PROJECTOBJECT='IPM_Project__c';
   public static final String IPM_BOSSCARDOBJECT='IPM_Bosscard__c';
   public static final String IPM_FINANCEOBJECT='IPM_Financial__c';
   public static final String IPM_COUNTRYOBJECT='IPM_Country__c';
   public static final String IPM_ROLLOUTOBJECT='IPM_Project_Rollout__c';
   public static final String IPM_DOCUMENTSECTIONCONTENT='IPM_Project_Document_Section_Content__c';
   
   //BET Search related Constants
   public final static string CATEGORY_TYPE ='Category';
   public final static string CATEGORY_STATUS_ACTIVE = 'Active';
   
   //gate document section security
   public static final String IPM_ROLLOUT_PLANS='Rollout_Plans';
   public static final String IPM_MILESTONES_DOC='Milestones';
   public static final String IPM_CUTOMER_OPPORTUNITY='Customer Opportunities and Challenges';
   public static final String IPM_GATEKEEPE_CHECKLIST='Gate_Keeper_Checklist'; 
   public static final String IPM_PACK_GRAPHICS='Pack_Graphics';
   public static final String KEY_ISSUES_NEEDING_FOCUS_IN_GATE_MEETING='Key_Issues_needing_focus_in_Gate_Meeting';
   
   //Ecodesign
   public static final String ECODESIGN_MARKET_PLACE_ACTIVITY_BLG = 'BLG';
   public static final String ECODESIGN_PROJECT_TYPE_OPERATIONAL = 'Operational';
   public static final String ECODESIGN_SYNC_STATUS_ERROR = 'Error';
   public static final String ECODESIGN_SYNC_STATUS_IN_PROGRESS = 'In Progress';
   public static final String ECODESIGN_SYNC_STATUS_READY = 'Ready';
   public static final String ECODESIGN_SYNC_STATUS_SUCCESS = 'Success';
   //batch class
   public static final String IPM_BATCHAPEX='BatchApex';
   public static final String IPM_PROCESSING='Processing';
   public static final String IPM_PREPARE='Preparing';
   public static final String IPM_QUEUED='Queued';
   public static final String IPM_JOBSTATED_AT='Job Started At ';
   public static final string IPM_QUEUE_CRNT_METHOD='queueCreation';//hold method name
   public static final string IPM_QUEUE_UPDATE_METHOD='GroupQueueUpdate';//hold method name
   public static final string IPM_QUEUE_UPDATENAME_METHOD='groupNameUpdate';//hold method name
   public static final string IPM_GRP_MEM_UPDATE_METHOD='groupmemberupdate';//hold method name
   
   
   public static final string IPM_HOUR = String.valueOf(Datetime.now().hour());
   public static final string IPM_MIN = String.valueOf(Datetime.now().minute() + 10); 
   public static final string IPM_SECOND= String.valueOf(Datetime.now().second());
   //parse to cron expression
   public static final string IPM_NEXT_FIRE_TIME= IPM_SECOND + ' ' + IPM_MIN + ' ' + IPM_HOUR + ' * * ?';
   public static integer IPM_BATCHLIMIT=100;
   //bosscard
   public static final string IPM_Q='Q';
   public static final string IPM_BOSSCARD_PATTERN='[a-zA-Z0-9 ]+$';
   public static final string IPM_HOMEPAGE_URL='/apex/IPM_HomePage';
   public static final string IPM_BOSS_CANCEL='cancel';
   public static final string IPM_BOSS_QUARTER='getListOfQuarter';
   public static final string IPM_BOSS_BRANDPOS='getBrandPos';
   public static final string IPM_BOSS_CATEGORY='getCategory';
   public static final string IPM_BOSS_COMPANYC='getAllcompanycard';
   public static final string IPM_BOSS_DELETEBOSSC='DeleteBosscard';
   public static final string IPM_BOSS_USERTYPE='getIpmuserType';
   public static final string IPM_BOSS_REAMOVEAPPR='removeApprover';
   public static final string IPM_BOSS_REMOVELOGO='removeBosscardLogo';
   public static final string IPM_BOSS_SAVE='save';
   public static final string IPM_BOSS_PDF_CONTENT='content-disposition';
   public static final string IPM_BOSS_PDF_FILENAME='attachment; filename=';
   public static final string IPM_BOSS_PDF_FORMAT='.pdf';
   public static final string IPM_BOSS_STATUS='IPM_Bosscard_Status__c';
   public static final string IPM_BOSS_CREATE_PROJECT = 'createProject';
   public static final string IPM_BOSS_BOSSCARD_CTRL = 'IPM_BosscardStatusController';
   public static final string IPM_BOSS_BOSSCARDUPDATE='updateStatus';
   public static final string IPM_BOSS_INPROGRESS='In Progress';
   public static final string IPM_BOSS_APPROVED='Approved';
   public static final string IPM_BOSS_NOT_APPROVED='Not Approved';
   public static final string IPM_BOSS_DISCARD='Discard';
   public static final string IPM_BOSS_CHANGE_BOSS_STATUS='Change Bosscard Status';
   public static final string IPM_BOSS_CSS_COMPLETED='completed';
   public static final string IPM_BOSS_CSS_STATUS='status';
   public static final string IPM_BOSS_CSS_STOPPED='stopped';
   //For Consolidated
   public static final String IPM_GLOBAL_CONSOLIDATED_CONTROLLER_STR = 'IPM_Global_Consolidated_Controller';
   public static final String GET_SUMMARY_STR= 'getSummary';
   
   //For Brand Position status
   public static final String BRANDPOSITION_STATUS_INACTIVE= 'Inactive';
   public static final String BRANDPOSITION_STATUS_ACTIVE= 'Active';
   //Image upload
   public static final String IPM_IMGUPLOAD_ISPROJECT='isProject';
   public static final String IPM_IMGUPLOAD_ISEDIT='isEdit';
   public static final String IPM_IMGUPLOAD_TRUE='true';
   public static final String IPM_IMGUPLOAD_UPLOADMETHOD='upload';
   public static final String IPM_IMGUPLOAD_IMGSRC='<img src=';
   public static final String IPM_IMGUPLOAD_CLOSE='>';
   
   public static final String IPM_UPDATECHILD_PROJECT='updateChildProjects';
   public static final String IPM_UPDATEGLOBAL_PROJECT='updateProjectName';
   public static final String IPM_ENVIRONMENTAL_IMPACT=system.label.IPM_Environmental_Impact;
   
   //coreparameter CSS
   public static final String IPM_OPERATIONAL_SLIDER='oprtnSliderbar';
   public static final String IPM_OPERATIONAL_BLUEPOINTER='bluePointer';
   public static final String IPM_ANSWER_CHECKED='checked';
   public static final String IPM_ANSWER_UNCHECKED='unchecked';
   
   //DML operation
   public static final String OPERATION_INSERT ='Insert';
   public static final String OPERATION_UPDATE ='Update';
   
   // 'Target Launch Date Updated From' picklist values
   public static final String TLD_UPDATED_FROM_NONE ='None';
   public static final String TLD_UPDATED_FROM_ROLLOUT ='Rollout';
   public static final String TLD_UPDATED_FROM_PROJECT ='Project';
   
   // local project notifications (REQ02445 & REQ02446)
   public static final String EMAIL_NOTIFICATION_BODY ='Dear {Gate Keeper}, The Target Launch Date and/or Business Case for {Project Name} have been modified post-{Phase} gate.';
   public static final String EMAIL_NOTIFICATION_SUBJECT ='Target Launch Date and/or Business Case updated';
   //DEF2339 & DEF2344 fix
   public static final String CHARTER_GATE_APPROVAL_MILESTONE = 'Charter Gate Approval';
   public static final String CONTRACT_GATE_APPROVAL_MILESTONE = 'Contract Gate Approval';
   public static final String MARKET_READY_GATE_APPROVAL_MILESTONE = 'Market Ready Gate Approval';
   public static finaL String SHIPTO_TRADE_TLD='Ship To Trade (Target Launch Date)';
   public static final Integer KB_TO_BYTES = 1024;
}