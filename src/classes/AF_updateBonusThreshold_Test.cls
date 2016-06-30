/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_updateBonusThreshold
@Created Date : 05/08/2014.
@Description : This Test class for AF_updateBonusThreshold trigger class
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_updateBonusThreshold_Test
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year()-1;
    Static string currYear1=string.valueof(IcurrYear1);
    static  user userForBonsusThreshold;
    static  user userForBonsusThreshold1;
    static User t1;
    static User t;
    static User u1;
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : AF_updateBonusThreshold
*  @param : none
*  @return : none
*************************************************************************/  
    Static testMethod void AF_updateBonusThreshold()
    {
        Test.startTest();
        userForBonsusThreshold =AF_TestFactory_Helper.createUserAdmin(true);
        userForBonsusThreshold1 =AF_TestFactory_Helper.createUserAdmin1(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForBonsusThreshold.id LIMIT 1];
        u1=[SELECT id,Email FROM user WHERE id=:userForBonsusThreshold1.id LIMIT 1];
        t=[Select Id,AF_UserTypeText__c,Email,IsActive from User where Id=:u.Id];
        t1=[Select Id,AF_UserTypeText__c,Email,IsActive from User where Id=:u1.Id];
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accNew = new List<Account>();
            for(Account ac : acc){
                ac.published__c=true;
                accNew.add(ac);
            }
            insert accNew;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            List<contact> con =AF_TestFactory_Helper.AFInsertContact(1,false);
            List<contact> conNewLst = new List<contact>();
            for(contact contactL : con){
                contactL.email = 'standarduserbec@unilever.com';
                contactL.AF_Send_Email_Notification__c = true;
                conNewLst.add(contactL);
            }
            insert conNewLst;
            List<Contact> conQuery = [SELECT id FROM contact LIMIT 1];
            System.Assert(conQuery[0].Id != null, AF_TestFactory_Helper.CONTACT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c brest : BrandEst){
                brest.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
                brest.AF_Locked__c=false; 
                brest.AF_Pilot_Model__c=true;
                brest.AF_AgencyUsers1__c=t.Email;
                BrandEstNew.add(brest);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id, AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert user category.
            List<Users_Category__c> usercat = AF_TestFactory_Helper.insertusercategory(1,true);
            List<Users_Category__c> usercat1 = AF_TestFactory_Helper.insertusercategory1(1,true);
            System.assertEquals(usercat!=null, usercat1!=null,AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Bonus Threshold
            /*List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdNew = new  List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bthresh : BonusThreshold ){
                bthresh.AF_Traditional__c=true;
                bthresh.AF_Digital__c=true;
                bthresh.Year__c=currYear;
                bthresh.AF_Minimum__c=10;
                bthresh.AF_Stretching__c=15;
                bthresh.AF_Outstanding__c=20;
                BonusThresholdNew.add(bthresh);
            }
            insert BonusThresholdNew;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThresholdNew LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //insert subResult.
            List<AF_Sub_Result__c> subres = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subresList = new List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sub : subres)
            {
                sub.AF_Traditional__c=true;
                sub.AF_Digital__c=true;
                sub.AF_Minimum__c=20;
                sub.AF_Stretching__c=25;
                sub.AF_Outstanding__c=30;
                subresList.add(sub);
            }
            insert subresList;
            List<AF_Sub_Result__c> subresQuery = [SELECT ID ,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subresList Limit 1];
            //System.assertEquals(subresQuery[0].AF_Bonus_Threshold__c,BonusThresholdNew[0].id, AF_TestFactory_Helper.SUBRESULT_RECORD);
            delete subresList;*/
            Test.stopTest();
        }
    }
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdateQuantBonus
*  @param : none
*  @return : none
*************************************************************************/  
    Static testMethod void AF_UpdateQuantBonus()
    {
        Test.startTest();
        userForBonsusThreshold =AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForBonsusThreshold.id LIMIT 1];
        t=[Select Id,AF_UserTypeText__c,Email,IsActive from User where Id=:u.Id];
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accNew = new List<Account>();
            for(Account ac : acc){
                ac.published__c=true;
                accNew.add(ac);
            }
            insert accNew;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            List<contact> con =AF_TestFactory_Helper.AFInsertContact(1,false);
            List<contact> conNewLst = new List<contact>();
            for(contact contactL : con){
                contactL.email = 'standarduserbec@unilever.com';
                contactL.AF_Send_Email_Notification__c = true;
                conNewLst.add(contactL);
            }
            insert conNewLst;
            List<Contact> conQuery = [SELECT id FROM contact LIMIT 1];
            System.Assert(conQuery[0].Id != null, AF_TestFactory_Helper.CONTACT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c brest : BrandEst){
                brest.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
                brest.AF_Locked__c=false; 
                brest.AF_Pilot_Model__c=true;
                brest.AF_AgencyUsers1__c=t.Email;
                BrandEstNew.add(brest);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id, AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //insert user category.
            List<Users_Category__c> usercat = AF_TestFactory_Helper.insertusercategory(1,true);
            //List<Users_Category__c> usercat1 = AF_TestFactory_Helper.insertusercategory1(1,true);
            System.assert(usercat[0].id!=null,AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Bonus Threshold
            /*List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdNew = new  List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bthresh : BonusThreshold ){
                bthresh.AF_Traditional__c=true;
                bthresh.AF_Digital__c=true;
                bthresh.Year__c=currYear;
                bthresh.AF_Minimum__c=10;
                bthresh.AF_Stretching__c=15;
                bthresh.AF_Outstanding__c=20;
                BonusThresholdNew.add(bthresh);
            }
            insert BonusThresholdNew;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThresholdNew LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results 
            List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,false);
            List<AF_Bonus_Results__c> AFBonusResNew = new  List<AF_Bonus_Results__c>();
            for(AF_Bonus_Results__c bonres : AFBonusRes){
                bonres.AF_Total_Bonus_Value__c=23;
                AFBonusResNew.add(bonres);
            }
            insert AFBonusResNew;
            List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c where RecordTypeId=:AF_TestFactory_Helper.AF_BONUS_RESULTS_RECTYPE and Id IN:AFBonusResNew LIMIT 1];
            //System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            //insert subResult.
            List<AF_Sub_Result__c> subres = AF_TestFactory_Helper.insertSubResult(1,false);
            List<AF_Sub_Result__c> subresList = new List<AF_Sub_Result__c>();
            for(AF_Sub_Result__c sub : subres)
            {
                sub.AF_Traditional__c=true;
                sub.AF_Digital__c=true;
                sub.AF_Minimum__c=20;
                sub.AF_Stretching__c=25;
                sub.AF_Outstanding__c=30;
                sub.AF_Status__c=AF_Constants.STATUS_DRAFT;
                subresList.add(sub);
            }
            insert subresList;
            List<AF_Sub_Result__c> subresQuery = [SELECT ID ,AF_Bonus_Threshold__c FROM AF_Sub_Result__c WHERE ID IN : subresList Limit 1];
            //System.assertEquals(subresQuery[0].AF_Bonus_Threshold__c,BonusThresholdNew[0].id, AF_TestFactory_Helper.SUBRESULT_RECORD);
            delete subresList ;*/
            Test.stopTest();
        }
    }
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : OOPsBaseFeeMatrix
*  @param : none
*  @return : none
*************************************************************************/  
    Static testMethod void AF_OOPsBaseFeeMatrix ()
    {
        Test.startTest();
        userForBonsusThreshold =AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForBonsusThreshold.id LIMIT 1];
        t=[Select Id,AF_UserTypeText__c,Email,IsActive from User where Id=:u.Id];
        System.runAs(u)
        {
            userForBonsusThreshold1 =AF_TestFactory_Helper.createUserAdmin1(true);
            u1=[SELECT id,Email FROM user WHERE id=:userForBonsusThreshold1.id LIMIT 1];
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accNew = new List<Account>();
            for(Account ac : acc){
                ac.published__c=true;
                accNew.add(ac);
            }
            insert accNew;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            List<contact> con =AF_TestFactory_Helper.AFInsertContact(1,false);
            List<contact> conNewLst = new List<contact>();
            for(contact contactL : con){
                contactL.email = 'standarduserbec@unilever.com';
                contactL.AF_Send_Email_Notification__c = true;
                conNewLst.add(contactL);
            }
            insert conNewLst;
            List<Contact> conQuery = [SELECT id FROM contact LIMIT 1];
            System.Assert(conQuery[0].Id != null, AF_TestFactory_Helper.CONTACT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            System.Assert(duuser[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c brest : BrandEst){
                brest.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
                brest.AF_Locked__c=false; 
                brest.AF_Pilot_Model__c=true;
                brest.AF_AgencyUsers1__c=t.Email;
                brest.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
                brest.AF_Fiscal_Year__c=currYear1;
                brest.AF_Fiscal_Year__c=currYear;
                BrandEstNew.add(brest);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList1(1,false);
            List<AF_Brand_Estimate__c> BrandEstNew1 = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c brest1 : BrandEst1){
                brest1.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
                brest1.AF_Locked__c=false; 
                brest1.AF_Pilot_Model__c=true;
                brest1.AF_AgencyUsers1__c=t.Email;
                brest1.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4;
                brest1.AF_Fiscal_Year__c=currYear1;
                brest1.AF_Fiscal_Year__c=currYear;
                BrandEstNew.add(brest1);
            }
            insert BrandEstNew1;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id, AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
            List<AF_OOPS_Actual__c> OopsactualListNew = new List<AF_OOPS_Actual__c>();
            for(AF_OOPS_Actual__c oopsact : OopsactualList){
                oopsact.AF_Fiscal_year__c=currYear;
                OopsactualListNew.add(oopsact);
            }
            insert OopsactualListNew;
            List<AF_OOPS_Actual__c> OopsactualList1 = AF_TestFactory_Helper.insertOOPSActual1(1,false);
            List<AF_OOPS_Actual__c> OopsactualListNew1 = new List<AF_OOPS_Actual__c>();
            for(AF_OOPS_Actual__c oopsact1 : OopsactualList1){
                oopsact1.AF_Fiscal_year__c=currYear1;
                OopsactualListNew1.add(oopsact1);
            }
            insert OopsactualListNew1;
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualListNew LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,false);
            List<AF_OOPS_Estimate__c> OOPSEstimateListNew = new List<AF_OOPS_Estimate__c>();
            for(AF_OOPS_Estimate__c oopEstl : OOPSEstimateList){
                oopEstl.AF_Estimate__c=55;
                oopEstl.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
                oopEstl.AF_Ready_For_PO_Entry_Currency__c = AF_Constants.AF_CURRENCY_USD;
                oopEstl.AF_Ready_For_PO_Exchange_Rate__c = 1.6112;
                OOPSEstimateListNew.add(oopEstl);
            }
            insert OOPSEstimateListNew;
            List<AF_OOPS_Estimate__c> OOPSEstimateList1 = AF_TestFactory_Helper.InsertOOPsEstimate1(1,false);
            List<AF_OOPS_Estimate__c> OOPSEstimateListNew1 = new List<AF_OOPS_Estimate__c>();
            for(AF_OOPS_Estimate__c oopEst : OOPSEstimateList1){
                oopEst.AF_Estimate__c=55;
                oopEst.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
                oopEst.AF_Ready_For_PO_Entry_Currency__c = AF_Constants.AF_CURRENCY_USD;
                oopEst.AF_Ready_For_PO_Exchange_Rate__c = 1.6112;
                OOPSEstimateList1.add(oopEst);
            }
            insert OOPSEstimateListNew1;
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateListNew LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            insert OOPSEstimateList1;
            delete OOPSEstimateList1;
            Test.stopTest();
        }
    }
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : AFBaseFeeMatrix
*  @param : none
*  @return : none
*************************************************************************/ 
    Static testMethod void AFBaseFeeMatrix()
    {
        Test.startTest();
        userForBonsusThreshold =AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userForBonsusThreshold.id LIMIT 1];
        t=[Select Id,AF_UserTypeText__c,Email,IsActive from User where Id=:u.Id];
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accNew = new List<Account>();
            for(Account ac : acc){
                ac.published__c=true;
                accNew.add(ac);
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
            System.Assert(AFCurrencyQuery[0].Id != null,AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert Matrix Table.
            List<AF_Matrix_Table__c> MatrixTableList = AF_TestFactory_Helper.insertmatrixtable(1,true);
            List<AF_Matrix_Table__c> MatrixTableListQuery = [SELECT Id FROM AF_Matrix_Table__c where id IN:MatrixTableList LIMIT 1];
            system.assert(MatrixTableListQuery[0].Id!=null ,AF_TestFactory_Helper.MATRIX_RECORD);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmateNew = new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_READYFORPO;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmateNew.add(agency);
            }
            insert AgencyEsitmateNew;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            delete AgencyEsitmateNew ;
        }
    }
}