@isTest
private class uw_BrandCentreExtensionTest {

    static testMethod void myUnitTest() 
    {
        BrandCentreExtension brandcentreex = new BrandCentreExtension(new ApexPages.StandardController(new uw_Brand__c()));   
    
  //BET cleanup  
  //  brandcentreex.savesection();
   // brandcentreex.linkret = 'a0e';
    //brandcentreex.savelink();
//    brandcentreex.getlinksSections();
//    brandcentreex.getbrandlinks();
//    brandcentreex.getbrandsubcategory();
    
        //kj 04/10
        brandcentreex.getUWLink();
        
brandcentreex.getwhoswholinks();
//brandcentreex.getlinksSections();
//brandcentreex.getbrandlinks();
//brandcentreex.getbrandsubcategory();
brandcentreex.getarticlelist();
        //TODO : pass in a valid brand to the controller
        // brandcentreex.savelink();
        //system.assertEquals('', brandcentreex.savelink().getUrl());
        
        
    }
    
    private static testmethod void test_new() {
        BrandCentreExtension brandcentreex = new BrandCentreExtension(new ApexPages.StandardController(new uw_Brand__c()));   
    
        ApexPages.currentPage().getParameters().put('type','subcategory');
        brandcentreex.savelink();
        ApexPages.currentPage().getParameters().put('type','sectionlink');
        brandcentreex.savelink();
        ApexPages.currentPage().getParameters().put('type','whoswho');
        brandcentreex.savelink();
        
        system.assertEquals(true,brandcentreex.pos0);
        system.assertEquals(false,brandcentreex.pos1);
        system.assertEquals(false,brandcentreex.pos2);
        
        List<Article__c> articles = brandcentreex.articles;
        system.assertEquals(0, articles.size());
        
    }  
}