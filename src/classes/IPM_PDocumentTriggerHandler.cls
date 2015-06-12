public with sharing class IPM_PDocumentTriggerHandler {
    
    private boolean m_isExecuting = false;

    public IPM_PDocumentTriggerHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }
    
    public void onAfterUpdate(IPM_Project_Document__c[] newPDocuments, Map<Id, IPM_Project_Document__c> newPDocumentsMap) {
        
        Map<Id, Set<String>> projectDocsMap = new Map<Id, Set<String>>();
        Set<Id> projectIds = new Set<Id>();
        IPM_Project__c[] projectsToUpdate = new List<IPM_Project__c>();
        
        for(IPM_Project_Document__c eachPDoc : newPDocuments) {
            IPM_Project_Document__c oldPDoc = newPDocumentsMap.get(eachPDoc.Id);
            if(oldPDoc.IPM_Document_Status__c != eachPDoc.IPM_Document_Status__c) {
                String txt = eachPDoc.Name + IPM_ChatterUtils.PROJECT_DOCUMENT_TEXT + eachPDoc.IPM_Document_Status__c;
                if(!projectDocsMap.containsKey(eachPDoc.IPM_Project__c)) {
                    Set<String> tmpStr = new Set<String>();
                    tmpStr.add(txt);
                    projectDocsMap.put(eachPDoc.IPM_Project__c, tmpStr);
               }else {
                   projectDocsMap.get(eachPDoc.IPM_Project__c).add(txt);
               }
               if(IPM_ConstantUtils.PD_STATUS_STOPPED.equals(eachPDoc.IPM_Document_Status__c)) {
                   projectIds.add(eachPDoc.IPM_Project__c); //mark the phase as Stopped!
               }
            }
        }
        system.debug('** projectIds : ' + projectIds);
        IPM_Project__c[] projectsList = [SELECT Name, IPM_Stopped_By__c, IPM_Stopped_Date_Time__c, IPM_Stopped_Phase__c, 
                                                    IPM_Phase__c FROM IPM_Project__c WHERE Id IN :projectIds];
        for(IPM_Project__c eachProject : projectsList) {
            projectsToUpdate.add(buildProjectToStop(eachProject));
        }
        system.debug('** projectsToUpdate : ' + projectsToUpdate);
        
        update projectsToUpdate;
        
        for(Id eachProject : projectDocsMap.keySet()) {
            IPM_ChatterUtils.postRecordFeed(eachProject, IPM_Utils.convertSetToString(projectDocsMap.get(eachProject)));
        }
        
    }
    
    private IPM_Project__c buildProjectToStop(IPM_Project__c projectSObj) {
        
        projectSObj.IPM_Stopped_By__c = UserInfo.getUserId();
        projectSObj.IPM_Stopped_Date_Time__c = system.now();
        projectSObj.IPM_Stopped_Phase__c = projectSObj.IPM_Phase__c;
        projectSObj.IPM_Phase__c = IPM_ConstantUtils.PD_STATUS_STOPPED;
        
        return projectSObj;
    }
}