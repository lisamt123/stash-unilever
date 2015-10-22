@isTest
private class Oblix_Ctrl02OverrideAssetNew_Test {

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
        		
	     	Oblix_SOW_Projects__c project = new Oblix_SOW_Projects__c();
        		project.Name = 'Project #2';
        		project.Financial_Year__c = marketingSow.Id;
        		insert project;
        	 System.assertEquals(project.Financial_Year__c, marketingSow.Id);
        	 
        	Asset_Scoring__c assetScoring = new Asset_Scoring__c();
        		assetScoring.Type__c = 'Static Imagery';
        		assetScoring.Sub_Category__c = 'Origination';
        		assetScoring.Point_Score__c = 150;
        		insert assetScoring;
        		
	     	Oblix_Project_Assets__c asset = new Oblix_Project_Assets__c();
        		asset.Quantity__c = 2;
        		asset.Sub_Category__c = 'Origination';	
        		asset.Agency_Projects__c = project.Id;
        		asset.FULL_Description__c = assetScoring.Id;
        		insert asset;
        		Oblix_Project_Assets__c asset2 = new Oblix_Project_Assets__c();
        		asset2.Quantity__c = 2;
        		asset2.Sub_Category__c = 'Origination';	
        		asset2.Agency_Projects__c = project.Id;
        		asset2.FULL_Description__c = assetScoring.Id;

        		PageReference pageref = Page.Oblix_VF02OverrideAsetNewLookup ; 
        			pageRef.getParameters().put('Id', asset.Id);
        			pageRef.getParameters().put('RecordType', Oblix_Utils.MapRecordType('Oblix_Project_Assets__c').get('Experiential'));
        	  	Test.setCurrentPage(pageref) ;
        	  Oblix_Ctrl02OverrideAssetNew controller = new Oblix_Ctrl02OverrideAssetNew(new ApexPages.StandardController(asset));
        	  	System.assertEquals(controller.asset.Id, asset.Id);
        	   Oblix_Ctrl02OverrideAssetNew controller2 = new Oblix_Ctrl02OverrideAssetNew(new ApexPages.StandardController(asset2));	
        	   System.assertEquals(controller2.asset.Id, null);
	     }
    }
}