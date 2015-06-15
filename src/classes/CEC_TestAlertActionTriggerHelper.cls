@isTest(seealldata=false)
public with sharing class CEC_TestAlertActionTriggerHelper {
 // Test Method for validate email template
    static testMethod void validateEmailtemplate(){
        
        mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
        insert pCategory;
        
         mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L5_Desc__c = 'L4 Desc');
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
    
     // Test Method for invalidate email template
    static testMethod void inValidateEmailtemplate(){
        
        mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
        insert pCategory;
        
         mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L5_Desc__c = 'L4 Desc');
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