/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Sendemail_categoryfinance_Test
@Created Date : 08/08/2014.
@Description : This Test class for  AF_Sendemail_categoryfinance apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_Sendemail_categoryfinance_Test
{ 
	static user userforcategoryfinance;
	private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : sendMailCatFinance
*  @param : none
*  @return : none
*************************************************************************/  
	Static testMethod void sendMailCatFinance()
	{
		Test.startTest();
		userforcategoryfinance=AF_TestFactory_Helper.createAgency(true);
		User u=[SELECT id,Email FROM user WHERE id=:userforcategoryfinance.id LIMIT 1];
		PermissionSet per = [SELECT Id,Name FROM PermissionSet where Name=:AF_Constants.PERM_FINANCE_CAT];
		PermissionSetAssignment pa = new PermissionSetAssignment();
		pa.PermissionSetId = per.id;
		pa.AssigneeId = u.id;
		insert pa;
		System.runAs(u)
		{
			System.assert(u.Id!=null,AF_TestFactory_Helper.USER_RECORD);
			AF_Sendemail_categoryfinance sendMailCatFin=new AF_Sendemail_categoryfinance();
			try{
				sendMailCatFin.send();
			}catch(exception e){
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'sendMailCatFinance',e.getMessage(),e.getTypeName(),e.getStackTraceString());
			}
			sendMailCatFin.closePopup();            
		}
		Test.stopTest();
	}
}