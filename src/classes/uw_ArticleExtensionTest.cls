/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class uw_ArticleExtensionTest {

    static ArticleExtension setup() {
        // create an object for standard controller
        Article__c article = new Article__c();
        insert article;
        
        // set the test to point at a page that uses the standard controller/extension
       // Test.setCurrentPage(Page.cornetto_brand_centre_single_sfdc);
        
        // set the parameter
        uw_Brand__c brand = uw_UnitTestDataFactory.createParentBrand();
        ApexPages.currentPage().getParameters().put('bid', brand.Id);    

        // create standard controller
        ApexPages.StandardController sc = new ApexPages.StandardController(article);
        system.assert(sc!=null);

        // create the extension
        ArticleExtension ext = new ArticleExtension(sc);
        ext.back();
        //bet cleanup
       // ext.getlinksSections(); 
       // ext.getbrandlinks();
       // ext.getbrandsubcategory();
               

        system.assert(ext!=null);
        return ext;
    }

    static testMethod void testBasics() {
        ArticleExtension ext1 = setup();

        Test.startTest();
        ext1.brandId = 'test';
        system.assertEquals('test',ext1.brandId);
        Test.stopTest();
    }
    
    static testMethod void testProperties() {
        ArticleExtension ext1 = setup();        
        PageReference pr = null;

        Test.startTest();
        pr = ext1.home();
        pr = ext1.back();
               
        Test.stopTest();
        
        
    }
}