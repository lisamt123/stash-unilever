/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_ViewAllController_Test 
@CreateDate : 16/9/2014
@Description : This is a Test class for AF_ViewAllController apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_ViewAllController_Test
{ 
	public static final string DParentId ;
	public static final string CParentId ;
	public static final string CHParentId;
	public static Boolean ViewComments;
	public static Boolean ViewDocuments;
	public static Boolean ViewChangeHistory;
	public static Boolean agencyEstimate;
	public static Boolean oopEstimate;
	public static Boolean bonusEstimate;
	public static user userForviewallcontroller;
	/***********************************************************************************
*  @Description: this method will have the test data.
*  @name : AFViewAllController
*  @param : none.
*  @return: none.
*************************************************************************************/
	static testmethod void AFViewAllController()
	{
		Test.startTest();
		userForviewallcontroller=AF_TestFactory_Helper.createUserAdmin(true);
		User u=[SELECT id FROM user WHERE id=:userForviewallcontroller.id LIMIT 1];
		System.runAs(u)
		{ 
			System.Assert(u.Id != null, AF_TestFactory_Helper.USER_RECORD);
			AF_ViewAllController  viewall = new AF_ViewAllController();
			viewall.CParentId ='14256';
			viewall.DParentId ='4654';
			viewall.CHParentId='3232';
			viewall.ViewComments=true;
			viewall.ViewDocuments=true;
			viewall.ViewChangeHistory=true;
			viewall.agencyEstimate=true;
			viewall.oopEstimate=true;
			viewall.bonusEstimate=true;
			Test.stopTest();
		}
	}
}