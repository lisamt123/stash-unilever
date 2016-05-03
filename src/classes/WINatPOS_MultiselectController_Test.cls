/**********************************************************************
Name: WINatPOSUtilRemoteActions
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test class for WINatPOS_MultiselectController
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela       24/11/2015         INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class WINatPOS_MultiselectController_Test {

	/*******************************************************************
    Purpose: Test method for MultiselectController 
    Parameters: [optional]
    Returns: void
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    static testMethod void testMultiselectController() {
        WINatPOS_MultiselectController c = new WINatPOS_MultiselectController();
        
        c.leftOptions = new List<SelectOption>();
        c.rightOptions = new List<SelectOption>();

        c.leftOptionsHidden = 'A&a&b&b&C&c';
        c.rightOptionsHidden = '';
        
        System.assertEquals(c.leftOptions.size(), 3);
        System.assertEquals(c.rightOptions.size(), 0);
    }
}