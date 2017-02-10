/******************************************************************************************************************************
* @author Cognizant 
* @date 06/02/2017
* @description Test Class for IPM_sObjectRedirectController
*/
@isTest
private class IPM_sObjectRedirectController_Test {

	private static testMethod void getSetUp_Test() {
        IPM_sObjectRedirectController sObjectRedirectController = new IPM_sObjectRedirectController();
        sObjectRedirectController.selectedSObjectType = 'TemporarySObeject__c';
        sObjectRedirectController.sObjectPrefix = '';
        sObjectRedirectController.selectedSObjectId = '';
        sObjectRedirectController.getSetUp();
        System.assertEquals(sObjectRedirectController.selectedSObjectType,'TemporarySObeject__c');
        
	}

}