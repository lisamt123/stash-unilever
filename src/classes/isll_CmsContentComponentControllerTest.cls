/**********************************************************************
 Name:  isll_CmsContentComponentControllerTest
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Test Class for isll_CmsContentComponentController class
======================================================
History
-------
VERSION		AUTHOR				DATE			DETAIL				Description
   1.0		Liza Romanenko		16/07/2013		INITIAL DEVELOPMENT 
***********************************************************************/
@isTest
private class isll_CmsContentComponentControllerTest {

    static testMethod void test_getCmsComponentContent() {
    	//Create test data
    	CMS_Content__c c = isll_TestData.createCMSContent('Text');
    	insert c;
    	
        isll_CmsContentComponentController contr = new isll_CmsContentComponentController();
        contr.cmsComponentName = c.Name;
        
        system.assertEquals(c.Content__c, contr.cmsComponentContent);
        system.assertEquals(c.Type__c, contr.contentType);
        
        contr.getShowEditLink();
        
        contr.editContent();
        
        contr.saveInline();
        
        contr.saveAndBack();
        
        contr.cancel();
        
        contr.deleteContent();

        contr.changeType();

        contr.changeTypeSave();

        contr.changeTypeCancel();
    }
    
    static testMethod void test_getCmsComponentContent_noContent() {
    	
        isll_CmsContentComponentController contr = new isll_CmsContentComponentController();
        contr.cmsComponentName = '';
        String content = contr.cmsComponentName;
        
        system.assertEquals('', content);
        
        contr.cmsComponentName = 'not existed name';
        content = contr.contentType;
        
        system.assertEquals(null, content);
    }
    
    static testMethod void test_contentWithEvent() {
    	//Create test data
    	Event__c theEvent = isll_TestData.createEvent();
		insert theEvent;
		
    	CMS_Content__c c   = isll_TestData.createCMSContent('Text');
    	c.Event__c         = theEvent.Id;
        insert c;
    	
    	Apexpages.currentPage().getParameters().put('event', 'true');
    	
        isll_CmsContentComponentController contr = new isll_CmsContentComponentController();
        contr.cmsComponentName = c.Name;
        
        system.assert(contr.showEvent);
        system.assertEquals('Text', contr.contentType);
        system.assertEquals(0, contr.daysToGo);
    }
}