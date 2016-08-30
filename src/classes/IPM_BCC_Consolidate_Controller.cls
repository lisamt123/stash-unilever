/*****************************************************************
@Description:used for Business case confirmation
@Created Date: 15/04/2015
@Author: Cognizant
@Referenced: IPM_Bcc_Consolidate Component for Local BB  document
******************************************************************/

public with sharing class IPM_BCC_Consolidate_Controller
{ 
    public Id projId; // used to store project id
    public ID getprojId(){ return projId; } //get project id
    public IPM_Financial__c financial;
    public static final String CORE_STRATEGIC_INNOVATION='Innovation';
    public static final String Year ='3';
    public void setprojId (ID p){ // set project id
        projId= p;
        showBCC();
    }
    public transient List<IPM_Financial__c> localFinancialList{get; set;} //used to store query result from IPM_Financial__c object
    public transient IPM_Project__c project{get; set;} //used to store query result from IPM_Project__c object
    public Integer localProjectsCount{get; set;} //used to store count of project where parent project id is equal to current project id
    public String projectSpan{get; set;} // used to store span value of the project
    public String gateDocType{get;set;} // to the the type of gate
    /*********************************************************************
    @Description: used for fetching local project count and local financial list
    @Created Date: 15/04/2015
    @Author: Cognizant
    @param: Not Applicable
    @Referenced: IPM_Bcc_Consolidate Component
    *********************************************************************/
    
    public void showBCC(){
        localProjectsCount=0;
        localFinancialList=new List<IPM_Financial__c>();
        
        if(projectSpan==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && projId!=null){
            localProjectsCount=[SELECT Count() FROM IPM_Project__c WHERE IPM_Parent_Project__r.IPM_Parent_Project__c=:projId];
            if(localProjectsCount>0) {
                localFinancialList=[SELECT Id,Local_Project__c,Local_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.Rollout_Plan_Target_Launch_Date__c,
                                           Regional_Project__c,Regional_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.name,
                                           Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c,Is_BC_Confirmed_Capability__c 
                                    FROM IPM_Financial__c 
                                    WHERE isActive__c=true and Regional_Project__r.IPM_Parent_Project__c=:projId and Local_Project_isNull__c = :IPM_ConstantUtils.IPM_false];
                }
        }
        else if(projectSpan==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && projId!=null){
            localProjectsCount=[SELECT Count() FROM IPM_Project__c WHERE IPM_Parent_Project__c=:projId];
            if(localProjectsCount>0) {
                localFinancialList=[SELECT Id,Local_Project__c,Local_Project__r.IPM_Phase__c,Local_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.Rollout_Plan_Target_Launch_Date__c,Regional_Project__c,Regional_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.name,
                                           Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c,Is_BC_Confirmed_Capability__c,
                                       (SELECT Turnover_Regional__c,Turnover_Contract__c,Turnover_MR__c,Advertising_Promotions_Regional__c,Advertising_Promotions_Contract__c,
                                        Advertising_Promotions_MR__c,GM_of_TO_Regional__c,GM_of_TO_Contract__c,GM_of_TO_MR__c 
                                    FROM IPM_Financial_Years__r 
                                    WHERE Year_Type__c=: CORE_STRATEGIC_INNOVATION AND Year__c=: Year)
                                    FROM IPM_Financial__c 
                                    WHERE isActive__c=true and Regional_Project__c=:projId and Local_Project_isNull__c = :IPM_ConstantUtils.IPM_false] ;
                }       
         
                                 
        }
        else if(projectSpan==IPM_ConstantUtils.PROJECT_SPAN_LOCAL && projId!=null){
            localFinancialList=[SELECT Id,Local_Project__c,Local_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.Rollout_Plan_Target_Launch_Date__c,
                                       Regional_Project__c,Regional_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.name,
                                       Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c,Is_BC_Confirmed_Capability__c 
                                FROM IPM_Financial__c 
                                WHERE isActive__c=true and Local_Project__c=:projId];
        }
    }          
}
