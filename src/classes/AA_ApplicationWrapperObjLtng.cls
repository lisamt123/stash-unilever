public class AA_ApplicationWrapperObjLtng extends AA_BaseApplicationWrapperObj{
    public String status {get;set;}
    public String serviceName {get;set;}
    public String urlParameters {get;set;}
    public String requestType {get;set;}
    public String serviceJSONObjectasString {get;set;}
    public boolean isAcceptedTermsCondition {get;set;}
    //public Agent_App__c agentReportToInsert {get;set;}
    @AuraEnabled 
   public AA_WrapperClass.AgentAppDataRequest objAgentAppDataRequest {get;set;}
    //Public AA_WrapperUtility.AllAgentReports objGetAgentDataResponse {get;set;}
    Public AA_WrapperClass.AgentAppDataResponse objGetAgentDataResponse{get;set;}
    Public AA_WrapperClass.AgentAppFilterRequest objAgentAppFilterDataRequest{get;set;}
    Public List<AA_WrapperUtility.agentReportDetail> objPassAgentReportsToNG{get;set;}
    public Integer TotalAgentReports;
    public Boolean UpdateLikeCount;
    
    @AuraEnabled
    Public List<AA_WrapperClass.agentReportDetail> objAgentReportsData{get;set;}
    @AuraEnabled
    public Integer TotalAgentReportsCount{get;set;}
    
}