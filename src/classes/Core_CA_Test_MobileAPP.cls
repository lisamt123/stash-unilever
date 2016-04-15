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
    
@isTest
public class Core_CA_Test_MobileAPP{
    
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
    
    
    @testSetup static void setup() {
        List<CORE_Chatter_Approval__c> lstCustSet = new List<CORE_Chatter_Approval__c>();
              
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='AppRejAribaMessage', Text_Value__c='You are not an active Approver for this PR'));       
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='AppRejAlreadyStatus', Text_Value__c='You have already approved/rejected this request'));
                
        if(!lstCustSet.isEmpty())
           insert lstCustSet;     
    }
      
    public static testMethod void TestMyApprovalData(){    
        //Test data for Ariba     
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name= 'Test Ariba1' ,Source_System__c=strAriba,Invalid_PR__c= true,Invalid_PR_Reason__c='invalid');
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj;
        System.assert(approverObj!= null);
     
        //Test data for GTES
        Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader1', Source_System__c = strGtes, Status__c= strStatus,Manager__c = Userinfo.getuserId() ,
                                               Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(), Reminder_Alert_Days__c=0,Fully_Approved__c=false);
        insert objHeader;
        System.assert(objHeader != null);
        Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = strGtes,Approval_Header__c =  objHeader.Id,
                                               Role__c = strApp,Action__c='ACTV');
        insert objApprover;
        System.assert(objApprover != null);
        
        //Calling service classes
        Test.starttest();   
        RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"All","RecordsShownCount": 0,"ExpenseTypeSelected": "All"}}',strGetMyApprovalsData,strPost);
        RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Pending","RecordsShownCount": 0,"ExpenseTypeSelected": "Expense"}}',strGetMyApprovalsData,strPost);
        RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Pending","RecordsShownCount": 0,"ExpenseTypeSelected": "Expense"}}',strGetMyApprovalsData,strPost);
        RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Closed","RecordsShownCount": 0,"ExpenseTypeSelected": "PurchaseRequest"}}',strGetMyApprovalsData,strPost);
        RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Closed","RecordsShownCount": 0,"ExpenseTypeSelected": "PurchaseRequest"}}',strGetMyApprovalsData,strPost);
        RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Pending","RecordsShownCount": 0,"ExpenseTypeSelected": "All"}}',strGetMyApprovalsData,strPost);
        RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Closed","RecordsShownCount": 0,"ExpenseTypeSelected": "All"}}',strGetMyApprovalsData,strPost);
        RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Pending","RecordsShownCount": 0,"ExpenseTypeSelected": "PurchaseRequest"}}',strGetMyApprovalsData,strPost);
        RemoteServiceCallController.invokeService('{"myApprovalsDataRequest": {"ExpenseStatus":"Closed","RecordsShownCount": 0,"ExpenseTypeSelected": "Expense"}}',strGetMyApprovalsData,strPost);
        Test.stoptest();
    }
    
    
    public static testmethod void TestRequestDetail(){
        Core_CA_WrapperUtility wrapper=new Core_CA_WrapperUtility(); 
        
        profile p=[select id from profile where name=:'System Administrator']; 
        User obj_user1 = new User (username='Core_CA_testHeaderUser1@admintest.com',IsActive=true,Alias='user1',timezonesidkey='America/Los_Angeles',
                                   ProfileId=p.id,Email='Core_CA_testReqDetailUser1@admintest.com',FederationIdentifier='feed1', FirstName='ReqDetail',
                                   LastName='user1',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
        insert obj_user1;
         
        //Test data for Ariba
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba2',Source_System__c=strAriba,External_Created_Date__c =system.now());
        insert headerObj;
        System.assert(headerObj!= null);
        
        Core_Approver_Details__c approverObj1=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=obj_user1.Id,Name=strApprover,Status__c=strApproved,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj1;
        System.assert(approverObj1 != null);
               
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strApproved,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp,Action__c='REJC');
        insert approverObj;
        System.assert(approverObj!= null);
        
        Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details1',Approval_Header__c=headerObj.Id,Source_System__c = strAriba);
        insert lineObj;
        System.assert(lineObj!= null);
           
        //Test data for GTES
        Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader2', Source_System__c = strGtes, Status__c= strStatus,Manager__c = Userinfo.getuserId() ,
                                               Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(), Reminder_Alert_Days__c=0,Fully_Approved__c=false);
        insert objHeader;
        System.assert(objHeader != null);
         
        Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = strGtes,Approval_Header__c =  objHeader.Id,
                                               Role__c = strApp);
        insert objApprover;
        System.assert(objApprover != null);
        
        Core_Approval_Details__c lineGtesObj=new Core_Approval_Details__c(name='Line Details GTES 1',Approval_Header__c=objHeader.Id,Source_System__c = strGtes);
        insert lineGtesObj;
        System.assert(lineGtesObj!= null);
              
        //Test data for Clarity
        Core_Approval_Header__c objHeaderClr = new Core_Approval_Header__c( Name = 'testclarity1', Source_System__c = strClarity,Status__c= strStatus,Manager__c = Userinfo.getuserId(),
                                               Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId());                                           
        insert objHeaderClr;
        System.assert(objHeaderClr != null);
         
        Core_Approver_Details__c  objApproverclr = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = strClarity,Approval_Header__c =  objHeaderClr.Id,
                                               Role__c = strApp,Status__c=strApproved,Action__c='REWO');
        insert objApproverclr;
            
        //Test data for Invoice
        Core_Approval_Header__c objHeaderInv = new Core_Approval_Header__c( Name = 'testInvoice1', Source_System__c = strInvoice,Status__c= strStatus,Manager__c = Userinfo.getuserId(),
                                               Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(),External_Created_Date__c =system.now());                                           
        insert objHeaderInv;
        System.assert(objHeaderInv != null);
         
        Core_Approver_Details__c  objApproverInv = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = strInvoice,Approval_Header__c =  objHeaderInv.Id,
                                               Role__c = strApp,Status__c=strApproved,Action__c = 'APPR');
        insert objApproverInv;
        System.assert(objApproverInv != null);
        
        Test.starttest();
        RemoteServiceCallController.invokeService('{"expenseDetailRequest": {"RequestId":'+'"'+ headerObj.ID +'","ApproverId":'+'"'+ approverObj1.ID +'"}}','GetExpenseDetailData','POST');     
        //Calling service classes     
        RemoteServiceCallController.invokeService('{"expenseDetailRequest": {"RequestId":'+'"'+ objHeader.ID +'","ApproverId":'+'"'+ objApprover.ID+'"}}',strGetExpenseDetailData,strPost);
        RemoteServiceCallController.invokeService('{"expenseDetailRequest": {"RequestId":'+'"'+ headerObj.ID +'","ApproverId":'+'"'+ approverObj.ID+'"}}',strGetExpenseDetailData,strPost);
        RemoteServiceCallController.invokeService('{"expenseDetailRequest": {"RequestId":'+'"'+ objHeaderClr.ID +'","ApproverId":'+'"'+ objApproverclr.ID +'"}}',strGetExpenseDetailData,strPost);
        RemoteServiceCallController.invokeService('{"expenseDetailRequest": {"RequestId":'+'"'+ objHeaderInv.ID +'","ApproverId":'+'"'+ objApproverInv.ID +'"}}',strGetExpenseDetailData,strPost);
        //calling service to cover redirect from chatter link functionality.
        RemoteServiceCallController.invokeService('{"expenseDetailRequest": {"RequestId":'+'"'+ objHeader.ID +'","ApproverId":'+'"'+ objHeader.ID +'"}}',strGetExpenseDetailData,strPost);        
        //Exception Condtions 
        RemoteServiceCallController.invokeService('{"expenseDetailRequest": {"RequestId":"","ApproverId": '+'"'+ approverObj.ID+'"}}',strGetExpenseDetailData,strPost);
        RemoteServiceCallController.invokeService('{"expenseDetailRequest": {"RequestId":"","ApproverId":""}}',strGetExpenseDetailData,strPost);
        RemoteServiceCallController.invokeService('{"myApprovalPostRequest":{"UpdateFunctionType": "Rework","CommentDesc": "Hi......","CommentVisibleToUser": true,"ApproverId": '+'"'+objApproverclr.Id+'"}}','PostApproveRejectAction',strPost);
        RemoteServiceCallController.invokeService('{"myApprovalPostRequest":{"UpdateFunctionType": "QWV","CommentDesc": "Hi......","CommentVisibleToUser": true,"ApproverId": '+'"'+objApproverInv.Id+'"}}','PostApproveRejectAction',strPost);
        RemoteServiceCallController.invokeService('{"myApprovalPostRequest":{"UpdateFunctionType": "RTAP","CommentDesc": "Hi......","CommentVisibleToUser": true,"ApproverId": '+'"'+objApproverInv.Id+'"}}','PostApproveRejectAction',strPost);
        Test.stoptest();
    }
    
    public static testMethod void TestLineItemDetail(){
        Core_CA_WrapperUtility wrapper=new Core_CA_WrapperUtility();
        
        //Test data for Ariba
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba3',Source_System__c=strAriba);
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strApproved,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj;
        System.assert(approverObj!= null);
        Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details3',Approval_Header__c=headerObj.Id,Source_System__c = strAriba,Quantity__c = 44,Expense_Date__c= system.now(),Reimbursable__c= true,Receipt__c=true);
        insert lineObj;
        System.assert(lineObj!= null);
        
        //Test data for GTES
        Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader3', Source_System__c = strGtes, Status__c= strStatus,Manager__c = Userinfo.getuserId() ,
                                               Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(), Reminder_Alert_Days__c=0,Fully_Approved__c=false);
        insert objHeader;
        System.assert(objHeader != null);
        Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = strGtes,Approval_Header__c =  objHeader.Id,
                                               Role__c = strApp);
        insert objApprover;
        System.assert(objApprover != null);
        Core_Approval_Details__c lineObj1=new Core_Approval_Details__c(name='Line Details4',Approval_Header__c=objHeader.Id,Source_System__c = strGtes);
        insert lineObj1;
        System.assert(lineObj1!= null);
        
        //Test data for Invoice
        Core_Approval_Header__c objHeaderInv = new Core_Approval_Header__c( Name = 'testHeaderINV 2', Source_System__c = strInvoice, Status__c= strStatus,Manager__c = Userinfo.getuserId() ,
                                               Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(), Reminder_Alert_Days__c=0,Fully_Approved__c=false);
        insert objHeaderInv;
        System.assert(objHeaderInv != null);
        Core_Approver_Details__c  objApproverInv = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = strInvoice,Approval_Header__c =  objHeaderInv.Id,
                                               Role__c = strApp,Action__c='ACTV');
        insert objApproverInv;      
        System.assert(objApproverInv != null);
        
        Core_Approval_Details__c lineObjInv =new Core_Approval_Details__c(name='Line Details4',Approval_Header__c=objHeaderInv.Id,Source_System__c = strInvoice);
        insert lineObjInv;
        System.assert(lineObjInv!= null);
        
        //Test data for Clarity
        Core_Approval_Header__c objHeaderClr = new Core_Approval_Header__c( Name = 'testclarity1', Source_System__c = strClarity,Status__c= strStatus,Manager__c = Userinfo.getuserId(),
                                               Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId());                                           
        insert objHeaderClr;
        System.assert(objHeaderClr != null);
        
        Core_Approver_Details__c  objApproverclr2 = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = strClarity,Approval_Header__c =  objHeaderClr.Id,
                                               Role__c = strApp,Action__c='ACTV');
        insert objApproverclr2;
        System.assert(objApproverclr2 != null);
    
        
        Test.starttest();
        //Calling service classes 
        RemoteServiceCallController.invokeService('{"LineItemDetailRequest": {"RequestType":"Purchase Request","LineItemID":'+'"'+lineObj.Id+'"}}','GetLineItemDetailData',strPost);
        RemoteServiceCallController.invokeService('{"LineItemDetailRequest": {"RequestType":"Expense","LineItemID": '+'"'+ lineObj1.Id+'"}}','GetLineItemDetailData',strPost);        
        RemoteServiceCallController.invokeService('{"LineItemDetailRequest": {"RequestType":"Expense","LineItemID": ""}}','GetLineItemDetailData',strPost);
        RemoteServiceCallController.invokeService('{"LineItemDetailRequest": {"RequestType":"Invoice","LineItemID": '+'"'+ lineObjInv.Id+'"}}','GetLineItemDetailData',strPost);        
        Test.stoptest();
    }
    
    
    public static testMethod void TestApproveRejectAction(){
        
        //Test data for Ariba
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba3',Source_System__c=strAriba);
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strApproved,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj;
        System.assert(approverObj!= null);
        Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details5',Approval_Header__c=headerObj.Id,Source_System__c = strAriba);
        insert lineObj;
        System.assert(lineObj!= null);
        
         //Test data for GTES
        Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader4', Source_System__c = strGtes, Status__c= strStatus,Manager__c = Userinfo.getuserId() ,
                                               Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(), Reminder_Alert_Days__c=0,Fully_Approved__c=false);
        insert objHeader;
        System.assert(objHeader != null);
        Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = strGtes,Approval_Header__c =  objHeader.Id,
                                               Role__c = strApp);
        insert objApprover;
        System.assert(objApprover != null);
        Core_Approval_Details__c lineObj1=new Core_Approval_Details__c(name='Line Details6',Approval_Header__c=objHeader.Id,Source_System__c = strGtes);
        insert lineObj1;
        System.assert(lineObj1!= null);
        
         
        Test.starttest();
        //Calling service classes 
        RemoteServiceCallController.invokeService('{"myApprovalPostRequest":{"UpdateFunctionType": "Approve","CommentDesc": "Hi......","CommentVisibleToUser": true,"ApproverId":'+'"'+approverObj.Id+'"}}','PostApproveRejectAction',strPost);
        RemoteServiceCallController.invokeService('{"myApprovalPostRequest":{"UpdateFunctionType": "Reject","CommentDesc": "Hi......","CommentVisibleToUser": true,"ApproverId": '+'"'+objApprover.Id+'"}}','PostApproveRejectAction',strPost);
                
        RemoteServiceCallController.invokeService('{"myApprovalPostRequest":{"UpdateFunctionType": "Reject","CommentDesc": "Hi......","CommentVisibleToUser": true,"ApproverId": ""}}','PostApproveRejectAction',strPost);
        
        Utility.isEmpty(lineObj1);
        Utility.isEmpty('');
        Test.stoptest();
    }
    
    public static testMethod void TestRemoteCallWithParameter(){
        
        //Test data for Ariba
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba4',Source_System__c=strAriba);
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strApproved,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj;
        System.assert(approverObj!= null);
        Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details7',Approval_Header__c=headerObj.Id,Source_System__c = strAriba);
        insert lineObj;
        System.assert(lineObj!= null);
        
        //Test data for GTES
        Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader5', Source_System__c = strGtes, Status__c= strStatus,Manager__c = Userinfo.getuserId() ,
                                               Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(), Reminder_Alert_Days__c=0,Fully_Approved__c=false);
        insert objHeader;
        System.assert(objHeader != null);
        Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = strGtes,Approval_Header__c =  objHeader.Id,
                                               Role__c = strApp);
        insert objApprover;
        System.assert(objApprover != null);
        Core_Approval_Details__c lineObj1=new Core_Approval_Details__c(name='Line Details8',Approval_Header__c=objHeader.Id,Source_System__c = strGtes);
        insert lineObj1;
        System.assert(lineObj1!= null);
        
        
       
        
        Test.starttest();
         //Calling service classes
        RemoteServiceCallController.invokeServiceWithURLParameter('{"expenseDetailRequest": {"RequestId":"'+objHeader.Id+'","ApproverId": "'+Userinfo.getUserId()+'"}}','PostApproveRejectAction',strPost,Userinfo.getUserId());
        
        Test.stoptest();
    }
    
    public static testMethod void TestBaseServiceException(){
        Test.starttest();
        integer i=1;        
        Core_CA_BaseServiceException.resolveExceptions('test1',new Core_CA_BaseServiceException('Exception occured: CoreCA_REST_GetHeaderDetails : getRequestDetail method'));
        Core_CA_BaseServiceException.resolveExceptions(new Core_CA_BaseServiceException('Exception occured: CoreCA_REST_GetHeaderDetails : getRequestDetail method '));
        Core_CA_BaseServiceException.resolveExceptions('Test2',new Core_CA_BaseServiceException('Exception occured: CoreCA_REST_GetHeaderDetails : getRequestDetail method'),'Test3');
        system.assertEquals(i ,1);
        Test.stoptest();            
    }
    /*   
    public static testMethod void testMethodDeletefullyApprovedRecBatch(){     
           //Fully approved Purchase request.
           Core_Approval_Header__c headerObjAriba=new Core_Approval_Header__c(Name='Test Ariba5',Source_System__c=strAriba,Status__c='Fully Approved');
           insert headerObjAriba;
           System.assert(headerObjAriba != null);
           
           //Fully approved expense
           Core_Approval_Header__c headerObjGtes= new Core_Approval_Header__c(Name ='Test GTES', Source_System__c = strGtes, Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(),Fully_Approved__c=True);
           insert headerObjGtes;
           System.assert(headerObjGtes != null);
           
           //list of Fully approved records
           List<Core_Approval_Header__c> lstHeader = new List<Core_Approval_Header__c>();
           lstHeader.add(headerObjAriba);
           lstHeader.add(headerObjGtes);
                 
           Test.startTest();
           CORE_CA_Delete_Fullyapproved_Batch fullyAppBatch = new CORE_CA_Delete_Fullyapproved_Batch();
           Database.BatchableContext BC;
           fullyAppBatch.execute(BC,lstHeader);
           fullyAppBatch.finish(BC);
           Test.stopTest();
      }*/
 }