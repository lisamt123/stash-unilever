/**********************************************************************
Name: SAM_RequestAgeing_Test ()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This is the test class for age calulation

-------
======================================================
======================================================
History
-------
VERSION     AUTHOR               DATE            DETAIL Description
1.0         Mindtree          04/08/2016        INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
public  class SAM_RequestAgeing_Test {

 /*******************************************************************
    Purpose: This method is used to cover custom settings
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static  void SAM_StatusMsgCustomSetting(){
        SAM_Trigger_Pattern__c ReqTP = SAM_testCustomSettingClass_util.SAMRequest_TriggerPattern();
        insert ReqTP;
        SAM_Trigger_Pattern__c qLITp = SAM_testCustomSettingClass_util.SAMQLI_TriggerPattern();
        insert qLITp;
        SAM_success_messages__c saveMsg = SAM_testCustomSettingClass_util.createTest_SaveSuccessaveMsg();
        insert saveMsg;
        
        SAM_Mandatory_fields_for_submit__c mandatoryFields = SAM_testCustomSettingClass_util.createTest_SAM_Mandatory_fields_for_submit();
        insert mandatoryFields;
        
        SAM_Mandatory_fields_for_submit__c mandatoryFields1 = SAM_testCustomSettingClass_util.createTest_SAM_controlling_fields_for_submit();
        insert mandatoryFields1;
    }  
    /*******************************************************************
    Purpose: This method is used insert user
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static  User SAM_User(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Unilever - Force MultiApp Standard'];       
        User u1 = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@unilever.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo1@unilever.org');
        return u1;
    }
    /*******************************************************************
    Purpose: This method covers SAM_RequestAgeing
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testMethod void testAgingForProject(){
    SAM_StatusMsgCustomSetting();
     
    SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
    
    objRequest.txt_Request_Type__c = SAM_Constants.SAM_RW_PROJECT_REQUEST;
    objRequest.pkl_Status__c='In Progress';
    objRequest.Ticket_Age__c=0;
    //objRequest.rus_Pending_with_Project__c=0;
    //objRequest.rus_Pending_with_SAM_records__c=0;
    objRequest.date_Query_End_Date__c=Date.newInstance( 2016, 7, 7 );
    objRequest.date_Query_Start_Date__c=Date.newInstance( 2016, 6, 6 );
    
    insert objRequest;
    List<SAM_Request__c> reqList=new List<SAM_Request__c>();
    reqList.add(objRequest);
    
     
           SAM_RequestAgeing.RequestAgeUpdateScheduler(reqList);
      
      SAM_Request__c objRequestValue = [select id,pkl_Status__c from SAM_Request__c where id =: objRequest.id];
      System.assert(objRequestValue.pkl_Status__c == SAM_Constants.INPROGRESS);   
    
    }
    
    static testMethod void testAgingForCrossChargeSAMTeam(){
    SAM_StatusMsgCustomSetting();
   RecordType rt =[select id,Name from RecordType where sObjectType='SAM_Request__c' AND Name='Query' limit 1] ;
    SAM_Request__c objRequest = new SAM_Request__c();
    objRequest.recordtypeid  = rt.Id ;
    objRequest.txt_Request_Type__c = SAM_Constants.SAM_RW_QUERY_REQUEST ;
    objRequest.pkl_Status__c='In Progress';
    objRequest.Ticket_Age__c=0;
    objRequest.date_Query_End_Date__c=Date.newInstance( 2016, 7, 7 );
    objRequest.date_Query_Start_Date__c=Date.newInstance( 2016, 6, 6 );
    objRequest.ltxt_Query_Detailed_Notes__c = SAM_Constants.TEST;    
    insert objRequest;
    List<SAM_Request__c> reqList=new List<SAM_Request__c>();
    reqList.add(objRequest);
     
           SAM_RequestAgeing.RequestAgeUpdateScheduler(reqList);
           
     SAM_Request__c objRequestValue = [select id,pkl_Status__c from SAM_Request__c where id =: objRequest.id];
      System.assert(objRequestValue.pkl_Status__c == SAM_Constants.INPROGRESS);     
    
    }
    
    static testMethod void testAgingForCrossChargeRequestor(){
    SAM_StatusMsgCustomSetting();
       
          
   RecordType rt =[select id,Name from RecordType where sObjectType='SAM_Request__c' AND Name='Query' limit 1] ;
  
    SAM_Request__c objRequest = new SAM_Request__c();
    objRequest.recordtypeid  = rt.Id ;
    objRequest.txt_Request_Type__c = SAM_Constants.SAM_RW_QUERY_REQUEST ;
    objRequest.pkl_Status__c='In Progress';
    objRequest.Ticket_Age__c=0;
    objRequest.date_Query_End_Date__c=Date.newInstance( 2016, 7, 7 );
    objRequest.date_Query_Start_Date__c=Date.newInstance( 2016, 6, 6 );
    objRequest.ltxt_Query_Detailed_Notes__c = SAM_Constants.TEST;
    insert objRequest;
    objRequest = [select Id, CreatedById,recordtypeid,txt_Request_Type__c,pkl_Status__c,Ticket_Age__c,date_Query_End_Date__c,date_Query_Start_Date__c  from SAM_Request__c where Id =: objRequest.Id limit 1];
    List<SAM_Request__c> reqList=new List<SAM_Request__c>();
    reqList.add(objRequest);
    
     
           SAM_RequestAgeing.RequestAgeUpdateScheduler(reqList);
           
     SAM_Request__c objRequestValue = [select id,pkl_Status__c from SAM_Request__c where id =: objRequest.id];
     System.assert(objRequestValue.pkl_Status__c != SAM_Constants.OPEN);    
    
    }
   /*******************************************************************
    Purpose: This method covers SAM_RequestAgeing
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testMethod void testAgingForProject2(){
     User u1 = SAM_User();
     insert u1;
     PermissionSet requestorPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Requestor' limit 1];
     PermissionSetAssignment opsa = new PermissionSetAssignment();
     opsa.AssigneeId = u1.id;
     opsa.PermissionSetId = requestorPermissionSet.id;
     insert opsa;
     System.runAs(u1){
        SAM_StatusMsgCustomSetting();
     
        RecordType rt =[select id,Name from RecordType where sObjectType='SAM_Request__c' AND Name='Query' limit 1] ;
  
    SAM_Request__c objRequest = new SAM_Request__c();
    objRequest.recordtypeid  = rt.Id ;
    objRequest.txt_Request_Type__c = SAM_Constants.SAM_RW_QUERY_REQUEST ;   
    objRequest.Ticket_Age__c=0;
    objRequest.date_Query_End_Date__c=Date.newInstance( 2016, 7, 7 );
    objRequest.date_Query_Start_Date__c=Date.newInstance( 2016, 6, 6 );
    objRequest.ltxt_Query_Detailed_Notes__c = SAM_Constants.TEST;
    insert objRequest;
    objRequest.pkl_Status__c='In Progress';
    update objRequest;
    objRequest = [select Id, CreatedById,recordtypeid,txt_Request_Type__c,pkl_Status__c,Ticket_Age__c,date_Query_End_Date__c,date_Query_Start_Date__c  from SAM_Request__c where Id =: objRequest.Id limit 1];
    List<SAM_Request__c> reqList=new List<SAM_Request__c>();
    reqList.add(objRequest); 
        SAM_RequestAgeing.RequestAgeUpdateScheduler(reqList);
        SAM_Request__c objRequestValue = [select id,pkl_Status__c from SAM_Request__c where id =: objRequest.id];
         system.debug('objRequestValue.pkl_Status__c>'+objRequestValue.pkl_Status__c);
        System.assert(objRequestValue.pkl_Status__c == SAM_Constants.INPROGRESS);
      }
    }
   }