@isTest
public class AA_RestRequestController_Test {
	static testMethod void serviceTest(){
	
   		String latlongString =AA_Constants.LatSample +','+AA_Constants.LongSample;
   		String path='/maps/api/geocode/json?latlng='+latlongString; 
   		String method='GET';
    	String responseFormat='application/json';
    	//String bodyContent;
    	String bodyContentType='application/json';
    	AA_GoogleMap__c customsetting = new AA_GoogleMap__c(Name='GoogleMap');
    	customsetting.BaseUrl__c='https://maps.googleapis.com';
    	customsetting.ClientID__c='gme-unilever';
    	customsetting.PrivateKey__c='DS-2wns6FR5hcaXPy5liVFfwKek=';
    	insert customsetting;
     	Test.startTest();
     	Test.setMock(HttpCalloutMock.class, new AA_MockHttpResponseGenerator());
     	AA_RestRequestController.Response resObj = new AA_RestRequestController.Response(); 
     	resObj = AA_RestRequestController.service(path,method,responseFormat,null,bodyContentType);
     	System.assertEquals(200,resObj.statusCode);
    	Test.stopTest();
	}
}