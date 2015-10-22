@isTest 
private class Oblix_TR03AssetPrScoreCalculator_Test {

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
        		insert marketingSow;
        		
        	Oblix_SOW_Projects__c project = new Oblix_SOW_Projects__c();
        		project.Name = 'Project #2';
        		project.Financial_Year__c = marketingSow.Id;
        		insert project;
        	
        	Asset_Scoring__c assetScoring = new Asset_Scoring__c();
        		assetScoring.Type__c = 'Static Imagery';
        		assetScoring.Sub_Category__c = 'Origination';
        		assetScoring.Point_Score__c = 150;
        		insert assetScoring;
        	
        	Asset_Scoring__c assetScoring2 = new Asset_Scoring__c();
        		assetScoring2.Type__c = 'Static Imagery';
        		assetScoring2.Sub_Category__c = 'Adaptation';
        		assetScoring2.Point_Score__c = 120;
        		insert assetScoring2;	
        		
        		
        	Oblix_Project_Assets__c asset = new Oblix_Project_Assets__c();
        		asset.Quantity__c = 2;
        		asset.Sub_Category__c = 'Origination';	
        		asset.Agency_Projects__c = project.Id;
        		asset.FULL_Description__c = assetScoring.Id;
        		insert asset;
        		Oblix_Project_Assets__c assetRetrieve = [Select Id, Name, Asset_Scoring_Number__c from Oblix_Project_Assets__c where id =:asset.Id ];
        		Oblix_SOW_Projects__c projectRetrieve = [Select Id, Name, ProjectTotalAssetScore__c from Oblix_SOW_Projects__c where Id =:project.Id];
        		System.debug('###assetRetrieve.Asset_Scoring_Number__c : '+assetRetrieve.Asset_Scoring_Number__c);
        		System.debug('###projectRetrieve.ProjectTotalAssetScore__c : '+projectRetrieve.ProjectTotalAssetScore__c);
        		System.assertequals(assetRetrieve.Asset_Scoring_Number__c, projectRetrieve.ProjectTotalAssetScore__c);
        		
        		asset.FULL_Description__c = assetScoring2.Id;
        		update asset;  
        		
        		delete asset;  
	     }
    }
}