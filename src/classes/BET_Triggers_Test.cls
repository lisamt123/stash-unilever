/**********************************************************************
Name: BET_CommonServiceTest 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: test for all triggers for BET app - updating fields for SOSL queries
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/12/2014      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class BET_Triggers_Test {
    static testMethod void testMethodOne(){
        uw_Inoplan_Project__c inoplan = BET_TestingHelper.initInoplan('Test Inoplan', true);
        BET_Category__c parentCategory = BET_TestingHelper.initCategory('Test Parent', true);
        BET_Category__c subCategory = BET_TestingHelper.initCategory('Test Subcategory', parentCategory, true);
        uw_Brand__c brand = BET_TestingHelper.initBrand('Test Brand', true);
        BET_TestingHelper.initCategoryBrand(subCategory, brand, true);
        User u = BET_TestingHelper.getDefaultOwner();

        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET(u, 'Test BET Name', BET_TestingHelper.BET_STATUS_FIRSTRELEASE, inoplan, parentCategory, subCategory, brand, true);

        uw_BET__c bet = wrap.BET;
        //check if text field values for SOSL are populated by trigger
        System.assertEquals(bet.Inoplan_Project_Keyword_Search__c, inoplan.Name);
        System.assertEquals(bet.Brand_Keyword_Search__c, brand.Name);
        System.assertEquals(bet.Category_Keyword_Search__c, subCategory.Name);
        System.assertEquals(bet.Owner_Keyword_Search__c, u.Name);

        uw_Inoplan_Project__c inoplan2 = BET_TestingHelper.initInoplan('Test Inoplan 2', true);
        BET_Category__c parentCategory2 = BET_TestingHelper.initCategory('Test Parent 2', true);
        BET_Category__c subCategory2 = BET_TestingHelper.initCategory('Test Subcategory 2', parentCategory2, true);
        uw_Brand__c brand2 = BET_TestingHelper.initBrand('Test Brand 2', true);
        BET_TestingHelper.initCategoryBrand(subCategory2, brand2, true);
        User u2 = BET_TestingHelper.getDefaultManager();

        bet.Inoplan_Project__c = inoplan2.Id;
        bet.Category__c = parentCategory2.Id;
        bet.Sub_Category__c = subCategory2.Id;
        bet.OwnerId = u2.Id;
        bet.uw_Brand__c = brand2.Id;

        update bet;

        bet = BET_TestingHelper.getBET(bet.Id);

        //check if text field values for SOSL are populated by trigger
        System.assertEquals(bet.Inoplan_Project_Keyword_Search__c, inoplan2.Name);
        System.assertEquals(bet.Brand_Keyword_Search__c, brand2.Name);
        System.assertEquals(bet.Category_Keyword_Search__c, subCategory2.Name);
        System.assertEquals(bet.Owner_Keyword_Search__c, u2.Name);

        User admin = BET_TestingHelper.createAdminUser('test', 'admin@tes.com', 'test');

        system.runAs(admin){
            u2.Firstname = 'Tom';
            u2.LastName = 'Hanks';
            update u2;
        }        

        inoplan2.Name = 'Test Inoplan 3';
        update inoplan2;

        brand2.Name = 'Test Brand 3';
        update brand2;

        subCategory2.Name = 'Test Subcategory 3';
        update subCategory2;        

        bet = BET_TestingHelper.getBET(bet.Id);

        System.assertEquals(bet.Inoplan_Project_Keyword_Search__c, inoplan2.Name);
        System.assertEquals(bet.Brand_Keyword_Search__c, brand2.Name);
        System.assertEquals(bet.Category_Keyword_Search__c, subCategory2.Name);

        Integer countFeedItems = [SELECT count() FROM FeedItem WHERE ParentId =: bet.Studio_Chatter_Group__c];
        bet.Status__c = BET_TestingHelper.BET_STATUS_FINALRELEASE;
        update bet;

        Integer countFeedItemsAfter = [SELECT count() FROM FeedItem WHERE ParentId =: bet.Studio_Chatter_Group__c];
        System.assertEquals(countFeedItems+1, countFeedItemsAfter);
    }

static testMethod void testMethodTwo(){
        uw_Inoplan_Project__c inoplan = BET_TestingHelper.initInoplan('Test Inoplan', true);
        BET_Category__c parentCategory = BET_TestingHelper.initCategory('Test Parent', true);
        BET_Category__c subCategory = BET_TestingHelper.initCategory('Test Subcategory', parentCategory, true);

        uw_Brand__c brand = BET_TestingHelper.initBrand('Test Brand', true);
        BET_TestingHelper.initCategoryBrand(subCategory, brand, true);
        User u = BET_TestingHelper.getDefaultOwner();

        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET(u, 'Test BET Name', BET_TestingHelper.BET_STATUS_FIRSTRELEASE, inoplan, parentCategory, subCategory, brand, true);

        uw_BET__c bet = wrap.BET;
        //check if text field values for SOSL are populated by trigger
        System.assertEquals(bet.Inoplan_Project_Keyword_Search__c, inoplan.Name);
        System.assertEquals(bet.Brand_Keyword_Search__c, brand.Name);
        System.assertEquals(bet.Category_Keyword_Search__c, subCategory.Name);
        System.assertEquals(bet.Owner_Keyword_Search__c, u.Name);

        uw_Inoplan_Project__c inoplan2 = BET_TestingHelper.initInoplan('Test Inoplan 2', true);
        BET_Category__c parentCategory2 = BET_TestingHelper.initCategory('Test Parent 2', true);
        BET_Category__c subCategory2 = BET_TestingHelper.initCategory('Test Subcategory 2', parentCategory2, true);
        uw_Brand__c brand2 = BET_TestingHelper.initBrand('Test Brand 2', true);
        BET_TestingHelper.initCategoryBrand(subCategory2, brand2, true);
        User u2 = BET_TestingHelper.getDefaultManager();

        bet.Inoplan_Project__c = inoplan2.Id;
        bet.Category__c = parentCategory2.Id;
        bet.Sub_Category__c = subCategory2.Id;
        bet.OwnerId = u2.Id;
        bet.uw_Brand__c = brand2.Id;

        update bet;

        bet = BET_TestingHelper.getBET(bet.Id);

        //check if text field values for SOSL are populated by trigger
        System.assertEquals(bet.Inoplan_Project_Keyword_Search__c, inoplan2.Name);
        System.assertEquals(bet.Brand_Keyword_Search__c, brand2.Name);
        System.assertEquals(bet.Category_Keyword_Search__c, subCategory2.Name);
        System.assertEquals(bet.Owner_Keyword_Search__c, u2.Name);

        User admin = BET_TestingHelper.createAdminUser('test', 'admin@tes.com', 'test');

        Test.startTest();//testing future method from the trigger;
        system.runAs(admin){
            u2.Firstname = 'Tom';
            u2.LastName = 'Hanks';
            update u2;
        }        
        Test.stopTest();
        inoplan2.Name = 'Test Inoplan 3';
        update inoplan2;

        brand2.Name = 'Test Brand 3';
        update brand2;

        subCategory2.Name = 'Test Subcategory 3';
        update subCategory2;        

        bet = BET_TestingHelper.getBET(bet.Id);

        System.assertEquals(bet.Inoplan_Project_Keyword_Search__c, inoplan2.Name);
        System.assertEquals(bet.Brand_Keyword_Search__c, brand2.Name);
        System.assertEquals(bet.Category_Keyword_Search__c, subCategory2.Name);
        System.assertEquals(bet.Owner_Keyword_Search__c, 'Tom Hanks');

        uw_Custom_Setting__c cs = new uw_Custom_Setting__c();
        cs.Checkbox_Value__c = true;
        cs.Name = uw_CustomSettingsMAnager.BET_DISABLE_LOG_CHANGE_TRIGGER;
        insert cs;
        Integer countFeedItems = [SELECT count() FROM FeedItem WHERE ParentId =: bet.Studio_Chatter_Group__c];
        bet.Status__c = BET_TestingHelper.BET_STATUS_FINALRELEASE;
        update bet;

        Integer countFeedItemsAfter = [SELECT count() FROM FeedItem WHERE ParentId =: bet.Studio_Chatter_Group__c];
        System.assertEquals(countFeedItems, countFeedItemsAfter);
    }
}