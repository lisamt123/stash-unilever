public with sharing class Oblix_TestUtils {

    public static final String DEFAULT_MARKETING_SOW_NAME = 'Marketinf Sow Approval Test';
    public static final String SOW_STATUS_OPEN = 'Open';
    public static final String DEFAULT_BRAND_NAME = 'Food';
    public static final String BRAND_STATUS_ACTIVE = 'active';
    public static final String DEFAULT_SMALL_PROD_CAT_NAME = 'testsmallproductcategory';
    public static final String DEFAULT_BIG_PROD_CAT_NAME = 'testbigproductcategory';
    
    private Oblix_TestUtils(){}
    
    public static User createTestUser(){
        Profile profile = [Select Id from Profile where Name='System Administrator' or Name='Système Administrateur'];       
     
        User user = new User(Alias = 'test123', Email = 'standarduser@unilever.com', 
          EmailEncodingKey = 'UTF-8', LastName = 'af test', LanguageLocaleKey = 'en_US', 
          LocaleSidKey = 'en_US', ProfileId = profile.Id,firstname = 'sf test one', 
          TimeZoneSidKey = 'Europe/London',AF_Agency_Fees_User_Type__c = 'Category Finance',isActive = true, 
          UserName = 'testuser@test123321.com');
        insert user; 

        return user;
    }

    public static MDO_Brand__c createBrand(String name, String status){
        MDO_Brand__c brand = new MDO_Brand__c(Name = name,status__c = status);
        insert brand;
        return brand;
    }

    public static String createCountries(Integer numberOfCountriesToCreate){
        String returnedString = '';
        for(Integer counter = 0; counter < numberOfCountriesToCreate; counter++){
            returnedString += 'Country ' + counter + ',';
        }
        returnedString = returnedString.removeEnd(',');
        return returnedString;
    }

    public static Marketing_SOW__c createTestMarketingSow(String name, String status, Id brandId){
        Marketing_SOW__c marketingSow = new Marketing_SOW__c();
        marketingSow.Active__c = true;
        marketingSow.Name = name == null ? DEFAULT_MARKETING_SOW_NAME : name;
        marketingSow.SOW_Status__c = status == null ? SOW_STATUS_OPEN : status;
        marketingSow.OblixBrand__c = brandId;
        marketingSow.SmallProductCategory__c = createSmallProductCategory().id;
        marketingSow.BigOblixProductCategory__c = createBigProductCategory().id;
        marketingSow.Financial_Year__c = 'FY2015';
        insert marketingSow;
        return marketingSow;
    }

    public static MDO_Category__c createSmallProductCategory(){
        MDO_Category__c category = new MDO_Category__c(name = DEFAULT_SMALL_PROD_CAT_NAME);
        insert category;
        return category;
    }

    public static MDO_Category__c createSmallProductCategory(Id parentBigCategoryId){
        MDO_Category__c category = new MDO_Category__c(name = DEFAULT_SMALL_PROD_CAT_NAME, parent_L2__c = parentBigCategoryId);
        insert category;
        return category;
    }

    public static MDO_Category__c createBigProductCategory(){
        MDO_Category__c category = new MDO_Category__c(name = DEFAULT_BIG_PROD_CAT_NAME);
        insert category;
        return category;
    }

    public static MDO_CategoryBrands__c createCategoryBrand(MDO_Category__c category, MDO_Brand__c brand){
        MDO_CategoryBrands__c categoryBrand = new MDO_CategoryBrands__c(product_Category_Id__c = category.Id, brand_id__c = brand.Id);
        insert categoryBrand;
        return categoryBrand;
    }


    public static Oblix_SOW_Projects__c createSowProjects(String name, Id marketingSowId){
        Oblix_SOW_Projects__c project = new Oblix_SOW_Projects__c();
        project.Name = name;
        project.Financial_Year__c = marketingSowId;
        project.Campaign_Countries__c = 'France, UK, Germany';
        insert project;
        return project;
    }

    public static Oblix_Marketing_SOW_Project_Splits__c createSowProjectSplits(Id projectId) {
        Oblix_Marketing_SOW_Project_Splits__c splits = new Oblix_Marketing_SOW_Project_Splits__c();
        splits.Project_Splits__c = projectId;
        insert splits;
        return splits;
    }

    public static Marketing_Basics__c createMarketingBasics(Id marketingSowId){
        Marketing_Basics__c mbasics = new Marketing_Basics__c();
        mbasics.Oblix_SOWMarketing__c = marketingSowId;
        insert mbasics;
        return mbasics;
    }


    public static Oblix_Project_Assets__c createProjectAssets(Id projectId){
        Asset_Scoring__c assetScoring = new Asset_Scoring__c();
        assetScoring.Name = 'Score 2';
        assetScoring.Type__c = 'Static Imagery';
        assetScoring.Sub_Category__c = 'Origination';
        assetScoring.Point_Score__c = 150;
        insert assetScoring;
                
                
        Oblix_Project_Assets__c asset = new Oblix_Project_Assets__c();
        asset.Quantity__c = 2;
        asset.Sub_Category__c = 'Origination';  
        asset.Agency_Projects__c = projectId;
        asset.FULL_Description__c = assetScoring.Id;
        insert asset;

        return asset;
    }

    public static Attachment createAttachment(String name, String body, Id parentId){
        Attachment attach = new Attachment();
        attach.Name = name;
        attach.Body = Blob.valueOf(body);
        attach.ParentId = parentId;
        insert attach;
        return attach; 
    }

    public static Account createAccount(){
        Account acc = new Account();
        acc.Name = 'testAccount';
        insert acc;
        return acc;
    }

    public static Oblix_Calculator__c createCalculator(String name, String floc){
        Oblix_Calculator__c calc = new Oblix_Calculator__c();
        calc.RecordTypeId = Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Country_Box_Number');
        calc.Financial_Year__c = floc;
        calc.Name = name;

        insert calc;
        return calc;
    }

}