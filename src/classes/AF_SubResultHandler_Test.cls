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
    private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
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
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
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
                sr.AF_Traditional__c = false;
                sr.AF_Quant__c = 12;
                sr.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                sr.AF_Status__c=AF_Constants.STATUS_DRAFT;
                sr.AF_Class_code__c=false;
                sr.Bonus_Measure__c ='BM1';
                sr.AF_Period__c=AF_Constants.QUARTER1;
                subResultlist.add(sr);
            }
            try{
            insert subResultlist;
            update subResultlist;
            }catch(Exception e){
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'AF_SubResultHandler',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            }
            AF_Sub_Result__c sub =new AF_Sub_Result__c();
            //insert sub result
            List<AF_Sub_Result__c> subResults1 = AF_TestFactory_Helper.insertSubResult1(1,false);
            List<AF_Sub_Result__c> subResultlist1= new  List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sr1 : subResults1 )
            {
                sr1.Sub_Result_AnnualID__c=sub.id;  
                sr1.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
                sr1.AF_Status__c=AF_Constants.STATUS_DRAFT;
                subResultlist1.add(sr1);
            }
            insert subResultlist1;
            List<AF_Sub_Result__c> subResultsQuery = [SELECT ID,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResults LIMIT 1];
            try{
                delete subResultlist;
            }
            catch(Exception e){
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'AF_SubResultHandler',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            }
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,true);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            AF_SubResultHandler subhand = new AF_SubResultHandler();
            subhand.bulkBefore();
            AF_Sub_Result__c so = new AF_Sub_Result__c();
            AF_Sub_Result__c oldso = new AF_Sub_Result__c();
            subhand.beforeInsert(so);
            subhand.beforeUpdate(so,oldso );
            subhand.afterInsert(so);
            subhand.afterUpdate(oldso,so);
            subhand.afterdelete(so);
            subhand.beforeDelete(so);
            Test.stopTest();
        }
    } /**********************************************************************
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
            //insert unilever Entity.
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFEntity4 = AF_TestFactory_Helper.insertEntity4(1,true);
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
                sr.AF_Traditional__c = false;
                sr.AF_Quant__c = 12;
                sr.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
                sr.AF_Minimum__c = 1;
                sr.AF_Outstanding__c = 3;
                sr.AF_Stretching__c = 2;
                sr.AF_Status__c=AF_Constants.STATUS_DRAFT;
                sr.AF_Class_code__c=false;
                sr.Bonus_Measure__c ='BM1';
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
                sr1.AF_Outstanding__c = 7;
                sr1.AF_Stretching__c = 6;
                sr1.Bonus_Measure__c = 'BM1';
                sr1.AF_Quant_Bonus_Value__c = 156;
                sr1.AF_Total_Bonus_Value__c = 3800;
                sr1.AF_Bonusable_Fees__c = 35;
                sr1.AF_Status__c=AF_Constants.STATUS_DRAFT;
                sr1.Sub_Result_AnnualID__c=subResultlist[0].id;
                sr1.AF_Bonus_Threshold__c=BonusThresholdQuery[0].id;
                subResultlist1.add(sr1);
            }
            insert subResultlist1;
            List<AF_Sub_Result__c> subResultsQuery = [SELECT ID,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subResults LIMIT 1];
            System.assertEquals(subResultsQuery[0].AF_Bonus_Threshold__c ,BonusThresholdQuery[0].id, AF_TestFactory_Helper.SUBRESULT_RECORD);
            try{
                delete subResultlist;
            }
            catch(Exception e){
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'AF_SubResultHandler1',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            }
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResultsquarterly(1,false);
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
            update BonusResultListNew;
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE_QUARTERLY LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            AF_SubResultHandler subhand = new AF_SubResultHandler();
            subhand.bulkBefore();
            AF_Sub_Result__c so = new AF_Sub_Result__c();
            AF_Sub_Result__c oldso = new AF_Sub_Result__c();
            subhand.beforeInsert(so);
            subhand.beforeUpdate(so,oldso);
            subhand.afterInsert(subResultlist[0]);
            subhand.afterUpdate(subResultlist1[0],subResultlist[0]);
            subhand.afterdelete(so);
            subhand.beforeDelete(so);
            Test.stopTest();
        }
    }
}