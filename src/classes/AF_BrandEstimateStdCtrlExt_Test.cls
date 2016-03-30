/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimateStdCtrlExt_Test
@CreateDate : 11/9/2014
@Description : This is a Test class for AF_BrandEstimateStdCtrlExt class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_BrandEstimateStdCtrlExt_Test
{    
	Static Integer IcurrYear = System.Today().year();
	Static string currYear=string.valueof(IcurrYear);
	static user userforBrandEstimateStdCtrlExt;
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : brandEstimateStdCtrl
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void brandEstimateStdCtrl ()
	{
		Test.startTest();
		userforBrandEstimateStdCtrlExt=AF_TestFactory_Helper.createUserAdmin(true);
		User u=[SELECT id FROM user WHERE id=:userforBrandEstimateStdCtrlExt.id LIMIT 1];
		System.runAs(u)
		{ 
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
			List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
			System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
			//insert oopsetting record.
			List<AF_OOPS_Settings__c> oopsetting = AF_TestFactory_Helper.insertOOPsetting(true,1);
			List<AF_OOPS_Settings__c> oopsettingQuery = [SELECT ID FROM AF_OOPS_Settings__c LIMIT 1];
			system.assert(oopsettingQuery[0].id!=null,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//Insert Currency
			List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
			List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
			System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
			ApexPages.StandardController sc = new ApexPages.StandardController(BrandEst[0]);
			ApexPages.currentPage().getParameters().put('id',BrandEst[0].id);
			//Create Instance of the Class         
			AF_BrandEstimateStdCtrlExt bes=new AF_BrandEstimateStdCtrlExt(sc);   
			bes.SetStatus();  
			Test.stopTest();
		}
	}
}