/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_RaisenewPO_Homepage_lightbox_Test
@Created Date : 08/08/2014.
@Description : This Test class for  AF_RaisenewPO_Homepage_lightbox   apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_RaisenewPO_Homepage_lightbox_Test
{  
    Private Static Integer IcurrYear = System.Today().year();
    Private Static string currYear=string.valueof(IcurrYear); 
    Private static user RaisenewPO_Homepage_lightbox; 
    private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
    private static string QUARTER='Q1;Q2;Q3;Q4';
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : raisenewPO_Homepage_lightbox
*  @param : none
*  @return : none
*************************************************************************/ 
    Static testMethod void AF_RaisenewPO_Homepage_lightbox ()
    {
        Test.startTest();
        RaisenewPO_Homepage_lightbox = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:RaisenewPO_Homepage_lightbox.id LIMIT 1];
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accList = new List<Account>();
            for(Account loopacc : acc){
                loopacc.Name=AF_Constants.TEST_USER_ALIAS_NAME;
                loopacc.published__c = true;
                accList.add(loopacc);
            }
            insert acc;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert contact.
            List<Contact> contactList = AF_TestFactory_Helper.AFInsertContact(1,false);
            List<Contact> contactList1=new List<Contact>();
            for(contact con : contactList){
                con.AF_Send_Email_Notification__c=true;
                contactList1.add(con);
            }
            insert contactList1;
            List<contact> conQuery = [SELECT id From Contact LIMIT 1];
            system.assert(conQuery[0].id!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c  loopBrandEst : BrandEst)
            {
                loopbrandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;  
                loopbrandEst.AF_Fiscal_Year__c=currYear;
                loopbrandEst.AF_Active__c = true;
                loopbrandEst.AF_Copied__c= false;
                loopbrandEst.AF_Locked__c = false; 
                loopbrandEst.AF_Controller_Flag__c=false;
                loopbrandEst.AF_AgencyUsers1__c=u.Email;
                loopbrandEst.AF_Traditional__c=23;
                loopbrandEst.AF_Digital__c=24;
                loopbrandEst.AF_Adaptive__c=44;
                loopbrandEst.AF_BackupQuarter__c = 'Q1;Q2;Q3';
                loopBrandEst.Archived_BrandEstimate_Quarter__c='Q1;Q2;Q3';
                BrandEstlist.add(loopbrandEst);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c LIMIT 2]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //inset Agency Estimate.           
            List<AF_Agency_Estimate__c> AgencyEsitmate1 = AF_TestFactory_Helper.insertAgencyEstimate(1,true);
            List<AF_Agency_Estimate__c> AgencyQuery1 = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate1 limit 1];
            System.assertEquals(AgencyQuery1[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //inset Agency Estimate.           
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Digital_Local__c=12;
                agency.AF_Traditional__c=22; 
                agency.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;  
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate1 limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            // insert currency.
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdLSt = new   List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bonThres :BonusThreshold){
                bonThres.AF_Traditional__c=true;
                bonThres.AF_Digital__c=true;
                bonThres.Year__c=currYear;
                bonThres.AF_Minimum__c=10;
                bonThres.AF_Stretching__c=15;
                bonThres.AF_Outstanding__c=20;
                BonusThresholdLSt.add(bonThres);
            }
            insert BonusThresholdLSt;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c WHERE ID IN :BonusThresholdLSt LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            ApexPages.currentPage().getParameters().put(AF_Constants.RT_CATEGORY,cb[0].id);
            ApexPages.currentPage().getParameters().put('Year',currYear);
            List<AF_RaisenewPO_Homepage_lightbox.wrapChechbox> brandEstimateRecords=new List<AF_RaisenewPO_Homepage_lightbox.wrapChechbox>();
            AF_RaisenewPO_Homepage_lightbox raiseHome=new AF_RaisenewPO_Homepage_lightbox ();
            AF_RaisenewPO_Homepage_lightbox.wrapChechbox wr=new AF_RaisenewPO_Homepage_lightbox.wrapChechbox(brandEst[0],true,true,true,false);
            wr.Selected=true;
            brandEstimateRecords.add(wr);
            raiseHome.QuarterEstimate=brandEstimateRecords;     
            raiseHome.showPopup();
            raiseHome.saveBrandEstimate(); 
            Test.stopTest();
        }
    }
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : raisenewPO_Homepage_lightbox1
*  @param : none
*  @return : none
*************************************************************************/ 
    Static testMethod void AF_RaisenewPO_Homepage_lightbox1()
    {
        Test.startTest();
        RaisenewPO_Homepage_lightbox = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:RaisenewPO_Homepage_lightbox.id LIMIT 1];
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accList = new List<Account>();
            for(Account loopacc : acc){
                loopacc.Name=AF_Constants.PERM_CMCO_SUPERUSER;
                loopacc.published__c = true;
                accList.add(loopacc);
            }
            insert accList;
            List<Account> acctQuery = [SELECT id, Name FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            List<Contact> contactList = AF_TestFactory_Helper.AFInsertContact(1,false);
            List<Contact> contactList1=new List<Contact>();
            for(contact con : contactList){
                con.AF_Send_Email_Notification__c=true;
                contactList1.add(con);
            }
            insert contactList1;
            List<contact> conQuery = [SELECT id From Contact LIMIT 1];
            system.assert(conQuery[0].id!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            // insert brand estimate
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist1=new list<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brand:BrandEst1){
                Brand.BrandEstimateArchivedId__c=AF_Constants.SOBJECT_BRANDESTIMATE_APINAME;
                BrandEstlist1.add(Brand);
            }
            insert BrandEstlist1;
            List<AF_Brand_Estimate__c> BrandEstQuery1 =[SELECT Brand__c FROM AF_Brand_Estimate__c WHERE ID IN:BrandEst1 LIMIT 1]; 
            System.assertEquals(BrandEstQuery1[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //insert brandestimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c  loopBrandEst : BrandEst)
            {
                loopbrandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO ;  
                loopbrandEst.AF_Fiscal_Year__c=currYear;
                loopbrandEst.AF_Active__c = true;
                loopbrandEst.AF_Copied__c= false;
                loopbrandEst.BrandEstimateArchivedId__c=AF_Constants.SOBJECT_BRANDESTIMATE_APINAME;
                loopbrandEst.AF_Locked__c = false; 
                loopbrandEst.AF_Controller_Flag__c=false;
                loopbrandEst.AF_AgencyUsers1__c=u.Email;
                loopbrandEst.archived_BrandEstimate_Quarter__c=QUARTER;
                loopbrandEst.AF_RaiseNewPOQuarters__c=QUARTER;
                loopBrandEst.AF_BackupQuarter__c =QUARTER;
                BrandEstlist.add(loopbrandEst);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c WHERE ID IN:BrandEstlist1 LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Brand_Estimate__c=BrandEstlist[0].id;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Digital_Local__c=12;
                agency.AF_Traditional__c=22; 
                agency.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            try{
                delete AgencyEsitmate;
            }
            catch(Exception e){
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'AF_RaisenewPO_Homepage_lightbox1',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            }        
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdLSt = new   List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bonThres :BonusThreshold){
                bonThres.AF_Traditional__c=true;
                bonThres.AF_Digital__c=true;
                bonThres.Year__c=currYear;
                bonThres.AF_Minimum__c=10;
                bonThres.AF_Stretching__c=15;
                bonThres.AF_Outstanding__c=20;
                BonusThresholdLSt.add(bonThres);
            }
            insert BonusThresholdLSt;
            ApexPages.currentPage().getParameters().put(AF_Constants.RT_CATEGORY,cb[0].id);
            ApexPages.currentPage().getParameters().put('Year',currYear);
            List<AF_RaisenewPO_Homepage_lightbox.wrapChechbox> brandEstimateRecords=new List<AF_RaisenewPO_Homepage_lightbox.wrapChechbox>();
            AF_RaisenewPO_Homepage_lightbox raiseHome1=new AF_RaisenewPO_Homepage_lightbox ();
            AF_RaisenewPO_Homepage_lightbox.wrapChechbox wr1=new AF_RaisenewPO_Homepage_lightbox.wrapChechbox(brandEst[0],true,true,true,false);
            wr1.Selected=true;
            brandEstimateRecords.add(wr1);
            raiseHome1.QuarterEstimate=brandEstimateRecords;
            raiseHome1.showPopup();
            raiseHome1.closePopup();
            raiseHome1.saveBrandEstimate();
            raiseHome1.SendEmailNotification();
            raiseHome1.RaisePo=true;
            raiseHome1.brandEstimate=BrandEstlist;
            raiseHome1.BrandName='vtest';
            raiseHome1.selectedQuarters='testq';
            raiseHome1.selectedId='Raisep';
            Test.stopTest();
        }
    }
        /**********************************************************************
*  @Description: This method will have Test data.
*  @name : raisenewPO_Homepage_lightbox2
*  @param : none
*  @return : none
*************************************************************************/ 
    Static testMethod void AF_RaisenewPO_Homepage_lightbox2()
    {
        Test.startTest();
        RaisenewPO_Homepage_lightbox = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:RaisenewPO_Homepage_lightbox.id LIMIT 1];
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> accList = new List<Account>();
            for(Account loopacc : acc){
                loopacc.Name=AF_Constants.PERM_CMCO_SUPERUSER;
                loopacc.published__c = true;
                accList.add(loopacc);
            }
            insert accList;
            List<Account> acctQuery = [SELECT id, Name FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            List<Contact> contactList = AF_TestFactory_Helper.AFInsertContact(1,false);
            List<Contact> contactList1=new List<Contact>();
            for(contact con : contactList){
                con.AF_Send_Email_Notification__c=true;
                contactList1.add(con);
            }
            insert contactList1;
            List<contact> conQuery = [SELECT id From Contact LIMIT 1];
            system.assert(conQuery[0].id!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            // insert brand estimate
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist1=new list<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Brand:BrandEst1){
                Brand.BrandEstimateArchivedId__c=AF_Constants.SOBJECT_BRANDESTIMATE_APINAME;
                BrandEstlist1.add(Brand);
            }
            insert BrandEstlist1;
            List<AF_Brand_Estimate__c> BrandEstQuery1 =[SELECT Brand__c FROM AF_Brand_Estimate__c WHERE ID IN:BrandEst1 LIMIT 1]; 
            System.assertEquals(BrandEstQuery1[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //insert brandestimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c  loopBrandEst : BrandEst)
            {
                loopbrandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO ;  
                loopbrandEst.AF_Fiscal_Year__c=currYear;
                loopbrandEst.AF_Active__c = true;
                loopbrandEst.AF_Copied__c= false;
                loopbrandEst.BrandEstimateArchivedId__c=AF_Constants.SOBJECT_BRANDESTIMATE_APINAME;
                loopbrandEst.AF_Locked__c = false; 
                loopbrandEst.AF_Controller_Flag__c=false;
                loopbrandEst.AF_AgencyUsers1__c=u.Email;
                loopbrandEst.archived_BrandEstimate_Quarter__c=QUARTER;
                loopbrandEst.AF_RaiseNewPOQuarters__c=QUARTER;
                loopBrandEst.AF_BackupQuarter__c =QUARTER;
                BrandEstlist.add(loopbrandEst);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c WHERE ID IN:BrandEstlist1 LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Brand_Estimate__c=BrandEstlist[0].id;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Digital_Local__c=12;
                agency.AF_Traditional__c=22; 
                agency.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            try{
                delete AgencyEsitmate;
            }
            catch(Exception e){
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'AF_RaisenewPO_Homepage_lightbox1',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            }        
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdLSt = new   List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bonThres :BonusThreshold){
                bonThres.AF_Traditional__c=true;
                bonThres.AF_Digital__c=true;
                bonThres.Year__c=currYear;
                bonThres.AF_Minimum__c=10;
                bonThres.AF_Stretching__c=15;
                bonThres.AF_Outstanding__c=20;
                BonusThresholdLSt.add(bonThres);
            }
            insert BonusThresholdLSt;
            ApexPages.currentPage().getParameters().put(AF_Constants.RT_CATEGORY,cb[0].id);
            ApexPages.currentPage().getParameters().put('Year',currYear);
            List<AF_RaisenewPO_Homepage_lightbox.wrapChechbox> brandEstimateRecords=new List<AF_RaisenewPO_Homepage_lightbox.wrapChechbox>();
            AF_RaisenewPO_Homepage_lightbox raiseHome1=new AF_RaisenewPO_Homepage_lightbox ();
            AF_RaisenewPO_Homepage_lightbox.wrapChechbox wr1=new AF_RaisenewPO_Homepage_lightbox.wrapChechbox(brandEst[0],false,false,false,false);
            brandEstimateRecords.add(wr1);
            raiseHome1.QuarterEstimate=brandEstimateRecords;
            raiseHome1.showPopup();
            raiseHome1.closePopup();
            //raiseHome1.saveBrandEstimate();
            //raiseHome1.SendEmailNotification();
            raiseHome1.RaisePo=true;
            raiseHome1.brandEstimate=BrandEstlist;
            raiseHome1.BrandName='vtest';
            raiseHome1.selectedQuarters='testq';
            raiseHome1.selectedId='Raisep';
            Test.stopTest();
        }
    }
}