/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BonusMatrixOverrideController_Test
@CreateDate : 29/9/2014
@Description : This is a Test class for AF_BonusMatrixOverrideController class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_BonusMatrixOverrideController_Test
{  
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user userforBonusMatrixOverride;
    private static string CHPARENTID='CHParentId';
    private static string ID='id';
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_bonusMatrixOverrideController
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_bonusMatrixOverrideController()
    {
        Test.startTest();
        userforBonusMatrixOverride=AF_TestFactory_Helper.createuser(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforBonusMatrixOverride.id LIMIT 1];
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
                brst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;  
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
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateLst = new  List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c =AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmateLst.add(agency);
            }
            insert AgencyEsitmateLst;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
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
            List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,false);
            List<AF_Bonus_Matrix__c> AFBonusMatLst = new List<AF_Bonus_Matrix__c>();
            for(AF_Bonus_Matrix__c bm : AFBonusMat){
                bm.AF_Value__c=decimal.valueOf(5500);
                bm.AF_Base_Fee_Country_Total__c =35353;
                bm.AF_BonusableFee__c=86588;  
                AFBonusMatLst.add(bm);
            }
            insert AFBonusMatLst;
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            ApexPages.currentPage().getParameters().put(ID,AFBonusMatLst[0].id);
            AF_BonusMatrixOverrideController bonMatCtrl=new AF_BonusMatrixOverrideController();
            bonMatCtrl.Save();  
            ApexPages.currentPage().getParameters().put(CHPARENTID,AgencyEsitmate[0].id);
            AF_ViewAllController viewCtrl1=new AF_ViewAllController();
            ApexPages.currentPage().getParameters().put(CHPARENTID,OOPSEstimateList[0].id);
            AF_ViewAllController viewCtrl2=new AF_ViewAllController();
            ApexPages.currentPage().getParameters().put(CHPARENTID,AFBonusMat[0].id);
            AF_ViewAllController viewCtrl3=new AF_ViewAllController();
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_bonusMatrixOverrideController1
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_bonusMatrixOverrideController1()
    {
        Test.startTest();
        userforBonusMatrixOverride=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforBonusMatrixOverride.id LIMIT 1];
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
                brst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;  
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
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateLst = new  List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c =AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmateLst.add(agency);
            }
            insert AgencyEsitmateLst;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> AFBonusSummarylist=new List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c bonus:AFBonusSummary ){
                bonus.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
                AFBonusSummarylist.add(bonus);
            }
            insert AFBonusSummarylist;
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
            List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,false);
            List<AF_Bonus_Matrix__c> AFBonusMatLst = new List<AF_Bonus_Matrix__c>();
            for(AF_Bonus_Matrix__c bm : AFBonusMat){
                bm.AF_Base_Fee_Country_Total__c =35353;
                bm.AF_BonusableFee__c=86588;  
                AFBonusMatLst.add(bm);
            }
            insert AFBonusMatLst;
            update AFBonusMatLst;
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            ApexPages.currentPage().getParameters().put(ID,AFBonusMat[0].id);
            AF_BonusMatrixOverrideController bonMatCtrl=new AF_BonusMatrixOverrideController();
            bonMatCtrl.Save();  
            bonMatCtrl.SavePo();
            bonMatCtrl.CalculateLocalC();
            ApexPages.currentPage().getParameters().put(CHPARENTID,AgencyEsitmate[0].id);
            AF_ViewAllController viewCtrl1=new AF_ViewAllController();
            ApexPages.currentPage().getParameters().put(CHPARENTID,OOPSEstimateList[0].id);
            AF_ViewAllController viewCtrl2=new AF_ViewAllController();
            ApexPages.currentPage().getParameters().put(CHPARENTID,AFBonusMat[0].id);
            AF_ViewAllController viewCtrl3=new AF_ViewAllController();
            Test.stopTest();
        }
    }
}