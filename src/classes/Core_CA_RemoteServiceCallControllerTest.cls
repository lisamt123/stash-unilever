@isTest 
public class Core_CA_RemoteServiceCallControllerTest{
    
    @TestVisible static String strAriba= 'Ariba';
    @TestVisible static String strApp= 'APP';
    @TestVisible static String strPost= 'POST';
    @TestVisible static String strApproved='Approved';
    @TestVisible static String strApprover='Approver';
    @TestVisible static String strGtes= 'GTES';
    @TestVisible static String strGetExpenseDetailData='GetExpenseDetailData'; 
    @TestVisible static String strGetMyApprovalsData= 'GetMyApprovalsData';
    @TestVisible static String strStatus= 'Approver Added';
    @TestVisible static String strClosingTags= '}}';
    @TestVisible static String strClarity = 'Clarity';
    @TestVisible static String strInvoice = 'Invoice'; 
    

    public static String serviceJSONObject = '{"myApprovalsDataRequest":{"ExpenseStatus":"All","RecordsShownCount":0,"ExpenseTypeSelected":"All"}}';
    public static String serviceName = 'GetMyApprovalsData';
    public static String requestType = 'GET';
    public static String urlParameter;

    public static testmethod void invokeServiceTest(){
    
    Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name= 'Test Ariba1' ,Source_System__c=strAriba,Invalid_PR__c= true,Invalid_PR_Reason__c='invalid');
    insert headerObj;
    System.assert(headerObj!= null);
    Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
    insert approverObj;
    System.assert(approverObj!= null);
    
    String str = RemoteServiceCallController.invokeService(serviceJSONObject,serviceName,requestType);
    System.assertEquals('200',str.substring(14,17),'error');
     System.assertEquals('Purchase Request',str.substring(227,243),'error');
    
    //RemoteServiceCallController.invokeServiceWithURLParameter(serviceJSONObject,serviceName,requestType,urlparameter);
    //RemoteServiceCallController.constructRequestBody(serviceJSONObject,serviceName,requestType,urlparameter);
    
    }
}