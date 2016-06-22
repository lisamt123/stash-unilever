/**
    @Description: A Trigger handler class for the IPM_Project__c object. THIS IS WITHOUT SHARING by purpose
    @Author: Cognizant Technology
    @Date: Nov 2014
**/
public with sharing class IPM_ProjectTriggerHandler 
{
    private static final String CLASS_NAME = 'IPM_ProjectTriggerHandler'; //Class Name for Exception Logging
    
    /**
    @Description: Internal method which puts together the projects with users.
    @param1 - newProjects: List of IPM_Project__c new records.
    @param2 - oldProjectsMap: Old sobjects records of IPM_Project__c object map
    @param3 - isFollow : Boolean value of following parameter.
    @return: Map of Sets of user ids which are assigned projects wise.
    **/
    @testvisible private static Map<Id, Set<Id>> getProjectUsersMap(IPM_Project__c[] newProjects, Map<Id, IPM_Project__c> oldProjectsMap, Boolean isFollow) {
        
        Map<Id, Set<Id>> mapToReturn = new Map<Id, Set<Id>>(); //var to return
        for(IPM_Project__c eachproject : newProjects) {
            Set<Id> tmpStr = new Set<Id>();//temp variable to add the users.check all those users which are changed.
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
                if(eachproject.IPM_Finance_Lead__c != null) {
                    tmpStr.add(eachproject.IPM_Finance_Lead__c);
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
                if(checkChangedUser(eachproject.IPM_Finance_Lead__c, oldProject.IPM_Finance_Lead__c)) {
                    tmpStr.add(oldProject.IPM_Finance_Lead__c);
                }
            }
            if(tmpStr != null && !tmpStr.isEmpty()) {
                mapToReturn.put(eachproject.Id, tmpStr);
            }
        }
        return mapToReturn;
    }
    
    /**
    @Description: Method which checks if the user being changed in the context or not
    @param1 - oldField: old sobject in the context
    @param2 - newField: new sobject in the context
    @return: Boolean value returns true if its changed.
    **/
    private Static Boolean checkChangedUser(String oldField, String newField) {
        
        Boolean paramToReturn = false;
        if(oldField != newField) {
            paramToReturn = true;
        }
        return paramToReturn;
    }
    
     /**
    @Description: Trigger context of Before Update
    @param1 - newProjects: New list of IPM_Project__c object records
    @param2 - oldProjectsMap: old map record of IPM_Project__c records
    **/
    
    public void onBeforeUpdate(IPM_Project__c[] newProjects) 
    {
    	//@@Design Review - Data Sharing Change - Update group members
        try 
        {
            Set<string> projideset = new Set<string>();
            Map<id,IPM_Project__c> projectmap;
            String projectidstr;
                            
            for(IPM_Project__c proj:newProjects)
            {
                projectidstr = proj.IPM_Global_Project_Id__c;
                projideset.add(projectidstr);
                projideset.add(proj.id);  
            }
               
                    
            if(projideset != null && !projideset.isEmpty())
            {
                projectmap = new Map<id,IPM_Project__c>([select id from IPM_Project__c where Id IN: projideset]);
                if(projectmap != null && !projectmap.isEmpty())
                {  
                    IPM_GroupManagement.groupmemberupdate(projectmap.keyset());  
                }  
            }  
        } 
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), CLASS_NAME,'onBeforeUpdate',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,'IPM'); 
            if(ApexPages.currentPage() != null)
            {  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage() + '\n' + ex.getStackTraceString()));
            }
        }
        
    }
    
    /**
    @Description: Trigger context of After Insert
    @param1 - newProjects: New list of IPM_Project__c object records
    **/
    public void onAfterInsert(IPM_Project__c[] newProjects) {
        
        /** follow/unfollow functionality begins **/
         
        /** follow/unfollow fnctionality ends **/        
                
        //@@Design Review - Data Sharing Change Create a queue 
        Set<id> projideset = new Set<id>();         
        String projectidstr;
        
        for(IPM_Project__c proj:newProjects){
            projectidstr = proj.Id;
            if(projectidstr.Substring(0,15) == proj.IPM_Global_Project_Id__c){
                projideset.add(proj.id);
            }

        }
        if(projideset != null && !projideset.isEmpty())
        {
            IPM_GroupManagement.queueCreation(projideset); 
        }
    }
}