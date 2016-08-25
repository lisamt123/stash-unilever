/*
  Class Name: Core_CA_ApprovalsController_Test
  Author : Mindtree
  Date: 5 July 2016
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Test class to cover The following classes
                            1.Core_CA_ApprovalsController                        
*/
    /*
        we are using (SeeAllData=true ) because we are testing custom setting.
    */
@isTest(SeeAllData=true)
public class Core_CA_ApprovalsController_Test{
    
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
    
    public static testMethod void TestgetApprovalHomeScreenData(){    
        System.assert(Core_CA_ApprovalsController.getApprovalHomeScreenData()!= null);
    }
    
    public static testmethod void TestgetApprovalDetailPageData(){
       
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba1',Source_System__c=strAriba);
        insert headerObj;
        System.assert(headerObj!= null);
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Status__c=strApproved,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj;
        System.assert(approverObj!= null);
        
        test.starttest();
        System.assert(Core_CA_ApprovalsController.getApprovalDetailPageData(headerObj.ID,approverObj.ID)!= null);
        test.stoptest();
    }
    
    public static testmethod void TestgetAribaLineItemDetailPageData(){
       
        //Test data for Ariba
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name='Test Ariba2',Source_System__c=strAriba,External_Created_Date__c =system.now());
        insert headerObj;
        System.assert(headerObj!= null);
             
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
        
        Core_Approval_Details__c lineInvoiceObj=new Core_Approval_Details__c(name='Line Details Invoice',Approval_Header__c=objHeaderInv.Id,Source_System__c = strInvoice);
        insert lineInvoiceObj;
        System.assert(lineInvoiceObj!= null);
        
        test.starttest();
        System.assert(Core_CA_ApprovalsController.getAribaLineItemDetailPageData(lineObj.ID)!= null);
        System.assert(Core_CA_ApprovalsController.getGTESLineItemDetailPageData(lineGtesObj.ID)!= null);
        System.assert(Core_CA_ApprovalsController.getInvoiceLineItemDetail(lineInvoiceObj.ID)!= null);
        Boolean sucess = Core_CA_ApprovalsController.updateApprovalAction('Approve','ok','true',objApprover.ID);
        System.assertEquals(true,sucess,'Error in action');
        test.stoptest();
    }
    
    public static testMethod void TestgetUserLanguage(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standardTestuser@testorg.com');

      System.runAs(u) { 
       String lang = Core_CA_ApprovalsController.getUserLanguage();
         System.assertEquals('en_US',lang, 'Error');
      }
    
        
    }
    
    public static testMethod void TestgetGAID(){    
        System.assert(Core_CA_ApprovalsController.getGAID()!= null);
    }
    
    public static testMethod void TestgetUIThemeDescription(){    
        System.assert(Core_CA_ApprovalsController.getUIThemeDescription()!= null);
    }
    
 }