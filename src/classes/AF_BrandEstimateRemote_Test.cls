/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimateRemote_Test
@CreateDate : 13/9/2014
@Description : This is a Test class for AF_BrandEstimateRemote class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_BrandEstimateRemote_Test 
{ 
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user userForBrandEstremote;
    private final static string ANNAUL_BONUS='The AnnualBonus records are inserted';
    private static final string bonus_Result='AF_Bonus_Results__c';
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : brandEstimateRemote
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void brandEstimateRemote ()
    {
        Test.startTest();
        userForBrandEstremote=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForBrandEstremote.id LIMIT 1];
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
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;  
                br.AF_Pilot_Model__c=false;
                br.AF_Active__c=true;
                br.AF_AgencyUsers1__c=u.Email;
                br.AF_Fiscal_Year__c=currYear;
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
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            Set<String> agencyNames=new Set<string>();
            agencyNames.add(AFEntity[0].Name);
            List<String> cols=new List<String>();
            cols.add(AFEntity[0].Name);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity1 = AF_TestFactory_Helper.insertUnileverEntityListRec(1,false);
            List<AF_Entity__c> AFUnileverEntitylist=new List<AF_Entity__c>();
            for(AF_Entity__c entity:AFUnileverEntity1){
                entity.AF_Country__c=AF_Constants.TEST_CURRENCY_COUNTRY;
                AFUnileverEntitylist.add(entity);
            }
            insert AFUnileverEntitylist;
            List<AF_Entity__c> AFUnileverEntityQuery1 = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntitylist LIMIT 1];
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<String> rows=new List<String>();
            rows.add(AFUnileverEntity[0].Name);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmate1=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_READYFORPO;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                agency.AF_Fiscal_Year__c=currYear;
                AgencyEsitmate1.add(agency);
            }
            insert AgencyEsitmate1;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBnsList =new  List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
                AnnualBnsList.add(Anb);
            }
            insert AnnualBnsList;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
            System.Assert(AnnualBnsQuery[0].Id != null, ANNAUL_BONUS);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdLst = new  List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bonThres : BonusThreshold){
                bonThres.AF_Traditional__c=true;
                bonThres.AF_Digital__c=true;
                bonThres.Year__c=currYear ;
                bonThres.AF_Minimum__c=10;
                bonThres.AF_Stretching__c=15;
                bonThres.AF_Outstanding__c=20;
                BonusThresholdLst.add(bonThres);
            }
            insert BonusThresholdLst;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,true);
            list<string> brandlist=new list<string>();
            brandlist.add(AFUnileverEntitylist[0].AF_Country__c);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE AND ID IN:BonusResultList LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            AF_BrandEstimateRemote.addUnileverEntityToEstimates(AFBonusSummary[0].id,AF_Constants.SOBJECT_BONUS_SUMMARY_APINAME,cols,acc[0].Id);
            AF_BrandEstimateRemote.addSingleULAGEntity(AFBonusSummary[0].Id,AF_Constants.SOBJECT_BONUS_SUMMARY_APINAME, AFUnileverEntity[0].Name, AFEntity[0].Name, acc[0].Id);
            AF_BrandEstimateRemote.archiveAgencyEntityToEstimates(BrandEstlist[0].Id,AF_Constants.SOBJECT_BRANDESTIMATE_APINAME,AFUnileverEntity[0].Name);
            AF_BrandEstimateRemote.archiveAgencyEntityToEstimates(OopsactualList[0].id,AF_Constants.SOBJECT_OOPSACTUAL_APINAME,AFUnileverEntity[0].Name);
            AF_BrandEstimateRemote.archiveUnileverEntityToEstimates(AFBonusSummary[0].Id,AF_Constants.SOBJECT_BONUS_SUMMARY_APINAME,AFEntity[0].Name,acc[0].Id);
            AF_BrandEstimateRemote.buildOopsEstimate(AFEntity[0].id,AFUnileverEntity[0].id,OopsactualList[0].id);
            AF_BrandEstimateRemote.archiveOopsEstimatesPerUnileverEntity(AFUnileverEntity[0].Name,OopsactualList[0].id);
            AF_BrandEstimateRemote.archiveBonusMatrixPerUnileverEntity(AFUnileverEntity[0].Name,AFBonusSummary[0].Id);
            AF_BrandEstimateRemote.archiveAgencyEstimatesPerAgencyEntity(AFUnileverEntity[0].Name,BrandEstlist[0].Id);
            AF_BrandEstimateRemote.archiveOopsEstimatesPerAgencyEntity(AFUnileverEntity[0].Name,OopsactualList[0].id);
            AF_BrandEstimateRemote.getOopsEstimates(OopsactualList[0].id);
            AF_BrandEstimateRemote.getBonusMatrices(AFBonusSummary[0].Id);
            AF_BrandEstimateRemote.getAgencyEntities(acc[0].Id,OopsactualList[0].id,AF_Constants.SOBJECT_OOPSACTUAL_APINAME);
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : brandEstimateRemote1
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void brandEstimateRemote1()
    {
        Test.startTest();
        userForBrandEstremote=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForBrandEstremote.id LIMIT 1];
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
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;
                br.AF_Agency__c= acc[0].id;
                br.Brand__c= brandQuery[0].id;  
                br.AF_Fiscal_Year__c=currYear;
                br.AF_Active__c=true;
                br.AF_Pilot_Model__c=true;
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
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            Set<String> agencyNames=new Set<string>();
            agencyNames.add(AFEntity[0].Name);
            List<String> cols=new List<String>();
            cols.add(AFEntity[0].Name);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity1 = AF_TestFactory_Helper.insertUnileverEntityListRec(1,false);
            List<AF_Entity__c> AFUnileverEntitylist=new List<AF_Entity__c>();
            for(AF_Entity__c entity:AFUnileverEntity1){
                entity.AF_Country__c=AF_Constants.TEST_CURRENCY_COUNTRY;
                AFUnileverEntitylist.add(entity);
            }
            insert AFUnileverEntitylist;
            List<AF_Entity__c> AFUnileverEntityQuery1 = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntitylist LIMIT 1];
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<String> rows=new List<String>();
            rows.add(AFUnileverEntity[0].Name);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmate1=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_READYFORPO;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                agency.AF_Fiscal_Year__c=currYear;
                AgencyEsitmate1.add(agency);
            }
            insert AgencyEsitmate1;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBnsList =new  List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
                AnnualBnsList.add(Anb);
            }
            insert AnnualBnsList;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
            System.Assert(AnnualBnsQuery[0].Id != null, ANNAUL_BONUS);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdLst = new  List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bonThres : BonusThreshold){
                bonThres.AF_Traditional__c=true;
                bonThres.AF_Digital__c=true;
                bonThres.Year__c=currYear ;
                bonThres.AF_Minimum__c=10;
                bonThres.AF_Stretching__c=15;
                bonThres.AF_Outstanding__c=20;
                BonusThresholdLst.add(bonThres);
            }
            insert BonusThresholdLst;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,true);
            list<string> brandlist=new list<string>();
            brandlist.add(AFUnileverEntitylist[0].AF_Country__c);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE AND ID IN:BonusResultList LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            AF_BrandEstimateRemote.getAgencyEstimateRecords(acc[0].Id,BrandEstlist[0].Id);
            AF_BrandEstimateRemote.addAgencyEntityToEstimates(BrandEstlist[0].Id,AF_Constants.SOBJECT_BRANDESTIMATE_APINAME,rows,acc[0].Id);
            AF_BrandEstimateRemote.addAgencyEntityToEstimates(OopsactualList[0].id,AF_Constants.SOBJECT_OOPSACTUAL_APINAME,rows,acc[0].Id);
            AF_BrandEstimateRemote.addUnileverEntityToEstimates(OopsactualList[0].id,AF_Constants.SOBJECT_OOPSACTUAL_APINAME,cols,acc[0].Id);
            AF_BrandEstimateRemote.addUnileverEntityToEstimates(AFBonusSummary[0].Id,AF_Constants.SOBJECT_BONUS_SUMMARY_APINAME,cols,acc[0].Id); 
            AF_BrandEstimateRemote.addSingleULAGEntity(BrandEstlist[0].Id,AF_Constants.SOBJECT_BRANDESTIMATE_APINAME, AFUnileverEntity[0].Name, AFEntity[0].Name, acc[0].Id);
            AF_BrandEstimateRemote.archiveAgencyEntityToEstimates(BrandEstlist[0].Id,AF_Constants.SOBJECT_BRANDESTIMATE_APINAME,AFUnileverEntity[0].Name);
            AF_BrandEstimateRemote.archiveAgencyEntityToEstimates(AFBonusSummary[0].Id,AF_Constants.SOBJECT_BONUS_SUMMARY_APINAME,AFUnileverEntity[0].Name);
            AF_BrandEstimateRemote.archiveUnileverEntityToEstimates(BrandEstlist[0].Id,AF_Constants.SOBJECT_BRANDESTIMATE_APINAME,AFEntity[0].Name,acc[0].Id);
            AF_BrandEstimateRemote.buildOopsEstimate(AFEntity[0].id,AFUnileverEntity[0].id,OopsactualList[0].id);
            AF_BrandEstimateRemote.getUnileverEntities(OopsactualList[0].id,AF_Constants.SOBJECT_OOPSACTUAL_APINAME);
            AF_BrandEstimateRemote.getUnileverEntities(AFBonusSummary[0].id,AF_Constants.SOBJECT_BONUS_SUMMARY_APINAME);
            AF_BrandEstimateRemote.getULOopsEstimates(OopsactualList[0].id);
            AF_BrandEstimateRemote.getULBonusEstimates(AFBonusSummary[0].Id);
        }
    }
        /***********************************************************************************
*  @Description: this method will the test data
*  @name : brandEstimateRemote3
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void brandEstimateRemote3()
    {
        Test.startTest();
        userForBrandEstremote=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForBrandEstremote.id LIMIT 1];
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
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;  
                br.AF_Pilot_Model__c=false;
                br.AF_Active__c=true;
                br.AF_AgencyUsers1__c=u.Email;
                br.AF_Fiscal_Year__c=currYear;
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
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            Set<String> agencyNames=new Set<string>();
            agencyNames.add(AFEntity[0].Name);
            List<String> cols=new List<String>();
            cols.add(AFEntity[0].Name);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity1 = AF_TestFactory_Helper.insertUnileverEntityListRec(1,false);
            List<AF_Entity__c> AFUnileverEntitylist=new List<AF_Entity__c>();
            for(AF_Entity__c entity:AFUnileverEntity1){
                entity.AF_Country__c=AF_Constants.TEST_CURRENCY_COUNTRY;
                AFUnileverEntitylist.add(entity);
            }
            insert AFUnileverEntitylist;
            List<AF_Entity__c> AFUnileverEntityQuery1 = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntitylist LIMIT 1];
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<String> rows=new List<String>();
            rows.add(AFUnileverEntity[0].Name);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmate1=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_READYFORPO;
                //agency.AF_Total__c=66;
                //agency.AF_Adaptation__c=22;
                //agency.AF_Digital__c=22;
                //agency.AF_Traditional__c=22;
                agency.AF_Fiscal_Year__c=currYear;
                AgencyEsitmate1.add(agency);
            }
            insert AgencyEsitmate1;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Annual Bonus.
            List<AF_AnnualBonus_Qual__c> AnnualBns = AF_TestFactory_Helper.insertAnnualBonusQual(1,false);
            List<AF_AnnualBonus_Qual__c> AnnualBnsList =new  List<AF_AnnualBonus_Qual__c>();
            for(AF_AnnualBonus_Qual__c  Anb : AnnualBns){
                Anb.X5__c = 15;
                AnnualBnsList.add(Anb);
            }
            insert AnnualBnsList;
            List<AF_AnnualBonus_Qual__c> AnnualBnsQuery = [SELECT ID FROM AF_AnnualBonus_Qual__c Limit 1];
            System.Assert(AnnualBnsQuery[0].Id != null, ANNAUL_BONUS);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdLst = new  List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bonThres : BonusThreshold){
                bonThres.AF_Traditional__c=true;
                bonThres.AF_Digital__c=true;
                bonThres.Year__c=currYear ;
                bonThres.AF_Minimum__c=10;
                bonThres.AF_Stretching__c=15;
                bonThres.AF_Outstanding__c=20;
                BonusThresholdLst.add(bonThres);
            }
            insert BonusThresholdLst;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,true);
            list<string> brandlist=new list<string>();
            brandlist.add(AFUnileverEntitylist[0].AF_Country__c);
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE AND ID IN:BonusResultList LIMIT 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            AF_BrandEstimateRemote.getAgencyEstimateRecords(acc[0].Id,BrandEstlist[0].Id);
            AF_BrandEstimateRemote.getAgencyEntitiesFromName(agencyNames,acc[0].id);
            AF_BrandEstimateRemote.getAgencyEntitiesFromName(agencyNames,OopsactualList[0].id);
            AF_BrandEstimateRemote.addAgencyEntityToEstimates(BrandEstlist[0].Id,AF_Constants.SOBJECT_BRANDESTIMATE_APINAME,rows,acc[0].Id);
            AF_BrandEstimateRemote.addAgencyEntityToEstimates(AFBonusSummary[0].Id,AF_Constants.SOBJECT_BONUS_SUMMARY_APINAME,rows,acc[0].Id);
            AF_BrandEstimateRemote.addUnileverEntityToEstimates(BrandEstlist[0].Id,AF_Constants.SOBJECT_BRANDESTIMATE_APINAME,cols,acc[0].Id);
            AF_BrandEstimateRemote.addUnileverEntityToEstimates(BonusResultList[0].Id,bonus_Result,cols,acc[0].Id); 
            AF_BrandEstimateRemote.addSingleULAGEntity(BrandEstlist[0].Id,AF_Constants.SOBJECT_BRANDESTIMATE_APINAME, AFUnileverEntity[0].Name, AFEntity[0].Name, acc[0].Id);
            AF_BrandEstimateRemote.archiveAgencyEntityToEstimates(BrandEstlist[0].Id,AF_Constants.SOBJECT_BRANDESTIMATE_APINAME,AFUnileverEntity[0].Name);
            AF_BrandEstimateRemote.archiveAgencyEntityToEstimates(OopsactualList[0].id,AF_Constants.SOBJECT_OOPSACTUAL_APINAME,AFUnileverEntity[0].Name);
            AF_BrandEstimateRemote.archiveUnileverEntityToEstimates(OopsactualList[0].Id,AF_Constants.SOBJECT_OOPSACTUAL_APINAME,AFEntity[0].Name,acc[0].Id);
            AF_BrandEstimateRemote.buildOopsEstimate(AFEntity[0].id,AFUnileverEntity[0].id,OopsactualList[0].id);
            AF_BrandEstimateRemote.archiveOopsEstimatesPerUnileverEntity(AFUnileverEntity[0].Name,OopsactualList[0].id);
        }
    }
}