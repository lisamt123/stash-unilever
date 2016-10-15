/**********************************************************************
 Name:  isll_ReturnUrlExtentionTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: The test class for the isll_ReturnUrlExtention                                                       
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     30/07/2013        INITIAL DEVELOPMENT         Story id:..  	
 
***********************************************************************/
@isTest
private class isll_ReturnUrlExtentionTest {
    
    static private void initData() {
        ISLL_Custom_Settings__c chatterGroupName    = isll_TestData.createISLLCustomSetting(isll_TestData.CHATTER_GROUP);
        chatterGroupName.String_Value__c            = isll_TestData.ISLL_NAME;
        insert chatterGroupName;
        /*if(null ==  ISLL_Custom_Settings__c.getValues('ISLL Chatter Group')){
            ISLL_Custom_Settings__c chatterGroupName = new ISLL_Custom_Settings__c();
            chatterGroupName.String_Value__c = 'Internal Sustainable Living Lab';
            chatterGroupName.Name = 'ISLL Chatter Group';
            insert chatterGroupName;
        }*/
    }

	static testMethod void EmptyConsTest(){
		isll_ReturnUrlExtention controller = new isll_ReturnUrlExtention();
	}
	static testMethod void standardContConsTest(){
		isll_ReturnUrlExtention controller = new isll_ReturnUrlExtention(new ApexPages.standardController(new User()));
		Test.setCurrentPage(new PageReference('www.google.com'));
		system.assertEquals('www.google.com' , controller.getBackUrl());

		 ApexPages.currentPage().getParameters().put('returnPage', 'www.google.com');
		 system.assertEquals('www.google.com' , controller.extCancel().getUrl());
		 
	}

	static testMethod void cmsContentTest(){
        initData();
		isll_ReturnUrlExtention controller  =  new isll_ReturnUrlExtention( new isll_CmsContentComponentController());
    	
    }
    
    static testMethod void sustainTest(){
        initData();
    	isll_ReturnUrlExtention controller  =  new isll_ReturnUrlExtention( new isll_SustainExpComponentController());
    	
    }
    
    static testMethod void  modControlTest(){
        initData();
    	isll_ReturnUrlExtention controller  =  new isll_ReturnUrlExtention( new isll_ModeratorComponentController());
    }
    
    static testMethod void  editPageContent(){
        initData();
    	isll_ReturnUrlExtention controller  =  new isll_ReturnUrlExtention(new isll_EditPageContentController());
    	
    }
    
    static testMethod void artComp(){
        initData();
    	isll_ReturnUrlExtention controller  =  new isll_ReturnUrlExtention (new isll_ArticleComponentController());
    }
    
    static testMethod void  uslpBrand(){
        initData();
    	isll_ReturnUrlExtention controller  =  new isll_ReturnUrlExtention (new isll_USLPBrandTableComponentController());
	}
}