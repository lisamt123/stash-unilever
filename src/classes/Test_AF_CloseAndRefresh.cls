/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_CloseAndRefresh
@CreateDate : 13/9/2014
@Description : This is a Test class for AF_CloseAndRefresh class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class Test_AF_CloseAndRefresh
{ 
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : closeandRefresh
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void closeandRefresh()
	{
		Test.startTest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		//Insert User 
		User u= new User(Alias = 'testcr', Email='standardusercr@unilever.com', 
		EmailEncodingKey='UTF-8', LastName='Test Usercr', LanguageLocaleKey='en_US', 
		LocaleSidKey='en_US', ProfileId = p.Id, 
		TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
		UserName='testusercr@test123321.com',AF_Brand__c='Test Brandcr',AF_Category__c='Test Beveragescr');
		insert u;        
		System.Assert(u.Id != null, 'The User record not inserted');
		System.runAs(u)
		{ 
			ApexPages.currentPage().getParameters().put('IsError','false');      
			ApexPages.currentPage().getParameters().put('IsError','true');     
			ApexPages.currentPage().getParameters().put('ErrorMessage','error');        
		}
		AF_CloseAndRefresh  Refresh =new AF_CloseAndRefresh ();
		Test.stopTest();
	}
}