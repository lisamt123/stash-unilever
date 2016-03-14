@isTest 
public class Core_CA_RemoteServiceCallControllerTest{
    public static String serviceJSONObject = '{"myApprovalsDataRequest":{"ExpenseStatus":"All","RecordsShownCount":0,"ExpenseTypeSelected":"All"}}';
    public static String serviceName = 'GetMyApprovalsData';
    public static String requestType = 'GET';
    public static String urlParameter;

    public static Testmethod void invokeServiceTest(){
    
    RemoteServiceCallController remServiceCall = new RemoteServiceCallController();
    Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();
    String str = RemoteServiceCallController.invokeService(serviceJSONObject,serviceName,requestType);
    System.assertEquals('200',str.substring(14,17),'error');
    //RemoteServiceCallController.invokeServiceWithURLParameter(serviceJSONObject,serviceName,requestType,urlparameter);
    //RemoteServiceCallController.constructRequestBody(serviceJSONObject,serviceName,requestType,urlparameter);
    
    }
}