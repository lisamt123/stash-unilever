global class AA_ApplicationWrapperObj extends AA_BaseApplicationWrapperObj{
    public String status {get;set;}
    public String serviceName {get;set;}
    public String urlParameters {get;set;}
    public String requestType {get;set;}
    public String serviceJSONObjectasString {get;set;}
    public boolean isAcceptedTermsCondition {get;set;}
    //public Agent_App__c agentReportToInsert {get;set;}
    Public AA_WrapperUtility.AgentAppDataRequest objAgentAppDataRequest {get;set;}
    //Public AA_WrapperUtility.AllAgentReports objGetAgentDataResponse {get;set;}
    Public AA_WrapperUtility.AgentAppDataResponse objGetAgentDataResponse{get;set;}
    Public List<AA_WrapperUtility.agentReportDetail> objPassAgentReportsToNG{get;set;}
    public Integer TotalAgentReports;
    public Boolean UpdateLikeCount;
}