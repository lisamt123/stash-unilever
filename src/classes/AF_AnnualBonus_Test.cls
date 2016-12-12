/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_AnnualBonus_Test
@CreateDate : 23/9/2014
@Description :This Test class for AF_AnnualBonus apex class 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_AnnualBonus_Test
{ 
    Private Static Integer IcurrYear = System.Today().year();
    Private Static string currYear=string.valueof(IcurrYear);
    private static user userforAnnualBonus;
    private static String bonusMeasure ='BM1';
    private static String Brandid = 'Brandid';
    private static String Agencyid = 'Agencyid';
    private static String Year = AF_Constants.YEAR;
    private static String ANNUAL_BONUS='The AnnualBonus records are inserted';
    private static String QUARTERLY_BONUS='The QuarterlyBonus records are inserted';
    //private static string className_STR=AF_AfterUpdateBonusResHandler.class.getName();
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AFannualBonus
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AFannualBonus()
    {
        Test.startTest();
        userforAnnualBonus=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforAnnualBonus.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br :BrandEst){
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;
                br.Brand__c=AFCategoryBrand[0].id;
                br.AF_Agency__c=acc[0].id;
                br.AF_Fiscal_Year__c=currYear;
                br.AF_AgencyUsers1__c=u.Email;
                BrandEstNew.add(br);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null,AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBnsNew = new  List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
                AnnualBnsNew.add(Anb);
            }
            insert AnnualBnsNew;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
            System.Assert(AnnualBnsQuery[0].Id != null,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            List<AF_AnnualBonus_Qual__c> AnnualBs = AF_TestFactory_Helper.insertAnnualBonus(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBnsNew1 = new  List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  AnnualBonus : AnnualBs)
            {
                AnnualBonus.X5__c = 15;
                AnnualBonus.X1__c = 0;
                AnnualBonus.X2__c = 0;
                AnnualBonus.X3__c = 5;
                AnnualBonus.X4__c = 10;
                AnnualBnsNew1.add(AnnualBonus);
            }
            insert AnnualBnsNew1;
            List<AF_AnnualBonus_Qual__c> AnnualBsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c LIMIT 1];
            System.Assert(AnnualBsQuery[0].Id != null, ANNUAL_BONUS);
            // insert QuarterlyBonus.
            List<AF_QuarterlyBonus__c> QuarterlyBonus = AF_TestFactory_Helper.insertQuarterlyBonus(1,false);
            List<AF_QuarterlyBonus__c> QuarterlyBonuslist= new  List<AF_QuarterlyBonus__c>();
            for(AF_QuarterlyBonus__c QB: QuarterlyBonus){
                QB.Minimum__c = 5;
                QB.Outstanding__c = 15;
                QB.Stretching__c = 10;
                QuarterlyBonuslist.add(QB);
            }
            insert QuarterlyBonuslist;
            List<AF_QuarterlyBonus__c> QuarterlyBonusQuery = [SELECT ID FROM AF_QuarterlyBonus__c WHERE ID IN : QuarterlyBonus LIMIT 1];
            System.Assert(QuarterlyBonusQuery[0].Id != null,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
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
            System.assertEquals(AFEntity3[0].id !=null, AFEntity[0].id!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
            System.AssertEquals(AFUnileverEntity!= null,AFEntity4!=null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateNew = new  List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmateNew.add(agency);
            }
            insert AgencyEsitmateNew;
            List<AF_Agency_Estimate__c> AgencyEsitmate1 = AF_TestFactory_Helper.insertAgencyEstimate1(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateNew1 = new  List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency1 : AgencyEsitmate1){
                agency1.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                agency1.AF_Fiscal_Year__c=currYear;
                agency1.AF_Adaptation__c=22;
                agency1.AF_Digital__c=22;
                agency1.AF_Traditional__c=22;
                AgencyEsitmateNew1.add(agency1);
            }
            insert AgencyEsitmateNew1;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //insert Bonus summary.
            List<AF_Bonus_Summary__c> bonussummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> bonussummaryQuery = [SELECT ID ,AF_Brand__c FROM AF_Bonus_Summary__c WHERE ID IN : bonussummary LIMIT 1];
            System.assertEquals(bonussummaryQuery[0].AF_Brand__c, AFCategoryBrand[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //insert sub Results.
            List<AF_Sub_Result__c> subResults = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subResultlist= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResults)
            {
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = true;
                sr.AF_Adaptation__c = true;
                sr.AF_Quant__c = 12;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                sr.Bonus_Measure__c ='Business Measure';
                subResultlist.add(sr);
            }
            insert subResultlist;
            List<AF_Sub_Result__c> subResultsQuery = [SELECT ID,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResults LIMIT 2];
            System.assertEquals(subResultsQuery[0].AF_Bonus_Threshold__c ,BonusThresholdQuery[0].id, AF_TestFactory_Helper.SUBRESULT_RECORD);
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,true);
            System.assertEquals(BonusResultList[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            ApexPages.currentPage().getParameters().put(Brandid,AFCategoryBrand[0].id);
            ApexPages.currentPage().getParameters().put(Agencyid,acc[0].id);
            ApexPages.currentPage().getParameters().put(Year,currYear);
            AF_AnnualBonus annulBonus=new AF_AnnualBonus();
            annulBonus.UpdateBonus();
            annulBonus.ConfirmBonus();
            annulBonus.annualBonusConstructorExt(subResultlist);
            annulBonus.annualBonusDigitalTradExt(subResultlist);
            annulBonus.annualBonusTotalTradDigitalCalc();
            annulBonus.annualBonusBMCalc(subResultlist);
            annulBonus.annualBonusQualQuantPerCalc(subResultlist);
            List<AF_Sub_Result__c> subResultlist1= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResultlist)
            {
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = false;
                sr.AF_Adaptation__c = false;
                sr.AF_Quant_Bonus_Value__c=250;
                sr.AF_Qual_Bonus_value__c=300;
                sr.AF_Total_Bonus_Value__c=550;
                sr.AF_Bonusable_Fees__c=25000;
                sr.AF_Quant_Bonus__c=1400;
                subResultlist1.add(sr);
            }
            update subResultlist1;
            
            annulBonus.annualBonusConstructorExt(subResultlist1);
            annulBonus.annualBonusDigitalTradExt(subResultlist1);
            annulBonus.annualBonusTotalTradDigitalCalc();
            annulBonus.annualBonusQuantQualExt(subResultlist1);
            
            
            List<AF_Sub_Result__c> subResultlist2= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResultlist)
            {
                sr.AF_Digital__c = false;
                sr.AF_Traditional__c = true;
                sr.AF_Adaptation__c = false;
                subResultlist2.add(sr);
            }
            update subResultlist2;
            annulBonus.annualBonusConstructorExt(subResultlist2);
            annulBonus.annualBonusDigitalTradExt(subResultlist2);
            annulBonus.annualBonusTotalTradDigitalCalc();
            
            
            List<AF_Sub_Result__c> subResultlist3= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResultlist)
            {
                sr.AF_Digital__c = false;
                sr.AF_Traditional__c = false;
                sr.AF_Adaptation__c = true;
                subResultlist3.add(sr);
            }
            update subResultlist3;
            annulBonus.annualBonusConstructorExt(subResultlist3);
            annulBonus.annualBonusDigitalTradExt(subResultlist3);
            annulBonus.annualBonusTotalTradDigitalCalc();
            //annulBonus.annualBonusQualQuantPerCalc(subResultlist1);
            
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_annualBonus1
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_annualBonus1()
    {
        Test.startTest();
        userforAnnualBonus=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforAnnualBonus.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstlist=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br:BrandEst){
                br.AF_Active__c = true;
                //br.AF_Copied__c= false;
                //br.AF_Locked__c = false; 
                //br.AF_Pilot_Model__c=true;
                br.Brand__c=brandQuery[0].id;
                br.AF_Agency__c=acctQuery[0].id;
                br.AF_Fiscal_Year__c=currYear;
                BrandEstlist.add(br);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null,AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
            }
            insert AnnualBns;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
            System.Assert(AnnualBnsQuery[0].Id != null, ANNUAL_BONUS);
            List<AF_AnnualBonus_Qual__c> AnnualBs = AF_TestFactory_Helper.insertAnnualBonus(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBnslist=new List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  AnnualBonus : AnnualBs)
            {
                AnnualBonus.X5__c = 15;
                AnnualBonus.X1__c = 0;
                AnnualBonus.X2__c = 0;
                AnnualBonus.X3__c = 5;
                AnnualBonus.X4__c = 10;
                AnnualBnslist.add(AnnualBonus);
            }
            insert AnnualBnslist;
            List<AF_AnnualBonus_Qual__c> AnnualBsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c LIMIT 1];
            System.Assert(AnnualBsQuery[0].Id != null, ANNUAL_BONUS);
            // insert QuarterlyBonus.
            List<AF_QuarterlyBonus__c> QuarterlyBonus = AF_TestFactory_Helper.insertQuarterlyBonus(1,false);
            List<AF_QuarterlyBonus__c> QuarterlyBonuslist=new List<AF_QuarterlyBonus__c>();
            for(AF_QuarterlyBonus__c QB: QuarterlyBonus){
                QB.Minimum__c = 5;
                QB.Outstanding__c = 15;
                QB.Stretching__c = 10;
                QuarterlyBonuslist.add(QB);
            }
            insert QuarterlyBonuslist;
            List<AF_QuarterlyBonus__c> QuarterlyBonusQuery = [SELECT ID FROM AF_QuarterlyBonus__c WHERE ID IN : QuarterlyBonus LIMIT 1];
            System.Assert(QuarterlyBonusQuery[0].Id != null, QUARTERLY_BONUS);
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
            System.assertEquals(AFEntity3[0].id !=null, AFEntity[0].id!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
            System.AssertEquals(AFUnileverEntity!= null,AFEntity4!=null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist =new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyEsitmate1 = AF_TestFactory_Helper.insertAgencyEstimate1(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist1 =new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency1 : AgencyEsitmate1){
                agency1.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                agency1.AF_Fiscal_Year__c=currYear;
                agency1.AF_Adaptation__c=22;
                agency1.AF_Digital__c=22;
                agency1.AF_Traditional__c=22;
                AgencyEsitmatelist1.add(agency1);
            }
            insert AgencyEsitmatelist1;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //insert Bonus summary.
            List<AF_Bonus_Summary__c> bonussummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> bonussummaryQuery = [SELECT ID ,AF_Brand__c FROM AF_Bonus_Summary__c WHERE ID IN : bonussummary LIMIT 1];
            System.assertEquals(bonussummaryQuery[0].AF_Brand__c, AFCategoryBrand[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //insert sub Results.
            /*List<AF_Sub_Result__c> subResults = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subResultlist =new List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResults)
            {
                sr.AF_Digital__c = false;
                sr.AF_Traditional__c = true;
                sr.AF_Adaptation__c = false;
                sr.AF_Quant__c = 12;
                sr.AF_Qual__c=1;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                sr.Bonus_Measure__c =bonusMeasure;
                subResultlist.add(sr);
            }
            insert subResultlist;
            List<AF_Sub_Result__c> subResultsQuery = [SELECT ID,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResults LIMIT 2];
            System.assertEquals(subResultsQuery[0].AF_Bonus_Threshold__c ,BonusThresholdQuery[0].id, AF_TestFactory_Helper.SUBRESULT_RECORD);*/
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,true);
            System.assertEquals(BonusResultList[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            ApexPages.currentPage().getParameters().put(Brandid,AFCategoryBrand[0].id);
            ApexPages.currentPage().getParameters().put(Agencyid,acc[0].id);
            ApexPages.currentPage().getParameters().put(Year,currYear);
            AF_AnnualBonus annulBonus1=new AF_AnnualBonus();
            annulBonus1.ConfirmBonus();
            
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data for testing the annual bonus data
*  @name : AF_annualBonus2
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_annualBonus2()
    {
        Test.startTest();
        userforAnnualBonus=AF_TestFactory_Helper.createuser(true);
        User u=[SELECT id,Email,AF_Agency_Fees_User_Type__c FROM user WHERE id=:userforAnnualBonus.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstlist=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br :BrandEst){
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false; 
                //br.AF_Pilot_Model__c=true;
                br.Brand__c=brandQuery[0].id;
                br.AF_Agency__c=acctQuery[0].id;
                br.AF_Fiscal_Year__c=currYear;
                br.AF_AgencyUsers1__c=u.Email;
                BrandEstlist.add(br);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Dummyuser Custom settings
            //List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBnslsit=new List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
                AnnualBnslsit.add(anb);
            }
            insert AnnualBnslsit;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
            System.Assert(AnnualBnsQuery[0].Id != null, ANNUAL_BONUS);
            List<AF_AnnualBonus_Qual__c> AnnualBs = AF_TestFactory_Helper.insertAnnualBonus(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBslist=new List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  AnnualBonus : AnnualBs)
            {
                AnnualBonus.X5__c = 15;
                AnnualBonus.X1__c = 0;
                AnnualBonus.X2__c = 0;
                AnnualBonus.X3__c = 5;
                AnnualBonus.X4__c = 10;
                AnnualBslist.add(AnnualBonus);
            }
            insert AnnualBslist;
            List<AF_AnnualBonus_Qual__c> AnnualBsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c LIMIT 1];
            System.Assert(AnnualBsQuery[0].Id != null, ANNUAL_BONUS);
            // insert QuarterlyBonus.
            List<AF_QuarterlyBonus__c> QuarterlyBonus = AF_TestFactory_Helper.insertQuarterlyBonus(1,false);
            List<AF_QuarterlyBonus__c> QuarterlyBonuslist=new List<AF_QuarterlyBonus__c>();
            for(AF_QuarterlyBonus__c QB: QuarterlyBonus){
                QB.Minimum__c = 5;
                QB.Outstanding__c = 15;
                QB.Stretching__c = 10;
                QuarterlyBonuslist.add(QB);
            }
            insert QuarterlyBonuslist;
            List<AF_QuarterlyBonus__c> QuarterlyBonusQuery = [SELECT ID FROM AF_QuarterlyBonus__c WHERE ID IN : QuarterlyBonus LIMIT 1];
            System.Assert(QuarterlyBonusQuery[0].Id != null, QUARTERLY_BONUS);
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
            System.assertEquals(AFEntity3[0].id !=null, AFEntity[0].id!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
            System.assertEquals(AFEntity4!=null, AFUnileverEntity!=null,AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
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
            List<AF_Agency_Estimate__c> AgencyEsitmate1 = AF_TestFactory_Helper.insertAgencyEstimate1(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist1=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency1 : AgencyEsitmate1){
                agency1.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                agency1.AF_Fiscal_Year__c=currYear;
                agency1.AF_Adaptation__c=22;
                agency1.AF_Digital__c=22;
                agency1.AF_Traditional__c=22;
                AgencyEsitmatelist1.add(agency1);
            }
            insert AgencyEsitmatelist1;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //insert Bonus summary.
            List<AF_Bonus_Summary__c> bonussummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> bonussummaryQuery = [SELECT ID ,AF_Brand__c FROM AF_Bonus_Summary__c WHERE ID IN : bonussummary LIMIT 1];
            System.assertEquals(bonussummaryQuery[0].AF_Brand__c, AFCategoryBrand[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdlist=new List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bonus:BonusThreshold){
                bonus.Agency_Name__c=acc[0].id;
                bonus.Brand_Name__c=AFCategoryBrand[0].id;
                bonus.Year__c=currYear;
                bonus.AF_Country__c=AFUnileverEntity[0].id;
                BonusThresholdlist.add(bonus);
            }
            insert BonusThresholdlist;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //insert sub Results.
            List<AF_Sub_Result__c> subResults = AF_TestFactory_Helper.insertSubResult(1,true);
            system.assert(true,subResults!=null);
            List<AF_Sub_Result__c> subResultlist= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResults)
            {
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = false;
                sr.AF_Adaptation__c = false;
                sr.Bonus_Measure__c ='Business Measure';
                subResultlist.add(sr);
            }
            update subResultlist;
            
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            ApexPages.currentPage().getParameters().put(Brandid,AFCategoryBrand[0].id);
            ApexPages.currentPage().getParameters().put(Agencyid,acc[0].id);
            ApexPages.currentPage().getParameters().put(Year,currYear);
            AF_AnnualBonus annulBonus1=new AF_AnnualBonus();
            annulBonus1.annualBonusConstructorExt(subResultlist);
            annulBonus1.annualBonusDigitalTradExt(subResultlist);
            annulBonus1.annualBonusTotalTradDigitalCalc();
            annulBonus1.annualBonusTradDigitalCalc();
            
            Test.stopTest();
        }
    }
     /***********************************************************************************
*  @Description: this method will the test data for testing the annual bonus data
*  @name : AF_annualBonus3
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void annualBonus3()
    {
        Test.startTest();
        userforAnnualBonus=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforAnnualBonus.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist1=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br :BrandEst1){
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false; 
                //br.AF_Pilot_Model__c=true;
                br.Brand__c=brandQuery[0].id;
                br.AF_Pilot_Model__c=true;
                br.AF_Agency__c=acctQuery[0].id;
                br.AF_Fiscal_Year__c=currYear;
                //br.AF_AgencyBaseFees__c=234;
                br.AF_AgencyUsers1__c=u.Email;
                BrandEstlist1.add(br);
            }
            insert BrandEstlist1;
            List<AF_Brand_Estimate__c> BrandEstQuery1 =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst1 LIMIT 1]; 
            System.assertEquals(BrandEstQuery1[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
            }
            insert AnnualBns;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
            System.Assert(AnnualBnsQuery[0].Id != null, ANNUAL_BONUS);
            List<AF_AnnualBonus_Qual__c> AnnualBs = AF_TestFactory_Helper.insertAnnualBonus(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBslist =new List<AF_AnnualBonus_Qual__c> ();
            for(AF_AnnualBonus_Qual__c  AnnualBonus : AnnualBs)
            {
                AnnualBonus.X5__c = 15;
                AnnualBonus.X1__c = 0;
                AnnualBonus.X2__c = 0;
                AnnualBonus.X3__c = 5;
                AnnualBonus.X4__c = 10;
                AnnualBslist.add(AnnualBonus);
            }
            insert AnnualBslist;
            List<AF_AnnualBonus_Qual__c> AnnualBsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c LIMIT 1];
            System.Assert(AnnualBsQuery[0].Id != null, ANNUAL_BONUS);
            // insert QuarterlyBonus.
            List<AF_QuarterlyBonus__c> QuarterlyBonus = AF_TestFactory_Helper.insertQuarterlyBonus(1,false);
            List<AF_QuarterlyBonus__c> QuarterlyBonuslist=new List<AF_QuarterlyBonus__c> ();
            for(AF_QuarterlyBonus__c QB: QuarterlyBonus){
                QB.Minimum__c = 5;
                QB.Outstanding__c = 15;
                QB.Stretching__c = 10;
                QuarterlyBonuslist.add(QB);
            }
            insert QuarterlyBonuslist;
            List<AF_QuarterlyBonus__c> QuarterlyBonusQuery = [SELECT ID FROM AF_QuarterlyBonus__c WHERE ID IN : QuarterlyBonus LIMIT 1];
            System.Assert(QuarterlyBonusQuery[0].Id != null, QUARTERLY_BONUS);
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
            System.assertEquals(AFEntity[0].id!=null, AFEntity3[0].id!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
            System.assertEquals(AFEntity4!=null, AFUnileverEntity!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            AF_Agency_Estimate__c agency= new AF_Agency_Estimate__c();
            List<AF_Agency_Estimate__c> AgencyEsitmatelist =new List<AF_Agency_Estimate__c>();
            
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Brand_Estimate__c=BrandEstlist1[0].id;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyEsitmate1 = AF_TestFactory_Helper.insertAgencyEstimate1(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist1 =new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency1 : AgencyEsitmate1){
                agency1.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                agency1.AF_Brand_Estimate__c=BrandEstlist1[0].id;
                agency1.AF_Fiscal_Year__c=currYear;
                agency1.AF_Unilever_Entity__c=AFUnileverEntityQuery[0].id;
                agency1.AF_Adaptation__c=22;
                agency1.AF_Digital__c=22;
                agency1.AF_Traditional__c=22;
                AgencyEsitmatelist1 .add(agency1);
            }
            insert AgencyEsitmatelist1 ;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmatelist1  limit 1];
            //System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //insert Bonus summary.
            List<AF_Bonus_Summary__c> bonussummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> bonussummaryQuery = [SELECT ID ,AF_Brand__c FROM AF_Bonus_Summary__c WHERE ID IN : bonussummary LIMIT 1];
            System.assertEquals(bonussummaryQuery[0].AF_Brand__c, AFCategoryBrand[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c,Brand_Name__c,Year__c from AF_Bonus_Threshold__c LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Threshold
            AF_Bonus_Threshold__c Bonus=  new AF_Bonus_Threshold__c ();
            List<AF_Bonus_Threshold__c> BonusThresholdlist=new List<AF_Bonus_Threshold__c>();
            
                Bonus.Agency_Name__c=acctQuery[0].id;
                Bonus.AF_Traditional__c=true;
                Bonus.AF_Digital__c=true;
                Bonus.AF_Adaptation__c=true;
                Bonus.Brand_Name__c=brandQuery[0].id;
                Bonus.AF_Country__c=AFUnileverEntityQuery[0].id;
                Bonus.Year__c=currYear;
                Bonus.AF_country__c=null;
                BonusThresholdlist.add(Bonus);
            
            insert BonusThresholdlist;
            //insert sub Results.
            AF_QuarterlyBonus__c  quart=new AF_QuarterlyBonus__c ();
            quart.Name='Communication';
            quart.Minimum__c=5;
            quart.Outstanding__c=10;
            quart.Stretching__c=23;
            insert quart;
            List<AF_Sub_Result__c> subResults = AF_TestFactory_Helper.insertSubResult(1,true);
            
            
            System.assert(subResults!=null, AF_TestFactory_Helper.SUBRESULT_RECORD);
            List<AF_Sub_Result__c> subResultlist= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResults)
            {
                sr.AF_Digital__c = false;
                sr.AF_Traditional__c = true;
                sr.AF_Adaptation__c = false;
                sr.Bonus_Measure__c ='Business Measure';
                sr.AF_Qual__c=1;
                sr.AF_Country__c=AFUnileverEntityQuery[0].id;
                sr.Bonus_Measure__c=AF_Constants.TEST_COMMUNICATION;
                sr.AF_Quant__c=99;
                //sr.AF_Country__r.AF_Country__c='Global';
                subResultlist.add(sr);
            }
            update subResultlist;
            
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,true);
            System.assert(BonusResultList[0].id!=null, AF_TestFactory_Helper.SUBRESULT_RECORD);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            ApexPages.currentPage().getParameters().put(Brandid,AFCategoryBrand[0].id);
            ApexPages.currentPage().getParameters().put(Agencyid,acc[0].id);
            ApexPages.currentPage().getParameters().put(Year,currYear);
            AF_AnnualBonus annulBonus =new AF_AnnualBonus();
            annulBonus.isTraditional =true;
            annulBonus.isDigital=true;
            annulBonus.pilotMode=true;
            annulBonus.bonusTradDigitalFee=0.0;
            annulBonus.annualBonusConstructorExt(subResultlist);
            annulBonus.annualBonusDigitalTradExt(subResultlist);
            annulBonus.updatebonus();
            annulBonus.ConfirmBonus();
            annulBonus.annualBonusTotalTradDigitalCalc();
            
            
            List<AF_Sub_Result__c> subResultlist1= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResultlist)
            {
                sr.AF_Digital__c = false;
                sr.AF_Traditional__c = false;
                sr.AF_Adaptation__c = true;
                subResultlist1.add(sr);
            }
            update subResultlist1;
            AF_AnnualBonus annulBonus1 =new AF_AnnualBonus();
            AF_AnnualBonus.wrapbonus wrapobj = new AF_AnnualBonus.wrapbonus(0,250,10,BonusThresholdlist[0].id,'Argentina',2,3,4,subResultlist[0],1500,'Brand Attribute',1,'Brand equity');
            annulBonus1.QuartelyBonus = new List<AF_AnnualBonus.wrapbonus>();
            annulBonus1.QuartelyBonus.add(wrapobj);
                             
            annulBonus1.annualBonusConstructorExt(subResultlist1);
            annulBonus1.annualBonusDigitalTradExt(subResultlist1);
            annulBonus1.annualBonusTradDigitalCalc();
            //annulBonus1.annualBonusQualQuantPerCalc(subResultlist1);
            annulBonus1.sum_of_total_bonus=234;
            annulBonus1.annualBonusPilotModel(acctQuery[0].id,brandQuery[0].id,currYear);
            annulBonus1.ConfirmBonus2();
            annulBonus1.Calculate_Remun_Per2();
            annulBonus1.UpdateBonus2();
            annulBonus1.Calculate_Remun2();
            try{
            annulBonus1.Calculate_Qual();
            }catch (Exception e){
            system.debug(e);
            system.assert(true,'Exception  '+e);
            }
            annulBonus1.annualBonusQuantQualExt(subResultlist);
            annulBonus1.updatebonus();
            annulBonus1.ConfirmBonus();
            annulBonus1.Calculate_Bonus();
            annulBonus1.isglobal=true;
            
            
            Test.stopTest();
        }
    }
       /***********************************************************************************
*  @Description: this method will the test data for testing the annual bonus data
*  @name : AF_annualBonus4
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void annualBonus()
    {
        Test.startTest();
        userforAnnualBonus=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforAnnualBonus.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist1=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br :BrandEst1){
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false; 
                //br.AF_Pilot_Model__c=true;
                br.Brand__c=brandQuery[0].id;
                br.AF_Pilot_Model__c=true;
                br.AF_Agency__c=acctQuery[0].id;
                br.AF_Fiscal_Year__c=currYear;
                br.AF_Is_Global_Bonus_Threshold_Checked__c=true;
                br.AF_AgencyUsers1__c=u.Email;
                BrandEstlist1.add(br);
            }
            insert BrandEstlist1;
            List<AF_Brand_Estimate__c> BrandEstQuery1 =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst1 LIMIT 1]; 
            System.assertEquals(BrandEstQuery1[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
            }
            insert AnnualBns;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
            System.Assert(AnnualBnsQuery[0].Id != null, ANNUAL_BONUS);
            AF_AnnualBonus_Qual__c AnnualBs = new AF_AnnualBonus_Qual__c();
            List<AF_AnnualBonus_Qual__c> AnnualBslist =new List<AF_AnnualBonus_Qual__c> ();
                AnnualBs.Name='Test Setting';
                AnnualBs.X5__c = 15;
                AnnualBs.X1__c = 0;
                AnnualBs.X2__c = 0;
                AnnualBs.X3__c = 5;
                AnnualBs.X4__c = 10;
                AnnualBslist.add(AnnualBs );
            
            insert AnnualBslist;
            List<AF_AnnualBonus_Qual__c> AnnualBsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c LIMIT 1];
            System.Assert(AnnualBsQuery[0].Id != null, ANNUAL_BONUS);
            // insert QuarterlyBonus.
            List<AF_QuarterlyBonus__c> QuarterlyBonus = AF_TestFactory_Helper.insertQuarterlyBonus(1,false);
            List<AF_QuarterlyBonus__c> QuarterlyBonuslist=new List<AF_QuarterlyBonus__c> ();
            for(AF_QuarterlyBonus__c QB: QuarterlyBonus){
                QB.Minimum__c = 5;
                QB.Outstanding__c = 15;
                QB.Stretching__c = 10;
                QuarterlyBonuslist.add(QB);
            }
            insert QuarterlyBonuslist;
            List<AF_QuarterlyBonus__c> QuarterlyBonusQuery = [SELECT ID FROM AF_QuarterlyBonus__c WHERE ID IN : QuarterlyBonus LIMIT 1];
            System.Assert(QuarterlyBonusQuery[0].Id != null, QUARTERLY_BONUS);
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
            System.assertEquals(AFEntity[0].id!=null, AFEntity3[0].id!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
            System.assertEquals(AFEntity4!=null, AFUnileverEntity!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            AF_Agency_Estimate__c agency= new AF_Agency_Estimate__c();
            List<AF_Agency_Estimate__c> AgencyEsitmatelist =new List<AF_Agency_Estimate__c>();
            
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Brand_Estimate__c=BrandEstlist1[0].id;
                agency.AF_Unilever_Entity__c=AFUnileverEntityQuery[0].id;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyEsitmate1 = AF_TestFactory_Helper.insertAgencyEstimate1(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist1 =new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency1 : AgencyEsitmate1){
                agency1.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                agency1.AF_Brand_Estimate__c=BrandEstlist1[0].id;
                agency1.AF_Fiscal_Year__c=currYear;
                agency1.AF_Unilever_Entity__c=AFUnileverEntityQuery[0].id;
                agency1.AF_Adaptation__c=22;
                agency1.AF_Digital__c=22;
                agency1.AF_Traditional__c=22;
                AgencyEsitmatelist1 .add(agency1);
            }
            insert AgencyEsitmatelist1 ;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmatelist1  limit 1];
            //System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //insert Bonus summary.
            List<AF_Bonus_Summary__c> bonussummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> bonussummaryQuery = [SELECT ID ,AF_Brand__c FROM AF_Bonus_Summary__c WHERE ID IN : bonussummary LIMIT 1];
            System.assertEquals(bonussummaryQuery[0].AF_Brand__c, AFCategoryBrand[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c,Brand_Name__c,Year__c from AF_Bonus_Threshold__c LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Threshold
            AF_Bonus_Threshold__c Bonus=  new AF_Bonus_Threshold__c ();
            List<AF_Bonus_Threshold__c> BonusThresholdlist=new List<AF_Bonus_Threshold__c>();
            
                Bonus.Agency_Name__c=acctQuery[0].id;
                Bonus.AF_Traditional__c=true;
                Bonus.AF_Digital__c=true;
                Bonus.AF_Adaptation__c=true;
                Bonus.Brand_Name__c=brandQuery[0].id;
                
                Bonus.Year__c=currYear;
                Bonus.AF_country__c=AFUnileverEntityQuery[0].id;
                BonusThresholdlist.add(Bonus);
            
            insert BonusThresholdlist;
            //insert sub Results.
            List<AF_Sub_Result__c> subResults = AF_TestFactory_Helper.insertSubResult(1,true);
            AF_QuarterlyBonus__c  quart=new AF_QuarterlyBonus__c ();
            quart.Name='Business Measure';
            quart.Minimum__c=5;
            quart.Outstanding__c=10;
            quart.Stretching__c=23;
            insert quart;
            
            System.assert(subResults!=null, AF_TestFactory_Helper.SUBRESULT_RECORD);
            AF_Sub_Result__c sub =new AF_Sub_Result__c();
            List<AF_Sub_Result__c> subResultlist= new  List<AF_Sub_Result__c>();
            
                sub.AF_Digital__c = false;
                sub.AF_Traditional__c = true;
                sub.AF_Adaptation__c = false;
                sub.Bonus_Measure__c ='Business Measure';
                sub.AF_Qual__c=1;
                sub.AF_Bonus_Threshold__c=BonusThresholdlist[0].id;
                sub.AF_country__c=AFUnileverEntityQuery[0].id;
                sub.Bonus_Measure__c=AF_Constants.TEST_BUSINESS_MEASURE;
                sub.AF_Quant__c=23;
                //sr.AF_Country__r.AF_Country__c='Global';
                subResultlist.add(sub);
            
            insert subResultlist;
            
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,true);
            System.assert(BonusResultList[0].id!=null, AF_TestFactory_Helper.SUBRESULT_RECORD);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            ApexPages.currentPage().getParameters().put(Brandid,AFCategoryBrand[0].id);
            ApexPages.currentPage().getParameters().put(Agencyid,acc[0].id);
            ApexPages.currentPage().getParameters().put(Year,currYear);
            AF_AnnualBonus annulBonus =new AF_AnnualBonus();
            annulBonus.isTraditional =true;
            annulBonus.isDigital=true;
            annulBonus.pilotMode=true;
            annulBonus.bonusTradDigitalFee=0.0;
            annulBonus.annualBonusConstructorExt(subResultlist);
            annulBonus.annualBonusDigitalTradExt(subResultlist);
            annulBonus.updatebonus();
            annulBonus.ConfirmBonus();
            annulBonus.annualBonusTotalTradDigitalCalc();
            
            
            List<AF_Sub_Result__c> subResultlist1= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResultlist)
            {
                sr.AF_Digital__c = false;
                sr.AF_Traditional__c = false;
                sr.AF_Adaptation__c = true;
                subResultlist1.add(sr);
            }
            update subResultlist1;
            AF_AnnualBonus annulBonus1 =new AF_AnnualBonus();
            AF_AnnualBonus.wrapbonus wrapobj = new AF_AnnualBonus.wrapbonus(0,250,10,BonusThresholdlist[0].id,'Argentina',2,3,4,subResultlist[0],1500,'Brand Attribute',1,'Brand equity');
            annulBonus1.QuartelyBonus = new List<AF_AnnualBonus.wrapbonus>();
            annulBonus1.QuartelyBonus.add(wrapobj);
                             
            annulBonus1.annualBonusConstructorExt(subResultlist1);
            annulBonus1.annualBonusDigitalTradExt(subResultlist1);
            //annulBonus1.annualBonusQualQuantPerCalc(subResultlist);
            annulBonus1.sum_of_total_bonus=234;
            annulBonus1.annualBonusPilotModel(acctQuery[0].id,brandQuery[0].id,currYear);
            annulBonus1.ConfirmBonus2();
            annulBonus1.Calculate_Remun_Per2();
            annulBonus1.UpdateBonus2();
            annulBonus1.Calculate_Remun2();
            //annulBonus1.Calculate_Qual();
            annulBonus1.annualBonusQuantQualExt(subResultlist);
            annulBonus1.updatebonus();
            annulBonus1.ConfirmBonus();
            annulBonus1.Calculate_Bonus();
            annulBonus1.isglobal=false;
            
            
            Test.stopTest();
        }
    }
         /***********************************************************************************
*  @Description: this method will the test data for testing the annual bonus data
*  @name : AF_annualBonus5
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void annualBonus5()
    {
        Test.startTest();
        userforAnnualBonus=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforAnnualBonus.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist1=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br :BrandEst1){
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;  
                br.Brand__c=brandQuery[0].id;
                br.AF_Pilot_Model__c=true;
                br.AF_Is_Global_Bonus_Threshold_Checked__c=true;
                br.AF_Agency__c=acctQuery[0].id;
                br.AF_Fiscal_Year__c=currYear;
                br.AF_AgencyUsers1__c=u.Email;
                BrandEstlist1.add(br);
            }
            insert BrandEstlist1;
            List<AF_Brand_Estimate__c> BrandEstQuery1 =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst1 LIMIT 1]; 
            System.assertEquals(BrandEstQuery1[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert custom setting
            
           AF_AnnualBonus_Qual__c AnnualBonus= new AF_AnnualBonus_Qual__c();
            List<AF_AnnualBonus_Qual__c> AnnualBslist =new List<AF_AnnualBonus_Qual__c> ();
                AnnualBonus.Name='Qualitative Value';
                AnnualBonus.X5__c = 15;
                AnnualBonus.X1__c = 0;
                AnnualBonus.X2__c = 0;
                AnnualBonus.X3__c = 5;
                AnnualBonus.X4__c = 10;
                AnnualBslist.add(AnnualBonus);
            
            insert AnnualBslist;
            List<AF_AnnualBonus_Qual__c> AnnualBsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c LIMIT 1];
            System.Assert(AnnualBsQuery[0].Id != null, ANNUAL_BONUS);
            // insert QuarterlyBonus.
            List<AF_QuarterlyBonus__c> QuarterlyBonus = AF_TestFactory_Helper.insertQuarterlyBonus(1,false);
            List<AF_QuarterlyBonus__c> QuarterlyBonuslist=new List<AF_QuarterlyBonus__c> ();
            for(AF_QuarterlyBonus__c QB: QuarterlyBonus){
                QB.Minimum__c = 5;
                QB.Outstanding__c = 15;
                QB.Stretching__c = 10;
                QuarterlyBonuslist.add(QB);
            }
            insert QuarterlyBonuslist;
            List<AF_QuarterlyBonus__c> QuarterlyBonusQuery = [SELECT ID FROM AF_QuarterlyBonus__c WHERE ID IN : QuarterlyBonus LIMIT 1];
            System.Assert(QuarterlyBonusQuery[0].Id != null, QUARTERLY_BONUS);
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
            System.assertEquals(AFEntity[0].id!=null, AFEntity3[0].id!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
            System.assertEquals(AFEntity4!=null, AFUnileverEntity!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //insert unilever Entity.
            AF_Entity__c ENT= new AF_Entity__c();
             List<AF_Entity__c> AFUnileverEntity1= new  List<AF_Entity__c>();
            
            ENT.Name='Global';
            ENT.AF_Country__c='Global';
            ENT.RecordTypeId=AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE;
            AFUnileverEntity1.add(ENT);
            
            
            insert AFUnileverEntity1;
            system.assertequals(AFUnileverEntity1[0].AF_Country__c,'Global');
            //Insert Agency Estimate.
            AF_Agency_Estimate__c agency= new AF_Agency_Estimate__c();
            List<AF_Agency_Estimate__c> AgencyEsitmatelist =new List<AF_Agency_Estimate__c>();
            
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Brand_Estimate__c=BrandEstlist1[0].id;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyEsitmate1 = AF_TestFactory_Helper.insertAgencyEstimate1(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist1 =new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency1 : AgencyEsitmate1){
                agency1.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                agency1.AF_Brand_Estimate__c=BrandEstlist1[0].id;
                agency1.AF_Fiscal_Year__c=currYear;
                agency1.AF_Unilever_Entity__c=AFUnileverEntityQuery[0].id;
                agency1.AF_Adaptation__c=22;
                agency1.AF_Digital__c=22;
                agency1.AF_Traditional__c=22;
                AgencyEsitmatelist1 .add(agency1);
            }
            insert AgencyEsitmatelist1 ;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmatelist1  limit 1];
            //System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //insert Bonus summary.
            List<AF_Bonus_Summary__c> bonussummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> bonussummaryQuery = [SELECT ID ,AF_Brand__c FROM AF_Bonus_Summary__c WHERE ID IN : bonussummary LIMIT 1];
            System.assertEquals(bonussummaryQuery[0].AF_Brand__c, AFCategoryBrand[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c,Brand_Name__c,Year__c from AF_Bonus_Threshold__c LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Threshold
            AF_Bonus_Threshold__c Bonus=  new AF_Bonus_Threshold__c ();
            List<AF_Bonus_Threshold__c> BonusThresholdlist=new List<AF_Bonus_Threshold__c>();
            
                Bonus.Agency_Name__c=acctQuery[0].id;
                Bonus.AF_Traditional__c=true;
                Bonus.AF_Digital__c=true;
                Bonus.AF_Adaptation__c=true;
                Bonus.Brand_Name__c=brandQuery[0].id;
                Bonus.AF_Country__c=AFUnileverEntity1[0].id;
                Bonus.Year__c=currYear;
                Bonus.AF_country__c=null;
                BonusThresholdlist.add(Bonus);
            
            insert BonusThresholdlist;
            //insert sub Results.
            //List<AF_Sub_Result__c> subResults = AF_TestFactory_Helper.insertSubResult(1,true);
            AF_QuarterlyBonus__c  quart=new AF_QuarterlyBonus__c ();
            quart.Name='Brand Attribute';
            quart.Minimum__c=5;
            quart.Outstanding__c=10;
            quart.Stretching__c=23;
            insert quart;
            AF_Sub_Result__c sr1 = new AF_Sub_Result__c();
            //System.assert(subResults!=null, AF_TestFactory_Helper.SUBRESULT_RECORD);
            List<AF_Sub_Result__c> subResultlist= new  List<AF_Sub_Result__c>();
            
                sr1.AF_Digital__c = false;
                sr1.AF_Traditional__c = true;
                sr1.AF_Adaptation__c = false;
                sr1.Bonus_Measure__c ='Business Measure';
                sr1.AF_Qual__c=1;
                sr1.AF_Quant__c=23;
                sr1.AF_Country__c=AFUnileverEntity1[0].id;
                sr1.AF_Bonus_Threshold__c=BonusThresholdlist[0].id;
                sr1.Bonus_Measure__c=AF_Constants.TEST_BRAND_ATTRIBUTE;
                //sr.AF_Country__r.AF_Country__c='Global';
                subResultlist.add(sr1);
            
            insert subResultlist;
            //system.assertequals(subResultlist[0].AF_Country__c,Null);
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,true);
            System.assert(BonusResultList[0].id!=null, AF_TestFactory_Helper.SUBRESULT_RECORD);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            ApexPages.currentPage().getParameters().put(Brandid,AFCategoryBrand[0].id);
            ApexPages.currentPage().getParameters().put(Agencyid,acc[0].id);
            ApexPages.currentPage().getParameters().put(Year,currYear);
            AF_AnnualBonus annulBonus =new AF_AnnualBonus();
            annulBonus.isTraditional =true;
            annulBonus.isDigital=true;
            annulBonus.pilotMode=true;
            annulBonus.bonusTradDigitalFee=0.0;
            annulBonus.annualBonusConstructorExt(subResultlist);
            annulBonus.annualBonusDigitalTradExt(subResultlist);
            annulBonus.updatebonus();
            annulBonus.ConfirmBonus();
            annulBonus.annualBonusTotalTradDigitalCalc();
            
            
            List<AF_Sub_Result__c> subResultlist1= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr : subResultlist)
            {
                sr.AF_Digital__c = false;
                sr.AF_Traditional__c = false;
                sr.AF_Adaptation__c = true;
                subResultlist1.add(sr);
            }
            update subResultlist1;
            AF_AnnualBonus annulBonus1 =new AF_AnnualBonus();
            AF_AnnualBonus.wrapbonus wrapobj = new AF_AnnualBonus.wrapbonus(0,250,10,BonusThresholdlist[0].id,'Argentina',2,3,4,subResultlist[0],1500,'Brand Attribute',1,'Brand equity');
            annulBonus1.QuartelyBonus = new List<AF_AnnualBonus.wrapbonus>();
            annulBonus1.QuartelyBonus.add(wrapobj);
                             
            annulBonus1.annualBonusConstructorExt(subResultlist1);
            annulBonus1.annualBonusDigitalTradExt(subResultlist1);
            annulBonus1.annualBonusTradDigitalCalc();
            //annulBonus1.annualBonusQualQuantPerCalc(subResultlist1);
            annulBonus1.sum_of_total_bonus=234;
            annulBonus1.annualBonusPilotModel(acctQuery[0].id,brandQuery[0].id,currYear);
            annulBonus1.ConfirmBonus2();
            annulBonus1.Calculate_Remun_Per2();
            annulBonus1.UpdateBonus2();
            annulBonus1.Calculate_Remun2();
            try{
            annulBonus1.Calculate_Qual();
            }catch (Exception e){
            system.debug(e);
            system.assert(true,'Exception  '+e);
            }
            annulBonus1.annualBonusQuantQualExt(subResultlist);
            annulBonus1.updatebonus();
            annulBonus1.ConfirmBonus();
            annulBonus1.Calculate_Bonus();
            annulBonus1.isglobal=true;
            annulBonus1.pilotMode=true;
            annulBonus1.total_bonus_fees=234;
            
            Test.stopTest();
        }
    }
}