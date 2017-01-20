/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BonusRecordManager_Test
@CreateDate : 13/9/2014
@Description : This is a Test class for AF_BonusRecordManager class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_BonusRecordManager_Test  
{
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear); 
    static string BrandEstimate_Name='Test BrandEstimatebm1';
    static user userforBonusRecordManager;
    static Set<Id> brandEstSet=new Set<Id>();
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : bonusRecordManager
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void bonusRecordManager ()
    {
        Test.startTest();
        userforBonusRecordManager=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBonusRecordManager.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstlist =new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brest : BrandEst){
                Brest.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
                Brest.AF_Pilot_Model__c=true;
                BrandEstlist.add(Brest);
            }
            insert BrandEstlist;
            brandEstSet.add(brandEst[0].Id);
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList1(1,true);
            brandEstSet.add(brandEst1[0].Id);
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
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=AF_Constants.TEST_FISCALYEAR;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            List<AF_Sub_Result__c> subResult = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subResultlist= new List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResult){
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = false;
                sr.AF_Period__c = AF_Constants.QUARTER1;
                sr.AF_Quant__c = 12;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                subResultlist.add(sr);
            }
            insert subResultlist;
            List<AF_Sub_Result__c> subResultQuery = [SELECT Id,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResult LIMIT 1];
            System.assertEquals(subResultQuery[0].AF_Bonus_Threshold__c ,BonusThreshold[0].Id,' SubResult Record inserted');
            //Insert Bonus Results 
            List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,true);
            List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c where Id IN:AFBonusRes LIMIT 1];
            System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            //Insert Bonus Matrix
            List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,true);
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            AF_BonusRecordManager bonMane=new AF_BonusRecordManager();
            AF_BonusRecordManager bonManeg=new AF_BonusRecordManager(brandEst1[0]);
            AF_BonusRecordManager bonMan=new AF_BonusRecordManager(brandEstSet);
            bonMan.CreateMultiObjectRecords();
            bonMan.BonusSummarySingleFactory(brandEst[0]);
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_bonusRecordManager1
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_bonusRecordManager1 ()
    {
        Test.startTest();
        userforBonusRecordManager=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBonusRecordManager.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstlist = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brest : BrandEst){
                Brest.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
                Brest.AF_Pilot_Model__c=true;
                BrandEstlist.add(Brest);
            }
            insert BrandEstlist;
            brandEstSet.add(brandEst[0].Id);
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList1(1,true);
            brandEstSet.add(brandEst1[0].Id);
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
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=AF_Constants.TEST_FISCALYEAR;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
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
            List<AF_Bonus_Matrix__c> AFBonusMatlist = new List<AF_Bonus_Matrix__c>();
            for(AF_Bonus_Matrix__c Bm : AFBonusMat){
                Bm.AF_BonusableFee__c=34;
                AFBonusMatlist.add(Bm);
            }
            insert AFBonusMatlist;
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            AF_BonusRecordManager bonMan1=new AF_BonusRecordManager(brandEstSet);
            bonMan1.CreateMultiObjectRecords();
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_bonusRecordManager2
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_bonusRecordManager2 ()
    {
        Test.startTest();
        userforBonusRecordManager=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBonusRecordManager.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstlist = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brest : BrandEst){
                Brest.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
                Brest.AF_Pilot_Model__c=true;
                BrandEstlist.add(Brest);
            }
            insert BrandEstlist;
            brandEstSet.add(brandEst[0].Id);
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList1(1,true);
            brandEstSet.add(brandEst1[0].Id);
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
            List<AF_Agency_Estimate__c> AgencyEsitmatelist =new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=AF_Constants.TEST_FISCALYEAR;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
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
            List<AF_Bonus_Matrix__c> AFBonusMatlist =new List<AF_Bonus_Matrix__c>();
            for(AF_Bonus_Matrix__c Bm : AFBonusMat){
                Bm.AF_BonusableFee__c=34;
                Bm.AF_Fiscal_Year__c=AgencyEsitmate[0].AF_Fiscal_Year__c;
                Bm.AF_Agency_Entity__c=AgencyEsitmate[0].AF_Agency_Entity__c;
                Bm.AF_Unilever_Entity__c=AgencyEsitmate[0].AF_Unilever_Entity__c;
                AFBonusMatlist.add(Bm);
            }
            insert AFBonusMatlist;
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            //Instantiating the class AF_BonusRecordManager 
            AF_BonusRecordManager bonMan1=new AF_BonusRecordManager(brandEstSet);
            bonMan1.CreateMultiObjectRecords();
            Test.stopTest();
        }
    }
      /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_bonusRecordManager3
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_bonusRecordManager3()
    {
        Test.startTest();
        userforBonusRecordManager=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBonusRecordManager.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstlist = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brest : BrandEst){
                Brest.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
                Brest.AF_Status_Base_Fees__c=AF_Constants.CATEGORY_FINANCE;
                //Brest.AF_Pilot_Model__c=true;
                BrandEstlist.add(Brest);
            }
            insert BrandEstlist;
            brandEstSet.add(brandEst[0].Id);
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList1(1,true);
            brandEstSet.add(brandEst1[0].Id);
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
            List<AF_Agency_Estimate__c> AgencyEsitmatelist =new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=AF_Constants.TEST_FISCALYEAR;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Instantiating the class AF_BonusRecordManager 
            AF_BonusRecordManager bonMan1=new AF_BonusRecordManager(brandEstSet);
            bonMan1.CreateMultiObjectRecords();
            //bonMan1.ExceptionalTarget=true;
            Test.stopTest();
        }
    }
      /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_bonusRecordManager4
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_bonusRecordManager4()
    {
        Test.startTest();
        userforBonusRecordManager=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBonusRecordManager.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstlist = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brest : BrandEst){
                Brest.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
                Brest.AF_Status_Base_Fees__c=AF_Constants.CATEGORY_FINANCE;
                Brest.AF_Pilot_Model__c=false;
                Brest.AF_No_Bonus__c=false;
                Brest.AF_Disable_Globalcheckbox__c=true;
                BrandEstlist.add(Brest);
            }
            insert BrandEstlist;
            brandEstSet.add(brandEst[0].Id);
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList1(1,true);
            brandEstSet.add(brandEst1[0].Id);
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
            List<AF_Agency_Estimate__c> AgencyEsitmatelist =new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=AF_Constants.TEST_FISCALYEAR;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            AF_Brand_Estimate__c  check1 =new AF_Brand_Estimate__c();
            check1.Name=AF_Constants.TEST_BRAND;
            check1.Brand__c=brandQuery[0].id;
            check1.AF_Pilot_Model__c=false;
            check1.AF_No_Bonus__c=false;
            check1.AF_Status_Base_Fees__c=AF_Constants.CATEGORY_FINANCE;
            check1.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
            AF_Brand_Estimate__c  check =new AF_Brand_Estimate__c();
            AF_Bonus_Results__c  result =new AF_Bonus_Results__c ();
            AF_Bonus_Threshold__c  ther=new AF_Bonus_Threshold__c ();
            AF_Agency_Estimate__c agency =new AF_Agency_Estimate__c();
            AF_Bonus_Summary__c Bonus =new AF_Bonus_Summary__c();
            list<AF_Bonus_Matrix__c> bonuslist=new list<AF_Bonus_Matrix__c>();
            string recordtyep=AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
             List<AF_Bonus_Threshold__c> Bonustherlist =new List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c agency1 : BonusThreshold){
                
                agency1.Year__c=AF_Constants.TEST_FISCALYEAR;
                agency1.AF_Digital__c=true;
                agency1.AF_Traditional__c=true;
                agency1.AF_Adaptation__c=true;
                Bonustherlist.add(agency1);
            }
            insert Bonustherlist ;
            List<AF_Sub_Result__c> subResult = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subResultlist= new List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResult){
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = true;
                sr.AF_Adaptation__c=true;
                sr.AF_Period__c = AF_Constants.QUARTER1;
                sr.AF_Quant__c = 12;
                sr.AF_Minimum__c = 1;
                sr.AF_Bonus_Threshold__c=Bonustherlist[0].id;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                subResultlist.add(sr);
            }
            insert subResultlist;
            List<AF_Sub_Result__c> subResultQuery = [SELECT Id,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResult and AF_Bonus_Threshold__r.id IN : Bonustherlist LIMIT 1];
              //Insert Bonus Results 
            List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,false);
            List<AF_Bonus_Results__c> AFBonusResult=new List<AF_Bonus_Results__c>();
            for (AF_Bonus_Results__c Bonus1:AFBonusRes ){
            Bonus1.AF_Total_Remuneration__c=55;
            AFBonusResult.add(Bonus1);
            }
            insert AFBonusResult;
            List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c where Id IN:AFBonusRes LIMIT 1];
            //System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            //Instantiating the class AF_BonusRecordManager 
            AF_BonusRecordManager bonMan1=new AF_BonusRecordManager(brandEstSet);
            bonMan1.CreateMultiObjectRecords();
            bonMan1.MatrixErrorMessage='';
            bonMan1.ExceptionalTarget=true;
            bonMan1.BonusMatrixSingleFactory(agency,Bonus,result,ther,subResultQuery);
            bonMan1.BonusThresholdValidationCheck(check);
            bonMan1.PilotModelBonusMatrixGenerator(check,bonuslist,result,ther);
            bonMan1.BonusResultSingleFactory(ther,check,recordtyep);
            Test.stopTest();
        }
    }
       /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_bonusRecordManager5
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_bonusRecordManager5()
    {
        Test.startTest();
        userforBonusRecordManager=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBonusRecordManager.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstlist = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brest : BrandEst){
                Brest.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
                Brest.AF_Status_Base_Fees__c=AF_Constants.CATEGORY_FINANCE;
                Brest.AF_Pilot_Model__c=false;
                Brest.AF_No_Bonus__c=false;
                BrandEstlist.add(Brest);
            }
            insert BrandEstlist;
            brandEstSet.add(brandEst[0].Id);
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList1(1,true);
            brandEstSet.add(brandEst1[0].Id);
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
            List<AF_Agency_Estimate__c> AgencyEsitmatelist =new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                //agency.AF_Fiscal_Year__c=AF_Constants.TEST_FISCALYEAR;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            AF_Brand_Estimate__c  check1 =new AF_Brand_Estimate__c();
            check1.Name=BrandEstlist[0].Name;
            check1.Brand__c=BrandEstlist[0].Brand__c;
            check1.AF_Pilot_Model__c=BrandEstlist[0].AF_Pilot_Model__c;
            check1.AF_No_Bonus__c=BrandEstlist[0].AF_No_Bonus__c;
            check1.AF_Status_Base_Fees__c=BrandEstlist[0].AF_Status_Base_Fees__c;
            check1.AF_Basefee_Estimate_Initial_Quarter__c=BrandEstlist[0].AF_Basefee_Estimate_Initial_Quarter__c;
            AF_Brand_Estimate__c  check =new AF_Brand_Estimate__c();
            AF_Bonus_Results__c  result =new AF_Bonus_Results__c ();
            result.AF_Total_Remuneration__c=555;
            AF_Bonus_Threshold__c  ther=new AF_Bonus_Threshold__c ();
            AF_Agency_Estimate__c agency =new AF_Agency_Estimate__c();
            AF_Bonus_Summary__c Bonus =new AF_Bonus_Summary__c();
            list<AF_Bonus_Matrix__c> bonuslist=new list<AF_Bonus_Matrix__c>();
            string recordtyep=AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
             List<AF_Bonus_Threshold__c> Bonustherlist =new List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c agency1 : BonusThreshold){
                
                //agency1.Year__c=AF_Constants.TEST_FISCALYEAR;
                agency1.AF_Digital__c=true;
                agency1.AF_Traditional__c=true;
                agency1.AF_Adaptation__c=true;
                Bonustherlist.add(agency1);
            }
            insert Bonustherlist ;
            List<AF_Sub_Result__c> subResult = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subResultlist= new List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResult){
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = true;
                sr.AF_Adaptation__c=true;
                sr.AF_Period__c = AF_Constants.QUARTER1;
                sr.AF_Quant__c = 12;
                sr.AF_Minimum__c = 1;
                sr.AF_Bonus_Threshold__c=Bonustherlist[0].id;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                subResultlist.add(sr);
            }
            insert subResultlist;
            List<AF_Sub_Result__c> subResultQuery = [SELECT Id,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResult and AF_Bonus_Threshold__r.id IN : Bonustherlist LIMIT 1];
              //Insert Bonus Results 
            List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,false);
            List<AF_Bonus_Results__c> AFBonusResult=new List<AF_Bonus_Results__c>();
            for (AF_Bonus_Results__c Bonus1:AFBonusRes ){
            Bonus1.AF_Total_Remuneration__c=55;
            AFBonusResult.add(Bonus1);
            }
            insert AFBonusResult;
            List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c where Id IN:AFBonusRes LIMIT 1];
            //System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
       
            //Instantiating the class AF_BonusRecordManager 
            AF_BonusRecordManager bonMan1=new AF_BonusRecordManager(brandEstSet);
            bonMan1.CreateMultiObjectRecords();
            bonMan1.MatrixErrorMessage='';
            bonMan1.ExceptionalTarget=true;
            bonMan1.BonusMatrixSingleFactory(agency,Bonus,result,ther,subResultQuery);
            bonMan1.BonusThresholdValidationCheck(check);
            bonMan1.PilotModelBonusMatrixGenerator(check,bonuslist,result,ther);
            bonMan1.BonusResultSingleFactory(ther,check,recordtyep);
            Test.stopTest();
        }
    }
}