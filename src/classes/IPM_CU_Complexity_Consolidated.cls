/******************************************************************
@Description :Used for the consolidated view of
@Created Date:22/10/2015
@Author: Cognizant
******************************************************************/
public with sharing class IPM_CU_Complexity_Consolidated {
     public List<IPM_Project_Document_Section_Content__c> secContentList{get;set;}     
     public Id projectId{ // to get-set the project id from the component attribute.
        get{
            if(projectId == null && Apexpages.currentpage().getparameters().get('getProjId') != null) {
                return  Id.valueOf(Apexpages.currentpage().getparameters().get('getProjId')) ;
            }
            else { return projectId; }
        }
        set;
    } 
    public String gateType{
        get{
            if(gateType == null && Apexpages.currentpage().getparameters().get('getGateType') != null) {
                return  Apexpages.currentpage().getparameters().get('getGateType');
            }
            else { return gateType; }
        }
        set;
    }
    public Boolean isGateDocument{
        get {
            if(isGateDocument == null) {
                if(Apexpages.currentpage().getparameters().get('isGateDoc') == IPM_ConstantUtils.IPM_true) {return true; }
                else { return false; }
            }
            else { return isGateDocument; }
        }
        set;
    }
    
    /************************************************************************************************************************
    * @Description: Methods to run when this controller is invoked from component
    */
    public string getInvokeMethodsForComponent() {
        getSectionContent();
        return 'Required methods are invoked for component';
    }
    
    /************************************************************************************************************************
    * @Description: CONSTRUCTOR
    */
    public IPM_CU_Complexity_Consolidated() {
        if(test.isRunningTest()){
            getInvokeMethodsForComponent();
        }
    }   
    
    public void getSectionContent(){
        secContentList=new List<IPM_Project_Document_Section_Content__c>();
        secContentList=[select IPM_Increased_By__c,IPM_Decreased_By__c,IPM_Project_Effect__c,IPM_Project_Document_Section__r.IPM_Gate_Document_Summary__c,
                        IPM_Project_Document_Section__r.IPM_PDP_Document_Summary__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c,
                       IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Project_Name__c
                       from IPM_Project_Document_Section_Content__c where IPM_Content_Type__c='Cu_Complexity' and 
                       IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.Is_Archieved__c = false and 
                       IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c=:projectId
                       and IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c=:gateType and
                       (IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__r.IPM_Phase__c='Feasibility' OR
                       IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__r.IPM_Phase__c='Capability')];
   }
                       
    
}