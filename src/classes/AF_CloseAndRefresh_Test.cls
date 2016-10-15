/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_CloseAndRefresh_Test
@CreateDate : 13/9/2014
@Description : This is a Test class for AF_CloseAndRefresh class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_CloseAndRefresh_Test
{ 
	static user CloseAndRefresh;
	/***********************************************************************************
*  @Description: this method will the test data
*  @name : closeandRefresh
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void AFcloseandRefresh()
	{
		Test.startTest();
		CloseAndRefresh = AF_TestFactory_Helper.createUserAdmin(true);
		User u=[SELECT id,Email FROM user WHERE id=:CloseAndRefresh.id LIMIT 1];
		System.runAs(u)
		{ 
			System.Assert(u.Id != null, AF_TestFactory_Helper.USER_RECORD);
			ApexPages.currentPage().getParameters().put('IsError','false');      
			ApexPages.currentPage().getParameters().put('IsError','true');     
			ApexPages.currentPage().getParameters().put('ErrorMessage','error');
			AF_CloseAndRefresh  Refresh =new AF_CloseAndRefresh ();
			Test.stopTest();
		}
	}
}