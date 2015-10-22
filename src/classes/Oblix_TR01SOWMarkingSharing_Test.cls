@isTest
private class Oblix_TR01SOWMarkingSharing_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
         Profile p=[Select Id from Profile where Name='System Administrator' or Name='Système Administrateur'];       
     
	     //Insert User 
	     User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
	      EmailEncodingKey='UTF-8', LastName='af test', LanguageLocaleKey='en_US', 
	      LocaleSidKey='en_US', ProfileId = p.Id,firstname='sf test one', 
	      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
	      UserName='testuser@test123321.com');//,AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1'
	     insert u; 
	     
	     System.runAs(u){
	     	User userShare= new User(Alias = 'test1233', Email='standarduser@unilever.com', 
			      EmailEncodingKey='UTF-8', LastName='af test', LanguageLocaleKey='en_US', 
			      LocaleSidKey='en_US', ProfileId = p.Id,firstname='sf test one', 
			      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
			      UserName='JOE@unilever1.com');
			     insert userShare; 
	     	MDO_Brand__c brand = new MDO_Brand__c();
	     		brand.Name = 'Food';
	     		brand.status__c = 'active';
	     		insert brand;
	     	MDO_BrandUser__c brandUser = new MDO_BrandUser__c();
        			brandUser.Brand__c = brand.Id;
        			brandUser.User__c = userShare.Id;	
        		insert brandUser;
        		
	     	Marketing_SOW__c marketingSow = new Marketing_SOW__c();
        		marketingSow.Active__c = true;
        		marketingSow.Name = 'Marketinf Sow Approval Test';
        		marketingSow.SOW_Status__c = 'Open';
        		marketingSow.OblixBrand__c = brand.Id;
        		insert marketingSow;
        		
        		update marketingSow;
        		System.assertequals(marketingSow.OblixBrand__c, brandUser.Brand__c);
	     }
    }
}