/**
* @author       Cognizant 
* @date         19/01/2016
* @description  This class is used to test the functionality of IPM_IECompatible class 
*/
@isTest
private with sharing class IPM_IECompatible_Test {
   
   
    public static final string USER_AGENT = 'USER-AGENT';
    public static final string MSIE = 'MSIE'; 
    public static final string ERROR_MSG ='Invalid browser type'; 
    /**
    *  To test PM_IECompatible class
    *  @name :testIECompatible
    *  @param : nil
    *  @return : nil
    */
    public static testmethod void testIECompatible(){
        

        Test.startTest();
        Test.setCurrentPage(Page.IPM_ProjectSearchPage);
        ApexPages.currentPage().getHeaders().put(USER_AGENT , MSIE);
        IPM_IECompatible.ieFix();
        System.assertEquals(Apexpages.currentPage().getHeaders().get(USER_AGENT),MSIE, ERROR_MSG);   
        Test.stopTest();
    }

}