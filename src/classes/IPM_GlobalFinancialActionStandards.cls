/**
* @author       Cognizant 
* @date         27/03/2016
* @description  This class is used for displaying Financial Action Stndards 
*               in the gate document  
*/
public with sharing class IPM_GlobalFinancialActionStandards {

    public IPM_Project__c project {get; set;} //The project record for which the financial business cases are being viewed
    public Id projDocSecId{get; set;}
    public Id projectId; //Project Id of te current project
    public Id getprojectId(){ return projectId; }
    public String gateType{get;set;}
    public boolean editTable{get; set;} //To Check Record is Editable or Read Mode
    public List<IPM_Financial_Action_Standards__c> finActionStandardsList{get; set;}
    public IPM_Financial_Action_Standards__c finAction{get; set;}
    public void setprojectId (ID p){
        projectId = p;
        showFinancialActionStandards(); 
    }
    public Id finActionId{get; set;}
    public String finActionSpan{get;set;}
    public String field{get;set;}
    public Decimal numValue{get; set;}
    public static final String CLASS_NAME = IPM_FinancialActionStandards.Class.getName(); //Class Name for Exception Logging
    @TestVisible private static string UPDATE_ACTION_STANDARDS_STR = 'updateActionStandards';
    @TestVisible private static string COMMENT_INNOVATION = 'Innovation';
    @TestVisible private static string COMMENT_INCREMENTAL = 'Incremental';
    @TestVisible private static string COMMENT_GTO = 'gTO';
    @TestVisible private static string COMMENT_ITO = 'iTO';
    @TestVisible private static string COMMENT_GM = 'GM';
    @TestVisible private static string COMMENT_NPV = 'NPV';
    @TestVisible private static string COMMENT_IRR = 'IRR';
    @TestVisible private static string COMMENT_PAYBACK = 'PayBack';
    /*******************************************************************************************************
    * @description  Action Method to show Action Standards
    * @param        NONE
    * @return       NONE
    */
    public void showFinancialActionStandards(){
        try{
            project = [SELECT IPM_Project_Name__c,IPM_Project_Type__c,IPMProject_Span__c, IPM_Phase__c
                       FROM IPM_Project__c 
                       WHERE ID =: projectId];
            
            getFinancialActionStandards();
            
        } catch (Exception ex) {
            if(ApexPages.currentPage() != null){  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Generic_ErrorMessage ) );
            }
        }
    }
    
    /*******************************************************************************************************
    * @description  Action Method to get Global Action Standards
    * @param        NONE
    * @return       NONE
    */
    public void getFinancialActionStandards(){
        finActionStandardsList=new List<IPM_Financial_Action_Standards__c>();
        finActionStandardsList=[SELECT IPM_Financial_Action_Standard_Name__c,IPM_Financial_Year_Y1_Gross__c,IPM_Financial_Year_Y1_Incremental__c,IPM_GM_Action_Standards_Charter__c,IPM_Project_Span__c,
                                       IPM_gTO_Action_Standard_Charter__c,IPM_Inc_Value_Share_Action_Charter__c,IPM_Innov_Value_Share_Action_Charter__c,IPM_IRR_Action_Standard_Charter__c,Name,
                                       IPM_iTo_Action_Standard_Charter__c,IPM_NPV_Action_Standard_Charter__c,IPM_Payback_Action_Standard_Charter__c,IPM_Project__c,IPM_Project_Document_Section__c,
                                       IPM_Financial_Year_Y1_Gross__r.Value_Market_Share_Global__c,IPM_Financial_Year_Y1_Gross__r.Turnover_Global__c,IPM_Financial_Year_Y1_Gross__r.GM_of_TO_Global__c,
                                       IPM_Financial_Year_Y1_Incremental__r.Value_Market_Share_Global__c,IPM_Financial_Year_Y1_Incremental__r.Turnover_Global__c,IPM_Financial_Year_Y1_Gross__r.IPM_Financial__c,
                                       IPM_Financial_Year_Y1_Gross__r.IPM_Financial__r.Payback_Global__c,IPM_Financial_Year_Y1_Gross__r.IPM_Financial__r.NPV_Global__c,IPM_Financial_Year_Y1_Gross__r.IPM_Financial__r.IRR_Global__c
                                FROM IPM_Financial_Action_Standards__c
                                WHERE IPM_Project__c=:project.Id AND IPM_Project_Document_Section__c=:projDocSecId order by Name Asc];
        for(IPM_Financial_Action_Standards__c finActStd:finActionStandardsList){
            finActStd.IPM_Inc_Value_Share_Action_Charter__c=finActStd.IPM_Inc_Value_Share_Action_Charter__c.setScale(1);
            finActStd.IPM_Innov_Value_Share_Action_Charter__c=finActStd.IPM_Innov_Value_Share_Action_Charter__c.setScale(1);
            finActStd.IPM_gTO_Action_Standard_Charter__c=finActStd.IPM_gTO_Action_Standard_Charter__c.setScale(2);
            finActStd.IPM_iTo_Action_Standard_Charter__c=finActStd.IPM_iTo_Action_Standard_Charter__c.setScale(2);
            finActStd.IPM_GM_Action_Standards_Charter__c=finActStd.IPM_GM_Action_Standards_Charter__c.setScale(1);
            finActStd.IPM_NPV_Action_Standard_Charter__c=finActStd.IPM_NPV_Action_Standard_Charter__c.setScale(2);
            finActStd.IPM_IRR_Action_Standard_Charter__c=finActStd.IPM_IRR_Action_Standard_Charter__c.setScale(3);
            finActStd.IPM_Payback_Action_Standard_Charter__c=finActStd.IPM_Payback_Action_Standard_Charter__c.setScale(2);
        }
    }
    
    /*******************************************************************************************************
    * @description  To Update Action Standards
    * @param        NONE
    * @return       NONE
    */  
    public void updateActionStandards(){
        try{
            Decimal oldValue=0;
            if(String.isNotBlank(finActionId)){
                finAction=[SELECT Id,IPM_Innov_Value_Share_Action_Charter__c,IPM_Inc_Value_Share_Action_Charter__c,IPM_gTO_Action_Standard_Charter__c,IPM_iTo_Action_Standard_Charter__c,
                                  IPM_GM_Action_Standards_Charter__c,IPM_NPV_Action_Standard_Charter__c,IPM_IRR_Action_Standard_Charter__c,IPM_Payback_Action_Standard_Charter__c
                           FROM IPM_Financial_Action_Standards__c
                           WHERE Id=:finActionId];
                if(field == COMMENT_INNOVATION){
                    finAction.IPM_Innov_Value_Share_Action_Charter__c=numvalue;  
                }
                else if(field == COMMENT_INCREMENTAL){
                    finAction.IPM_Inc_Value_Share_Action_Charter__c=numvalue;
                }
                else if(field == COMMENT_GTO){
                    oldValue=finAction.IPM_gTO_Action_Standard_Charter__c;
                    finAction.IPM_gTO_Action_Standard_Charter__c=numvalue;
                }
                else if(field == COMMENT_ITO){
                    oldValue=finAction.IPM_iTo_Action_Standard_Charter__c;
                    finAction.IPM_iTo_Action_Standard_Charter__c=numvalue;
                }
                else if(field == COMMENT_GM){
                    finAction.IPM_GM_Action_Standards_Charter__c=numvalue;
                }
                else if(field == COMMENT_NPV){
                    finAction.IPM_NPV_Action_Standard_Charter__c=numvalue;
                }
                else if(field == COMMENT_IRR){
                    finAction.IPM_IRR_Action_Standard_Charter__c=numvalue;
                }
                else if(field == COMMENT_PAYBACK){
                    finAction.IPM_Payback_Action_Standard_Charter__c=numvalue;
                }
                update finAction;
                if(gateType==IPM_ConstantUtils.CHARTER_GATE && finActionSpan==IPM_ConstantUtils.IPMREGIONAL){
                    IPM_Financial_Action_Standards__c globalFinaAction=[SELECT Id,IPM_gTO_Action_Standard_Charter__c,IPM_iTo_Action_Standard_Charter__c FROM IPM_Financial_Action_Standards__c
                                                                        WHERE IPM_Project_Span__c=:IPM_ConstantUtils.IPMGLOBAL AND IPM_Project__c=:project.Id AND IPM_Project_Document_Section__c=:projDocSecId];
                    if(field == COMMENT_GTO){
                        globalFinaAction.IPM_gTO_Action_Standard_Charter__c=globalFinaAction.IPM_gTO_Action_Standard_Charter__c-oldValue+numvalue;
                    }
                    else if(field == COMMENT_ITO){
                        globalFinaAction.IPM_iTo_Action_Standard_Charter__c=globalFinaAction.IPM_iTo_Action_Standard_Charter__c-oldValue+numvalue;
                    }
                    update globalFinaAction;                                                    
                }
            }
            getFinancialActionStandards();
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    UPDATE_ACTION_STANDARDS_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
            if(ApexPages.currentPage() != null){  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Generic_ErrorMessage ) );
            }
        }  
    }
}