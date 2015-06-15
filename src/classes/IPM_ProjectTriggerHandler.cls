public without sharing class IPM_ProjectTriggerHandler {

    private boolean m_isExecuting = false;

    public IPM_ProjectTriggerHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }
    
    private Map<Id, Set<Id>> getProjectUsersMap(IPM_Project__c[] newProjects, Map<Id, IPM_Project__c> oldProjectsMap, Boolean isFollow) {
        
        Map<Id, Set<Id>> mapToReturn = new Map<Id, Set<Id>>();
        for(IPM_Project__c eachproject : newProjects) {
            Set<Id> tmpStr = new Set<Id>();
            if(isFollow && oldProjectsMap == null) {
                if(eachproject.IPM_Project_Leader__c != null) {
                    tmpStr.add(eachproject.IPM_Project_Leader__c);
                }
                if(eachproject.IPM_Technical_Project_Leader__c != null) {
                    tmpStr.add(eachproject.IPM_Technical_Project_Leader__c);
                }
                if(eachproject.Deputy_Project_Leader__c != null) {
                    tmpStr.add(eachproject.Deputy_Project_Leader__c);
                }
                if(eachproject.IPM_Project_Gatekeeper__c != null) {
                    tmpStr.add(eachproject.IPM_Project_Gatekeeper__c);
                }
                if(eachproject.IPM_Finance_Member__c != null) {
                    tmpStr.add(eachproject.IPM_Finance_Member__c);
                }
            }else if(!isFollow && oldProjectsMap != null) {
                IPM_Project__c oldProject = oldProjectsMap.get(eachproject.Id);
                if(checkChangedUser(eachproject.IPM_Project_Leader__c, oldProject.IPM_Project_Leader__c)) {
                    tmpStr.add(oldProject.IPM_Project_Leader__c);
                }
                if(checkChangedUser(eachproject.IPM_Technical_Project_Leader__c, oldProject.IPM_Technical_Project_Leader__c)) {
                    tmpStr.add(oldProject.IPM_Technical_Project_Leader__c);
                }
                if(checkChangedUser(eachproject.Deputy_Project_Leader__c, oldProject.Deputy_Project_Leader__c)) {
                    tmpStr.add(oldProject.Deputy_Project_Leader__c);
                }
                if(checkChangedUser(eachproject.IPM_Project_Gatekeeper__c, oldProject.IPM_Project_Gatekeeper__c)) {
                    tmpStr.add(oldProject.IPM_Project_Gatekeeper__c);
                }
                if(checkChangedUser(eachproject.IPM_Finance_Member__c, oldProject.IPM_Finance_Member__c)) {
                    tmpStr.add(oldProject.IPM_Finance_Member__c);
                }
            }
            if(tmpStr.size() > 0) {
                mapToReturn.put(eachproject.Id, tmpStr);
            }
        }
        return mapToReturn;
    }
    
    private Boolean checkChangedUser(String oldField, String newField) {
        
        Boolean paramToReturn = false;
        if(oldField != newField) {
            paramToReturn = true;
        }
        return paramToReturn;
    }
    
    public void onAfterInsert(IPM_Project__c[] newProjects) {
        
        /** follow/unfollow fnctionality begins **/
        Map<Id, Set<Id>> projectUsersToFollowMap = getProjectUsersMap(newProjects, null, true); 
        system.debug('** projectUsersToFollowMap : ' + projectUsersToFollowMap);
        IPM_ChatterFeedHelper.autoFollowProjectMembers(projectUsersToFollowMap);
        /** follow/unfollow fnctionality ends **/
    }
    
    public void onAfterUpdate(IPM_Project__c[] newProjects, Map<Id, IPM_Project__c> oldProjectsMap) {
        
        /** follow/unfollow fnctionality begins **/
        Map<Id, Set<Id>> projectUsersToUnFollowMap = getProjectUsersMap(newProjects, oldProjectsMap, false);
        system.debug('** projectUsersToUnFollowMap : ' + projectUsersToUnFollowMap);
        IPM_ChatterFeedHelper.autoUnFollowProjectMembers(projectUsersToUnFollowMap);
        
        Map<Id, Set<Id>> projectUsersToFollowMap = getProjectUsersMap(newProjects, null, true); 
        system.debug('** projectUsersToFollowMap : ' + projectUsersToFollowMap);
        IPM_ChatterFeedHelper.autoFollowProjectMembers(projectUsersToFollowMap);
        
        /** follow/unfollow fnctionality ends **/
        
        Map<Id, Set<String>> projectMap = new Map<Id, Set<String>>();
        
        //Added by Vipul - 22/03/2015
        Set<String> setTrimmedProjectIds = new Set<String>();
        Set<String> setSustainabilityPeriod = new Set<String>();
        //End (Vipul's update)
        
        for(IPM_Project__c eachproject : newProjects) {
            IPM_Project__c oldProject = oldProjectsMap.get(eachproject.Id);
            
            //Added by Vipul - 22/03/2015
            String projectId = eachproject.Id;
            if(projectId.length() > 15)
                projectId = projectId.subString(0,15);
            setTrimmedProjectIds.add(projectId);

            if(eachProject.Sustainability_Period__c != oldProject.Sustainability_Period__c){
                String sustainabilityPeriodString = projectId + '_' + eachProject.Sustainability_Period__c + '_' + oldProject.Sustainability_Period__c;
                setSustainabilityPeriod.add(sustainabilityPeriodString);
            }
            //End (Vipul's update)
            
            if((eachproject.IPM_Target_Launch_Dates__c != null || oldProject.IPM_Target_Launch_Dates__c != null) && 
                oldProject.IPM_Target_Launch_Dates__c != eachproject.IPM_Target_Launch_Dates__c) {
                Date d = eachproject.IPM_Target_Launch_Dates__c;
                DateTime dt = datetime.newInstance(d.year(), d.month(),d.day());
                String txt = eachproject.Name + IPM_ChatterUtils.PROJECT_TLD_CHANGE_TEXT + ' New Date : ' + dt.format('dd-MMM-yyyy') + ' ';
                if(!projectMap.containsKey(eachproject.Id)) {
                    Set<String> tmpStr = new Set<String>();
                    tmpStr.add(txt);
                    projectMap.put(eachproject.Id, tmpStr);
               }else {
                   projectMap.get(eachproject.Id).add(txt);
               }
            }
            
        }
        
        Map<Id, IPM_Project__c> projectDetailsMap = IPM_Utils.getProjectDetails(projectMap.keySet());
        for(Id eachProject : projectMap.keySet()) {
            if(IPM_CheckRecursive.runOnce()) {
                Set<Id> userMentionIds = new Set<Id>{projectDetailsMap.get(eachProject).IPM_Project_Leader__c};
                IPM_ChatterUtils.postRecordFeedWithMention(eachProject, IPM_Utils.convertSetToString(projectMap.get(eachProject)), userMentionIds);
            }
        }
        
        //Added by Vipul - 22/03/2015
        IPMProcessFinancials.processProjectFinancials(setTrimmedProjectIds, setSustainabilityPeriod);
        // End (Vipul's update)
        
        //commented out for the demo 24 feb
    }
}