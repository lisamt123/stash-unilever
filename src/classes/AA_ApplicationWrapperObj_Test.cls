@isTest
private class AA_ApplicationWrapperObj_Test {

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
        system.assert(obj!=null);
    }
}