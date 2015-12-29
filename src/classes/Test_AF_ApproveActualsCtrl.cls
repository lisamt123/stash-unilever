/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_ApproveActualsCtrl
@CreateDate : 17/9/2014
@Description : This is a Test class for AF_ApproveActualsCtrl class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class Test_AF_ApproveActualsCtrl
{    
	Static Integer IcurrYear = System.Today().year();
	Static string currYear=string.valueof(IcurrYear);
	Static Integer IcurrYear1 = System.Today().year()-1;
	Static string currYear1=string.valueof(IcurrYear1);
	private static String attachment_Data = 'Test Data for document attachment';
	private static String brandId='bId';
	private static String accountId = 'aId';
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : approveActualsCtrl
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void approveActualsCtrl()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = 'testac', Email='standarduserac@unilever.com', 
		EmailEncodingKey='UTF-8', LastName='Test Usera123', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
		LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
		UserName='testuserac@test123321.com',AF_Brand__c='Test Brandac',AF_Category__c='Test Beveragesac');
		insert u;        
		System.runAs(u)
		{ 
			//Insert Account
			Account acc1=new Account();
			acc1.Name='Test Agencyac';
			acc1.published__c=true;
			insert acc1;
			System.Assert(acc1.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name='Test Beveragesac';
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=AF_Constants.TEST_SUPER_CATEGORY;
			insert cat;
			System.Assert(cat.Id != null, 'The Category record not inserted');
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name='Test Brandac';
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc1.Id;               
			brandEst.Name='Test BrandEstimateac';
			brandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
			brandEst.Brand__c=bran.id;
			insert brandEst;
			System.assertEquals(brandEst.Brand__c, bran.id);
			//Insert OOPS Actual
			AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
			oopsActual.AF_Agency_lk__c=acc1.Id;     
			oopsActual.AF_Agency__c=acc1.Id;
			oopsActual.AF_BrandEstimateId__c=brandEst.id;
			oopsActual.AF_Brand__c=bran.Id;
			oopsActual.AF_Fiscal_year__c=currYear;
			oopsActual.Quarter__c='Q1;Q2';
			insert oopsActual;   
			Blob b = Blob.valueOf(attachment_Data);  
			Attachment attach = new Attachment();  
			attach.Name = 'Test Attachment';  
			attach.Body = b;  
			attach.ParentId=oopsActual.Id;  
			attach.contentType='OOPS Q1 Backup';
			insert attach; 
			/* Adding parameters to page URL */
			//For Brand Id
			ApexPages.currentPage().getParameters().put(brandId,bran.id);         
			//For Agency Id
			ApexPages.currentPage().getParameters().put(accountId,acc1.Id);
			//For Fiscal year
			ApexPages.currentPage().getParameters().put('fy',currYear);   
			//Instantiate AF_ApproveActualsCtrl  Class
			AF_ApproveActualsCtrl  appActCtrl=new AF_ApproveActualsCtrl ();
			appActCtrl.selectedQuarter='Q1';
			appActCtrl.getTotalSum();
			appActCtrl.submit();
			appActCtrl.grApprove();
			appActCtrl.grReject();
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : approveActualsCtrl1
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void approveActualsCtrl1()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = 'testac1', Email='standarduserac1@unilever.com', 
		EmailEncodingKey='UTF-8', LastName='Test Usera1123', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
		LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
		UserName='testuserac1@test123321.com',AF_Brand__c='Test Brandac1',AF_Category__c='Test Beveragesac1');
		insert u;        
		System.runAs(u)
		{ 
			//Insert Account
			Account acc1=new Account();
			acc1.Name='Test Agencyac1';
			acc1.published__c=true;
			insert acc1;
			System.Assert(acc1.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name='Test Beveragesac1';
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=AF_Constants.TEST_SUPER_CATEGORY;
			insert cat;
			System.Assert(cat.Id != null, 'The Category record not inserted');
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name='Test Brandac1';
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc1.Id;               
			brandEst.Name='Test BrandEstimateac1';
			brandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
			brandEst.Brand__c=bran.id;
			insert brandEst;
			System.assertEquals(brandEst.Brand__c, bran.id);
			//Insert OOPS Actual
			AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
			oopsActual.AF_Agency_lk__c=acc1.Id;     
			oopsActual.AF_Agency__c=acc1.Id;
			oopsActual.AF_BrandEstimateId__c=brandEst.id;
			oopsActual.AF_Brand__c=bran.Id;
			oopsActual.AF_Fiscal_year__c=currYear1;
			oopsActual.Quarter__c='Q2;Q3';
			insert oopsActual;   
			//Insert Attachment
			Blob b = Blob.valueOf(attachment_Data);  
			Attachment attach = new Attachment();  
			attach.Name = 'Test Attachment1';  
			attach.Body = b;  
			attach.ParentId=oopsActual.Id;  
			attach.contentType='OOPS Q2 Backup';
			insert attach;
			/* Adding parameters to page URL */
			//For Brand Id
			ApexPages.currentPage().getParameters().put(brandId,bran.id);         
			//For Agency Id
			ApexPages.currentPage().getParameters().put(accountId,acc1.Id);
			//For Fiscal year
			ApexPages.currentPage().getParameters().put('fy',currYear1);   
			//Instantiate AF_ApproveActualsCtrl  Class
			AF_ApproveActualsCtrl  appActCtrl1=new AF_ApproveActualsCtrl ();
			appActCtrl1.selectedQuarter='Q2';
			appActCtrl1.getTotalSum();
			appActCtrl1.submit();
			appActCtrl1.grApprove();
			appActCtrl1.grReject();
			Test.stopTest();
		}
	}    /***********************************************************************************
*  @Description: this method will the test data
*  @name : approveActualsCtrl2
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void approveActualsCtrl2()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = 'testac2', Email='standarduserac2@unilever.com', 
		EmailEncodingKey='UTF-8', LastName='Test Usera1223', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
		LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
		UserName='testuserac2@test123321.com',AF_Brand__c='Test Brandac2',AF_Category__c='Test Beveragesac2');
		insert u;        
		System.runAs(u)
		{ 
			//Insert Account
			Account acc1=new Account();
			acc1.Name='Test Agencyac2';
			acc1.published__c=true;
			insert acc1;
			System.Assert(acc1.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name='Test Beveragesac2';
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=AF_Constants.TEST_SUPER_CATEGORY;
			insert cat;
			System.Assert(cat.Id != null, 'The Category record not inserted');
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name='Test Brandac2';
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc1.Id;               
			brandEst.Name='Test BrandEstimateac2';
			brandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
			brandEst.Brand__c=bran.id;
			insert brandEst;
			System.assertEquals(brandEst.Brand__c, bran.id);
			//Insert OOPS Actual
			AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
			oopsActual.AF_Agency_lk__c=acc1.Id;     
			oopsActual.AF_Agency__c=acc1.Id;
			oopsActual.AF_BrandEstimateId__c=brandEst.id;
			oopsActual.AF_Brand__c=bran.Id;
			oopsActual.AF_Fiscal_year__c=currYear;
			oopsActual.Quarter__c='Q3;Q4';
			insert oopsActual;   
			//Insert Attachment
			Blob b = Blob.valueOf(attachment_Data);  
			Attachment attach = new Attachment();  
			attach.Name = 'Test Attachment2';  
			attach.Body = b;  
			attach.ParentId=oopsActual.Id;  
			attach.contentType='OOPS Q3 Backup';
			insert attach;
			/* Adding parameters to page URL */
			//For Brand Id
			ApexPages.currentPage().getParameters().put(brandId,bran.id);         
			//For Agency Id
			ApexPages.currentPage().getParameters().put(accountId,acc1.Id);
			//For Fiscal year
			ApexPages.currentPage().getParameters().put('fy',currYear);   
			//Instantiate AF_ApproveActualsCtrl  Class
			AF_ApproveActualsCtrl  appActCtrl2=new AF_ApproveActualsCtrl ();
			appActCtrl2.selectedQuarter='Q3';
			appActCtrl2.getTotalSum();
			appActCtrl2.submit();
			appActCtrl2.grApprove();
			appActCtrl2.grReject();
			Test.stopTest();
		}
	}    
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : approveActualsCtrl3
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void approveActualsCtrl3()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = 'testac3', Email='standarduserac3@unilever.com', 
		EmailEncodingKey='UTF-8', LastName='Test Usera1323', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
		LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
		UserName='testuserac3@test123321.com',AF_Brand__c='Test Brandac3',AF_Category__c='Test Beveragesac3');
		insert u;        
		System.runAs(u)
		{ 
			//Insert Account
			Account acc1=new Account();
			acc1.Name='Test Agencyac3';
			acc1.published__c=true;
			insert acc1;
			System.Assert(acc1.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name='Test Beveragesac3';
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=AF_Constants.TEST_SUPER_CATEGORY;
			insert cat;
			System.Assert(cat.Id != null, 'The Category record not inserted');
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name='Test Brandac3';
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc1.Id;               
			brandEst.Name='Test BrandEstimateac3';
			brandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
			brandEst.Brand__c=bran.id;
			insert brandEst;
			System.assertEquals(brandEst.Brand__c, bran.id);
			//Insert OOPS Actual
			AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
			oopsActual.AF_Agency_lk__c=acc1.Id;     
			oopsActual.AF_Agency__c=acc1.Id;
			oopsActual.AF_BrandEstimateId__c=brandEst.id;
			oopsActual.AF_Brand__c=bran.Id;
			oopsActual.AF_Fiscal_year__c=currYear;
			oopsActual.Quarter__c='Q1;Q4';
			insert oopsActual;   
			//Insert Attachment
			Blob b = Blob.valueOf(attachment_Data);  
			Attachment attach = new Attachment();  
			attach.Name = 'Test Attachment3';  
			attach.Body = b;  
			attach.ParentId=oopsActual.Id;  
			attach.contentType='OOPS Q4 Backup';
			insert attach;
			/* Adding parameters to page URL */
			//For Brand Id
			ApexPages.currentPage().getParameters().put(brandId,bran.id);         
			//For Agency Id
			ApexPages.currentPage().getParameters().put(accountId,acc1.Id);
			//For Fiscal year
			ApexPages.currentPage().getParameters().put('fy',currYear);   
			//Instantiate AF_ApproveActualsCtrl  Class
			AF_ApproveActualsCtrl  appActCtrl3=new AF_ApproveActualsCtrl ();
			appActCtrl3.selectedQuarter='Q4';
			appActCtrl3.getTotalSum();
			appActCtrl3.submit();
			appActCtrl3.grApprove();
			appActCtrl3.grReject();
			oopsActual.Overall__c=10;
			oopsActual.AF_iS_OOPS_Percentage__c = false;
			update oopsActual;
			appActCtrl3.save();
			appActCtrl3.redo();
			Test.stopTest();
		}
	}    
}