/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_ApproveActualsCtrl_Test
@CreateDate : 17/9/2014
@Description : This is a Test class for AF_ApproveActualsCtrl class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_ApproveActualsCtrl_Test
{ 
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year()-1;
    Static string currYear1=string.valueof(IcurrYear1);
    private static String attachment_Data = 'Test Data for document attachment';
    private static String brandId='bId';
    private static String accountId = 'aId';
    static String quarter='Q1;Q2';
    static user ApproveActualsCtrl;
    static user ApproveActualsCtrl1;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_approveActualsCtrl
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_approveActualsCtrl()
    {
        Test.startTest();
        ApproveActualsCtrl=AF_TestFactory_Helper.createUserAdmin1(true);
        User u=[SELECT id FROM user WHERE id=:ApproveActualsCtrl.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
            List<AF_OOPS_Actual__c> OopsactualList1=new List<AF_OOPS_Actual__c>();
            for(AF_OOPS_Actual__c oopact : OopsactualList){
                oopact.Quarter__c='Q1;Q2;Q3;Q4';
                OopsactualList1.add(oopact);
            }
            insert OopsactualList1;
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList1 LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            // insert Attachment.
            Blob b = Blob.valueOf(attachment_Data);  
            Attachment attach = new Attachment();  
            attach.Name = 'Test Attachment';  
            attach.Body = b;  
            attach.ParentId=OopsactualList[0].Id;  
            attach.contentType='OOPS Q1 Backup';
            insert attach;
            system.assert(attach.id!=null,' Attachment is inserted');
            ApexPages.currentPage().getParameters().put(brandId,AFCategoryBrand[0].id);   
            //For Agency Id
            ApexPages.currentPage().getParameters().put(accountId,acc[0].Id);
            //For Fiscal year
            ApexPages.currentPage().getParameters().put('fy',currYear);   
            //Instantiate AF_ApproveActualsCtrl  Class
            AF_ApproveActualsCtrl  appActCtrl=new AF_ApproveActualsCtrl();
            appActCtrl.selectedQuarter='Q1';
            appActCtrl.getTotalSum();
            appActCtrl.submit();
            appActCtrl.redo();
            appActCtrl.grApprove();
            appActCtrl.grReject();
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_approveActualsCtrl1
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_approveActualsCtrl1()
    {
        Test.startTest();
        ApproveActualsCtrl=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:ApproveActualsCtrl.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
            List<AF_OOPS_Actual__c> OopsactualList1=new List<AF_OOPS_Actual__c>();
            for(AF_OOPS_Actual__c oopact1 : OopsactualList){
                oopact1.Quarter__c='Q2;Q3';
                //oopact1.AF_Rejected_Quarter__c='Q2';
                oopact1.AF_Fiscal_year__c=currYear1;
                OopsactualList1.add(oopact1);
            }
            insert OopsactualList1;
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList1 LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            // insert Attachment
            Blob b = Blob.valueOf(attachment_Data);  
            Attachment attach = new Attachment();  
            attach.Name = 'Test Attachment1';  
            attach.Body = b;  
            attach.ParentId=OopsactualList[0].Id;  
            attach.contentType='OOPS Q2 Backup';
            insert attach;
            system.assert(attach.id!=null,' Attachment is inserted');
            /* Adding parameters to page URL */
            //For Brand Id
            ApexPages.currentPage().getParameters().put(brandId,AFCategoryBrand[0].id);         
            //For Agency Id
            ApexPages.currentPage().getParameters().put(accountId,acc[0].Id);
            //For Fiscal year
            ApexPages.currentPage().getParameters().put('fy',currYear1);   
            //Instantiate AF_ApproveActualsCtrl  Class
            AF_ApproveActualsCtrl  appActCtrl1=new AF_ApproveActualsCtrl ();
            appActCtrl1.selectedQuarter='Q2';
            appActCtrl1.getTotalSum();
            appActCtrl1.submit();
            appActCtrl1.redo();
            appActCtrl1.grApprove();
            appActCtrl1.grReject();
            Test.stopTest();
        }
    }       
    /*-------------------------------------------------------------------------------
*  @Description: this method will the test data
*  @name : AF_approveActualsCtrl2
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_approveActualsCtrl2()
    {
        Test.startTest();
        ApproveActualsCtrl=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:ApproveActualsCtrl.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
            List<AF_OOPS_Actual__c> OopsactualList1 =new List<AF_OOPS_Actual__c>();
            for(AF_OOPS_Actual__c oopact2 : OopsactualList){
                oopact2.Quarter__c='Q3;Q4';
                OopsactualList1.add(oopact2);
            }
            insert OopsactualList1;
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList1 LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert BrandEstimate
            List<AF_AgencyEmailAlerts__c> Agency= AF_TestFactory_Helper.insertagencyEmailalerts(1,true);
            List<AF_AgencyEmailAlerts__c> AgencyQuery =[SELECT Name, Q2__c, Q1__c ,Q3__c, Q4__c  FROM AF_AgencyEmailAlerts__c where Id IN:Agency LIMIT 1];
            //Insert Attachment
            Blob b = Blob.valueOf(attachment_Data);  
            Attachment attach = new Attachment();  
            attach.Name = 'Test Attachment2';  
            attach.Body = b;  
            attach.ParentId=OopsactualList[0].Id;  
            attach.contentType='OOPS Q3 Backup';
            insert attach;
            system.assert(attach.id!=null,' Attachment is inserted');
            /* Adding parameters to page URL */
            //For Brand Id
            ApexPages.currentPage().getParameters().put(brandId,AFCategoryBrand[0].id);         
            //For Agency Id
            ApexPages.currentPage().getParameters().put(accountId,acc[0].Id);
            //For Fiscal year
            ApexPages.currentPage().getParameters().put('fy',currYear);   
            //Instantiate AF_ApproveActualsCtrl  Class
            AF_ApproveActualsCtrl  appActCtrl2=new AF_ApproveActualsCtrl ();
            appActCtrl2.selectedQuarter='Q3';
            appActCtrl2.getTotalSum();
            appActCtrl2.submit();
            appActCtrl2.grApprove();
            appActCtrl2.grReject();
            appActCtrl2.save();
            appActCtrl2.redo();
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_approveActualsCtrl3
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_approveActualsCtrl3()
    {
        Test.startTest();
        ApproveActualsCtrl=AF_TestFactory_Helper.createAgency(true);
        User u=[SELECT id FROM user WHERE id=:ApproveActualsCtrl.id LIMIT 1];
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
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;
                BrandEstlist.add(br); 
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
            List<AF_OOPS_Actual__c> OopsactualList1 =new List<AF_OOPS_Actual__c>();
            for(AF_OOPS_Actual__c oopact3 : OopsactualList){
                oopact3.Quarter__c='Q1;Q4';
                oopact3.AF_Fiscal_year__c=currYear;
                OopsactualList1 .add(oopact3);
            }
            insert OopsactualList1;
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Attachment
            Blob b = Blob.valueOf(attachment_Data);  
            Attachment attach = new Attachment();  
            attach.Name = 'Test Attachment3';  
            attach.Body = b;  
            attach.ParentId=OopsactualList1[0].Id;  
            attach.contentType='OOPS Q4 Backup';
            insert attach;
            /* Adding parameters to page URL */
            //For Brand Id
            ApexPages.currentPage().getParameters().put(brandId,AFCategoryBrand[0].id);         
            //For Agency Id
            ApexPages.currentPage().getParameters().put(accountId,acc[0].Id);
            //For Fiscal year
            ApexPages.currentPage().getParameters().put('fy',currYear);   
            //Instantiate AF_ApproveActualsCtrl  Class
            AF_ApproveActualsCtrl  appActCtrl3=new AF_ApproveActualsCtrl ();
            appActCtrl3.redo();
            appActCtrl3.selectedQuarter='Q4';
            //appActCtrl3.isBackUpUploaded(true);
            appActCtrl3.getTotalSum();
            OopsactualList[0].Overall__c=10;
            OopsactualList[0].AF_iS_OOPS_Percentage__c = false;
            update OopsactualList;
            Test.stopTest();
        }
    }
    /*-------------------------------------------------------------------------------
*  @Description: this method will the test data
*  @name : AF_approveActualsCtrl2
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_approveActualsCtrl4()
    {
        Test.startTest();
        ApproveActualsCtrl=AF_TestFactory_Helper.createAgency(true);
        User u=[SELECT id FROM user WHERE id=:ApproveActualsCtrl.id LIMIT 1];   
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.CONTACT_RECORD);
            //Insert contact
            List<contact> Con=AF_TestFactory_Helper.AFInsertContact(1,true);
            List<contact> Contactquery= [SELECT id FROM contact LIMIT 1];
            System.Assert(Contactquery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
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
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
            List<AF_OOPS_Actual__c> OopsactualList1 =new List<AF_OOPS_Actual__c>();
            for(AF_OOPS_Actual__c oopact2 : OopsactualList){
                oopact2.Quarter__c=AF_Constants.QUARTER4;
                OopsactualList1.add(oopact2);
            }
            insert OopsactualList1;
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList1 LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert BrandEstimate
            List<AF_AgencyEmailAlerts__c> Agency= AF_TestFactory_Helper.insertagencyEmailalerts(1,true);
            List<AF_AgencyEmailAlerts__c> AgencyQuery =[SELECT Name, Q2__c, Q1__c ,Q3__c, Q4__c  FROM AF_AgencyEmailAlerts__c where Id IN:Agency LIMIT 1];
            //Insert Attachment
            Blob b = Blob.valueOf(attachment_Data);  
            Attachment attach = new Attachment();  
            attach.Name = 'Test Attachment2';  
            attach.Body = b;  
            attach.ParentId=OopsactualList[0].Id;  
            attach.contentType='OOPS Q4 Backup';
            insert attach;
            system.assert(attach.id!=null,' Attachment is inserted');
            /* Adding parameters to page URL */
            //For Brand Id
            ApexPages.currentPage().getParameters().put(brandId,AFCategoryBrand[0].id);         
            //For Agency Id
            ApexPages.currentPage().getParameters().put(accountId,acc[0].Id);
            //For Fiscal year
            ApexPages.currentPage().getParameters().put('fy',currYear);
            ApexPages.currentPage().getParameters().put('quarter','Q4'); 
            //Instantiate AF_ApproveActualsCtrl  Class
            AF_ApproveActualsCtrl  appActCtrl2=new AF_ApproveActualsCtrl ();
            appActCtrl2.selectedQuarter='Q4';
            appActCtrl2.getTotalSum();
            appActCtrl2.getUserAction(OopsactualList1[0].Quarter__c,OopsactualList1[0].Quarter__c);
            appActCtrl2.grApprove();
            appActCtrl2.grReject();
            appActCtrl2.save();
            appActCtrl2.redo();
            Test.stopTest();
        }
    }
}