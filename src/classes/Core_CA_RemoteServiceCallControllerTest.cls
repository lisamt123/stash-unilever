@istest (SeeAllData = true)
public class Core_CA_RemoteServiceCallControllerTest{
    public static String serviceJSONObject;
    public static String serviceName;
    public static String requestType;
    public static String urlParameter;

<<<<<<< HEAD
    public static Testmethod void MyTest(){
    
    RemoteServiceCallController remServiceCall = new RemoteServiceCallController();
    System.assert(remServiceCall != null);
    RemoteServiceCallController.invokeService(serviceJSONObject,serviceName,requestType);
    RemoteServiceCallController.invokeServiceWithURLParameter(serviceJSONObject,serviceName,requestType,urlparameter);
    RemoteServiceCallController.constructRequestBody(serviceJSONObject,serviceName,requestType,urlparameter);
=======
    public static Testmethod void invokeServiceTestMethod(){
    
    RemoteServiceCallController remServiceCall = new RemoteServiceCallController();
    RemoteServiceCallController.invokeService(serviceJSONObject,serviceName,requestType);
    System.assert(RemoteServiceCallController.invokeService(serviceJSONObject,serviceName,requestType) != null);
    RemoteServiceCallController.invokeServiceWithURLParameter(serviceJSONObject,serviceName,requestType,urlparameter);
    System.assert(RemoteServiceCallController.invokeServiceWithURLParameter(serviceJSONObject,serviceName,requestType,urlparameter) != null);
    RemoteServiceCallController.constructRequestBody(serviceJSONObject,serviceName,requestType,urlparameter);
    System.assert(RemoteServiceCallController.constructRequestBody(serviceJSONObject,serviceName,requestType,urlparameter) != null);
>>>>>>> e7762774510a0def457f22eaa4caec8bb9c29733
    
    }
}