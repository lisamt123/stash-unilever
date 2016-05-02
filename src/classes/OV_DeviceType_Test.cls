/**********************************************************************
Name: OV_DeviceType_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test for OV_DeviceType
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class OV_DeviceType_Test {	
	@isTest static void testConstants() {
		System.assertNotEquals(OV_DeviceType.DESKTOP, OV_DeviceType.MOBILE);
		System.assertNotEquals(OV_DeviceType.DESKTOP, OV_DeviceType.TABLET);
		System.assertNotEquals(OV_DeviceType.MOBILE, OV_DeviceType.TABLET);
		System.assertNotEquals(null, OV_DeviceType.DESKTOP);
		System.assertNotEquals(null, OV_DeviceType.TABLET);
		System.assertNotEquals(null, OV_DeviceType.MOBILE);
	}

	@isTest static void testDescription() {
		System.assertEquals('Desktop', OV_DeviceType.descriptionForType(OV_DeviceType.DESKTOP));
		System.assertEquals('Tablet', OV_DeviceType.descriptionForType(OV_DeviceType.TABLET));
		System.assertEquals('Mobile', OV_DeviceType.descriptionForType(OV_DeviceType.MOBILE));
		System.assertEquals('unknown', OV_DeviceType.descriptionForType(-1));
	}

	@isTest static void testTypeForParameter() {
		System.assertEquals(OV_DeviceType.DESKTOP, OV_DeviceType.typeForParameter('D'));
		System.assertEquals(OV_DeviceType.TABLET, OV_DeviceType.typeForParameter('T'));
		System.assertEquals(OV_DeviceType.MOBILE, OV_DeviceType.typeForParameter('M'));
		System.assertEquals(OV_DeviceType.DESKTOP, OV_DeviceType.typeForParameter('OTHER'));	
	}	
}