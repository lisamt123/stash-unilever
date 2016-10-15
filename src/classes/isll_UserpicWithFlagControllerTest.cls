/**********************************************************************
 Name:  isll_UserpicWithFlagControllerTest
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Test Class for isll_UserpicWithFlagController
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      07/08/2013      INITIAL DEVELOPMENT 
***********************************************************************/
@isTest
private class isll_UserpicWithFlagControllerTest {

    static testMethod void test_isll_UserpicWithFlagController() {
        User u = [SELECT LocaleSidKey FROM User LIMIT 1];
        isll_UserpicWithFlagController contr = new isll_UserpicWithFlagController();
        contr.cUser = u;
        String icon = contr.getIconName();
        
        system.assertNotEquals(null, icon);
    }
}