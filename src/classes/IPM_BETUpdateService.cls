/*************************************************************************************
Name : IPM_BETUpdateService

Purpose : Stub class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  23-07-2015  Initial
*************************************************************************************/

public with sharing class IPM_BETUpdateService {

	private IPM_BETUpdateService(){}

	public static Boolean CategoryCheck(String selectedCategory) {
		try{
			List<MDO_ProductCategorysubscriptions__c> subscriptions = [select id from MDO_ProductCategorysubscriptions__c where product_category_id__c=:selectedCategory limit 1];
			return !subscriptions.isEmpty();
		}catch(Exception e) {
			throw new IPM_CustomException(e);
		}
		return false;
	}

	public static Boolean UserAccess(Id betId,Id IPMProjectId,Id userId){
		try{
			return true;
		}catch(Exception e) {
			throw new IPM_CustomException(e);
		}
		return true;
	}
}