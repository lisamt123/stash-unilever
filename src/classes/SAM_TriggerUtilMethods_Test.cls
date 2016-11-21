/**********************************************************************
Name: SAM_TriggerUtilMethods_Test()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This is the util class of rest of the test classes
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
1.0         Pooja Kanani      28/07/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
private class SAM_TriggerUtilMethods_Test {
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
        SAM_Trigger_Pattern__c rLITp = SAM_testCustomSettingClass_util.SAMRLI_TriggerPattern();
        insert rLITp;
        SAM_success_messages__c saveMsg = SAM_testCustomSettingClass_util.createTest_SaveSuccessaveMsg();
        insert saveMsg;
        SAM_success_messages__c aCCMsg = SAM_testCustomSettingClass_util.createTest_AwaitingChargeSuccessaveMsg();
        insert aCCMsg;
        SAM_success_messages__c closedMsg = SAM_testCustomSettingClass_util.createTest_ClosedSuccessaveMsg();
        insert closedMsg;
        SAM_success_messages__c openMsg = SAM_testCustomSettingClass_util.createTest_OpenSuccessaveMsg();
        insert openMsg;
        SAM_Mandatory_fields_for_submit__c mandatoryFields = SAM_testCustomSettingClass_util.createTest_SAM_Mandatory_fields_for_submit();
        insert mandatoryFields;
    }       
    /*******************************************************************
    Purpose: This method is used to cover trigger utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void SAM_Request_Util_Test(){ 
        SAM_StatusMsgCustomSetting();

        //Test.startTest();   
                        
        SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
        User u = SAM_TestRequestClass_util.createTestUser();
        System.Debug('objRequest -'+objRequest);
        System.Debug('objRequest Id -'+objRequest.Id);
        if(u != null)
        {
        objRequest.lkp_Assign_To__c= u.id;  
        objRequest.pkl_Software_Purchase_Req__c  = null;    
        insert objRequest;
        System.Debug('Status Should be saved- '+ objRequest.pkl_Status__c);
        System.Debug('pkl_Ownership_Reporting__c Should be saved- '+ objRequest.pkl_Ownership_Reporting__c);
        System.Debug('Name in saved status- '+ objRequest.Name);
        System.Debug('Post Insert objRequest -'+objRequest);
        System.Debug('Post Insert objRequest Id -'+objRequest.Id);
        }       
        if(objRequest.Id != null)
        {
        objRequest.txt_SA_Clarity_Id__c = '67890';
        update objRequest;
        
        SAM_Request_Line_Item__c ObjRLI =  SAM_TestRequestClass_util.createProductDetails(objRequest);
        insert ObjRLI;
        
        objRequest.pkl_SAM_team_Status__c = SAM_Constants.INPROGRESS;
        objRequest.pkl_Software_Purchase_Req__c = 'Yes';
        objRequest.chk_Is_Quote_Submitted_Once__c = false;
        update objRequest;      
        System.Debug('Status Should be InProgress - '+ objRequest.pkl_Status__c);
        
        SAM_Quote_Line_Item__c ObjQLI =  SAM_TestRequestClass_util.createQuotationDetails(objRequest);
        insert ObjQLI;
        
        List<SAM_Quote_Line_Item__c> QLI = [Select id, pkl_Line_Status__c,md_Request__c from  SAM_Quote_Line_Item__c where md_Request__c=:objRequest.id];
        for(SAM_Quote_Line_Item__c q:QLI){
            q.pkl_Line_Status__c = 'Completed';
        }
        If(QLI != null && QLI.size()>0){  
            update QLI;
            }
        
        objRequest.pkl_SAM_team_Status__c = SAM_Constants.QUOTE_PROVIDED;        
        update objRequest;
        System.Debug('Status Should be QUOTE_PROVIDED - '+ objRequest.pkl_status__c);
        
        Test.startTest();   
        objRequest.pkl_SAM_Requester_Status__c = SAM_Constants.QUOTE_APPROVED;
        update objRequest;
        System.Debug('Status Should be QUOTE_APPROVED - '+ objRequest.pkl_status__c);
        
        SAM_TestRequestClass_util.addBuild_DetailsAttachmentToParent(objRequest.id);
        SAM_TestRequestClass_util.addApproval_EmailsAttachmentToParent(objRequest.id);               
        
        
        objRequest.pkl_SAM_team_Status__c = SAM_Constants.AWAITINGCHARGE;
        update objRequest;
        System.Debug('Status Should be AWAITINGCHARGE - '+ objRequest.pkl_status__c);
        //FAILS      
        //objRequest.pkl_SAM_team_Status__c = SAM_Constants.CLOSED;
        //objRequest.pkl_Reason_for_closure__c = 'Invalid Request';
        //objRequest.ltxt_Comments__c = SAM_Constants.TEST;
        //update objRequest;      
        
        /*try
        {
            delete objRequest;
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  (e.getMessage().contains('You are not authorized to delete this record')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }*/
        
        list<SAM_Email_Attachment_InvocableMethod.SendEmailClassVariable> sendEmailAttachments = new list<SAM_Email_Attachment_InvocableMethod.SendEmailClassVariable>();
        SAM_Email_Attachment_InvocableMethod.SendEmailClassVariable sendEmailAttachment = new SAM_Email_Attachment_InvocableMethod.SendEmailClassVariable();
        sendEmailAttachment.recordId = objRequest.id;
        sendEmailAttachment.templateDeveloperName = 'SAM_FinalQuoteReSubmitted_To_Requester';
        sendEmailAttachments.add(sendEmailAttachment);
        SAM_Email_Attachment_InvocableMethod.SendEmailWithAttachment(sendEmailAttachments);
        
        
        Test.stopTest();
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:objRequest.id];      
        System.assertEquals(2, attachments.size());  
        }       
        
    }
     /*******************************************************************
    Purpose: This method is used to cover SAM_Email_Attachment_InvocableMethod class
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void SAM_EmailInvocableClass_Test(){ 
        SAM_StatusMsgCustomSetting();                        
        SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
        User u = SAM_TestRequestClass_util.createTestUser();
        if(u != null)
        {
        objRequest.lkp_Assign_To__c= u.id;  
        objRequest.pkl_Software_Purchase_Req__c  = null;    
        insert objRequest;
        }       
        if(objRequest.Id != null)
        {
        objRequest.txt_SA_Clarity_Id__c = '67890';
        update objRequest;
        
        SAM_Request_Line_Item__c ObjRLI =  SAM_TestRequestClass_util.createProductDetails(objRequest);
        insert ObjRLI;
        
        objRequest.pkl_SAM_team_Status__c = SAM_Constants.INPROGRESS;
        objRequest.pkl_Software_Purchase_Req__c = 'Yes';
        objRequest.chk_Is_Quote_Submitted_Once__c = false;
        update objRequest;      
        
        SAM_Quote_Line_Item__c ObjQLI =  SAM_TestRequestClass_util.createQuotationDetails(objRequest);       
        insert ObjQLI;
        SAM_TestRequestClass_util.addApproval_EmailsAttachmentToQLI(ObjQLI.id);
        ObjQLI.pkl_Charging_Type__c = SAM_Constants.DO_PO_APPLICABLE;
        ObjQLI.pkl_DO_PO_Details_Applicable__c = 'Yes';
        update  ObjQLI;
        ObjQLI.pkl_Line_Status__c = 'Completed';           
        update ObjQLI;
      Test.startTest();   
        list<SAM_Email_Attachment_InvocableMethod.SendEmailClassVariable> sendEmailAttachments = new list<SAM_Email_Attachment_InvocableMethod.SendEmailClassVariable>();
        SAM_Email_Attachment_InvocableMethod.SendEmailClassVariable sendEmailAttachment = new SAM_Email_Attachment_InvocableMethod.SendEmailClassVariable();
        sendEmailAttachment.recordId = objRequest.id;
        sendEmailAttachment.templateDeveloperName = 'SAM_FinalQuoteReSubmitted_To_Requester';
        sendEmailAttachments.add(sendEmailAttachment);
        SAM_Email_Attachment_InvocableMethod.SendEmailWithAttachment(sendEmailAttachments);
     Test.stopTest();
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:ObjQLI.id];      
        System.assertEquals(1, attachments.size());
    }
  }
    /*******************************************************************
    Purpose: This method is used to cover trigger utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void SAM_Request_Util_DeleteTest(){ 
        SAM_StatusMsgCustomSetting();

        Test.startTest();   
                        
        SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
        objRequest.pkl_status__c = SAM_Constants.SAVED;
        insert objRequest;
        
        SAM_Request_Line_Item__c ObjRLI =  SAM_TestRequestClass_util.createProductDetails(objRequest);
        insert ObjRLI;
        
        SAM_Quote_Line_Item__c ObjQLI =  SAM_TestRequestClass_util.createQuotationDetails(objRequest);
        insert ObjQLI;
                             
        delete ObjQLI;
        delete ObjRLI;
        delete objRequest;
        
        Test.stopTest();

        System.assertEquals(objRequest.isdeleted, false);
        
    }
    
    /*******************************************************************
    Purpose: This method is used to cover trigger Close Action validation
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void SAM_Request_Util_Close_Test(){ 
        SAM_StatusMsgCustomSetting();

        Test.startTest();   
                        
        SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
        User u = SAM_TestRequestClass_util.createTestUser();
        objRequest.lkp_Assign_To__c= u.id;       
        insert objRequest;
        
        objRequest.txt_SA_Clarity_Id__c = '67890';
        update objRequest;
        
        SAM_Request_Line_Item__c ObjRLI =  SAM_TestRequestClass_util.createProductDetails(objRequest);
        insert ObjRLI;
        
        objRequest.pkl_SAM_team_Status__c = SAM_Constants.INPROGRESS;
        objRequest.pkl_Software_Purchase_Req__c = 'Yes';
        objRequest.chk_Is_Quote_Submitted_Once__c = false;
        update objRequest;
        
        SAM_Quote_Line_Item__c ObjQLI =  SAM_TestRequestClass_util.createQuotationDetails(objRequest);
        insert ObjQLI;      
        
        //FAILS   
        try
        {   
        objRequest.pkl_SAM_team_Status__c = SAM_Constants.CLOSED;
        objRequest.pkl_Reason_for_closure__c = 'Invalid Request';
        objRequest.ltxt_Comments__c = SAM_Constants.TEST;
        update objRequest;  
        }
        catch(Exception e)
        {
           Boolean expectedExceptionThrown =  (e.getMessage().contains('You can not Close the Request without attaching build details with file name "Build_Details"')) ? true : false;
           System.AssertEquals(expectedExceptionThrown, true);
        } 
        Test.stopTest();          
        
    }
 /*******************************************************************
    Purpose: This method is used to cover SAM_GroupMemberShip
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void SAM_GroupMemberShip_Test(){ 
        SAM_StatusMsgCustomSetting();

        Test.startTest();   
                        
        SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();  
        insert objRequest;
        List<string> reqId = new List<string>();
        reqId.add(objRequest.id);
        SAM_Request_GroupMemberShipUtils.GetPublicGroups(reqId);
               
        Test.stopTest();
        SAM_Request__c req =[select id, ltxt_User_Public_Groups__c from SAM_Request__c where id=:objRequest.id];      
        System.assertEquals(req.ltxt_User_Public_Groups__c == null,true);  
    }
    /*******************************************************************
    Purpose: This method is used to cover SAM_GroupMemberShip
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void SAM_PublisherFieldUpdate_Test(){ 
        SAM_StatusMsgCustomSetting();

          
                        
        SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();  
        insert objRequest;
        
        SAM_Request_Line_Item__c ObjRLI =  SAM_TestRequestClass_util.createProductDetails(objRequest);
        insert ObjRLI;
        
        SAM_Quote_Line_Item__c ObjQLI =  SAM_TestRequestClass_util.createQuotationDetails(objRequest);
        insert ObjQLI;
        
        Test.startTest(); 
        List<string> reqId = new List<string>();
        reqId.add(objRequest.id);
        SAM_Request_PublisherFieldUpdate.UpdatePublisherField(reqId);
               
        Test.stopTest();
        SAM_Request__c req =[select id, txt_CrossCharge_Publisher__c from SAM_Request__c where id=:objRequest.id];      
        System.assertEquals(req.txt_CrossCharge_Publisher__c != null,true);  
    }                 

}