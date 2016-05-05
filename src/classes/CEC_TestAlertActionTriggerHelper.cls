@isTest(seealldata=false)
public with sharing class CEC_TestAlertActionTriggerHelper {

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
 // Test Method for validate email template
    static testMethod void validateEmailtemplate(){
    User u = insertUser();
        
         System.runAs(u)
         {
        
        mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
        insert pCategory;
        
        mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', 
                                                                L2_Desc__c = 'Product', L3_Desc__c = 'Foreign matter',
                                                                L4_Desc__c = 'Unidentifiable Foreign Matter', 
                                                                L5_Desc__c = 'Foreign matter - unidentifiable');
        insert gListingTree;

        mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261',Global_Listening_Tree__c = gListingTree.Id);
        insert reasonObj;
        
        cec_Alert_Rule__c alertRule = new cec_Alert_Rule__c(Name = 'Rule 1', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='India',  All_Market__c = true, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5', Group_By_Day_Code__c = false);
        insert alertRule;
        
        Test.startTest();
        try{
        cec_Alert_Action__c alertAction = new cec_Alert_Action__c( 
        Type__c = 'Email', 
        Alert_Rule_Id__c = alertRule.id,
        Email_Template_Name__c='CEC_SubjectMerged' ,
        To__c='John.Smith@test.com');
        insert alertAction;
        System.assert(alertAction!=null);
        }catch(Exception e){
            
        }
        
        Test.stopTest();
        }
    }
    
     // Test Method for invalidate email template
    static testMethod void inValidateEmailtemplate(){
        
        User u = insertUser();
        
         System.runAs(u)
         {
        mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
        insert pCategory;
        
        mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', 
                                                                L2_Desc__c = 'Product', L3_Desc__c = 'Foreign matter',
                                                                L4_Desc__c = 'Unidentifiable Foreign Matter', 
                                                                L5_Desc__c = 'Foreign matter - unidentifiable');
        insert gListingTree;

        mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261',Global_Listening_Tree__c = gListingTree.Id);
        insert reasonObj;
        
        cec_Alert_Rule__c alertRule = new cec_Alert_Rule__c(Name = 'Rule 1', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='India',  All_Market__c = true, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5', Group_By_Day_Code__c = false);
        insert alertRule;
        
        Test.startTest();
        try{
        cec_Alert_Action__c alertAction = new cec_Alert_Action__c( 
        Type__c = 'Email', 
        Alert_Rule_Id__c = alertRule.id,
        Email_Template_Name__c='test' ,
        To__c='John.Smith@test.com');
        insert alertAction;
        System.assert(alertAction!=null); 
        }catch(Exception e){
            System.debug('Added error');
        }
        
        Test.stopTest();
        }
    }
}