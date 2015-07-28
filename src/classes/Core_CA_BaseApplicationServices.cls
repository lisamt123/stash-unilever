@RestResource (urlMapping='/AppService/*')
global class Core_CA_BaseApplicationServices implements Core_CA_IBaseAppicationServices{

    @HttpPost
    webservice static Core_CA_BaseApplicationWrapper invokeService(Core_CA_ApplicationWrapper appWrapperObj){

        /* Get Context objects in order to read parameters like url, cookies */
        Core_CA_BaseApplicationWrapper responseObj = null;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String svcName = null;
        String requestBodySerializedMap = '';
        if(null!=req){
            svcName = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1); /* Read service name from URL in order to invoke specific service method */
        }
        else{
            svcName = appWrapperObj.serviceName;
        }

        try{
            
            if(!Utility.isEmpty(svcName)){
               
                /**** Get myapproval data****/
                if(svcName.equals(Core_CA_AppConstants.SVC_GET_MY_APPROVALS_DATA)){                  
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.myApprovalsDataRequest = (Core_CA_WrapperUtility.MyApprovalsDataRequest) JSON.deserialize(requestBodySerializedMap, Core_CA_WrapperUtility.MyApprovalsDataRequest.class);
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_CA_MyApprovalData.getMyApprovalsData(appWrapperObj);                   
                }
                
                /**** Get RequestDetail data for Ariba or GTES****/
                if(svcName.equals(Core_CA_AppConstants.SVC_GET_REQUEST_DETAIL_DATA)){
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.expenseDetailRequest = (Core_CA_WrapperUtility.ExpenseDetailsDataRequest) JSON.deserialize(requestBodySerializedMap, Core_CA_WrapperUtility.ExpenseDetailsDataRequest.class);              
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_CA_RequestDetail.getRequestDetail(appWrapperObj);
                }
                
                /**** Get Line item detail for Ariba or GTES****/
                if(svcName.equals(Core_CA_AppConstants.SVC_GET_LINEITEM_DETAIL_DATA)){
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.lineItemDetailRequest = (Core_CA_WrapperUtility.LineItemDetailRequest) JSON.deserialize(requestBodySerializedMap , Core_CA_WrapperUtility.LineItemDetailRequest.class);
                   // system.debug('******'+appWrapperObj);
                   // system.debug('******'+appWrapperObj.lineItemDetailRequest);
                  //  system.debug('******'+appWrapperObj.lineItemDetailRequest.LineItemID);
                    if(appWrapperObj.lineItemDetailRequest.RequestType.equals(Core_CA_AppConstants.DATA_REQUEST_TYPE_GTES))
                      responseObj = (Core_CA_BaseApplicationWrapper)Core_CA_LineItemDetail.getLineItemDetailGTES(appWrapperObj);      
                    if(appWrapperObj.lineItemDetailRequest.RequestType.equals(Core_CA_AppConstants.DATA_REQUEST_TYPE_ARIBA))
                      responseObj = (Core_CA_BaseApplicationWrapper)Core_CA_LineItemDetail.getLineItemDetailAriba(appWrapperObj);        
                }
                 
                /*if(svcName.equals(Core_CA_AppConstants.SVC_VALIDATE_APPROVEREJECTACTION)){
                    //system.debug('Enter');
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_CA_ApproveRejectAction.validateApproveRejectAction(appWrapperObj.urlParameters);
                   // system.debug('Exit');
                }*/
                
                
                
                
                if(svcName.equals(Core_CA_AppConstants.SVC_POST_APPROVEREJECTACTION)){
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                   // system.debug('^^^^'+appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.myApprovalPostRequest= (Core_CA_WrapperUtility.MyApprovalPostRequest) JSON.deserialize(requestBodySerializedMap, Core_CA_WrapperUtility.MyApprovalPostRequest.class);              
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_CA_ApproveRejectAction.postApproveRejectAction(appWrapperObj);
                }
               
                if(svcName.equals(Core_CA_AppConstants.SVC_EMAIL_DOMAIN_GET)){
                    //appWrapperObj.retListFromServer = UtilityHelper.getEmailDomainList();
                    //responseObj = appWrapperObj;
                }
                if(svcName.equals(Core_CA_AppConstants.SVC_EMAIL_DOMAIN_UPDATE)){
                    //appWrapperObj.retListFromServer = UtilityHelper.processNewEmailDomainList(appWrapperObj.postListToServer);
                    //responseObj = appWrapperObj;
                }
            }            
            else{/* Case of invalid service requested */
                responseObj = handleInvalidSvcNameReq( responseObj );
            }

        }
        catch(Core_CA_BaseServiceException baseAppEx){
            Core_CA_BaseServiceException.resolveExceptions(baseAppEx.getMessage(),baseAppEx);
            responseObj = constructResponseBody( responseObj, baseAppEx );
        }
        catch(Exception ex){
            Core_CA_BaseServiceException.resolveExceptions('Exception occured: AccountServiceController : callAccountInsert method ',ex);
            responseObj = constructResponseBody( responseObj, ex );
        }
        return responseObj;

    }
    /* Uses out error codes/messages from exception object and updates the same to Core_CA_BaseApplicationWrapper which is sent as response for the service call */
    
    
    public static Core_CA_BaseApplicationWrapper constructResponseBody(Core_CA_BaseApplicationWrapper responseObj, Object exceptionObj ){
        if(Utility.isEmpty(responseObj)) responseObj = new Core_CA_ApplicationWrapper();
        if( exceptionObj instanceOf Core_CA_BaseServiceException || exceptionObj instanceOf Exception) {
            responseObj.message   = Core_CA_AppConstants.ERROR_MSG_UNEXPECTED_ERROR_OCCURED;
            responseObj.statusCode = Core_CA_AppConstants.RESPONSE_FAILURE_ERROR_CODE;
        }
        return (Core_CA_BaseApplicationWrapper)responseObj;
    }

    /* Updates error code and error message for invalid service name cases */
   
    public static Core_CA_BaseApplicationWrapper handleInvalidSvcNameReq(Core_CA_BaseApplicationWrapper responseObj){
        if(Utility.isEmpty(responseObj)) responseObj = new Core_CA_ApplicationWrapper();
        responseObj.statusCode   =   Core_CA_AppConstants.RESPONSE_FAILURE_ERROR_CODE;
        responseObj.message     =   Core_CA_AppConstants.SVC_RESP_MESSAGE_INVALID_SVCNAME;
        return (Core_CA_BaseApplicationWrapper)responseObj;
    }
    private static String createSerializedMapString(String serviceJSONObjectasString){
        String requestBodySerializedMap = '';
        try{
            if(!Utility.isEmpty(serviceJSONObjectasString)){
                Map<String, Object> mapOfJSONData = (Map<String, Object>) JSON.deserializeUntyped(serviceJSONObjectasString);
                for(String str : mapOfJSONData.KeySet())
                {
                    Object obj = mapOfJSONData.get(str);
                    requestBodySerializedMap = JSON.serialize(obj);
                    

                }                
            }
        }       
        catch(JSONException ex){
            throw new Core_CA_BaseServiceException(
            'Exception occured: Core_CA_BaseApplicationServices : createSerializedMapString method ', ex);
        }
        return requestBodySerializedMap;
    }


}