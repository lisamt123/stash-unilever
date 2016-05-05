@isTest 
private class Oblix_Ctrl04OverrideProjectNew_Test {


    static testMethod void ValueDriversProjectTest(){
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);

            Oblix_TestUtils.createProjectAssets(project.id);

            ApexPages.currentPage().getParameters().put('clone','1');
            ApexPages.currentPage().getParameters().put('retUrl',project.id);
            ApexPages.currentPage().getParameters().put('Id',project.id);

            Oblix_Ctrl04OverrideProjectNew controller = new Oblix_Ctrl04OverrideProjectNew(new ApexPages.StandardController(project));

            controller.project = project;

            controller.ValueDriversProject('c1,c2,c4,c4');
            controller.ValueDriversProject('c1,c2,c4,c4,c5,c6');
            controller.ValueDriversProject('c1,c2,c4,c4,c5,c6,c7,c8,c9,c10,c11');
            controller.ValueDriversProject('c1,c2,c4,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16');

            Test.stopTest();

            System.assertEquals(controller.project.Project_Scale_1__c ,Oblix_Constants.Innovation_Projects_Market5,'Field should not be empty');

        }

    }

    static testMethod void CloneProjectTest(){
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);

            Oblix_TestUtils.createProjectAssets(project.id);

            Oblix_TestUtils.createSowProjectSplits(project.id);

            ApexPages.currentPage().getParameters().put('clone','1');
            ApexPages.currentPage().getParameters().put('retUrl',project.id);
            ApexPages.currentPage().getParameters().put('Id',project.id);

            Oblix_Ctrl04OverrideProjectNew controller = new Oblix_Ctrl04OverrideProjectNew(new ApexPages.StandardController(project));

            controller.project = project;

            controller.CloneProject();

            Test.stopTest();

            List<Oblix_Project_Assets__c> assets = [select id from Oblix_Project_Assets__c limit 3];
            List<Oblix_Marketing_SOW_Project_Splits__c> splits = [select id from Oblix_Marketing_SOW_Project_Splits__c limit 3];

            System.assertEquals(assets.size(),2,'There should be 2 assets');
            System.assertEquals(splits.size(),2,'There should be 2 splits');

        }
    }

    static testMethod void myUnitTest() {

        User u = Oblix_TestUtils.createTestUser();
	     
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
        	Test.StartTest();
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
        	Test.stopTest()	;
	    }
    }
}