<<<<<<< HEAD
global with sharing class RemoteServiceCallController {
    
    @remoteAction
    public static String invokeService(String serviceJSONObject,String serviceName,String requestType) {        
        Core_CA_BaseApplicationWrapper responseObj = null;  
       // system.debug('@@@@@1');
        try{
            //system.debug('@@@@@1entered');
=======
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
>>>>>>> FETCH_HEAD
            responseObj = Core_CA_BaseApplicationServices.invokeService(constructRequestBody(serviceJSONObject, serviceName, requestType,''));
        }
        catch(Core_CA_BaseServiceException baseAppEx){if(Utility.isEmpty(responseObj)) responseObj = new Core_CA_ApplicationWrapper();
            responseObj.statusCode = 404;responseObj.message = baseAppEx.getMessage();
            Core_CA_BaseServiceException.resolveExceptions(baseAppEx.getMessage(),baseAppEx,serviceJSONObject);}
        return JSON.serialize(responseObj);
    }
   
    @remoteAction
<<<<<<< HEAD
    public static String invokeServiceWithURLParameter(String serviceJSONObject,String serviceName,String requestType,String urlParameter) {
        Core_CA_BaseApplicationWrapper responseObj = null; 
        //system.debug('2');
=======
    global static String invokeServiceWithURLParameter(String serviceJSONObject,String serviceName,String requestType,String urlParameter) {
        Core_CA_BaseApplicationWrapper responseObj = null; 
>>>>>>> FETCH_HEAD
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
<<<<<<< HEAD
    private static Core_CA_ApplicationWrapper constructRequestBody(String serviceJSONObject,String serviceName,String requestType,String urlParameter){
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();
       // system.debug('@@@@@3');
=======
    global static Core_CA_ApplicationWrapper constructRequestBody(String serviceJSONObject,String serviceName,String requestType,String urlParameter){
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();
>>>>>>> FETCH_HEAD
        try{
            appWrapperObj.serviceJSONObjectasString = serviceJSONObject;
            appWrapperObj.serviceName = serviceName;
            appWrapperObj.requestType = requestType;
            appWrapperObj.urlParameters = urlParameter;
        }catch(Core_CA_BaseServiceException baseAppEx){ throw new Core_CA_BaseServiceException('Exception occured: RemoteServiceCallController : constructRequestBody method ',baseAppEx);}
<<<<<<< HEAD
       // system.debug('@@@@@3'+appWrapperObj);
=======
>>>>>>> FETCH_HEAD
        return appWrapperObj;
    }

}