/*
  Class Name: Core_CA_Test_MobileAPP
  Author : Mindtree
  Date: 10 May 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Test class to cover The following classes
                            1.Core_CA_AppConstants
                            2.Core_CA_ApplicationWrapper
                            3.Core_CA_BaseApplicationWrapper
                            4.Core_CA_WrapperUtility
                            5.Core_CA_BaseApplicationServices
                            6.Core_CA_BaseApplicationServicesTest
                            7.Core_CA_BaseServiceException
                            8.Core_CA_BaseServiceExceptionTest
                            9.Core_CA_ApproveRejectAction
                            10.Core_CA_MyApprovalData
                            11.Core_CA_RequestDetail
                            12.Core_CA_LineItemDetail
                            13.Core_CA_RemoteServiceCallControllerTest
                            14.Core_CA_IBaseAppicationServices
                            15.RemoteServiceCallController
                            16.Core_CA_Test_MobileAPP
                            17.Utility                          
*/

@isTest (Seealldata=true)
public class Core_CA_Test_MobileAPP{
public static testMethod void TestMyApprovalData(){
    Test.starttest();
    //Test data for Ariba
    Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
    insert headerObj;
    System.assert(headerObj!= null);
    Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
    insert approverObj;
    System.assert(approverObj!= null);
 
    //Test data for GTES
    Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'GTES', Status__c= 'Approver Added',Manager__c = Userinfo.getuserId() ,
                                           Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(), Reminder_Alert_Days__c=0,Fully_Approved__c=false);
    insert objHeader;
    System.assert(objHeader != null);
    Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = 'GTES',Approval_Header__c =  objHeader.Id,
                                           Role__c = 'APP');
    insert objApprover;
    System.assert(objApprover != null);
    
    //Calling service classes   
    RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"All","RecordsShownCount": 0,"ExpenseTypeSelected": "All"}}','GetMyApprovalsData','POST');
    RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Pending","RecordsShownCount": 0,"ExpenseTypeSelected": "Expense"}}','GetMyApprovalsData','POST');
    RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Pending","RecordsShownCount": 0,"ExpenseTypeSelected": "Expense"}}','GetMyApprovalsData','POST');
    RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Closed","RecordsShownCount": 0,"ExpenseTypeSelected": "PurchaseRequest"}}','GetMyApprovalsData','POST');
    RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Closed","RecordsShownCount": 0,"ExpenseTypeSelected": "PurchaseRequest"}}','GetMyApprovalsData','POST');
    RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Pending","RecordsShownCount": 0,"ExpenseTypeSelected": "All"}}','GetMyApprovalsData','POST');
    RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Closed","RecordsShownCount": 0,"ExpenseTypeSelected": "All"}}','GetMyApprovalsData','POST');
    RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Pending","RecordsShownCount": 0,"ExpenseTypeSelected": "PurchaseRequest"}}','GetMyApprovalsData','POST');
    RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Closed","RecordsShownCount": 0,"ExpenseTypeSelected": "Expense"}}','GetMyApprovalsData','POST');
    Test.stoptest();
}

public static testMethod void TestRequestDetail(){
    Test.starttest();
    Core_CA_WrapperUtility wrapper=new Core_CA_WrapperUtility();    
    //Test data for Ariba
    Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
    insert headerObj;
    System.assert(headerObj!= null);
    Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Approved',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
    insert approverObj;
    System.assert(approverObj!= null);
    Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=headerObj.Id,Source_System__c = 'Ariba');
    insert lineObj;
    System.assert(lineObj!= null);
       
    //Test data for GTES
    Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'GTES', Status__c= 'Approver Added',Manager__c = Userinfo.getuserId() ,
                                           Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(), Reminder_Alert_Days__c=0,Fully_Approved__c=false);
    insert objHeader;
    System.assert(objHeader != null);
    Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = 'GTES',Approval_Header__c =  objHeader.Id,
                                           Role__c = 'APP');
    insert objApprover;
    System.assert(objApprover != null);
    Core_Approval_Details__c lineObj1=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=objHeader.Id,Source_System__c = 'GTES');
    insert lineObj1;
    System.assert(lineObj1!= null);
     
    //Calling service classes     
    RemoteServiceCallController.invokeService('{"expenseDetailRequest": {"RequestId":'+'"'+ objHeader.ID +'","ApproverId":'+'"'+ objApprover.ID+'"}}','GetExpenseDetailData','POST');
    RemoteServiceCallController.invokeService('{"expenseDetailRequest": {"RequestId":'+'"'+ headerObj.ID +'","ApproverId":'+'"'+ approverObj.ID+'"}}','GetExpenseDetailData','POST');
    //Exception Condtions 
    RemoteServiceCallController.invokeService('{"expenseDetailRequest": {"RequestId":"","ApproverId": '+'"'+ approverObj.ID+'"}}','GetExpenseDetailData','POST');
    RemoteServiceCallController.invokeService('{"expenseDetailRequest": {"RequestId":"","ApproverId":""}}','GetExpenseDetailData','POST');
    Test.stoptest();
}

public static testMethod void TestLineItemDetail(){
    Test.starttest();
    Core_CA_WrapperUtility wrapper=new Core_CA_WrapperUtility();
    
    //Test data for Ariba
    Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
    insert headerObj;
    System.assert(headerObj!= null);
    Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Approved',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
    insert approverObj;
    System.assert(approverObj!= null);
    Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=headerObj.Id,Source_System__c = 'Ariba',Quantity__c = 44,Expense_Date__c= system.now(),Reimbursable__c= true,Receipt__c=true);
    insert lineObj;
    System.assert(lineObj!= null);
    
    //Test data for GTES
    Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'GTES', Status__c= 'Approver Added',Manager__c = Userinfo.getuserId() ,
                                           Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(), Reminder_Alert_Days__c=0,Fully_Approved__c=false);
    insert objHeader;
    System.assert(objHeader != null);
    Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = 'GTES',Approval_Header__c =  objHeader.Id,
                                           Role__c = 'APP');
    insert objApprover;
    System.assert(objApprover != null);
    Core_Approval_Details__c lineObj1=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=objHeader.Id,Source_System__c = 'GTES');
    insert lineObj1;
    System.assert(lineObj1!= null);
    
    //Calling service classes 
    RemoteServiceCallController.invokeService('{"LineItemDetailRequest": {"RequestType":"Purchase Request","LineItemID":'+'"'+lineObj.Id+'"}}','GetLineItemDetailData','POST');
    RemoteServiceCallController.invokeService('{"LineItemDetailRequest": {"RequestType":"Expense","LineItemID": '+'"'+ lineObj1.Id+'"}}','GetLineItemDetailData','POST');
    RemoteServiceCallController.invokeService('{"LineItemDetailRequest": {"RequestType":"Expense","LineItemID": ""}}','GetLineItemDetailData','POST');
    Test.stoptest();
}


public static testMethod void TestApproveRejectAction(){
    Test.starttest();
    //Test data for Ariba
    Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
    insert headerObj;
    System.assert(headerObj!= null);
    Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Approved',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
    insert approverObj;
    System.assert(approverObj!= null);
    Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=headerObj.Id,Source_System__c = 'Ariba');
    insert lineObj;
    System.assert(lineObj!= null);
    
     //Test data for GTES
    Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'GTES', Status__c= 'Approver Added',Manager__c = Userinfo.getuserId() ,
                                           Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(), Reminder_Alert_Days__c=0,Fully_Approved__c=false);
    insert objHeader;
    System.assert(objHeader != null);
    Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = 'GTES',Approval_Header__c =  objHeader.Id,
                                           Role__c = 'APP');
    insert objApprover;
    System.assert(objApprover != null);
    Core_Approval_Details__c lineObj1=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=objHeader.Id,Source_System__c = 'GTES');
    insert lineObj1;
    System.assert(lineObj1!= null);
    
    //Calling service classes 
    RemoteServiceCallController.invokeService('{"myApprovalPostRequest":{"UpdateFunctionType": "Approve","CommentDesc": "Hi......","CommentVisibleToUser": true,"ApproverId":'+'"'+approverObj.Id+'"}}','PostApproveRejectAction','POST');
    RemoteServiceCallController.invokeService('{"myApprovalPostRequest":{"UpdateFunctionType": "Reject","CommentDesc": "Hi......","CommentVisibleToUser": true,"ApproverId": '+'"'+objApprover.Id+'"}}','PostApproveRejectAction','POST');
    RemoteServiceCallController.invokeService('{"myApprovalPostRequest":{"UpdateFunctionType": "Reject","CommentDesc": "Hi......","CommentVisibleToUser": true,"ApproverId": ""}}','PostApproveRejectAction','POST');
    
    Utility.isEmpty(lineObj1);
    Utility.isEmpty('');
    Test.stoptest();
}

public static testMethod void TestRemoteCallWithParameter(){
    Test.starttest();
    //Test data for Ariba
    Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
    insert headerObj;
    System.assert(headerObj!= null);
    Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Approved',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
    insert approverObj;
    System.assert(approverObj!= null);
    Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=headerObj.Id,Source_System__c = 'Ariba');
    insert lineObj;
    System.assert(lineObj!= null);
    
    //Test data for GTES
    Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'GTES', Status__c= 'Approver Added',Manager__c = Userinfo.getuserId() ,
                                           Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(), Reminder_Alert_Days__c=0,Fully_Approved__c=false);
    insert objHeader;
    System.assert(objHeader != null);
    Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = 'GTES',Approval_Header__c =  objHeader.Id,
                                           Role__c = 'APP');
    insert objApprover;
    System.assert(objApprover != null);
    Core_Approval_Details__c lineObj1=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=objHeader.Id,Source_System__c = 'GTES');
    insert lineObj1;
    System.assert(lineObj1!= null);
    
     //Calling service classes
    RemoteServiceCallController.invokeServiceWithURLParameter('{"expenseDetailRequest": {"RequestId":"a0Jc0000007TOEiEAO","ApproverId": "a0Kc000000FTMY4"}}','PostApproveRejectAction','POST','a0Kc000000FTJT3EAP');
    Test.stoptest();
}

public static testMethod void TestBaseServiceException(){
    Test.starttest();
    Core_CA_BaseServiceException.resolveExceptions('test1',new Core_CA_BaseServiceException('Exception occured: CoreCA_REST_GetHeaderDetails : getRequestDetail method'));
    Core_CA_BaseServiceException.resolveExceptions(new Core_CA_BaseServiceException('Exception occured: CoreCA_REST_GetHeaderDetails : getRequestDetail method '));
    Core_CA_BaseServiceException.resolveExceptions('Test2',new Core_CA_BaseServiceException('Exception occured: CoreCA_REST_GetHeaderDetails : getRequestDetail method'),'Test3');
    Test.stoptest();            
}
}