/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_EmailToCatFinance
@CreateDate : 22/9/2014
@Description : This is a Test class for AF_EmailToCatFinance class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_EmailToCatFinance_Test
{    
	Static Integer IcurrYear = System.Today().year();
	Static string currYear=string.valueof(IcurrYear);
	static user userforemailtocatfinanace;
	static boolean displaypopup=true;
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : EmailToCat
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void AF_EmailToCat()
	{
		Test.startTest();
		userforemailtocatfinanace=AF_TestFactory_Helper.createUser(true);
		User u=[SELECT id FROM user WHERE id=:userforemailtocatfinanace.id LIMIT 1];
		PermissionSet ps = [SELECT Id,Name FROM PermissionSet where Name='AF_Category_Finance'];
		PermissionSetAssignment pa = new PermissionSetAssignment();
		pa.PermissionSetId = ps.id;
		pa.AssigneeId = u.id;
		insert pa;
		System.runAs(u)
		{ 
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account where id IN:acc LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
			List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
			System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			List<AF_Brand_Estimate__c> BrandEstLst = new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br: BrandEst){           
				br.Name='Test br';
				br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
				br.AF_Fiscal_Year__c=currYear;
				br.AF_Active__c = true;
				br.AF_Locked__c  = false;
				br.AF_Created_By_Batch__c = true;
				br.AF_Notified_To_CatFinance__c  = false;
				br.AF_Cat_Finance_Approver_1__c=u.Id;    
				BrandEstLst.add(br);
			}
			insert BrandEstLst;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstLst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			ApexPages.currentPage().getParameters().put('Year',currYear);
			AF_EmailToCatFinance obj = new AF_EmailToCatFinance();
			obj.confirm();
			obj.closePopup();
			update BrandEst;
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : EmailToCat1
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void EmailToCat1()
	{
		Test.startTest();
		userforemailtocatfinanace=AF_TestFactory_Helper.createUserAdmin(true);
		User u=[SELECT id FROM user WHERE id=:userforemailtocatfinanace.id LIMIT 1];
		System.runAs(u)
		{
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
			List<Account> acctQuery = [SELECT id FROM account where id IN:acc LIMIT 1];
			System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
			List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
			System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
			ApexPages.currentPage().getParameters().put('Year',currYear);
			AF_EmailToCatFinance obj = new AF_EmailToCatFinance();
			obj.confirm();
			obj.closePopup();
			Test.stopTest();
		}
	}
}