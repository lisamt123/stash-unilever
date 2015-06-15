/* ------------------------------------------------------------------------------------------------------------------
   Name:           ipmProjectDocumentTrigger
   Developed By:   Cognizant (Vipul)
   Description:    Handle All events on Project Gate Documents
   
   Change History:
   17/02/2015    Vipul    Create Gate Documents, Rollout Projects and Financials
--------------------------------------------------------------------------------------------------------------------- */

public with sharing class IPMProjectDocumentTriggerHandler{
    
    private static String GATE_CHARTER = 'Charter';
    private static String GATE_CONTRACT = 'Contract';
    private static String GATE_MARKET_READY = 'Market Ready';

    private static String STATUS_APPROVED = 'Approved';
    private static String STATUS_APPROVED_WITH_EDIT = 'Approved with Edits';

    private static String GATEKEEPER_MODEL_GCLT = 'GCLT';
    private static String GATEKEEPER_MODEL_RCLT = 'RCLT';
    private static String GATEKEEPER_MODEL_BOTH = 'GCLT & RCLT';
    //private static String FROM_CLASS='Class';
   // private static String FROM_TRIGGER='Trigger';

    public void processAfterUpdate(List<IPM_Project_Document__c> lstProjectDocuments, String Place){
        List<IPM_Project_Document__c> lstCharterProjectDocumentGCLT = new List<IPM_Project_Document__c>();
        List<IPM_Project_Document__c> lstCharterProjectDocumentRCLT = new List<IPM_Project_Document__c>();
        List<IPM_Project_Document__c> lstCharterProjectDocumentBOTH = new List<IPM_Project_Document__c>();
        List<IPM_Project_Document__c> lstContractProjectDocument = new List<IPM_Project_Document__c>();
        List<IPM_Project_Document__c> lstMarketReadyProjectDocument = new List<IPM_Project_Document__c>();

        Set<Id> setProjectDocumentIds = new Set<Id>();

        For(IPM_Project_Document__c projectDocument : lstProjectDocuments){
            //Charter Document Approved
            if(projectDocument.IPM_GateDocuments__c == GATE_CHARTER  && (projectDocument.IPM_Document_Status__c == STATUS_APPROVED || (projectDocument.IPM_Document_Status__c == STATUS_APPROVED_WITH_EDIT && Place=='Class'))) {
                System.debug('Place here'+projectDocument.IPM_Contract_GateKeeper_Model__c);
                if(projectDocument.IPM_Contract_GateKeeper_Model__c == GATEKEEPER_MODEL_GCLT )
                    lstCharterProjectDocumentGCLT.add(projectDocument);
                
                else if(projectDocument.IPM_Contract_GateKeeper_Model__c == GATEKEEPER_MODEL_RCLT )
                    lstCharterProjectDocumentRCLT.add(projectDocument);
    
                else if(projectDocument.IPM_Contract_GateKeeper_Model__c == GATEKEEPER_MODEL_BOTH )
                    lstCharterProjectDocumentBOTH.add(projectDocument);
                    
            }

            //Contract Document Approved
            else if(projectDocument.IPM_GateDocuments__c == GATE_CONTRACT && (projectDocument.IPM_Document_Status__c == STATUS_APPROVED || (projectDocument.IPM_Document_Status__c == STATUS_APPROVED_WITH_EDIT && Place=='Class'))) {
                lstContractProjectDocument.add(projectDocument);
            }

            //Market Ready Document Approved
            else if(projectDocument.IPM_GateDocuments__c == GATE_MARKET_READY && (projectDocument.IPM_Document_Status__c == STATUS_APPROVED || (projectDocument.IPM_Document_Status__c == STATUS_APPROVED_WITH_EDIT && Place=='Class')) && projectDocument.IPM_Project_Span__c!='Global') {
                lstMarketReadyProjectDocument.add(projectDocument);
            }

            setProjectDocumentIds.add(projectDocument.Id);
        }
        
        //GCLT Model - CHARTER
        if(lstCharterProjectDocumentGCLT.size()>0) {
            IPM_CreateRolloutProjects.createProjects(lstCharterProjectDocumentGCLT);
            IPM_CreateGateDocuments.createContractDocument(lstCharterProjectDocumentGCLT, GATEKEEPER_MODEL_GCLT);
            /*if(IPM_CreateIPMProjectTasks.offTrigger){
                List<Id> projectIds=new List<Id>();
                for(IPM_Project_Document__c pdoc:lstCharterProjectDocumentGCLT){
                    projectIds.add(pdoc.IPM_Project__c);
                }
                 IPM_CreateIPMProjectTasks.createIPMTasks(projectids);
            }*/
        }

        //RCLT Model - CHARTER
        if(lstCharterProjectDocumentRCLT.size()>0){
            IPM_CreateRolloutProjects.createProjects(lstCharterProjectDocumentRCLT);
            IPM_CreateGateDocuments.createContractDocument(lstCharterProjectDocumentRCLT, GATEKEEPER_MODEL_RCLT);
            /*if(IPM_CreateIPMProjectTasks.offTrigger){
                List<Id> projectIds=new List<Id>();
                for(IPM_Project_Document__c pdoc:lstCharterProjectDocumentRCLT){
                    projectIds.add(pdoc.IPM_Project__c);
                }
                 IPM_CreateIPMProjectTasks.createIPMTasks(projectids);
            }*/
        }
    
        //BOTH Model - CHARTER
        if(lstCharterProjectDocumentBOTH.size()>0){
            IPM_CreateRolloutProjects.createProjects(lstCharterProjectDocumentBOTH);
            IPM_CreateGateDocuments.createContractDocument(lstCharterProjectDocumentBOTH, GATEKEEPER_MODEL_BOTH);
            /*if(IPM_CreateIPMProjectTasks.offTrigger){
                List<Id> projectIds=new List<Id>();
                for(IPM_Project_Document__c pdoc:lstCharterProjectDocumentBOTH){
                    projectIds.add(pdoc.IPM_Project__c);
                }
                 IPM_CreateIPMProjectTasks.createIPMTasks(projectids);
            }*/
        }
    
        //CONTRACT
        if(lstContractProjectDocument.size()>0){
            IPM_CreateGateDocuments.createMarketReadyDocument(lstContractProjectDocument);
        }
    
        //MARKET READY
        if(lstMarketReadyProjectDocument.size()>0){
            IPM_CreateGateDocuments.createMarketDeploymentDocument(lstMarketReadyProjectDocument);
        }
        
        if(setProjectDocumentIds.size() > 0)
            IPMProcessFinancials.processDocumentApprovalFinancials(setProjectDocumentIds);
        
    }
}