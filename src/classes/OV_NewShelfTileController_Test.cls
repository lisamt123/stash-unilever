/**********************************************************************
Name: OV_NewShelfTileController_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test for OV_NewShelfTileController
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             18/05/2015      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class OV_NewShelfTileController_Test {
	@isTest
    static void testWithTilesOnShelf() {
    	OV_Shelf__c shelf1 = OV_TestingHelper.initShelf('Shelf1', 'Subject', true);
        OV_Shelf_Tile__c tile1 = OV_TestingHelper.initShelfTile('Tile 1', '#ccc', 'www.test.com/image.png', shelf1, true);
        OV_Shelf_Tile__c tile2 = OV_TestingHelper.initShelfTile('Tile 2', '#ccc', 'www.test.com/image.png', shelf1, false);

        ApexPages.StandardController sc = new ApexPages.StandardController(tile2);
		OV_NewShelfTileController controller = new OV_NewShelfTileController(sc);
		controller.calculateSortOrder();

		System.assertEquals(2, controller.record.Sort_Order__c);
	}

	@isTest
    static void testWithoutTilesOnShelf() {
    	OV_Shelf__c shelf1 = OV_TestingHelper.initShelf('Shelf1', 'Subject', true);
        OV_Shelf_Tile__c tile2 = OV_TestingHelper.initShelfTile('Tile 2', '#ccc', 'www.test.com/image.png', shelf1, false);

        ApexPages.StandardController sc = new ApexPages.StandardController(tile2);
		OV_NewShelfTileController controller = new OV_NewShelfTileController(sc);
		controller.calculateSortOrder();

		System.assertEquals(1, controller.record.Sort_Order__c);
	}
}