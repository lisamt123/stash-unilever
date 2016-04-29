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
1.1      Sathish         Mar-2016      Code Refactoring 
***********************************************************************/

@isTest(SeeAllData = False)
public class CEC_IRIProductLocatorControllerTest{
   
       @testSetup static void setUpTestData() {
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            List<mdm_Product_Category__c> prodCategoryList = 
                                                CEC_TestDataFactory.createProductCategory(1);
            insert prodCategoryList;

            mdm_Case_Product__c caseprod = new mdm_Case_Product__c(name='Test Case Product', 
                                            Global_CPG_Code__c = prodCategoryList.get(0).Id, ISO_Country_Code__c = 'US', 
                                            brand__c= 'Dove',GTIN_EAN_UPC_Code__c = 'Test Code', Active_for_CEC__c = True);
            insert caseprod;

            List<Account> accountList = CEC_TestDataFactory.createTestAccounts(1, 'TestAccount', null, null, '560023',
                                                'Mumbai', null, null);
            insert accountList;

            List<Case> caseList = CEC_TestDataFactory.createTestCases(1, 'New', 'Email', null, null,
                                                caseprod.Id, null, accountList.get(0).Id, null, false);
            insert caseList;
        }
    }

    /**
        Test method for  fetchRecords method
    **/  
    public static testMethod void test_fetchrecords(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u){
            Case caseRec = [Select Id, CEC_Product__c, Product_UPC__c, Account.PersonMailingPostalCode 
                                    FROM Case LIMIT 1];
            Account account = [SELECT Id, PersonMailingPostalCode, PersonMailingCity, PersonMailingCountry FROM Account Limit  1];
            System.debug('Case = ' + caseRec);
            System.debug('account = ' + account);
            System.debug('PersonMailingPostalCode = ' + caseRec.Account.PersonMailingPostalCode);
            Test.setCurrentPage(Page.CEC_IRIProductLocator);
            ApexPages.currentPage().getParameters().put('Id', caseRec.id);
            
            Test.startTest();
           
            CEC_IRIProductLocatorController ControllerObj = new CEC_IRIProductLocatorController();

            System.debug('ControllerObj = ' + ControllerObj);
            
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