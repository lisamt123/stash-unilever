/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_CountryBreakdownCheck_Test
@CreateDate : 22/9/2014
@Description : This is a Test class for AF_CountryBreakdownCheck class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_CountryBreakdownCheck_Test
{
	Static Integer IcurrYear = System.Today().year();
	Static string currYear=string.valueof(IcurrYear);
	static user userforcountybreakdown;
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : addCountryController
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void AFaddCountryController()
	{
		Test.startTest();
		userforcountybreakdown=AF_TestFactory_Helper.createUserAdmin(true);
		User u=[SELECT id,Email FROM user WHERE id=:userforcountybreakdown.id LIMIT 1];
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
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			List<AF_Brand_Estimate__c> BrandEstLst = new   List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br:BrandEst){
				br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO; 
				br.AF_Fiscal_Year__c=currYear ;  
				br.AF_Active__c = true; 
				br.AF_Copied__c= false;    
				br.AF_AgencyUsers1__c=u.Email;
				br.AF_Locked__c = false;   
				BrandEstLst.add(br);
			}
			insert BrandEstLst;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstLst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//Insert Currency
			List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
			List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
			System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
			//insert OOPs Actual.
			List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
			List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
			System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
			//Insert Agency Entity
			List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
			List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
			System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
			//Insert Unilever Entity
			List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,false);
			List<AF_Entity__c> AFUnileverEntityList = new List<AF_Entity__c>();
			for(AF_Entity__c ent : AFUnileverEntity){
				ent.IsCentralHub__c = true;
				AFUnileverEntityList.add(ent);
			}
			insert AFUnileverEntityList;
			List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntityList LIMIT 1];
			System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
			//Insert Agency Estimate.
			List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
			List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
			for(AF_Agency_Estimate__c agency : AgencyEsitmate){
				agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
				agency.AF_Fiscal_Year__c=currYear;
				agency.AF_Adaptation__c=22;
				agency.AF_Digital__c=22;
				agency.AF_Traditional__c=22;
				AgencyEsitmatelist.add(agency);
			}
			insert AgencyEsitmatelist;
			List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
			System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
			//insert Entity Exception.
			List<AF_Entity_Exception__c> EntityExceptionLst = AF_TestFactory_Helper.InsertEntityException(1,false);
			List<AF_Entity_Exception__c> EntityExceptionNew = new List<AF_Entity_Exception__c>();
			for(AF_Entity_Exception__c Exp : EntityExceptionLst){
				Exp.AF_Value__c=520;
				EntityExceptionNew.add(Exp);
			}
			insert EntityExceptionNew; 
			List<AF_Entity_Exception__c> EntityExceptionLstQuery = [SELECT Id,AF_Agency_Estimate__c FROM AF_Entity_Exception__c WHERE ID IN : EntityExceptionNew LIMIT 1];
			System.assertEquals(EntityExceptionLstQuery[0].AF_Agency_Estimate__c ,AgencyEsitmate[0].id,AF_TestFactory_Helper.ENTITYEXCEPTION_RECORD);
			//Insert OOPS Estimate.
			List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
			List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
			System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
			//Insert Bonus Summary
			List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
			List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
			System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
			//Insert Bonus Threshold
			List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
			List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
			System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
			//Insert Bonus Results 
			List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,true);
			List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c where Id IN:AFBonusRes LIMIT 1];
			System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
			//Insert Bonus Matrix
			List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,true);
			List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
			System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id,AF_TestFactory_Helper.BONUSMATRIX_RECORD);
			AF_CountryBreakdownCheck obj = new AF_CountryBreakdownCheck();
			Boolean s = obj.CheckCountryBreakdown(brandEst[0].id);
			Test.stopTest();
		}
	}
}