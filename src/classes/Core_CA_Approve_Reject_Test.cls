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

@isTest (Seealldata=true)
//This test class is to cover controllers associated with vf pages used for Approve/Reject functionalities
public class Core_CA_Approve_Reject_Test{
    
    //This method covers the controller class of approve action for header object
    static testMethod void TestHeaderApprove(){
        test.starttest();
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Approved',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
        insert approverObj;
        System.assert(approverObj!= null);
        
        Core_Approval_Header__c headerObj1=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
        insert headerObj1;
        System.assert(headerObj1!= null);
        Core_Approver_Details__c approverObj2=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Approved',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
        insert approverObj2;
        System.assert(approverObj2!= null);
        Core_Approver_Details__c approverObj3=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
        insert approverObj3;
        System.assert(approverObj3!= null);
        
        Apexpages.currentPage().getParameters().put('id',headerObj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(headerObj);
        Core_CA_HeaderApproveController headerApproveCont=new Core_CA_HeaderApproveController(sc);
        headerApproveCont.approverComments='Approved';
        headerApproveCont.submitComments();
        headerApproveCont.approverComments='hpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpoho';
        headerApproveCont.submitComments();
        
        Apexpages.currentPage().getParameters().put('id',headerObj1.id);
        ApexPages.StandardController sc1 = new ApexPages.standardController(headerObj1);
        Core_CA_HeaderApproveController headerApproveCont1=new Core_CA_HeaderApproveController(sc1);
        headerApproveCont1.approverComments='Approved';
        headerApproveCont1.submitComments();
        test.stoptest();
    } 
    
    //This method covers the controller class of reject action for header object
    static testMethod void TestHeaderReject(){
        test.starttest();
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Rejected',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
        insert approverObj;
        System.assert(approverObj!= null);
        
        Core_Approval_Header__c headerObj1=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
        insert headerObj1;
        System.assert(headerObj1!= null);
        Core_Approver_Details__c approverObj2=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Rejected',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
        insert approverObj2;
        System.assert(approverObj2!= null);
        Core_Approver_Details__c approverObj3=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
        insert approverObj3;
        System.assert(approverObj3!= null);
        
        Apexpages.currentPage().getParameters().put('id',headerObj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(headerObj);
        Core_CA_HeaderRejectController headerRejectCont=new Core_CA_HeaderRejectController(sc);
        headerRejectCont.approverComments='Rejected';
        headerRejectCont.submitComments();
        headerRejectCont.approverComments='hpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpoho';
        headerRejectCont.submitComments();
        
        Apexpages.currentPage().getParameters().put('id',headerObj1.id);
        ApexPages.StandardController sc1 = new ApexPages.standardController(headerObj1);
        Core_CA_HeaderRejectController headerRejectCont1=new Core_CA_HeaderRejectController(sc1);
        headerRejectCont1.approverComments='Rejected';
        headerRejectCont1.submitComments();
        test.stoptest();
    }
    
    //This method covers the controller class of approve action for Interested Party object
    static testMethod void TestApproverApprove(){
        test.starttest();
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Approved',Is_Active__c=true,Role__c='APP',Source_System__c='Ariba');
        insert approverObj;
        System.assert(approverObj!= null);
        
        Apexpages.currentPage().getParameters().put('id',approverObj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(approverObj);
        Core_CA_Approver_ApproveController approverApproveCont=new Core_CA_Approver_ApproveController(sc);
        approverApproveCont.approverComments='Approved';
        approverApproveCont.submitComments();
        Core_Approver_Details__c approverObj1=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Is_Active__c=true,Role__c='APP',Source_System__c='Ariba');
        insert approverObj1;
        approverApproveCont.approverComments='hpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpoho';
        approverApproveCont.submitComments();
        test.stoptest();
    }
    
    //This method covers the controller class of reject action for Interested Party object
    static testMethod void TestApproverReject(){
        test.starttest();
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Approved',Is_Active__c=true,Role__c='APP',Source_System__c='Ariba');
        insert approverObj;
        System.assert(approverObj!= null);
        
        Apexpages.currentPage().getParameters().put('id',approverObj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(approverObj);
        Core_CA_Approver_RejectController approverRejectCont=new Core_CA_Approver_RejectController(sc);
        approverRejectCont.approverComments='Rejected';
        approverRejectCont.submitComments();
        Core_Approver_Details__c approverObj1=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Is_Active__c=true,Role__c='APP',Source_System__c='Ariba');
        insert approverObj1;
        approverRejectCont.approverComments='hpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpoho';
        approverRejectCont.submitComments();
        test.stoptest();
    }
    
    //This method covers the controller class of approve action for line object
    static testMethod void TestLineApprove(){
        test.starttest();
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=headerObj.Id,Source_System__c='Ariba');
        insert lineObj;
        System.assert(lineObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Approved',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
        insert approverObj;
        System.assert(approverObj!= null);
        
        Core_Approval_Header__c headerObj1=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
        insert headerObj1;
        System.assert(headerObj1!= null);
        Core_Approval_Details__c lineObj1=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=headerObj1.Id,Source_System__c='Ariba');
        insert lineObj1;
        System.assert(lineObj!= null);
        Core_Approver_Details__c approverObj2=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Approved',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
        insert approverObj2;
        System.assert(approverObj2!= null);
        Core_Approver_Details__c approverObj3=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
        insert approverObj3;
        System.assert(approverObj3!= null);
        
        Apexpages.currentPage().getParameters().put('id',lineObj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(lineObj);
        Core_CA_Line_ApproveController lineApproveCont=new Core_CA_Line_ApproveController(sc);
        lineApproveCont.approverComments='Approved';
        lineApproveCont.submitComments();
        lineApproveCont.approverComments='hpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpoho';
        lineApproveCont.submitComments();
        
        Apexpages.currentPage().getParameters().put('id',lineObj1.id);
        ApexPages.StandardController sc1 = new ApexPages.standardController(lineObj1);
        Core_CA_Line_ApproveController lineApproveCont1=new Core_CA_Line_ApproveController(sc1);
        lineApproveCont1.approverComments='Approved';
        lineApproveCont1.submitComments();
        test.stoptest();
    }
    
    //This method covers the controller class of reject action for line object
    static testMethod void TestLineReject(){
        test.starttest();
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=headerObj.Id,Source_System__c='Ariba');
        insert lineObj;
        System.assert(lineObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Approved',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
        insert approverObj;
        System.assert(approverObj!= null);
        
        Core_Approval_Header__c headerObj1=new Core_Approval_Header__c(Name='Test Ariba',Source_System__c='Ariba');
        insert headerObj1;
        System.assert(headerObj1!= null);
        Core_Approval_Details__c lineObj1=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=headerObj1.Id,Source_System__c='Ariba');
        insert lineObj1;
        System.assert(lineObj!= null);
        Core_Approver_Details__c approverObj2=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Status__c='Rejected',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
        insert approverObj2;
        System.assert(approverObj2!= null);
        Core_Approver_Details__c approverObj3=new Core_Approver_Details__c(Approval_Header__c=headerObj1.Id,Interested_Party__c=Userinfo.getuserId(),Name='Approver',Is_Active__c=true,Source_System__c='Ariba',Role__c='APP');
        insert approverObj3;
        System.assert(approverObj3!= null);
        
        Apexpages.currentPage().getParameters().put('id',lineObj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(lineObj);
        Core_CA_Line_RejectController lineRejectCont=new Core_CA_Line_RejectController(sc);
        lineRejectCont.approverComments='Rejected';
        lineRejectCont.submitComments();
        lineRejectCont.approverComments='hpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpohoihpopohpoho';
        lineRejectCont.submitComments();
        
        Apexpages.currentPage().getParameters().put('id',lineObj1.id);
        ApexPages.StandardController sc1 = new ApexPages.standardController(lineObj1);
        Core_CA_Line_RejectController lineRejectCont1=new Core_CA_Line_RejectController(sc1);
        lineRejectCont1.approverComments='Rejected';
        lineRejectCont1.submitComments();
        test.stoptest();
    }
}