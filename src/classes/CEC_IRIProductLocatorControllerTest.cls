/**********************************************************************
Name:  CEC_IRIProductLocatorControllerTest()
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: This is the Test class for CEC_IRIProductLocatorController Apex class                                                                                                    

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Sreya           Jan-2016      INITIAL DEVELOPMENT   

***********************************************************************/

@isTest(SeeAllData = False)
public class CEC_IRIProductLocatorControllerTest{
    
    /* method to create test user*/
    public static User insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Unilever - Salesforce MultiApp Standard'];
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
    
    /**
Test method for  fetchRecords method
**/  
    public static testMethod void test_fetchrecords(){
        
        User u = insertUser();
        System.runAs(u){
            /***** CREATING TEST DATA *****/
            
            //Create Account
            
            Account accountObj = new Account();
            accountObj.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
            accountObj.PersonMailingCity = 'Mumbai';
            accountObj.PersonMailingPostalCode = '560023';
            accountObj.LastName = 'TestAccount';        
            insert accountObj;
            
            //Create Product Category
            
            mdm_Product_Category__c categoryObj = new mdm_Product_Category__c(name='Test Category', Corp_Prod_Grouping_Name__c='Group1', L2_Product_Category__c = 'L2 Category', L7_Product_Category__c = 'Test Category');
            insert categoryObj;
            
            //Create Case Product
            
            mdm_Case_Product__c caseprod = new mdm_Case_Product__c(name='Test Case Product', Global_CPG_Code__c = categoryObj.Id, ISO_Country_Code__c = 'GB', brand__c= 'Dove',GTIN_EAN_UPC_Code__c = 'Test Code', Active_for_CEC__c = True);
            insert caseprod;
            
            //Create Case
            
            Case caseObj = new Case();
            caseObj .Status = 'New';
            caseObj .Origin = 'Email';
            caseObj.AccountID =  accountObj.id;
            caseObj.CEC_Product__c = caseprod.id;
            insert caseObj;
            
            case caseRec = [Select Id, CEC_Product__c, Product_UPC__c, Account.PersonMailingPostalCode FROM case WHERE id =:caseObj.Id];
            
            Test.setCurrentPage(Page.CEC_IRIProductLocator);
            ApexPages.currentPage().getParameters().put('Id', caseRec.id);
            
            Test.startTest();
           
            CEC_IRIProductLocatorController ControllerObj = new CEC_IRIProductLocatorController();
            
            System.assertEquals(ControllerObj.postCode , '560023');
            
            System.assertEquals(ControllerObj.prodCode , 'Test Code');
            
            System.assertEquals(ControllerObj.pageSize , '10');
          
            Test.setMock(HttpCalloutMock.class, new CEC_IRIProductLocator_CalloutMock());
           
            ControllerObj.IRISearch();
            
            System.assertEquals(ControllerObj.stores.size() , 2);
            
            System.assert(ControllerObj.errMsg <> null);
       
            ControllerObj.getpageSizeOptions();
            
            List<CEC_IRIWrapper.STORE> storeDetails = ControllerObj.stores;
            
            for(CEC_IRIWrapper.STORE storeToCase : storeDetails){
            
            storeToCase.ISSELECTED = true;
            
            }
       
            ControllerObj.addToCase(); 
     
            Test.stopTest();
            
        }
    }
}