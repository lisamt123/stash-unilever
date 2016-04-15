/**********************************************************************
Name: OV_BatchKpiNotification_Test
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Test for OV_BatchKpiNotification
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             16/10/2015      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class OV_BatchKpiNotification_Test {

    public static final String TEST_EMAIL         = 'test@test.com';
    public static final String TEST_LABEL            = 'test';
    public static final String TEST2_LABEL           = 'test2';
    
    @isTest static void batchTest() {
        User u = OV_TestingHelper.createAdminUser(TEST_LABEL, TEST_EMAIL, TEST2_LABEL);
        OV_Profile__c profile = new OV_Profile__c(User__c = u.Id);
        insert profile;
        OV_KPI_Dimension_KPI_Name__c kpiName = new OV_KPI_Dimension_KPI_Name__c(Visible_Columns__c='brand;businessUnit;channel;', Code__c = TEST2_LABEL, Code_Text__c = TEST2_LABEL);
        insert kpiName;
        List<OV_KPI_Transaction__c> transactions = new List<OV_KPI_Transaction__c>();
        for(Integer i=0;i<200;i++){
            transactions.add(new OV_KPI_Transaction__c(Direction__c ='NO CHANGE', KPI_Name__c=kpiName.Id, KPI_Name_Code__c=TEST2_LABEL, Source__c='test123', File_Version__c='222', Source_Timestamp__c=Datetime.now(), Data_Tag__c=TEST2_LABEL, Value_Current_Period__c='1.2', Value_Previous_Period__c='2.2'));
        }
        insert transactions;

        List<OV_KPI_Transaction_Favorite__c> favouriteTransactions = new List<OV_KPI_Transaction_Favorite__c>();
        for(Integer i=0;i<150;i++){
            favouriteTransactions.add(new OV_KPI_Transaction_Favorite__c(User__c = profile.Id, KPI_Transaction__c = transactions[i].Id, Wants_Notifications__c = true));
        }
        insert favouriteTransactions;

        Test.startTest();
        String query = 'SELECT Id FROM OV_KPI_Transaction__c';
        OV_BatchKpiNotification c = new OV_BatchKpiNotification(query);
        Database.executeBatch(c);
        Test.stopTest();
        system.assertEquals(150, OV_BatchKpiNotification.testBatchSize);
    }
    
    @isTest static void noFavouriteTransactionTest() {
        List<OV_GetKPI_Mapping__c > mappingList = new List<OV_GetKPI_Mapping__c >();
        mappingList.add(new OV_GetKPI_Mapping__c(Name='timeRange', Header__c = 'Time Range', Field_API_Name__c = 'Time_Range__c',  Object_API_Name__c = 'OV_KPI_Dimension_Time_Range__c',  Order__c = 1, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='wlGroup', Header__c = 'WL Group', Field_API_Name__c = 'WL_Group__c',  Object_API_Name__c = 'OV_KPI_Dimension_WL_GROUP__c',  Order__c = 2, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='businessUnit', Header__c = 'Business Unit', Field_API_Name__c = 'Business_Unit__c',  Object_API_Name__c = 'OV_KPI_Dimension_Business_Unit__c',  Order__c = 3, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='geography', Header__c = 'Geography', Field_API_Name__c = 'Geography__c',  Object_API_Name__c = 'OV_KPI_Dimension_Geography__c',  Order__c = 4, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='organisationalUnit', Header__c = 'Org Unit', Field_API_Name__c = 'Organisational_Unit__c',  Object_API_Name__c = 'OV_KPI_Dimension_Org_Unit__c',  Order__c = 5, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='salesOrgNA', Header__c = 'Org Unit', Field_API_Name__c = 'NA_Sales_Org__c',  Object_API_Name__c = 'OV_KPI_Dimension_NA_Sales_Org__c',  Order__c = 6, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='opcoNA', Header__c = 'NA OPCO', Field_API_Name__c = 'NA_OPCO__c',  Object_API_Name__c = 'OV_KPI_Dimension_NA_OPCO__c',  Order__c = 7, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='productCategory', Header__c = 'Product Category', Field_API_Name__c = 'Product_Category__c',  Object_API_Name__c = 'OV_KPI_Dimension_Product_Category__c',  Order__c = 8, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='productCategoryNA', Header__c = 'NA Product Category', Field_API_Name__c = 'NA_Product_Category__c',  Object_API_Name__c = 'OV_KPI_Dimension_NAProductCategory__c',  Order__c = 9, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='brand', Header__c = 'Brand', Field_API_Name__c = 'Brand__c',  Object_API_Name__c = 'OV_KPI_Dimension_Brand__c',  Order__c = 10, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='brandNA', Header__c = 'NA Brand', Field_API_Name__c = 'NA_Brand__c',  Object_API_Name__c = 'OV_KPI_Dimension_NA_Brand__c',  Order__c = 11, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='customer', Header__c = 'Customer', Field_API_Name__c = 'Customer__c',  Object_API_Name__c = 'OV_KPI_Dimension_Customer__c',  Order__c = 12, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='channel', Header__c = 'Channel', Field_API_Name__c = 'Channel__c',  Object_API_Name__c = 'OV_KPI_Dimension_Channel__c',  Order__c = 13, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='kpiName', Header__c = 'KPI Name', Field_API_Name__c = 'KPI_Name__c',  Object_API_Name__c = 'OV_KPI_Dimension_KPI_Name__c',  Order__c = 14, isDisplayed__c = true));
             
        insert mappingList;     

        List<OV_KPI_Transaction__c> transactions = new List<OV_KPI_Transaction__c>();
        OV_KPI_Dimension_KPI_Name__c kpiName = new OV_KPI_Dimension_KPI_Name__c(Visible_Columns__c='brand;businessUnit;channel;', Code__c = TEST2_LABEL, Code_Text__c = TEST2_LABEL);
        insert kpiName;

        for(Integer i=0;i<200;i++){
            transactions.add(new OV_KPI_Transaction__c(Direction__c ='NO CHANGE', KPI_Name__c=kpiName.Id, KPI_Name_Code__c=TEST2_LABEL, Source__c='test123', File_Version__c='222', Source_Timestamp__c=Datetime.now(), Data_Tag__c=TEST2_LABEL, Value_Current_Period__c='1.2', Value_Previous_Period__c='2.2'));
        }
        insert transactions;
        Test.startTest();
        String query = 'SELECT Id FROM OV_KPI_Transaction__c';
        OV_BatchKpiNotification c = new OV_BatchKpiNotification(query);
        Database.executeBatch(c);
        Test.stopTest();
        system.assertEquals(null, OV_BatchKpiNotification.testBatchSize);
    }
}