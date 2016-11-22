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
1.1     Sathish         Mar-2016       Code Refactoring
***********************************************************************/

@isTest(SeeAllData = False)
public class CEC_ProductRangeControllerTest {
    
   @testSetup static void setUpTestData() {

        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            /***** CREATING TEST DATA *****/
            // create category list 
            List<mdm_Product_Category__c> catogoryList = new List<mdm_Product_Category__c>();
            for(Integer i=0; i<5; i++){
                mdm_Product_Category__c categoryObj = new mdm_Product_Category__c(name='Test Category'+i, Corp_Prod_Grouping_Name__c='Group1', L2_Product_Category__c = 'L2 Category', L7_Product_Category__c = 'Test Category'+i);
                catogoryList.add(categoryObj);
            }
            insert catogoryList;
            
            // Create case product list
            list <mdm_Case_Product__c> caseProductList = new list<mdm_Case_Product__c>();
            for(Integer i=0; i<10; i++){
                mdm_Case_Product__c caseprod = new mdm_Case_Product__c(name='Test Case Product'+i, Global_CPG_Code__c = catogoryList[0].Id, Product_Tag__c = 'TagTest'+i, ISO_Country_Code__c = 'GB', brand__c= 'Dove'+i, Active_for_CEC__c = True);
                caseProductList.add(caseprod);
            }
            insert caseProductList;

            List<Case> caseList = CEC_TestDataFactory.createTestCases(1, 'New', 'Phone', null, null,
                                                caseProductList.get(0).Id, null, null, null, true);
            insert caseList;
        }
    } 
    
    /**
Test method for  fetchRecords method
**/  
    public static testMethod void test_fetchrecords(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {

            case caseRec = [Select Id, CEC_Product__c, Product_Code__c, Product_ISO_Country_Code__c, Product_CPG_Code__c, CEC_Product__r.Global_CPG_Code__r.Name,
                            CEC_Product__r.Brand__c FROM case LIMIT 1]; 
            
            Test.setCurrentPage(Page.CEC_ProductRange);
            ApexPages.currentPage().getParameters().put('Id', caseRec.id);
            
            Test.startTest();
            
            CEC_ProductRangeController ControllerObj = new CEC_ProductRangeController();
            ControllerObj.pageLoadAction();
            System.assertEquals(ControllerObj.CaseProducts.size(),9);
            
            
            // particular brand search
            ControllerObj.code = CEC_Constants.none;
            ControllerObj.brand = 'Dove1';
            ControllerObj.Producttag = CEC_Constants.none;
            ControllerObj.getBrands();
            ControllerObj.filteredCaseProducts();
            System.assertEquals(ControllerObj.CaseProducts.size(),1);
            // particular tag search
            ControllerObj.code = CEC_Constants.none;
            ControllerObj.brand = CEC_Constants.none;
            ControllerObj.Producttag = 'TagTest1';          
            ControllerObj.getTags();  
            ControllerObj.filteredCaseProducts();
            // particular Code search
            ControllerObj.code = 'Test Category1';
            ControllerObj.brand = CEC_Constants.none;
            ControllerObj.Producttag = CEC_Constants.none; 
            ControllerObj.filteredCaseProducts();
            // particular Code and brand search
            ControllerObj.code = 'Test Category1';
            ControllerObj.brand = 'Dove1';
            ControllerObj.Producttag = CEC_Constants.none; 
            ControllerObj.filteredCaseProducts();
            // particular Code and tag search
            ControllerObj.code = 'Test Category1';
            ControllerObj.brand = CEC_Constants.none;
            ControllerObj.Producttag = 'TagTest1'; 
            ControllerObj.filteredCaseProducts();
            // particular Brand and tag search
            ControllerObj.code = CEC_Constants.none;
            ControllerObj.brand = 'Dove1';
            ControllerObj.Producttag = 'TagTest1'; 
            ControllerObj.filteredCaseProducts();
            // blank search
            ControllerObj.brand = CEC_Constants.none;
            ControllerObj.code = CEC_Constants.none;
            ControllerObj.Producttag = CEC_Constants.none;
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