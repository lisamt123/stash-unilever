/******************************************************************
@Description :Used for the consolidated view of
@Created Date:22/10/2015
@Author: Cognizant
******************************************************************/
public with sharing class IPM_CU_Complexity_Consolidated {
     public List<IPM_Project_Document_Section_Content__c> secContentList{get;set;}
     public String gateType{get;set;}
     public Boolean isGateDocument{get;set;}
     public Id projectId{
        get {
            return projectId; // to get the project ID from the component used from Gate document page
        }
        set {
            projectId= value;// setting the value of project Id
            getSectionContent();
        }
    }
    
    public void getSectionContent(){
        secContentList=new List<IPM_Project_Document_Section_Content__c>();
        secContentList=[select IPM_Increased_By__c,IPM_Decreased_By__c,IPM_Project_Effect__c,IPM_Project_Document_Section__r.IPM_Gate_Document_Summary__c,
                        IPM_Project_Document_Section__r.IPM_PDP_Document_Summary__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c,
                       IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Project_Name__c
                       from IPM_Project_Document_Section_Content__c where IPM_Content_Type__c='Cu_Complexity' and
                       IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c=:projectId
                       and IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c=:gateType and
                       (IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__r.IPM_Phase__c='Feasibility' OR
                       IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__r.IPM_Phase__c='Capability')];
   }
                       
    
}