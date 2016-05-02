@isTest
public with sharing class AR_Test_CaptchaHelper {
	static testmethod void Test_AR_CaptchaHelper() 
	{
		
		AR_CaptchaSettings__c settings = new AR_CaptchaSettings__c();
  		settings.base_url__c = 'https://www.google.com/recaptcha/api/verify';
    	settings.public_key__c = '6Lc34uYSAAAAAE61wmZTnmzd7ZoGUEyo__zvD3L1';
    	settings.private_key__c = '6Lc34uYSAAAAAMfFGBpiAsuas7_Me2KKDwp545Kr';
		insert settings;
		Test.startTest();
		
		Test.setMock(HttpCalloutMock.class, new AR_CaptchaHttpMock(false));
		
		AR_CaptchaHelper tmp_testHelper2 = new AR_CaptchaHelper();

		tmp_testHelper2.publicKey = 'test'; 
		String tests2 = tmp_testHelper2.challenge; 
        tests2 = tmp_testHelper2.response;  
        
    	Boolean testb2 =  tmp_testHelper2.verified;
        tmp_testHelper2.doVerify(); 
    	tmp_testHelper2.verify() ;
    	tmp_testHelper2.reset() ;

		
		ApexPages.currentPage().getParameters().put('recaptcha_challenge_field','test');
		ApexPages.currentPage().getParameters().put('recaptcha_response_field','test');
				
		AR_CaptchaHelper tmp_testHelper = new AR_CaptchaHelper();

		tmp_testHelper.publicKey = 'test'; 
		String tests = tmp_testHelper.challenge; 
        tests = tmp_testHelper.response;  
        
    	Boolean testb =  tmp_testHelper.verified;
        tmp_testHelper.doVerify(); 
    	tmp_testHelper.verify() ;
    	tmp_testHelper.reset() ;
    	Test.stopTest();
	}
}