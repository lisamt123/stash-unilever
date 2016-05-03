/**********************************************************************
Name: OV_ThumbnailPreviewBuilder_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test for OV_ThumbnailPreviewBuilder
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
1.1 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class OV_ThumbnailPreviewBuilder_Test {
    static final String testLabel = 'test';

    @isTest static void testPrepareUrlDesktop() {
        ContentVersion obj = OV_TestingHelper.initContentVersion(testLabel, true);

        String expected = '/apex/OV_FilePreview?contentdocumentid='+obj.ContentDocumentId;
        String actual = OV_ThumbnailPreviewBuilder.prepareURL(OV_ThumbnailPreviewBuilder.DESKTOP, obj);
        System.assertEquals(expected, actual);
    }

    @isTest static void testPrepareUrlTablet() {
        ContentVersion obj = OV_TestingHelper.initContentVersion(testLabel, true);

        Id id = obj.Id; 
        String expected = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId='+id;
        String actual = OV_ThumbnailPreviewBuilder.prepareURL(OV_ThumbnailPreviewBuilder.TABLET, obj.Id);
        System.assertEquals(expected, actual);
    }

    @isTest static void testPrepareUrlMobile() {
        ContentVersion obj = OV_TestingHelper.initContentVersion(testLabel, true);

        Id id = obj.Id;
        String expected = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB240BY180&versionId='+id;
        String actual = OV_ThumbnailPreviewBuilder.prepareURL(OV_ThumbnailPreviewBuilder.MOBILE, obj.Id);
        System.assertEquals(expected, actual);
        actual = OV_ThumbnailPreviewBuilder.prepareURL(OV_ThumbnailPreviewBuilder.MOBILE, obj);
        actual = OV_ThumbnailPreviewBuilder.prepareDownloadURL(obj.Id);
        System.assertEquals(OV_ThumbnailPreviewBuilder.SERVLET_DOWNLOAD+obj.Id, actual);
    }

    @isTest static void testPrepareUrlToken() {
        ContentVersion obj = OV_TestingHelper.initContentVersion(testLabel, true);

        Id id = obj.Id;
        String token = OV_ThumbnailPreviewBuilder.TOKEN;
        String expected = '/sfc/servlet.shepherd/version/renditionDownload?rendition=' +  token + '&versionId='+id;
        String actual = OV_ThumbnailPreviewBuilder.prepareURL(OV_ThumbnailPreviewBuilder.TOKEN, obj);
        System.assertEquals(expected, actual);
    }   

    @isTest static void testPreviewAvailable() {
        ContentVersion obj = OV_TestingHelper.initContentVersion(testLabel, true);
        Boolean isAv = OV_ThumbnailPreviewBuilder.isPreviewAvailable(obj);
        System.assertEquals(true, isAv);
    }
}