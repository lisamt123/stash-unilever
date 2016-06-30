/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_SubResultHandler_Test
@Created Date : 02/08/2014.
@Description : This Test class for AF_subResult_Helper  apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_subResult_Helper_Test
{
    static user userForsubResultHelper;
    private static string bonusmeasure='BM1';
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : AF_SubResultHandler
*  @param : none
*  @return : none
*************************************************************************/   
    static testMethod void AF_SubResultHelper() 
    {
        Test.startTest();
        userForsubResultHelper=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForsubResultHelper.id LIMIT 1];
        system.runAs(u)
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
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null,AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id,AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //insert sub Results.
            List<AF_Sub_Result__c> subResults = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subResultlist= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResults)
            {
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = false;
                sr.AF_Quant__c = 12;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Total_Bonus_Value__c=12;
                sr.AF_Stretching__c = 2;
                sr.Bonus_Measure__c =bonusmeasure;
                sr.AF_Bonusable_Fees__c = 35;
                sr.AF_Period__c=AF_Constants.QUARTER1;
                sr.AF_Qual_Bonus_Value__c=234;
                sr.AF_Quant_Bonus_Value__c = 156;
                subResultlist.add(sr);
            }
            insert subResultlist;
            update subResultlist;
            List<AF_Sub_Result__c> subResults1 = AF_TestFactory_Helper.insertSubResult1(1,false);
            List<AF_Sub_Result__c> subResultlist1= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr1 : subResults1 )
            {
                sr1.AF_Digital__c = true;
                sr1.AF_Traditional__c = false;
                sr1.AF_Period__c=AF_Constants.QUARTER2;
                sr1.AF_Quant__c = 12;
                sr1.AF_Minimum__c = 5;
                sr1.AF_Qual_Bonus_Value__c=12;
                sr1.AF_Total_Bonus_Value__c=12;
                sr1.AF_Outstanding__c = 7;
                sr1.AF_Quant_Bonus_Value__c=1234;
                sr1.AF_Stretching__c = 6;
                sr1.Bonus_Measure__c = bonusmeasure;
                sr1.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
                sr1.AF_Bonusable_Fees__c = 45;
                subResultlist1.add(sr1);
            }
            insert subResultlist1;
            List<AF_Sub_Result__c> subResults2 = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subResultlist2= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr2 : subResults2)
            {
                sr2.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
                sr2.AF_Total_Bonus_Value__c=1234;
                sr2.AF_Quant__c = 12;
                sr2.AF_Minimum__c = 5;
                sr2.AF_Outstanding__c = 7;
                sr2.AF_Stretching__c = 6;
                sr2.Bonus_Measure__c = bonusmeasure;
                sr2.AF_Quant_Bonus_Value__c = 156;
                sr2.AF_Bonusable_Fees__c = 45;               
                subResultlist2.add(sr2);
            }
            insert subResultlist2;
            List<AF_Sub_Result__c> subResultsQuery = [SELECT ID,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResults LIMIT 1];
            System.assertEquals(subResultsQuery[0].AF_Bonus_Threshold__c ,BonusThresholdQuery[0].id, AF_TestFactory_Helper.SUBRESULT_RECORD);
            delete subResultlist;
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,false);
            List<AF_Bonus_Results__c> BonusResultListNew = new  List<AF_Bonus_Results__c>();
            for(AF_Bonus_Results__c bonRes : BonusResultList){
                bonRes.AF_Bonusable_Fees__c=55;
                bonRes.AF_Total_Bonus_Value__c=10;
                bonRes.AF_Qual_Bonus_Value__c=15;
                bonRes.AF_Quant_Bonus_Value__c=65;
                bonRes.AF_Status__c=AF_Constants.STATUS_DRAFT;
                bonRes.AF_Locked__c=true;
                bonRes.AF_Period__c=AF_Constants.QUARTER2;
                bonRes.AF_Bonus_Thresholds__c=BonusThresholdQuery[0].id;
                BonusResultListNew.add(bonRes);
            }
            insert BonusResultListNew;
            upsert BonusResultListNew;
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            AF_subResult_Helper.subResultCalcExt(subResultlist2);
            Test.stopTest();
        }
    }
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : AF_SubResultHandler1
*  @param : none
*  @return : none
*************************************************************************/   
    static testMethod void AF_SubResultHelper1() 
    {
        Test.startTest();
        userForsubResultHelper=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForsubResultHelper.id LIMIT 1];
        system.runAs(u)
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
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null,AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id,AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //insert 
            List<AF_Sub_Result__c> subResults3 = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subResultlist3= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResults3)
            {
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = false;
                sr.AF_Quant__c = 12;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                sr.Bonus_Measure__c =bonusmeasure;
                sr.AF_Bonusable_Fees__c = 35;
                sr.AF_Total_Bonus_Value__c=234;
                sr.AF_Qual_Bonus_Value__c=23;
                sr.AF_Quant_Bonus_Value__c = 156;
                subResultlist3.add(sr);
            }
            insert subResultlist3;
            update subResultlist3;
            //insert sub Results.
            List<AF_Sub_Result__c> subResults = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subResultlist= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResults)
            {
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = false;
                sr.AF_Quant__c = 12;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                sr.Bonus_Measure__c =bonusmeasure;
                sr.AF_Bonusable_Fees__c = 35;
                sr.AF_Total_Bonus_Value__c=234;
                sr.AF_Qual_Bonus_Value__c=23;
                sr.AF_Quant_Bonus_Value__c = 156;
                sr.AF_Period__c=AF_Constants.QUARTER3;
                subResultlist.add(sr);
            }
            insert subResultlist;
            update subResultlist;
            List<AF_Sub_Result__c> subResults1 = AF_TestFactory_Helper.insertSubResult1(1,false);
            List<AF_Sub_Result__c> subResultlist1= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr1 : subResults1 )
            {
                sr1.AF_Digital__c = true;
                sr1.AF_Traditional__c = false;
                sr1.AF_Quant__c = 12;
                sr1.AF_Minimum__c = 5;
                sr1.AF_Total_Bonus_Value__c=234;
                sr1.AF_Outstanding__c = 7;
                sr1.AF_Stretching__c = 6;
                sr1.AF_Qual_Bonus_Value__c=23;
                sr1.Bonus_Measure__c = bonusmeasure;
                sr1.AF_Period__c=AF_Constants.QUARTER3;
                sr1.AF_Bonusable_Fees__c = 45;
                subResultlist1.add(sr1);
            }
            insert subResultlist1;
            delete subResultlist;
            AF_subResult_Helper.subResultCalcExt(subResultlist1);
            Test.stopTest();
        }
    }
}