/****************************************************************************************************************************
   @Author: Cognizant
   @Name: IPM_Global_Consolidated_Controller
   @Created Date: 26/10/2015
   @Description: Controller Consolidated View of Summary
   @Version: 1.0 
   @Reference: IPM_Global_Consolidated Component
*/
public with sharing class IPM_Global_Consolidated_Controller{
    public List<IPM_Project_Document_Section__c> summaryList{get;set;}
    public Id projectId{
        get {
            return projectId; // to get the project ID from the component used from Gate document page
        }
        set {
            projectId= value;// setting the value of project Id
            getSummary();
        }
    }
    public String secExtId{get; set;}
    public String gateDocument{get; set;}
    public void getSummary(){
        try{
            summaryList=new List<IPM_Project_Document_Section__c>();
            summaryList=[SELECT IPM_PDP_Document_Summary__c,IPM_Gate_Document_Summary__c,IPM_Project_Document__r.IPM_Project__r.IPM_Project_Name__c 
                         FROM IPM_Project_Document_Section__c
                         WHERE IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c=:projectId AND IPM_Master_Section_External_Id__c=:secExtId
                               AND IPM_Project_Document__r.IPM_GateDocuments__c=:gateDocument];
        }
           catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ConstantUtils.IPM_GLOBAL_CONSOLIDATED_CONTROLLER_STR ,
                    IPM_ConstantUtils.GET_SUMMARY_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }   
    }
}