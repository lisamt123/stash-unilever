@isTest
private class uw_CustomAssetUploadExtensionTest2 {
    private static BET_TestingHelper.BET_TestingData prepareData() {
        return prepareData(false, BET_TestingHelper.BET_STATUS_UNRELEASED);
    }

    private static BET_TestingHelper.BET_TestingData prepareData(Boolean addMember) {
        return prepareData(addMember, BET_TestingHelper.BET_STATUS_UNRELEASED);
    }

    private static BET_TestingHelper.BET_TestingData prepareData(Boolean addMember, String status) {
        BET_TestingHelper.BET_TestingData betWrapper = BET_TestingHelper.initBET(
            BET_TestingHelper.getDefaultOwner(), 'UT_BET', status, true, true);

        if (addMember) {
            betWrapper.addMember();
        }

        Id parentId = betWrapper.BET.Studio_Chatter_Group__c; 
            
        System.Test.setCurrentPageReference(Page.uw_CustomAssetUpload);
        System.currentPageReference().getParameters().put('id', parentId);

        return betWrapper; 
    }
    static testMethod void validateDataBBEmptyCountry(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        uw_CustomAssetUploadExtension controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed();
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Country cannot be empty.', result[0]);
    }  

    static testMethod void validateDataBBNotAllowed(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        uw_CustomAssetUploadExtension controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed();
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Not allowed to add Brand Building.', result[0]);
    }
}