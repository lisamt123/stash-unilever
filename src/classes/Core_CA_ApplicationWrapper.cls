global class Core_CA_ApplicationWrapper extends Core_CA_BaseApplicationWrapper{
    
    public String serviceName {get;set;}
    public String urlParameters {get;set;}
    public String serviceJSONObjectasString{get;set;}
    public String requestType{get;set;}
    public Core_CA_WrapperUtility.MyApprovalsDataRequest myApprovalsDataRequest {get;set;}    
    public Core_CA_WrapperUtility.LineItemDetailRequest lineItemDetailRequest {get;set;}    
    public Core_CA_WrapperUtility.ExpenseDetailsDataRequest expenseDetailRequest {get;set;}
    public Core_CA_WrapperUtility.MyApprovalPostRequest myApprovalPostRequest {get;set;}
    
    
}