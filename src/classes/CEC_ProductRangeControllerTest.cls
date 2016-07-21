/**********************************************************************
Name:  CEC_ProductRangeControllerTest()
Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: This is the Test class for CEC_ProductRangeController Apex class                                                                                                    

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Koti           Nov-2015      INITIAL DEVELOPMENT   

***********************************************************************/

@isTest(SeeAllData = False)
public class CEC_ProductRangeControllerTest {
    
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
            // create category list 
            List<mdm_Product_Category__c> catogoryList = new List<mdm_Product_Category__c>();
            for(Integer i=0; i<5; i++){
                mdm_Product_Category__c categoryObj = new mdm_Product_Category__c(name='Test Category'+i, Corp_Prod_Grouping_Name__c='Group1', L2_Product_Category__c = 'L2 Category', L7_Product_Category__c = 'Test Category'+i);
                catogoryList.add(categoryObj);
            }
            insert catogoryList;
            
            // Create case product list
            list <mdm_Case_Product__c> caseprodlist = new list<mdm_Case_Product__c>();
            for(Integer i=0; i<10; i++){
                mdm_Case_Product__c caseprod = new mdm_Case_Product__c(name='Test Case Product'+i, Global_CPG_Code__c = catogoryList[0].Id, Product_Tag__c = 'TagTest'+i, ISO_Country_Code__c = 'GB', brand__c= 'Dove'+i, Active_for_CEC__c = True);
                caseprodlist.add(caseprod);
            }
            insert caseprodlist;
            
            // Create case
            Case caseObj = new Case(); 
            caseObj.CEC_Product__c = caseprodlist[0].id;
            insert caseObj;
            
            case caseRec = [Select Id, CEC_Product__c, Product_Code__c, Product_ISO_Country_Code__c, Product_CPG_Code__c, CEC_Product__r.Global_CPG_Code__r.Name,
                            CEC_Product__r.Brand__c FROM case WHERE id =:caseObj.Id]; 
            
            Test.setCurrentPage(Page.CEC_ProductRange);
            ApexPages.currentPage().getParameters().put('Id', caseRec.id);
            
            Test.startTest();
            
            CEC_ProductRangeController ControllerObj = new CEC_ProductRangeController();
            ControllerObj.pageLoadAction();
            System.assertEquals(ControllerObj.CaseProducts.size(),9);
            
            
            // particular brand search
            ControllerObj.code = '-None-';
            ControllerObj.brand = 'Dove1';
            ControllerObj.Producttag = '-None-';
            ControllerObj.getBrands();
            ControllerObj.filteredCaseProducts();
            System.assertEquals(ControllerObj.CaseProducts.size(),1);
            // particular tag search
            ControllerObj.code = '-None-';
            ControllerObj.brand = '-None-';
            ControllerObj.Producttag = 'TagTest1';          
            ControllerObj.getTags();  
            ControllerObj.filteredCaseProducts();
            // particular Code search
            ControllerObj.code = 'Test Category1';
            ControllerObj.brand = '-None-';
            ControllerObj.Producttag = '-None-'; 
            ControllerObj.filteredCaseProducts();
            // particular Code and brand search
            ControllerObj.code = 'Test Category1';
            ControllerObj.brand = 'Dove1';
            ControllerObj.Producttag = '-None-'; 
            ControllerObj.filteredCaseProducts();
            // particular Code and tag search
            ControllerObj.code = 'Test Category1';
            ControllerObj.brand = '-None-';
            ControllerObj.Producttag = 'TagTest1'; 
            ControllerObj.filteredCaseProducts();
            // particular Brand and tag search
            ControllerObj.code = '-None-';
            ControllerObj.brand = 'Dove1';
            ControllerObj.Producttag = 'TagTest1'; 
            ControllerObj.filteredCaseProducts();
            // blank search
            ControllerObj.brand = '-None-';
            ControllerObj.code = '-None-';
            ControllerObj.Producttag = '-None-';
            ControllerObj.filteredCaseProducts();
            System.assertEquals(ControllerObj.CaseProducts.size(),0);
            // All filters
            ControllerObj.code = 'Test Category1';
            ControllerObj.brand = 'Dove1';
            ControllerObj.Producttag = 'TagTest1';
            ControllerObj.getCodes();          
            ControllerObj.filteredCaseProducts();
            
            Test.stopTest();
        }
    }
    
}