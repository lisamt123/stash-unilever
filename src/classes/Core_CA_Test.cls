/*
  Class Name: Core_CA_Test
  Author : Mindtree
  Date: 15 sep 2014
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Test class to cover 
                           1.Core_CA_ApprovalDetailsController
                           2.Core_CA_RequestDetailsController
                           3.Core_CA_Header_Handler
                           4.Core_CA_InterestedParty_Handler
                           5.Core_CA_Header_BI_AI_AU
                           6.Core_CA_Line_Details_BI
                           7.Core_CA_InterestedParty_BI_AI_AU
*/

@isTest(SeeAllData=true)
public class Core_CA_Test {
   
   //Test method to cover both Header handler and Interested Party trigger and handler. 
   static testMethod void testMethodForHeaderAndApproverHandlerGTES1(){   
       
       Test.starttest();
       //Test User
       profile p=[select id from profile where name=:'System Administrator']; 
       User obj_user1 = new User (username='Core_CA_testHeaderUser1@admintest.com',IsActive=true,Alias='user1',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser1@admintest.com',FederationIdentifier='feed1', FirstName='Header',
                                 LastName='user1',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user1;
       
       User obj_user2 = new User (username='Core_CA_testHeaderUser2@admintest.com',IsActive=true,Alias='user2',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser2@admintest.com',FederationIdentifier='feed2', FirstName='Header',
                                 LastName='user2',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user2;
       
       user obj_user3 = new User (username='Core_CA_testHeaderUser3@admintest.com',IsActive=true,Alias='user3',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser3@admintest.com',FederationIdentifier='feed3', FirstName='Header',
                                 LastName='user3',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user3;
          
       //Test data for Header object(insert).
       Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'GTES', Status__c= 'Approver Added',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0,Fully_Approved__c=false);
       insert objHeader;
       System.assert(objHeader != null);
       
       
       //Test Data for Interested party object(insert).
       Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = obj_user3.Id ,Source_System__c = 'GTES',Approval_Header__c =  objHeader.Id,
                                               Role__c = 'EMP',Action__c = 'SUBM');
       insert objApprover;
       System.assert(objApprover != null);
       
       Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=objHeader.Id,Source_System__c = 'GTES');
       insert lineObj;
       System.assert(lineObj!= null);
       
       //Test data for Header Object(Update).
        objHeader.Ledger_Extract__c= Datetime.now();
        Update objHeader;
       
       //Test Data for Interested party object(Update).       
       objApprover.Interested_Party__c =obj_user1.Id;
       Update objApprover;
       
       //Expense Claim Submitted(Action 'SUBM' and Role 'EMP')
       Core_Approver_Details__c  objApprover1 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = 'GTES',     
                                                Role__c = 'EMP',Action__c = 'SUBM',Approval_Header__c =  objHeader.Id);
       insert objApprover1;
       
       //Expense Claim Submitted with(Action 'SUBM' and Role 'SUB')
       Core_Approver_Details__c  objApprover2 = new Core_Approver_Details__c (Interested_Party__c = obj_user3.Id,Source_System__c = 'GTES',     
                                                Role__c = 'SUB',Action__c = 'SUBM',Approval_Header__c =  objHeader.Id);
       insert objApprover2;
       
       //Expense Claim Submitted with(Action 'SUBM' and Role 'SUB')
       Core_Approver_Details__c  objApprover3 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = 'GTES',     
                                                Role__c = 'SUB',Action__c = 'SUBM',Approval_Header__c =  objHeader.Id);
       insert objApprover3;
       
       
       
       //delete objApprover6;
       
       
       Test.stoptest();
       
   }  
   
   static testMethod void testMethodForHeaderAndApproverHandlerGTES2(){
       Test.starttest(); 
       //Test User
       profile p=[select id from profile where name=:'System Administrator']; 
       User obj_user1 = new User (username='Core_CA_testHeaderUser1@admintest.com',IsActive=true,Alias='user1',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser1@admintest.com',FederationIdentifier='feed1', FirstName='Header',
                                 LastName='user1',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user1;
       
       User obj_user2 = new User (username='Core_CA_testHeaderUser2@admintest.com',IsActive=true,Alias='user2',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser2@admintest.com',FederationIdentifier='feed2', FirstName='Header',
                                 LastName='user2',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user2;
       
       //Test data for Header object(insert).
       Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'GTES', Status__c= 'Approver Added',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0,Fully_Approved__c=false);
       insert objHeader;
       System.assert(objHeader != null);
       
       Core_Approval_Header__c objHeader1 = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'GTES', Status__c= 'Approver Added',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0,Fully_Approved__c=true);
       insert objHeader1;
       System.assert(objHeader1 != null);
       
       //Approver Added with (Role__c 'APP')
       Core_Approver_Details__c  objApprover4 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = 'GTES',     
                                                Role__c = 'APP',Action__c = 'ACTV',Approval_Header__c =  objHeader.Id);
       insert objApprover4;
       
       //Fully Approved with (Action 'CANC' and Role 'EMP')
       Core_Approver_Details__c  objApprover5 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = 'GTES',     
                                                Role__c = 'EMP',Action__c = 'CANC',Approval_Header__c =  objHeader.Id);
       insert objApprover5;
       
       //Rejected with (Action 'REJC' and Role 'APP')
       Core_Approver_Details__c  objApprover6 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = 'GTES',     
                                                Role__c = 'APP',Action__c = 'REJC',Approval_Header__c =  objHeader.Id);
       insert objApprover6;
       
       //Fully Approved ( Role 'SYS' and Action 'APPR' )
       /*objApprover3.Action__c='APPR';
       objApprover3.Role__c='SYS';
       update objApprover3;*/
       
       objApprover6.Interested_Party__c=obj_user2.Id;
       objApprover6.Action__c='ACTV';
       update objApprover6;
            
       objApprover5.Role__c='EMP';
       objApprover5.Action__c='SUBM';
       update objApprover5;
       
       //Rejected (Role 'APP' and Action 'REJC' )
       objApprover4.Action__c='REJC';
       objApprover4.Role__c='APP';
       update objApprover4;
       
       
       objHeader.Fully_Approved__c=true;
       update objHeader;
       
       Test.stoptest();
   }
   
     
  static testMethod void testMethodForHeaderAndApproverHandlerAriba1(){
        
       Test.starttest();
       
       //Test User
       profile p=[select id from profile where name=:'System Administrator']; 
       User obj_user1 = new User (username='Core_CA_testHeaderUser1@admintest.com',IsActive=true,Alias='user1',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser1@admintest.com',FederationIdentifier='feed1', FirstName='Header',
                                 LastName='user1',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user1;
       
       User obj_user2 = new User (username='Core_CA_testHeaderUser2@admintest.com',IsActive=true,Alias='user2',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser2@admintest.com',FederationIdentifier='feed2', FirstName='Header',
                                 LastName='user2',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user2;
       
          
       //Test data for Header object(insert).
       
       //Submitted notification when Requested For == Requested by(after insert)
       Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'Ariba',Manager__c = obj_user1.Id ,Status__c= 'Submitted',
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0);
       insert objHeader;
       System.assert(objHeader != null);
       //Submitted notification when Requested For == Requested by(after update)
       objHeader.Status__c='Withdrawn';
       update objHeader;
       objHeader.Status__c='Submitted';
       update objHeader;
       
       //Inserting line detail
       Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=objHeader.Id,Source_System__c = 'Ariba');
       insert lineObj;
       System.assert(lineObj!= null);
       
       //Submitted notification when Requested For <> Requested by(after insert)
       Core_Approval_Header__c objHeader1 = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'Ariba', Status__c= 'Submitted',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user2.Id, Reminder_Alert_Days__c=0);
       insert objHeader1;
       System.assert(objHeader1 != null);
       //Submitted notification when Requested For <> Requested by(after update)
       objHeader1.Status__c='Withdrawn';
       update objHeader1;
       objHeader1.Status__c='Submitted';
       update objHeader1;
      
       Core_Approver_Details__c  objApproveResub1 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id ,Source_System__c = 'Ariba',Approval_Header__c =  objHeader.Id,Action__c='REJC');
       insert objApproveResub1;
       System.assert(objApproveResub1 != null);
       //Denied to resubmit
       objApproveResub1.Action__c='';
       update objApproveResub1;
       
       Core_Approver_Details__c  objApproverResub2 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id ,Source_System__c = 'Ariba',Approval_Header__c =  objHeader1.Id,Action__c='REJC');
       insert objApproverResub2;
       System.assert(objApproverResub2 != null);
       //Denied to resubmit
       objApproverResub2.Action__c='';
       update objApproverResub2;
       
       //Approver added notification(after insert)
       Core_Approver_Details__c  objApprover1 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = 'Ariba',     
                                                Role__c = 'APP',Is_Active__c=true,Approval_Header__c =  objHeader1.Id);
       insert objApprover1;
       
       //Approver deleted notification
       delete objApprover1;
       
       //Approver approved notifiaction(after insert)
       Core_Approver_Details__c  objApprover2 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = 'Ariba',     
                                                Role__c = 'APP',Is_Active__c=true,Action__c='APPR',Approval_Header__c =  objHeader1.Id);
       insert objApprover2;
                    
       Test.stoptest();
   }
   
   static testMethod void testMethodForHeaderAndApproverHandlerAriba2(){
       Test.starttest();
        //Test User
       profile p=[select id from profile where name=:'System Administrator']; 
       User obj_user1 = new User (username='Core_CA_testHeaderUser1@admintest.com',IsActive=true,Alias='user1',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser1@admintest.com',FederationIdentifier='feed1', FirstName='Header',
                                 LastName='user1',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user1;
       
       User obj_user2 = new User (username='Core_CA_testHeaderUser2@admintest.com',IsActive=true,Alias='user2',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser2@admintest.com',FederationIdentifier='feed2', FirstName='Header',
                                 LastName='user2',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user2;
       
       //Header with Requested For == Requested by.
       Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'Ariba',Manager__c = obj_user1.Id ,Status__c='Fully Approved',
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0);
       insert objHeader;
       System.assert(objHeader != null);
       
       //Header with Requested For <> Requested by.
       Core_Approval_Header__c objHeader1 = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'Ariba', Status__c= 'Submitted',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user2.Id, Reminder_Alert_Days__c=0);
       insert objHeader1;
       System.assert(objHeader1 != null);
       
       //Header with Requested For <> Requested by.
       Core_Approval_Header__c objHeader2 = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'Ariba',Manager__c = obj_user1.Id ,Status__c='Submitted',
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user2.Id, Reminder_Alert_Days__c=0);
       insert objHeader2;
       System.assert(objHeader2 != null);
       
       //Interested party test data
       Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id ,Source_System__c = 'Ariba',Approval_Header__c =  objHeader1.Id,Is_Active__c=false,Role__c='APP');
       insert objApprover;
       System.assert(objApprover != null);
       
       objHeader.Status__c='Submitted';
       update objHeader;
       
       //Notification sent when approver is added. 
       objApprover.Is_Active__c=true;
       update objApprover;
      
       //Notification sent when the approver approved.      
       objApprover.Action__c='APPR';
       update objApprover;
       
       //fully approved notificaton.    
       objHeader.Status__c='Fully Approved';
       update objHeader;
      
       //Header data with status as denied     
       Core_Approval_Header__c objHeader3 = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'Ariba', Status__c= 'Denied',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user2.Id, Reminder_Alert_Days__c=0);
       insert objHeader3;
       
       //Approver denied notification
       Core_Approver_Details__c  objApprover3 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = 'Ariba',    
                                                Role__c = 'APP',Is_Active__c=true,Action__c='REJC',Approval_Header__c =  objHeader3.Id);
       insert objApprover3;
       
       //Denied to resubmit
       objHeader3.Status__c='Submitted';
       update objHeader3;
       objApprover3.Action__c='';
       update objApprover3;
       
       objHeader3.Status__c='Denied';
       update objHeader3;
       objApprover3.Action__c='REJC';
       update objApprover3;
       
       Test.stoptest();
   }
   
   
   /*static testMethod void testMethodForHeaderAndApproverHandlerRemedy(){
       Test.starttest();
         //Test User
       profile p=[select id from profile where name=:'System Administrator']; 
       User obj_user1 = new User (username='Core_CA_testHeaderUser1@admintest.com',IsActive=true,Alias='user1',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser1@admintest.com',FederationIdentifier='feed1', FirstName='Header',
                                 LastName='user1',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user1;
       
       User obj_user2 = new User (username='Core_CA_testHeaderUser2@admintest.com',IsActive=true,Alias='user2',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser2@admintest.com',FederationIdentifier='feed2', FirstName='Header',
                                 LastName='user2',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user2;
          
       //Test data for Header object(insert).
       Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'Remedy', Status__c= 'Approver Added',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0);
       insert objHeader;
       System.assert(objHeader != null);
       
       Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id ,Source_System__c = 'Remedy',Approval_Header__c =  objHeader.Id,
                                                Role__c = 'EMP',Action__c = 'SUBM');
       insert objApprover;
       System.assert(objApprover != null);
       
       Core_Approval_Details__c lineObj=new Core_Approval_Details__c(Name ='Line Details',Approval_Header__c=objHeader.Id,Source_System__c = 'Remedy');
       insert lineObj;
       System.assert(lineObj!= null);
       Test.stoptest();
   }*/
   
   
   //Test method to cover both Request and Approval details
   static testMethod void testMethodForRequestAndApprovalDetails(){ 
       //Test User
       profile p=[select id from profile where name=:'System Administrator'];
       User obj_user1 = new User (username='Core_CA_testHeaderUser4@admintest.com',IsActive=true,Alias='user1',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser4@admintest.com',FederationIdentifier='feed1', FirstName='Header',
                                 LastName='user1',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user1;
       
       User obj_user2 = new User (username='Core_CA_testHeaderUser5@admintest.com',IsActive=true,Alias='user2',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser5@admintest.com',FederationIdentifier='feed2', FirstName='Header',
                                 LastName='user2',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user2;
       
       user obj_user3 = new User (username='Core_CA_testHeaderUser6@admintest.com',IsActive=true,Alias='user3',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser6@admintest.com',FederationIdentifier='feed3', FirstName='Header',
                                 LastName='user3',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user3;
        
       //Test data for Header object(insert).
       Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = 'GTES', Status__c= 'Approver Added',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0);
       insert objHeader;
       System.assert(objHeader != null);
       

       //Test Data for Interested party object(insert).
       Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = obj_user3.Id ,Source_System__c = 'GTES',Approval_Header__c =  objHeader.Id,
                                               Role__c = 'EMP',Action__c = 'SUBM');
       insert objApprover;
       System.assert(objApprover != null);
           
       Test.StartTest();
       // Test coverage for the Class 'Core_CA_ApprovalDetailsController'
       Core_CA_ApprovalDetailsController objAppDetailCont = new Core_CA_ApprovalDetailsController();
       //Oepn approval
       objAppDetailCont.getopenApproval();
       objAppDetailCont.BeginningOpen();
       objAppDetailCont.PreviousOpen();
       objAppDetailCont.NextOpen();
       objAppDetailCont.EndOpen();
       objAppDetailCont.getDisablePreviousOpen();
       objAppDetailCont.getDisableNextOpen();
       objAppDetailCont.gettotal_sizeOpen();
       objAppDetailCont.getPageNumberOpen();
       objAppDetailCont.getTotalPagesOpen();
       //closed approval
       objAppDetailCont.getClosedApproval();
       objAppDetailCont.BeginningClose();
       objAppDetailCont.PreviousClose();
       objAppDetailCont.NextClose();
       objAppDetailCont.EndClose();
       objAppDetailCont.getDisablePreviousClose();
       objAppDetailCont.getDisableNextClose();
       objAppDetailCont.gettotal_sizeClose();
       objAppDetailCont.getPageNumberClose();
       objAppDetailCont.getTotalPagesClose();
       
       
       //Test coverage for the class 'Core_CA_RequestDetailsController'
       Core_CA_RequestDetailsController objReqDetailCont = new Core_CA_RequestDetailsController();
       //Open request
       objReqDetailCont.getopenRequests();
       objReqDetailCont.BeginningOpen();
       objReqDetailCont.PreviousOpen();
       objReqDetailCont.NextOpen();
       objReqDetailCont.EndOpen();
       objReqDetailCont.getDisablePreviousOpen();
       objReqDetailCont.getDisableNextOpen();
       objReqDetailCont.gettotal_sizeOpen();
       objReqDetailCont.getPageNumberOpen();
       objReqDetailCont.getTotalPagesOpen();
       //Closed request
       objReqDetailCont.getclosedRequests();
       objReqDetailCont.BeginningClose();
       objReqDetailCont.PreviousClose();
       objReqDetailCont.NextClose();
       objReqDetailCont.EndClose();
       objReqDetailCont.getDisablePreviousClose();
       objReqDetailCont.getDisableNextClose();
       objReqDetailCont.gettotal_sizeClose();
       objReqDetailCont.getPageNumberClose();
       objReqDetailCont.getTotalPagesClose();
       Test.StopTest();
   }
   
}