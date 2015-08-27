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

    public static testMethod void test_beforeInsert(){

        Test.startTest(); 

        CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
        cmm.Market__c = 'India';
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
        cec_Case_Brand_Mapping__c cbmtest = [Select Default_Template_Name__c, Brand_Market__c from cec_Case_Brand_Mapping__c Where Default_Template_Name__c = 'DoveIndia' limit 1];

        System.assertEquals(cmm.Market__c, cbmtest.Brand_Market__c);
        System.assertEquals(cbm.Inbound_Email__c,'akg@akg.com');          

        c.Origin = 'Email';
        c.Status = 'New';
        c.Subject ='My PC is not working2';
        c.Brand__c = 'Dove';
        c.Set_Assignment_Fields__c = true;
        c.Country__c = cmm.id;
        insert c;

        case caseTest = [Select Brand__c, Case_Market__c from case Where Brand__c = 'Dove'];
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

        Test.stopTest(); 
 
    }
    
    public static testMethod void test_beforeInsert1(){

        Test.startTest(); 
        
        //insert case market mapping
        CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
        cmm.Market__c = 'India';
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
        c.Brand__c = 'Dove';
        c.Set_Assignment_Fields__c = true;
        c.Country__c = cmm.id;
        insert c;

        case caseTest = [Select Brand__c, Case_Market__c from case Where Brand__c = 'Dove'];
        System.assertEquals(cmm.Market__c, caseTest.Case_Market__c);

        EmailMessage e =  new EmailMessage();
        e.Status = '0';
        e.ParentId = c.id;
        e.ToAddress = 'unknown@unilever.com';
        e.Incoming = true;
        em.add(e);

        //System.assertEquals(em.size(),1);  
        insert em;

        cec_EmailMessageHandler ocec_cec_EmailMessageHandler = new cec_EmailMessageHandler();
        ocec_cec_EmailMessageHandler.forbeforeInsert(em);
    
        cec_EmailMessageHelper ocec_EmailMessageHelper = new cec_EmailMessageHelper();
        ocec_EmailMessageHelper.emailMessage(em);

        Test.stopTest(); 

    }
    
}