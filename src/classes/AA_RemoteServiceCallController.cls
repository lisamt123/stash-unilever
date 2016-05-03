global with sharing class AA_RemoteServiceCallController {
	
	@remoteAction
    public static String invokeService(String serviceJSONObject,String serviceName,String requestType) {        
        AA_BaseApplicationWrapperObj responseObj = null;   
        
        try{ 
            system.debug('in remote service call controller'+serviceName);
            responseObj = AA_BaseApplicationServices.invokeService(constructRequestBody(serviceJSONObject, serviceName, requestType,''));
            
        }catch(Exception e){  
        	//BaseServiceException baseAppEx;
        }
        system.debug('Serialize Response will be ->'+JSON.serialize(responseObj));
        return JSON.serialize(responseObj);
    }
    @remoteAction
    public static String invokeServiceWithURLParameter(String serviceJSONObject,String serviceName,String requestType,String urlParameter) {
        AA_BaseApplicationWrapperObj responseObj = null; 
        try{
            responseObj =   AA_BaseApplicationServices.invokeService(constructRequestBody(serviceJSONObject, serviceName, requestType,urlParameter));
        }
        catch(Exception e){ //BaseServiceException baseAppEx){
        }
        return JSON.serialize(responseObj);
    }
    @TestVisible
    private static AA_ApplicationWrapperObj constructRequestBody(String serviceJSONObject,String serviceName,String requestType,String urlParameter){
        AA_ApplicationWrapperObj appWrapperObj = new AA_ApplicationWrapperObj();
        try{
            appWrapperObj.serviceJSONObjectasString = serviceJSONObject;
            appWrapperObj.serviceName = serviceName;
            appWrapperObj.requestType = requestType;
            appWrapperObj.urlParameters = urlParameter;
        }catch(Exception e){ //(BaseServiceException baseAppEx){ 
            //throw new BaseServiceException('Exception occured: RemoteServiceCallController : constructRequestBody method ',baseAppEx);
        }
        
        return appWrapperObj;
    }

}