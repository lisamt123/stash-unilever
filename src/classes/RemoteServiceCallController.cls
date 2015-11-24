/*
  Class Name: RemoteServiceCallController
  Author : Mindtree
  Date: 1 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Controller Class used for RemoteTK Component
*/
global with sharing class RemoteServiceCallController {
    
    @remoteAction
    global static String invokeService(String serviceJSONObject,String serviceName,String requestType) {        
        Core_CA_BaseApplicationWrapper responseObj = null;
        try{
            responseObj = Core_CA_BaseApplicationServices.invokeService(constructRequestBody(serviceJSONObject, serviceName, requestType,''));
        }
        catch(Core_CA_BaseServiceException baseAppEx){if(Utility.isEmpty(responseObj)) responseObj = new Core_CA_ApplicationWrapper();
            responseObj.statusCode = 404;responseObj.message = baseAppEx.getMessage();
            Core_CA_BaseServiceException.resolveExceptions(baseAppEx.getMessage(),baseAppEx,serviceJSONObject);}
        return JSON.serialize(responseObj);
    }
   
    @remoteAction
    global static String invokeServiceWithURLParameter(String serviceJSONObject,String serviceName,String requestType,String urlParameter) {
        Core_CA_BaseApplicationWrapper responseObj = null; 
        try{
            responseObj =   Core_CA_BaseApplicationServices.invokeService(constructRequestBody(serviceJSONObject, serviceName, requestType,urlParameter));
        }
        catch(Core_CA_BaseServiceException baseAppEx){ if(Utility.isEmpty(responseObj)) responseObj = new Core_CA_ApplicationWrapper();
            responseObj.statusCode = 404;responseObj.message = baseAppEx.getMessage();
            Core_CA_BaseServiceException.resolveExceptions(baseAppEx.getMessage(),baseAppEx,serviceJSONObject);}
        return JSON.serialize(responseObj);
    } 
   /*  
    @remoteAction
    public static String invokeServiceWithURLParameter1(String serviceName,String requestType,String urlParameter) {
        Core_CA_BaseApplicationWrapper responseObj = null; 
        //system.debug('2');
        try{
            responseObj =   Core_CA_BaseApplicationServices.invokeService(constructRequestBody('',serviceName,requestType,urlParameter));
        }
        catch(Core_CA_BaseServiceException baseAppEx){
            if(Utility.isEmpty(responseObj)) responseObj = new Core_CA_ApplicationWrapper();
            responseObj.statusCode = 404;
            responseObj.message = baseAppEx.getMessage();
            Core_CA_BaseServiceException.resolveExceptions(baseAppEx.getMessage(),baseAppEx);
        }
        return JSON.serialize(responseObj);
    }
    */
    @TestVisible
    global static Core_CA_ApplicationWrapper constructRequestBody(String serviceJSONObject,String serviceName,String requestType,String urlParameter){
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();
        try{
            appWrapperObj.serviceJSONObjectasString = serviceJSONObject;
            appWrapperObj.serviceName = serviceName;
            appWrapperObj.requestType = requestType;
            appWrapperObj.urlParameters = urlParameter;
        }catch(Core_CA_BaseServiceException baseAppEx){ throw new Core_CA_BaseServiceException('Exception occured: RemoteServiceCallController : constructRequestBody method ',baseAppEx);}
        return appWrapperObj;
    }

}