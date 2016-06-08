/**
* @author       Cognizant 
* @date         19/01/2016
* @description  This class is used to test the functionality of IPM_IECompatible class 
*/
@isTest
public with sharing class IPM_IECompatible_Test {
   
   
    public static string USER_AGENT = 'USER-AGENT';
    public static string MSIE = 'MSIE'; 
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
        system.AssertEquals(Apexpages.currentPage().getHeaders().get(USER_AGENT),MSIE,'Browser Mode IE');   
        Test.stopTest();
    }

}