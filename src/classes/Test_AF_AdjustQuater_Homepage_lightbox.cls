/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_AdjustQuater_Homepage_lightbox
@CreateDate : 12/9/2014
@Description : This is a Test class for AF_AdjustQuater_Homepage_lightbox class, 
@			  
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(seeAllData=false)
public class Test_AF_AdjustQuater_Homepage_lightbox  
{    
	Static Integer IcurrYear = System.Today().year();
	Static string currYear=string.valueof(IcurrYear);
	private static String agencyFeesUserType = 'Agency';
	private static String Fyear = 'Year';
	/***********************************************************************************
*  @Description: this method will have the test data
*  @name : adjustQuater_Homepage_lightbox
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void adjustQuater_Homepage_lightbox()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = 'testbe', Email='standarduserbe@unilever.com', 
		EmailEncodingKey='UTF-8', LastName='Test Userbe', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
		LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c=agencyFeesUserType,isActive=true, 
		UserName='testuserbe@test123321.com',AF_Brand__c='Test Brandbe',AF_Category__c='Test Beveragesbe');
		insert u;        
		System.runAs(u)
		{ 
			//Insert Account
			Account acc=new Account();
			acc.Name='Test Agencybe';
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name='Test Beveragesbe';
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=AF_Constants.TEST_SUPER_CATEGORY;
			insert cat;
			System.Assert(cat.Id != null, AF_Constants.TEST_ASSERT_MSG_CATEGORY);
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name='Test Brandbe';
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name='Test BrandEstimatebe';
			brandEst.AF_Status_Base_Fees__c=AF_Constants.CATEGORY_FINANCE;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q1;Q2;Q3;Q4';
			brandEst.AF_Fiscal_Year__c=currYear;
			brandEst.AF_Pilot_Model__c=false;
			insert brandEst;
			ApexPages.currentPage().getParameters().put('Category',cat.id);
			ApexPages.currentPage().getParameters().put(Fyear,currYear);    
			AF_AdjustQuater_Homepage_lightbox adjHome=new AF_AdjustQuater_Homepage_lightbox();
			adjHome.saveBrandEstimate();
			adjHome.showPopup();
			adjHome.closePopup();
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will have the test data
*  @name : adjustQuater_Homepage_lightbox1
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void adjustQuater_Homepage_lightbox1()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = 'testbe', Email='standarduserbe1@unilever.com', 
		EmailEncodingKey='UTF-8', LastName='Test Userbe1', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
		LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c=agencyFeesUserType,isActive=true, 
		UserName='testuserbe1@test123321.com',AF_Brand__c='Test Brandbe1',AF_Category__c='Test Beveragesbe1');
		insert u;        
		System.runAs(u)
		{ 
			//Insert Account
			Account acc=new Account();
			acc.Name='Test Agencybe1';
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name='Test Beveragesbe1';
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=AF_Constants.TEST_SUPER_CATEGORY;
			insert cat;
			System.Assert(cat.Id != null, AF_Constants.TEST_ASSERT_MSG_CATEGORY);
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name='Test Brandbe1';
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name='Test BrandEstimatebe1';
			brandEst.AF_Status_Base_Fees__c=AF_Constants.CATEGORY_FINANCE;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q1;Q2;Q3;Q4';
			brandEst.AF_Fiscal_Year__c=currYear;
			brandEst.AF_Pilot_Model__c=false;
			insert brandEst;
			List<AF_AdjustQuater_Homepage_lightbox.wrapChechbox> brandEstimateRecords=new List<AF_AdjustQuater_Homepage_lightbox.wrapChechbox>();
			ApexPages.currentPage().getParameters().put('Category',cat.id);
			ApexPages.currentPage().getParameters().put(Fyear,currYear);    
			AF_AdjustQuater_Homepage_lightbox adjHome=new AF_AdjustQuater_Homepage_lightbox();
			AF_AdjustQuater_Homepage_lightbox.wrapChechbox wr=new AF_AdjustQuater_Homepage_lightbox.wrapChechbox(brandEst,brandEst.Name,true,false,false,false);
			System.debug('Quarter Estimate Records:');
			wr.Selected=true;
			brandEstimateRecords.add(wr);
			adjHome.QuarterEstimate=brandEstimateRecords;      
			adjHome.saveBrandEstimate();
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will have the test data
*  @name : adjustQuater_Homepage_lightbox2
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void adjustQuater_Homepage_lightbox2()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = 'testbe2', Email='standarduserbe2@unilever.com', 
		EmailEncodingKey='UTF-8', LastName='Test Userbe1', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
		LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c=agencyFeesUserType,isActive=true, 
		UserName='testuserbe2@test123321.com',AF_Brand__c='Test Brandbe2',AF_Category__c='Test Beveragesbe2');
		insert u;        
		System.runAs(u)
		{ 
			//Insert Account
			Account acc=new Account();
			acc.Name='Test Agencybe1';
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name='Test Beveragesbe2';
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=AF_Constants.TEST_SUPER_CATEGORY;
			insert cat;
			System.Assert(cat.Id != null, AF_Constants.TEST_ASSERT_MSG_CATEGORY);
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name='Test Brandbe2';
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name='Test BrandEstimatebe2';
			brandEst.AF_Status_Base_Fees__c=AF_Constants.CATEGORY_FINANCE;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Fiscal_Year__c=currYear;
			brandEst.AF_Pilot_Model__c=false;
			insert brandEst;
			List<AF_AdjustQuater_Homepage_lightbox.wrapChechbox> brandEstimateRecords=new List<AF_AdjustQuater_Homepage_lightbox.wrapChechbox>();
			ApexPages.currentPage().getParameters().put('Category',cat.id);
			ApexPages.currentPage().getParameters().put(Fyear,currYear);    
			AF_AdjustQuater_Homepage_lightbox adjHome=new AF_AdjustQuater_Homepage_lightbox();
			AF_AdjustQuater_Homepage_lightbox.wrapChechbox wr=new AF_AdjustQuater_Homepage_lightbox.wrapChechbox(brandEst,brandEst.Name,false,false,false,false);
			System.debug('Quarter Estimate Records:');
			wr.Selected=true;
			brandEstimateRecords.add(wr);
			adjHome.QuarterEstimate=brandEstimateRecords;      
			adjHome.showPopup();
			adjHome.saveBrandEstimate();
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will have the test data
*  @name : adjustQuater_Homepage_lightbox3
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void adjustQuater_Homepage_lightbox3()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = 'testbe3', Email='standarduserbe3@unilever.com', 
		EmailEncodingKey='UTF-8', LastName='Test Userbe3', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
		LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c=agencyFeesUserType,isActive=true, 
		UserName='testuserbe3@test123321.com',AF_Brand__c='Test Brandbe3',AF_Category__c='Test Beveragesbe3');
		insert u;        
		System.runAs(u)
		{ 
			//Insert Account
			Account acc=new Account();
			acc.Name='Test Agencybe1';
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name='Test Beveragesbe3';
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=AF_Constants.TEST_SUPER_CATEGORY;
			insert cat;
			System.Assert(cat.Id != null, AF_Constants.TEST_ASSERT_MSG_CATEGORY);
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name='Test Brandbe3';
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			System.assertEquals(bran.AF_Category_Brands__c, cat.Id);
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name='Test BrandEstimatebe3';
			brandEst.AF_Status_Base_Fees__c=AF_Constants.CATEGORY_FINANCE;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Fiscal_Year__c=currYear;
			brandEst.AF_Pilot_Model__c=false;
			insert brandEst;
			List<AF_AdjustQuater_Homepage_lightbox.wrapChechbox> brandEstimateRecords=new List<AF_AdjustQuater_Homepage_lightbox.wrapChechbox>();
			ApexPages.currentPage().getParameters().put('Category',cat.id);
			ApexPages.currentPage().getParameters().put(Fyear,currYear);    
			AF_AdjustQuater_Homepage_lightbox adjHome=new AF_AdjustQuater_Homepage_lightbox();
			AF_AdjustQuater_Homepage_lightbox.wrapChechbox wr=new AF_AdjustQuater_Homepage_lightbox.wrapChechbox(brandEst,brandEst.Name,true,true,true,true);
			System.debug('Quarter Estimate Records:');
			wr.Selected=true;
			brandEstimateRecords.add(wr);
			adjHome.QuarterEstimate=brandEstimateRecords;      
			adjHome.showPopup();
			adjHome.saveBrandEstimate();
			Test.stopTest();
		}
	}
}