/*
  Class Name: Core_CA_Approve_Reject_Test
  Author : Mindtree
  Date: 15 sep 2014
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Test class to cover 
                           1.Core_CA_HeaderApproveController
                           2.Core_CA_HeaderRejectController
                           3.Core_CA_Approver_RejectController 
                           4.Core_CA_Approver_ApproveController
                           5.Core_CA_Line_ApproveController 
                           6.Core_CA_Line_RejectController

*/

@isTest 
//This test class is to cover controllers associated with vf pages used for Approve/Reject functionalities
public class Core_CA_Approve_Reject_Test{
    
    @TestVisible static String strAriba= 'Ariba';
    @TestVisible static String strApp= 'APP';
    @TestVisible static String strStatusRejected= 'Rejected';
    @TestVisible static String strApprover= 'Approver';
    @TestVisible static String strApproved= 'Approved';
    
    @testSetup static void setup() {
        List<CORE_Chatter_Approval__c> lstCustSet = new List<CORE_Chatter_Approval__c>();
       
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='MyApprovalsTabId', Text_Value__c='Yes'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='AppRejSubmitMessage', Text_Value__c='This form is electronically signed when you click submit. By submitting, you are confirming that the information provided by you reflects your wishes and intent'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='AppErrorMessage', Text_Value__c='You are not authorized to approve this request'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='AppRejAribaMessage', Text_Value__c='You are not an active Approver for this PR'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='AppRejAlreadyStatus', Text_Value__c='You have already approved/rejected this request'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='AppRejGTESCANCMessage', Text_Value__c='User has recalled this expense Claim'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='AppRejStringLengthMessage', Text_Value__c='Please restrict Comments to less than 255 characters'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='AppConfirmMessage', Text_Value__c='You have successfully approved this request'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='AppRejDBErrorMessage', Text_Value__c='An error has occurred, please try again later'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='RejErrorMessage', Text_Value__c='You are not authorized to reject this request'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='AppRejGTESCommErrMessage', Text_Value__c='You have successfully rejected this request' ,ReminderAlertDays__c=0));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='RejConfirmMessage', Text_Value__c='You have successfully rejected this request',ReminderAlertDays__c=0));
        
        if(!lstCustSet.isEmpty())
           insert lstCustSet;     
    }
    
    //This method covers the controller class of approve action for header object
    static testmethod void TestHeaderApprove(){
       
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba1',Source_System__c=strAriba);
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strApproved,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj;
        System.assert(approverObj!= null);
        
        Core_Approval_Header__c headerObj1=new Core_Approval_Header__c(Name='Test Ariba2',Source_System__c=strAriba);
        insert headerObj1;
        System.assert(headerObj1!= null);
        Core_Approver_Details__c approverObj2=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strApproved,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj2;
        System.assert(approverObj2!= null);
        Core_Approver_Details__c approverObj3=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj3;
        System.assert(approverObj3!= null);
        
        test.starttest();
        Apexpages.currentPage().getParameters().put('id',headerObj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(headerObj);
        Core_CA_HeaderApproveController headerApproveCont=new Core_CA_HeaderApproveController(sc);
        headerApproveCont.approverComments=strApproved;
        headerApproveCont.submitComments();
        headerApproveCont.approverComments='ahpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpoho';
        headerApproveCont.submitComments();
        
        Apexpages.currentPage().getParameters().put('id',headerObj1.id);
        ApexPages.StandardController sc1 = new ApexPages.standardController(headerObj1);
        Core_CA_HeaderApproveController headerApproveCont1=new Core_CA_HeaderApproveController(sc1);
        headerApproveCont1.approverComments=strApproved;
        headerApproveCont1.submitComments();
        test.stoptest();
    } 
    
    //This method covers the controller class of reject action for header object
    static testmethod void TestHeaderReject(){
        
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba3',Source_System__c=strAriba);
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strStatusRejected,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj;
        System.assert(approverObj!= null);
        
        Core_Approval_Header__c headerObj1=new Core_Approval_Header__c(Name='Test Ariba4',Source_System__c=strAriba);
        insert headerObj1;
        System.assert(headerObj1!= null);
        Core_Approver_Details__c approverObj2=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strStatusRejected,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj2;
        System.assert(approverObj2!= null);
        Core_Approver_Details__c approverObj3=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj3;
        System.assert(approverObj3!= null);
        
        test.starttest();
        Apexpages.currentPage().getParameters().put('id',headerObj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(headerObj);
        Core_CA_HeaderRejectController headerRejectCont=new Core_CA_HeaderRejectController(sc);
        headerRejectCont.approverComments=strStatusRejected;
        headerRejectCont.submitComments();
        headerRejectCont.approverComments='bhpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpoho';
        headerRejectCont.submitComments();
        
        Apexpages.currentPage().getParameters().put('id',headerObj1.id);
        ApexPages.StandardController sc1 = new ApexPages.standardController(headerObj1);
        Core_CA_HeaderRejectController headerRejectCont1=new Core_CA_HeaderRejectController(sc1);
        headerRejectCont1.approverComments=strStatusRejected;
        headerRejectCont1.submitComments();
        test.stoptest();
    }
    
    //This method covers the controller class of approve action for Interested Party object
    static testmethod void TestApproverApprove(){
        
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba5',Source_System__c=strAriba);
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strApproved,Is_Active__c=true,Role__c=strApp,Source_System__c=strAriba);
        insert approverObj;
        System.assert(approverObj!= null);
        
        test.starttest();
        Apexpages.currentPage().getParameters().put('id',approverObj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(approverObj);
        Core_CA_Approver_ApproveController approverApproveCont=new Core_CA_Approver_ApproveController(sc);
        approverApproveCont.approverComments=strApproved;
        approverApproveCont.submitComments();
        Core_Approver_Details__c approverObj1=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Is_Active__c=true,Role__c=strApp,Source_System__c=strAriba);
        insert approverObj1;
        approverApproveCont.approverComments='chpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpoho';
        approverApproveCont.submitComments();
        test.stoptest();
    }
    
    //This method covers the controller class of reject action for Interested Party object
    static testmethod  void TestApproverReject(){
        
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba6',Source_System__c=strAriba);
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strApproved,Is_Active__c=true,Role__c=strApp,Source_System__c=strAriba);
        insert approverObj;
        System.assert(approverObj!= null);
        
        test.starttest();
        Apexpages.currentPage().getParameters().put('id',approverObj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(approverObj);
        Core_CA_Approver_RejectController approverRejectCont=new Core_CA_Approver_RejectController(sc);
        approverRejectCont.approverComments=strStatusRejected;
        approverRejectCont.submitComments();
        Core_Approver_Details__c approverObj1=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Is_Active__c=true,Role__c=strApp,Source_System__c=strAriba);
        insert approverObj1;
        approverRejectCont.approverComments='dhpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpoho';
        approverRejectCont.submitComments();
        test.stoptest();
    }
    
    //This method covers the controller class of approve action for line object
    static testmethod  void TestLineApprove(){
        
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba7',Source_System__c=strAriba);
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=headerObj.Id,Source_System__c=strAriba);
        insert lineObj;
        System.assert(lineObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strApproved,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj;
        System.assert(approverObj!= null);
        
        Core_Approval_Header__c headerObj1=new Core_Approval_Header__c(Name='Test Ariba8',Source_System__c=strAriba);
        insert headerObj1;
        System.assert(headerObj1!= null);
        Core_Approval_Details__c lineObj1=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=headerObj1.Id,Source_System__c=strAriba);
        insert lineObj1;
        System.assert(lineObj!= null);
        Core_Approver_Details__c approverObj2=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strApproved,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj2;
        System.assert(approverObj2!= null);
        Core_Approver_Details__c approverObj3=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj3;
        System.assert(approverObj3!= null);
        
        test.starttest();
        Apexpages.currentPage().getParameters().put('id',lineObj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(lineObj);
        Core_CA_Line_ApproveController lineApproveCont=new Core_CA_Line_ApproveController(sc);
        lineApproveCont.approverComments=strApproved;
        lineApproveCont.submitComments();
        lineApproveCont.approverComments='ehpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpoho';
        lineApproveCont.submitComments();
        
        Apexpages.currentPage().getParameters().put('id',lineObj1.id);
        ApexPages.StandardController sc1 = new ApexPages.standardController(lineObj1);
        Core_CA_Line_ApproveController lineApproveCont1=new Core_CA_Line_ApproveController(sc1);
        lineApproveCont1.approverComments=strApproved;
        lineApproveCont1.submitComments();
        test.stoptest();
    }
    
    //This method covers the controller class of reject action for line object
    static testmethod void TestLineReject(){
        
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba9',Source_System__c=strAriba);
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=headerObj.Id,Source_System__c=strAriba);
        insert lineObj;
        System.assert(lineObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strApproved,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj;
        System.assert(approverObj!= null);
        
        Core_Approval_Header__c headerObj1=new Core_Approval_Header__c(Name='Test Ariba10',Source_System__c=strAriba);
        insert headerObj1;
        System.assert(headerObj1!= null);
        Core_Approval_Details__c lineObj1=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=headerObj1.Id,Source_System__c=strAriba);
        insert lineObj1;
        System.assert(lineObj!= null);
        Core_Approver_Details__c approverObj2=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strStatusRejected,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj2;
        System.assert(approverObj2!= null);
        Core_Approver_Details__c approverObj3=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj3;
        System.assert(approverObj3!= null);
        
        test.starttest();
        Apexpages.currentPage().getParameters().put('id',lineObj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(lineObj);
        Core_CA_Line_RejectController lineRejectCont=new Core_CA_Line_RejectController(sc);
        lineRejectCont.approverComments=strStatusRejected;
        lineRejectCont.submitComments();
        lineRejectCont.approverComments='fhpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpoho';
        lineRejectCont.submitComments();
        System.assert(lineRejectCont!= null);
        
        Apexpages.currentPage().getParameters().put('id',lineObj1.id);
        ApexPages.StandardController sc1 = new ApexPages.standardController(lineObj1);
        Core_CA_Line_RejectController lineRejectCont1=new Core_CA_Line_RejectController(sc1);
        lineRejectCont1.approverComments=strStatusRejected;
        lineRejectCont1.submitComments();
        System.assert(lineRejectCont1!= null);
        test.stoptest();
    }
}