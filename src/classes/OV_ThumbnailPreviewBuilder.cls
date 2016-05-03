/**********************************************************************
Name: OV_ThumbnailPreviewBuilder
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class used for preview link buliding
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_ThumbnailPreviewBuilder {

	private static String THUMB720BY480 = 'THUMB720BY480';
	private static String THUMB240BY180 = 'THUMB240BY180';
	private static String THUMB120BY90 = 'THUMB120BY90';

	public static String DESKTOP = THUMB720BY480;
	public static String TABLET = THUMB240BY180;
	public static String MOBILE = THUMB120BY90;

	public static String TOKEN = '{DEVICE_TYPE}';

	private static String SERVLET = '/sfc/servlet.shepherd/version/renditionDownload?rendition=';
    public static String SERVLET_DOWNLOAD = '/sfc/servlet.shepherd/version/download/';

    private static Integer PREVIEW_SIZE_LIMIT = 26214400;

    public static String prepareURL(String thumbSize, Id conVersionId){
        String thumb = thumbSize;
        if(thumbSize == MOBILE){
            thumb = TABLET;
        }else if(thumbSize == TABLET){
            thumb = DESKTOP;
        }
        return SERVLET + thumb + '&versionId=' + conVersionId;  
    }

    public static String prepareURL(String thumbSize, ContentVersion contentVerObject)
    {
        if(thumbSize == DESKTOP){
            return '/apex/OV_FilePreview?contentdocumentid='+ contentVerObject.ContentDocumentId;
        }else{
            return SERVLET + thumbSize + '&versionId=' + contentVerObject.Id;  
        }       
    }

    public static String prepareDownloadURL(Id conVersionId)
    {
        return SERVLET_DOWNLOAD + conVersionId;  
    }

    public static Boolean isPreviewAvailable(ContentVersion contentVerObject)
    {
        Set<String> supportedFormats = new Set<String>{'txt', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'pdf', 'jpg', 'jpeg', 'bmp', 'png', 'gif'};

        String ext = contentVerObject.FileExtension;
        ext = ext.toLowerCase();

        if(contentVerObject.ContentSize > PREVIEW_SIZE_LIMIT){
            return false;
        }else if(! supportedFormats.contains(ext)){
            return false;
        }else{
            return true;
        }
    }
}