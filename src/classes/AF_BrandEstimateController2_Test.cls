/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimateController2_Test
@CreateDate : 16/9/2014
@Description : This is a Test class for AF_BrandEstimateController2 class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_BrandEstimateController2_Test
{ 
	public static string ANNUAL_QUAL='The AnnualBonusQual Record inserted';                            
	Static Integer IcurrYear = System.Today().year();
	Static string currYear=string.valueof(IcurrYear);
	static user userforBrandEstimateController2;
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_brandEstimateController2
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void AF_brandEstimateController2()
	{
		Test.startTest();
		userforBrandEstimateController2=AF_TestFactory_Helper.createuser(true);
		User u=[SELECT id FROM user WHERE id=:userforBrandEstimateController2.id LIMIT 1];
		System.runAs(u)
		{ 
			//Insert Account
			List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
			for(Account ac : acc){
				ac.published__c=true;
			}
			insert acc;
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
			List<AF_Brand_Estimate__c> BrandEstlist = new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_Locked__c=false; 
				br.AF_Traditional__c=23;
				br.AF_Digital__c=23;
				br.AF_Adaptive__c=23;
				br.AF_Status_Base_Fees__c = AF_Constants.BASE_FEES_READYFORPO;
				br.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
				br.AF_Pilot_Model__c=true;
				br.AF_No_Bonus__c=true;
				br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;
				BrandEstlist.add(br);
			}
			insert BrandEstlist;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//Insert Currency
			List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
			List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
			System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
			//Insert Agency Entity
			List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
			List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
			System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
			//Insert Unilever Entity
			List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
			List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
			System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
			//Insert Agency Estimate.
			List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
			List<AF_Agency_Estimate__c> AgencyEsitmatelist = new List<AF_Agency_Estimate__c>();
			for(AF_Agency_Estimate__c agency : AgencyEsitmate){
				agency.AF_Status__c =AF_Constants.BASE_FEES_WITH_AGENCY ;
				agency.AF_Fiscal_Year__c=currYear;
				agency.AF_Adaptation__c=22;
				agency.AF_Digital__c=22;
				agency.AF_Traditional__c=22;
				AgencyEsitmatelist.add(agency);
			}
			insert AgencyEsitmatelist;
			List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
			System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
			//Insert Bonus Threshold
			List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
			List<AF_Bonus_Threshold__c> BonusThresholdlist=new List<AF_Bonus_Threshold__c>();
			for(AF_Bonus_Threshold__c bthrshold : BonusThreshold){
				bthrshold.Year__c=currYear;
				bthrshold.AF_Digital__c=false;
				bthrshold.AF_Traditional__c=false;
				BonusThresholdlist.add(bthrshold);
			}
			insert BonusThresholdlist;
			List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
			System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
			//Instantiate AF_BrandEstimateController  Class
			AF_brandEstimatehandlerHelper.brandEstApprovalProcess();
			AF_Brand_EstimateHandler handler=new AF_Brand_EstimateHandler();
			handler.andFinally();
			ApexPages.currentPage().getParameters().put('id',brandEst[0].id);
			AF_BrandEstimateController2 stdCtrl=new AF_BrandEstimateController2();
			stdCtrl.IsPilotModel=true;
			stdCtrl.showpilot=true;
			stdCtrl.checkpilot();
			stdCtrl.addwrapper();
			stdCtrl.createBonusThreshold();
			stdCtrl.save();
			stdCtrl.SaveBonusThresholds();
			stdCtrl.SaveBonusRemeneration();
			stdCtrl.showPopup();
			stdCtrl.showPopup1();
			stdCtrl.showPopup2();
			stdCtrl.closePopup();
			stdCtrl.closePopup1();
			stdCtrl.Reload();
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : brandEstimateController21
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void AF_brandEstimateController21()
	{
		Test.startTest();
		userforBrandEstimateController2=AF_TestFactory_Helper.createUserAdmin1(true);
		User u=[SELECT id FROM user WHERE id=:userforBrandEstimateController2.id LIMIT 1];
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
			//insert brandestimate
			List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			List<AF_Brand_Estimate__c> BrandEstlist1=new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst1){
				br.AF_Pilot_Model__c=false;
				br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WIHTCMCO;
				BrandEstlist1.add(br);
			}
			insert BrandEstlist1;
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
			List<AF_Brand_Estimate__c> BrandEstlist=new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c br : BrandEst){
				br.AF_Pilot_Model__c=false;
				br.AF_No_Bonus__c=false;
				br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;
				BrandEstlist.add(br);
			}
			insert BrandEstlist;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//Insert Currency
			List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
			List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
			System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
			//Insert Agency Entity
			List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
			List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
			System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
			//Insert Unilever Entity
			List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
			List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
			System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
			//Insert Agency Estimate.
			List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
			List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
			for(AF_Agency_Estimate__c agency : AgencyEsitmate){
				agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY ;
				agency.AF_Fiscal_Year__c=currYear;
				agency.AF_Brand_Estimate__c=BrandEstlist[0].id;
				agency.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
				agency.AF_Adaptation__c=22;
				agency.AF_Digital__c=22;
				agency.AF_Traditional__c=22;
				AgencyEsitmatelist.add(agency);
			}
			insert AgencyEsitmatelist;
			List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
			System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
			//Insert AnnualBonusQual
			List<AF_AnnualBonus_Qual__c> Anuualbonusqual = AF_TestFactory_Helper.insertAnnualBonusQual(1,true);
			List<AF_AnnualBonus_Qual__c> AnuualbonusqualQuery = [SELECT Id FROM AF_AnnualBonus_Qual__c LIMIT 1];
			System.assertEquals(AnuualbonusqualQuery[0].Id!=null ,Anuualbonusqual!=null,ANNUAL_QUAL);
			//Insert Bonus Summary
			List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
			List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
			System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, 'The BonusSummary records are inserted');
			//Insert Bonus Threshold
			List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
			List<AF_Bonus_Threshold__c> BonusThresholdlist =new List<AF_Bonus_Threshold__c>();
			for(AF_Bonus_Threshold__c bthrshold : BonusThreshold){
				bthrshold.Year__c=currYear;
				BonusThresholdlist.add(bthrshold);
			}
			insert BonusThresholdlist;
			List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
			System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
			//Insert Bonus Results 
			List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,true);
			List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c Where RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE  and Id IN:AFBonusRes LIMIT 1];
			System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
			//Insert Bonus Matrix
			List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,false);
			List<AF_Bonus_Matrix__c> AFBonusMatlist=new List<AF_Bonus_Matrix__c>();
			for(AF_Bonus_Matrix__c bm : AFBonusMat){
				bm.AF_Value__c=decimal.valueOf(5500);
				bm.AF_Base_Fee_Country_Total__c =35353;
				bm.AF_BonusableFee__c=86588;
				AFBonusMatlist.add(bm);   
			}
			insert AFBonusMatlist;
			List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
			System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, 'The BonusMatrix records are inserted');
			//insert sub Results.
			List<AF_Sub_Result__c> subResults = AF_TestFactory_Helper.insertSubResult(1,false);
			List<AF_Sub_Result__c> subResultslist=new List<AF_Sub_Result__c>();
			for(AF_Sub_Result__c sr : subResults)
			{
				sr.AF_Digital__c = true;
				sr.AF_Traditional__c = false;
				sr.AF_Quant__c = 12;
				sr.AF_Minimum__c = 1;
				sr.AF_Outstanding__c = 3;
				sr.AF_Stretching__c = 2;
				sr.Bonus_Measure__c ='BM1';
				subResultslist.add(sr);
			}
			insert subResultslist;
			List<AF_Sub_Result__c> subResultsQuery = [SELECT ID,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResults LIMIT 1];
			System.assertEquals(subResultsQuery[0].AF_Bonus_Threshold__c ,BonusThresholdQuery[0].id, 'SubResult is inserted');
			//instantiate the brandestimate helper class
			AF_brandEstimatehandlerHelper.brandEstApprovalProcess();
			AF_Brand_EstimateHandler handler=new AF_Brand_EstimateHandler();
			handler.andFinally();
			//instantiate the class
			ApexPages.currentPage().getParameters().put('id',brandEst[0].id);
			AF_BrandEstimateController2 stdCtrl1=new AF_BrandEstimateController2();
			stdCtrl1.IsPilotModel=true;
			stdCtrl1.showpilot=true;
			stdCtrl1.checkpilot();
			stdCtrl1.addwrapper();
			stdCtrl1.createBonusThreshold();
			stdCtrl1.save();
			stdCtrl1.SaveBonusThresholds();
			stdCtrl1.SaveBonusRemeneration();
			stdCtrl1.showPopup();
			stdCtrl1.showPopup1();
			stdCtrl1.showPopup2();
			stdCtrl1.closePopup();
			stdCtrl1.closePopup1();
			stdCtrl1.Reload();
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_brandEstimateController212
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void AF_brandEstimateController212()
	{
		Test.startTest();
		userforBrandEstimateController2=AF_TestFactory_Helper.createUserAdmin(true);
		User u=[SELECT id FROM user WHERE id=:userforBrandEstimateController2.id LIMIT 1];
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
			//Insert Dummyuser Custom settings
			List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
			System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
			//Insert BrandEstimate
			List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//Insert Currency
			List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
			List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
			System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
			//Insert Agency Entity
			List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
			List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
			System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
			//Insert Unilever Entity
			List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
			List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
			System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
			//Insert Agency Estimate.
			List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
			List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
			for(AF_Agency_Estimate__c agency : AgencyEsitmate){
				agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY ;
				agency.AF_Fiscal_Year__c=currYear;
				agency.AF_Adaptation__c=22;
				agency.AF_Digital__c=22;
				agency.AF_Traditional__c=22;
				AgencyEsitmatelist.add(agency);
			}
			insert AgencyEsitmatelist;
			List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
			System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
			//Insert AnnualBonusQual
			List<AF_AnnualBonus_Qual__c> Anuualbonusqual = AF_TestFactory_Helper.insertAnnualBonusQual(1,true);
			List<AF_AnnualBonus_Qual__c> AnuualbonusqualQuery = [SELECT Id FROM AF_AnnualBonus_Qual__c LIMIT 1];
			System.assertEquals(AnuualbonusqualQuery[0].Id!=null ,Anuualbonusqual!=null,'The AnnualBonusQual Record inserted');
			//Insert Bonus Summary
			List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
			List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
			System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, 'The BonusSummary records are inserted');
			//Insert Bonus Threshold
			List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
			List<AF_Bonus_Threshold__c> BonusThresholdlist=new List<AF_Bonus_Threshold__c>();
			for(AF_Bonus_Threshold__c bonsuthres : BonusThreshold){
				bonsuthres.Year__c=currYear;
				BonusThresholdlist.add(bonsuthres);
			}
			insert BonusThresholdlist;
			List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
			System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
			//Insert Bonus Results 
			List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,true);
			List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c Where RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE  and Id IN:AFBonusRes LIMIT 1];
			System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
			//Insert Bonus Matrix
			List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,true);
			List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
			System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
			//insert subResult.
			List<AF_Sub_Result__c> subResult = AF_TestFactory_Helper.insertSubResult(1,true);
			List<AF_Sub_Result__c> subResultQuery = [SELECT Id,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResult LIMIT 1];
			System.assertEquals(subResultQuery[0].AF_Bonus_Threshold__c ,BonusThreshold[0].Id,AF_TestFactory_Helper.SUBRESULT_RECORD);
			AF_brandEstimatehandlerHelper.brandEstApprovalProcess();
			AF_Brand_EstimateHandler handler=new AF_Brand_EstimateHandler();
			handler.andFinally();
			ApexPages.currentPage().getParameters().put('id',brandEst[0].id);
			AF_BrandEstimateController2 stdCtrl1=new AF_BrandEstimateController2();
			stdCtrl1.IsPilotModel=true;
			stdCtrl1.R_Traditional= true;
			stdCtrl1.SaveBonusRemeneration();
			stdCtrl1.IsPilotModel=true;
			stdCtrl1.checkpilot();
			stdCtrl1.addwrapper();
			stdCtrl1.createBonusThreshold();
			stdCtrl1.save();
			stdCtrl1.showPopup();
			stdCtrl1.showPopup1();
			stdCtrl1.showPopup2();
			stdCtrl1.closePopup();
			stdCtrl1.closePopup1();
			stdCtrl1.Reload();
			stdCtrl1.clearErrorMsg();
			stdCtrl1.showpilot=true;
			stdCtrl1.getPilotmethod();
			stdCtrl1.delCountryId = subResult[0].id;//bonThres.id;
			stdctrL1.bonusCheck();
			stdCtrl1.SaveBonusRemeneration();
			stdCtrl1.R_Digital=false;
			stdCtrl1.delCounrtyRecord();
			stdCtrL1.CalculateTotal();
			stdctrL1.ispilotModel=true;
			stdctrl1.bonusThresholdValidation();
			Test.stopTest();
		}
	}
}