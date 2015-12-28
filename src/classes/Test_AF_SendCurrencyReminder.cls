/**
 * Test_AF_SendCurrencyReminder: This Test class for af_SendCurrencyReminder apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_SendCurrencyReminder 
{
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