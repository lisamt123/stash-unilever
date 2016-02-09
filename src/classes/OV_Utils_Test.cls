/**********************************************************************
Name: OV_Utils_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test Class test OV_Utils
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             29/05/2015      INITIAL DEVELOPMENT
**********************************************************************/

@isTest
private class OV_Utils_Test {
    
    @isTest static void test_method_one() {
                OV_Brand__c brand1 = OV_TestingHelper.initBrand('Brand 1', true);
                OV_Brand__c brand2 = OV_TestingHelper.initBrand('Brand 2', true);
                OV_Brand__c brand3 = OV_TestingHelper.initBrand('Brand 3', true);
                OV_Brand__c brand4 = OV_TestingHelper.initBrand('Brand 4', true);
                OV_Brand__c brand5 = OV_TestingHelper.initBrand('Brand 5', true);

                OV_Comparator__c comparator1 = OV_TestingHelper.initBrandComparator('Comparator 1', true);
                OV_Comparator__c comparator2 = OV_TestingHelper.initBrandComparator('Comparator 2', true);
                OV_Comparator__c comparator3 = OV_TestingHelper.initBrandComparator('Comparator 3', true);
                OV_Comparator__c comparator4 = OV_TestingHelper.initBrandComparator('Comparator 4', true);

                OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);
                OV_Category__c category2 = OV_TestingHelper.initCategory('Category 2', category1, true);
                OV_Category__c category3 = OV_TestingHelper.initCategory('Category 3', category2, true);

                OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);
                OV_Function__c function2 = OV_TestingHelper.initFunction('Function 2', function1, true);
                OV_Function__c function3 = OV_TestingHelper.initFunction('Function 3', function2, true);

                OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);
                OV_Geography__c geography2 = OV_TestingHelper.initGeography('Geography 2', geography1, true);
                OV_Geography__c geography3 = OV_TestingHelper.initGeography('Geography 3', geography2, true);

                OV_Customer__c customer1 = OV_TestingHelper.initCustomer('Test Customer 1', true);
                OV_Customer__c customer2 = OV_TestingHelper.initCustomer('Test Customer 2', customer1, true);

                List<Object> brandsList = OV_Utils.getBrands();
                System.assertEquals(5, brandsList.size());

                List<Object> comparatorList = OV_Utils.getComparators();
                System.assertEquals(4, comparatorList.size());

                List<Object> categoriesList = OV_Utils.getSortedNestedFilters('category');
                System.assertEquals(1, categoriesList.size());

                OV_Wrapper.CategoryWrapper categoryCast1 = (OV_Wrapper.CategoryWrapper)categoriesList[0];
                System.assertEquals(category1.Id, categoryCast1.categoryId);
                System.assertEquals(1, categoryCast1.categoryChilds.size());

                OV_Wrapper.CategoryWrapper categoryCast2 = (OV_Wrapper.CategoryWrapper)categoryCast1.categoryChilds[0];
                System.assertEquals(category2.Id, categoryCast2.categoryId);
                System.assertEquals(1, categoryCast2.categoryChilds.size());

                OV_Wrapper.CategoryWrapper categoryCast3 = (OV_Wrapper.CategoryWrapper)categoryCast2.categoryChilds[0];
                System.assertEquals(category3.Id, categoryCast3.categoryId);

                List<Object> functionsList = OV_Utils.getSortedNestedFilters('function');
                System.assertEquals(1, functionsList.size());
                OV_Wrapper.FunctionWrapper functionCast1 = (OV_Wrapper.FunctionWrapper)functionsList[0];
                System.assertEquals(function1.Id, functionCast1.functionId);
                System.assertEquals(1, functionCast1.functionChilds.size());

                OV_Wrapper.FunctionWrapper functionCast2 = (OV_Wrapper.FunctionWrapper)functionCast1.functionChilds[0];
                System.assertEquals(function2.Id, functionCast2.functionId);
                System.assertEquals(1, functionCast2.functionChilds.size());
                OV_Wrapper.FunctionWrapper functionCast3 = (OV_Wrapper.FunctionWrapper)functionCast2.functionChilds[0];
                System.assertEquals(function3.Id, functionCast3.functionId);

                List<Object> geographiesList = OV_Utils.getSortedNestedFilters('geography');
                System.assertEquals(1, geographiesList.size());
                OV_Wrapper.GeographyWrapper geographyCast1 = (OV_Wrapper.GeographyWrapper) geographiesList[0];
                System.assertEquals(geography1.Id, geographyCast1.geographyId);
                System.assertEquals(1, geographyCast1.geographyChilds.size());

                OV_Wrapper.GeographyWrapper geographyCast2 = (OV_Wrapper.GeographyWrapper) geographyCast1.geographyChilds[0];
                System.assertEquals(geography2.Id, geographyCast2.geographyId);
                System.assertEquals(1, geographyCast2.geographyChilds.size());

                OV_Wrapper.GeographyWrapper geographyCast3 = geographyCast2.geographyChilds[0];
                System.assertEquals(geography3.Id, geographyCast3.geographyId);

                List<Object> timespanList = OV_Utils.getTimespans();
                System.assertEquals(true, (timespanList.size() > 0) );

                List<Object> channelsList = OV_Utils.getChannels();
                System.assertEquals(true, (channelsList.size() > 0) );

                List<Object> customerList = OV_Utils.getSortedNestedFilters('customer');
                System.assertEquals(1, customerList.size());
                OV_Wrapper.CustomerWrapper customerCast1 = (OV_Wrapper.CustomerWrapper)customerList[0];
                System.assertEquals(customer1.Id, customerCast1.customerId);
                System.assertEquals(1, customerCast1.customerChilds.size());
                OV_Wrapper.CustomerWrapper customerCast2 = (OV_Wrapper.CustomerWrapper)customerCast1.customerChilds[0];
                System.assertEquals(customer2.Id, customerCast2.customerId);

                List<Object> headingList = OV_Utils.getReportHeadings();
    }

        @isTest static void testSavedFilters() {
                OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);
                OV_Category__c category2 = OV_TestingHelper.initCategory('Category 2', category1, true);
                OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);
                OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);
                OV_Geography__c geography2 = OV_TestingHelper.initGeography('Geography 2', geography1, true);
                OV_Geography__c geography3 = OV_TestingHelper.initGeography('Geography 3', geography2, true);

                OV_Geography__c geography5 = OV_TestingHelper.initGeography('Geography 5', true);
                OV_Geography__c geography6 = OV_TestingHelper.initGeography('Geography 6', geography5, true);

                User u = OV_TestingHelper.createAdminUser('test', 'test@test.com', 'test2');
                OV_Profile__c profile = OV_TestingHelper.initProfile('Profile1', u, true);

                System.runAs(u){
                    System.assertEquals(null, OV_Utils.getSavedFilters());
                    OV_Utils.saveFilters(geography3.Id, category2.Id, function1.Id, false);
                    Map<String, String> savedFilters = OV_Utils.getSavedFilters();
                    System.assertEquals(category1.Id, savedFilters.get('category1Id'));
                    System.assertEquals(category2.Id, savedFilters.get('category2Id'));

                    System.assertEquals(function1.Id, savedFilters.get('functionId'));

                    System.assertEquals(geography1.Id, savedFilters.get('geography1Id'));
                    System.assertEquals(geography2.Id, savedFilters.get('geography2Id'));
                    System.assertEquals(geography3.Id, savedFilters.get('geography3Id'));

                    OV_Utils.saveFilters(geography6.Id, category2.Id, function1.Id, false);
                    savedFilters = OV_Utils.getSavedFilters();
                    System.assertEquals(geography5.Id, savedFilters.get('geography1Id'));
                    System.assertEquals(geography6.Id, savedFilters.get('geography2Id'));
                }
        }
        
    @isTest static void wrapperTests() {
        User u = OV_TestingHelper.createAdminUser('test', 'test@test.com', 'test2');
        
        OV_Wrapper.ReportWrapper report1 = new OV_Wrapper.ReportWrapper(u.Id, 'Report Title 1');
        report1.reportCreatedDate = DateTime.now();
        OV_Wrapper.ReportWrapper report2 = new OV_Wrapper.ReportWrapper(u.Id, 'Report Title 2');
        report2.reportCreatedDate = DateTime.now().addDays(-1);
        system.assertEquals(-1, report2.compareTo(report1));
        
        OV_Shelf__c s1 = new OV_Shelf__c(Sort_Order__c = 1);
        insert s1;
        OV_Shelf__c s2 = new OV_Shelf__c(Sort_Order__c = 1);
        insert s2;
        
        OV_Wrapper.ShelfWrapper shelf1 = new OV_Wrapper.ShelfWrapper(s1);
        shelf1.shelfCreatedDate = DateTime.now();
        OV_Wrapper.ShelfWrapper shelf2 = new OV_Wrapper.ShelfWrapper(s2);
        shelf2.shelfCreatedDate = DateTime.now().addDays(-1);
        system.assertEquals(-1, shelf2.compareTo(shelf1));
        
        OV_Shelf_Tile__c st1 = new OV_Shelf_Tile__c(Shelf__c = s1.Id, Sort_Order__c = 1);
        insert st1;
        OV_Shelf_Tile__c st2 = new OV_Shelf_Tile__c(Shelf__c = s2.Id, Sort_Order__c = 1);
        insert st2;
        
        OV_Wrapper.ShelfTileWrapper shelfTile1 = new OV_Wrapper.ShelfTileWrapper(st1);
        shelfTile1.shelfTileCreatedDate = DateTime.now();
        OV_Wrapper.ShelfTileWrapper shelfTile2 = new OV_Wrapper.ShelfTileWrapper(st2);
        shelfTile2.shelfTileCreatedDate = DateTime.now().addDays(-1);
        system.assertEquals(-1, shelfTile2.compareTo(shelfTile1));
        
        List<OV_Wrapper.ShelfTileWrapper> cShelfTiles = new List<OV_Wrapper.ShelfTileWrapper>();
        cShelfTiles.add(shelfTile1);
        cShelfTiles.add(shelfTile2);
        shelf1.addTiles(cShelfTiles);
        system.assertEquals(2, shelf1.getTiles().size());
    }
}