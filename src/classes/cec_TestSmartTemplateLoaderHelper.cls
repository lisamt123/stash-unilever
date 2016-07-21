/**********************************************************************
 Name:  cec_TestSmartTemplateLoaderHelper
 Copyright ? 2014  Unilever
 ======================================================================
=======================================================================
Purpose: This is the test class for the Helper class for cec_TestEmailMessageHelper
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
   1.0 - Aalok 22/10/2014      INITIAL DEVELOPMENT  CSR
 
***********************************************************************/

/**
Test class for the Helper class for Trigger for cec_EmailMessageHelper
*/
@isTest(SeeAllData = false)

public class cec_TestSmartTemplateLoaderHelper{

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


public static testMethod void SmartTemplateLoaderHelper(){

    User u = insertUser();
        
         System.runAs(u)
         {
        Test.startTest();
        case c = new case(); 
        case c1 = new case();      
        case c2 = new case();  

        CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
        cmm.Market__c = 'India';
        insert cmm;
     
        system.debug('------------------cmm.Market__c '+cmm.Market__c );
        system.debug('------------------cmm '+cmm );
    
        List<case> caseList = new List<case>();
        cec_Case_Brand_Mapping__c cbm = new cec_Case_Brand_Mapping__c();
        
        cbm.Inbound_Email__c='akg@akg.com';
        cbm.Country__c = cmm.Id;
        cbm.Brand__c ='Dove';
        cbm.External_Image_Address__c ='http://unilever.com/central/img/so_logo.gif';
        cbm.Default_Outbound_Email__c = true;
        cbm.Default_Template_Name__c='DoveIndia';
        insert cbm;
        
        system.debug('------------------cbm.id>>>>>>>> '+cbm.id);
        system.debug('------------------cbm.Country__c.id>>>>>>>> '+cbm.Country__c);
        system.debug('------------------cbm.Brand_Market__c.id>>>>>>>> '+cbm.Brand_Market__c);
    
        cec_Case_Brand_Mapping__c cbmtest = [Select Inbound_Email__c, Brand__c, External_Image_Address__c, Default_Outbound_Email__c, Default_Template_Name__c,
                                          Brand_Market__c, Language__c from cec_Case_Brand_Mapping__c Where Default_Template_Name__c = 'DoveIndia' limit 1];

        system.debug('------------------cbm.Brand_Market__c>>>>>>> '+cbmtest.Brand_Market__c);
    
        System.assertEquals(cmm.Market__c, cbmtest.Brand_Market__c); 
      
        cec_Case_Brand_Mapping__c cbm1 = new cec_Case_Brand_Mapping__c();
        

        /**/
        c.Origin = 'Email';
        c.Status = 'New';
        c.Subject ='My PC is not working2';
        //c.Brand__c = 'Dove';
        c.Set_Assignment_Fields__c = true;
        c.Case_Brand_Mapping__c  =cbm.id;
        c.Country__c = cmm.Id;
        caseList.add(c);
        
        
    
        c1.Origin = 'Email';
        c1.Status = 'New';
        c1.Subject ='My PC is not working2';
        //c1.Brand__c = 'Dove';
        c1.Country__c = cmm.id;
        c1.Set_Assignment_Fields__c = true;
        caseList.add(c1);  
        insert caseList;
        
      /*case caseTest = [Select Brand__c, Case_Market__c from case Where Brand__c = 'Dove' limit 1];*/
      case caseTest = [Select Case_Brand__c, Case_Market__c from case Where Case_Brand__c = :c.Case_Brand__c limit 1];

        system.debug('------------------cbm.Brand_Market__c>>>>>>> '+caseTest.Case_Market__c);
        
        System.assertEquals(cmm.Market__c, caseTest.Case_Market__c);
        
        /*case caseTest1 = [Select Brand__c, Case_Market__c from case Where Brand__c = 'Dove' limit 1];*/
      case caseTest1 = [Select Case_Brand__c, Case_Market__c from case Where Case_Brand__c = :c1.Case_Brand__c  limit 1];

        system.debug('------------------cbm.Brand_Market__c>>>>>>> '+caseTest1.Case_Market__c);
        
        System.assertEquals(cmm.Market__c, caseTest1.Case_Market__c);
            
        
        
        System.assertEquals(caseList.size(),2);
        cbm1.Country__c =  cmm.Id;
 
        cbm1.Inbound_Email__c='akg1@akg.com';
        cbm1.Brand__c ='';
        cbm1.External_Image_Address__c ='http://unilever.com/central/img/so_logo.gif';
        cbm1.Default_Outbound_Email__c = true;
        cbm1.Default_Template_Name__c='DoveIndia1';
        insert cbm1;
   
        System.assertEquals(cbm1.Default_Template_Name__c,'DoveIndia1');  
                         
        cec_Case_Brand_Mapping__c cbmtest1 = [Select Inbound_Email__c, Brand__c, External_Image_Address__c, Default_Outbound_Email__c, Default_Template_Name__c,
                                          Brand_Market__c, Language__c from cec_Case_Brand_Mapping__c Where Default_Template_Name__c = 'DoveIndia1' limit 1];

        system.debug('------------------cbm.Brand_Market__c>>>>>>> '+cbmtest1.Brand_Market__c);
        
        System.assertEquals(cmm.Market__c, cbmtest1.Brand_Market__c);
       
        Folder FolderObj = [select id, name from Folder where DeveloperName = 'CEC_Unilever' or name = 'CEC Unilever' limit 1];

        system.debug('-------------FolderObj '+FolderObj );

        EmailTemplate EmailTemplateObj = [select id, name from EmailTemplate where folderid =:FolderObj.id limit 1];
        
        cec_SmartTemplateLoaderHelper  ocec_SmartTemplateLoaderHelper = new cec_SmartTemplateLoaderHelper();
        if (!caseList.isEmpty()){
        for(case cc :caseList)
            ocec_SmartTemplateLoaderHelper.getDefaultEmailTemplateId(cc.id);
        }
      
        delete cbm1;
        delete cbm;
      
        c2.Origin = 'Email';
        c2.Status = 'New';
        c2.Set_Assignment_Fields__c = true;
      
        insert c2;
     
        caseList = null;
        ocec_SmartTemplateLoaderHelper.getDefaultEmailTemplateId(c2.id);
}
        Test.stopTest();
    }
}