/**
 * Name:        -   AA_ApplicationWrapperObj_Test
 * @description -   This is the test class for AA_ApplicationWrapperObj class to verify the code for adding data to the Application Wrapper object.
 * @Author      -   Aslesha R K     
 */
@isTest
private class AA_ApplicationWrapperObj_Test {
/*******************************************************************
Purpose: Method to test if we could add data to the Application Wrapper Object.
********************************************************************/
    static testMethod void myUnitTest() {
        AA_ApplicationWrapperObj obj = new AA_ApplicationWrapperObj();
        obj.errorCode='test';
        obj.isAcceptedTermsCondition=true;
        obj.message='test';
        AA_WrapperUtility.AgentAppDataRequest datarequest=new AA_WrapperUtility.AgentAppDataRequest();
        obj.objAgentAppDataRequest=datarequest;
        AA_WrapperUtility.AgentAppDataResponse dataresponse=new AA_WrapperUtility.AgentAppDataResponse();
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
        obj.TotalAgentReportsCount=3;
        List<AA_WrapperClass.agentReportDetail>  agentReportsData=new List<AA_WrapperClass.agentReportDetail>();
        obj.objAgentReportsData=agentReportsData;
        system.assert(obj!=null);
                
    }
}