/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_SendCurrencyReminder
@Created Date : 08/08/2014.
@Description : This Test class for  AF_SendCurrencyReminder  apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class Test_AF_SendCurrencyReminder 
{
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : AFCurrencySchedulable
*  @param : none
*  @return : none
*************************************************************************/  
    static testmethod void AFCurrencySchedulable()
    {
        test.starttest();
        af_SendCurrencyReminder sch=new af_SendCurrencyReminder();
        System.Assert(sch!= null, 'The CurrencyReminder record not inserted');
        Database.BatchableContext BC ;
        SchedulableContext ctx;
        sch.execute(ctx);
        sch.finish(BC);
        test.stoptest();
    }
}