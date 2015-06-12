public with sharing class IPM_PDSectionTriggerHandler {

    private boolean m_isExecuting = false;

    public IPM_PDSectionTriggerHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }
    
    public void onAfterUpdate(IPM_Project_Document_Section__c[] newPDSections, Map<Id, IPM_Project_Document_Section__c> newPDSectionsMap) {
        
        Map<Id, Set<String>> projectDdocSectionMap = new Map<Id, Set<String>>();
        
        for(IPM_Project_Document_Section__c eachPDSection : newPDSections) {
            IPM_Project_Document_Section__c oldPDSection = newPDSectionsMap.get(eachPDSection.Id);
            if(oldPDSection.IPM_Section_Status__c != eachPDSection.IPM_Section_Status__c &&
                IPM_ConstantUtils.STATUS_NOT_FILLED.equals(eachPDSection.IPM_Section_Status__c)) {
                String txt = eachPDSection.Name + IPM_ChatterUtils.PROJECT_SECTION_TEXT;
                if(!projectDdocSectionMap.containsKey(eachPDSection.IPM_Project_ID__c)) {
                    Set<String> tmpStr = new Set<String>();
                    tmpStr.add(txt);
                    projectDdocSectionMap.put(eachPDSection.IPM_Project_ID__c, tmpStr);
               }else {
                   projectDdocSectionMap.get(eachPDSection.IPM_Project_ID__c).add(txt);
               }
            }
        }
        
        for(Id eachProject : projectDdocSectionMap.keySet()) {
            IPM_ChatterUtils.postRecordFeed(eachProject, IPM_Utils.convertSetToString(projectDdocSectionMap.get(eachProject)));
        }
        
    }
}