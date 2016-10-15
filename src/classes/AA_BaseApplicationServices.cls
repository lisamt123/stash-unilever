@RestResource (urlMapping='/AgentAppService/*')
global class AA_BaseApplicationServices implements AA_IBaseAppicationServices {

@HttpPost
    webservice static AA_BaseApplicationWrapperObj invokeService(AA_ApplicationWrapperObj appWrapperObj){
    	
    	/* Get Context objects in order to read parameters like url, cookies */
        AA_BaseApplicationWrapperObj responseObj = null;
        RestRequest req = RestContext.request;
        //RestResponse res = RestContext.response;
        String requestBodySerializedMap = '';
        String svcName = null;
        if(null!=req){
            svcName = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1); /* Read service name from URL in order to invoke specific service method */
        }
        else{
            svcName = appWrapperObj.serviceName;
        }
        
        try{
            if(!Utility.isEmpty(svcName)){
                
                // Handle service request to create unilever report                 
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_UNILEVER_CREATE)){
                    
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                     responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.insertAgentApp(appWrapperObj);
                    
                }
                
                //Handles service request to fetch all reports to show on landing page                   
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_GET_ALL_REPORTS)){
                     system.debug('in service name '+AA_Constants.SVC_AGENT_APP_GET_ALL_REPORTS);
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                   if(!String.isBlank(requestBodySerializedMap)){ 
                
                       appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                
                    }
                               
                   responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.retriveAllAgentReports(appWrapperObj);
                  system.debug('response from controller'+responseObj);
                }  
                
                //Handles service request to fetch most like reports                 
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_MOST_LIKE_REPORTS)){
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    if(!String.isBlank(requestBodySerializedMap)){ 
                        appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                
                    }
                   responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.retrieveAgentReportsOnMostliked(appWrapperObj);
                
                }    
                
                 //Handles service request to get auto populate values like category ,company name compititor brand 
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_GET_AUTO_POPULATED_VALUES)){
                     AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();          
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.getAutoPopulatedValues_UnileverReport(appWrapperObj);   
                }
                
                 //Handles service request to auto populate the category & company name based on compititor brand  
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_GET_COMPETITOR_NAME_AND_CATEGORY)){
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController(); 
                    
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.getCompetitorNameAndCategory_CompetitorReport(appWrapperObj);   
                }
                
                //Handles service request to get values for source retailer topic & country 
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_GET_COMPETITOR_SOURCE_RETAILER_TOPIC_COUNTRY)){
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();          
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.getSourceRetailerTopicCountry_CompetitorReport(appWrapperObj);   
                }
                
                //Handles service request to create competitor report 
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_COMPETITOR_CREATE)){
                    
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                    requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                    appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.insertAgentApp_Competitor(appWrapperObj);
                    
                }
                //Handles service request to check whether user has accepted terms & conditions
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_TERMS_AND_CONDITION)){
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.isAcceptedTermsAndCondition(appWrapperObj);
                }
                
                //Handles service request to update the terms & conditions
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_UPDATE_TERMS_AND_CONDITION)){
                    AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                    responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.updateIsAcceptedTermsAndCondition(appWrapperObj);
                }
                
                //Handles service request to update the like count
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_LIKE_UPDATE)){
                     AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                     requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                     appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                     responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.updateLikeCount(appWrapperObj);
                }
                
                //Handales service request to unlike the report count
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_UNLIKE_UPDATE)){
                    
                     AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                     requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                     appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                     responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.updateUnlikeCount(appWrapperObj);
                }
                
                
                //Get userlist for typeahead
                
                if(svcName.equals(AA_Constants.SVC_AGENT_APP_AUTOCOMPLETELIST)){
                    
                     AA_AgentAppServiceController objAgentAppController = new AA_AgentAppServiceController();
                     requestBodySerializedMap = createSerializedMapString(appWrapperObj.serviceJSONObjectasString);
                     appWrapperObj.objAgentAppDataRequest = (AA_WrapperUtility.AgentAppDataRequest) JSON.deserialize(requestBodySerializedMap, AA_WrapperUtility.AgentAppDataRequest.class);
                     responseObj = (AA_BaseApplicationWrapperObj)objAgentAppController.getUserList(appWrapperObj);
                }
                         
            }
            else{
                /* Case of invalid service requested */
                responseObj = handleInvalidSvcNameReq( responseObj );
            }

        }catch(Exception e){
             System.debug('Exception:' + e);
        }
       
        return responseObj;

    }
   
    /* Updates error code and error message for invalid service name cases */
    private static AA_BaseApplicationWrapperObj handleInvalidSvcNameReq(AA_BaseApplicationWrapperObj responseObj){
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
             System.debug('Exception:' + ex);
        }
        
        return requestBodySerializedMap;
    }


}