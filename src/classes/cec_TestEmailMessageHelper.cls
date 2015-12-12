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
   1.0 - Aalok 21/10/2014      INITIAL DEVELOPMENT  CSR

 ***********************************************************************/

/**
Test class for the Helper class for Trigger for cec_EmailMessageHelper
 */

@isTest(SeeAllData=false)
public class cec_TestEmailMessageHelper{

    public static User insertUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Unilever - Salesforce MultiApp Standard'];
       //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //UserRole r = [SELECT Id,name FROM UserRole WHERE Name = 'CEC Global Head'];
        //System.debug('Role' + r.name);
        User u = new User(LastName = 'Testing', 
                             Username = 'cectestuser@test00DE0000000bbLj.org', 
                             Email = 'cectestuser@test00DE0000000bbLj.org', 
                             Alias = 'utest', 
                             TimeZoneSidKey = 'Europe/London', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'UTF-8', 
                             ProfileId = p.Id, 
                             LanguageLocaleKey = 'en_US',
                             UserPermissionsKnowledgeUser = true);  
                             
        insert u;
        List<PermissionSet> pslist = [SELECT Id FROM PermissionSet WHERE Name IN ('CEC_User','CEC_Manager','CEC_CRUD','CEC_Business_Admin','CEC_Knowledge_Manager','CEC_Automated_User')];
        List<PermissionSetAssignment> psalist = new List<PermissionSetAssignment>();
        for(PermissionSet ps:pslist)
        {
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = u.Id;
            psa.PermissionSetId = ps.Id;
            
            psalist.add(psa);
        
        }
        
        insert psalist;
        
        Group GR = [SELECT Id,name FROM Group WHERE Name = 'CEC - Knowledge Manager'];
        GroupMember GM = new GroupMember();
        GM.GroupId = GR.id;
        GM.UserOrGroupId = u.Id;
        insert GM;
        
        return u;
    
    }

    public static testMethod void test_beforeInsert(){

        Test.startTest(); 
        
        User u = insertUser();
        
         System.runAs(u)
         {

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
        User u = insertUser();
        
         System.runAs(u)
         {
        
        //insert case market mapping
        CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
        cmm.Market__c     = 'India';
        cmm.CaseOrigin__c = 'Email India';
        insert cmm;

        List<EmailMessage> em = new List<EmailMessage>();
        case c = new case();        
        cec_Case_Brand_Mapping__c cbm = new cec_Case_Brand_Mapping__c();

        cbm.Inbound_Email__c='unknown@unilever.com';
        cbm.Country__c = cmm.Id;
        cbm.Brand__c ='Dove1';
        cbm.External_Image_Address__c ='http://unilever.com/central/img/so_logo.gif';
        cbm.Default_Outbound_Email__c = true;
        cbm.Default_Template_Name__c = 'DoveIndia';

        insert cbm;
        cec_Case_Brand_Mapping__c cbmtest = [Select Default_Template_Name__c, Brand_Market__c from cec_Case_Brand_Mapping__c Where Default_Template_Name__c = 'DoveIndia' limit 1];

        System.assertEquals(cbm.Inbound_Email__c,'unknown@unilever.com');          

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
    }
        Test.stopTest(); 

    }
    
    //Test method to test for the Case updating from CMM 
    public static testMethod void test_beforeInsert2(){

        Test.startTest(); 
        User u = insertUser();
        
         System.runAs(u)
         {
        
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
        Test.stopTest(); 

    }
    
}