/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_BonusMatrixSummary
@CreateDate : 30/9/2014
@Description : This is a Test class for AF_BonusMatrixSummary class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_BonusMatrixSummary_Test
{ 
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user BonusMatrixSummary;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_addCommentCompController
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_addCommentCompController()
    {
        Test.startTest();
        BonusMatrixSummary=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:BonusMatrixSummary.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accLst = new List<Account>();
            for(Account ac: acc){
                ac.published__c=true;
                accLst.add(ac);
            }
            insert accLst;
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
            List<AF_Brand_Estimate__c> BrandEstLSt = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c brst : BrandEst){
                brst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO ;  
                brst.AF_Fiscal_Year__c=currYear;
                brst.AF_Active__c = true;
                brst.AF_Copied__c= false;
                brst.AF_Locked__c = false;  
                brst.AF_AgencyUsers1__c=u.Email;
                BrandEstLSt.add(brst);
            }
            insert BrandEstLSt;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstLSt LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
             List<AF_Agency_Estimate__c> AgencyEsitmateLst = new  List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmateLst.add(agency);
            }
            insert AgencyEsitmateLst;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //Insert Dummyuser Custom setting
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,false);
             List<AF_Bonus_Summary__c> AFBonusSummaryLst = new  List<AF_Bonus_Summary__c>();
             for(AF_Bonus_Summary__c sum : AFBonusSummary){
                sum.AF_Fiscal_Year__c=currYear; 
                sum.AF_Is_Pilot_Model__c=true; 
                sum.AF_Status__c=AF_Constants.BONUS_SUMMARY_READYFORPO ;
                AFBonusSummaryLst.add(sum);
             }
             insert AFBonusSummaryLst;
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummaryLst LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdlist=new List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bonus:BonusThreshold){
            bonus.Agency_Name__c=acc[0].id;
            bonus.Brand_Name__c=AFCategoryBrand[0].id;
            bonus.Year__c=currYear;
            BonusThresholdlist.add(bonus);
            }
            insert BonusThresholdlist;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThresholdlist LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results 
            List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,false);
            List<AF_Bonus_Results__c> AFBonusResLst = new List<AF_Bonus_Results__c>();
            for(AF_Bonus_Results__c bres : AFBonusRes){
                 bres.AF_Total_Bonus_Value__c=23;
                 bres.AF_Bonus_Thresholds__c=BonusThresholdlist[0].id;
                 bres.AF_Total_Remuneration__c=547;
                 bres.AF_Bonusable_Fees__c = 2000;
                 bres.AF_Qual_Bonus_Value__c = 200;
                 bres.AF_Quant_Bonus_Value__c = 300;
                 AFBonusResLst.add(bres);
            }
            insert AFBonusResLst;
            List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c where Id IN:AFBonusResLst LIMIT 1];
            System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            //Insert Bonus Matrix
            List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,false);
            List<AF_Bonus_Matrix__c> AFBonusMatLst = new List<AF_Bonus_Matrix__c>();
            for(AF_Bonus_Matrix__c bm : AFBonusMat){
                bm.AF_Value__c=23;
                bm.AF_Base_Fee_Country_Total__c =35353;
                bm.AF_BonusableFee__c=86588;  
                AFBonusMatLst.add(bm);
            }
            insert AFBonusMatLst;
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMatLst LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            ApexPages.currentPage().getParameters().put('Id',AFBonusSummary[0].id);
            ApexPages.StandardController sc1 = new ApexPages.StandardController(AFBonusSummary[0]);
            AF_BonusMatrixSummary obj = new AF_BonusMatrixSummary(sc1);
            obj.remainingAllowances =0;
            obj.SubmitforStatus();
            Test.stopTest();
        }
    }
     /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_addCommentCompController1
*  @param : none.
*  @return: none.
*************************************************************************************/
      Static testMethod void AF_addCommentCompController1()
    {
        Test.startTest();
        BonusMatrixSummary=AF_TestFactory_Helper.createUserAdmin3(true);
        User u=[SELECT id,Email FROM user WHERE id=:BonusMatrixSummary.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accLst = new List<Account>();
            for(Account ac: acc){
                ac.published__c=true;
                accLst.add(ac);
            }
            insert accLst;
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
            List<AF_Brand_Estimate__c> BrandEstLSt = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c brst : BrandEst){
                brst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO ;  
                brst.AF_Fiscal_Year__c=currYear;
                brst.AF_Active__c = true;
                brst.AF_Copied__c= false;
                brst.AF_Locked__c = false;  
                brst.AF_AgencyUsers1__c=u.Email;
                BrandEstLSt.add(brst);
            }
            insert BrandEstLSt;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstLSt LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
             List<AF_Agency_Estimate__c> AgencyEsitmateLst = new  List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmateLst.add(agency);
            }
            insert AgencyEsitmateLst;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,false);
             List<AF_Bonus_Summary__c> AFBonusSummaryLst = new  List<AF_Bonus_Summary__c>();
             for(AF_Bonus_Summary__c sum : AFBonusSummary){
                sum.AF_Fiscal_Year__c=currYear; 
                sum.AF_Is_Pilot_Model__c=false; 
                sum.AF_Status__c=AF_Constants.BONUS_SUMMARY_READYFORPO ;
                AFBonusSummaryLst.add(sum);
             }
             insert AFBonusSummaryLst;
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummaryLst LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdlist=new List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bonus:BonusThreshold){
            bonus.Agency_Name__c=acc[0].id;
            bonus.Brand_Name__c=AFCategoryBrand[0].id;
            bonus.Year__c=currYear;
            BonusThresholdlist.add(bonus);
            }
            insert BonusThresholdlist;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThresholdlist LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results 
            List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,false);
            List<AF_Bonus_Results__c> AFBonusResLst = new List<AF_Bonus_Results__c>();
            for(AF_Bonus_Results__c bres : AFBonusRes){
                 bres.AF_Total_Bonus_Value__c=23;
                 bres.AF_Bonus_Thresholds__c=BonusThresholdlist[0].id;
                 bres.AF_Total_Remuneration__c=547;
                 bres.AF_Bonusable_Fees__c = 2000;
                 bres.AF_Qual_Bonus_Value__c = 200;
                 bres.AF_Quant_Bonus_Value__c = 300;
                 AFBonusResLst.add(bres);
            }
            insert AFBonusResLst;
            List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c where Id IN:AFBonusResLst LIMIT 1];
            System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            //Insert Bonus Matrix
            List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,false);
            List<AF_Bonus_Matrix__c> AFBonusMatLst = new List<AF_Bonus_Matrix__c>();
            for(AF_Bonus_Matrix__c bm : AFBonusMat){
                bm.AF_Value__c=23;
                bm.AF_Base_Fee_Country_Total__c =35353;
                bm.AF_BonusableFee__c=86588;  
                AFBonusMatLst.add(bm);
            }
            insert AFBonusMatLst;
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMatLst LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            ApexPages.currentPage().getParameters().put('Id',AFBonusSummary[0].id);
            ApexPages.StandardController sc1 = new ApexPages.StandardController(AFBonusSummary[0]);
            AF_BonusMatrixSummary obj = new AF_BonusMatrixSummary(sc1);
            obj.remainingAllowances =0;
            obj.SubmitforStatus();
            Test.stopTest();
        }
    }
}