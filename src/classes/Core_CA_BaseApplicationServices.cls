/*
  Class Name: Core_CA_BaseApplicationServices
  Author : Mindtree
  Date: 1 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: This class is used to call respective service classes based on Key from request data
*/
@RestResource (urlMapping='/AppService/*')
global class Core_CA_BaseApplicationServices implements Core_CA_IBaseAppicationServices{
    
    /* -- SONAR Issue explanation -- 
       This class is called from Core_CA_RemoteServiceCallController which Accept the request JSON from the UI and the required apex
       method will be called and the Response JSON will be sent, to differentiate which method to be called according to the JSON value 
       there are multiple if and else condtion and it has code for MyApproval App and Ideation APP thats leading to the Npath complexity.
    */
    
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
               
                //Chatter Approval Services
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
                    if(appWrapperObj.lineItemDetailRequest.RequestType.equals(Core_CA_AppConstants.DATA_REQUEST_TYPE_INVOICE))
                      responseObj = (Core_CA_BaseApplicationWrapper)Core_CA_LineItemDetail.getLineItemDetailInvoice(appWrapperObj);
                }
                
                //Ideation Services
                /**** Get Ideation Landing Page data****/
                if(svcName.equals(Core_IC_AppConstants.SVC_GET_Landing_Page_Data)){              
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.ideaLandingPageRequest = (Core_IC_WrapperUtility.IdeaLandingPageRequest) JSON.deserialize(requestBodySerializedMap, Core_IC_WrapperUtility.IdeaLandingPageRequest.class);                    
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_IC_LandingPage.getLandingPageDetail(appWrapperObj);
                }  
                
                /**** Post Vote for Idea****/
                if(svcName.equals(Core_IC_AppConstants.SVC_POST_Vote_Ideas)){                  
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.voteForIdeasOfTheWeekRequest = (Core_IC_WrapperUtility.VoteForIdeasOfTheWeekRequest) JSON.deserialize(requestBodySerializedMap, Core_IC_WrapperUtility.VoteForIdeasOfTheWeekRequest.class);
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_IC_PostVoteForIdeas.postVoteForIdeas(appWrapperObj);
                } 
                
                /**** Get Idea Campaign detail data****/
                if(svcName.equals(Core_IC_AppConstants.SVC_GET_Campaign_Detail_Data)){                  
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.ideaCampaignDetailRequest = (Core_IC_WrapperUtility.IdeaCampaignDetailRequest) JSON.deserialize(requestBodySerializedMap, Core_IC_WrapperUtility.IdeaCampaignDetailRequest.class);
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_IC_CampaignDetail.getCampaignDetail(appWrapperObj);
                }
                
                /**** Get Idea detail data****/
                if(svcName.equals(Core_IC_AppConstants.SVC_GET_Idea_Detail_Data)){                  
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.ideaDetailRequest = (Core_IC_WrapperUtility.IdeaDetailRequest) JSON.deserialize(requestBodySerializedMap, Core_IC_WrapperUtility.IdeaDetailRequest.class);
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_IC_IdeaDetail.getIdeaDetail(appWrapperObj);
                }
                
                /**** Post Comment for Idea****/
                if(svcName.equals(Core_IC_AppConstants.SVC_POST_Comment_Ideas)){                  
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.ideaCommentRequest = (Core_IC_WrapperUtility.IdeaCommentRequest) JSON.deserialize(requestBodySerializedMap, Core_IC_WrapperUtility.IdeaCommentRequest.class);
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_IC_PostCommentForAnIdea.postCommentForIdeas(appWrapperObj);
                }
                
                /**** Post Submit an Idea****/
                if(svcName.equals(Core_IC_AppConstants.SVC_POST_Submit_Ideas)){                
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.submitIdeaRequest = (Core_IC_WrapperUtility.SubmitIdeaRequest) JSON.deserialize(requestBodySerializedMap, Core_IC_WrapperUtility.SubmitIdeaRequest.class);
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_IC_PostSubmitIdea.postSubmitAnIdea(appWrapperObj);
                }
                
                /**** Get Category Values****/
                /*if(svcName.equals(Core_IC_AppConstants.SVC_GET_Category_Values)){                  
                    //requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    //appWrapperObj.submitIdeaRequest = (Core_IC_WrapperUtility.SubmitIdeaRequest) JSON.deserialize(requestBodySerializedMap, Core_IC_WrapperUtility.SubmitIdeaRequest.class);
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_IC_GetCategoryValues.GetCategoryValues();
                }*/
                
                /**** Get Attachment Id****/
                /*if(svcName.equals(Core_IC_AppConstants.SVC_GET_Attachment_Id)){                
                    //requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    //appWrapperObj.submitIdeaRequest = (Core_IC_WrapperUtility.SubmitIdeaRequest) JSON.deserialize(requestBodySerializedMap, Core_IC_WrapperUtility.SubmitIdeaRequest.class);
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_IC_GetAttachmentId.GetAttachmentId();
                }*/
                
                /**** Get FAQ Values****/
                if(svcName.equals(Core_IC_AppConstants.SVC_GET_FAQ_Values)){                
                    //requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    //appWrapperObj.submitIdeaRequest = (Core_IC_WrapperUtility.SubmitIdeaRequest) JSON.deserialize(requestBodySerializedMap, Core_IC_WrapperUtility.SubmitIdeaRequest.class);
                    responseObj = (Core_CA_BaseApplicationWrapper)Core_IC_FAQData.GetFAQValues();
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
               
                /*if(svcName.equals(Core_CA_AppConstants.SVC_EMAIL_DOMAIN_GET)){
                    //appWrapperObj.retListFromServer = UtilityHelper.getEmailDomainList();
                    //responseObj = appWrapperObj;
                }
                if(svcName.equals(Core_CA_AppConstants.SVC_EMAIL_DOMAIN_UPDATE)){
                    //appWrapperObj.retListFromServer = UtilityHelper.processNewEmailDomainList(appWrapperObj.postListToServer);
                    //responseObj = appWrapperObj;

                }*/
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
        Core_CA_BaseApplicationWrapper responseObjj = responseObj;
        if(Utility.isEmpty(responseObjj)) responseObjj = new Core_CA_ApplicationWrapper();
        if( exceptionObj instanceOf Core_CA_BaseServiceException || exceptionObj instanceOf Exception) {
            responseObjj.message   = Core_CA_AppConstants.ERROR_MSG_UNEXPECTED_ERROR_OCCURED;
            responseObjj.statusCode = Core_CA_AppConstants.RESPONSE_FAILURE_ERROR_CODE;
        }
        return (Core_CA_BaseApplicationWrapper)responseObjj;
    }

    /* Updates error code and error message for invalid service name cases */
   
    public static Core_CA_BaseApplicationWrapper handleInvalidSvcNameReq(Core_CA_BaseApplicationWrapper responseObj){
        Core_CA_BaseApplicationWrapper responseObje = responseObj;
        if(Utility.isEmpty(responseObje)) responseObje = new Core_CA_ApplicationWrapper();
        responseObje.statusCode   =   Core_CA_AppConstants.RESPONSE_FAILURE_ERROR_CODE;
        responseObje.message     =   Core_CA_AppConstants.SVC_RESP_MESSAGE_INVALID_SVCNAME;
        return (Core_CA_BaseApplicationWrapper)responseObje;
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