@isTest 
public class Core_CA_RemoteServiceCallControllerTest{
    public static String serviceJSONObject;
    public static String serviceName;
    public static String requestType;
    public static String urlParameter;

    public static Testmethod void invokeServiceTestMethod(){
    
    RemoteServiceCallController remServiceCall = new RemoteServiceCallController();
    RemoteServiceCallController.invokeService(serviceJSONObject,serviceName,requestType);
    System.assert(RemoteServiceCallController.invokeService(serviceJSONObject,serviceName,requestType) != null);
    RemoteServiceCallController.invokeServiceWithURLParameter(serviceJSONObject,serviceName,requestType,urlparameter);
    System.assert(RemoteServiceCallController.invokeServiceWithURLParameter(serviceJSONObject,serviceName,requestType,urlparameter) != null);
    RemoteServiceCallController.constructRequestBody(serviceJSONObject,serviceName,requestType,urlparameter);
    System.assert(RemoteServiceCallController.constructRequestBody(serviceJSONObject,serviceName,requestType,urlparameter) != null);
    
    }
}