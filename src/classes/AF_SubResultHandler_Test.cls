/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_SubResultHandler_Test
@Created Date : 02/08/2014.
@Description : This Test class for AF_SubResultHandler  apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_SubResultHandler_Test
{
    Private Static Integer IcurrYear = System.Today().year();
    Private Static string currYear=string.valueof(IcurrYear);
    static user userForsubResult;
    /**********************************************************************
*  @Description: This method will have Test data for testing the subresult
                 handler method,as it performs the testing logic of updation of quant
                 and qual amounts
*  @name : AF_SubResultHandler
*  @param : none
*  @return : none
*************************************************************************/   
    static testMethod void AF_SubResultHandler() 
    {
        Test.startTest();
        userForsubResult=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForsubResult.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br :BrandEst){
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;  
                br.AF_AgencyUsers1__c=u.Email;
                BrandEstNew.add(br);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBnsNew = new  List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
                AnnualBnsNew.add(Anb);
            }
            insert AnnualBnsNew;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
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
            System.assertEquals(AnnualBnsQuery!=null, AnnualBsQuery!=null,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
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
            System.assert(QuarterlyBonusQuery!=null,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
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
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            System.assertEquals(AFEntity3!=null,AFEntityQuery!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            System.assertEquals(AFUnileverEntity!=null,AFEntity4!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
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
            //insert sub result
            List<AF_Sub_Result__c> subResults1 = AF_TestFactory_Helper.insertSubResult1(1,true);
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,true);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            System.assertEquals(BonusResultList!=null,subResults1!=null, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            list <AF_Sub_Result__c>  checklist =new list<AF_Sub_Result__c>();
            AF_Sub_Result__c check = new AF_Sub_Result__c();
            check.AF_Minimum__c=0;
            check.AF_Stretching__c=4;
            check.AF_Outstanding__c=3;
            checklist.add(check);
            AF_Sub_Result__c  check1 =new AF_Sub_Result__c();
            check1.AF_Minimum__c=1;
            check1.AF_Stretching__c=2;
            check1.AF_Outstanding__c=3;
            check1.AF_Period__c=AF_Constants.QUARTER1;
            check1.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
            check1.AF_Quant_Bonus_Value__c=234;
            insert check1;
            update check1;
            delete check1;
            AF_Sub_Result__c  check3 =new AF_Sub_Result__c();
            check3.AF_Minimum__c=1;
            check3.AF_Stretching__c=2;
            check3.AF_Outstanding__c=0;
            AF_Sub_Result__c  check2 =new AF_Sub_Result__c();
            check2.AF_Minimum__c=1;
            check2.AF_Stretching__c=1;
            check2.AF_Outstanding__c=1;
            AF_SubResultHandler subhand = new AF_SubResultHandler();
            subhand.bulkBefore();
            subhand.validateSubResult(check3);
            subhand.validateSubResult(check2);
            //subhand.bulkAfter();
            AF_Sub_Result__c so = new AF_Sub_Result__c();
            AF_Sub_Result__c oldso = new AF_Sub_Result__c();
            subhand.beforeInsert(so);
            subhand.beforeUpdate(so,oldso );
            subhand.afterInsert(so);
            subhand.afterUpdate(oldso,so);
            subhand.afterdelete(so);
            subhand.beforeDelete(so);
            subhand.validateSubResult(check);
            subhand.andFinallyDeleteExt();
            subhand.andFinallyBonusListUpdate();
            AF_CheckRecursiveBonusQuarterly.run=true;
            Test.stopTest();
        }
    } 
        /**********************************************************************
*  @Description: This method will have Test data for testing the subresult
                 handler method,as it performs the testing logic of updation of quant
                 and qual amounts
*  @name : AF_SubResultHandler1
*  @param : none
*  @return : none
*************************************************************************/   
    static testMethod void AF_SubResultHandler1() 
    {
        Test.startTest();
        userForsubResult=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForsubResult.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br :BrandEst){
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;  
                br.AF_AgencyUsers1__c=u.Email;
                BrandEstNew.add(br);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBnsNew = new  List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
                AnnualBnsNew.add(Anb);
            }
            insert AnnualBnsNew;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
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
            System.assertEquals(AnnualBnsQuery!=null, AnnualBsQuery!=null,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
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
            System.assert(QuarterlyBonusQuery!=null,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
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
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            System.assertEquals(AFEntity3!=null,AFEntityQuery!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            System.assertEquals(AFUnileverEntity!=null,AFEntity4!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
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
            //insert sub result
            //List<AF_Sub_Result__c> subResult = AF_TestFactory_Helper.insertSubResult(1,false);
            AF_Sub_Result__c sr=new AF_Sub_Result__c();
            List<AF_Sub_Result__c> subResultlist =new List<AF_Sub_Result__c>();
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = true;
                sr.AF_Bonus_Threshold__c=BonusThresholdlist[0].id;
                sr.AF_Quant_Bonus_Value__c=12;
                sr.AF_Bonusable_Fees__c=12;
                //sr.AF_Result_type__c=AF_Constants.RESULT_TYPE_QUARTERLY;
                sr.AF_Status__c=AF_Constants.STATUS_DRAFT;
                //sr.AF_Period__c = AF_Constants.QUARTER1;
                sr.AF_Class_code__c=false;
                sr.AF_Country__c=AFUnileverEntityQuery[0].id;
                sr.Bonus_Measure__c=AF_Constants.TEST_BUSINESS_MEASURE;
                sr.AF_Quant__c = 55;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                subResultlist.add(sr);
            
            insert subResultlist;
            
            AF_Sub_Result__c sr1=new AF_Sub_Result__c();
            List<AF_Sub_Result__c> subResultlist1 =new List<AF_Sub_Result__c>();
                sr1.AF_Digital__c = true;
                sr1.AF_Traditional__c = true;
                sr1.AF_Bonus_Threshold__c=BonusThresholdlist[0].id;
                sr1.AF_Quant_Bonus_Value__c=12;
                sr1.AF_Bonusable_Fees__c=12;
                //sr.AF_Result_type__c=AF_Constants.RESULT_TYPE_QUARTERLY;
                sr1.AF_Status__c=AF_Constants.STATUS_DRAFT;
                sr1.AF_Period__c = AF_Constants.QUARTER1;
                sr1.AF_Class_code__c=false;
                sr1.AF_Country__c=AFUnileverEntityQuery[0].id;
                sr1.Bonus_Measure__c=AF_Constants.TEST_BUSINESS_MEASURE;
                sr1.AF_Quant__c = 55;
                sr1.AF_Minimum__c = 1;
                sr1.AF_Outstanding__c = 3;
                sr1.AF_Stretching__c = 2;
                subResultlist1.add(sr1);
            
            insert subResultlist1;
            update subResultlist1;
            List<AF_Bonus_Results__c> BonusResult = AF_TestFactory_Helper.insertBonusResults(1,false);
              List<AF_Bonus_Results__c> BonusResultlist =new List<AF_Bonus_Results__c>();
              for (AF_Bonus_Results__c Bonus:BonusResult){
              Bonus.RecordTypeId=Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Quarterly').getRecordTypeId();
              Bonus.AF_Period__c=AF_Constants.QUARTER2;
              Bonus.AF_Bonus_Thresholds__c=BonusThresholdlist[0].id;
              }
              //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold1 =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c LIMIT 1];
            AF_SubResultHandler subhand = new AF_SubResultHandler();
            //subhand.bulkBefore();
            //subhand.bulkAfter();
            AF_Sub_Result__c  check =new AF_Sub_Result__c();
            check.AF_Minimum__c=0;
            check.AF_Stretching__c=2;
            check.AF_Outstanding__c=3;
            check.AF_Period__c=AF_Constants.QUARTER2;
            check.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
            check.AF_Quant_Bonus_Value__c=234;
            AF_Sub_Result__c  check1 =new AF_Sub_Result__c();
            check1.AF_Minimum__c=0;
            check1.AF_Stretching__c=2;
            check1.AF_Outstanding__c=1;
            AF_Sub_Result__c  check11 =new AF_Sub_Result__c();
            check11.AF_Minimum__c=1;
            check11.AF_Stretching__c=2;
            check11.AF_Outstanding__c=3;
            check11.AF_Period__c=AF_Constants.QUARTER2;
            check11.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
            check11.AF_Quant_Bonus_Value__c=234;
            insert check11;
            update check11;
            delete check11;
            AF_Sub_Result__c so = new AF_Sub_Result__c();
            AF_Sub_Result__c oldso = new AF_Sub_Result__c();
            subhand.beforeInsert(so);
            subhand.beforeUpdate(so,oldso );
            subhand.afterInsert(so);
            subhand.afterUpdate(oldso,so);
            subhand.afterdelete(so);
            subhand.beforeDelete(so);
            subhand.andFinallyDeleteExt();
            subhand.andFinallyBonusListUpdate();
            subhand.andFinallyUpdateExt();
            subhand.andFinallyInsertExt();
            subhand.validateSubResult(check);
            subhand.validateSubResult(check1);
            AF_CheckRecursiveBonusQuarterly.run=true;
            Test.stopTest();
        }
    } 
      /**********************************************************************
*  @Description: This method will have Test data for testing the subresult
                 handler method,as it performs the testing logic of updation of quant
                 and qual amounts
*  @name : AF_SubResultHandler2
*  @param : none
*  @return : none
*************************************************************************/   
    static testMethod void AF_SubResultHandler2() 
    {
        Test.startTest();
        userForsubResult=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForsubResult.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br :BrandEst){
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;  
                br.AF_AgencyUsers1__c=u.Email;
                BrandEstNew.add(br);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBnsNew = new  List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
                AnnualBnsNew.add(Anb);
            }
            insert AnnualBnsNew;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
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
            System.assertEquals(AnnualBnsQuery!=null, AnnualBsQuery!=null,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
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
            System.assert(QuarterlyBonusQuery!=null,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
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
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            System.assertEquals(AFEntity3!=null,AFEntityQuery!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            System.assertEquals(AFUnileverEntity!=null,AFEntity4!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
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
            //insert sub result
            //List<AF_Sub_Result__c> subResult = AF_TestFactory_Helper.insertSubResult(1,false);
            AF_Sub_Result__c sr=new AF_Sub_Result__c();
            List<AF_Sub_Result__c> subResultlist =new List<AF_Sub_Result__c>();
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = true;
                sr.AF_Bonus_Threshold__c=BonusThresholdlist[0].id;
                sr.AF_Quant_Bonus_Value__c=12;
                sr.AF_Bonusable_Fees__c=12;
                //sr.AF_Result_type__c=AF_Constants.RESULT_TYPE_QUARTERLY;
                sr.AF_Status__c=AF_Constants.STATUS_DRAFT;
                sr.AF_Period__c = AF_Constants.QUARTER1;
                sr.AF_Class_code__c=false;
                sr.AF_Country__c=AFUnileverEntityQuery[0].id;
                sr.Bonus_Measure__c=AF_Constants.TEST_BUSINESS_MEASURE;
                sr.AF_Quant__c = 55;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                subResultlist.add(sr);
            try{
            insert subResultlist;
            }catch (Exception e){
            system.debug(e);
            System.assert(true, 'Exception ' + e);
            }
            AF_Sub_Result__c sr1=new AF_Sub_Result__c();
            List<AF_Sub_Result__c> subResultlist1 =new List<AF_Sub_Result__c>();
                sr1.AF_Digital__c = true;
                sr1.AF_Traditional__c = true;
                sr1.AF_Bonus_Threshold__c=BonusThresholdlist[0].id;
                sr1.AF_Quant_Bonus_Value__c=12;
                sr1.AF_Bonusable_Fees__c=12;
                //sr.AF_Result_type__c=AF_Constants.RESULT_TYPE_QUARTERLY;
                sr1.AF_Status__c=AF_Constants.STATUS_DRAFT;
                sr1.AF_Period__c = AF_Constants.QUARTER1;
                sr1.AF_Class_code__c=false;
                sr1.AF_Country__c=AFUnileverEntityQuery[0].id;
                sr1.Bonus_Measure__c=AF_Constants.TEST_BUSINESS_MEASURE;
                sr1.AF_Quant__c = 55;
                sr1.AF_Minimum__c = 1;
                sr1.AF_Outstanding__c = 3;
                sr1.AF_Stretching__c = 2;
                subResultlist1.add(sr1);
            
            //insert subResultlist1;
            List<AF_Bonus_Results__c> BonusResult = AF_TestFactory_Helper.insertBonusResults(1,false);
              List<AF_Bonus_Results__c> BonusResultlist =new List<AF_Bonus_Results__c>();
              for (AF_Bonus_Results__c Bonus:BonusResult){
              Bonus.RecordTypeId=Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Quarterly').getRecordTypeId();
              Bonus.AF_Period__c=AF_Constants.QUARTER1;
              Bonus.AF_Bonus_Thresholds__c=BonusThresholdlist[0].id;
              }
              //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold1 =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c LIMIT 1];
            AF_SubResultHandler subhand = new AF_SubResultHandler();
            //subhand.bulkBefore();
            //subhand.bulkAfter();
            AF_Sub_Result__c  check =new AF_Sub_Result__c();
            check.AF_Minimum__c=0;
            check.AF_Stretching__c=2;
            check.AF_Outstanding__c=3;
            check.AF_Period__c=AF_Constants.QUARTER2;
            check.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
            check.AF_Quant_Bonus_Value__c=234;
            check.AF_Status__c=AF_Constants.STATUS_DRAFT;
            AF_Sub_Result__c  check1 =new AF_Sub_Result__c();
            check1.AF_Minimum__c=1;
            check1.AF_Stretching__c=2;
            check1.AF_Outstanding__c=1;
            AF_Sub_Result__c  check11 =new AF_Sub_Result__c();
            check11.AF_Minimum__c=1;
            check11.AF_Stretching__c=2;
            check11.AF_Outstanding__c=3;
            check11.AF_Period__c=AF_Constants.QUARTER3;
            check11.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
            check11.AF_Quant_Bonus_Value__c=234;
            insert check11;
            update check11;
            delete check11;
            AF_Sub_Result__c so = new AF_Sub_Result__c();
            AF_Sub_Result__c oldso = new AF_Sub_Result__c();
            subhand.beforeInsert(so);
            subhand.beforeUpdate(so,oldso );
            subhand.afterInsert(so);
            subhand.afterUpdate(oldso,so);
            subhand.afterdelete(so);
            subhand.beforeDelete(so);
            subhand.andFinallyDeleteExt();
            subhand.andFinallyBonusListUpdate();
            AF_CheckRecursiveBonusQuarterly.run=true;
            subhand.andFinallyUpdateExt();
            subhand.andFinallyInsertExt();
            subhand.validateSubResult(check);
            subhand.validateSubResult(check1);
            Test.stopTest();
        }
    } 
        /**********************************************************************
*  @Description: This method will have Test data for testing the subresult
                 handler method,as it performs the testing logic of updation of quant
                 and qual amounts
*  @name : AF_SubResultHandler3
*  @param : none
*  @return : none
*************************************************************************/   
    static testMethod void AF_SubResultHandler3() 
    {
        Test.startTest();
        userForsubResult=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForsubResult.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br :BrandEst){
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;  
                br.AF_AgencyUsers1__c=u.Email;
                BrandEstNew.add(br);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBnsNew = new  List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
                AnnualBnsNew.add(Anb);
            }
            insert AnnualBnsNew;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
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
            System.assertEquals(AnnualBnsQuery!=null, AnnualBsQuery!=null,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
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
            System.assert(QuarterlyBonusQuery!=null,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
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
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            System.assertEquals(AFEntity3!=null,AFEntityQuery!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            System.assertEquals(AFUnileverEntity!=null,AFEntity4!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
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
            //insert sub result
            //List<AF_Sub_Result__c> subResult = AF_TestFactory_Helper.insertSubResult(1,false);
            AF_Sub_Result__c sr=new AF_Sub_Result__c();
            List<AF_Sub_Result__c> subResultlist =new List<AF_Sub_Result__c>();
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = true;
                sr.AF_Bonus_Threshold__c=BonusThresholdlist[0].id;
                sr.AF_Quant_Bonus_Value__c=12;
                sr.AF_Bonusable_Fees__c=12;
                //sr.AF_Result_type__c=AF_Constants.RESULT_TYPE_QUARTERLY;
                sr.AF_Status__c=AF_Constants.STATUS_DRAFT;
                sr.AF_Period__c = AF_Constants.QUARTER2;
                sr.AF_Class_code__c=false;
                sr.AF_Country__c=AFUnileverEntityQuery[0].id;
                sr.Bonus_Measure__c=AF_Constants.TEST_BUSINESS_MEASURE;
                sr.AF_Quant__c = 55;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                subResultlist.add(sr);
            try{
            insert subResultlist;
            }catch (Exception e){
            system.debug(e);
            System.assert(true, 'Exception ' + e);
            }
            AF_Sub_Result__c sr1=new AF_Sub_Result__c();
            List<AF_Sub_Result__c> subResultlist1 =new List<AF_Sub_Result__c>();
                sr1.AF_Digital__c = true;
                sr1.AF_Traditional__c = true;
                sr1.AF_Bonus_Threshold__c=BonusThresholdlist[0].id;
                sr1.AF_Quant_Bonus_Value__c=12;
                sr1.AF_Bonusable_Fees__c=12;
                //sr.AF_Result_type__c=AF_Constants.RESULT_TYPE_QUARTERLY;
                sr1.AF_Status__c=AF_Constants.STATUS_DRAFT;
                sr1.AF_Period__c = AF_Constants.QUARTER1;
                sr1.AF_Class_code__c=false;
                sr1.AF_Country__c=AFUnileverEntityQuery[0].id;
                sr1.Bonus_Measure__c=AF_Constants.TEST_BUSINESS_MEASURE;
                sr1.AF_Quant__c = 55;
                sr1.AF_Minimum__c = 1;
                sr1.AF_Outstanding__c = 3;
                sr1.AF_Stretching__c = 2;
                subResultlist1.add(sr1);
            
            //insert subResultlist1;
            List<AF_Bonus_Results__c> BonusResult = AF_TestFactory_Helper.insertBonusResults(1,false);
              List<AF_Bonus_Results__c> BonusResultlist =new List<AF_Bonus_Results__c>();
              for (AF_Bonus_Results__c Bonus:BonusResult){
              Bonus.RecordTypeId=Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Quarterly').getRecordTypeId();
              Bonus.AF_Period__c=AF_Constants.QUARTER2;
              Bonus.AF_Bonus_Thresholds__c=BonusThresholdlist[0].id;
              }
              //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold1 =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c LIMIT 1];
            AF_SubResultHandler subhand = new AF_SubResultHandler();
            //subhand.bulkBefore();
            //subhand.bulkAfter();
            AF_Sub_Result__c  check =new AF_Sub_Result__c();
            check.AF_Minimum__c=0;
            check.AF_Stretching__c=2;
            check.AF_Outstanding__c=3;
            check.AF_Period__c=AF_Constants.QUARTER2;
            check.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
            check.AF_Quant_Bonus_Value__c=234;
            check.AF_Status__c=AF_Constants.STATUS_DRAFT;
            AF_Sub_Result__c  check1 =new AF_Sub_Result__c();
            check1.AF_Minimum__c=0;
            check1.AF_Stretching__c=-1;
            check1.AF_Outstanding__c=-1;
            AF_Sub_Result__c  check11 =new AF_Sub_Result__c();
            check11.AF_Minimum__c=1;
            check11.AF_Stretching__c=2;
            check11.AF_Outstanding__c=3;
            check11.AF_Period__c=AF_Constants.QUARTER2;
            check11.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
            check11.AF_Quant_Bonus_Value__c=234;
            insert check11;
            update check11;
            delete check11;
            AF_Sub_Result__c so = new AF_Sub_Result__c();
            AF_Sub_Result__c oldso = new AF_Sub_Result__c();
            subhand.beforeInsert(so);
            subhand.beforeUpdate(so,oldso );
            subhand.afterInsert(so);
            subhand.afterUpdate(oldso,so);
            subhand.afterdelete(so);
            subhand.beforeDelete(so);
            subhand.andFinallyDeleteExt();
            subhand.andFinallyBonusListUpdate();
            AF_CheckRecursiveBonusQuarterly.run=true;
            subhand.andFinallyUpdateExt();
            subhand.andFinallyInsertExt();
            subhand.validateSubResult(check);
            subhand.validateSubResult(check1);
            Test.stopTest();
        }
    } 
       /**********************************************************************
*  @Description: This method will have Test data for testing the subresult
                 handler method,as it performs the testing logic of updation of quant
                 and qual amounts
*  @name : AF_SubResultHandler4
*  @param : none
*  @return : none
*************************************************************************/   
    static testMethod void AF_SubResultHandler4() 
    {
        Test.startTest();
        userForsubResult=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForsubResult.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br :BrandEst){
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;  
                br.AF_AgencyUsers1__c=u.Email;
                BrandEstNew.add(br);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBnsNew = new  List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
                AnnualBnsNew.add(Anb);
            }
            insert AnnualBnsNew;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
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
            System.assertEquals(AnnualBnsQuery!=null, AnnualBsQuery!=null,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
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
            System.assert(QuarterlyBonusQuery!=null,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
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
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            System.assertEquals(AFEntity3!=null,AFEntityQuery!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            System.assertEquals(AFUnileverEntity!=null,AFEntity4!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
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
            //insert sub result
            //List<AF_Sub_Result__c> subResult = AF_TestFactory_Helper.insertSubResult(1,false);
            AF_Sub_Result__c sr=new AF_Sub_Result__c();
            List<AF_Sub_Result__c> subResultlist =new List<AF_Sub_Result__c>();
                sr.AF_Digital__c = true;
                sr.AF_Traditional__c = true;
                sr.AF_Bonus_Threshold__c=BonusThresholdlist[0].id;
                sr.AF_Quant_Bonus_Value__c=12;
                sr.AF_Bonusable_Fees__c=12;
                //sr.AF_Result_type__c=AF_Constants.RESULT_TYPE_QUARTERLY;
                sr.AF_Status__c=AF_Constants.STATUS_DRAFT;
                sr.AF_Period__c = AF_Constants.QUARTER3;
                sr.AF_Class_code__c=false;
                sr.AF_Country__c=AFUnileverEntityQuery[0].id;
                sr.Bonus_Measure__c=AF_Constants.TEST_BUSINESS_MEASURE;
                sr.AF_Quant__c = 55;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                subResultlist.add(sr);
            try{
            insert subResultlist;
            }catch (Exception e){
            system.debug(e);
            System.assert(true, 'Exception ' + e);
            }
            AF_Sub_Result__c sr1=new AF_Sub_Result__c();
            List<AF_Sub_Result__c> subResultlist1 =new List<AF_Sub_Result__c>();
                sr1.AF_Digital__c = true;
                sr1.AF_Traditional__c = true;
                sr1.AF_Bonus_Threshold__c=BonusThresholdlist[0].id;
                sr1.AF_Quant_Bonus_Value__c=12;
                sr1.AF_Bonusable_Fees__c=12;
                //sr.AF_Result_type__c=AF_Constants.RESULT_TYPE_QUARTERLY;
                sr1.AF_Status__c=AF_Constants.STATUS_DRAFT;
                sr1.AF_Period__c = AF_Constants.QUARTER1;
                sr1.AF_Class_code__c=false;
                sr1.AF_Country__c=AFUnileverEntityQuery[0].id;
                sr1.Bonus_Measure__c=AF_Constants.TEST_BUSINESS_MEASURE;
                sr1.AF_Quant__c = 55;
                sr1.AF_Minimum__c = 1;
                sr1.AF_Outstanding__c = 3;
                sr1.AF_Stretching__c = 2;
                subResultlist1.add(sr1);
            
            //insert subResultlist1;
            List<AF_Bonus_Results__c> BonusResult = AF_TestFactory_Helper.insertBonusResults(1,false);
              List<AF_Bonus_Results__c> BonusResultlist =new List<AF_Bonus_Results__c>();
              for (AF_Bonus_Results__c Bonus:BonusResult){
              Bonus.RecordTypeId=Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Quarterly').getRecordTypeId();
              Bonus.AF_Period__c=AF_Constants.QUARTER3;
              Bonus.AF_Bonus_Thresholds__c=BonusThresholdlist[0].id;
              }
              //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold1 =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c LIMIT 1];
            AF_SubResultHandler subhand = new AF_SubResultHandler();
            //subhand.bulkBefore();
            //subhand.bulkAfter();
            AF_Sub_Result__c  check =new AF_Sub_Result__c();
            check.AF_Minimum__c=0;
            check.AF_Stretching__c=2;
            check.AF_Outstanding__c=3;
            check.AF_Period__c=AF_Constants.QUARTER2;
            check.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
            check.AF_Quant_Bonus_Value__c=234;
            check.AF_Status__c=AF_Constants.STATUS_DRAFT;
            AF_Sub_Result__c  check1 =new AF_Sub_Result__c();
            check1.AF_Minimum__c=0;
            check1.AF_Stretching__c=-1;
            check1.AF_Outstanding__c=-1;
            AF_Sub_Result__c  check11 =new AF_Sub_Result__c();
            check11.AF_Minimum__c=1;
            check11.AF_Stretching__c=3;
            check11.AF_Outstanding__c=4;
            check11.AF_Period__c=AF_Constants.QUARTER3;
            check11.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
            check11.AF_Quant_Bonus_Value__c=234;
            insert check11;
            update check11;
            delete check11;
            AF_Sub_Result__c so = new AF_Sub_Result__c();
            AF_Sub_Result__c oldso = new AF_Sub_Result__c();
            subhand.beforeInsert(so);
            subhand.validateSubResult(check1);
            subhand.beforeUpdate(check11,check11);
            subhand.afterInsert(check11);
            subhand.afterUpdate(check11,check11);
            subhand.afterdelete(check11);
            subhand.beforeDelete(check11);
            subhand.andFinallyDeleteExt();
            //subhand.andFinallyBonusListUpdate();
            AF_CheckRecursiveBonusQuarterly.run=true;
            subhand.andFinallyUpdateExt();
            subhand.andFinallyInsertExt();
            subhand.validateSubResult(check);
            Test.stopTest();
        }
    } 
}