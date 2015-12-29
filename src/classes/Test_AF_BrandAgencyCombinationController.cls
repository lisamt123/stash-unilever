/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_BrandAgencyCombinationController
@CreateDate : 12/9/2014
@Description : This is a Test class for AF_BrandAgencyCombinationController class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class Test_AF_BrandAgencyCombinationController
{    
	Static Integer IcurrYear = System.Today().year();
	Static string currYear=string.valueof(IcurrYear);
	Static Integer IcurrYear1 = System.Today().year()-1;
	Static string currYear1=string.valueof(IcurrYear1);
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : afBrandAgencyCombinationController
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void afBrandAgencyCombinationController()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
		EmailEncodingKey='UTF-8', LastName='Test User123', LanguageLocaleKey='en_US', 
		LocaleSidKey='en_US', ProfileId = p.Id, 
		TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
		UserName='testuser@test123321.com',AF_Brand__c='Test Brand',AF_Category__c='Test Beverages');
		insert u;        
		System.runAs(u)
		{ 
			//Insert Account
			Account acc=new Account();
			acc.Name='Test Agency';
			acc.published__c=true;
			insert acc;
			System.Assert(acc.Id != null, 'The Account record not inserted');
			//Insert Category
			RecordType catRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Category' Limit 1];
			AF_Category_Brand__c cat=new AF_Category_Brand__c();
			cat.RecordTypeId=catRT.Id;
			cat.Name='Test Beverages';
			cat.AF_Pilot_Model__c=false;     
			cat.AF_Super_category__c='Drinks';
			insert cat;
			System.Assert(cat.Id != null, 'The category record not inserted');
			//Insert Brand
			RecordType brandRT = [select id,Name from RecordType where SobjectType='AF_Category_Brand__c' and Name='Brand' Limit 1];
			AF_Category_Brand__c brand=new AF_Category_Brand__c();
			brand.RecordTypeId=brandRT.Id;
			brand.AF_Pilot_Model__c=false;    
			brand.Name='Test Brand';
			brand.AF_Category_Brands__c=cat.Id;
			insert brand;
			System.Assert(brand.Id != null, 'The Brand record not inserted');
			//Insert Brand Estimate                  
			AF_Brand_Estimate__c brandEstimate=new AF_Brand_Estimate__c();
			brandEstimate.AF_Agency__c=acc.Id;               
			brandEstimate.Name='Test Brand';
			brandEstimate.AF_Status_Base_Fees__c='Initiate';  
			brandEstimate.AF_Fiscal_Year__c='currYear1';
			brandEstimate.Brand__c=brand.id;
			brandEstimate.AF_Adaptive__c=20;
			brandEstimate.AF_Digital__c=20;
			brandEstimate.AF_Traditional__c=20;    
			brandEstimate.AF_Cat_Finance_Approver_1__c=u.Id;    
			insert brandEstimate;
			System.Assert(brandEstimate.Id != null, 'The brandEstimate record not inserted');
			//  ApexPages.StandardController sc = new ApexPages.StandardController(brand);
			//  ApexPages.currentPage().getParameters().put('id',brand.id);      
			//Instantiating the Class AfBrandAgencyCombinationController  
			ApexPages.currentPage().getParameters().put('Year',currYear);  
			AF_BrandAgencyCombinationController brandAg=new AF_BrandAgencyCombinationController();
			brandAg.selectedoption=brand.Id+'::'+brand.Name;
			brandAg.selectedoptionAgency=acc.Id+'::'+acc.Name;
			brandAg.Save();
			brandAg.closePopup();
			ApexPages.currentPage().getParameters().put('Year','currYear1');  
			AF_BrandAgencyCombinationController brandAg1=new AF_BrandAgencyCombinationController();
			Test.stopTest(); 
		}
	}
}