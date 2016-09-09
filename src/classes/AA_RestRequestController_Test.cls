@isTest
public class AA_RestRequestController_Test {
	static testMethod void serviceTest(){
	
   		String latlongString =AA_Constants.LatSample +','+AA_Constants.LongSample;
   		String path='/maps/api/geocode/json?latlng='+latlongString; 
   		String method='GET';
    	String responseFormat='application/json';
    	//String bodyContent;
    	String bodyContentType='application/json';
    	aa_agent_app_custom_setting__c customsetting = new aa_agent_app_custom_setting__c(Name='GoogleMap ClientID');
    	customsetting.Key__c='gme-unilever';
        insert customsetting;
        aa_agent_app_custom_setting__c customsetting1 = new aa_agent_app_custom_setting__c(Name='GoogleMap PrivateKey');
    	customsetting1.Key__c='DS-2wns6FR5hcaXPy5liVFfwKek=';
        insert customsetting1;
        aa_agent_app_custom_setting__c customsetting2 = new aa_agent_app_custom_setting__c(Name='GoogleMap BaseUrl');
    	customsetting2.Key__c='https://maps.googleapis.com';
        insert customsetting2;
        //customsetting.BaseUrl__c='https://maps.googleapis.com';
    	//customsetting.ClientID__c='gme-unilever';
    	//customsetting.PrivateKey__c='DS-2wns6FR5hcaXPy5liVFfwKek=';
    	
     	Test.startTest();
     	Test.setMock(HttpCalloutMock.class, new AA_MockHttpResponseGenerator());
     	AA_RestRequestController.Response resObj = new AA_RestRequestController.Response(); 
     	resObj = AA_RestRequestController.service(path,method,responseFormat,null,bodyContentType);
     	System.assertEquals(200,resObj.statusCode);
    	Test.stopTest();
	}
}