/*************************************************************************************
Name : BET_UpdateExpectedAssetsController

Purpose : Controller for BET_UpdateExpectedAssets

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  22-09-2015  Initial
*************************************************************************************/
public with sharing class BET_UpdateExpectedAssetsController {

	public Id betId {get;set;}
	public Boolean runJsSuccess {get;set;}

	/************************************************************
        Purpose: Page controller constructor
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
	public BET_UpdateExpectedAssetsController() {
		System.debug('Entering BET_UpdateExpectedAssetsController');
		betId = (Id)ApexPages.currentPage().getParameters().get('id');
		runJsSuccess = false;
	}

	/************************************************************
        Purpose: Method called during saving 
        Parameters: -
        Returns: PageReference
        Throws: -
    *************************************************************/
	public PageReference onSave(){
		System.debug('Entering onSave');
		runJsSuccess = true;
		return null;
	}
}