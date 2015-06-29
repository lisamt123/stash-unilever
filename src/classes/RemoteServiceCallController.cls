global with sharing class RemoteServiceCallController {
    
    @remoteAction
    public static String invokeService(String serviceJSONObject,String serviceName,String requestType) {        
        Core_CA_BaseApplicationWrapper responseObj = null;  
       // system.debug('@@@@@1');
        try{
            //system.debug('@@@@@1entered');
            responseObj = Core_CA_BaseApplicationServices.invokeService(constructRequestBody(serviceJSONObject, serviceName, requestType,''));
        }
        catch(Core_CA_BaseServiceException baseAppEx){if(Utility.isEmpty(responseObj)) responseObj = new Core_CA_ApplicationWrapper();
            responseObj.statusCode = 404;responseObj.message = baseAppEx.getMessage();
            Core_CA_BaseServiceException.resolveExceptions(baseAppEx.getMessage(),baseAppEx,serviceJSONObject);}
        return JSON.serialize(responseObj);
    }
   
    @remoteAction
    public static String invokeServiceWithURLParameter(String serviceJSONObject,String serviceName,String requestType,String urlParameter) {
        Core_CA_BaseApplicationWrapper responseObj = null; 
        //system.debug('2');
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
    private static Core_CA_ApplicationWrapper constructRequestBody(String serviceJSONObject,String serviceName,String requestType,String urlParameter){
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();
       // system.debug('@@@@@3');
        try{
            appWrapperObj.serviceJSONObjectasString = serviceJSONObject;
            appWrapperObj.serviceName = serviceName;
            appWrapperObj.requestType = requestType;
            appWrapperObj.urlParameters = urlParameter;
        }catch(Core_CA_BaseServiceException baseAppEx){ throw new Core_CA_BaseServiceException('Exception occured: RemoteServiceCallController : constructRequestBody method ',baseAppEx);}
       // system.debug('@@@@@3'+appWrapperObj);
        return appWrapperObj;
    }

}