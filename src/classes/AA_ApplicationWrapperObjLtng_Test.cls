/**
 * Name:        -   AA_ApplicationWrapperObjLtng_Test
 * @description -   This is the test class for AA_ApplicationWrapperObj class to verify the code for adding data to the Application Wrapper object.
 * @Author      -   Ipsita s. Patra    
 */
@isTest
private class AA_ApplicationWrapperObjLtng_Test {
/*******************************************************************
Purpose: Method to test if we could add data to the Application Wrapper Object.
********************************************************************/
    static testMethod void myUnitTest() {
       AA_ApplicationWrapperObjLtng obj = new AA_ApplicationWrapperObjLtng ();
        obj.errorCode='test';
        obj.isAcceptedTermsCondition=true;
        obj.message='test';
        AA_WrapperClass.AgentAppDataRequest datarequest=new AA_WrapperClass.AgentAppDataRequest();
        obj.objAgentAppDataRequest=datarequest;
        AA_WrapperClass.AgentAppDataResponse dataresponse=new AA_WrapperClass.AgentAppDataResponse();
        obj.objGetAgentDataResponse=dataresponse;
        List<AA_WrapperUtility.agentReportDetail> lstDatarequest=new List<AA_WrapperUtility.agentReportDetail>();        
        obj.objPassAgentReportsToNG=lstDatarequest;
        obj.requestType='post';
        obj.serviceJSONObjectasString='test';
        obj.serviceName='testservice';
        obj.status='new';
        obj.TotalAgentReports=3;
        obj.UpdateLikeCount=true;
        obj.urlParameters='test';
        system.assert(obj!=null);
    }
}