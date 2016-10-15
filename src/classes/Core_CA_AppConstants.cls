public with sharing class Core_CA_AppConstants {


    /* Service response error messages */
    public static final String ERROR_MSG_UNEXPECTED_ERROR_OCCURED = 'Unexcepted exception encountered, please try again later';
    public static final String SVC_RESP_MESSAGE_INVALID_SVCNAME = 'Invalid service requested, please check the service name requested for';
    public static final Integer RESPONSE_SUCCESS_CODE = 200;
    public static final Integer RESPONSE_FAILURE_ERROR_CODE = 400;
    public static final String RESPONSE_SUCCESS_MSG = 'SUCCESS';


    /*  Service name constants */
    public static final String SVC_GET_MY_APPROVALS_DATA = 'GetMyApprovalsData';
    public static final String SVC_GET_REQUEST_DETAIL_DATA = 'GetExpenseDetailData';
    public static final String SVC_GET_LINEITEM_DETAIL_DATA = 'GetLineItemDetailData';
    public static final String SVC_VALIDATE_APPROVEREJECTACTION = 'ValidateApproveRejectAction';
    public static final String SVC_POST_APPROVEREJECTACTION = 'PostApproveRejectAction';
    public static final String SVC_SEARCH_CON = 'SearchContactService';
    public static final String SVC_EMAIL_DOMAIN_GET = 'GetEmailDomainList';
    public static final String SVC_EMAIL_DOMAIN_UPDATE = 'UpdateNewEmailDomain';

    /*  Serach utility constants */
    public static final String SEARCH_RECORDS_DEFAULT_LIMIT = '100';
    public static final integer PAGINATION_INDEX = 0;
    public static final integer PAGINATION_BLOCK_SIZE = 100;
    
    /* Mobile Approval app constants */
    public static final String DATA_REQUEST_TYPE_EXPENSE = 'GTES';
    public static final String DATA_REQUEST_TYPE_PURCHASE_REQUEST = 'Ariba';
    public static final String DATA_REQUEST_TYPE_ARIBA = 'Purchase Request';
    public static final String DATA_REQUEST_TYPE_GTES = 'Expense';
    public static final String DATA_REQUEST_TYPE_INVOICE = 'Invoice';
    public static final String Data_Role_Approver = 'APP';
    public static final String Data_Action_Approved = 'APPR';
    public static final String Data_Action_Rejected = 'REJC';
    public static final String Data_Action_Active = 'ACTV';
    public static final String Data_Status_Approved = 'Approved';
    public static final String Data_Status_Rejected = 'Rejected';
    public static final String Expense_Status_Type = 'All';
    public static final Integer RecordsShownCount = 0;

}