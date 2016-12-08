/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_UpdBonusSummaryCatApproverValues_Test
@Created Date : 04/08/2014.
@Description : This Test class for class AF_UpdateBonusSummaryCatApproverValues,AF_Bonus_SummaryHandler,trigger AF_Bonus_SummaryTrigger
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_UpdBonusSummaryCatApproverValues_Test  
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year()-1;
    Static string currYear1=string.valueof(IcurrYear1);
    static user userForupdateSummaryCatApprover;
    static user userForupdateSummaryCatApprover1;
    static user userForupdateSummaryCatApprover2;
    static user userForupdateSummaryCatApprover3;
    static user userForupdateSummaryCatApprover4;
    static user userForupdateSummaryCatApprover5;
    static user userForupdateSummaryCatApprover6;
    static user userForupdateSummaryCatApprover7;
    static user userForupdateSummaryCatApprover8;
    static user userForupdateSummaryCatApprover9;
    static user userForupdateSummaryCatApprover10;
    static user userForupdateSummaryCMCO1;
    static user userForupdateSummaryCMCO2;
    static user userForupdateSummaryCMCO3;
    static user userForupdateSummaryCMCO4;
    static user userForupdateSummaryCMCO5;
    static user userForupdateSummarybonusApprover;
    static  List<contact> con4;
    static  List<contact> con5;
    static  List<contact> con6;
    
    /**********************************************************************
    *  @Description: This method will have Test data.
    *  @name : UpSummaryCatApproverValues
    *  @param : none
    *  @return : none
    *************************************************************************/  
    Static testMethod void UpSummaryCatApproverValues()
    {
        Test.startTest();
        userForupdateSummaryCatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
        User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCatApprover.id LIMIT 1];
        
        userForupdateSummarybonusApprover=AF_TestFactory_Helper.createApprover(true);
        User uApprover=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummarybonusApprover.id LIMIT 1];
        
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            list<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con!=Null,con1!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            list<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con2!=Null,con3!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
            con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
            List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
            for(AF_Category_Brand__c brand:AFCategoryBrand){
                brand.name=AF_Constants.TEST_BRANDNAME;
                AFCategoryBrandlist.add(brand);
            }
            insert AFCategoryBrandlist;
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
            
            
            List<AF_Bonus_Summary__c> summaryList = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew = new List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c SummaryObj: summaryList){
                SummaryObj.AF_Fiscal_year__c=currYear;
                SummaryListNew.add(SummaryObj);
            }
            insert SummaryListNew;
            List<AF_Bonus_Summary__c> SummaryList1 = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew1 = new List<AF_Bonus_Summary__c>();
            
            for(AF_Bonus_Summary__c SummaryObj1: SummaryList1){
                SummaryObj1.AF_Fiscal_year__c=currYear1;
                SummaryListNew1.add(SummaryObj1);
            }
            insert SummaryListNew1;
            
            List<AF_Bonus_Summary__c> SummaryListQuery = [SELECT ID,AF_Agency__c FROM AF_Bonus_Summary__c WHERE ID IN : SummaryListNew LIMIT 1];
            System.assertEquals(SummaryListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            
            AF_UpdateBonusSummaryCatApproverValues.UpdateBonusSummary(SummaryListNew);
            AF_UpdateBonusSummaryCatApproverValues.UpdateOopsagencyBulk(SummaryListNew);
            Test.stopTest();
        }
    }
    
    /**********************************************************************
    *  @Description: This method will have Test data.
    *  @name : UpSummaryCatApproverValues1
    *  @param : none
    *  @return : none
    *************************************************************************/  
    Static testMethod void UpSummaryCatApproverValues1 ()
    {
        Test.startTest();
        userForupdateSummaryCatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
        User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCatApprover.id LIMIT 1];
        userForupdateSummaryCatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
        user u1=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover1.id LIMIT 1];
        
        userForupdateSummaryCMCO1=AF_TestFactory_Helper.createuser(true);
        User uCMCO1=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO1.id LIMIT 1];
        
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            list<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con!=Null,con1!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            list<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con2!=Null,con3!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
            con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
            List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
            for(AF_Category_Brand__c brand:AFCategoryBrand){
                brand.name=AF_Constants.TEST_BRANDNAME;
                AFCategoryBrandlist.add(brand);
            }
            insert AFCategoryBrandlist;
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
            
            
            List<AF_Bonus_Summary__c> summaryList = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew = new List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c SummaryObj: summaryList){
                SummaryObj.AF_Fiscal_year__c=currYear;
                SummaryListNew.add(SummaryObj);
            }
            insert SummaryListNew;
            List<AF_Bonus_Summary__c> SummaryList1 = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew1 = new List<AF_Bonus_Summary__c>();
            
            for(AF_Bonus_Summary__c SummaryObj1: SummaryList1){
                SummaryObj1.AF_Fiscal_year__c=currYear1;
                SummaryListNew1.add(SummaryObj1);
            }
            insert SummaryListNew1;
            
            List<AF_Bonus_Summary__c> SummaryListQuery = [SELECT ID,AF_Agency__c FROM AF_Bonus_Summary__c WHERE ID IN : SummaryListNew LIMIT 1];
            System.assertEquals(SummaryListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            
            AF_UpdateBonusSummaryCatApproverValues.UpdateBonusSummary(SummaryListNew);
            AF_UpdateBonusSummaryCatApproverValues.UpdateOopsagencyBulk(SummaryListNew);
            Test.stopTest();
        }
    }
    
    /**********************************************************************
    *  @Description: This method will have Test data.
    *  @name : UpSummaryCatApproverValues2
    *  @param : none
    *  @return : none
    *************************************************************************/  
    Static testMethod void UpSummaryCatApproverValues2 ()
    {
        Test.startTest();
        userForupdateSummaryCatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
        User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCatApprover.id LIMIT 1];
        userForupdateSummaryCatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
        user u1=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover1.id LIMIT 1];
        userForupdateSummaryCatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
        user u2=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover2.id LIMIT 1];
        userForupdateSummaryCMCO1=AF_TestFactory_Helper.createuser(true);
        User uCMCO1=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO1.id LIMIT 1];
        userForupdateSummaryCMCO2=AF_TestFactory_Helper.createuser1(true);
        User uCMCO2=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO2.id LIMIT 1];
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            list<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con!=Null,con1!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            list<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con2!=Null,con3!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
            con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
            List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
            for(AF_Category_Brand__c brand:AFCategoryBrand){
                brand.name=AF_Constants.TEST_BRANDNAME;
                AFCategoryBrandlist.add(brand);
            }
            insert AFCategoryBrandlist;
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
            
            
            List<AF_Bonus_Summary__c> summaryList = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew = new List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c SummaryObj: summaryList){
                SummaryObj.AF_Fiscal_year__c=currYear;
                SummaryListNew.add(SummaryObj);
            }
            insert SummaryListNew;
            List<AF_Bonus_Summary__c> SummaryList1 = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew1 = new List<AF_Bonus_Summary__c>();
            
            for(AF_Bonus_Summary__c SummaryObj1: SummaryList1){
                SummaryObj1.AF_Fiscal_year__c=currYear1;
                SummaryListNew1.add(SummaryObj1);
            }
            insert SummaryListNew1;
            
            List<AF_Bonus_Summary__c> SummaryListQuery = [SELECT ID,AF_Agency__c FROM AF_Bonus_Summary__c WHERE ID IN : SummaryListNew LIMIT 1];
            System.assertEquals(SummaryListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            
            AF_UpdateBonusSummaryCatApproverValues.UpdateBonusSummary(SummaryListNew);
            AF_UpdateBonusSummaryCatApproverValues.UpdateOopsagencyBulk(SummaryListNew);
            Test.stopTest();
        }
    }
    
    /**********************************************************************
    *  @Description: This method will have Test data.
    *  @name : UpSummaryCatApproverValues3
    *  @param : none
    *  @return : none
    *************************************************************************/  
    Static testMethod void UpSummaryCatApproverValues3 ()
    {
        Test.startTest();
        userForupdateSummaryCatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
        User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCatApprover.id LIMIT 1];
        userForupdateSummaryCatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
        user u1=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover1.id LIMIT 1];
        userForupdateSummaryCatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
        user u2=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover2.id LIMIT 1];
        userForupdateSummaryCatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
        System.assertEquals(u1!=null,u2!=null,AF_TestFactory_Helper.USER_RECORD);
        user u3=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover3.id LIMIT 1];
        userForupdateSummaryCMCO1=AF_TestFactory_Helper.createuser(true);
        User uCMCO1=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO1.id LIMIT 1];
        userForupdateSummaryCMCO2=AF_TestFactory_Helper.createuser1(true);
        User uCMCO2=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO2.id LIMIT 1];
        userForupdateSummaryCMCO3=AF_TestFactory_Helper.createuser2(true);
        User uCMCO3=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO3.id LIMIT 1];
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            list<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con!=Null,con1!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            list<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con2!=Null,con3!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
            con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
            List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
            for(AF_Category_Brand__c brand:AFCategoryBrand){
                brand.name=AF_Constants.TEST_BRANDNAME;
                AFCategoryBrandlist.add(brand);
            }
            insert AFCategoryBrandlist;
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
            
            
            List<AF_Bonus_Summary__c> summaryList = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew = new List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c SummaryObj: summaryList){
                SummaryObj.AF_Fiscal_year__c=currYear;
                SummaryListNew.add(SummaryObj);
            }
            insert SummaryListNew;
            List<AF_Bonus_Summary__c> SummaryList1 = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew1 = new List<AF_Bonus_Summary__c>();
            
            for(AF_Bonus_Summary__c SummaryObj1: SummaryList1){
                SummaryObj1.AF_Fiscal_year__c=currYear1;
                SummaryListNew1.add(SummaryObj1);
            }
            insert SummaryListNew1;
            
            List<AF_Bonus_Summary__c> SummaryListQuery = [SELECT ID,AF_Agency__c FROM AF_Bonus_Summary__c WHERE ID IN : SummaryListNew LIMIT 1];
            System.assertEquals(SummaryListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            
            AF_UpdateBonusSummaryCatApproverValues.UpdateBonusSummary(SummaryListNew);
            AF_UpdateBonusSummaryCatApproverValues.UpdateOopsagencyBulk(SummaryListNew);
            Test.stopTest();
        }
    }
    
    /**********************************************************************
    *  @Description: This method will have Test data.
    *  @name : UpSummaryCatApproverValues4
    *  @param : none
    *  @return : none
    *************************************************************************/  
    Static testMethod void UpSummaryCatApproverValues4()
    {
        Test.startTest();
        userForupdateSummaryCatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
        User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCatApprover.id LIMIT 1];
        userForupdateSummaryCatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
        user u1=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover1.id LIMIT 1];
        userForupdateSummaryCatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
        user u2=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover2.id LIMIT 1];
        userForupdateSummaryCatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
        System.assertEquals(u1!=null,u2!=null,AF_TestFactory_Helper.USER_RECORD);
        user u3=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover3.id LIMIT 1];
        userForupdateSummaryCatApprover4=AF_TestFactory_Helper.createUserADMINSTRATOR4(true);
        user u4=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover4.id LIMIT 1];
        userForupdateSummaryCMCO1=AF_TestFactory_Helper.createuser(true);
        User uCMCO1=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO1.id LIMIT 1];
        userForupdateSummaryCMCO2=AF_TestFactory_Helper.createuser1(true);
        User uCMCO2=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO2.id LIMIT 1];
        userForupdateSummaryCMCO3=AF_TestFactory_Helper.createuser2(true);
        User uCMCO3=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO3.id LIMIT 1];
        userForupdateSummaryCMCO4=AF_TestFactory_Helper.createuser3(true);
        User uCMCO4=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO4.id LIMIT 1];
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            list<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con!=Null,con1!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            list<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con2!=Null,con3!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
            con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
            List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
            for(AF_Category_Brand__c brand:AFCategoryBrand){
                brand.name=AF_Constants.TEST_BRANDNAME;
                AFCategoryBrandlist.add(brand);
            }
            insert AFCategoryBrandlist;
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
            
            
            List<AF_Bonus_Summary__c> summaryList = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew = new List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c SummaryObj: summaryList){
                SummaryObj.AF_Fiscal_year__c=currYear;
                SummaryListNew.add(SummaryObj);
            }
            insert SummaryListNew;
            List<AF_Bonus_Summary__c> SummaryList1 = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew1 = new List<AF_Bonus_Summary__c>();
            
            for(AF_Bonus_Summary__c SummaryObj1: SummaryList1){
                SummaryObj1.AF_Fiscal_year__c=currYear1;
                SummaryListNew1.add(SummaryObj1);
            }
            insert SummaryListNew1;
            
            List<AF_Bonus_Summary__c> SummaryListQuery = [SELECT ID,AF_Agency__c FROM AF_Bonus_Summary__c WHERE ID IN : SummaryListNew LIMIT 1];
            System.assertEquals(SummaryListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            
            AF_UpdateBonusSummaryCatApproverValues.UpdateBonusSummary(SummaryListNew);
            AF_UpdateBonusSummaryCatApproverValues.UpdateOopsagencyBulk(SummaryListNew);
            Test.stopTest();
        }
    }
    
    /**********************************************************************
    *  @Description: This method will have Test data.
    *  @name : UpSummaryCatApproverValues5
    *  @param : none
    *  @return : none
    *************************************************************************/  
    Static testMethod void UpSummaryCatApproverValues5 ()
    {
        Test.startTest();
        userForupdateSummaryCatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
        User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCatApprover.id LIMIT 1];
        userForupdateSummaryCatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
        user u1=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover1.id LIMIT 1];
        userForupdateSummaryCatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
        user u2=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover2.id LIMIT 1];
        userForupdateSummaryCatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
        System.assertEquals(u1!=null,u2!=null,AF_TestFactory_Helper.USER_RECORD);
        user u3=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover3.id LIMIT 1];
        userForupdateSummaryCatApprover4=AF_TestFactory_Helper.createUserADMINSTRATOR4(true);
        user u4=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover4.id LIMIT 1];
        userForupdateSummaryCatApprover5=AF_TestFactory_Helper.createUserAdmin1(true);
        System.assertEquals(u3!=null,u4!=null,AF_TestFactory_Helper.USER_RECORD);
        user u5=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover5.id LIMIT 1];
        userForupdateSummaryCMCO1=AF_TestFactory_Helper.createuser(true);
        User uCMCO1=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO1.id LIMIT 1];
        userForupdateSummaryCMCO2=AF_TestFactory_Helper.createuser1(true);
        User uCMCO2=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO2.id LIMIT 1];
        userForupdateSummaryCMCO3=AF_TestFactory_Helper.createuser2(true);
        User uCMCO3=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO3.id LIMIT 1];
        userForupdateSummaryCMCO4=AF_TestFactory_Helper.createuser3(true);
        User uCMCO4=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO4.id LIMIT 1];
        userForupdateSummaryCMCO5=AF_TestFactory_Helper.createuser4(true);
        User uCMCO5=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCMCO5.id LIMIT 1];
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            list<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con!=Null,con1!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            list<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con2!=Null,con3!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
            con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
            List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
            for(AF_Category_Brand__c brand:AFCategoryBrand){
                brand.name=AF_Constants.TEST_BRANDNAME;
                AFCategoryBrandlist.add(brand);
            }
            insert AFCategoryBrandlist;
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
            
            
            List<AF_Bonus_Summary__c> summaryList = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew = new List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c SummaryObj: summaryList){
                SummaryObj.AF_Fiscal_year__c=currYear;
                SummaryListNew.add(SummaryObj);
            }
            insert SummaryListNew;
            List<AF_Bonus_Summary__c> SummaryList1 = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew1 = new List<AF_Bonus_Summary__c>();
            
            for(AF_Bonus_Summary__c SummaryObj1: SummaryList1){
                SummaryObj1.AF_Fiscal_year__c=currYear1;
                SummaryListNew1.add(SummaryObj1);
            }
            insert SummaryListNew1;
            
            List<AF_Bonus_Summary__c> SummaryListQuery = [SELECT ID,AF_Agency__c FROM AF_Bonus_Summary__c WHERE ID IN : SummaryListNew LIMIT 1];
            System.assertEquals(SummaryListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            
            AF_UpdateBonusSummaryCatApproverValues.UpdateBonusSummary(SummaryListNew);
            AF_UpdateBonusSummaryCatApproverValues.UpdateOopsagencyBulk(SummaryListNew);
            Test.stopTest();
        }
    }
    
    /**********************************************************************
    *  @Description: This method will have Test data.
    *  @name : UpSummaryCatApproverValues6
    *  @param : none
    *  @return : none
    *************************************************************************/  
    Static testMethod void UpSummaryCatApproverValues6()
    {
        Test.startTest();
        userForupdateSummaryCatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
        User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCatApprover.id LIMIT 1];
        userForupdateSummaryCatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
        user u1=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover1.id LIMIT 1];
        userForupdateSummaryCatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
        user u2=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover2.id LIMIT 1];
        userForupdateSummaryCatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
        System.assertEquals(u1!=null,u2!=null,AF_TestFactory_Helper.USER_RECORD);
        user u3=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover3.id LIMIT 1];
        userForupdateSummaryCatApprover4=AF_TestFactory_Helper.createUserADMINSTRATOR4(true);
        user u4=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover4.id LIMIT 1];
        userForupdateSummaryCatApprover5=AF_TestFactory_Helper.createUserAdmin1(true);
        System.assertEquals(u3!=null,u4!=null,AF_TestFactory_Helper.USER_RECORD);
        user u5=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover5.id LIMIT 1];
        userForupdateSummaryCatApprover6=AF_TestFactory_Helper.createUserADMINSTRATOR_CATEGORY(true);
        user u6=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover6.id LIMIT 1];
        
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            list<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con!=Null,con1!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            list<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con2!=Null,con3!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
            con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
            List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
            for(AF_Category_Brand__c brand:AFCategoryBrand){
                brand.name=AF_Constants.TEST_BRANDNAME;
                AFCategoryBrandlist.add(brand);
            }
            insert AFCategoryBrandlist;
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
            
            
            List<AF_Bonus_Summary__c> summaryList = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew = new List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c SummaryObj: summaryList){
                SummaryObj.AF_Fiscal_year__c=currYear;
                SummaryListNew.add(SummaryObj);
            }
            insert SummaryListNew;
            List<AF_Bonus_Summary__c> SummaryList1 = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew1 = new List<AF_Bonus_Summary__c>();
            
            for(AF_Bonus_Summary__c SummaryObj1: SummaryList1){
                SummaryObj1.AF_Fiscal_year__c=currYear1;
                SummaryListNew1.add(SummaryObj1);
            }
            insert SummaryListNew1;
            
            List<AF_Bonus_Summary__c> SummaryListQuery = [SELECT ID,AF_Agency__c FROM AF_Bonus_Summary__c WHERE ID IN : SummaryListNew LIMIT 1];
            System.assertEquals(SummaryListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            
            AF_UpdateBonusSummaryCatApproverValues.UpdateBonusSummary(SummaryListNew);
            AF_UpdateBonusSummaryCatApproverValues.UpdateOopsagencyBulk(SummaryListNew);
            Test.stopTest();
        }
    }
    
    /**********************************************************************
    *  @Description: This method will have Test data.
    *  @name : UpSummaryCatApproverValues7
    *  @param : none
    *  @return : none
    *************************************************************************/  
    Static testMethod void UpSummaryCatApproverValues7()
    {
        Test.startTest();
        userForupdateSummaryCatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
        User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCatApprover.id LIMIT 1];
        userForupdateSummaryCatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
        user u1=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover1.id LIMIT 1];
        userForupdateSummaryCatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
        user u2=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover2.id LIMIT 1];
        userForupdateSummaryCatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
        System.assertEquals(u1!=null,u2!=null,AF_TestFactory_Helper.USER_RECORD);
        user u3=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover3.id LIMIT 1];
        userForupdateSummaryCatApprover4=AF_TestFactory_Helper.createUserADMINSTRATOR4(true);
        user u4=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover4.id LIMIT 1];
        userForupdateSummaryCatApprover5=AF_TestFactory_Helper.createUserAdmin1(true);
        System.assertEquals(u3!=null,u4!=null,AF_TestFactory_Helper.USER_RECORD);
        user u5=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover5.id LIMIT 1];
        userForupdateSummaryCatApprover6=AF_TestFactory_Helper.createUserADMINSTRATOR_CATEGORY(true);
        user u6=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover6.id LIMIT 1];
        userForupdateSummaryCatApprover7=AF_TestFactory_Helper.createUserAdmin3(true);
        user u7=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover7.id LIMIT 1];
        System.assertEquals(u5!=null,u6!=null,AF_TestFactory_Helper.USER_RECORD);
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            list<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con!=Null,con1!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            list<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con2!=Null,con3!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
            con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
            List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
            for(AF_Category_Brand__c brand:AFCategoryBrand){
                brand.name=AF_Constants.TEST_BRANDNAME;
                AFCategoryBrandlist.add(brand);
            }
            insert AFCategoryBrandlist;
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
            
            
            List<AF_Bonus_Summary__c> summaryList = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew = new List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c SummaryObj: summaryList){
                SummaryObj.AF_Fiscal_year__c=currYear;
                SummaryListNew.add(SummaryObj);
            }
            insert SummaryListNew;
            List<AF_Bonus_Summary__c> SummaryList1 = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew1 = new List<AF_Bonus_Summary__c>();
            
            for(AF_Bonus_Summary__c SummaryObj1: SummaryList1){
                SummaryObj1.AF_Fiscal_year__c=currYear1;
                SummaryListNew1.add(SummaryObj1);
            }
            insert SummaryListNew1;
            
            List<AF_Bonus_Summary__c> SummaryListQuery = [SELECT ID,AF_Agency__c FROM AF_Bonus_Summary__c WHERE ID IN : SummaryListNew LIMIT 1];
            System.assertEquals(SummaryListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            
            AF_UpdateBonusSummaryCatApproverValues.UpdateBonusSummary(SummaryListNew);
            AF_UpdateBonusSummaryCatApproverValues.UpdateOopsagencyBulk(SummaryListNew);
            Test.stopTest();
        }
    }
    
    /**********************************************************************
    *  @Description: This method will have Test data.
    *  @name : UpSummaryCatApproverValues8
    *  @param : none
    *  @return : none
    *************************************************************************/  
    Static testMethod void UpSummaryCatApproverValues8()
    {
        Test.startTest();
        userForupdateSummaryCatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
        User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCatApprover.id LIMIT 1];
        userForupdateSummaryCatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
        user u1=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover1.id LIMIT 1];
        userForupdateSummaryCatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
        user u2=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover2.id LIMIT 1];
        userForupdateSummaryCatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
        System.assertEquals(u1!=null,u2!=null,AF_TestFactory_Helper.USER_RECORD);
        user u3=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover3.id LIMIT 1];
        userForupdateSummaryCatApprover4=AF_TestFactory_Helper.createUserADMINSTRATOR4(true);
        user u4=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover4.id LIMIT 1];
        userForupdateSummaryCatApprover5=AF_TestFactory_Helper.createUserAdmin1(true);
        System.assertEquals(u3!=null,u4!=null,AF_TestFactory_Helper.USER_RECORD);
        user u5=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover5.id LIMIT 1];
        userForupdateSummaryCatApprover6=AF_TestFactory_Helper.createUserADMINSTRATOR_CATEGORY(true);
        user u6=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover6.id LIMIT 1];
        userForupdateSummaryCatApprover7=AF_TestFactory_Helper.createUserAdmin3(true);
        user u7=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover7.id LIMIT 1];
        userForupdateSummaryCatApprover8=AF_TestFactory_Helper.createUserAdmin5(true);
        user u8=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover8.id LIMIT 1];
        System.assertEquals(u5!=null,u6!=null,AF_TestFactory_Helper.USER_RECORD);
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            list<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con!=Null,con1!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            list<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con2!=Null,con3!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
            con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
            List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
            for(AF_Category_Brand__c brand:AFCategoryBrand){
                brand.name=AF_Constants.TEST_BRANDNAME;
                AFCategoryBrandlist.add(brand);
            }
            insert AFCategoryBrandlist;
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
            
            
            List<AF_Bonus_Summary__c> summaryList = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew = new List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c SummaryObj: summaryList){
                SummaryObj.AF_Fiscal_year__c=currYear;
                SummaryListNew.add(SummaryObj);
            }
            insert SummaryListNew;
            List<AF_Bonus_Summary__c> SummaryList1 = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew1 = new List<AF_Bonus_Summary__c>();
            
            for(AF_Bonus_Summary__c SummaryObj1: SummaryList1){
                SummaryObj1.AF_Fiscal_year__c=currYear1;
                SummaryListNew1.add(SummaryObj1);
            }
            insert SummaryListNew1;
            
            List<AF_Bonus_Summary__c> SummaryListQuery = [SELECT ID,AF_Agency__c FROM AF_Bonus_Summary__c WHERE ID IN : SummaryListNew LIMIT 1];
            System.assertEquals(SummaryListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            
            AF_UpdateBonusSummaryCatApproverValues.UpdateBonusSummary(SummaryListNew);
            AF_UpdateBonusSummaryCatApproverValues.UpdateOopsagencyBulk(SummaryListNew);
            Test.stopTest();
        }
    }
    
    /**********************************************************************
    *  @Description: This method will have Test data.
    *  @name : UpSummaryCatApproverValues9
    *  @param : none
    *  @return : none
    *************************************************************************/  
    Static testMethod void UpSummaryCatApproverValues9()
    {
        Test.startTest();
        userForupdateSummaryCatApprover=AF_TestFactory_Helper.createUserADMINSTRATOR(true);
        User u=[SELECT id,Email,AF_Brand__c FROM user WHERE id=:userForupdateSummaryCatApprover.id LIMIT 1];
        userForupdateSummaryCatApprover1=AF_TestFactory_Helper.createUserADMINSTRATOR1(true);
        user u1=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover1.id LIMIT 1];
        userForupdateSummaryCatApprover2=AF_TestFactory_Helper.createUserADMINSTRATOR2(true);
        user u2=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover2.id LIMIT 1];
        userForupdateSummaryCatApprover3=AF_TestFactory_Helper.createUserADMINSTRATOR3(true);
        System.assertEquals(u1!=null,u2!=null,AF_TestFactory_Helper.USER_RECORD);
        user u3=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover3.id LIMIT 1];
        userForupdateSummaryCatApprover4=AF_TestFactory_Helper.createUserADMINSTRATOR4(true);
        user u4=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover4.id LIMIT 1];
        userForupdateSummaryCatApprover5=AF_TestFactory_Helper.createUserAdmin1(true);
        System.assertEquals(u3!=null,u4!=null,AF_TestFactory_Helper.USER_RECORD);
        user u5=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover5.id LIMIT 1];
        userForupdateSummaryCatApprover6=AF_TestFactory_Helper.createUserADMINSTRATOR_CATEGORY(true);
        user u6=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover6.id LIMIT 1];
        userForupdateSummaryCatApprover7=AF_TestFactory_Helper.createUserAdmin3(true);
        user u7=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover7.id LIMIT 1];
        userForupdateSummaryCatApprover8=AF_TestFactory_Helper.createUserAdmin5(true);
        user u8=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover8.id LIMIT 1];
        userForupdateSummaryCatApprover9=AF_TestFactory_Helper.createUserAdmin6(true);
        user u9=[SELECT id,Email FROM user WHERE id=:userForupdateSummaryCatApprover9.id LIMIT 1];
        System.assertEquals(u5!=null,u6!=null,AF_TestFactory_Helper.USER_RECORD);
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //insert contact.
            list<contact> con =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con1 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con!=Null,con1!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            list<contact> con2 =AF_TestFactory_Helper.AFInsertContact(1,true);
            list<contact> con3 =AF_TestFactory_Helper.AFInsertContact(1,true);
            System.assertEquals(con2!=Null,con3!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            con4 =AF_TestFactory_Helper.AFInsertContact(1,true);
            con5 =AF_TestFactory_Helper.AFInsertContact(1,true);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,false);
            List<AF_Category_Brand__c> AFCategoryBrandlist= new List<AF_Category_Brand__c>();
            for(AF_Category_Brand__c brand:AFCategoryBrand){
                brand.name=AF_Constants.TEST_BRANDNAME;
                AFCategoryBrandlist.add(brand);
            }
            insert AFCategoryBrandlist;
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrandlist LIMIT 1];
            
            
            List<AF_Bonus_Summary__c> summaryList = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew = new List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c SummaryObj: summaryList)
            {
                SummaryObj.AF_Fiscal_year__c=currYear;
                SummaryListNew.add(SummaryObj);
            }
            insert SummaryListNew;
            List<AF_Bonus_Summary__c> SummaryList1 = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> SummaryListNew1 = new List<AF_Bonus_Summary__c>();
            
            for(AF_Bonus_Summary__c SummaryObj1: SummaryList1)
            {
                SummaryObj1.AF_Fiscal_year__c=currYear1;
                SummaryListNew1.add(SummaryObj1);
            }
            insert SummaryListNew1;
            
            List<AF_Bonus_Summary__c> SummaryListQuery = [SELECT ID,AF_Agency__c FROM AF_Bonus_Summary__c WHERE ID IN : SummaryListNew LIMIT 1];
            System.assertEquals(SummaryListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            
            AF_UpdateBonusSummaryCatApproverValues.UpdateBonusSummary(SummaryListNew);
            AF_UpdateBonusSummaryCatApproverValues.UpdateOopsagencyBulk(SummaryListNew);
            Test.stopTest();
        }
    }  
}