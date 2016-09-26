/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_EditComment_Test
@CreateDate : 10/9/2014
@Description : This is a Test class for AF_EditComment class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_EditComment_Test
{    
	Static Integer IcurrYear = System.Today().year();
	Static string currYear=string.valueof(IcurrYear);
	static user userforEditcomment;
	static Boolean IsEdit ;
	static Boolean IsAdd ;
	static Boolean IsDisplayed;
	static String ReturnPageURL;
	static string ParentId;
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_editComment
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void AF_editComment()
	{
		Test.startTest();
		userforEditcomment=AF_TestFactory_Helper.createUserAdmin(true);
		User u=[SELECT id,Email FROM user WHERE id=:userforEditcomment.id LIMIT 1];
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
			List<AF_Brand_Estimate__c> BrandEstLst =new List<AF_Brand_Estimate__c>();
			for(AF_Brand_Estimate__c brandLst : BrandEst){               
				brandLst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;  
				brandLst.AF_Fiscal_Year__c=currYear;
				brandLst.AF_Active__c = true;
				brandLst.AF_Copied__c= false;
				brandLst.AF_Locked__c = false;  
				brandLst.AF_AgencyUsers1__c=u.Email;
				BrandEstLst.add(brandLst);
			}
			insert BrandEstLst;
			List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstLst LIMIT 1]; 
			System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
			//insert OOPs Actual.
			List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
			List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
			System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
			//Insert Currency
			List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
			List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
			System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
			//Insert Agency Entity
			List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
			List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
			System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
			//Insert Unilever Entity
			List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
			List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
			System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
			List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
			List<AF_Agency_Estimate__c> AgencyEsitmateNew = new List<AF_Agency_Estimate__c>();
			for(AF_Agency_Estimate__c agency : AgencyEsitmate){
				agency.AF_Adaptation_Local__c=23;
				agency.AF_Adaptation__c=324;
				agency.AF_Digital__c=12;
				agency.AF_Digital_Local__c=12;
				agency.AF_Agency_Exchange_Rate__c=21;
				agency.AF_Traditional__c=46;
				agency.AF_Traditional_Local__c=23;  
				AgencyEsitmateNew.add(agency);
			}
			insert AgencyEsitmateNew;
			List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
			System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
			//Insert OOPS Estimate.
			List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
			List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
			System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
			//Insert Bonus Summary
			List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
			List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
			System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
			//Insert Bonus Threshold
			List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
			List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
			System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id,AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
			//Insert Bonus Results 
			List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,true);
			List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c where Id IN:AFBonusRes LIMIT 1];
			System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id,AF_TestFactory_Helper.BONUSRESULT_RECORD);
			//Insert Bonus Matrix
			List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,true);
			List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
			System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id,AF_TestFactory_Helper.BONUSMATRIX_RECORD);
			//insert AF_Comments__c
			List<AF_Comments__c> afcomment =AF_TestFactory_Helper.insertcomments(1,true);
			List<AF_Comments__c> afcomment1 =AF_TestFactory_Helper.insertcomments1(1,true);
			List<AF_Comments__c> afcomment2 =AF_TestFactory_Helper.insertcomments2(1,true);
			List<AF_Comments__c> afcomment3 =AF_TestFactory_Helper.insertcomments3(1,true);
			List<AF_Comments__c> afcommentQuery =[SELECT Id,AF_OOPS_Estimate__c from AF_Comments__c WHERE Id IN :afcomment LIMIT 1];
			System.assertEquals(afcommentQuery[0].AF_OOPS_Estimate__c,OOPSEstimateList[0].id,AF_TestFactory_Helper.COMMENT_RECORD);
			//Instantiating AF_EditComment Class 
			ApexPages.currentPage().getParameters().put('id',afcomment[0].id);
			ApexPages.currentPage().getParameters().put('rp',AgencyEsitmateNew[0].id);
			AF_EditComment editComm=new AF_EditComment();
			editComm.CommentRecord=afcomment[0]; 
			editComm.ParentRecordType='AF_Brand_Estimate__c'; 
			editComm.SaveComment(); 
			editComm.IsEdit=true;
			editComm.IsAdd=true;
			editComm.IsDisplayed=true;
			editComm.ReturnPageURL='test';
			editComm.ParentId='testId';
			ApexPages.currentPage().getParameters().put('id',afcomment1[0].id);
			ApexPages.currentPage().getParameters().put('rp',AgencyEsitmateNew[0].id);
			AF_EditComment editComm1=new AF_EditComment();
			editComm1.CommentRecord=afcomment1[0]; 
			editComm1.ParentRecordType='AF_Agency_Estimate__c'; 
			editComm1.SaveComment();
			editComm1.IsEdit=true;
			editComm1.IsAdd=true;
			editComm1.IsDisplayed=true;
			editComm1.ReturnPageURL='test1';
			editComm1.ParentId='testId1';
			ApexPages.currentPage().getParameters().put('id',afcomment2[0].id);
			ApexPages.currentPage().getParameters().put('rp',AgencyEsitmateNew[0].id);
			AF_EditComment editComm2=new AF_EditComment();
			editComm2.CommentRecord=afcomment2[0]; 
			editComm2.ParentRecordType='AF_Bonus__c'; 
			editComm2.SaveComment();
			editComm2.IsEdit=true;
			editComm2.IsAdd=true;
			editComm2.IsDisplayed=true;
			editComm2.ReturnPageURL='test2';
			editComm2.ParentId='testId2';
			ApexPages.currentPage().getParameters().put('id',afcomment3[0].id);
			ApexPages.currentPage().getParameters().put('rp',AgencyEsitmateNew[0].id);
			AF_EditComment editComm3=new AF_EditComment();
			editComm3.CommentRecord=afcomment3[0]; 
			editComm3.ParentRecordType='AF_OOPS_Estimate__c'; 
			editComm3.SaveComment();
			editComm3.IsEdit=true;
			editComm3.IsAdd=true;
			editComm3.IsDisplayed=true;
			editComm3.ReturnPageURL='test3';
			editComm3.ParentId='testId3';
			Test.stopTest();
		}
	}
}