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
1.1 -   Michal Bluj             29/07/2015      SWITCHING TO MDO Objects 
**********************************************************************/
@isTest
private class BET_Triggers_Test {


    private static final String PROJECT_ASSERT_COMMENT = 'Category field search must match category name';
    private static final String BRAND_ASSERT_COMMENT = 'Brand field search must match brand name';
    private static final String CATEGORY_ASSERT_COMMENT = 'Category field search must match category name';
    private static final String OWNER_ASSERT_COMMENT = 'Owner field search must match owner name';

    static testMethod void testMethodOne(){
        Test.startTest();
        uw_Inoplan_Project__c inoplan = BET_TestingHelper.initInoplan('Test Inoplan', true);
        MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
        MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup, 'Test Category');
        MDO_Brand__c brand = BET_TestUtils.createBrand('Axe');

        uw_BET__c bet = BET_TestUtils.getTestBet('Test BET '+system.now(),categoryGroup.id,
                                                category.id,brand.id, inoplan.id,null,
                                                BET_TestingHelper.BET_STATUS_FIRSTRELEASE);
        insert bet;

        bet = BET_TestingHelper.getBET(bet.Id);

        //check if text field values for SOSL are populated by trigger
        System.assertEquals(bet.Inoplan_Project_Keyword_Search__c, inoplan.Name,PROJECT_ASSERT_COMMENT);
        System.assertEquals(bet.Brand_Keyword_Search__c, brand.Name,BRAND_ASSERT_COMMENT);
        System.assertEquals(bet.Category_Keyword_Search__c, category.Name,CATEGORY_ASSERT_COMMENT);
        //System.assertEquals(bet.Owner_Keyword_Search__c, UserInfo.getFirstName() + ' ' + UserInfo.getLastName());

        uw_Inoplan_Project__c inoplan2 = BET_TestingHelper.initInoplan('Test Inoplan 2', true);
        MDO_Category__c categoryGroup2 = BET_TestUtils.createCategoryGroup();
        MDO_Category__c category2 = BET_TestUtils.createCategory(categoryGroup2, 'Test Category 1');
        MDO_Brand__c brand2 = BET_TestUtils.createBrand('Axe 1');
        User u2 = BET_TestingHelper.getDefaultManager();

        bet.Inoplan_Project__c = inoplan2.Id;
        bet.Product_Category__c = category2.Id;
        bet.OwnerId = u2.Id;
        bet.Product_Brand__c = brand2.Id;

        update bet;

        bet = BET_TestingHelper.getBET(bet.Id);

        //check if text field values for SOSL are populated by trigger
        System.assertEquals(bet.Inoplan_Project_Keyword_Search__c, inoplan2.Name,PROJECT_ASSERT_COMMENT);
        System.assertEquals(bet.Brand_Keyword_Search__c, brand2.Name,BRAND_ASSERT_COMMENT);
        System.assertEquals(bet.Category_Keyword_Search__c, category2.Name,CATEGORY_ASSERT_COMMENT);
        System.assertEquals(bet.Owner_Keyword_Search__c, u2.Name,OWNER_ASSERT_COMMENT);

        inoplan2.Name = 'Test Inoplan 3';
        update inoplan2;

        bet = BET_TestingHelper.getBET(bet.Id);

        System.assertEquals(bet.Inoplan_Project_Keyword_Search__c, inoplan2.Name,PROJECT_ASSERT_COMMENT);

        Integer countFeedItems = [SELECT count() FROM FeedItem WHERE ParentId =: bet.Studio_Chatter_Group__c];
        bet.Status__c = BET_TestingHelper.BET_STATUS_FINALRELEASE;
        update bet;

        Integer countFeedItemsAfter = [SELECT count() FROM FeedItem WHERE ParentId =: bet.Studio_Chatter_Group__c];
        System.assertEquals(countFeedItems+1, countFeedItemsAfter, 'Feed items counters must match');
        Test.stopTest();
    }

    static testMethod void testMethodTwo(){
        Test.startTest();
        uw_Inoplan_Project__c inoplan = BET_TestingHelper.initInoplan('Test Inoplan', true);
        MDO_Category__c categoryGroup = BET_TestUtils.createCategoryGroup();
        MDO_Category__c category = BET_TestUtils.createCategory(categoryGroup, 'Test Category');
        MDO_Brand__c brand = BET_TestUtils.createBrand('Axe');

        uw_BET__c bet = BET_TestUtils.getTestBet('Test BET '+system.now(),categoryGroup.id,
                                                category.id,brand.id, inoplan.id,null,
                                                BET_TestingHelper.BET_STATUS_FIRSTRELEASE);
        insert bet;

        bet = BET_TestingHelper.getBET(bet.Id);

        //check if text field values for SOSL are populated by trigger
        System.assertEquals(bet.Inoplan_Project_Keyword_Search__c, inoplan.Name,PROJECT_ASSERT_COMMENT);
        System.assertEquals(bet.Brand_Keyword_Search__c, brand.Name,BRAND_ASSERT_COMMENT);
        System.assertEquals(bet.Category_Keyword_Search__c, category.Name,CATEGORY_ASSERT_COMMENT);

        uw_Inoplan_Project__c inoplan2 = BET_TestingHelper.initInoplan('Test Inoplan 2', true);
        MDO_Category__c categoryGroup2 = BET_TestUtils.createCategoryGroup();
        MDO_Category__c category2 = BET_TestUtils.createCategory(categoryGroup2, 'Test Category 1');
        MDO_Brand__c brand2 = BET_TestUtils.createBrand('Axe 1');
        User u2 = BET_TestingHelper.getDefaultManager();

        bet.Inoplan_Project__c = inoplan2.Id;
        bet.Product_Category__c = category2.Id;
        bet.OwnerId = u2.Id;
        bet.Product_Brand__c = brand2.Id;

        update bet;

        bet = BET_TestingHelper.getBET(bet.Id);

        //check if text field values for SOSL are populated by trigger
        System.assertEquals(bet.Inoplan_Project_Keyword_Search__c, inoplan2.Name,PROJECT_ASSERT_COMMENT);
        System.assertEquals(bet.Brand_Keyword_Search__c, brand2.Name,BRAND_ASSERT_COMMENT);
        System.assertEquals(bet.Category_Keyword_Search__c, category2.Name,CATEGORY_ASSERT_COMMENT);
        System.assertEquals(bet.Owner_Keyword_Search__c, u2.Name,OWNER_ASSERT_COMMENT);    

        inoplan2.Name = 'Test Inoplan 3';
        update inoplan2;

        bet = BET_TestingHelper.getBET(bet.Id);

        System.assertEquals(bet.Inoplan_Project_Keyword_Search__c, inoplan2.Name,PROJECT_ASSERT_COMMENT);

        uw_Custom_Setting__c cs = new uw_Custom_Setting__c();
        cs.Checkbox_Value__c = true;
        cs.Name = uw_CustomSettingsMAnager.BET_DISABLE_LOG_CHANGE_TRIGGER;
        insert cs;
        Integer countFeedItems = [SELECT count() FROM FeedItem WHERE ParentId =: bet.Studio_Chatter_Group__c];
        bet.Status__c = BET_TestingHelper.BET_STATUS_FINALRELEASE;
        update bet;

        Integer countFeedItemsAfter = [SELECT count() FROM FeedItem WHERE ParentId =: bet.Studio_Chatter_Group__c];
        System.assertEquals(countFeedItems, countFeedItemsAfter,'Feed count must match');
        Test.stopTest();
    }
}