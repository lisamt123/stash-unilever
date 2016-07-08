@isTest(seeAllData=false)
public class AF_CurrencyHandler_Test
{
	Private Static Integer IcurrYear = System.Today().year();
	Private Static string currYear=string.valueof(IcurrYear); 
	Private static user userForCurrencyHandler;
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : raisenewPO_Homepage_lightbox
*  @param : none
*  @return : none
*************************************************************************/ 
	Static testMethod void AF_CurrencyHandler ()
	{
		Test.startTest();
		userForCurrencyHandler = AF_TestFactory_Helper.createUserAdmin(true);
		User u=[SELECT id,Email FROM user WHERE id=:userForCurrencyHandler.id LIMIT 1];
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
			//insert BrandEstimate.
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			List<AF_Brand_Estimate__c> BrandEstlist=new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c  loopBrandEst : BrandEst)
			{
				loopbrandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;  
				loopbrandEst.AF_Fiscal_Year__c=currYear;
				loopbrandEst.AF_Active__c = true;
				loopbrandEst.AF_Copied__c= false;
				loopbrandEst.AF_Locked__c = false; 
				loopbrandEst.AF_Controller_Flag__c=false;
				loopbrandEst.AF_AgencyUsers1__c=u.Email;
				loopbrandEst.AF_Traditional__c=23;
				loopbrandEst.AF_Digital__c=24;
				loopbrandEst.AF_Adaptive__c=44;
				loopbrandEst.AF_BackupQuarter__c = 'Q1;Q2;Q3';
				BrandEstlist.add(loopbrandEst);
			}
			insert BrandEstlist;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c LIMIT 2]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//Insert Agency Entity
			List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
			List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and id IN:AFEntity LIMIT 1];
			System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
			// insert currency.
			List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
			List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c LIMIT 1];
			System.AssertEquals(AFCurrencyQuery[0].Id != null,AFCurrency!=null, AF_TestFactory_Helper.CURRENCY_RECORD);
		}
	}
}