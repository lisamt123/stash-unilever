@istest
private class BET_EditAssetController_Test {

    private static final String RESULT_NOT_NULL = 'Result should not be null';
    private static final String RESULT_NULL = 'Result should be null';
    private static final String ERROR_MESSAGE_MATCH = 'Error message should match';
    private static final String ONE_RECORD = 'There should be one record';
    private static final String STATUS_MATCH = 'Status should match';

    private static BET_TestingHelper.BET_TestingData prepareData() {
        return prepareData(false, BET_TestingHelper.BET_STATUS_UNRELEASED);
    }

    private static BET_TestingHelper.BET_TestingData prepareData(Boolean addMember) {
        return prepareData(addMember, BET_TestingHelper.BET_STATUS_UNRELEASED);
    }

    private static BET_TestingHelper.BET_TestingData prepareData(Boolean addMember, String status) {
        BET_TestingHelper.BET_TestingData betWrapper = BET_TestingHelper.initBET(
            BET_TestingHelper.getDefaultOwner(), 'UT_BET', status, true, true);
        uw_Asset__c asset = betWrapper.addCreativeWork('creative-work.pdf', BET_TestingHelper.ASSET_STATUS_DRAFT);

        if (addMember) {
            betWrapper.addMember();
        }

        System.Test.setCurrentPageReference(Page.BET_EditAsset);
        return betWrapper;
	}

    static testMethod void validateDataBDEmptySubFunction(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        List<String> result;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c = null;
            result = controller.validateData();            
        }         
        Test.stopTest();
        System.assertNotEquals(null, result,RESULT_NOT_NULL);
        System.assertEquals(1, result.size(),ONE_RECORD);
        System.assertEquals('Sub Function cannot be empty.', result[0],ERROR_MESSAGE_MATCH);
    }

    static testMethod void validateDataBDEmptyStatusAndStudioAssetType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        List<String> result;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Status__c = null;
            controller.file.Studio_Asset_Type__c = null;
            result = controller.validateData();            
        }         
        Test.stopTest();

        System.assertNotEquals(null, result,RESULT_NOT_NULL);
        System.assertEquals(2, result.size(),'There should be two records');
        System.assertEquals('Status cannot be empty.', result[0],ERROR_MESSAGE_MATCH);
        System.assertEquals('Type cannot be empty.', result[1],ERROR_MESSAGE_MATCH);
    }

    static testMethod void validateDataBDInvalidSubFunctionForUser(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        BET_EditAssetController controller;
        List<String> result;

        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c = null;
            controller.file.Studio_Asset_Type__c = null;
            result = controller.validateData();            
        }         
        Test.stopTest();

        System.assertNotEquals(null, result,RESULT_NOT_NULL);
        System.assertEquals(3, result.size(),'There should be three records');
        System.assertEquals('Not allowed to add Brand Development.', result[0],ERROR_MESSAGE_MATCH);
        System.assertEquals('Status cannot be empty.', result[1],ERROR_MESSAGE_MATCH);
        System.assertEquals('Type cannot be empty.', result[2],ERROR_MESSAGE_MATCH);
    }

    static testMethod void validateDataBDEmptyMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        List<String> result;
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            controller.file.Media_Type__c        = null;
            result = controller.validateData();            
        }         
        Test.stopTest();

        System.assertNotEquals(null, result,RESULT_NOT_NULL);
        System.assertEquals(1, result.size(),ONE_RECORD);
        System.assertEquals('Media Type cannot be empty.', result[0],ERROR_MESSAGE_MATCH);
    }

    static testMethod void validateDataBDInvalidInvalidMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        List<String> result;

        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            result = controller.validateData();            
        }
        Test.stopTest();

        System.assertNotEquals(null, result,RESULT_NOT_NULL);
        System.assertEquals(1, result.size(),ONE_RECORD);
        System.assertEquals('Media Type cannot be Brand Experience Presentation.', result[0],ERROR_MESSAGE_MATCH);
    }

    static testMethod void validateDataBDEmptyCountry(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        List<String> result;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = null;
            result = controller.validateData();            
        }         
        Test.stopTest();

        System.assertNotEquals(null, result,RESULT_NOT_NULL);
        System.assertEquals(1, result.size(),ONE_RECORD);
        System.assertEquals('Country cannot be empty.', result[0],ERROR_MESSAGE_MATCH);
    }

    static testMethod void validateDataBDBDClearCountryAndMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        List<String> result;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_PRESENTATION;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            result = controller.validateData();            
        }         
        Test.stopTest();

        System.assertNotEquals(null, result,RESULT_NOT_NULL);
        System.assertEquals(0, result.size(),'There should be no records');
        System.assertEquals(null, controller.file.Media_Type__c,RESULT_NULL);
        System.assertEquals(null, controller.file.Country__c,RESULT_NULL);
    }    

    static testMethod void validateDataBBEnforceStatus(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        BET_EditAssetController controller;
        List<String> result;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_PRESENTATION;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            result = controller.validateData();            
        }         
        Test.stopTest();

        System.assertNotEquals(null, result,RESULT_NOT_NULL);
        System.assertEquals(0, result.size(),'There should be no records');
        System.assertEquals(BET_TestingHelper.ASSET_STATUS_SHARED, controller.file.Status__c,STATUS_MATCH);
        System.assertEquals(null, controller.file.Studio_Asset_Type__c,RESULT_NULL);
    }    

    static testMethod void validateDataBBEmptyMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        BET_EditAssetController controller;
        List<String> result;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            controller.file.Media_Type__c        = null;
            result = controller.validateData();            
        }         
        Test.stopTest();

        System.assertNotEquals(null, result,RESULT_NOT_NULL);
        System.assertEquals(1, result.size(),ONE_RECORD);
        System.assertEquals('Media Type cannot be empty.', result[0],ERROR_MESSAGE_MATCH);
    }  

}