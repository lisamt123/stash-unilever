@isTest
private class AA_RemoteServiceCallController_Test {

    static testMethod void invokeServiceTest() {
        String responseA = AA_RemoteServiceCallController.invokeService('','getCompetitorSourceRetailerTopicCountry','post');
        String responseB = AA_RemoteServiceCallController.invokeServiceWithURLParameter('','getCompetitorSourceRetailerTopicCountry','post','');
        
        AA_ApplicationWrapperObj responseC = AA_RemoteServiceCallController.constructRequestBody('test','test','test','test');
        
         String responseD = AA_RemoteServiceCallController.invokeService(null,null,null);
        system.assert(responseA!=null);
        system.assert(responseB!=null);
  
    }
}