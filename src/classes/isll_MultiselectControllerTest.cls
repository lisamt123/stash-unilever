/**********************************************************************
 Name:  isll_MultiselectControllerTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:Manages test class for the multiselect controller                                                           
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     16/07/2013        INITIAL DEVELOPMENT         Story id:..  	
 
***********************************************************************/
@isTest
private class isll_MultiselectControllerTest {
    static testMethod void testMultiselectController() {
        isll_MultiselectController c = new isll_MultiselectController();
        
        c.leftOptions = new List<SelectOption>();
        c.rightOptions = new List<SelectOption>();

        c.leftOptionsHidden = 'A&a&b&b&C&c';
        c.rightOptionsHidden = '';
        
        System.assertEquals(c.leftOptions.size(), 3);
        System.assertEquals(c.rightOptions.size(), 0);
    }
}