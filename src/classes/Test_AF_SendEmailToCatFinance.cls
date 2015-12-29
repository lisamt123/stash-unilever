/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_SendEmailToCatFinance
@Created Date : 08/08/2014.
@Description : This Test class for  AF_SendEmailToCatFinance apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class Test_AF_SendEmailToCatFinance
{  
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : AFCallingSchedulable
*  @param : none
*  @return : none
*************************************************************************/  
	Static testMethod void AFCallingSchedulable()
	{
		Test.StartTest();
		AF_CatFinanceThreshold__c customList = new AF_CatFinanceThreshold__c();
		customList.AF_Date__c = system.today();
		insert customList;
		System.Assert(customList.Id != null, 'The customsetting record not inserted');
		AF_SendEmailToCatFinance obj = new AF_SendEmailToCatFinance();
		//obj.query=null;
		Datetime dt = Datetime.now().addMinutes(1);
		String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
		String jobId = System.schedule('Sample_Heading', CRON_EXP, obj); 
		Database.BatchableContext BC ;
		obj.finish(BC);
		Test.stopTest();
	}
}