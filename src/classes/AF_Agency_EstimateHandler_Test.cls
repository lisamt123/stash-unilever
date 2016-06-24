/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Agency_EstimateHandler 
@CreateDate : 10/9/2014
@Description : This is a Test class for AF_Agency_EstimateHandler  class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_Agency_EstimateHandler_Test
{    
	Static Integer IcurrYear = System.Today().year();
	Static string currYear=string.valueof(IcurrYear);
	static user UserForAF_Agency_EstimateHandler ;
	private static string TestBrand='Test brand';
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_Agency_EstimateHandler
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void AF_Agency_EstimateHandler()
	{
		Test.startTest();
		UserForAF_Agency_EstimateHandler=AF_TestFactory_Helper.createUserAdmin(true);
		User u=[SELECT id,Email FROM user WHERE id=:UserForAF_Agency_EstimateHandler.id LIMIT 1];
		System.runAs(u)
		{ 
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
			List<Account> accNew = new List<Account>();
			for(Account loopacc : acc){
				loopacc.published__c = true;
				accNew.add(loopacc);
			}
			insert accNew;
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null,AF_TestFactory_Helper.ACCOUNT_RECORD);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
			List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
			System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
			//Insert Dummyuser Custom settings
			List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
			System.Assert(duuser[0].Id != null,AF_TestFactory_Helper.ACCOUNT_RECORD);
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			list<AF_Brand_Estimate__c> Brandestimatelist= new list<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c  Brand:BrandEst){
				Brand.name=TestBrand;
				Brand.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WITH_AGENCY;
				Brandestimatelist.add(Brand);
			}
			insert Brandestimatelist;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//Insert Currency
			List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
			List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
			System.Assert(AFCurrencyQuery[0].Id != null,AF_TestFactory_Helper.CURRENCY_RECORD );
			//Insert Agency Entity
			List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
			List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
			System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
			//Insert Unilever Entity
			List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
			List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
			System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
			List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
			List<AF_Agency_Estimate__c> AgencyEsitmateNew = new List<AF_Agency_Estimate__c>();
			for(AF_Agency_Estimate__c agency : AgencyEsitmate){
				agency .AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
				agency.AF_Brand_Estimate__c=Brandestimatelist[0].id;
				agency.AF_Adaptation_Local__c=23;
				agency.name=TestBrand;
				agency.AF_Adaptation__c=324;
				agency.AF_Digital__c=12;
				agency.AF_Digital_Local__c=12;
				agency.AF_Agency_Exchange_Rate__c=21;
				agency.AF_Traditional__c=46;
				agency.AF_Traditional_Local__c=23;  
				AgencyEsitmateNew.add(agency);
			}
			insert AgencyEsitmateNew;
			update AgencyEsitmateNew;
			List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
			System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
			delete AgencyEsitmateNew;
			AF_Agency_EstimateHandler agencyhand = new AF_Agency_EstimateHandler();
			AF_Agency_Estimate__c so = new AF_Agency_Estimate__c();     
			AF_Agency_Estimate__c oldso =new AF_Agency_Estimate__c();
			agencyhand.bulkAfter();
			agencyhand.beforeInsert(so);
			agencyhand.beforeUpdate(oldso,so);
			agencyhand.beforeDelete(so);
			agencyhand.afterInsert(so);
			agencyhand.afterUpdate(oldso,so);
			agencyhand.afterDelete(so);
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_Agency_EstimateHandler2
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void AF_Agency_EstimateHandler2()
	{
		Test.startTest();
		UserForAF_Agency_EstimateHandler=AF_TestFactory_Helper.createUserAdmin(true);
		User u=[SELECT id,Email FROM user WHERE id=:UserForAF_Agency_EstimateHandler.id LIMIT 1];
		System.runAs(u)
		{ 
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
			List<Account> accNew = new List<Account>();
			for(Account loopacc : acc){
				loopacc.published__c = true;
				accNew.add(loopacc);
			}
			insert accNew;
			List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
			System.Assert(acctQuery[0].Id != null,AF_TestFactory_Helper.ACCOUNT_RECORD);
			//Insert category
			List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
			List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
			System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
			//Insert Brand
			List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
			List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
			System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
			//Insert Dummyuser Custom settings
			List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
			System.Assert(duuser[0].Id != null,AF_TestFactory_Helper.ACCOUNT_RECORD);
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			list<AF_Brand_Estimate__c> Brandestimatelist= new list<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c  Brand:BrandEst){
				Brand.name=TestBrand;
				Brand.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WITH_AGENCY;
				Brandestimatelist.add(Brand);
			}
			insert Brandestimatelist;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//Insert Currency
			List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
			List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
			System.Assert(AFCurrencyQuery[0].Id != null,AF_TestFactory_Helper.CURRENCY_RECORD );
			//Insert Agency Entity
			List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
			List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
			System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
			//Insert Unilever Entity
			List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
			List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
			System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
			//insert agency estimate
			List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
			List<AF_Agency_Estimate__c> AgencyEsitmateNew = new List<AF_Agency_Estimate__c>();
			for(AF_Agency_Estimate__c agency : AgencyEsitmate){
				agency.AF_Adaptation_Local__c=0;
				agency.name=TestBrand;
				agency.AF_Adaptation__c=0;
				agency.AF_Digital__c=0;
				agency.AF_Digital_Local__c=0;
				agency.AF_Agency_Exchange_Rate__c=0;
				agency.AF_Traditional__c=0;
				agency.AF_Traditional_Local__c=0; 
				AgencyEsitmateNew.add(agency);
			}
				insert AgencyEsitmateNew;
			List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
			System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
			//insert agency estimate
			List<AF_Agency_Estimate__c> AgencyEsitmate1 = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
			List<AF_Agency_Estimate__c> AgencyEsitmateNew1 = new List<AF_Agency_Estimate__c>();
			for(AF_Agency_Estimate__c agency : AgencyEsitmate1){
				agency.AF_Adaptation_Local__c=0;
				agency.name=TestBrand;
				agency.AF_Adaptation__c=0;
				agency.AF_Digital__c=20;
				agency.AF_Digital_Local__c=20;
				agency.AF_Agency_Exchange_Rate__c=0;
				agency.AF_Traditional__c=20;
				agency.AF_Traditional_Local__c=40; 
				AgencyEsitmateNew.add(agency);
			}
			insert AgencyEsitmateNew1;
			List<AF_Agency_Estimate__c> AgencyQuery1 = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate1 limit 1];
			delete AgencyEsitmateNew1;
			//Insert Bonus Threshold
			List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
			List<AF_Bonus_Threshold__c> BonusThresholdlist =new List<AF_Bonus_Threshold__c>();
			for(AF_Bonus_Threshold__c bonus:BonusThreshold){
				bonus.Agency_Name__c=acctQuery[0].id;
				bonus.Brand_Name__c=brandQuery[0].id;
				bonus.Year__c=currYear;
				BonusThresholdlist.add(bonus);
			}
			insert BonusThresholdlist;
			List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThresholdlist  LIMIT 1];
			System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
			// insert sub result
			List<AF_Sub_Result__c> subResult = AF_TestFactory_Helper.insertSubResult(1,false);
			List<AF_Sub_Result__c> subResultlist= new List<AF_Sub_Result__c>();
			for(AF_Sub_Result__c sr : subResult){
				sr.AF_Digital__c = true;
				sr.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
				sr.AF_Locked__c=false;
				sr.AF_Traditional__c = true;
				sr.AF_Period__c =AF_Constants.QUARTER1;
				sr.AF_Quant__c = 12;
				sr.AF_Minimum__c = 1;
				sr.AF_Outstanding__c = 3;
				sr.AF_Stretching__c = 2;
				subResultlist.add(sr);
			}
			insert subResultlist;
			List<AF_Sub_Result__c> subResultQuery = [SELECT Id,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResult LIMIT 1];
			System.assertEquals(subResultQuery[0].AF_Bonus_Threshold__c ,BonusThreshold[0].Id,AF_TestFactory_Helper.SUBRESULT_RECORD);
			AF_Agency_EstimateHandler agencyhand = new AF_Agency_EstimateHandler();
			AF_Agency_Estimate__c so = new AF_Agency_Estimate__c();
			AF_Agency_Estimate__c oldso =new AF_Agency_Estimate__c();
			agencyhand.bulkAfter();
			agencyhand.beforeInsert(so);
			agencyhand.beforeUpdate(oldso,so);
			agencyhand.beforeDelete(so);
			agencyhand.afterInsert(so);
			agencyhand.afterUpdate(oldso,so);
			agencyhand.afterDelete(so);
		}
	}
}