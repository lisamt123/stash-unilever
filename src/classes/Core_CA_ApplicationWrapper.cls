/*
  Class Name: Core_CA_ApplicationWrapper
  Author : Mindtree
  Date: 4 August 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: group wrapper request data used for both Chatter Approval & Ideation
*/
global class Core_CA_ApplicationWrapper extends Core_CA_BaseApplicationWrapper{
    
    public String serviceName {get;set;}
    public String urlParameters {get;set;}
    public String serviceJSONObjectasString{get;set;}
    public String requestType{get;set;}
    
    //Chatter Approval Wrapper instances
    public Core_CA_WrapperUtility.MyApprovalsDataRequest myApprovalsDataRequest {get;set;}    
    public Core_CA_WrapperUtility.LineItemDetailRequest lineItemDetailRequest {get;set;}    
    public Core_CA_WrapperUtility.ExpenseDetailsDataRequest expenseDetailRequest {get;set;}
    public Core_CA_WrapperUtility.MyApprovalPostRequest myApprovalPostRequest {get;set;}
    
    //Ideation Wrapper instances
    public Core_IC_WrapperUtility.IdeaLandingPageRequest ideaLandingPageRequest {get;set;}
    public Core_IC_WrapperUtility.VoteForIdeasOfTheWeekRequest voteForIdeasOfTheWeekRequest {get;set;}
    public Core_IC_WrapperUtility.IdeaCampaignDetailRequest ideaCampaignDetailRequest {get;set;}
    public Core_IC_WrapperUtility.IdeaDetailRequest ideaDetailRequest {get;set;}
    public Core_IC_WrapperUtility.IdeaCommentRequest ideaCommentRequest {get;set;}
    public Core_IC_WrapperUtility.SubmitIdeaRequest submitIdeaRequest {get;set;}
    
    
}