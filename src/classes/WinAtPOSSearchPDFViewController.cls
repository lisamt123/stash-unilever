/**********************************************************************
Name: WinAtPOSSearchPDFViewController
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class is a Controller for WinAtPOSSearchPDFView Page
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          27/11/2014     INITIAL DEVELOPMENT
**********************************************************************/

public with sharing class WinAtPOSSearchPDFViewController {
    
    /*******************************************************************
	Purpose: Method retrive all aplicable assets for pdf file  
	Parameters: [optional]
	Returns: List<WINatPOSRemoteActionWrapper.AssetDetailForPDF>
	********************************************************************/
    public List<WINatPOSRemoteActionWrapper.AssetDetailForPDF> getAssets(){
        Map<String,String> params=ApexPages.currentPage().getParameters();
        String pageSize=params.get('pageSize');
        String pageNumber=params.get('pageNumber');
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.getSearchResultListPdf(params.get('searchType'), params.get('brandId'),params.get('categoryId'),params.get('keyWord'),params.get('assetType'),params.get('assetChannel'),params.get('assetCluster'),params.get('assetPlacment'),params.get('country'),Integer.valueOf(pageSize),Integer.valueOf(pageNumber),true);
        return (List<WINatPOSRemoteActionWrapper.AssetDetailForPDF>)response.data;
    }
    
    /*******************************************************************
	Purpose: Method add retrived files in pdf to download statistics
	Parameters: []
	Returns: []
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public PageReference addFilesToDwonloadStats() {
        System.Debug('*** WINatPOS addFilesToDwonloadStats start processing');
        Map<String,String> filesForDonwloadStats=new Map<String,String>();
        for(WINatPOSRemoteActionWrapper.AssetDetailForPDF assetItem: getAssets()){
            //get only files which feedId isn't null
            if(assetItem.assetPrimaryFileFeedId != null){
                filesForDonwloadStats.put(assetItem.assetPrimaryFileId,assetItem.assetPrimaryFileFeedId);
            }
        }
        //insert statistics only for assets which contains images
        WINatPOSUtilRemoteActions.addRecordsToDonwloadStatistics(filesForDonwloadStats);
        return null;
    }
}