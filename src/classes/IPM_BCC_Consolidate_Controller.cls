/*****************************************************************
@Description:used for Business case confirmation
@Created Date: 15/04/2015
@Author: Cognizant
@Referenced: IPM_Bcc_Consolidate Component for Local BB  document
******************************************************************/

public with sharing class IPM_BCC_Consolidate_Controller
{ 
    public Id projId{ // to get-set the project id from the component attribute.
        get{
            if(projId == null && Apexpages.currentpage().getparameters().get('projectId') != null) {
                return  Id.valueOf(Apexpages.currentpage().getparameters().get('projectId')) ;
            }
            else { return projId; }
        }
        set;
    }  // used to store project id
    public String projectSpan{// to get-set the project document section id from the component attribute.
        get{
            if(projectSpan == null && Apexpages.currentpage().getparameters().get('projSpan') != null) {
                return  Apexpages.currentpage().getparameters().get('projSpan');
            }
            else { return projectSpan; }
        }
        set;
    } // used to store span value of the project
    public String projSpan{// to get-set the project document section id from the component attribute.
        get{
            if(projSpan == null && Apexpages.currentpage().getparameters().get('projSpan') != null) {
                return  Apexpages.currentpage().getparameters().get('projSpan');
            }
            else { return projSpan; }
        }
        set;
    } // created while converting the component to page. This is used in page while projectSpan in used in controller
    public String gateDocType{// to get-set the project document section id from the component attribute.
        get{
            if(gateDocType == null && Apexpages.currentpage().getparameters().get('gateType') != null) {
                return  Apexpages.currentpage().getparameters().get('gateType');
            }
            else { return gateDocType; }
        }
        set;
    } // to the the type of gate
    public boolean showBccTable{
        get {
            if(showBccTable == null) {
                if(Apexpages.currentpage().getparameters().get('showBccTab') == IPM_ConstantUtils.IPM_true) {return true; }
                else { return false; }
            }
            else { return showBccTable; }
        }
        set;
    } // colomn visibility 
    
    public IPM_Financial__c financial;
    public static final String CORE_STRATEGIC_INNOVATION='Innovation';
    public static final String Year ='3';
    public transient List<IPM_Financial__c> localFinancialList{get; set;} //used to store query result from IPM_Financial__c object
    public transient IPM_Project__c project{get; set;} //used to store query result from IPM_Project__c object
    public Integer localProjectsCount{get; set;} //used to store count of project where parent project id is equal to current project id
    
    /************************************************************************************************************************
    * @Description: Methods to run when this controller is invoked from component
    */
    public string getInvokeMethodsForComponent() {
        showBCC();
        return 'Required methods are invoked for component';
    }
    
    /************************************************************************************************************************
    * @Description: CONSTRUCTOR
    */
    public IPM_BCC_Consolidate_Controller() {
        if(test.isRunningTest()){
            getInvokeMethodsForComponent();
        }
    }   
    
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
                                           Regional_Project__c,Regional_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.name,Contract_Approved__c,MR_Approved__c, 
                                           Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c,Is_BC_Confirmed_Capability__c
                                    FROM IPM_Financial__c 
                                    WHERE isActive__c=true and Regional_Project__r.IPM_Parent_Project__c=:projId and Local_Project_isNull__c = :IPM_ConstantUtils.IPM_false];
                }
             else if(showBccTable)
             {
                   localFinancialList=[SELECT Id,Local_Project__r.IPM_Phase__c,Local_Project__c,Local_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.Rollout_Plan_Target_Launch_Date__c,
                                           Regional_Project__c,Regional_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.name,
                                           Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c,Is_BC_Confirmed_Capability__c,Contract_Approved__c, MR_Approved__c,
                                            (SELECT Turnover_Regional__c,Turnover_Contract__c,Turnover_MR__c,Advertising_Promotions_Regional__c,Advertising_Promotions_Contract__c,
                                        Advertising_Promotions_MR__c,GM_of_TO_Regional__c,GM_of_TO_Contract__c,GM_of_TO_MR__c,Turnover_Global__c,Advertising_Promotions_Global__c,GM_of_TO_Global__c 
                                    FROM IPM_Financial_Years__r 
                                    WHERE Year_Type__c=: CORE_STRATEGIC_INNOVATION AND Year__c=: Year)
                                    FROM IPM_Financial__c 
                                    WHERE isActive__c=true and IPM_Project_Rollout__r.IPM_Project__c=:projId and Local_Project_isNull__c = :IPM_ConstantUtils.IPM_false];
                
             }   
        }
        else if(projectSpan==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && projId!=null){
            localProjectsCount=[SELECT Count() FROM IPM_Project__c WHERE IPM_Parent_Project__c=:projId];
            if(localProjectsCount>0) {
                localFinancialList=[SELECT Id,Local_Project__c,Local_Project__r.IPM_Phase__c,Local_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.Rollout_Plan_Target_Launch_Date__c,Regional_Project__c,Regional_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.name,
                                           Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c,Is_BC_Confirmed_Capability__c,Contract_Approved__c, MR_Approved__c,
                                       (SELECT Turnover_Regional__c,Turnover_Contract__c,Turnover_MR__c,Advertising_Promotions_Regional__c,Advertising_Promotions_Contract__c,
                                        Advertising_Promotions_MR__c,GM_of_TO_Regional__c,GM_of_TO_Contract__c,GM_of_TO_MR__c,Turnover_Global__c,Advertising_Promotions_Global__c,GM_of_TO_Global__c 
                                    FROM IPM_Financial_Years__r 
                                    WHERE Year_Type__c=: CORE_STRATEGIC_INNOVATION AND Year__c=: Year)
                                    FROM IPM_Financial__c 
                                    WHERE isActive__c=true and Regional_Project__c=:projId and Local_Project_isNull__c = :IPM_ConstantUtils.IPM_false] ;
                }       
         
                                 
        }
        else if(projectSpan==IPM_ConstantUtils.PROJECT_SPAN_LOCAL && projId!=null){
       
            localFinancialList=[SELECT Id,Local_Project__c,Local_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.Rollout_Plan_Target_Launch_Date__c,
                                       Regional_Project__c,Regional_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.name,Contract_Approved__c, MR_Approved__c,
                                       Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c,Is_BC_Confirmed_Capability__c 
                                FROM IPM_Financial__c 
                                WHERE isActive__c=true and Local_Project__c=:projId];
        }
    }          
}