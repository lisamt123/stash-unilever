@isTest
private class Oblix_TR06SowMarketBrandPopulate_Test {

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
	     	MDO_Brand__c brand = new MDO_Brand__c();
	     		brand.Name = 'Food';
	     		brand.status__c = 'active';
	     		insert brand;
	     	MDO_Category__c categoryL3 = new MDO_Category__c();
	     		categoryL3.category_type__c = 'Category';
	     		insert categoryL3;
	     	MDO_Category__c categoryL5 = new MDO_Category__c();
	     		categoryL5.category_type__c = 'Category';
	     		insert categoryL5;
	     	MDO_Category__c categoryBrand = new MDO_Category__c();
	     		categoryBrand.category_type__c = 'Sector';
	     		categoryBrand.parent_L3__c =categoryL3.Id;
	     		categoryBrand.parent_L5__c = categoryL5.Id;
	     		insert categoryBrand;
	     	MDO_CategoryBrands__c mdoCategBrand = new MDO_CategoryBrands__c();
	     		mdoCategBrand.brand_id__c = brand.Id;
	     			mdoCategBrand.product_Category_Id__c = categoryBrand.Id;
	     			insert mdoCategBrand;
	     			
	     	Marketing_SOW__c marketingSow = new Marketing_SOW__c();
        		marketingSow.Active__c = true;
        		marketingSow.Name = 'Marketinf Sow Approval Test';
        		marketingSow.SOW_Status__c = 'Open';
        		marketingSow.OblixBrand__c = brand.Id;
        		insert marketingSow;
        		
        		mdoCategBrand.product_Category_Id__c =null;
        		update mdoCategBrand;
        		
        		update marketingSow;
	     }
    }
}