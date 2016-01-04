/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_BrandEstimateCatApproverValues
@CreateDate : 23/10/2014
@Description : This is a Test class for AF_UpdateBrandEstimateCatApproverValues class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class Test_AF_BrandEstimateCatApproverValues 
{    
	private static String emailAddress='standarduserbec@unilever.com';
	private static String brandName='Test Brander';
	private static String emailAddress1='standarduserbec1@unilever.com';
	private static String lastName = 'Test Userbec1';
	private static String userName ='testuserbec1@test123321.com';
	private static String emailAddress3='standarduserbec2@unilever.com';
	private static String lastName2 ='Test Userbec2';
	private static String emailAddress4='testuserbec2@test123321.com';
	private static String emailAddress5='standarduserbec3@unilever.com';
	private static String lastName3 = 'Test Userbec3';
	private static String emailAddress6 = 'testuserbec3@test123321.com';
	private static String emailAddress7 ='standarduserbec4@unilever.com';
	private static String lastName4 ='Test Userbec4';
	private static String emailAddress8 = 'testuserbec4@test123321.com';
	private static String emailAddress9 = 'standarduserbec5@unilever.com';
	private static String lastName5 = 'Test Userbec5';
	private static String emailAddress10 = 'testuserbec5@test123321.com';
	private static String emailAddress11 = 'standarduserbec6@unilever.com';
	private static String lastName6 = 'Test Userbec6';
	private static String emailAddress12 = 'testuserbec6@test123321.com';
	private static String AcctName='Test Agencyer';
	private static String contactName='Test Cono';
	private static String superCategoryName = 'Drinks';
	private static String brandEstName = 'Test BrandEstimateer';
	private static String brandEstStatus = 'Initiate';
	private static String User_Mesage='The user record inserted';
	private static String Contact_Assert_message='The contact record  inserted';
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : catApprovervalues1
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void catApprovervalues1()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=AF_Constants.TEST_UserName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u;
		System.Assert(u.Id != null, User_Mesage);
		User u1= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress1, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=userName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u1;
		System.Assert(u1.Id != null, User_Mesage);
		User u2= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress3, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName2, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress4,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u2;
		System.Assert(u2.Id != null, User_Mesage);
		User u3= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress5, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName3, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress6,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u3;
		System.Assert(u3.Id != null, User_Mesage);
		User u4= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress7, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName4, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress8,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u4;
		System.Assert(u4.Id != null, User_Mesage);
		User u5= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress9, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName5, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress10,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u5;
		System.Assert(u5.Id != null, User_Mesage);
		User u6= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress11, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName6, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress12,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u6;
		System.Assert(u6.Id != null, User_Mesage);
		User u7= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbec7@unilever.com', 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName='Test Userbec7', LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName='testuserbec7@test123321.com',AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u7;
		System.Assert(u7.Id != null, User_Mesage);
		User u8= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbec8@unilever.com', 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName='Test Userbec8', LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName='testuserbec8@test123321.com',AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u8;
		System.Assert(u8.Id != null, User_Mesage);
		User u9= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbec9@unilever.com', 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName='Test Userbec9', LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName='testuserbec9@test123321.com',AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u9;
		System.Assert(u9.Id != null, User_Mesage);
		System.runAs(u)
		{
			//Insert Account
			Account acc=new Account();
			acc.Name=AcctName;
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, 'The Account record inserted');
			//inser Contact
			Contact con=new Contact();
			con.LastName=contactName;
			con.AccountId=acc.Id;
			con.email = emailAddress;
			con.AF_Send_Email_Notification__c = true;
			insert Con;
			System.Assert(Con.Id != null, 'The contact record inserted');
			Contact con1=new Contact();
			con1.LastName=contactName;
			con1.AccountId=acc.Id;
			con1.email = emailAddress1;
			con1.AF_Send_Email_Notification__c = true;
			insert Con1;
			System.Assert(Con1.Id != null, 'The contact record inserted');
			Contact con2=new Contact();
			con2.LastName=contactName;
			con2.AccountId=acc.Id;
			con2.email = emailAddress3;
			con2.AF_Send_Email_Notification__c = true;
			insert Con2;
			System.Assert(Con2.Id != null, 'The contact record inserted');
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name=AF_Constants.TEST_AF_Category;
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=superCategoryName;
			insert cat;
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name=brandName;
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name=brandEstName;
			brandEst.AF_Status_Base_Fees__c=brandEstStatus;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Locked__c=false; 
			brandEst.AF_Pilot_Model__c=true;
			//insert brandEst;
			List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
			brandEstimateList.add(brandEst);
			insert brandEstimateList;
			AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
			DummyUser__c dummyuser = new DummyUser__c();
			dummyuser.User_id__c = u.id;
			insert dummyuser;
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : catApprovervalues2
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void catApprovervalues2()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=AF_Constants.TEST_UserName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u;
		System.Assert(u.Id != null, User_Mesage);
		User u1= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress1, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=userName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u1;
		System.Assert(u1.Id != null, User_Mesage);
		User u2= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress3, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName2, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress4,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u2;
		System.Assert(u2.Id != null, User_Mesage);
		User u3= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress5, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName3, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress6,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u3;
		System.Assert(u3.Id != null, User_Mesage);
		User u4= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress7, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName4, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress8,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u4;
		System.Assert(u4.Id != null, User_Mesage);
		User u5= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress9, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName5, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress10,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u5;
		System.Assert(u5.Id != null, User_Mesage);
		User u6= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress11, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName6, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress12,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u6;
		System.Assert(u6.Id != null, User_Mesage);
		User u7= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbec7@unilever.com', 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName='Test Userbec7', LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName='testuserbec7@test123321.com',AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u7;
		System.Assert(u7.Id != null, User_Mesage);
		User u8= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbec8@unilever.com', 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName='Test Userbec8', LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName='testuserbec8@test123321.com',AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u8;
		System.Assert(u8.Id != null, User_Mesage);
		System.runAs(u)
		{
			//Insert Account
			Account acc=new Account();
			acc.Name=AcctName;
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//inser Contact
			Contact con=new Contact();
			con.LastName=contactName;
			con.AccountId=acc.Id;
			con.email = emailAddress;
			con.AF_Send_Email_Notification__c = true;
			insert Con;
			System.Assert(Con.Id != null, Contact_Assert_message);
			Contact con1=new Contact();
			con1.LastName=contactName;
			con1.AccountId=acc.Id;
			con1.email = emailAddress1;
			con1.AF_Send_Email_Notification__c = true;
			insert Con1;
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name=AF_Constants.TEST_AF_Category;
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=superCategoryName;
			insert cat;
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name=brandName;
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name=brandEstName;
			brandEst.AF_Status_Base_Fees__c=brandEstStatus;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Locked__c=false; 
			brandEst.AF_Pilot_Model__c=true;
			//insert brandEst;
			List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
			brandEstimateList.add(brandEst);
			insert brandEstimateList;
			AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
			DummyUser__c dummyuser = new DummyUser__c();
			dummyuser.User_id__c = u1.id;
			insert dummyuser;
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : catApprovervalues3
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void catApprovervalues3()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=AF_Constants.TEST_UserName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u;
		System.Assert(u.Id != null, User_Mesage);
		User u1= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress1, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=userName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u1;
		System.Assert(u1.Id != null, User_Mesage);
		User u2= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress3, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName2, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress4,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u2;
		System.Assert(u2.Id != null, User_Mesage);
		User u3= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress5, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName3, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress6,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u3;
		System.Assert(u3.Id != null, User_Mesage);
		User u4= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress7, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName4, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress8,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u4;
		System.Assert(u4.Id != null, User_Mesage);
		User u5= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress9, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName5, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress10,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u5;
		System.Assert(u5.Id != null, User_Mesage);
		User u6= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress11, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName6, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress12,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u6;
		System.Assert(u6.Id != null, User_Mesage);
		User u7= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbec7@unilever.com', 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName='Test Userbec7', LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName='testuserbec7@test123321.com',AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u7;
		System.Assert(u7.Id != null, User_Mesage);
		System.runAs(u)
		{
			//Insert Account
			Account acc=new Account();
			acc.Name=AcctName;
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//inser Contact
			Contact con=new Contact();
			con.LastName=contactName;
			con.AccountId=acc.Id;
			con.email = emailAddress;
			con.AF_Send_Email_Notification__c = true;
			insert Con;
			System.Assert(Con.Id != null, Contact_Assert_message);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name=AF_Constants.TEST_AF_Category;
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=superCategoryName;
			insert cat;
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name=brandName;
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name=brandEstName;
			brandEst.AF_Status_Base_Fees__c=brandEstStatus;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Locked__c=false; 
			brandEst.AF_Pilot_Model__c=true;
			//insert brandEst;
			List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
			brandEstimateList.add(brandEst);
			insert brandEstimateList;
			AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
			DummyUser__c dummyuser = new DummyUser__c();
			dummyuser.User_id__c = u1.id;
			insert dummyuser;
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : catApprovervalues4
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void catApprovervalues4()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=AF_Constants.TEST_UserName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u;
		System.Assert(u.Id != null, User_Mesage);
		User u1= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress1, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=userName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u1;
		System.Assert(u1.Id != null, User_Mesage);
		User u2= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress3, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName2, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress4,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u2;
		System.Assert(u2.Id != null, User_Mesage);
		User u3= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress5, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName3, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress6,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u3;
		System.Assert(u3.Id != null, User_Mesage);
		User u4= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress7, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName4, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress8,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u4;
		System.Assert(u4.Id != null, User_Mesage);
		User u5= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress9, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName5, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress10,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u5;
		System.Assert(u5.Id != null, User_Mesage);
		User u6= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress11, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName6, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress12,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u6;
		System.Assert(u6.Id != null, User_Mesage);
		System.runAs(u)
		{
			//Insert Account
			Account acc=new Account();
			acc.Name=AcctName;
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//inser Contact
			Contact con=new Contact();
			con.LastName=contactName;
			con.AccountId=acc.Id;
			con.email = emailAddress;
			con.AF_Send_Email_Notification__c = true;
			insert Con;
			System.Assert(Con.Id != null, Contact_Assert_message);
			Contact con1=new Contact();
			con1.LastName=contactName;
			con1.AccountId=acc.Id;
			con1.email = emailAddress1;
			con1.AF_Send_Email_Notification__c = true;
			insert Con1;
			Contact con2=new Contact();
			con2.LastName=contactName;
			con2.AccountId=acc.Id;
			con2.email = emailAddress3;
			con2.AF_Send_Email_Notification__c = true;
			insert Con2;
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name=AF_Constants.TEST_AF_Category;
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=superCategoryName;
			insert cat;
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name=brandName;
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name=brandEstName;
			brandEst.AF_Status_Base_Fees__c=brandEstStatus;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Locked__c=false; 
			brandEst.AF_Pilot_Model__c=true;
			//insert brandEst;
			List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
			brandEstimateList.add(brandEst);
			insert brandEstimateList;
			AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
			DummyUser__c dummyuser = new DummyUser__c();
			dummyuser.User_id__c = u1.id;
			insert dummyuser;
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : catApprovervalues5
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void catApprovervalues5()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=AF_Constants.TEST_UserName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u;
		System.Assert(u.Id != null, User_Mesage);
		User u1= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress1, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=userName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u1;
		System.Assert(u1.Id != null, User_Mesage);
		User u2= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress3, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName2, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress4,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u2;
		System.Assert(u2.Id != null, User_Mesage);
		User u3= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress5, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName3, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress6,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u3;
		System.Assert(u3.Id != null, User_Mesage);
		User u4= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress7, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName4, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress8,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u4;
		System.Assert(u4.Id != null, User_Mesage);
		User u5= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress9, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName5, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress10,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u5;
		System.Assert(u5.Id != null, User_Mesage);
		System.runAs(u)
		{
			//Insert Account
			Account acc=new Account();
			acc.Name=AcctName;
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//inser Contact
			Contact con=new Contact();
			con.LastName=contactName;
			con.AccountId=acc.Id;
			con.email = emailAddress;
			con.AF_Send_Email_Notification__c = true;
			insert Con;
			System.Assert(Con.Id != null, Contact_Assert_message);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name=AF_Constants.TEST_AF_Category;
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=superCategoryName;
			insert cat;
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name=brandName;
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name=brandEstName;
			brandEst.AF_Status_Base_Fees__c=brandEstStatus;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Locked__c=false; 
			brandEst.AF_Pilot_Model__c=true;
			//insert brandEst;
			List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
			brandEstimateList.add(brandEst);
			insert brandEstimateList;
			AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
			DummyUser__c dummyuser = new DummyUser__c();
			dummyuser.User_id__c = u1.id;
			insert dummyuser;
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : catApprovervalues6
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void catApprovervalues6()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=AF_Constants.TEST_UserName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u;
		System.Assert(u.Id != null, User_Mesage);
		User u1= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress1, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=userName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u1;
		System.Assert(u1.Id != null, User_Mesage);
		User u2= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress3, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName2, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress4,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u2;
		System.Assert(u2.Id != null, User_Mesage);
		User u3= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress5, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName3, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress6,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u3;
		System.Assert(u3.Id != null, User_Mesage);
		User u4= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress7, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName4, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress8,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u4;
		System.Assert(u4.Id != null, User_Mesage);
		System.runAs(u)
		{
			//Insert Account
			Account acc=new Account();
			acc.Name=AcctName;
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//inser Contact
			Contact con=new Contact();
			con.LastName=contactName;
			con.AccountId=acc.Id;
			con.email = emailAddress;
			con.AF_Send_Email_Notification__c = true;
			insert Con;
			System.Assert(Con.Id != null, Contact_Assert_message);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name=AF_Constants.TEST_AF_Category;
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=superCategoryName;
			insert cat;
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name=brandName;
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name=brandEstName;
			brandEst.AF_Status_Base_Fees__c=brandEstStatus;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Locked__c=false; 
			brandEst.AF_Pilot_Model__c=true;
			//insert brandEst;
			List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
			brandEstimateList.add(brandEst);
			insert brandEstimateList;
			AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
			DummyUser__c dummyuser = new DummyUser__c();
			dummyuser.User_id__c = u1.id;
			insert dummyuser;
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : catApprovervalues7
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void catApprovervalues7()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=AF_Constants.TEST_UserName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u;
		System.Assert(u.Id != null, User_Mesage);
		User u1= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress1, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=userName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u1;
		System.Assert(u1.Id != null, User_Mesage);
		User u2= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress3, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName2, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress4,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u2;
		System.Assert(u2.Id != null, User_Mesage);
		User u3= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress5, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName3, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress6,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u3;
		System.Assert(u3.Id != null, User_Mesage);
		System.runAs(u)
		{
			//Insert Account
			Account acc=new Account();
			acc.Name=AcctName;
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//inser Contact
			Contact con=new Contact();
			con.LastName=contactName;
			con.AccountId=acc.Id;
			con.email = emailAddress;
			con.AF_Send_Email_Notification__c = true;
			insert Con;
			System.Assert(Con.Id != null, Contact_Assert_message);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name=AF_Constants.TEST_AF_Category;
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=superCategoryName;
			insert cat;
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name=brandName;
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name=brandEstName;
			brandEst.AF_Status_Base_Fees__c=brandEstStatus;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Locked__c=false; 
			brandEst.AF_Pilot_Model__c=true;
			//insert brandEst;
			List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
			brandEstimateList.add(brandEst);
			insert brandEstimateList;
			AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
			DummyUser__c dummyuser = new DummyUser__c();
			dummyuser.User_id__c = u1.id;
			insert dummyuser;
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : catApprovervalues8
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void catApprovervalues8()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=AF_Constants.TEST_UserName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u;
		System.Assert(u.Id != null, User_Mesage);
		User u1= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress1, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=userName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u1;
		System.Assert(u1.Id != null, User_Mesage);
		User u2= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress3, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName2, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=emailAddress4,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u2;
		System.Assert(u2.Id != null, User_Mesage);
		System.runAs(u)
		{
			//Insert Account
			Account acc=new Account();
			acc.Name=AcctName;
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//inser Contact
			Contact con=new Contact();
			con.LastName=contactName;
			con.AccountId=acc.Id;
			con.email = emailAddress;
			con.AF_Send_Email_Notification__c = true;
			insert Con;
			System.Assert(Con.Id != null, Contact_Assert_message);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name=AF_Constants.TEST_AF_Category;
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=superCategoryName;
			insert cat;
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name=brandName;
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name=brandEstName;
			brandEst.AF_Status_Base_Fees__c=brandEstStatus;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Locked__c=false; 
			brandEst.AF_Pilot_Model__c=true;
			//insert brandEst;
			List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
			brandEstimateList.add(brandEst);
			insert brandEstimateList;
			AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
			DummyUser__c dummyuser = new DummyUser__c();
			dummyuser.User_id__c = u1.id;
			insert dummyuser;
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : catApprovervalues9
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void catApprovervalues9()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=AF_Constants.TEST_UserName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u;
		System.Assert(u.Id != null, User_Mesage);
		User u1= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress1, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=lastName, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=userName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u1;
		System.Assert(u1.Id != null, User_Mesage);
		System.runAs(u)
		{
			//Insert Account
			Account acc=new Account();
			acc.Name=AcctName;
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//inser Contact
			Contact con=new Contact();
			con.LastName=contactName;
			con.AccountId=acc.Id;
			con.email = emailAddress;
			con.AF_Send_Email_Notification__c = true;
			insert Con;
			System.Assert(Con.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name=AF_Constants.TEST_AF_Category;
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=superCategoryName;
			insert cat;
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name=brandName;
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name=brandEstName;
			brandEst.AF_Status_Base_Fees__c=brandEstStatus;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Locked__c=false; 
			brandEst.AF_Pilot_Model__c=true;
			//insert brandEst;
			List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
			brandEstimateList.add(brandEst);
			insert brandEstimateList;
			AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
			DummyUser__c dummyuser = new DummyUser__c();
			dummyuser.User_id__c = u1.id;
			insert dummyuser;
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
			Test.stopTest();
		}
	}
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : catApprovervalues10
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void catApprovervalues10()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = AF_Constants.TEST_Alias, Email=emailAddress, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.LocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
		UserName=AF_Constants.TEST_UserName,AF_Brand__c=brandName,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u;
		System.Assert(u.Id != null, User_Mesage);
		System.runAs(u)
		{
			//Insert Account
			Account acc=new Account();
			acc.Name=AcctName;
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, AF_Constants.TEST_ASSERT_MSG);
			//inser Contact
			Contact con=new Contact();
			con.LastName=contactName;
			con.AccountId=acc.Id;
			con.email = emailAddress;
			con.AF_Send_Email_Notification__c = true;
			insert Con;
			System.Assert(Con.Id != null, Contact_Assert_message);
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name=AF_Constants.TEST_AF_Category;
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c=superCategoryName;
			insert cat;
			System.Assert(cat.Id != null, 'The Category record  inserted');
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c bran=new AF_Category_Brand__c();
			bran.RecordTypeId=brandRT.Id;
			bran.AF_Pilot_Model__c=false;    
			bran.Name=brandName;
			bran.AF_Category_Brands__c=cat.Id;
			insert bran;
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEst=new AF_Brand_Estimate__c();
			brandEst.AF_Agency__c=acc.Id;               
			brandEst.Name=brandEstName;
			brandEst.AF_Status_Base_Fees__c=brandEstStatus;  
			brandEst.Brand__c=bran.id;
			brandEst.AF_Locked__c=false; 
			brandEst.AF_Pilot_Model__c=true;
			//insert brandEst;
			List<AF_Brand_Estimate__c> brandEstimateList = new List<AF_Brand_Estimate__c>();
			brandEstimateList.add(brandEst);
			insert brandEstimateList;
			AF_Brand_Estimate__c queryBrand = [select id,AF_Agency__c,AF_AgencyUsers1__c,AF_AgencyUsers2__c,AF_AgencyUsers3__c from AF_Brand_Estimate__c where id IN :brandEstimateList];
			DummyUser__c dummyuser = new DummyUser__c();
			dummyuser.User_id__c = u.id;
			insert dummyuser;
			AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(brandEstimateList);
			AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagency(queryBrand);
			Test.stopTest();
		}
	}
}