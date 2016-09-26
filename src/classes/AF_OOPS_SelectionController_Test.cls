/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_OOPS_SelectionController
@Created Date : 15/09/2014.
@Description : This Test class for  AF_OOPS_SelectionController   apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_OOPS_SelectionController_Test
{
	Static Integer IcurrYear = System.Today().year()-1;
	Static string currYear=string.valueof(IcurrYear);
	static user userforOOPS_Selection;
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : AFselectionController
*  @param : none
*  @return : none
*************************************************************************/ 
	Static testMethod void AFselectionController()
	{
		Test.startTest();
		userforOOPS_Selection=AF_TestFactory_Helper.createUserAdmin(true);
		User u=[SELECT id,Email FROM user WHERE id=:userforOOPS_Selection.id LIMIT 1];
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
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
			List<AF_OOPS_Actual__c> OopsactualList1=new List<AF_OOPS_Actual__c>();
			for(AF_OOPS_Actual__c oops:OopsactualList ){
				oops.AF_Brand__c=AFCategoryBrand[0].id;
				oops.AF_Agency_lk__c=acc[0].id;
				oops.AF_Fiscal_year__c=currYear;
				OopsactualList1.add(oops);
			}
			insert OopsactualList1;
			List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
			System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
			ApexPages.currentPage().getParameters().put('bId',AFCategoryBrand[0].id);         
			//For Agency Id
			ApexPages.currentPage().getParameters().put('aId',acc[0].Id);
			//For Fiscal year
			ApexPages.currentPage().getParameters().put('fy',currYear);   
			//Instantiate AF_OOPS_SelectionController  Class
			AF_OOPS_SelectionController selCtrl=new AF_OOPS_SelectionController();
			Test.stopTest();
		}
	}
}