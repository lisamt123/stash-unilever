/**********************************************************************
Name:  cec_TestEmailMessageHelper
Copyright � 2014  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for the Helper class for cec_TestEmailMessageHelper
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
1.0 -   Aalok           21/10/2014      INITIAL DEVELOPMENT  CSR
1.1     Sathish         Mar-2016        Code Refacctoring   Included CEC_TestDataFactory.
***********************************************************************/

/**
Test class for the Helper class for Trigger for cec_EmailMessageHelper
*/

@isTest(SeeAllData=false)
public class cec_TestEmailMessageHelper{
    
    @testSetup static void setUpTestData() {
        
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            cec_Org_Settings__c custsett = new cec_Org_Settings__c(Alert_Retention_Days__c = 180);
            insert custsett;
            
            List<mdm_Product_Category__c> prodCategoryList = 
                CEC_TestDataFactory.createProductCategory(1);
            insert prodCategoryList;
            
            List<mdm_Case_Product__c> caseProductList = 
                CEC_TestDataFactory.createCaseProduct(1, prodCategoryList.get(0).Id);
            insert caseProductList;
            
            List<mdm_Global_Listening_Tree__c> globalListeningTreeList = 
                CEC_TestDataFactory.createGlobalListeningTree(1);
            insert globalListeningTreeList;
            
            List<mdm_Reason_Code__c> reasonCodeList = 
                CEC_TestDataFactory.createReasonCode(1, globalListeningTreeList.get(0).Id);
            insert reasonCodeList;
            
            List<cec_Alert_Rule__c> alertRuleList = 
                CEC_TestDataFactory.createAlertRule(1,'Quality','2','5',null,
                                                    reasonCodeList.get(0).Id,prodCategoryList.get(0).Id,
                                                    null,true,false,false,1);
            insert alertRuleList;
            
            List<cec_Alert_Action__c> alertActionList = 
                CEC_TestDataFactory.createEmailAlertAction(1, 'AlertTemplate', 
                                                           alertRuleList[0].Id);
            insert alertActionList;
            
            List<Case> caseList = CEC_TestDataFactory.createTestCases(50, 'New', 'Phone', null, null,
                                                                      caseProductList.get(0).Id, null, null, null, true);
            insert caseList;
        }
    } 
    
    public static testMethod void test_beforeInsert(){
        
        Test.startTest(); 
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c     = 'India';
            cmm.CaseOrigin__c = 'Email India';
            insert cmm;
            
            List<EmailMessage> em = new List<EmailMessage>();
            case c = new case();        
            cec_Case_Brand_Mapping__c cbm = new cec_Case_Brand_Mapping__c();
            
            cbm.Inbound_Email__c='akg@akg.com';
            cbm.Country__c = cmm.Id;
            cbm.Brand__c ='Dove';
            cbm.External_Image_Address__c ='http://unilever.com/central/img/so_logo.gif';
            cbm.Default_Outbound_Email__c = true;
            cbm.Default_Template_Name__c = 'DoveIndia';
            
            insert cbm;
            cec_Case_Brand_Mapping__c cbmtest = [Select Default_Template_Name__c, Brand_Market__c, Brand__c from cec_Case_Brand_Mapping__c Where Default_Template_Name__c = 'DoveIndia' limit 1];
            
            System.assertEquals(cmm.Market__c, cbmtest.Brand_Market__c);
            System.assertEquals(cbm.Inbound_Email__c,'akg@akg.com');          
            
            c.Origin = 'Email';
            c.Status = 'New';
            c.Subject ='My PC is not working2';
            //c.Brand__c = 'Dove';
            c.Set_Assignment_Fields__c = true;
            c.Country__c = cmm.id;
            insert c;
            
            /*case caseTest = [Select Brand__c, Case_Market__c from case Where Brand__c = 'Dove'];*/
            case caseTest = [Select Case_Brand__c, Case_Market__c from case Where Case_Brand__c = :c.Case_Brand__c];
            System.assertEquals(cmm.Market__c, caseTest.Case_Market__c); 
            
            
            EmailMessage e =  new EmailMessage();
            e.Status = '0';
            e.ParentId = c.id;
            e.ToAddress = 'akg@akg.com';
            e.Incoming = true;
            em.add(e);
            
            System.assertEquals(em.size(),1);  
            insert em;
            
            cec_EmailMessageHandler ocec_cec_EmailMessageHandler = new cec_EmailMessageHandler();
            ocec_cec_EmailMessageHandler.forbeforeInsert(em);
            
            cec_EmailMessageHelper ocec_EmailMessageHelper = new cec_EmailMessageHelper();
            ocec_EmailMessageHelper.emailMessage(em);
            
        }
        
        Test.stopTest(); 
        
    }
    
    public static testMethod void test_beforeInsert1(){
        
        Test.startTest(); 
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            
            //insert case market mapping
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c     = 'India';
            cmm.CaseOrigin__c = 'Email India';
            insert cmm;
            
            List<EmailMessage> em = new List<EmailMessage>();
            case c = new case();        
            cec_Case_Brand_Mapping__c cbm = new cec_Case_Brand_Mapping__c();
            
            cbm.Inbound_Email__c=CEC_Constants.unknownEmail;
            cbm.Country__c = cmm.Id;
            cbm.Brand__c ='Dove1';
            cbm.External_Image_Address__c ='http://unilever.com/central/img/so_logo.gif';
            cbm.Default_Outbound_Email__c = true;
            cbm.Default_Template_Name__c = 'DoveIndia';
            
            insert cbm;
            cec_Case_Brand_Mapping__c cbmtest = [Select Default_Template_Name__c, Brand_Market__c from cec_Case_Brand_Mapping__c Where Default_Template_Name__c = 'DoveIndia' limit 1];
            
            System.assertEquals(cbm.Inbound_Email__c,CEC_Constants.unknownEmail);          
            
            c.Origin = 'Email';
            c.Status = 'New';
            c.Subject ='My PC is not working2';
            //c.Brand__c = 'Dove';
            c.Set_Assignment_Fields__c = true;
            c.Country__c = cmm.id;
            insert c;
            
            /*case caseTest = [Select Brand__c, Case_Market__c from case Where Brand__c = 'Dove'];*/
            case caseTest = [Select Case_Brand__c, Case_Market__c from case Where Case_Brand__c = :c.Case_Brand__c];
            System.assertEquals(cmm.Market__c, caseTest.Case_Market__c);
            
            EmailMessage e =  new EmailMessage();
            e.Status = '0';
            e.ParentId = c.id;
            e.ToAddress = CEC_Constants.unknownEmail;
            e.CcAddress = CEC_Constants.unknownEmail;
            e.BccAddress = CEC_Constants.unknownEmail;
            e.Incoming = true;
            em.add(e);
            
            //System.assertEquals(em.size(),1);  
            insert em;
            
            cec_EmailMessageHandler ocec_cec_EmailMessageHandler = new cec_EmailMessageHandler();
            ocec_cec_EmailMessageHandler.forbeforeInsert(em);
            
            cec_EmailMessageHelper ocec_EmailMessageHelper = new cec_EmailMessageHelper();
            ocec_EmailMessageHelper.emailMessage(em);
        }
        Test.stopTest(); 
        
    }
    
    //Test method to test for the Case updating from CMM 
    public static testMethod void test_beforeInsert2(){
        
<<<<<<< HEAD
        EmailMessage e =  new EmailMessage();
        e.Status = '0';
        e.ParentId = c.id;
        e.ToAddress = 'unknown@unilever.com';
        e.CcAddress = 'unknown@unilever.com';
        e.BccAddress = 'unknown@unilever.com';
        e.Incoming = true;
        em.add(e);

        //System.assertEquals(em.size(),1);  
        insert em;

        cec_EmailMessageHandler ocec_cec_EmailMessageHandler = new cec_EmailMessageHandler();
        ocec_cec_EmailMessageHandler.forbeforeInsert(em);
    
        cec_EmailMessageHelper ocec_EmailMessageHelper = new cec_EmailMessageHelper();
        ocec_EmailMessageHelper.emailMessage(em);
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        CEC_NotificationEmailId__c Notifymail = new CEC_NotificationEmailId__c();
        Notifymail.Name = 'Cust Name';
        Notifymail.EmailId__c = 'email@somewhere.com';
        insert Notifymail;
        
        String emailSubject = 'Dove package damaged';
        String msgString    = 'Please pack properly';
        mail.setToAddresses(new String[] {Notifymail.EmailId__c});
        mail.setSubject(emailSubject);
        mail.setHTMLBody(msgString);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        
        CEC_Util.sendNotificationEmail(msgString, emailSubject);
}
=======
        Test.startTest(); 
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            
            //insert case market mapping
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c     = 'India';
            cmm.CaseOrigin__c = 'Email India';
            insert cmm;
            
            List<EmailMessage> em = new List<EmailMessage>();
            case c   =   new case();  
            CEC_Case_Market_Mapping__c cmmRec = [SELECT Id, CaseOrigin__c FROM CEC_Case_Market_Mapping__c WHERE CaseOrigin__c = 'Email India'];
            
            c.Origin                   = 'Email India';
            c.Status                   = 'New';
            c.Subject                  = 'My PC is not working2';
            //c.Brand__c                 = 'Dove';
            c.Set_Assignment_Fields__c = true;
            c.Country__c               = cmmRec.id;
            insert c;
            
            System.assertEquals(cmmRec.CaseOrigin__c, c.Origin);
            
            EmailMessage e =  new EmailMessage();
            e.Status = '0';
            e.ParentId = c.id;
            e.ToAddress = CEC_Constants.unknownEmail;
            e.CcAddress = CEC_Constants.unknownEmail;
            e.BccAddress = CEC_Constants.unknownEmail;
            e.Incoming = true;
            em.add(e);
            
            //System.assertEquals(em.size(),1);  
            insert em;
            
            cec_EmailMessageHandler ocec_cec_EmailMessageHandler = new cec_EmailMessageHandler();
            ocec_cec_EmailMessageHandler.forbeforeInsert(em);
            
            cec_EmailMessageHelper ocec_EmailMessageHelper = new cec_EmailMessageHelper();
            ocec_EmailMessageHelper.emailMessage(em);
            
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            CEC_NotificationEmailId__c Notifymail = new CEC_NotificationEmailId__c();
            Notifymail.Name = 'Cust Name';
            Notifymail.EmailId__c = 'email@somewhere.com';
            insert Notifymail;
            
            String emailSubject = 'Dove package damaged';
            String msgString    = 'Please pack properly';
            mail.setToAddresses(new String[] {Notifymail.EmailId__c});
            mail.setSubject(emailSubject);
            mail.setHTMLBody(msgString);
            if(!Test.isRunningTest()){ Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail}); }
            
            CEC_Util.sendNotificationEmail(msgString, emailSubject);
        }
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
        Test.stopTest(); 
        
    }
    
}
