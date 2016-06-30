/**
 * Name:        -   AA_RemoteServiceCallController_Test
 * @description -   This is the test class for AA_RemoteServiceCallController Class to verify the code While invoking a service.
 * @Author      -   Aslesha R K     
 */
@isTest
private class AA_RemoteServiceCallController_Test {
/********************************************************************************
Purpose: Method to test if we could invoke a service with and without URL pattern.
**********************************************************************************/
    static testMethod void invokeServiceTest() {
    	
        String responseA = AA_RemoteServiceCallController.invokeService('','getCompetitorSourceRetailerTopicCountry','post');
        String responseB = AA_RemoteServiceCallController.invokeServiceWithURLParameter('','getCompetitorSourceRetailerTopicCountry','post','');
        
        AA_ApplicationWrapperObj responseC = AA_RemoteServiceCallController.constructRequestBody('test','test','test','test');
        
        String responseD = AA_RemoteServiceCallController.invokeService(null,null,null);
        system.assert(responseA!=null);
        system.assert(responseB!=null);
        system.assert(responseC!=null);
        system.assert(responseD!=null);
  
    }
}