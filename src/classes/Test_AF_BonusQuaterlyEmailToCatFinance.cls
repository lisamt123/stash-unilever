/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_BonusQuaterlyEmailToCatFinance
@CreateDate : 22/9/2014
@Description : This is a Test class for AF_BonusQuaterlyEmailToCatFinance class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class Test_AF_BonusQuaterlyEmailToCatFinance
{     /***********************************************************************************
*  @Description: this method will the test data
*  @name : AFCallingSchedulable
*  @param : none.
*  @return: none.
*************************************************************************************/
	Static testMethod void AFCallingSchedulable()
	{
		Test.StartTest();
		AF_BonusQuarterly__c customList = new AF_BonusQuarterly__c();
		customList.AF_BonusQuarterlyDate__c = system.today();
		insert customList;
		System.Assert(customList.Id != null, 'The custom record not inserted');
		AF_BonusQuaterlyEmailToCatFinance obj = new AF_BonusQuaterlyEmailToCatFinance();
		Datetime dt = Datetime.now().addMinutes(1);
		String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
		String jobId = System.schedule('Sample_Heading', CRON_EXP, obj); 
		Database.BatchableContext BC ;
		obj.finish(BC);
		//obj.start(BC);
		Test.stopTest();
	}
}