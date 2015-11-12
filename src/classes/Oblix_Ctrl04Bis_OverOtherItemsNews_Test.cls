@isTest
private class Oblix_Ctrl04Bis_OverOtherItemsNews_Test {

    static testMethod void myUnitTest() {
		Profile p=[Select Id from Profile where Name='System Administrator' or Name='Système Administrateur'];       
     
	     //Insert User 
	     User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
	      EmailEncodingKey='UTF-8', LastName='af test', LanguageLocaleKey='en_US', 
	      LocaleSidKey='en_US', ProfileId = p.Id,firstname='sf test one', 
	      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
	      UserName='testuser@test123321.com');//,AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1'
	     insert u; 
	     
	     System.runAs(u){
	     	Account myAccount = new Account();
	     			myAccount.Name = 'AgencyAccount';
	     	insert myAccount;
	     	Marketing_SOW__c marketingSow = new Marketing_SOW__c();
        		marketingSow.Active__c = true;
        		marketingSow.Name = 'Marketinf Sow Approval Test';
        		marketingSow.SOW_Status__c = 'Open';
        		marketingSow.Financial_Year__c = 'FY2015';
        		marketingSow.Oblix_AgencyEstimate__c = myAccount.Id;
        		insert marketingSow;
        		MDO_Geography__c geographyRegion = new MDO_Geography__c();
        		geographyRegion.Name = 'Europe';
        		geographyRegion.geography_type__c = 'Region';
        		insert geographyRegion;
        	
        	MDO_Geography__c geographyCountry = new MDO_Geography__c();
        		geographyCountry.Name = 'France';
        		geographyCountry.geography_type__c = 'Country Cluste';
        		geographyCountry.parent_L5__c = geographyRegion.Id;
        		insert geographyCountry;	
        	Oblix_Calculator__c roleRate = new Oblix_Calculator__c();
        			roleRate.Agency_Department__c = 'Account Management';
        			roleRate.Role_Title__c = 'Global Account Head';
        			roleRate.OblixCountry__c = geographyCountry.Id;
        			roleRate.FTE__c = 20;
        			roleRate.Role_Daily_Rate_EUR__c = 10;
        			roleRate.Financial_Year__c = marketingSow.Financial_Year__c ;
        			roleRate.RecordTypeId = Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Role_Rate');
        			roleRate.Oblix_Agency__c = marketingSow.Oblix_AgencyEstimate__c;
        			insert roleRate; 
        	String marKObjName = 'Marketing_Basics__c';
        	Marketing_Basics__c basicParent = new Marketing_Basics__c();
        		basicParent.Oblix_SOWMarketing__c = marketingSow.Id;
        		basicParent.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Resource');
        		basicParent.OblixCountry__c = geographyCountry.Id;
        		insert basicParent;
			Marketing_Basics__c basicParent1 = new Marketing_Basics__c();
        		basicParent1.Oblix_SOWMarketing__c = marketingSow.Id;
        		basicParent1.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Resource');
        		basicParent1.FTE__c = 50;
        		basicParent1.OblixCountry__c = geographyCountry.Id;
        		insert basicParent1;
        	
        		
        	Marketing_Basics__c basicParentActivity = new Marketing_Basics__c();
        		basicParentActivity.Oblix_SOWMarketing__c = marketingSow.Id;
        		basicParentActivity.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Activity');
        		basicParentActivity.OblixCountry__c = geographyCountry.Id;
        	Marketing_Basics__c basicParentActivity1 = new Marketing_Basics__c();
        		basicParentActivity1.Oblix_SOWMarketing__c = marketingSow.Id;
        		basicParentActivity1.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Activity');	
        		//basicParentActivity1.FTE__c = 50;
        		basicParentActivity1.No_of_Hours_Required__c = 10;
        		basicParentActivity1.OblixCountry__c = geographyCountry.Id;
        		insert basicParentActivity1;
        
        	
        	
        	Test.StartTest();
	        	PageReference pageref = Page.Oblix_VF4Bis_OverrideOtherItemsNews ; 
	        			pageRef.getParameters().put('Id', basicParent1.Id);
	        	  	Test.setCurrentPage(pageref) ;
	        	  	Oblix_Ctrl04Bis_OverrideOtherItemsNews controller = new Oblix_Ctrl04Bis_OverrideOtherItemsNews(new ApexPages.StandardController(basicParent1));
	        	  		controller.reRenderAgencyDepartments();
	        	  		controller.selectedAgencyDepartment = roleRate.Agency_Department__c;
	        	  		controller.reRenderRoleTitle();
	        	  		 System.assertEquals(controller.selectedAgencyDepartment, roleRate.Agency_Department__c);
	        	  		//controller.getRoleTitle();
	        	  		//controller.getOblixCountry();
	        	  		controller.save(); 
	        	  
	        	  Oblix_Ctrl04Bis_OverrideOtherItemsNews controller1 = new Oblix_Ctrl04Bis_OverrideOtherItemsNews(new ApexPages.StandardController(basicParentActivity));
	        	  		controller1.reRenderAgencyDepartments();
	        	  		controller1.selectedAgencyDepartment = roleRate.Agency_Department__c;
	        	  		controller1.reRenderRoleTitle();
	        	  		controller1.save(); 
	        	  		
	        	  Oblix_Ctrl04Bis_OverrideOtherItemsNews controller2 = new Oblix_Ctrl04Bis_OverrideOtherItemsNews(new ApexPages.StandardController(basicParentActivity1));
	        	  		controller2.reRenderAgencyDepartments();
	        	  		controller2.selectedAgencyDepartment = roleRate.Agency_Department__c;
	        	  		controller2.reRenderRoleTitle();
	        	  		controller2.save(); 
	        	  		controller2.reRenderSOW();
	        	  		List<SelectOption> countries = controller2.getCountry();
	        	  	
        	  Test.stopTest();		
	     }
		        
    }
}