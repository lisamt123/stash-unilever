/*************************************************************************************
Name : BET_AssetDispatcherController

Purpose : Sets access rights to asset content and redirects to appropriate salesforce page

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  25-01-2016  Initial
*************************************************************************************/
public with sharing class BET_AssetDispatcherController {

	public static final String PREVIEW = 'preview';
	public static final String DOWNLOAD = 'download';
	public static final String FILEID_PARAM = 'fileId'; 
	public static final String TYPE_PARAM = 'type';
	public static final String DOWNLOADLINK_PARAM = 'downloadLink';

	private String fileId {get;set;}
	private String type {get;set;}
	private String downloadLink {get;set;}

	public BET_AssetDispatcherController() {
		fileId = getParameter(FILEID_PARAM);
		type = getParameter(TYPE_PARAM);
		downloadLink = getParameter(DOWNLOADLINK_PARAM);
	}

	/************************************************************
		Purpose: Method sets access rights to asset content and redirects to appropriate salesforce page
		Parameters: -
		Returns: PageReference
	*************************************************************/
	public PageReference grantAccess(){
		if(BET_CommonService.isBETOperationAdmin() || BET_CommonService.isHubAdmin()){
			BET_AssetService.grantAccessToAsset((Id)fileId,UserInfo.getUserId());
		}
		PageReference pr;
		if(type == PREVIEW) {
			pr = new PageReference('/'+fileId);
		} else if (type == DOWNLOAD){
			pr = new PageReference(downloadLink);
		}
		pr.setRedirect(true);
		return pr;
	}

	/************************************************************
		Purpose: Method gets parameter by its name
		Parameters: String paramName
		Returns: String
	*************************************************************/
	private String getParameter(String paramName){
		if(ApexPages.currentPage().getParameters().get(paramName) != null) {
			return ApexPages.currentPage().getParameters().get(paramName);
		}
		return null;
	}
}