/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimatesBatch_Test
@CreateDate : 13/9/2014
@Description : This is a Test class for AF_BrandEstimatesBatch class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_BrandEstimatesBatch_Test
{    
	public static string AGNECY_DATE =' The Agency date record is inserted';
	static user userforbrandestimateupdate;
	static string Query='Select Id, Name, AF_Status_Base_Fees__c from AF_Brand_Estimate__c';
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_BrandEstimatesBatch
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void AF_BrandEstimatesBatch()
	{
		Test.startTest();
		userforbrandestimateupdate=AF_TestFactory_Helper.createUserAdmin(true);
		User u=[SELECT id FROM user WHERE id=:userforbrandestimateupdate.id LIMIT 1];
		System.runAs(u)
		{ 
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null,AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
			List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
			System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
			//insert brandestimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> brandestimatequery=[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
			AF_BrandEstimatesBatch estimate = new AF_BrandEstimatesBatch(Query);
			database.executeBatch(estimate);
			Test.stopTest();
		}
	}
}