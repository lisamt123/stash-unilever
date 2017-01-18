@isTest
/**
 * Name:        -   AA_TheAgentSingleExecution_Test
 * @description -   This is test class for AA_TheAgentReportWrapper class which includes all functionalities related to chatter
 * @Author      -   Aslesha R K     
 */

public class AA_TheAgentSingleExecution_Test {


    /**
     * @date        -   19/09/2015
     * @description -   Test class to test the method hasAlreadyDone
     * @param       -   None 
     * @return      -   None
     * @modifiedby  -
     */  
    static testMethod void hasAlreadyDoneTest() {
        Boolean res = AA_TheAgentSingleExecution.hasAlreadyDone();
        AA_TheAgentSingleExecution.setAlreadyDone();
        AA_TheAgentSingleExecution.forceResetAlreadyDone();
        system.assertEquals(res,false);
    }
}