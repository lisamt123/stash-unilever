@isTest
public class AA_TheAgentSingleExecution_Test {

    static testMethod void hasAlreadyDoneTest() {
        Boolean res = AA_TheAgentSingleExecution.hasAlreadyDone();
        AA_TheAgentSingleExecution.setAlreadyDone();
        AA_TheAgentSingleExecution.forceResetAlreadyDone();
        system.assertEquals(res,false);
    }
}