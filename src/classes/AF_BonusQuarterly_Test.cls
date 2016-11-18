/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BonusQuarterly_Test
@CreateDate : 19/9/2014
@Description : This is a Test class for AF_BonusQuarterly class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_BonusQuarterly_Test
{ 
    public static string ANNAUL_BONNUS='The AnnualBonusQual Record inserted';
    public static string QUARTERLY_BONUS=' QuarterlyBonus is inserted';
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user userforBonusQuarterly;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : bonusQuarterly
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void bonusQuarterly()
    {
        Test.startTest();
        userforBonusQuarterly = AF_TestFactory_Helper.createuser(true);
        User u=[SELECT id FROM user WHERE id=:userforBonusQuarterly.id LIMIT 1];
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
            //Insert AnnualBonusQual
            List<AF_AnnualBonus_Qual__c> Anuualbonusqual = AF_TestFactory_Helper.insertAnnualBonusQual(1,true);
            List<AF_AnnualBonus_Qual__c> Anuualbonusqual1 = AF_TestFactory_Helper.insertAnnualBonus(1,true);
            System.assertEquals(Anuualbonusqual!=null,Anuualbonusqual1!=null,ANNAUL_BONNUS);
            List<AF_AnnualBonus_Qual__c> AnuualbonusqualQuery = [SELECT Id FROM AF_AnnualBonus_Qual__c LIMIT 1];
            System.assert(AnuualbonusqualQuery[0].Id!=null ,ANNAUL_BONNUS);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist=new  List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brand:BrandEst){
                Brand.Brand__c=cb[0].id;
                Brand.AF_Agency__c=acc[0].id;
                Brand.AF_Fiscal_Year__c=currYear;
                Brand.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;
                Brand.AF_Pilot_Model__c=false;
                Brand.AF_Active__c=true;
                BrandEstlist.add(Brand);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, cb[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //insert Quarterly Bonus.
            List<AF_QuarterlyBonus__c> QuarterlyBonus = AF_TestFactory_Helper.insertQuarterlyBonus(1,false);
            List<AF_QuarterlyBonus__c> QuarterlyBonuslist= new List<AF_QuarterlyBonus__c>();
            for(AF_QuarterlyBonus__c QB : QuarterlyBonus){
                QB.Minimum__c = 5;
                QB.Outstanding__c = 15;
                QB.Stretching__c = 10;
                QuarterlyBonuslist.add(QB);
            }
            insert QuarterlyBonuslist;
            List<AF_QuarterlyBonus__c> QuarterlyBonusQuery = [SELECT Id FROM AF_QuarterlyBonus__c LIMIT 1];
            System.assert(QuarterlyBonusQuery[0].Id!= null,QUARTERLY_BONUS);
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
            List<AF_Entity__c> AFEntity3 = AF_TestFactory_Helper.insertEntity3(1,true);
            System.assertEquals(AFEntity[0].id!=null,AFEntity3[0].id!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
            System.AssertEquals(AFEntity4!=null,AFUnileverEntity!=null,AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate1 = AF_TestFactory_Helper.insertAgencyEstimate1(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist1=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate1){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist1.add(agency);
            }
            insert AgencyEsitmatelist1;
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
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //insert bonus thershold
            List<AF_Bonus_Threshold__c> BonusThreshold1 =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdlist1=new List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c Bonus:BonusThreshold1){
                Bonus.AF_Digital__c=true;
                Bonus.Year__c=currYear;
                Bonus.AF_country__c=AFUnileverEntityQuery[0].id;
                BonusThresholdlist1.add(Bonus);
            }
            insert BonusThresholdlist1;
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdlist=new List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c Bonus:BonusThreshold){
                Bonus.Agency_Name__c=acc[0].id;
                Bonus.AF_Traditional__c=true;
                Bonus.Brand_Name__c=cb[0].id;
                Bonus.Year__c=currYear;
                Bonus.AF_country__c=AFUnileverEntityQuery[0].id;
                BonusThresholdlist.add(Bonus);
            }
            insert BonusThresholdlist;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThresholdlist LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            List<AF_Sub_Result__c> subResult = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subResultlist =new List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResult){
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = true;
                sr.AF_Bonus_Threshold__c=BonusThreshold[0].id;
                sr.AF_Quant_Bonus_Value__c=12;
                sr.AF_Bonusable_Fees__c=12;
                sr.AF_Period__c = AF_Constants.QUARTER1;
                sr.AF_Quant__c = 55;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                subResultlist.add(sr);
            }
            insert subResultlist;
            List<AF_Sub_Result__c> subResult1 = AF_TestFactory_Helper.insertSubResult1(1,false);
            List<AF_Sub_Result__c> subResultlist1 =new List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr1 : subResult1){
                sr1.AF_Digital__c = true;
                sr1.AF_Traditional__c = true;
                sr1.AF_Bonus_Threshold__c=BonusThreshold[0].id;
                sr1.AF_Period__c =AF_Constants.QUARTER1;
                sr1.AF_Quant__c = 12;
                sr1.AF_Minimum__c = 5;
                sr1.AF_Outstanding__c = 7;
                sr1.AF_Stretching__c = 6;
                sr1.Bonus_Measure__c = 'BM1';
                subResultlist1.add(sr1);
            }
            insert subResultlist1;
            List<AF_Sub_Result__c> subResultQuery = [SELECT Id,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResult LIMIT 1];
            System.assertEquals(subResultQuery[0].AF_Bonus_Threshold__c ,BonusThreshold[0].Id,AF_TestFactory_Helper.SUBRESULT_RECORD);
            //insert BonusResult.
            List<AF_Bonus_Results__c> BonusResult = AF_TestFactory_Helper.insertBonusResults(1,true);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c  FROM AF_Bonus_Results__c WHERE ID IN :BonusResult LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c ,BonusThreshold[0].Id ,AF_TestFactory_Helper.BONUSRESULT_RECORD);
            ApexPages.currentPage().getParameters().put('Brandid',cb[0].id);
            ApexPages.currentPage().getParameters().put('Agencyid',acc[0].id);
            ApexPages.currentPage().getParameters().put('Year',currYear);
            AF_BonusQuarterly bonQuart=new AF_BonusQuarterly();
            bonQuart.CallBonusQuarterly();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : bonusQuarterly1
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_bonusQuarterly1()
    {
        Test.startTest();
        userforBonusQuarterly = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBonusQuarterly.id LIMIT 1];
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
            //Insert AnnualBonusQual
            List<AF_AnnualBonus_Qual__c> Anuualbonusqual = AF_TestFactory_Helper.insertAnnualBonusQual(1,true);
            List<AF_AnnualBonus_Qual__c> Anuualbonusqual1 = AF_TestFactory_Helper.insertAnnualBonus(1,true);
            System.assertEquals(Anuualbonusqual!=null,Anuualbonusqual1!=null,ANNAUL_BONNUS);
            List<AF_AnnualBonus_Qual__c> AnuualbonusqualQuery = [SELECT Id FROM AF_AnnualBonus_Qual__c LIMIT 1];
            System.assert(AnuualbonusqualQuery[0].Id!=null ,ANNAUL_BONNUS);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist=new  List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brand:BrandEst){
                Brand.Brand__c=AFCategoryBrand[0].id;
                Brand.AF_Agency__c=acc[0].id;
                Brand.AF_Fiscal_Year__c=currYear;
                Brand.AF_Active__c=true;
                Brand.AF_Pilot_Model__c=true;
                BrandEstlist.add(Brand);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, AFCategoryBrand[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //insert Quarterly Bonus.
            List<AF_QuarterlyBonus__c> QuarterlyBonus = AF_TestFactory_Helper.insertQuarterlyBonus(1,false);
            List<AF_QuarterlyBonus__c> QuarterlyBonuslist = new List<AF_QuarterlyBonus__c>();
            for(AF_QuarterlyBonus__c QB : QuarterlyBonus){
                QB.Minimum__c = 5;
                QB.Outstanding__c = 15;
                QB.Stretching__c = 10;
                QuarterlyBonuslist.add(QB);
            }
            insert QuarterlyBonuslist;
            List<AF_QuarterlyBonus__c> QuarterlyBonusQuery = [SELECT Id FROM AF_QuarterlyBonus__c LIMIT 1];
            System.assert(QuarterlyBonusQuery[0].Id!= null,QUARTERLY_BONUS);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,false);
            List<AF_Entity__c> AFEntitylist=new List<AF_Entity__c>();
            for(AF_Entity__c entity:AFEntity){
                entity.AF_Agency__c=acc[0].id;
                AFEntitylist.add(entity);
            }
            insert AFEntitylist;
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,false);
            List<AF_Entity__c> AFUnileverEntitylist=new List<AF_Entity__c>();
            for(AF_Entity__c entity:AFUnileverEntity){
                entity.AF_Country__c=AF_Constants.TEST_CURRENCY_COUNTRY;
                AFUnileverEntitylist.add(entity);
            }
            insert AFUnileverEntitylist;
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
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
            List<AF_Sub_Result__c> subResult = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subResultlist = new List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResult){
                sr.AF_Digital__c = false;
                sr.AF_Traditional__c = false;
                sr.AF_Locked__c=true;
                sr.AF_Bonusable_Fees__c=12;
                sr.AF_Period__c = AF_Constants.QUARTER1;
                sr.AF_Quant__c = 12;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                subResultlist.add(sr);
            }
            insert subResultlist;
            List<AF_Sub_Result__c> subResult1 = AF_TestFactory_Helper.insertSubResult1(1,false);
            List<AF_Sub_Result__c> subResultlist1 = new List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr1 : subResult1){
                sr1.AF_Digital__c = true;
                sr1.AF_Traditional__c = false;
                sr1.AF_Quant__c = 12;
                sr1.AF_Quant_Bonus__c=23;
                sr1.AF_Minimum__c = 5;
                sr1.AF_Outstanding__c = 7;
                sr1.AF_Stretching__c = 6;
                sr1.Bonus_Measure__c = 'BM1';
                subResultlist1.add(sr1);
            }
            insert subResultlist1;
            List<AF_Sub_Result__c> subResultQuery = [SELECT Id,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResult LIMIT 1];
            System.assertEquals(subResultQuery[0].AF_Bonus_Threshold__c ,BonusThreshold[0].Id,AF_TestFactory_Helper.SUBRESULT_RECORD);
            List<AF_Bonus_Results__c> BonusResult = AF_TestFactory_Helper.insertBonusResults(1,true);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c  FROM AF_Bonus_Results__c WHERE ID IN :BonusResult LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c ,BonusThreshold[0].Id ,AF_TestFactory_Helper.BONUSRESULT_RECORD);
            ApexPages.currentPage().getParameters().put('Brandid',AFCategoryBrand[0].id);
            ApexPages.currentPage().getParameters().put('Agencyid',acc[0].id);
            ApexPages.currentPage().getParameters().put('Year',currYear);
            AF_BonusQuarterly bonQuart1=new AF_BonusQuarterly();
            bonQuart1.CallBonusQuarterly();
            bonQuart1.ConfirmBonus();
            bonQuart1.UpdateBonus();
            bonQuart1.Calculate_Bonus();
        }
    }
        /***********************************************************************************
*  @Description: this method will the test data
*  @name : bonusQuarterly2
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_bonusQuarterly2()
    {
        Test.startTest();
        userforBonusQuarterly = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBonusQuarterly.id LIMIT 1];
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
            //Insert AnnualBonusQual
            List<AF_AnnualBonus_Qual__c> Anuualbonusqual = AF_TestFactory_Helper.insertAnnualBonusQual(1,true);
            List<AF_AnnualBonus_Qual__c> Anuualbonusqual1 = AF_TestFactory_Helper.insertAnnualBonus(1,true);
            System.assertEquals(Anuualbonusqual!=null,Anuualbonusqual1!=null,ANNAUL_BONNUS);
            List<AF_AnnualBonus_Qual__c> AnuualbonusqualQuery = [SELECT Id FROM AF_AnnualBonus_Qual__c LIMIT 1];
            System.assert(AnuualbonusqualQuery[0].Id!=null ,ANNAUL_BONNUS);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist=new  List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brand:BrandEst){
                Brand.Brand__c=AFCategoryBrand[0].id;
                Brand.AF_Agency__c=acc[0].id;
                Brand.AF_Fiscal_Year__c=currYear;
                Brand.AF_Active__c=true;
                Brand.AF_Pilot_Model__c=true;
                BrandEstlist.add(Brand);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, AFCategoryBrand[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //insert Quarterly Bonus.
            List<AF_QuarterlyBonus__c> QuarterlyBonus = AF_TestFactory_Helper.insertQuarterlyBonus(1,false);
            List<AF_QuarterlyBonus__c> QuarterlyBonuslist = new List<AF_QuarterlyBonus__c>();
            for(AF_QuarterlyBonus__c QB : QuarterlyBonus){
                QB.Minimum__c = 5;
                QB.Outstanding__c = 15;
                QB.Stretching__c = 10;
                QuarterlyBonuslist.add(QB);
            }
            insert QuarterlyBonuslist;
            List<AF_QuarterlyBonus__c> QuarterlyBonusQuery = [SELECT Id FROM AF_QuarterlyBonus__c LIMIT 1];
            System.assert(QuarterlyBonusQuery[0].Id!= null,QUARTERLY_BONUS);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,false);
            List<AF_Entity__c> AFEntitylist=new List<AF_Entity__c>();
            for(AF_Entity__c entity:AFEntity){
                entity.AF_Agency__c=acc[0].id;
                AFEntitylist.add(entity);
            }
            insert AFEntitylist;
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,false);
            List<AF_Entity__c> AFUnileverEntitylist=new List<AF_Entity__c>();
            for(AF_Entity__c entity:AFUnileverEntity){
                entity.AF_Country__c=AF_Constants.TEST_CURRENCY_COUNTRY;
                AFUnileverEntitylist.add(entity);
            }
            insert AFUnileverEntitylist;
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
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
            List<AF_Sub_Result__c> subResult = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subResultlist = new List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResult){
                sr.AF_Digital__c = false;
                sr.AF_Traditional__c = false;
                sr.AF_Locked__c=true;
                sr.AF_Bonusable_Fees__c=12;
                sr.AF_Bonus_Threshold__c=BonusThreshold[0].id;
                sr.AF_Period__c = AF_Constants.QUARTER1;
                //sr.AF_Quant__c = 12;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                subResultlist.add(sr);
            }
            insert subResultlist;
            List<AF_Sub_Result__c> subResult1 = AF_TestFactory_Helper.insertSubResult1(1,false);
            List<AF_Sub_Result__c> subResultlist1 = new List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr1 : subResult1){
                sr1.AF_Digital__c = true;
                sr1.AF_Traditional__c = false;
                //sr1.AF_Quant__c = 12;
                sr1.AF_Bonus_Threshold__c=BonusThreshold[0].id;
                sr1.AF_Period__c=AF_Constants.QUARTER2;
                sr1.AF_Quant_Bonus__c=23;
                sr1.AF_Minimum__c = 5;
                sr1.AF_Outstanding__c = 7;
                sr1.AF_Stretching__c = 6;
                sr1.Bonus_Measure__c = 'BM1';
                subResultlist1.add(sr1);
            }
            insert subResultlist1;
            List<AF_Sub_Result__c> subResultQuery = [SELECT Id,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResult LIMIT 1];
            System.assertEquals(subResultQuery[0].AF_Bonus_Threshold__c ,BonusThreshold[0].Id,AF_TestFactory_Helper.SUBRESULT_RECORD);
            List<AF_Bonus_Results__c> BonusResult = AF_TestFactory_Helper.insertBonusResults(1,true);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c  FROM AF_Bonus_Results__c WHERE ID IN :BonusResult LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c ,BonusThreshold[0].Id ,AF_TestFactory_Helper.BONUSRESULT_RECORD);
            ApexPages.currentPage().getParameters().put('Brandid',AFCategoryBrand[0].id);
            ApexPages.currentPage().getParameters().put('Agencyid',acc[0].id);
            ApexPages.currentPage().getParameters().put('Year',currYear);
            AF_BonusQuarterly bonQuart1=new AF_BonusQuarterly();
            bonQuart1.CallBonusQuarterly();
            bonQuart1.ConfirmBonus();
            bonQuart1.UpdateBonus();
            bonQuart1.Calculate_Bonus();
        }
    }
}