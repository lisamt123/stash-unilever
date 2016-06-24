/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_AgencyEstimateController_Test
@CreateDate : 22/9/2014
@Description : This is a Test class for AF_AgencyEstimateController class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_AgencyEstimateController_Test
{ 
    Private static user AgencyEstimateController;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : agencyEstimateController
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AFagencyEstimateController()
    {
        Test.startTest();
        AgencyEstimateController = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:AgencyEstimateController.id LIMIT 1];
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
            System.Assert(acctQuery[0].Id != null,AF_TestFactory_Helper.ACCOUNT_RECORD);
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
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            list<AF_Brand_Estimate__c> Brandestimatelist= new list<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c  Brand:BrandEst){
                Brand.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                Brandestimatelist.add(Brand);
            }
            insert Brandestimatelist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null,AF_TestFactory_Helper.CURRENCY_RECORD );
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            System.Assert(AFUnileverEntity[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateNew = new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Adaptation_Local__c=23;
                agency.AF_Adaptation__c=324;
                agency.AF_Digital__c=12;
                agency.AF_Digital_Local__c=12;
                agency.AF_Agency_Exchange_Rate__c=21;
                agency.AF_Traditional__c=46;
                agency.AF_Traditional_Local__c=23;  
                AgencyEsitmateNew.add(agency);
            }
            insert AgencyEsitmateNew;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            List<AF_Entity_Exception__c> EntityExcepList = AF_TestFactory_Helper.InsertEntityException(1,true);
            List<AF_Entity_Exception__c> EntityExcepQuery = [SELECT ID,AF_Agency_Estimate__c FROM AF_Entity_Exception__c WHERE ID IN : EntityExcepList LIMIT 1];
            System.assertEquals(EntityExcepQuery[0].AF_Agency_Estimate__c,AgencyEsitmate[0].id,'EntityException is inserted');
            ApexPages.currentPage().getParameters().put('id',AgencyEsitmate[0].id);
            ApexPages.currentPage().getParameters().put('aid',AFEntity[0].id);
            ApexPages.currentPage().getParameters().put('bid',brandEst[0].id);
            ApexPages.currentPage().getParameters().put('uid',AFUnileverEntity[0].id);
            AF_AgencyEstimateController agenEstCtrl=new AF_AgencyEstimateController();
            agenEstCtrl.ExceptionId=EntityExcepList[0].Id;
            agenEstCtrl.getDisplayEntityException();
            agenEstCtrl.clearErrorMsg();
            agenEstCtrl.getupdatedC_breakdown();
            agenEstCtrl.getUnileverEntities();
            agenEstCtrl.UpdatPO();  
            agenEstCtrl.Save();
            agenEstCtrl.JustSave();
            agenEstCtrl.SaveEntityException();
            agenEstCtrl.SaveEntityExceptionRecords();
            agenEstCtrl.Reload();
            agenEstCtrl.confirmBox();
            agenEstCtrl.OverridePO();
            agenEstCtrl.AddComment();
            agenEstCtrl.AddNewRow();
            agenEstCtrl.UpdateDisplayTotal();
            agenEstCtrl.NowInEditMode();
            agenEstCtrl.delCountryId=EntityExcepList[0].Id;
            agenEstCtrl.delCounrtyRecord();
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AFagencyEstimateController1
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AFagencyEstimateController1()
    {
        Test.startTest();
        AgencyEstimateController = AF_TestFactory_Helper.createUserAdmin2(true);
        User u=[SELECT id FROM user WHERE id=:AgencyEstimateController.id LIMIT 1];
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
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> Brandesitmatelist=new list<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brand:BrandEst){
                Brand.AF_Status_Base_Fees__c=AF_Constants.CATEGORY_FINANCE; 
                Brandesitmatelist.add(Brand);
            }
            insert Brandesitmatelist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            System.Assert(AFUnileverEntity[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateNew = new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Adaptation_Local__c=23;
                agency.AF_Adaptation__c=324;
                agency.AF_Digital__c=12;
                agency.AF_Digital_Local__c=12;
                agency.AF_Agency_Exchange_Rate__c=21;
                agency.AF_Traditional__c=46;
                agency.AF_Traditional_Local__c=23;
                AgencyEsitmateNew.add(agency);
            }
            insert AgencyEsitmateNew;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            List<AF_Entity_Exception__c> EntityExcepList = AF_TestFactory_Helper.InsertEntityException(1,true);
            List<AF_Entity_Exception__c> EntityExcepQuery = [SELECT ID,AF_Agency_Estimate__c FROM AF_Entity_Exception__c WHERE ID IN : EntityExcepList LIMIT 1];
            System.assertEquals(EntityExcepQuery[0].AF_Agency_Estimate__c,AgencyEsitmate[0].id,AF_TestFactory_Helper.ENTITYEXCEPTION_RECORD);
            //Instantiate AF_AgencyEstimateController Class
            ApexPages.currentPage().getParameters().put('aid',AFEntity[0].id);
            ApexPages.currentPage().getParameters().put('bid',brandEst[0].id);
            ApexPages.currentPage().getParameters().put('uid',AFUnileverEntity[0].id);
            AF_AgencyEstimateController agenEstCtrl1=new AF_AgencyEstimateController();
            agenEstCtrl1.ExceptionId=EntityExcepList[0].Id;
            agenEstCtrl1.DeleteException();
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AFagencyEstimateController2
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AFagencyEstimateController2()
    {
        Test.startTest();
        AgencyEstimateController = AF_TestFactory_Helper.createuser(true);
        User u=[SELECT id FROM user WHERE id=:AgencyEstimateController.id LIMIT 1];
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
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            list<AF_Brand_Estimate__c> brandestimatelist=new list<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brand:BrandEst){
                Brand.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;
                brandestimatelist.add(Brand);
            }
            insert brandestimatelist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, 'The Currency records are inserted');
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            System.Assert(AFEntity[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateNew = new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Adaptation_Local__c=0;
                agency.AF_Adaptation__c=0;
                agency.AF_Digital__c=0;
                agency.AF_Digital_Local__c=0;
                agency.AF_Agency_Exchange_Rate__c=0;
                agency.AF_Traditional__c=0;
                agency.AF_PO_Number__c=AF_Constants.TEST_CATEGORYNAME;
                agency.AF_Traditional_Local__c=0;  
                agency.AF_OverridePO_Traditional_LC__c=66;
                agency.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
                agency.AF_PO_Number__c='text';
                AgencyEsitmateNew.add(agency);
            }
            insert AgencyEsitmate;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            List<AF_Entity_Exception__c> EntityExcepList = AF_TestFactory_Helper.InsertEntityException(1,true);
            List<AF_Entity_Exception__c> EntityExcepQuery = [SELECT ID,AF_Agency_Estimate__c FROM AF_Entity_Exception__c WHERE ID IN : EntityExcepList and AF_Agency_Estimate__c=:AgencyQuery LIMIT 1];
            System.assertEquals(EntityExcepQuery[0].AF_Agency_Estimate__c,AgencyEsitmate[0].id,AF_TestFactory_Helper.ENTITYEXCEPTION_RECORD);
            //insert cmcolist
            List<AF_CMCO__c> cmc = AF_TestFactory_Helper.insertCMCO(1,true);
            List<AF_CMCO__c> cmcoQuery = [SELECT id FROM AF_CMCO__c where id IN:cmc  LIMIT 1];
            System.Assert(cmcoQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Instantiate AF_AgencyEstimateController Class
            ApexPages.currentPage().getParameters().put('id',AgencyEsitmate[0].id);
            ApexPages.currentPage().getParameters().put('aid',AFEntity[0].id);
            ApexPages.currentPage().getParameters().put('bid',brandEst[0].id);
            ApexPages.currentPage().getParameters().put('uid',AFUnileverEntity[0].id);
            AF_AgencyEstimateController agenEstCtrl2=new AF_AgencyEstimateController();
            agenEstCtrl2.ExceptionId=EntityExcepList[0].Id;
            agenEstCtrl2.DeleteEntityException();   
            agenEstCtrl2.closePopupReject();
            agenEstCtrl2.UpdatPO();
            Test.stopTest();
        }
    }
}