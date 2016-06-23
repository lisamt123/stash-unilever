public with sharing class Oblix_TestUtils {

    public static final String DEFAULT_MARKETING_SOW_NAME = 'Marketing Sow Approval Test';
    public static final String SOW_STATUS_OPEN = 'Open';
    public static final String DEFAULT_BRAND_NAME = 'Food';
    public static final String BRAND_STATUS_ACTIVE = 'active';
    public static final String DEFAULT_SMALL_PROD_CAT_NAME = 'testsmallproductcategory';
    public static final String DEFAULT_BIG_PROD_CAT_NAME = 'testbigproductcategory';

    public static final String UTF8 = 'UTF-8';
    public static final String CATEGORY_FINANCE = 'Category Finance';
    public static final String EUROPE_LONDON = 'Europe/London';


    public static final String JOB_STATUS_SYNC_COMPLETED = 'Sync Completed';
    public static final String JOB_STATUS_SYNC_REQUESTED = 'Sync Requested';
    public static final String JOB_STATUS_SYNC_REQUIRED = 'Sync Required';
    
    private static final String EN_US  = 'en_us';
    private Oblix_TestUtils(){}
    
    public static User createTestUser(){
        Profile profile = [Select Id from Profile where Name='System Administrator'];       
     
        User user = new User(Alias = 'test123', Email = 'standarduser@unilever.com', 
          EmailEncodingKey = UTF8, LastName = 'af test', LanguageLocaleKey = EN_US, 
          LocaleSidKey = EN_US, ProfileId = profile.Id,firstname = 'sf test one', 
          TimeZoneSidKey = EUROPE_LONDON,AF_Agency_Fees_User_Type__c = CATEGORY_FINANCE,isActive = true, 
          UserName = 'testuseradmin@test123321.com');
        insert user; 

        return user;
    }
    
    public static User createQA1User(){
        Profile profile = [Select Id from Profile where Name='Marketing User'];       
        PermissionSet permission_set = [SELECT Id FROM PermissionSet WHERE Name = 'Oblix_SWOP_UL_1_V1'];
     
        User user = new User(Alias = 'QA1', Email = 'standarduser@unilever.com.qa1', 
        EmailEncodingKey = UTF8, LastName = 'qa1 test', LanguageLocaleKey = EN_US, 
        LocaleSidKey = EN_US, ProfileId = profile.Id,firstname = 'qa1user', 
        TimeZoneSidKey = EUROPE_LONDON,AF_Agency_Fees_User_Type__c = CATEGORY_FINANCE,isActive = true, 
        UserName = 'testuser@test123321.com');
        insert user; 

        PermissionSetAssignment pa = new PermissionSetAssignment(permissionSetId = permission_set.Id, AssigneeId = user.Id);
        insert pa;

        return user;
    }
    
    public static User createSuperUser(){
        Profile profile = [Select Id from Profile where Name='Marketing User'];       
        PermissionSet permission_set = [SELECT Id FROM PermissionSet WHERE Name = 'Oblix_SWOP_Super_User_V1'];
     
        User user = new User(Alias = 'S_User', Email = 'Super_User_Test@unilever.com.superuser', 
        EmailEncodingKey = UTF8, LastName = 'Super_User_Test test', LanguageLocaleKey = EN_US, 
        LocaleSidKey = EN_US, ProfileId = profile.Id,firstname = 'Super_User_Test', 
        TimeZoneSidKey = EUROPE_LONDON,AF_Agency_Fees_User_Type__c = CATEGORY_FINANCE,isActive = true, 
        UserName = 'Super_User_Test@Super_User_Test123.com');
        insert user; 

        PermissionSetAssignment pa = new PermissionSetAssignment(permissionSetId = permission_set.Id, AssigneeId = user.Id);
        insert pa;

        return user;
    }
    
    public static User createAdminSuperUser(){
        Profile profile = [Select Id from Profile where Name='System Administrator'];       
        PermissionSet permission_set = [SELECT Id FROM PermissionSet WHERE Name = 'Oblix_SWOP_Super_User_V1'];
     
        User user = new User(Alias = 'S_Admin', Email = 'Admin_Super_User_Test@unilever.com.superuser', 
        EmailEncodingKey = UTF8, LastName = 'Admin_Super_User_Test test', LanguageLocaleKey = EN_US, 
        LocaleSidKey = EN_US, ProfileId = profile.Id,firstname = 'Admin_Super_User_Test', 
        TimeZoneSidKey = EUROPE_LONDON,AF_Agency_Fees_User_Type__c = CATEGORY_FINANCE,isActive = true, 
        UserName = 'Admin_Super_User_Test@Admin_Super_User_Test123.com');
        insert user; 

        PermissionSetAssignment pa = new PermissionSetAssignment(permissionSetId = permission_set.Id, AssigneeId = user.Id);
        insert pa;

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

    public static Marketing_SOW__c createTestMarketingSow(String name, String status, Id brandId, Id smallCategoryId, Id bigCategoryId, Id accountId){
        Marketing_SOW__c marketingSow = new Marketing_SOW__c();
        marketingSow.Active__c = true;
        marketingSow.Name_Prefix__c = name == null ? DEFAULT_MARKETING_SOW_NAME : name;
        marketingSow.SOW_Status__c = status == null ? SOW_STATUS_OPEN : status;
        marketingSow.OblixBrand__c = brandId;
        marketingSow.SmallProductCategory__c = smallCategoryId;
        marketingSow.BigOblixProductCategory__c = bigCategoryId;
        marketingSow.Financial_Year__c = 'FY2016';
        marketingSow.Oblix_AgencyEstimate__c = accountId;
        return marketingSow;
    }
    public static Marketing_SOW__c createTestMarketingSow(String name, String status, Id brandId){
        Marketing_SOW__c marketingSow = createTestMarketingSow(name, status, brandId, createSmallProductCategory().id, createBigProductCategory().id, null);
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
        project.Name_Prefix__c = name;
        project.Financial_Year__c = marketingSowId;
        project.Campaign_Countries__c = 'France, UK, Germany';
        System.DEBUG('Project Name : ' + project);
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
        mbasics.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_ID;
        mbasics.Hourly_Rate_or_FTE__c = 10;
        insert mbasics;
        return mbasics;
    }


    public static List<Marketing_Basics__c> createMarketingBasics(Id sow_id, Integer records_to_create){
        List<Marketing_Basics__c> list_records_to_return = new List<Marketing_Basics__c>();

        for (Integer i =0; i<records_to_create; i++){
            list_records_to_return.add(new Marketing_Basics__c(Name = 'TEST_NON_CAMPAIGN_' + i, Oblix_SOWMarketing__c = sow_id ));
        }

        return list_records_to_return;
    }


    public static Oblix_Project_Assets__c createProjectAssets(Id projectId){
        Asset_Scoring__c assetScoring = new Asset_Scoring__c();
        assetScoring.Name = 'Score 2';
        assetScoring.Type__c = 'Static Imagery';
        assetScoring.Sub_Category__c = 'Origination';
        assetScoring.Point_Score__c = 150;
        assetScoring.mdm_id__c = 'ASSET000144';
        insert assetScoring;
                
                
        Oblix_Project_Assets__c asset = new Oblix_Project_Assets__c();
        asset.Quantity__c = 2;
        asset.Sub_Category__c = 'Origination';  
        asset.Agency_Projects__c = projectId;
        asset.FULL_Description__c = assetScoring.Id;
        insert asset;

        return asset;
    }

    public static Oblix_Project_Assets__c createProjectAssets(Id projectId,String name,String type,String subCategory){
        Asset_Scoring__c assetScoring = new Asset_Scoring__c();
        assetScoring.Name = name;
        assetScoring.Type__c = type;
        assetScoring.Sub_Category__c = subCategory;
        assetScoring.Point_Score__c = 150;
        assetScoring.mdm_id__c = 'ASSET000144';
        insert assetScoring;
                
                
        Oblix_Project_Assets__c asset = new Oblix_Project_Assets__c();
        asset.Quantity__c = 2;
        asset.Asset_Type__c = type;
        asset.Sub_Category__c = subCategory;  
        asset.Agency_Projects__c = projectId;
        asset.FULL_Description__c = assetScoring.Id;
        insert asset;
        System.DEBUG('Inserted Asset : ' + asset); 
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


    public static List<Attachment> createAttachment(Id parent_Id, Integer records_to_create ){
        
        List<Attachment> list_attachments = new List<Attachment>();

        for (Integer i = 0 ; i < records_to_create; i++){
            list_attachments.add(new Attachment(Name = 'Unite_Test_Attachment_'+i, Body = Blob.valueOf('Unit Test Attachment Body'), ParentId = parent_Id ));
        }
        
        return list_attachments;
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




    /**************************************************************************************
    *                                                                                     *
    *        Methods without inserts, for bulk inserts / modification before inserts      *
    *                                                                                     *
    **************************************************************************************/

    public static List<Oblix_Settings__c> createOblixCustomSettings(){
        List<Oblix_Settings__c> oblix_settings = new List<Oblix_Settings__c>();

        String settings_json_string = '[{"attributes":{"type":"Oblix_Settings__c"},"Name":"PROJECT_STAGE_BRIEFING","Value__c":"10","Label__c":"Briefing","Attribute_1__c":"1"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"FX_TEXT_MESSAGE","Value__c":"Please note : on %date% fees were automatically updated with the current Unilever Planning rates. This may have resulted in a movement in both campaign and non-campaign fees since you last logged in.","Label__c":"Briefing","Attribute_1__c":""},{"attributes":{"type":"Oblix_Settings__c"},"Name":"FX_DURATION_IN_DAYS","Value__c":"10","Label__c":"","Attribute_1__c":""},{"attributes":{"type":"Oblix_Settings__c"},"Name":"FX_UPDATED_DATE","Value__c":"01/01/2016","Label__c":"","Attribute_1__c":""},{"attributes":{"type":"Oblix_Settings__c"},"Name":"BRAND_LED_GROWTH_LABEL","Value__c":"Brand Led Growth","Label__c":"","Attribute_1__c":""},{"attributes":{"type":"Oblix_Settings__c"},"Name":"INNOVATION_LABEL","Value__c":"Innovation","Label__c":"","Attribute_1__c":""},{"attributes":{"type":"Oblix_Settings__c"},"Name":"PROJECT_STAGE_EXECUTION","Value__c":"25","Label__c":"Creative Execution","Attribute_1__c":"4"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"PROJECT_STAGE_IDEATIOIN","Value__c":"30","Label__c":"Creative Ideation","Attribute_1__c":"3"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"PROJECT_STAGE_PRODUCTION","Value__c":"15","Label__c":"Production","Attribute_1__c":"5"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"PROJECT_STAGE_STRATEGY","Value__c":"20","Label__c":"Strategy & Planning","Attribute_1__c":"2"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_BRAND_GROWTH_10_TO_20","Value__c":"0.25","Label__c":"Incremental Turnover 10M - 20M","Attribute_1__c":"S/M"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_BRAND_GROWTH_20_TO_30","Value__c":"0.35","Label__c":"Incremental Turnover 20M - 30M","Attribute_1__c":"M"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_BRAND_GROWTH_30_TO_40","Value__c":"0.45","Label__c":"Incremental Turnover 30M - 40M","Attribute_1__c":"M/L"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_BRAND_GROWTH_ABOVE_40","Value__c":"0.5","Label__c":"Incremental Turnover >40M","Attribute_1__c":"L"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_BRAND_GROWTH_BELOW_10","Value__c":"0.15","Label__c":"Incremental Turnover <10M","Attribute_1__c":"S"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_HUB_PARENTERS_1","Value__c":"0.1","Label__c":"1 location"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_HUB_PARENTERS_2","Value__c":"0.15","Label__c":"Up to 2 locations"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_HUB_PARENTERS_3","Value__c":"0.2","Label__c":"Up to 3 locations"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_HUB_PARENTERS_4","Value__c":"0.25","Label__c":"Up to 4 locations"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_HUB_PARENTERS_5","Value__c":"0.3","Label__c":"Up to 5 locations"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_IDEA_EXISTING","Value__c":"0.6","Label__c":"Existing"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_IDEA_NEW_MULTI","Value__c":"1.2","Label__c":"New – Multi channel"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_IDEA_NEW_ONE","Value__c":"1","Label__c":"New – One channel"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_PROJECT_MARKET_1","Value__c":"0.15","Label__c":"Local campaign, single language only"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_PROJECT_MARKET_2","Value__c":"0.25","Label__c":"Local / regional campaign, mutiple languages (5)"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_PROJECT_MARKET_3","Value__c":"0.35","Label__c":"Multiple countries (5-10), multiple language (5-10)"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_PROJECT_MARKET_4","Value__c":"0.45","Label__c":"Multiple countries (11-15), mutiple language (c.15)"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_PROJECT_MARKET_5","Value__c":"0.5","Label__c":"Global campaign (all market clusters)"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_TURNOVER_100_TO_200","Value__c":"0.25","Label__c":"Total turnover €100-€200m","Attribute_1__c":"S/M"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_TURNOVER_200_TO_300","Value__c":"0.35","Label__c":"Total turnover €200-€300m","Attribute_1__c":"M"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_TURNOVER_300_TO_400","Value__c":"0.45","Label__c":"Total turnover €300-€400m","Attribute_1__c":"M/L"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_TURNOVER_ABOVE_400","Value__c":"0.5","Label__c":"Total turnover >€400m","Attribute_1__c":"L"},{"attributes":{"type":"Oblix_Settings__c"},"Name":"SCORE_INNOVATION_TURNOVER_BELOW_100","Value__c":"0.15","Label__c":"Total turnover <€100m","Attribute_1__c":"S"}]';
        oblix_settings = (list<Oblix_Settings__c>) json.deserialize(settings_json_string,list<Oblix_Settings__c>.class);

        return oblix_settings;
    }

    public static List<Oblix_FX_Change__c> createOblixFXChangeCustomSetting(){
        List<Oblix_FX_Change__c> retList = new List<Oblix_FX_Change__c>();

        Oblix_FX_Change__c csRec = new Oblix_FX_Change__c();

        csRec.SetupOwnerId = UserInfo.getOrganizationId();
        csRec.Acknowledged__c = false;
        csRec.FX_Date__c = '01/01/2015';
        csRec.Org_FX_Date__c = Date.Today();
        retList.add(csRec);
        
        return retList;
    }

    public static List<Oblix_Job_Orchestration__c> createOblixJobOrchestrationCustomSetting(){
        List<Oblix_Job_Orchestration__c> retList = new List<Oblix_Job_Orchestration__c>();

        Oblix_Job_Orchestration__c csRec = new Oblix_Job_Orchestration__c();

        csRec.SetupOwnerId = UserInfo.getOrganizationId();
        csRec.Job_Is_Running__c = false;
        retList.add(csRec);
        
        return retList;
    }


    public static Map<Id, Oblix_SOW_Projects__c> insertCampaignsWithRelatedRecords(Integer number_of_campaigns,Integer  number_of_assets,Integer  number_of_hubs, Id sow_id,String brand_led_growth, String scale_1, String scale_2, String campaign_idea ){

        

        // Brand_Led_Growth__c: Total turnover €300-€400m = 0.45
        // Project_Scale_1__c: Multiple countries (5-10), multiple language (5-10) = 0.35
        // Project_Scale_2__c: Up to 4 locations = 0.25
        // Campaign_Idea__c: Existing = 0.6

        insert createCampaigns(number_of_campaigns, sow_id, brand_led_growth, scale_1, scale_2, campaign_idea);

        Map<Id, Oblix_SOW_Projects__c> map_campaigns_with_related = new Map<Id, Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>)
            [SELECT Name, Financial_Year__c, Campaign_Countries__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c FROM Oblix_SOW_Projects__c LIMIT 1000]);
        

        List<Oblix_Marketing_SOW_Project_Splits__c> list_project_splits = new List<Oblix_Marketing_SOW_Project_Splits__c>();
        List<Oblix_Project_Assets__c> list_assets_to_create = new List<Oblix_Project_Assets__c>();


        for (Id campaign_id: map_campaigns_with_related.keySet()){

            list_project_splits.addAll(createProjectSplits(campaign_id, number_of_hubs));
            list_assets_to_create.addAll(createProjectAssets(campaign_id, number_of_assets));
        }

        insert list_project_splits;
        insert list_assets_to_create;


        map_campaigns_with_related = new Map<Id, Oblix_SOW_Projects__c>((List<Oblix_SOW_Projects__c>) [SELECT Id,Agency_Percentage_of_Fees_to_this_FY__c,Asset_Deliverables__c,BET_first_release__c,Brand_Led_Growth__c,Budget_Burnt_to_date__c,Campaign_Countries__c,Campaign_Fees_Total__c
            ,Campaign_Hub_Summary__c,Campaign_Idea__c,Campaign_Points__c,Campaign_Score__c,Campaign_Splits_Total__c,Campaign_Status__c,Campaign_Total_Adjustment__c,Campaign_Total_Fees__c,Financial_Year__r.Financial_Year__c
            ,Completed_Stage__c,Date_for_Assets_to_be_in_BET__c,Description__c,Fees_To_Be_Paid_Next_Financial_Year__c,Final_release__c,Financial_Year__c,First_Air_Date__c
            ,Innovation_Projects__c,IsDeleted,Is_this_High_Risk__c,Is_type_of_item_usually_poduced_by_this__c,Jobs_to_be_Done__c,List_Preview_Markets__c,Live_date_Asset_delivery__c,Live_Date__c
            ,Name,Number_of_Agency_Hub_Splits__c,Number_of_Markets_for_Preview__c,Number_of_Previews__c,OblixClonedFromParentProject__c,OblixProjectSplitPercentage_Comment__c,OblixRegion__c
            ,Oblix_ProjectBoxNumber__c,Other_Kinds_of_Research__c,Overall_Project_Complete__c,Percentage_of_Fee_for_Next_FY__c,Percentage_of_Fee_for_this_FY__c,Platform__c,Preview_Date__c
            ,Production_Completion_Date__c,Projected_Stage__c,ProjectTotalAssetscore__c,Project_Completion_Date__c,Project_Finish_Date__c,Project_Priority__c,Project_Scale_1__c,Project_Scale_2__c
            ,Project_Stage__c,Project_Start_Date__c,Region__c,Selected_Countries__c, First_3_selected_countries__c,Should_legal_review_this_project__c,Start_of_TV_production__c,Stimulus_Requirements__c,Timescale_Notes__c
            ,Total_Adapt_Fees__c,Total_Asset_Deliverables__c,Total_Digital_Fee__c,Total_Fees_for_Project__c,Total_Locations__c,Total_Project_Score__c,Total_Value_Driver__c,Value_To_BePaid_Manual_Override__c
            ,Value_to_be_paid_in_Current_FY__c, (SELECT Actual_Delivery_Date__c,Additional_Description__c,Agency_Projects__c,Asset_Description__c,Asset_name__c,Asset_Picklist__c,Asset_Scoring_Number__c
            ,Asset_Title__c,Asset_Total_Score__c,Asset_Type__c,Calculator_Question__c,Category__c,Channels__c,FULL_Description__c,Description__c,Location__c,Name,OblixClonedFromParentAsset__c,Option_Name__c,Quantity__c
            ,RecordTypeId,Sub_Category__c,SystemModstamp,Target_Delivery_Date__c,MDM_id__c,Asset_Score__c FROM Agency_Project_Assets__r)
            , (SELECT Name,OblixCountry__c,Percentage__c,Project_Splits__c,OblixCountry__r.Name FROM Marketing_SOW_Project_Splits__r) 
            FROM Oblix_SOW_Projects__c WHERE Id in : map_campaigns_with_related.keySet()]);


        return map_campaigns_with_related;

    }



    public static List<Oblix_SOW_Projects__c> createCampaigns(Integer number_of_campaigns, Id sow_id, String brand_led_growth, String scale_1, String scale_2, String campaign_idea ){

        List<Oblix_SOW_Projects__c> list_new_campaigns = new List<Oblix_SOW_Projects__c>();

        Oblix_SOW_Projects__c project;

        for (Integer cam_num = 1; cam_num <= number_of_campaigns; cam_num ++){
            project = new Oblix_SOW_Projects__c();

            // make sure it is a unique name
            project.Name_Prefix__c = 'TEST_CAMPAIGN_' + date.today().format() + '_' +cam_num; 
            project.Financial_Year__c = sow_id;
            project.Campaign_Countries__c = 'France, UK, Germany';

            // set 4 attributes
            project.Brand_Led_Growth__c = brand_led_growth;
            project.Project_Scale_1__c = scale_1;
            project.Project_Scale_2__c = scale_2;
            project.Campaign_Idea__c = campaign_idea;
            
            project.Percentage_of_Fee_for_this_FY__c = 22.5;
            project.Percentage_of_Fees_PFY__c = 22.5;
            project.Total_Fees_for_Project__c = 12000;
            project.Campaign_Total_Adjustment__c = 10;
            project.Fees_PFY_Paid_Using_CFY_Calc__c = 100;
            list_new_campaigns.add(project);
        }

        return list_new_campaigns;
    }

    public static List<Oblix_Marketing_SOW_Project_Splits__c> createProjectSplits(Id campaign_id, Integer number_of_splits){

        // example: 3 splits, first 2 will have 30% and the third will have 40%
        Integer even_splits_portion = 100/number_of_splits;
        Integer final_split_portion = 100 - ((number_of_splits - 1) * even_splits_portion);

        List<Oblix_Marketing_SOW_Project_Splits__c> list_project_splits = new List<Oblix_Marketing_SOW_Project_Splits__c>();

        List<MDO_Geography__c> list_mdo_geography = createMDOgeography();
        insert list_mdo_geography;


        list_mdo_geography = [SELECT Name FROM MDO_Geography__c WHERE geography_type__c = 'Country'];

        Oblix_Marketing_SOW_Project_Splits__c split;

        for (Integer split_num = 1; split_num <= number_of_splits; split_num++){
            split = new Oblix_Marketing_SOW_Project_Splits__c();
            split.Project_Splits__c = campaign_id;
            // get a random country split
            split.OblixCountry__c =  list_mdo_geography[Math.round(Math.random() * (2 - 0)) + 0].Id;

            // final loop? check if need to add left over
            if (split_num == number_of_splits && final_split_portion > 0){
                split.Percentage__c = final_split_portion;
            }
            else{
                split.Percentage__c = even_splits_portion;
            }

            list_project_splits.add(split);
        }

        return list_project_splits;

    }

    public static List<Oblix_Project_Assets__c> createProjectAssets(Id campaign_id, Integer number_of_assets_to_create){

        List<Oblix_Project_Assets__c> list_assets_to_create = new List<Oblix_Project_Assets__c>();

        for (Asset_Scoring__c score: createAssetScoringRecords(number_of_assets_to_create)){
            Oblix_Project_Assets__c asset = new Oblix_Project_Assets__c();
            asset.Asset_Type__c = score.Type__c;
            asset.Sub_Category__c = score.Sub_Category__c;
            asset.Option_Name__c = score.Asset_Option__c;
            asset.Asset_name__c = score.Asset_name__c;
            asset.Asset_score__c = score.Point_Score__c;
            asset.mdm_id__c = score.mdm_id__c;
            // set a random quantity
            asset.Quantity__c = Math.round(Math.random() * (10 - 1)) + 1;
            asset.Agency_Projects__c  = campaign_id;

            list_assets_to_create.add(asset);
        }

        return list_assets_to_create;
    }


    public static List<Oblix_Project_Assets__c> createLimitedNumberOfProjectAssets(Id campaign_id, Integer number_of_assets_to_create){

        List<Oblix_Project_Assets__c> list_assets_to_create = new List<Oblix_Project_Assets__c>();
        List<Asset_Scoring__c> assetScorings = createAssetScoringRecords(number_of_assets_to_create);

        //createAssetScoringRecords always returns fixed number of asset scores.
        //Make sure we don't create more Campaign Assets than there are asset scores
        Integer assetCount = Math.min(number_of_assets_to_create, assetScorings.size());

        for (Integer i = 0; i < assetCount; i++) {
            Asset_Scoring__c score = assetScorings[i];
            Oblix_Project_Assets__c asset = new Oblix_Project_Assets__c();
            asset.Asset_Type__c = score.Type__c;
            asset.Sub_Category__c = score.Sub_Category__c;
            asset.Option_Name__c = score.Asset_Option__c;
            asset.Asset_name__c = score.Asset_name__c;
            asset.Asset_score__c = score.Point_Score__c;
            asset.mdm_id__c = score.mdm_id__c;
            // set a random quantity
            asset.Quantity__c = Math.round(Math.random() * (10 - 1)) + 1;
            asset.Agency_Projects__c  = campaign_id;

            list_assets_to_create.add(asset);
        }

        return list_assets_to_create;
    }

    public static List<Oblix_Calculator__c> createCountryCalculatorRecords(){

        //List<Oblix_Calculator__c> list_calculator_records = new List<Oblix_Calculator__c>();

        Id record_type_id = Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Country_Box_Number');

        String country_calc_json = '[{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":17750.00,"Box_2__c":31950.00,"Box_3__c":46150.00,"Box_4__c":71000.00,"Box_5__c":99400.00,"Box_6__c":134900.00,"Box_7__c":163300.00,"Box_8__c":188150.00,"Box_9__c":213000.00,"Box_10__c":227200.00,"Box_11__c":244950.00,"Box_12__c":266250.00,"Box_13__c":291100.00,"Box_14__c":305300.00,"Box_15__c":376300.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"DUBAI","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":13750.00,"Box_2__c":24750.00,"Box_3__c":35750.00,"Box_4__c":55000.00,"Box_5__c":77000.00,"Box_6__c":104500.00,"Box_7__c":126500.00,"Box_8__c":145750.00,"Box_9__c":165000.00,"Box_10__c":176000.00,"Box_11__c":189750.00,"Box_12__c":206250.00,"Box_13__c":225500.00,"Box_14__c":236500.00,"Box_15__c":291500.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"INDONESIA","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":20000.00,"Box_2__c":36000.00,"Box_3__c":52000.00,"Box_4__c":80000.00,"Box_5__c":112000.00,"Box_6__c":152000.00,"Box_7__c":184000.00,"Box_8__c":212000.00,"Box_9__c":240000.00,"Box_10__c":256000.00,"Box_11__c":276000.00,"Box_12__c":300000.00,"Box_13__c":328000.00,"Box_14__c":344000.00,"Box_15__c":424000.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"ITALY","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":22500.00,"Box_2__c":40500.00,"Box_3__c":58500.00,"Box_4__c":90000.00,"Box_5__c":126000.00,"Box_6__c":171000.00,"Box_7__c":207000.00,"Box_8__c":238500.00,"Box_9__c":270000.00,"Box_10__c":288000.00,"Box_11__c":310500.00,"Box_12__c":337500.00,"Box_13__c":369000.00,"Box_14__c":387000.00,"Box_15__c":477000.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"JAPAN","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":13750.00,"Box_2__c":24750.00,"Box_3__c":35750.00,"Box_4__c":55000.00,"Box_5__c":77000.00,"Box_6__c":104500.00,"Box_7__c":126500.00,"Box_8__c":145750.00,"Box_9__c":165000.00,"Box_10__c":176000.00,"Box_11__c":189750.00,"Box_12__c":206250.00,"Box_13__c":225500.00,"Box_14__c":236500.00,"Box_15__c":291500.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"MEXICO","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":22000.00,"Box_2__c":39600.00,"Box_3__c":57200.00,"Box_4__c":88000.00,"Box_5__c":123200.00,"Box_6__c":167200.00,"Box_7__c":202400.00,"Box_8__c":233200.00,"Box_9__c":264000.00,"Box_10__c":281600.00,"Box_11__c":303600.00,"Box_12__c":330000.00,"Box_13__c":360800.00,"Box_14__c":378400.00,"Box_15__c":466400.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"SINGAPORE","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":14500.00,"Box_2__c":26100.00,"Box_3__c":37700.00,"Box_4__c":58000.00,"Box_5__c":81200.00,"Box_6__c":110200.00,"Box_7__c":133400.00,"Box_8__c":153700.00,"Box_9__c":174000.00,"Box_10__c":185600.00,"Box_11__c":200100.00,"Box_12__c":217500.00,"Box_13__c":237800.00,"Box_14__c":249400.00,"Box_15__c":307400.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"SOUTH AFRICA","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":14000.00,"Box_2__c":25200.00,"Box_3__c":36400.00,"Box_4__c":56000.00,"Box_5__c":78400.00,"Box_6__c":106400.00,"Box_7__c":128800.00,"Box_8__c":148400.00,"Box_9__c":168000.00,"Box_10__c":179200.00,"Box_11__c":193200.00,"Box_12__c":210000.00,"Box_13__c":229600.00,"Box_14__c":240800.00,"Box_15__c":296800.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"THAILAND","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":16750.00,"Box_2__c":30150.00,"Box_3__c":43550.00,"Box_4__c":67000.00,"Box_5__c":93800.00,"Box_6__c":127300.00,"Box_7__c":154100.00,"Box_8__c":177550.00,"Box_9__c":201000.00,"Box_10__c":214400.00,"Box_11__c":231150.00,"Box_12__c":251250.00,"Box_13__c":274700.00,"Box_14__c":288100.00,"Box_15__c":355100.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"TURKEY","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":25000.00,"Box_2__c":45000.00,"Box_3__c":65000.00,"Box_4__c":100000.00,"Box_5__c":140000.00,"Box_6__c":190000.00,"Box_7__c":230000.00,"Box_8__c":265000.00,"Box_9__c":300000.00,"Box_10__c":320000.00,"Box_11__c":345000.00,"Box_12__c":375000.00,"Box_13__c":410000.00,"Box_14__c":430000.00,"Box_15__c":530000.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"UK & IRELAND","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":17750.00,"Box_2__c":31950.00,"Box_3__c":46150.00,"Box_4__c":71000.00,"Box_5__c":99400.00,"Box_6__c":134900.00,"Box_7__c":163300.00,"Box_8__c":188150.00,"Box_9__c":213000.00,"Box_10__c":227200.00,"Box_11__c":244950.00,"Box_12__c":266250.00,"Box_13__c":291100.00,"Box_14__c":305300.00,"Box_15__c":376300.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"UNITED ARAB EMIRATES","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":26250.00,"Box_2__c":47250.00,"Box_3__c":68250.00,"Box_4__c":105000.00,"Box_5__c":147000.00,"Box_6__c":199500.00,"Box_7__c":241500.00,"Box_8__c":278250.00,"Box_9__c":315000.00,"Box_10__c":336000.00,"Box_11__c":362250.00,"Box_12__c":393750.00,"Box_13__c":430500.00,"Box_14__c":451500.00,"Box_15__c":556500.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"UNITED STATES OF AMERICA","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":15750.00,"Box_2__c":28350.00,"Box_3__c":40950.00,"Box_4__c":63000.00,"Box_5__c":88200.00,"Box_6__c":119700.00,"Box_7__c":144900.00,"Box_8__c":166950.00,"Box_9__c":189000.00,"Box_10__c":201600.00,"Box_11__c":217350.00,"Box_12__c":236250.00,"Box_13__c":258300.00,"Box_14__c":270900.00,"Box_15__c":333900.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"VENEZUELA","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":10750.00,"Box_2__c":19350.00,"Box_3__c":27950.00,"Box_4__c":43000.00,"Box_5__c":60200.00,"Box_6__c":81700.00,"Box_7__c":98900.00,"Box_8__c":113950.00,"Box_9__c":129000.00,"Box_10__c":137600.00,"Box_11__c":148350.00,"Box_12__c":161250.00,"Box_13__c":176300.00,"Box_14__c":184900.00,"Box_15__c":227900.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"VIETNAM","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":15000.00,"Box_2__c":27000.00,"Box_3__c":39000.00,"Box_4__c":60000.00,"Box_5__c":84000.00,"Box_6__c":114000.00,"Box_7__c":138000.00,"Box_8__c":159000.00,"Box_9__c":180000.00,"Box_10__c":192000.00,"Box_11__c":207000.00,"Box_12__c":225000.00,"Box_13__c":246000.00,"Box_14__c":258000.00,"Box_15__c":318000.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"MALAYSIA","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":20500.00,"Box_2__c":36900.00,"Box_3__c":53300.00,"Box_4__c":82000.00,"Box_5__c":114800.00,"Box_6__c":155800.00,"Box_7__c":188600.00,"Box_8__c":217300.00,"Box_9__c":246000.00,"Box_10__c":262400.00,"Box_11__c":282900.00,"Box_12__c":307500.00,"Box_13__c":336200.00,"Box_14__c":352600.00,"Box_15__c":434600.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"SPAIN","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":19750.00,"Box_2__c":35550.00,"Box_3__c":51350.00,"Box_4__c":79000.00,"Box_5__c":110600.00,"Box_6__c":150100.00,"Box_7__c":181700.00,"Box_8__c":209350.00,"Box_9__c":237000.00,"Box_10__c":252800.00,"Box_11__c":272550.00,"Box_12__c":296250.00,"Box_13__c":323900.00,"Box_14__c":339700.00,"Box_15__c":418700.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"NETHERLANDS","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":13000.00,"Box_2__c":23400.00,"Box_3__c":33800.00,"Box_4__c":52000.00,"Box_5__c":72800.00,"Box_6__c":98800.00,"Box_7__c":119600.00,"Box_8__c":137800.00,"Box_9__c":156000.00,"Box_10__c":166400.00,"Box_11__c":179400.00,"Box_12__c":195000.00,"Box_13__c":213200.00,"Box_14__c":223600.00,"Box_15__c":275600.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"SRI LANKA","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":24000.00,"Box_2__c":43200.00,"Box_3__c":62400.00,"Box_4__c":96000.00,"Box_5__c":134400.00,"Box_6__c":182400.00,"Box_7__c":220800.00,"Box_8__c":254400.00,"Box_9__c":288000.00,"Box_10__c":307200.00,"Box_11__c":331200.00,"Box_12__c":360000.00,"Box_13__c":393600.00,"Box_14__c":412800.00,"Box_15__c":508800.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"SWEDEN","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":10750.00,"Box_2__c":19350.00,"Box_3__c":27950.00,"Box_4__c":43000.00,"Box_5__c":60200.00,"Box_6__c":81700.00,"Box_7__c":98900.00,"Box_8__c":113950.00,"Box_9__c":129000.00,"Box_10__c":137600.00,"Box_11__c":148350.00,"Box_12__c":161250.00,"Box_13__c":176300.00,"Box_14__c":184900.00,"Box_15__c":227900.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"PAKISTAN","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":12000.00,"Box_2__c":21600.00,"Box_3__c":31200.00,"Box_4__c":48000.00,"Box_5__c":67200.00,"Box_6__c":91200.00,"Box_7__c":110400.00,"Box_8__c":127200.00,"Box_9__c":144000.00,"Box_10__c":153600.00,"Box_11__c":165600.00,"Box_12__c":180000.00,"Box_13__c":196800.00,"Box_14__c":206400.00,"Box_15__c":254400.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"PHILIPPINES","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":19000.00,"Box_2__c":34200.00,"Box_3__c":49400.00,"Box_4__c":76000.00,"Box_5__c":106400.00,"Box_6__c":144400.00,"Box_7__c":174800.00,"Box_8__c":201400.00,"Box_9__c":228000.00,"Box_10__c":243200.00,"Box_11__c":262200.00,"Box_12__c":285000.00,"Box_13__c":311600.00,"Box_14__c":326800.00,"Box_15__c":402800.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"POLAND","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":19250.00,"Box_2__c":34650.00,"Box_3__c":50050.00,"Box_4__c":77000.00,"Box_5__c":107800.00,"Box_6__c":146300.00,"Box_7__c":177100.00,"Box_8__c":204050.00,"Box_9__c":231000.00,"Box_10__c":246400.00,"Box_11__c":265650.00,"Box_12__c":288750.00,"Box_13__c":315700.00,"Box_14__c":331100.00,"Box_15__c":408100.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"RUSSIAN FEDERATION","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":13250.00,"Box_2__c":23850.00,"Box_3__c":34450.00,"Box_4__c":53000.00,"Box_5__c":74200.00,"Box_6__c":100700.00,"Box_7__c":121900.00,"Box_8__c":140450.00,"Box_9__c":159000.00,"Box_10__c":169600.00,"Box_11__c":182850.00,"Box_12__c":198750.00,"Box_13__c":217300.00,"Box_14__c":227900.00,"Box_15__c":280900.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"INDIA","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":21250.00,"Box_2__c":38250.00,"Box_3__c":55250.00,"Box_4__c":85000.00,"Box_5__c":119000.00,"Box_6__c":161500.00,"Box_7__c":195500.00,"Box_8__c":225250.00,"Box_9__c":255000.00,"Box_10__c":272000.00,"Box_11__c":293250.00,"Box_12__c":318750.00,"Box_13__c":348500.00,"Box_14__c":365500.00,"Box_15__c":450500.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"CHINA","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":21250.00,"Box_2__c":38250.00,"Box_3__c":55250.00,"Box_4__c":85000.00,"Box_5__c":119000.00,"Box_6__c":161500.00,"Box_7__c":195500.00,"Box_8__c":225250.00,"Box_9__c":255000.00,"Box_10__c":272000.00,"Box_11__c":293250.00,"Box_12__c":318750.00,"Box_13__c":348500.00,"Box_14__c":365500.00,"Box_15__c":450500.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"FRANCE","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":15000.00,"Box_2__c":27000.00,"Box_3__c":39000.00,"Box_4__c":60000.00,"Box_5__c":84000.00,"Box_6__c":114000.00,"Box_7__c":138000.00,"Box_8__c":159000.00,"Box_9__c":180000.00,"Box_10__c":192000.00,"Box_11__c":207000.00,"Box_12__c":225000.00,"Box_13__c":246000.00,"Box_14__c":258000.00,"Box_15__c":318000.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"ARGENTINA","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":23000.00,"Box_2__c":41400.00,"Box_3__c":59800.00,"Box_4__c":92000.00,"Box_5__c":128800.00,"Box_6__c":174800.00,"Box_7__c":211600.00,"Box_8__c":243800.00,"Box_9__c":276000.00,"Box_10__c":294400.00,"Box_11__c":317400.00,"Box_12__c":345000.00,"Box_13__c":377200.00,"Box_14__c":395600.00,"Box_15__c":487600.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"AUSTRALIA","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":7000.00,"Box_2__c":12600.00,"Box_3__c":18200.00,"Box_4__c":28000.00,"Box_5__c":39200.00,"Box_6__c":53200.00,"Box_7__c":64400.00,"Box_8__c":74200.00,"Box_9__c":84000.00,"Box_10__c":89600.00,"Box_11__c":96600.00,"Box_12__c":105000.00,"Box_13__c":114800.00,"Box_14__c":120400.00,"Box_15__c":148400.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"BANGLADESH","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":22500.00,"Box_2__c":40500.00,"Box_3__c":58500.00,"Box_4__c":90000.00,"Box_5__c":126000.00,"Box_6__c":171000.00,"Box_7__c":207000.00,"Box_8__c":238500.00,"Box_9__c":270000.00,"Box_10__c":288000.00,"Box_11__c":310500.00,"Box_12__c":337500.00,"Box_13__c":369000.00,"Box_14__c":387000.00,"Box_15__c":477000.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"GERMANY","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":22500.00,"Box_2__c":40500.00,"Box_3__c":58500.00,"Box_4__c":90000.00,"Box_5__c":126000.00,"Box_6__c":171000.00,"Box_7__c":207000.00,"Box_8__c":238500.00,"Box_9__c":270000.00,"Box_10__c":288000.00,"Box_11__c":310500.00,"Box_12__c":337500.00,"Box_13__c":369000.00,"Box_14__c":387000.00,"Box_15__c":477000.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"BRAZIL","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":20000.00,"Box_2__c":36000.00,"Box_3__c":52000.00,"Box_4__c":80000.00,"Box_5__c":112000.00,"Box_6__c":152000.00,"Box_7__c":184000.00,"Box_8__c":212000.00,"Box_9__c":240000.00,"Box_10__c":256000.00,"Box_11__c":276000.00,"Box_12__c":300000.00,"Box_13__c":328000.00,"Box_14__c":344000.00,"Box_15__c":424000.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"HONG KONG","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":19000.00,"Box_2__c":34200.00,"Box_3__c":49400.00,"Box_4__c":76000.00,"Box_5__c":106400.00,"Box_6__c":144400.00,"Box_7__c":174800.00,"Box_8__c":201400.00,"Box_9__c":228000.00,"Box_10__c":243200.00,"Box_11__c":262200.00,"Box_12__c":285000.00,"Box_13__c":311600.00,"Box_14__c":326800.00,"Box_15__c":402800.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"CANADA","RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Box_1__c":16500.00,"Box_2__c":29700.00,"Box_3__c":42900.00,"Box_4__c":66000.00,"Box_5__c":92400.00,"Box_6__c":125400.00,"Box_7__c":151800.00,"Box_8__c":174900.00,"Box_9__c":198000.00,"Box_10__c":211200.00,"Box_11__c":227700.00,"Box_12__c":247500.00,"Box_13__c":270600.00,"Box_14__c":283800.00,"Box_15__c":349800.00,"Financial_Year__c":"FY2016"';
        country_calc_json += ',"Name":"CHILE","RecordTypeId":"REC_TO_REPLACE"}]';

        // replace the record type for the intended environment
        country_calc_json = country_calc_json.replace('REC_TO_REPLACE', record_type_id);
        system.debug('calculator_string: '+country_calc_json);

        List<Oblix_Calculator__c> list_calculator_records = (List<Oblix_Calculator__c>) json.deserialize(country_calc_json,list<Oblix_Calculator__c>.class);

        


        // box_1__c: 20, box_2__c: 40, box_3__c: 60, ..., box__20__c: 400, FY: 2016, Name: UK & IRELAND
        // box_1__c: 30, box_2__c: 60, box_3__c: 90, ..., box__20__c: 600, FY: 2016, Name: SPAIN



        //Oblix_Calculator__c calc;

        //calc = new Oblix_Calculator__c();

        //calc.Financial_Year__c = 'FY2016';

        //// set box range
        //for (Integer box_num = 1; box_num <= 20; box_num ++){
        //    String field_name = 'Box_' + box_num + '__c';
        //    calc.put(field_name, box_num*20);
        //}

        //calc.Name = 'UK & IRELAND';

        //list_calculator_records.add(calc);

        //calc = new Oblix_Calculator__c();

        //calc.Financial_Year__c = 'FY2016';

        //// set box range
        //for (Integer box_num = 1; box_num <= 20; box_num ++){
        //    String field_name = 'Box_' + box_num + '__c';
        //    calc.put(field_name, box_num*30);
        //}

        //calc.Name = 'SPAIN';

        //list_calculator_records.add(calc);

        return list_calculator_records;

    }



    public static List<Oblix_Calculator__c> createRoleRateCalculatorRecords(Id countryId, Id agencyId){

        String country_calc_json = '';
        country_calc_json += '[{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.288", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.945", "Role_Title__c":"Art Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.2881", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.946", "Role_Title__c":"Copywriter", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.2882", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.945", "Role_Title__c":"Creative Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Analytics", "Financial_Year__c":"FY2016", "FTE__c":"50000.2883", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.946", "Role_Title__c":"Data Analyst", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.2884", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.947", "Role_Title__c":"Designer", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Planning", "Financial_Year__c":"FY2016", "FTE__c":"50000.2885", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.946", "Role_Title__c":"Digital Planning Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Technology", "Financial_Year__c":"FY2016", "FTE__c":"50000.2886", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.947", "Role_Title__c":"Information Architect", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.2887", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.948", "Role_Title__c":"Junior Art Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.2888", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.947", "Role_Title__c":"Junior Copywriter", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Production", "Financial_Year__c":"FY2016", "FTE__c":"50000.2889", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.948", "Role_Title__c":"Junior Project Manager", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Planning", "Financial_Year__c":"FY2016", "FTE__c":"50000.289", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.949", "Role_Title__c":"Planner", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Production", "Financial_Year__c":"FY2016", "FTE__c":"50000.2891", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.948", "Role_Title__c":"Project Manager", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.2894", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.949", "Role_Title__c":"Senior Art Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.2895", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.95", "Role_Title__c":"Senior Designer", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Planning", "Financial_Year__c":"FY2016", "FTE__c":"50000.2896", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.951", "Role_Title__c":"Senior Planner", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Production", "Financial_Year__c":"FY2016", "FTE__c":"50000.2897", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.95", "Role_Title__c":"Senior Project Manager", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Technology", "Financial_Year__c":"FY2016", "FTE__c":"50000.2898", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.951", "Role_Title__c":"Senior Software Developer", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Technology", "Financial_Year__c":"FY2016", "FTE__c":"50000.2899", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.952", "Role_Title__c":"Software Developer", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Technology", "Financial_Year__c":"FY2016", "FTE__c":"50000.29", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.951", "Role_Title__c":"Technology Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Technology", "Financial_Year__c":"FY2016", "FTE__c":"50000.2901", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.952", "Role_Title__c":"Technology Manager", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Technology", "Financial_Year__c":"FY2016", "FTE__c":"50000.2902", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.953", "Role_Title__c":"Tester", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.6337", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.2098", "Role_Title__c":"Art Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.6338", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.2097", "Role_Title__c":"Copywriter", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.6339", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.2098", "Role_Title__c":"Creative Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Analytics", "Financial_Year__c":"FY2016", "FTE__c":"50000.634", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.2099", "Role_Title__c":"Data Analyst", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.6341", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.2098", "Role_Title__c":"Designer", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Planning", "Financial_Year__c":"FY2016", "FTE__c":"50000.6342", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.2099", "Role_Title__c":"Digital Planning Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Technology", "Financial_Year__c":"FY2016", "FTE__c":"50000.6343", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.21", "Role_Title__c":"Information Architect", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.6344", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.2099", "Role_Title__c":"Junior Art Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.6345", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.21", "Role_Title__c":"Junior Copywriter", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Production", "Financial_Year__c":"FY2016", "FTE__c":"50000.6346", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.2101", "Role_Title__c":"Junior Project Manager", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Planning", "Financial_Year__c":"FY2016", "FTE__c":"50000.6347", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.21", "Role_Title__c":"Planner", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Production", "Financial_Year__c":"FY2016", "FTE__c":"50000.6348", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.2101", "Role_Title__c":"Project Manager", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.6351", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.2102", "Role_Title__c":"Senior Art Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Creative", "Financial_Year__c":"FY2016", "FTE__c":"50000.6352", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.2103", "Role_Title__c":"Senior Designer", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Planning", "Financial_Year__c":"FY2016", "FTE__c":"50000.6353", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.2102", "Role_Title__c":"Senior Planner", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Production", "Financial_Year__c":"FY2016", "FTE__c":"50000.6354", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.2103", "Role_Title__c":"Senior Project Manager", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Technology", "Financial_Year__c":"FY2016", "FTE__c":"50000.6355", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.2104", "Role_Title__c":"Senior Software Developer", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Technology", "Financial_Year__c":"FY2016", "FTE__c":"50000.6356", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.2103", "Role_Title__c":"Software Developer", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Technology", "Financial_Year__c":"FY2016", "FTE__c":"50000.6357", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.2104", "Role_Title__c":"Technology Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Technology", "Financial_Year__c":"FY2016", "FTE__c":"50000.6358", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.2105", "Role_Title__c":"Technology Manager", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Technology", "Financial_Year__c":"FY2016", "FTE__c":"50000.6359", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.2104", "Role_Title__c":"Tester", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Account Management", "Financial_Year__c":"FY2016", "FTE__c":"50000.2877", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.944", "Role_Title__c":"Account Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Account Management", "Financial_Year__c":"FY2016", "FTE__c":"50000.2878", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.945", "Role_Title__c":"Account Executive", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Account Management", "Financial_Year__c":"FY2016", "FTE__c":"50000.2879", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.944", "Role_Title__c":"Account Manager", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Account Management", "Financial_Year__c":"FY2016", "FTE__c":"50000.6349", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.2102", "Role_Title__c":"Senior Account Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Account Management", "Financial_Year__c":"FY2016", "FTE__c":"50000.635", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.2101", "Role_Title__c":"Senior Account Manager", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Account Management", "Financial_Year__c":"FY2016", "FTE__c":"50000.6334", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.2097", "Role_Title__c":"Account Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Account Management", "Financial_Year__c":"FY2016", "FTE__c":"50000.6335", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"25.2096", "Role_Title__c":"Account Executive", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Account Management", "Financial_Year__c":"FY2016", "FTE__c":"50000.6336", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.2097", "Role_Title__c":"Account Manager", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Account Management", "Financial_Year__c":"FY2016", "FTE__c":"50000.2892", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"35.949", "Role_Title__c":"Senior Account Director", "RecordTypeId":"REC_TO_REPLACE"},';
        country_calc_json += '{"attributes":{"type":"Oblix_Calculator__c"},"Agency_Department__c":"Account Management", "Financial_Year__c":"FY2016", "FTE__c":"50000.2893", "Name":"Argentina", "OblixCountry__c":"COUNTRY_ID_TO_REPLACE", "Oblix_Agency__c":"AGENCY_ID_TO_REPLACE", "Role_Daily_Rate_EUR__c":"45.95", "Role_Title__c":"Senior Account Manager", "RecordTypeId":"REC_TO_REPLACE"}]';

        // replace the record type for the intended environment
        Id record_type_id = Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Role_Rate');
        country_calc_json = country_calc_json.replace('REC_TO_REPLACE', record_type_id);

        country_calc_json = country_calc_json.replace('COUNTRY_ID_TO_REPLACE', countryId);
        country_calc_json = country_calc_json.replace('AGENCY_ID_TO_REPLACE', agencyId);
        //system.debug('calculator_string: '+country_calc_json);

        List<Oblix_Calculator__c> list_calculator_records = (List<Oblix_Calculator__c>) json.deserialize(country_calc_json,list<Oblix_Calculator__c>.class);


        return list_calculator_records;

    }


    public static List<MDO_Geography__c> createMDOgeography(){
        //List<MDO_Geography__c> list_mdo_geography = new List<MDO_Geography__c>();
        
        //String geography_string = '[{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"GD","Name":"Grenada"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"GP","Name":"Guadeloupe"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"HT","Name":"Haiti"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"JM","Name":"Jamaica"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"MQ","Name":"Martinique"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"MS","Name":"Montserrat"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"AN","Name":"Netherlands Antilles"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"PR","Name":"Puerto Rico"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BL","Name":"Saint Barthelemy"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"KN","Name":"Saint Kitts and Nevis"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"LC","Name":"Saint Lucia"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"MF","Name":"Saint Martin"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"SX","Name":"Sint Maarten"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"VC","Name":"St Vincent and the Grenadines"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"TT","Name":"Trinidad and Tobago"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"TC","Name":"Turks and Caicos Islands"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"VG","Name":"Virgin Islands, British"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"LK","Name":"Sri Lanka"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"AF","Name":"Afghanistan"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BT","Name":"Bhutan"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"IO","Name":"British Indian Ocean Territory"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"MV","Name":"Maldives"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BE","Name":"Belgium"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"LU","Name":"Luxembourg"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"NL","Name":"Netherlands"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CZ","Name":"Czech Republic"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"SK","Name":"Slovakia"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BA","Name":"Bosnia and Herzegovina"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"VI","Name":"Virgin Islands, U.S."},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CU","Name":"Cuba"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"MX","Name":"Mexico"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BZ","Name":"Belize"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CO","Name":"Colombia"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CR","Name":"Costa Rica"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"EC","Name":"Ecuador"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"SV","Name":"El Salvador"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"GF","Name":"French Guiana"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"GT","Name":"Guatemala"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"GY","Name":"Guyana"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"HN","Name":"Honduras"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"NI","Name":"Nicaragua"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"PA","Name":"Panama"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"SR","Name":"Suriname"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"VE","Name":"Venezuela"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BR","Name":"Brazil"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"AR","Name":"Argentina"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BO","Name":"Bolivia"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CL","Name":"Chile"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"PY","Name":"Paraguay"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"PE","Name":"Peru"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"UY","Name":"Uruguay"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CA","Name":"Canada"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"PM","Name":"Saint Pierre and Miquelon"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"US","Name":"United States"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"UM","Name":"US Minor Outlying Islands"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"AO","Name":"Angola"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CV","Name":"Cabo Verde"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CM","Name":"Cameroon"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CF","Name":"Central African Republic"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"TD","Name":"Chad"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"KM","Name":"Comoros"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CG","Name":"Congo"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CD","Name":"Congo, The Democratic Republic"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"DJ","Name":"Djibouti"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"GQ","Name":"Equatorial Guinea"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"ER","Name":"Eritrea"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"ET","Name":"Ethiopia"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"GA","Name":"Gabon"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"MG","Name":"Madagascar"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"MU","Name":"Mauritius"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"YT","Name":"Mayotte"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"RE","Name":"Réunion"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"SH","Name":"Saint Helena"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"ST","Name":"Sao Tome and Principe"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"SC","Name":"Seychelles"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"SO","Name":"Somalia"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BI","Name":"Burundi"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"KE","Name":"Kenya"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"RW","Name":"Rwanda"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"TZ","Name":"Tanzania"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"UG","Name":"Uganda"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"NG","Name":"Nigeria"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BW","Name":"Botswana"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"LS","Name":"Lesotho"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"NA","Name":"Namibia"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"ZA","Name":"South Africa"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"SZ","Name":"Swaziland"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"MW","Name":"Malawi"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"MZ","Name":"Mozambique"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"ZM","Name":"Zambia"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"ZW","Name":"Zimbabwe"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BJ","Name":"Benin"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BF","Name":"Burkina Faso"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CI","Name":"Côte DIvoire"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"GN","Name":"Guinea"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"GW","Name":"Guinea-Bissau"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"ML","Name":"Mali"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"NE","Name":"Niger"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"SN","Name":"Senegal"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"TG","Name":"Togo"}]';
        String country_json_string = '[{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"LK"';
        country_json_string += ',"Name":"Sri Lanka"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"NL"';
        country_json_string += ',"Name":"Netherlands"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"MX"';
        country_json_string += ',"Name":"Mexico"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"VE"';
        country_json_string += ',"Name":"Venezuela"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BR"';
        country_json_string += ',"Name":"Brazil"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"AR"';
        country_json_string += ',"Name":"Argentina"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CL"';
        country_json_string += ',"Name":"Chile"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CA"';
        country_json_string += ',"Name":"Canada"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"ZA"';
        country_json_string += ',"Name":"South Africa"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"AE"';
        country_json_string += ',"Name":"United Arab Emirates"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"RU"';
        country_json_string += ',"Name":"Russian Federation"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"TR"';
        country_json_string += ',"Name":"Turkey"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"HK"';
        country_json_string += ',"Name":"Hong Kong"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"CN"';
        country_json_string += ',"Name":"China"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"JP"';
        country_json_string += ',"Name":"Japan"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"AU"';
        country_json_string += ',"Name":"Australia"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"MY"';
        country_json_string += ',"Name":"Malaysia"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"SG"';
        country_json_string += ',"Name":"Singapore"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"ID"';
        country_json_string += ',"Name":"Indonesia"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"PH"';
        country_json_string += ',"Name":"Philippines"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"VN"';
        country_json_string += ',"Name":"Vietnam"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"TH"';
        country_json_string += ',"Name":"Thailand"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"BD"';
        country_json_string += ',"Name":"Bangladesh"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"IN"';
        country_json_string += ',"Name":"India"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"PK"';
        country_json_string += ',"Name":"Pakistan"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"PL"';
        country_json_string += ',"Name":"Poland"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"DE"';
        country_json_string += ',"Name":"Germany"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"SE"';
        country_json_string += ',"Name":"Sweden"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"FR"';
        country_json_string += ',"Name":"France"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"IT"';
        country_json_string += ',"Name":"Italy"},{"attributes":{"type":"MDO_Geography__c"},"geography_type__c":"Country","mdm_id__c":"ES"';
        country_json_string += ',"Name":"Spain"}]';

        system.debug('geography_string: '+country_json_string);

        List<MDO_Geography__c> list_mdo_geography = (List<MDO_Geography__c>) json.deserialize(country_json_string,list<MDO_Geography__c>.class);

        //MDO_Geography__c country_geography = new MDO_Geography__c();

        //country_geography.Name = 'France';
        //country_geography.geography_type__c = 'Country';
        //country_geography.mdm_id__c = 'FR001';

        //list_mdo_geography.add(country_geography);


        //country_geography = new MDO_Geography__c(); 
        //country_geography.Name = 'SPAIN';
        //country_geography.geography_type__c = 'Country';
        //country_geography.mdm_id__c = 'SP002';
        //list_mdo_geography.add(country_geography);


        //country_geography = new MDO_Geography__c(); 
        //country_geography.Name = 'UK & IRELAND';
        //country_geography.geography_type__c = 'Country';
        //country_geography.mdm_id__c = 'UK003';
        //list_mdo_geography.add(country_geography);

        return list_mdo_geography;
    }



    public static List<Oblix_Calculator__c> createBoxRangeCalculatorRecords(){

        //List<Oblix_Calculator__c> list_calculator_records = new List<Oblix_Calculator__c>();
        Id record_type_id = Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Box_Range');

        String calculator_string = '[{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 1","Name":"Box Range","Points_High__c":11.00,"Points_Low__c":0.10,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 2","Name":"Box Range","Points_High__c":16.00,"Points_Low__c":11.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 3","Name":"Box Range","Points_High__c":21.00,"Points_Low__c":16.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 4","Name":"Box Range","Points_High__c":26.00,"Points_Low__c":21.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 5","Name":"Box Range","Points_High__c":31.00,"Points_Low__c":26.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 6","Name":"Box Range","Points_High__c":41.00,"Points_Low__c":31.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 7","Name":"Box Range","Points_High__c":51.00,"Points_Low__c":41.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 8","Name":"Box Range","Points_High__c":61.00,"Points_Low__c":51.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 9","Name":"Box Range","Points_High__c":71.00,"Points_Low__c":61.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 10","Name":"Box Range","Points_High__c":81.00,"Points_Low__c":71.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 11","Name":"Box Range","Points_High__c":91.00,"Points_Low__c":81.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 12","Name":"Box Range","Points_High__c":100.00,"Points_Low__c":91.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 13","Name":"Box Range","Points_High__c":111.00,"Points_Low__c":100.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 14","Name":"Box Range","Points_High__c":121.00,"Points_Low__c":111.00,"RecordTypeId":"REC_TO_REPLACE"},{"attributes":{"type":"Oblix_Calculator__c"},"Financial_Year__c":"FY2016","Box_Range__c":"Box 15","Name":"Box Range","Points_High__c":10000.00,"Points_Low__c":121.00,"RecordTypeId":"REC_TO_REPLACE"}]';
        // replace the record type for the intended environment
        calculator_string = calculator_string.replace('REC_TO_REPLACE', record_type_id);
        system.debug('calculator_string: '+calculator_string);

        List<Oblix_Calculator__c> list_calculator_records = (List<Oblix_Calculator__c>) json.deserialize(calculator_string,list<Oblix_Calculator__c>.class);

        return list_calculator_records;
    }


    public static List<Asset_Scoring__c> createAssetScoringRecords(Integer number_of_assets_to_create){

        String asset_scoring_json = '[{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdXVMA0"},"Is_Active__c":"true","Asset_name__c":"Behind the Scenes Footage","Asset_Option__c":"Option 5","Description__c":"Strategic Print - Full creative development and production of new print, requiring several copy versions and layouts (>2). Includes new photography.","mdm_id__c":"ASSET000120","Name":"Score 5","Point_Score__c":500,"Sub_Category__c":"Origination Lite","Type__c":"Static Imagery"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdYEMA0"},"Is_Active__c":"true","Asset_name__c":"Experiential","Asset_Option__c":"Option 4","Description__c":"Full creative development and production of a experiential ideas in multiple locations","mdm_id__c":"ASSET000144","Name":"Score 5","Point_Score__c":900,"Sub_Category__c":"Experiential - Promotional ideas ORIGINATION","Type__c":"Experiential"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdYiMAK"},"Is_Active__c":"true","Asset_name__c":"Interactive Game","Asset_Option__c":"Option 2","Description__c":"Complex specialist digital strategic requirements. Eg/ complex mobile marketing strategy. UX Strategy  for a large brand etc","mdm_id__c":"ASSET000165","Name":"Score 2","Point_Score__c":1200,"Sub_Category__c":"Specialist Digital","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdYTMA0"},"Is_Active__c":"true","Asset_name__c":"Other","Asset_Option__c":"Option 3","Description__c":"Moderate adaptation of an existing experiential idea. Eg, existing idea will be activated in a different location and / or for a different product line or in a different type of retail concept etc.","mdm_id__c":"ASSET000154","Name":"Score 4","Point_Score__c":300,"Sub_Category__c":"Experiential - Promotional ideas ADAPTATION","Type__c":"Experiential"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdYnMAK"},"Is_Active__c":"true","Asset_name__c":"Interactive Game","Asset_Option__c":"Option 3","Description__c":"Complex Interactive game creation / mobile app conceptualisation.","mdm_id__c":"ASSET000171","Name":"Score 3","Point_Score__c":1500,"Sub_Category__c":"Specialist Digital","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdZWMA0"},"Is_Active__c":"true","Asset_name__c":"Other","Asset_Option__c":"Option 2","Description__c":"Digital strategy adaptation / refresh. Eg/ mobile or UX strategy","mdm_id__c":"ASSET000288","Name":"Score 2","Point_Score__c":40,"Sub_Category__c":"Digital Adaptation","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdaAMAS"},"Is_Active__c":"true","Asset_name__c":"Other","Asset_Option__c":"Option 5","Description__c":"Complex data segmentation strategy to identify audiences. Creation of tracking framework. Campaign analytics, reporting and optimisation.","mdm_id__c":"ASSET000343","Name":"Score 5","Point_Score__c":450,"Sub_Category__c":"Data Analytics Reporting Dashboards","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdZqMAK"},"Is_Active__c":"true","Asset_name__c":"Other","Asset_Option__c":"Option 1","Description__c":"Simple campaign analytics and reporting.","mdm_id__c":"ASSET000339","Name":"Score 1","Point_Score__c":90,"Sub_Category__c":"Data Analytics Reporting Dashboards","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdaZMAS"},"Is_Active__c":"true","Asset_name__c":"Other","Asset_Option__c":"Option 5","Description__c":"Social media strat and content calendar for 8+ social media channel with frequent updates. PER MONTH","mdm_id__c":"ASSET000348","Name":"Score 5","Point_Score__c":220,"Sub_Category__c":"Always on Social","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdXGMA0"},"Is_Active__c":"true","Asset_name__c":"Behind the Scenes Footage","Asset_Option__c":"Option 2","Description__c":"Out of Home materials - Bus wraps / shelters/ billboards / street banners","mdm_id__c":"ASSET000111","Name":"Score 2","Point_Score__c":150,"Sub_Category__c":"Origination Lite","Type__c":"Static Imagery"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdXLMA0"},"Is_Active__c":"true","Asset_name__c":"Behind the Scenes Footage","Asset_Option__c":"Option 3","Description__c":"New tactical print, requiring new tactical creative concept, new call to action, new simple copy, new headline. Uses KV or other existing photography.","mdm_id__c":"ASSET000114","Name":"Score 3","Point_Score__c":300,"Sub_Category__c":"Origination Lite","Type__c":"Static Imagery"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000Cda5MAC"},"Is_Active__c":"true","Asset_name__c":"Other","Asset_Option__c":"Option 4","Description__c":"Simple/Moderate customer segmentation and targeting strategy. Creation of measurement framework. Large amounts of campaign analytics and reporting.","mdm_id__c":"ASSET000342","Name":"Score 4","Point_Score__c":300,"Sub_Category__c":"Data Analytics Reporting Dashboards","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdaUMAS"},"Is_Active__c":"true","Asset_name__c":"Other","Asset_Option__c":"Option 4","Description__c":"Social media strat and content calendar for 5-7 social media channel with weekly updates. PER MONTH","mdm_id__c":"ASSET000347","Name":"Score 4","Point_Score__c":200,"Sub_Category__c":"Always on Social","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdZ2MAK"},"Is_Active__c":"true","Asset_name__c":"Microsite","Asset_Option__c":"Option 1","Description__c":"Banner, landing page, page take over, youtube uploads (includes writing the copy for you tube clips etc).","mdm_id__c":"ASSET000197","Name":"Score 1","Point_Score__c":25,"Sub_Category__c":"Digital Campaign Assets","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdZRMA0"},"Is_Active__c":"true","Asset_name__c":"Other","Asset_Option__c":"Option 1","Description__c":"Banner or landing page adaptations (complex)","mdm_id__c":"ASSET000273","Name":"Score 1","Point_Score__c":20,"Sub_Category__c":"Digital Adaptation","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdZbMAK"},"Is_Active__c":"true","Asset_name__c":"Other","Asset_Option__c":"Option 3","Description__c":"EDM/eNewsletters - Adapt copy, design & layout.","mdm_id__c":"ASSET000303","Name":"Score 3","Point_Score__c":100,"Sub_Category__c":"Digital Adaptation","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdZgMAK"},"Is_Active__c":"true","Asset_name__c":"Other","Asset_Option__c":"Option 4","Description__c":"Micro site adaptation for language or localised creative concept 8 Page / 10 Sections","mdm_id__c":"ASSET000318","Name":"Score 4","Point_Score__c":150,"Sub_Category__c":"Digital Adaptation","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdZ7MAK"},"Is_Active__c":"true","Asset_name__c":"Microsite","Asset_Option__c":"Option 2","Description__c":"EDM/eNewsletters (Standard) - Originate copy, design & layout","mdm_id__c":"ASSET000212","Name":"Score 2","Point_Score__c":60,"Sub_Category__c":"Digital Campaign Assets","Type__c":"Digital"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdXfMAK"},"Is_Active__c":"true","Asset_name__c":"Other","Asset_Option__c":"Option 1","Description__c":"Small copy amend or adaptation of copy. OR Simple layout amend, or photo / pack replacement.","mdm_id__c":"ASSET000125","Name":"Score 3","Point_Score__c":75,"Sub_Category__c":"Adaptation","Type__c":"Static Imagery"},{"attributes":{"type":"Asset_Scoring__c","url":"/services/data/v36.0/sobjects/Asset_Scoring__c/a6NM0000000CdXBMA0"},"Is_Active__c":"true","Asset_name__c":"Behind the Scenes Footage","Asset_Option__c":"Option 1","Description__c":"Development of a Key Visual (shoot, talent, production and post production) or new Logo design","mdm_id__c":"ASSET000108","Name":"Score 1","Point_Score__c":90,"Sub_Category__c":"Origination Lite","Type__c":"Static Imagery"}]';
        system.debug('asset_scoring_json: '+asset_scoring_json);
        List<Asset_Scoring__c> list_asset_scoring_to_return = (List<Asset_Scoring__c>) json.deserialize(asset_scoring_json,list<Asset_Scoring__c>.class);

        //for (Integer asset_number = 1; asset_number <= number_of_assets_to_create; asset_number++){

        //    list_asset_scoring_to_return.add(createAssetScore('Type-'+asset_number, 'sub-cat-'+asset_number, 'asset-option-'+asset_number
        //        , 'name-'+asset_number, (Decimal) (100*asset_number), 'description-'+asset_number
        //        , 'option-description-'+asset_number, 'mdm-id-'+asset_number));
        //}

        return list_asset_scoring_to_return;
    }

    //public static Asset_Scoring__c createAssetScore(String asset_type, String asset_sub_category, String asset_option
    //    , String asset_name, Decimal asset_score, String asset_description, String asset_option_description, String mdm_id){

    //    Asset_Scoring__c asset_score_to_return = new Asset_Scoring__c();

    //    asset_score_to_return.Type__c = asset_type;
    //    asset_score_to_return.Sub_Category__c = asset_sub_category;
    //    asset_score_to_return.Asset_Option__c = asset_option;
    //    asset_score_to_return.Asset_name__c = asset_name;
    //    asset_score_to_return.Point_Score__c = asset_score;
    //    asset_score_to_return.Description__c = asset_description;
    //    asset_score_to_return.Asset_Option_Description__c = asset_option_description;
    //    asset_score_to_return.mdm_id__c = mdm_id;

    //    return asset_score_to_return;
    //}

    public static MDO_Category__c createProductCategory(String categoryName){
        return new MDO_Category__c(Name = categoryName);
    }

    public static MDO_Brand__c createBrand(String brandName){
        return new MDO_Brand__c(Name = brandName, Status__c = 'Active');
    }

    public static MDO_CategoryBrands__c createCategoryBrand(Id categoryId, Id brandId){
        return new MDO_CategoryBrands__c(product_Category_Id__c = categoryId, brand_id__c = brandId);
    }

    public static User createMarketingUser(String name){
        Profile profile = [SELECT Id FROM Profile WHERE Name='Marketing User'];
        return new User(Alias = name+'ut', Email = name+'unittest@unilever.com', 
            EmailEncodingKey = UTF8, LastName = 'LastName', LanguageLocaleKey = EN_US, 
            LocaleSidKey = EN_US, ProfileId = profile.Id, FirstName = name, 
            TimeZoneSidKey = EUROPE_LONDON,AF_Agency_Fees_User_Type__c = CATEGORY_FINANCE,isActive = true, 
            UserName = name+'@unilever.com.unittest');
    }

    public static PermissionSetAssignment createPermissionSetAssignment(Id userId, Id permissionSetId){
        return new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = permissionSetId);
    }

    public static Map<String, Id> getOblixPermissionSets(){

        Map<String, Id> oblixPermissionSetsMap = new Map<String, Id>();

        List<String> oblixPermissionSets = new List<String>{Oblix_Utils.PERMISSIONSETNAME_UL1, Oblix_Utils.PERMISSIONSETNAME_UL2,
                                                            Oblix_Utils.PERMISSIONSETNAME_UL3, Oblix_Utils.PERMISSIONSETNAME_SUPERUSER};

        List<PermissionSet> permissionSets = [SELECT Id, Name FROM PermissionSet WHERE Name IN :oblixPermissionSets];
        for(PermissionSet ps : permissionSets){
            oblixPermissionSetsMap.put(ps.Name, ps.Id);
        }

        return oblixPermissionSetsMap;
    }

    public static Oblix_User_Permission__c createUserPermission(Id userId, Id catBrandId, String levelOfAccess, Id recordTypeId){
        return new Oblix_User_Permission__c(User_id__c = userId, CategoryBrand_id__c = catBrandId, Level_of_Access__c = levelOfAccess, RecordTypeId = recordTypeId);
    }

    // creates UL1, UL2, UL3 and superuser, checks for appropriate permission sets and assignes them if present in the system.
    // fires an assertion exception if there are any permission sets missing in the system
    public static Map<String, User> createTestUsers(){
        Map<String, User> testUsers = new Map<String, User>();
        // insert users
        User thisUser = new User(Id = UserInfo.getUserId());
        System.runAs(thisUser){
            User ul1 = Oblix_TestUtils.createMarketingUser('UL1');
            User ul2 = Oblix_TestUtils.createMarketingUser('UL2');
            User ul3 = Oblix_TestUtils.createMarketingUser('UL3');
            User superuser = Oblix_TestUtils.createMarketingUser('superu');
            insert new List<User>{ul1, ul2, ul3, superuser};

            // assign permission sets (step 1. get permission set ids, verify they exist)
            Map<String, Id> oblixPermissionSets = Oblix_TestUtils.getOblixPermissionSets();

            System.assertNotEquals(null, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL1));
            System.assertNotEquals(null, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL2));
            System.assertNotEquals(null, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL3));
            System.assertNotEquals(null, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_SUPERUSER));

            PermissionSetAssignment ul1PSA = Oblix_TestUtils.createPermissionSetAssignment(ul1.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL1));
            PermissionSetAssignment ul2PSA = Oblix_TestUtils.createPermissionSetAssignment(ul2.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL2));
            PermissionSetAssignment ul3PSA = Oblix_TestUtils.createPermissionSetAssignment(ul3.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL3));
            PermissionSetAssignment superuserPSA = Oblix_TestUtils.createPermissionSetAssignment(superuser.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_SUPERUSER));
            insert new List<PermissionSetAssignment>{ul1PSA, ul2PSA, ul3PSA, superuserPSA};

            testUsers.put('UL1', ul1);
            testUsers.put('UL2', ul2);
            testUsers.put('UL3', ul3);
            testUsers.put('superuser', superuser);

        }

        return testUsers;

    }

}