@isTest(SeeAllData=true)
Private class BC_BrandCentreHomeTabTest{
    /** Description: test method for checking the redirect method for BC_BrandCentreHomeTabController
      * 
      */
    static testMethod void myUnitTest(){
        BC_BrandCentreHomeTabController brandcentrehometab = new BC_BrandCentreHomeTabController();
        brandcentrehometab.Redirect();        
    }
}