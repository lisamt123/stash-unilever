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

@isTest
public class Core_CA_Test {
   
   
   @TestVisible static String strSystemAdministrator = 'System Administrator';
   @TestVisible static String strUtf = 'UTF-8';
   @TestVisible static String strHeaderTemp = 'Header';
   @TestVisible static String strGtesTemp = 'GTES';
   @TestVisible static String strSubmTemp = 'SUBM';
   @TestVisible static String strAppTemp = 'APP';
   @TestVisible static String strRejcTemp =  'REJC';
   @TestVisible static String strAribaTemp = 'Ariba'; 
   @TestVisible static String strRoleTemp = 'EMP';
   @TestVisible static String strStatusTemp = 'Submitted';
   
   @testSetup static void setup() {
        List<CORE_Chatter_Approval__c> lstCustSet = new List<CORE_Chatter_Approval__c>();
        profile p=[select id from profile where name=:strSystemAdministrator]; 
        System.assert(p != null);
       
        User obj_user1 = new User(username='Core_CA_customSettingUser@admintest.com',IsActive=true,Alias='user1',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_customSettingUser@admintest.com',FederationIdentifier='feed13', FirstName=strHeaderTemp,
                                 LastName='user1',emailencodingkey=strUtf,languagelocalekey='en_US',localesidkey='bg_BG');
        insert obj_user1;
        
        lstCustSet.add( new CORE_Chatter_Approval__c( Name='PaginationLimit', Text_Value__c='20'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='OpenApprovalMsg', Text_Value__c='There are no Open Approvals'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='ClosedApprovalMsg', Text_Value__c='There are no Closed Approvals'));
        
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='OpenRequestMsg', Text_Value__c='There are no Open Requests'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='ClosedRequestMsg', Text_Value__c='There are no Closed Requests'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='OpenRequest', Text_Value__c='Submitted,Withdrawn,Denied'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='ClosedRequest', Text_Value__c='Fully Approved'));
        
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='GTES_Notification', Text_Value__c='Yes'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='GTES-ApproverAdded', Text_Value__c='Dear XXX, Travel & Expense claim YYY requires your immediate Approval (Requested By ZZZ)'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='Ariba_Notification', Text_Value__c='Yes'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='Ariba-ApproverAdded1', Text_Value__c='Dear XXX, Purchase requisition YYY requires your immediate Approval (Requester & Preparer: ZZZ)'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='Ariba-ApproverAdded2', Text_Value__c='Dear XXX, Purchase requisition YYY requires your immediate Approval (Requester: ZZZ, Preparer: AAA)'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='Clarity_Notification', Text_Value__c='Yes'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='Clarity_ApproverAdded', Text_Value__c='Dear XXX, Project Approval YYY requires your immediate Approval'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='Invoice_Notification', Text_Value__c='Yes'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='Invoice_ApproverAdded', Text_Value__c='Dear XXX, Invoice YYY from ZZZ requires your approval'));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='Invoice', Text_Value__c='',ReminderAlertDays__c=0));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='Ariba', Text_Value__c= obj_user1.Id,ReminderAlertDays__c=0));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='GTES', Text_Value__c= obj_user1.Id,ReminderAlertDays__c=0));
        lstCustSet.add( new CORE_Chatter_Approval__c(Name='Clarity', Text_Value__c= obj_user1.Id,ReminderAlertDays__c=0));
        
        if(!lstCustSet.isEmpty())
           insert lstCustSet;     
    }
   
   //Test method to cover both Header handler and Interested Party trigger and handler.
   @isTest 
   static void testMethodForHeaderAndApproverHandlerGTES1(){   
       
       
       //Test User
       profile p=[select id from profile where name=:strSystemAdministrator]; 
       System.assert(p != null);
       
       User obj_user1 = new User (username='Core_CA_testHeaderUser1@admintest.com',IsActive=true,Alias='user1',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser1@admintest.com',FederationIdentifier='feed1', FirstName=strHeaderTemp,
                                 LastName='user1',emailencodingkey=strUtf,languagelocalekey='en_US',localesidkey='bg_BG');
       insert obj_user1;
       
       User obj_user2 = new User (username='Core_CA_testHeaderUser2@admintest.com',IsActive=true,Alias='user2',timezonesidkey='America/Panama' ,
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser2@admintest.com',FederationIdentifier='feed2', FirstName=strHeaderTemp,
                                 LastName='user2',emailencodingkey=strUtf,languagelocalekey='ko',localesidkey='my_MM');
       insert obj_user2;
       
       user obj_user3 = new User (username='Core_CA_testHeaderUser3@admintest.com',IsActive=true,Alias='user3',timezonesidkey='America/Caracas' ,
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser3@admintest.com',FederationIdentifier='feed3', FirstName=strHeaderTemp,
                                 LastName='user3',emailencodingkey=strUtf,languagelocalekey='ru',localesidkey='bs_BA');
       insert obj_user3;
          
       //Test data for Header object(insert).
       Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader1', Source_System__c = strGtesTemp, Status__c= 'Approver Added',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0,Fully_Approved__c=false);
       insert objHeader;
       System.assert(objHeader != null);
       
       
       //Test Data for Interested party object(insert).
       Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = obj_user3.Id ,Source_System__c = strGtesTemp,Approval_Header__c =  objHeader.Id,
                                               Role__c = strRoleTemp,Action__c = strSubmTemp);
       insert objApprover;
       System.assert(objApprover != null);
       
       Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=objHeader.Id,Source_System__c = strGtesTemp);
       insert lineObj;
       System.assert(lineObj!= null);
       
       //Test data for Header Object(Update).
        objHeader.Ledger_Extract__c= Datetime.now();
        Update objHeader;
       
       //Test Data for Interested party object(Update).       
       objApprover.Interested_Party__c =obj_user1.Id;
       Update objApprover;
       Test.starttest();
       //Expense Claim Submitted(Action 'SUBM' and Role 'EMP')
       Core_Approver_Details__c  objApprover1 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = strGtesTemp,     
                                                Role__c = strRoleTemp,Action__c = strSubmTemp,Approval_Header__c =  objHeader.Id);
       insert objApprover1;
       
       //Expense Claim Submitted with(Action 'SUBM' and Role 'SUB')
       Core_Approver_Details__c  objApprover2 = new Core_Approver_Details__c (Interested_Party__c = obj_user3.Id,Source_System__c = strGtesTemp,     
                                                Role__c = 'SUB',Action__c = strSubmTemp,Approval_Header__c =  objHeader.Id);
       insert objApprover2;
       
       //Expense Claim Submitted with(Action 'SUBM' and Role 'SUB')
       Core_Approver_Details__c  objApprover3 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = strGtesTemp,     
                                                Role__c = 'SUB',Action__c = strSubmTemp,Approval_Header__c =  objHeader.Id);
       insert objApprover3;
       
       
       
       //delete objApprover6;
       
       
       Test.stoptest();
       
   }  
   
   @isTest 
   static void testMethodForHeaderAndApproverHandlerGTES2(){
        
       //Test User
       profile p=[select id from profile where name=:strSystemAdministrator]; 
       User obj_user1 = new User (username='Core_CA_testHeaderUser11@admintest.com',IsActive=true,Alias='user4',timezonesidkey='America/Tijuana' ,
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser11@admintest.com',FederationIdentifier='feed4', FirstName=strHeaderTemp,
                                 LastName='user4',emailencodingkey=strUtf,languagelocalekey='nl_NL',localesidkey='ca_ES');
       insert obj_user1;
       
       User obj_user2 = new User (username='Core_CA_testHeaderUser21@admintest.com',IsActive=true,Alias='user5',timezonesidkey='Pacific/Pitcairn' ,
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser21@admintest.com',FederationIdentifier='feed5', FirstName=strHeaderTemp,
                                 LastName='user5',emailencodingkey=strUtf,languagelocalekey='ar',localesidkey='zh_CN');
       insert obj_user2;
       
       //Test data for Header object(insert).
       Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader2', Source_System__c = strGtesTemp, Status__c= 'Approver Added',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0,Fully_Approved__c=false);
       insert objHeader;
       System.assert(objHeader != null);
       
       Core_Approval_Header__c objHeader1 = new Core_Approval_Header__c( Name = 'testHeader3', Source_System__c = strGtesTemp, Status__c= 'Approver Added',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0,Fully_Approved__c=true);
       insert objHeader1;
       System.assert(objHeader1 != null);
       Test.starttest();
       //Approver Added with (Role__c 'APP')
       Core_Approver_Details__c  objApprover4 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = strGtesTemp,     
                                                Role__c = strAppTemp,Action__c = 'ACTV',Approval_Header__c =  objHeader.Id);
       insert objApprover4;
       
       //Fully Approved with (Action 'CANC' and Role 'EMP')
       Core_Approver_Details__c  objApprover5 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = strGtesTemp,     
                                                Role__c = strRoleTemp,Action__c = 'CANC',Approval_Header__c =  objHeader.Id);
       insert objApprover5;
       
       //Rejected with (Action strRejcTemp and Role 'APP')
       Core_Approver_Details__c  objApprover6 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c = strGtesTemp,     
                                                Role__c = strAppTemp,Action__c = strRejcTemp,Approval_Header__c =  objHeader.Id);
       insert objApprover6;
       
       //Fully Approved ( Role 'SYS' and Action 'APPR' )
       /*objApprover3.Action__c='APPR';
       objApprover3.Role__c='SYS';
       update objApprover3;*/
       
       objApprover6.Interested_Party__c=obj_user2.Id;
       objApprover6.Action__c='ACTV';
       update objApprover6;
            
       objApprover5.Role__c='EMP';
       objApprover5.Action__c=strSubmTemp;
       update objApprover5;
       
       //Rejected (Role 'APP' and Action strRejcTemp )
       objApprover4.Action__c=strRejcTemp;
       objApprover4.Role__c= strAppTemp;
       update objApprover4;
       
       
       objHeader.Fully_Approved__c=true;
       update objHeader;
       
       Test.stoptest();
   }
   
  @isTest 
  static void testMethodForHeaderAndApproverHandlerAriba1(){
              
       //Test User
       profile p=[select id from profile where name=:strSystemAdministrator]; 
       User obj_user1 = new User (username='Core_CA_testHeaderUser13@admintest.com',IsActive=true,Alias='user6',timezonesidkey='America/Anchorage' ,
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser13@admintest.com',FederationIdentifier='feed6', FirstName=strHeaderTemp,
                                 LastName='user6',emailencodingkey=strUtf,languagelocalekey='hu',localesidkey='zh_SG');
       insert obj_user1;
       
       User obj_user2 = new User (username='Core_CA_testHeaderUser23@admintest.com',IsActive=true,Alias='user7',timezonesidkey='Pacific/Marquesas' ,
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser23@admintest.com',FederationIdentifier='feed7', FirstName=strHeaderTemp,
                                 LastName='user7',emailencodingkey=strUtf,languagelocalekey='no',localesidkey='hr_HR');
       insert obj_user2;
       
          
       //Test data for Header object(insert).
       
       //Submitted notification when Requested For == Requested by(after insert)
       Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader4', Source_System__c =  strAribaTemp,Manager__c = obj_user1.Id ,Status__c= strStatusTemp,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0,Invalid_PR__c = false ,Invalid_PR_Reason__c = 'Invalid' );
       insert objHeader;
       System.assert(objHeader != null);
       //Submitted notification when Requested For == Requested by(after update)
       objHeader.Status__c='Withdrawn';
       update objHeader;
       objHeader.Status__c=strStatusTemp;
       
       
       //Inserting line detail
       Core_Approval_Details__c lineObj=new Core_Approval_Details__c(name='Line Details',Approval_Header__c=objHeader.Id,Source_System__c =  strAribaTemp);
       insert lineObj;
       System.assert(lineObj!= null);
       
       //Submitted notification when Requested For <> Requested by(after insert)
       Core_Approval_Header__c objHeader1 = new Core_Approval_Header__c( Name = 'testHeader5', Source_System__c =  strAribaTemp, Status__c= strStatusTemp,Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user2.Id, Reminder_Alert_Days__c=0);
       insert objHeader1;
       System.assert(objHeader1 != null);
       //Submitted notification when Requested For <> Requested by(after update)
       objHeader1.Status__c='Withdrawn';
       update objHeader1;
       objHeader1.Status__c=strStatusTemp;
       update objHeader1;
       
       Test.starttest();
       Core_Approver_Details__c  objApproveResub1 = new Core_Approver_Details__c (Role__c = strAppTemp,Is_Active__c=true,Interested_Party__c = obj_user1.Id ,Source_System__c =  strAribaTemp,Approval_Header__c =  objHeader.Id,Action__c=strRejcTemp);
       insert objApproveResub1;
       System.assert(objApproveResub1 != null);
       //Denied to resubmit
       objApproveResub1.Action__c='';
       update objApproveResub1;
       
       Core_Approver_Details__c  objApproverResub2 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id ,Source_System__c =  strAribaTemp,Approval_Header__c =  objHeader1.Id,Action__c=strRejcTemp);
       insert objApproverResub2;
       System.assert(objApproverResub2 != null);
       //Denied to resubmit
       objApproverResub2.Action__c='';
       update objApproverResub2;
       
       //Approver added notification(after insert)
       Core_Approver_Details__c  objApprover1 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c =  strAribaTemp,     
                                                Role__c = strAppTemp,Is_Active__c=true,Approval_Header__c =  objHeader1.Id);
       insert objApprover1;
       
       //Approver deleted notification
       delete objApprover1;
       
       //Approver approved notifiaction(after insert)
       Core_Approver_Details__c  objApprover2 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c =  strAribaTemp,     
                                                Role__c = strAppTemp,Is_Active__c=true,Action__c='APPR',Approval_Header__c =  objHeader1.Id);
       insert objApprover2;
       
       objHeader.Invalid_PR__c = true; 
       update objHeader;

       objHeader.Invalid_PR__c = false; 
       update objHeader;
       
       objHeader.Invalid_PR__c = true;
       objHeader.Invalid_PR_Reason__c ='';     
       update objHeader;
       Test.stoptest();
   }
   
   @isTest 
   static void testMethodForHeaderAndApproverHandlerAriba2(){
       
        //Test User
       profile p=[select id from profile where name=:strSystemAdministrator]; 
       User obj_user1 = new User (username='Core_CA_testHeaderUser14@admintest.com',IsActive=true,Alias='user8',timezonesidkey='Australia/Lord_Howe' ,
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser14@admintest.com',FederationIdentifier='feed8', FirstName=strHeaderTemp,
                                 LastName='user8',emailencodingkey=strUtf,languagelocalekey='vi',localesidkey='da_DK');
       insert obj_user1;
       
       User obj_user2 = new User (username='Core_CA_testHeaderUser24@admintest.com',IsActive=true,Alias='user9',timezonesidkey='Pacific/Kiritimati' ,
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser24@admintest.com',FederationIdentifier='feed9', FirstName=strHeaderTemp,
                                 LastName='user9',emailencodingkey=strUtf,languagelocalekey='uk',localesidkey='nl_BE');
       insert obj_user2;
       
       //Header with Requested For == Requested by.
       Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader6', Source_System__c =  strAribaTemp,Manager__c = obj_user1.Id ,Status__c='Fully Approved',
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0);
       insert objHeader;
       System.assert(objHeader != null);
       Test.starttest();
       //Header with Requested For <> Requested by.
       Core_Approval_Header__c objHeader1 = new Core_Approval_Header__c( Name = 'testHeader7', Source_System__c =  strAribaTemp, Status__c= strStatusTemp,Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user2.Id, Reminder_Alert_Days__c=0);
       insert objHeader1;
       System.assert(objHeader1 != null);
       
       //Header with Requested For <> Requested by.
       Core_Approval_Header__c objHeader2 = new Core_Approval_Header__c( Name = 'testHeader8', Source_System__c =  strAribaTemp,Manager__c = obj_user1.Id ,Status__c=strStatusTemp,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user2.Id, Reminder_Alert_Days__c=0);
       insert objHeader2;
       System.assert(objHeader2 != null);
       
       //Interested party test data
       Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id ,Source_System__c =  strAribaTemp,Approval_Header__c =  objHeader1.Id,Is_Active__c=false,Role__c=strAppTemp);
       insert objApprover;
       System.assert(objApprover != null);
       
       objHeader.Status__c=strStatusTemp;
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
       Core_Approval_Header__c objHeader3 = new Core_Approval_Header__c( Name = 'testHeader9', Source_System__c =  strAribaTemp, Status__c= 'Denied',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user2.Id, Reminder_Alert_Days__c=0);
       insert objHeader3;
       
       //Approver denied notification
       Core_Approver_Details__c  objApprover3 = new Core_Approver_Details__c (Interested_Party__c = obj_user1.Id,Source_System__c =  strAribaTemp,    
                                                Role__c = strAppTemp,Is_Active__c=true,Action__c=strRejcTemp,Approval_Header__c =  objHeader3.Id);
       insert objApprover3;
       
       //Denied to resubmit
       objHeader3.Status__c=strStatusTemp;
       update objHeader3;
       objApprover3.Action__c='';
       update objApprover3;
       
       objHeader3.Status__c='Denied';
       update objHeader3;
       objApprover3.Action__c=strRejcTemp;
       update objApprover3;
       
       Test.stoptest();
   }
   
      
   //Test method to cover both Request and Approval details
   @isTest 
   static void testMethodForRequestAndApprovalDetails(){ 
       //Test User
       profile p=[select id from profile where name=:strSystemAdministrator];
       User obj_user1 = new User (username='Core_CA_testHeaderUser41@admintest.com',IsActive=true,Alias='user10',timezonesidkey='Pacific/Tongatapu' ,
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser41@admintest.com',FederationIdentifier='feed10', FirstName=strHeaderTemp,
                                 LastName='user10',emailencodingkey=strUtf,languagelocalekey='en_GB',localesidkey='en_AG');
       insert obj_user1;
       
       User obj_user2 = new User (username='Core_CA_testHeaderUser51@admintest.com',IsActive=true,Alias='user11',timezonesidkey='Asia/Kamchatka' ,
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser51@admintest.com',FederationIdentifier='feed11', FirstName=strHeaderTemp,
                                 LastName='user11',emailencodingkey=strUtf,languagelocalekey='es_MX',localesidkey='en_BS');
       insert obj_user2;
       
       user obj_user3 = new User (username='Core_CA_testHeaderUser61@admintest.com',IsActive=true,Alias='user12',timezonesidkey='Asia/Seoul' ,
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser61@admintest.com',FederationIdentifier='feed12', FirstName=strHeaderTemp,
                                 LastName='user12',emailencodingkey=strUtf,languagelocalekey='pt_BR',localesidkey='en_BM');
       insert obj_user3;
        
       //Test data for Header object(insert).
       Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader', Source_System__c = strGtesTemp, Status__c= 'Approver Added',Manager__c = obj_user1.Id ,
                                           Requested_By__c= obj_user1.Id,Requested_For__c = obj_user1.Id, Reminder_Alert_Days__c=0);
       insert objHeader;
       System.assert(objHeader != null);
       

       //Test Data for Interested party object(insert).
       Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = obj_user3.Id ,Source_System__c = strGtesTemp,Approval_Header__c =  objHeader.Id,
                                               Role__c = strRoleTemp,Action__c = strSubmTemp);
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