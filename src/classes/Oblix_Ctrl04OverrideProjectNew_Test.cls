@isTest 
private class Oblix_Ctrl04OverrideProjectNew_Test {

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
	     	Marketing_SOW__c marketingSow = new Marketing_SOW__c();
        		marketingSow.Active__c = true;
        		marketingSow.Name = 'Marketinf Sow Approval Test';
        		marketingSow.SOW_Status__c = 'Open';
        		marketingSow.Financial_Year__c = 'FY2015';
        		insert marketingSow;
        	
        	Oblix_SOW_Projects__c project2 = new Oblix_SOW_Projects__c();
        		project2.Name = 'Project #3';
        		project2.Financial_Year__c = marketingSow.Id;
        		
	     	Oblix_SOW_Projects__c project = new Oblix_SOW_Projects__c();
        		project.Name = 'Project #2';
        		project.Financial_Year__c = marketingSow.Id;
        		insert project;
        	 System.assertEquals(project.Financial_Year__c, marketingSow.Id);
        	 
        	MDO_Geography__c geographyRegion = new MDO_Geography__c();
        		geographyRegion.Name = 'Europe';
        		geographyRegion.geography_type__c = 'Region';
        		insert geographyRegion;
        	
        	MDO_Geography__c geographyCountry = new MDO_Geography__c();
        		geographyCountry.Name = 'France';
        		geographyCountry.geography_type__c = 'Country Cluste';
        		geographyCountry.parent_L5__c = geographyRegion.Id;
        		insert geographyCountry;
        		
        		PageReference pageref = Page.Oblix_VF04OverrideProjectNew ; 
        			pageRef.getParameters().put('Id', project.Id);
        	  	Test.setCurrentPage(pageref) ;
        	  Oblix_Ctrl04OverrideProjectNew controller = new Oblix_Ctrl04OverrideProjectNew(new ApexPages.StandardController(project));
        	  	controller.selectedCountries = 'France';
        	  	controller.RelatedCountriesRegions();
        	  	controller.selectedCountries = null;
        	  	controller.save();
        	  	controller.selectedCountries = null;
        	  	controller.save();
        	  	
        	  	Oblix_Ctrl04OverrideProjectNew controller2 = new Oblix_Ctrl04OverrideProjectNew(new ApexPages.StandardController(project2));
        	  	controller2.selectedCountries = null;
        	  	controller2.save();
	     }
    }
}