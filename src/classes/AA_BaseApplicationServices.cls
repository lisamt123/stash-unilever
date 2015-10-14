@RestResource (urlMapping='/AgentAppService/*')
global class AA_BaseApplicationServices implements AA_IBaseAppicationServices {

@HttpPost
    webservice static AA_BaseApplicationWrapperObj invokeService(AA_ApplicationWrapperObj appWrapperObj){

        /* Get Context objects in order to read parameters like url, cookies */
        AA_BaseApplicationWrapperObj responseObj = null;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String requestBodySerializedMap = '';
        String svcName = null;
        if(null!=req){
            svcName = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1); /* Read service name from URL in order to invoke specific service method */
        }
        else{
            svcName = appWrapperObj.serviceName;
        }
        System.debug(LoggingLevel.INFO, 'Within invokeService method with svcName ['+svcName+']' );
        try{
            if(!Utility.isEmpty(svcName)){
                
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_UNILEVER_CREATE)){
                    
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                    system.debug(LoggingLevel.INFO,'**??** inside AA_BaseApplicationServices'+appWrapperObj.objAgentAppDataRequest);
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.insertAgentApp(appWrapperObj);
                    
                }
                   
               if(svcName.equals(AA_Constants.SVC_AGENT_APP_GET_ALL_REPORTS)){
                    system.debug('1 : SVC_AGENT_APP_GET_ALL_REPORTS   ');
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                    system.debug('2 : SVC_AGENT_APP_GET_ALL_REPORTS   '+appWrapperObj);
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                        system.debug('3 : SVC_AGENT_APP_GET_ALL_REPORTS  : '+requestBodySerializedMap + ':: String.isBlank(requestBodySerializedMap'+String.isBlank(requestBodySerializedMap));
                   if(!String.isBlank(requestBodySerializedMap)){ 
                       system.debug('33 in if');
                       appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                        system.debug(LoggingLevel.INFO,'**??** inside AA_BaseApplicationServices + AA_Constants.SVC_AGENT_APP_UNILEVER_CREATE '+appWrapperObj.objAgentAppDataRequest);
                   	}
                   system.debug('4 : SVC_AGENT_APP_GET_ALL_REPORTS   ');
                   //responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.getAllAgentReports(appWrapperObj);
                   responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.retriveAllAgentReports(appWrapperObj);
                   system.debug(LoggingLevel.INFO,'**??** Response '+responseObj);
                }    
                
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_MOST_LIKE_REPORTS)){
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    if(!String.isBlank(requestBodySerializedMap)){ 
                    	appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                        system.debug(LoggingLevel.INFO,'**??** inside AA_BaseApplicationServices + AA_Constants.SVC_AGENT_APP_UNILEVER_CREATE '+appWrapperObj.objAgentAppDataRequest);
                   	}
                   responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.retrieveAgentReportsOnMostliked(appWrapperObj);
                   system.debug(LoggingLevel.INFO,'**??** Response '+responseObj);
                }    
                
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_GET_AUTO_POPULATED_VALUES)){
                    system.debug('in base app'+svcName);
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();          
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.getAutoPopulatedValues_UnileverReport(appWrapperObj);   
                }
                
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_GET_COMPETITOR_NAME_AND_CATEGORY)){
                    system.debug('in base app'+svcName);
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController(); 
                    
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                    system.debug(LoggingLevel.INFO,'**??** inside AA_BaseApplicationServices'+appWrapperObj.objAgentAppDataRequest);   
                          
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.getCompetitorNameAndCategory_CompetitorReport(appWrapperObj);   
                }
                
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_GET_COMPETITOR_SOURCE_RETAILER_TOPIC_COUNTRY)){
                    system.debug('in base app'+svcName);
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();          
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.getSourceRetailerTopicCountry_CompetitorReport(appWrapperObj);   
                }
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_COMPETITOR_CREATE)){
                    
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                    system.debug(LoggingLevel.INFO,'**??** inside AA_BaseApplicationServices'+appWrapperObj.objAgentAppDataRequest);
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.insertAgentApp_Competitor(appWrapperObj);
                    
                }
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_TERMS_AND_CONDITION)){
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.isAcceptedTermsAndCondition(appWrapperObj);
                }
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_UPDATE_TERMS_AND_CONDITION)){
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                    //requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    //appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                    //system.debug(LoggingLevel.INFO,'**??** inside AA_BaseApplicationServices'+appWrapperObj.objAgentAppDataRequest);
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.updateIsAcceptedTermsAndCondition(appWrapperObj);
                }
                
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_LIKE_UPDATE)){
                	 AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                	 requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                     appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                	 system.debug('in updateLikeCount'+appWrapperObj);
                     responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.updateLikeCount(appWrapperObj);
                }
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_UNLIKE_UPDATE)){
                	
                	 AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                     requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                     appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                     system.debug('in updateLikeCount'+appWrapperObj);
                     responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.updateUnlikeCount(appWrapperObj);
                }
            }
            else{/* Case of invalid service requested */
                responseObj = handleInvalidSvcNameReq( responseObj );
            }

        }catch(Exception e){
            
        }
        /*catch(BaseServiceException baseAppEx){
            BaseServiceException.resolveExceptions(baseAppEx.getMessage(),baseAppEx);
            responseObj = constructResponseBody( responseObj, baseAppEx );
        }
        catch(Exception ex){
            BaseServiceException.resolveExceptions('Exception occured: AccountServiceController : callAccountInsert method ',ex);
            responseObj = constructResponseBody( responseObj, ex );
        }*/
        return responseObj;

    }
    /* Uses out error codes/messages from exception object and updates the same to BaseApplicationWrapperObj which is sent as response for the service call */
    private static AA_BaseApplicationWrapperObj constructResponseBody(AA_BaseApplicationWrapperObj responseObj, Object exceptionObj ){
        if(Utility.isEmpty(responseObj)) responseObj = new AA_ApplicationWrapperObj();
        /*if( exceptionObj instanceOf BaseServiceException || exceptionObj instanceOf Exception) {
            responseObj.message   = AppConstants.ERROR_MSG_UNEXPECTED_ERROR_OCCURED;
            responseObj.errorCode = AppConstants.RESPONSE_FAILURE_ERROR_CODE;

        }*/
        return (AA_BaseApplicationWrapperObj)responseObj;
    }

    /* Updates error code and error message for invalid service name cases */
    private static AA_BaseApplicationWrapperObj handleInvalidSvcNameReq(AA_BaseApplicationWrapperObj responseObj){
        /*if(Utility.isEmpty(responseObj)) responseObj = new ApplicationWrapperObj();
        responseObj.errorCode   =   AppConstants.RESPONSE_FAILURE_ERROR_CODE;
        responseObj.message     =   AppConstants.SVC_RESP_MESSAGE_INVALID_SVCNAME;
        */
        return (AA_BaseApplicationWrapperObj)responseObj;
    }
    
    public static String createSerializedMapString(String serviceJSONObjectasString){
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
            //throw new BaseServiceException('Exception occured: BaseApplicationServices : createSerializedMapString method ', ex);
        }
        
        return requestBodySerializedMap;
    }


}