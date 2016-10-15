/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_AgencyHomePageController_Test
@CreateDate : 20/9/2014
@Description : This is a Test class for AF_AgencyHomePageController class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_AgencyHomePageController_Test
{  
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year()-1;
    Static string currYear1=string.valueof(IcurrYear1);
    Static Integer IcurrYear2 = System.Today().year()-2;
    Static string currYear2=string.valueof(IcurrYear2);
    Private static final string category=AF_Constants.CATEGORY;
    Private static final string year=AF_Constants.YEAR;
    Private static final string brandvalue='brandvalue';
    Private static final string mybrand=AF_Constants.MY_BRANDS;
    Private static final string allbrands=AF_Constants.ALL_BRANDS;
    Private static user AgencyHomePage;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : agencyHomPgController
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AFagencyHomPgController()
    {
        Test.startTest();
        AgencyHomePage = AF_TestFactory_Helper.createUserADMINSTRATOR(true);
        User u=[SELECT id,Email FROM user WHERE id=:AgencyHomePage.id LIMIT 1];
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
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
            List<AF_Category_Brand__c> AFCategoryBrandlist=new List<AF_Category_Brand__c>();
            for(AF_Category_Brand__c cat:AFCategoryBrand){
                cat.Name=AF_Constants.TEST_BRANDNAME;
                AFCategoryBrandlist.add(cat);
            }
            insert AFCategoryBrandlist;
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD );
            //insert brandestimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c  loopBrandEst : BrandEst)
            {
                loopbrandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;  
                loopbrandEst.AF_Fiscal_Year__c=currYear1;
                loopbrandEst.AF_Active__c = true;
                loopbrandEst.AF_Copied__c= false;
                loopbrandEst.AF_Locked__c = false; 
                loopbrandEst.Brand__c=AFCategoryBrandlist[0].id;
                loopbrandEst.AF_Agency__c=acctQuery[0].ID;
                BrandEstNew.add(loopBrandEst);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            // insert currency.
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //insert custom setting
            List<AF_isBonusLinkForAgency__c> AFBONUS= AF_TestFactory_Helper.insertBonusLinkforAgency(1,true);
            List<AF_isBonusLinkForAgency__c> AFBONUSQUERY= [SELECT Id FROM AF_isBonusLinkForAgency__c LIMIT 1];
            System.Assert(AFBONUSQUERY[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert agency estimate
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateNew = new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Adaptation_Local__c=23;
                agency.AF_Brand_Estimate__c=BrandEstNew[0].id;
                agency.AF_Agency_Entity__c=AFEntityQuery[0].id;
                agency.AF_Unilever_Entity__c=AFUnileverEntityQuery[0].id;
                agency.AF_Archived__c=false;
                agency.AF_Fiscal_Year__c=currYear1;
                agency.AF_Adaptation__c=23;
                agency.AF_Digital__c=23;
                agency.AF_Digital_Local__c=12;
                agency.AF_Agency_Exchange_Rate__c=21;
                agency.AF_Traditional__c=23;
                agency.AF_Traditional_Local__c=23;  
                agency.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
                AgencyEsitmateNew.add(agency);
            }
            insert AgencyEsitmateNew;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,false);
            List<AF_Bonus_Results__c> BonusResultList1 = new List<AF_Bonus_Results__c>();
            for(AF_Bonus_Results__c bonus:BonusResultList){
                bonus.AF_Period__c=AF_Constants.QUARTER1;
                bonus.AF_Status__c =AF_Constants.STATUS_SUBMITTED;
                BonusResultList1.add(bonus);
            }
            insert BonusResultList1 ;
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE ID IN : BonusResultList limit 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
            List<AF_OOPS_Actual__c> OopsactualList1 =new List<AF_OOPS_Actual__c> ();
            for(AF_OOPS_Actual__c oops:OopsactualList ){
                oops.AF_Agency_lk__c=acctQuery[0].id;
                oops.AF_BrandEstimateId__c=BrandEstNew[0].id;
                oops.AF_Brand__c=AFCategoryBrandlist[0].id;
                oops.AF_Agency__c=acctQuery[0].id;
                oops.AF_Fiscal_Year__c=currYear1;
                OopsactualList1.add(oops);
            }
            insert OopsactualList1;
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Instantiate AF_OOPS_SelectionController  Class
            ApexPages.currentPage().getParameters().put(category,cb[0].Name+'::'+cb[0].Id);
            ApexPages.currentPage().getParameters().put(year,currYear1);
            ApexPages.currentPage().getParameters().put(brandvalue,mybrand);
            AF_AgencyHomePageController agenHome=new AF_AgencyHomePageController();
            agenHome.getfinancialYearOption();
            agenHome.getCategoryOption();
            agenHome.getbrandEstimateDetailList();
            agenHome.getAgencyEstimateDetailList();
            agenHome.redirectToReportPage();
            agenHome.changeCatName();
            agenHome.changeBrand();
            agenHome.emailtocatfinance();
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : agencyHomPgController1
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AFagencyHomPgController1()
    {
        Test.startTest();
        AgencyHomePage = AF_TestFactory_Helper.createUser(true);
        User u=[SELECT id,Email FROM user WHERE id=:AgencyHomePage.id LIMIT 1];
        PermissionSet perSet = [SELECT Id,Name FROM PermissionSet WHERE Name = 'AF_Category_Finance' Limit 1];
        PermissionSetAssignment perSetAssign=new PermissionSetAssignment();
        perSetAssign.PermissionSetId = perSet.Id; 
        perSetAssign.AssigneeId=u.id;
        Insert perSetAssign;
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accNew = new List<Account>();
            for(Account loopacc : acc){
                loopacc.published__c = true;
                accNew.add(loopacc);
            }
            insert accNew;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,false);
            List<AF_Category_Brand__c> AFCategoryBrandlist=new List<AF_Category_Brand__c> ();
            for(AF_Category_Brand__c Brand:cb ){
                Brand.Name=AF_Constants.TEST_CATEGORYNAME;
                AFCategoryBrandlist.add(Brand); 
            }
            insert AFCategoryBrandlist;
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD );
            //insert custom setting
            List<AF_isBonusLinkForAgency__c> AFBONUS= AF_TestFactory_Helper.insertBonusLinkforAgency(1,false);
            List<AF_isBonusLinkForAgency__c> AFBONUSlist=new List<AF_isBonusLinkForAgency__c>();
            for(AF_isBonusLinkForAgency__c Agency:AFBONUS){
                Agency.Name=AF_Constants.ANNUAL_BONUS_REC_TYPE;
                Agency.Bonus_Date__c=Date.Today();
                AFBONUSlist.add(Agency);
            }
            insert AFBONUSlist;
            List<AF_isBonusLinkForAgency__c> AFBONUSQUERY= [SELECT Id FROM AF_isBonusLinkForAgency__c LIMIT 1];
            System.Assert(AFBONUSQUERY[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert brandestimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c  loopBrandEst : BrandEst)
            {
                loopbrandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;  
                loopbrandEst.AF_Fiscal_Year__c=currYear1;
                loopbrandEst.AF_Active__c = true;
                loopbrandEst.AF_Copied__c= false;
                loopbrandEst.AF_Locked__c = false; 
                loopbrandEst.Agency_Base_Fee__c=20;
                loopbrandEst.AF_No_CrossBorders__c=22;
                loopbrandEst.AF_AgencyUsers1__c=u.Email;
                loopbrandEst.AF_BackupQuarter__c = 'Q1;Q2;Q3';
                BrandEstNew.add(loopBrandEst);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            // insert currency.
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateList = new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
                agency.AF_Traditional__c=0;
                agency.AF_Digital__c=0;
                agency.AF_Adaptation__c=0;
                agency.AF_Fiscal_Year__c=currYear1;
                AgencyEsitmateList.add(agency);
            }
            insert AgencyEsitmateList;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,false);
            RecordType brRT = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Quarterly' Limit 1];
            List<AF_Bonus_Results__c> BonusResultList1 = new List<AF_Bonus_Results__c>();
            for(AF_Bonus_Results__c bonus:BonusResultList){
                bonus.RecordTypeid=brRT.id;
                bonus.AF_Bonus_Thresholds__c=BonusThresholdQuery[0].ID;
                bonus.AF_Period__c=AF_Constants.QUARTER2;
                bonus.AF_Status__c = AF_Constants.STATUS_DRAFT;
                BonusResultList1.add(bonus);
            }
            insert BonusResultList1 ;
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE ID IN : BonusResultList limit 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Instantiate AF_OOPS_SelectionController  Class
            ApexPages.currentPage().getParameters().put(category,cb[0].Name+'::'+cb[0].Id);
            ApexPages.currentPage().getParameters().put(year,currYear1);
            ApexPages.currentPage().getParameters().put(brandvalue,allbrands);
            AF_AgencyHomePageController agenHome=new AF_AgencyHomePageController();
            agenHome.getfinancialYearOption();
            agenHome.getCategoryOption();
            agenHome.getbrandEstimateDetailList();
            agenHome.getAgencyEstimateDetailList();
            agenHome.redirectToReportPage();
            agenHome.changeCatName();
            agenHome.changeBrand();
            agenHome.emailtocatfinance();
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AFagencyHomPgController2
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AFagencyHomPgController2()
    {
        Test.startTest();
        AgencyHomePage = AF_TestFactory_Helper.createUser(true);
        User u=[SELECT id,Email FROM user WHERE id=:AgencyHomePage.id LIMIT 1];
        PermissionSet perSet = [SELECT Id,Name FROM PermissionSet WHERE Name ='AF_Controllers' Limit 1];
        PermissionSetAssignment perSetAssign=new PermissionSetAssignment();
        perSetAssign.PermissionSetId = perSet.Id; 
        perSetAssign.AssigneeId=u.id;
        Insert perSetAssign;
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accNew = new List<Account>();
            for(Account loopacc : acc){
                loopacc.published__c = true;
                accNew.add(loopacc);
            }
            insert accNew;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD );
            // insert brandestimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c  loopBrandEst : BrandEst)
            {
                loopbrandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;
                loopbrandEst.AF_Fiscal_Year__c= currYear2;
                loopbrandEst.AF_Active__c=true;
                loopbrandEst.Brand__c=brandQuery[0].id;
                loopbrandEst.AF_Agency__c=accNew[0].id;
                loopbrandEst.AF_Fiscal_Year__c=currYear1;
                BrandEstNew.add(loopBrandEst);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            // insert currency.
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateNew = new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
                agency.AF_Fiscal_Year__c=currYear1;
                AgencyEsitmateNew.add(agency);
            }
            insert AgencyEsitmateNew;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
            List<AF_OOPS_Actual__c> OopsactualList1 =new List<AF_OOPS_Actual__c> ();
            for(AF_OOPS_Actual__c oops:OopsactualList ){
                oops.AF_Agency_lk__c=accNew[0].id;
                oops.AF_BrandEstimateId__c=BrandEstNew[0].id;
                oops.AF_Brand__c=brandQuery[0].id;
                oops.AF_Agency__c=accNew[0].id;
                oops.AF_Fiscal_Year__c=currYear1;
                OopsactualList1.add(oops);
            }
            insert OopsactualList1;
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Instantiate AF_OOPS_SelectionController  Class
            ApexPages.currentPage().getParameters().put(category,cb[0].Name+'::'+cb[0].Id);
            ApexPages.currentPage().getParameters().put(year,currYear);
            ApexPages.currentPage().getParameters().put(brandvalue,mybrand);
            AF_AgencyHomePageController agenHome=new AF_AgencyHomePageController();
            agenHome.getfinancialYearOption();
            agenHome.getCategoryOption();
            agenHome.getbrandEstimateDetailList();
            agenHome.getAgencyEstimateDetailList();
            agenHome.redirectToReportPage();
            agenHome.changeCatName();
            agenHome.changeBrand();
            agenHome.emailtocatfinance();
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AFagencyHomPgController3
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AFagencyHomPgController3()
    {
        Test.startTest();
        AgencyHomePage = AF_TestFactory_Helper.createAgency(true);
        User u=[SELECT id,Email FROM user WHERE id=:AgencyHomePage.id LIMIT 1];
        PermissionSet perSet = [SELECT Id,Name FROM PermissionSet WHERE Name = 'AF_Procurement'  Limit 1];
        PermissionSetAssignment perSetAssign=new PermissionSetAssignment();
        perSetAssign.PermissionSetId = perSet.Id; 
        perSetAssign.AssigneeId=u.id;
        Insert perSetAssign;
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accNew = new List<Account>();
            for(Account loopacc : acc){
                loopacc.published__c = true;
                accNew.add(loopacc);
            }
            insert accNew;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD );
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c  loopBrandEst : BrandEst)
            {
                loopbrandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE; 
                BrandEstNew.add(loopBrandEst);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            // insert currency.
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateNew = new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
                agency.AF_Fiscal_Year__c=currYear1;
                AgencyEsitmateNew.add(agency);
            }
            insert AgencyEsitmateNew;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results.
            List<AF_Bonus_Results__c> BonusResultList = AF_TestFactory_Helper.insertBonusResults(1,false);
            List<AF_Bonus_Results__c> BonusResultList1 = new List<AF_Bonus_Results__c>();
            for(AF_Bonus_Results__c bonus:BonusResultList){
                bonus.AF_Period__c=AF_Constants.QUARTER2;
                bonus.AF_Status__c =AF_Constants.STATUS_DRAFT;
                BonusResultList1.add(bonus);
            }
            insert BonusResultList1 ;
            List<AF_Bonus_Results__c> BonusResultQuery = [SELECT ID,AF_Bonus_Thresholds__c FROM AF_Bonus_Results__c WHERE ID IN : BonusResultList limit 1];
            System.assertEquals(BonusResultQuery[0].AF_Bonus_Thresholds__c,BonusThreshold[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //Instantiate AF_OOPS_SelectionController  Class
            ApexPages.currentPage().getParameters().put(category,cb[0].Name+'::'+cb[0].Id);
            ApexPages.currentPage().getParameters().put(year,currYear);
            ApexPages.currentPage().getParameters().put(brandvalue,allbrands);
            AF_AgencyHomePageController agenHome=new AF_AgencyHomePageController();
            agenHome.getfinancialYearOption();
            agenHome.getCategoryOption();
            agenHome.getbrandEstimateDetailList();
            agenHome.getAgencyEstimateDetailList();
            agenHome.redirectToReportPage();
            agenHome.changeCatName();
            agenHome.changeBrand();
            agenHome.emailtocatfinance();
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AFagencyHomPgController4
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AFagencyHomPgController4()
    {
        Test.startTest();
        AgencyHomePage = AF_TestFactory_Helper.createUserAdmin2(true);
        User u=[SELECT id,Email FROM user WHERE id=:AgencyHomePage.id LIMIT 1];
        PermissionSet perSet = [SELECT Id,Name FROM PermissionSet WHERE Name = 'AF_Category_Finance_Regional' Limit 1];
        PermissionSetAssignment perSetAssign=new PermissionSetAssignment();
        perSetAssign.PermissionSetId = perSet.Id; 
        perSetAssign.AssigneeId=u.id;
        Insert perSetAssign;
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accNew = new List<Account>();
            for(Account loopacc : acc){
                loopacc.published__c = true;
                accNew.add(loopacc);
            }
            insert accNew;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD );
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c  loopBrandEst : BrandEst)
            {
                loopbrandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE; 
                BrandEstNew.add(loopBrandEst);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            // insert currency.
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateNew = new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
                agency.AF_Traditional__c=0;
                agency.AF_Digital__c=0;
                agency.AF_Adaptation__c=0;
                agency.AF_Archived__c=false;
                agency.AF_Fiscal_Year__c=currYear;
                AgencyEsitmateNew.add(agency);
            }
            insert AgencyEsitmateNew;
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
            //Instantiate AF_OOPS_SelectionController  Class
            ApexPages.currentPage().getParameters().put(category,cb[0].Name+'::'+cb[0].Id);
            ApexPages.currentPage().getParameters().put(year,currYear);
            ApexPages.currentPage().getParameters().put(brandvalue,allbrands);
            AF_AgencyHomePageController agenHome=new AF_AgencyHomePageController();
            agenHome.getfinancialYearOption();
            agenHome.getCategoryOption();
            agenHome.getbrandEstimateDetailList();
            agenHome.getAgencyEstimateDetailList();
            agenHome.redirectToReportPage();
            agenHome.changeCatName();
            agenHome.changeBrand();
            agenHome.emailtocatfinance();
            Test.stopTest();
        }
    }     
}