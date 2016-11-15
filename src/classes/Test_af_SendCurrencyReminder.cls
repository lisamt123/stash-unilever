/**
 * Test_af_SendCurrencyReminder: This Test class for af_SendCurrencyReminder apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_af_SendCurrencyReminder 
{
static testmethod void AFCurrencySchedulable()
{
test.starttest();

af_SendCurrencyReminder sch=new af_SendCurrencyReminder();


Database.BatchableContext BC ;
SchedulableContext ctx;
sch.execute(ctx);
sch.finish(BC);
test.stoptest();
}
}