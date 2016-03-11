@istest 
public class Core_CA_RemoteServiceCallControllerTest{
    public static String serviceJSONObject;
    public static String serviceName;
    public static String requestType;
    public static String urlParameter;

    public static Testmethod void MyTest(){
    
    RemoteServiceCallController remServiceCall = new RemoteServiceCallController();
    RemoteServiceCallController.invokeService(serviceJSONObject,serviceName,requestType);
    RemoteServiceCallController.invokeServiceWithURLParameter(serviceJSONObject,serviceName,requestType,urlparameter);
    RemoteServiceCallController.constructRequestBody(serviceJSONObject,serviceName,requestType,urlparameter);
    System.assert(RemoteServiceCallController.invokeService(serviceJSONObject,serviceName,requestType) != null);
    System.assert(RemoteServiceCallController.invokeServiceWithURLParameter(serviceJSONObject,serviceName,requestType,urlparameter) != null);
    System.assert(RemoteServiceCallController.constructRequestBody(serviceJSONObject,serviceName,requestType,urlparameter) != null);
    }
}