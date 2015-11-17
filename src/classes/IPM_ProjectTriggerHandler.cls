/**
    @Description: A Trigger handler class for the IPM_Project__c object. THIS IS WITHOUT SHARING by purpose
    @Author: Cognizant Technology
    @Date: Nov 2014
**/
public without sharing class IPM_ProjectTriggerHandler {

    public IPM_ProjectTriggerHandler(){ //constructor
    }
    
    private static final String CLASS_NAME = 'IPM_ProjectTriggerHandler'; //Class Name for Exception Logging
    
    /**
    @Description: Method to update milestones
    @param1 - mapupdmilestone: Map of milestone dates record id wise.
    **/
    public void updateMilestone(Map<Id,Date> mapupdmilestone){
        List<IPM_Milestone__c> lstmilestones = [SELECT IPM_Project__c 
                                                  FROM IPM_Milestone__c 
                                                  WHERE IPM_Project__c IN : mapupdmilestone.keySet() AND 
                                                        IPM_Type_of_Milestone__c='Standard' 
                                                        AND IPM_Type_of_gate__c ='PLE/Learnings']; //critirea based milestone callings
        
        List<IPM_Milestone__c> updmilestones=new List<IPM_Milestone__c>(); //milestones to update
        if(!lstmilestones.isEmpty()){
            for(IPM_Milestone__c milestone:lstmilestones){
                //preparing milestones sobjects
                IPM_Milestone__c mile=new IPM_Milestone__c(Id=milestone.Id,IPM_Completed_On__c=mapupdmilestone.get(milestone.IPM_Project__c));    
                updmilestones.add(mile);
            }  
            if(!updmilestones.isEmpty()){
                update updmilestones;//DML Operation
            }      
        }
    }
    
    /**
    @Description: Internal method which puts together the projects with users.
    @param1 - newProjects: List of IPM_Project__c new records.
    @param2 - oldProjectsMap: Old sobjects records of IPM_Project__c object map
    @param3 - isFollow : Boolean value of following parameter.
    @return: Map of Sets of user ids which are assigned projects wise.
    **/
    private Map<Id, Set<Id>> getProjectUsersMap(IPM_Project__c[] newProjects, Map<Id, IPM_Project__c> oldProjectsMap, Boolean isFollow) {
        
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
    private Boolean checkChangedUser(String oldField, String newField) {
        
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
    //public void onBeforeUpdate(IPM_Project__c[] newProjects, Map<Id, IPM_Project__c> oldProjectsMap) {
    public void onBeforeUpdate(IPM_Project__c[] newProjects) {
        //@@Design Review - Data Sharing Change - Update group members
        try {
                Set<string> projideset = new Set<string>();
                Map<id,IPM_Project__c> projectmap;
                String projectidstr;
                            
                for(IPM_Project__c proj:newProjects){
                     
                        
                      projectidstr = proj.IPM_Global_Project_Id__c;
                      
                      projideset.add(projectidstr);
                      projideset.add(proj.id);  
                     
                }
                
                    
                if(projideset != null && projideset.size()>0){
                    projectmap = new Map<id,IPM_Project__c>([select id from IPM_Project__c where Id IN: projideset]);
                    if(projectmap != null && projectmap.size()>0){  
                        IPM_GroupManagement.groupmemberupdate(projectmap.keyset());  
                    }  
                }  
        } catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), CLASS_NAME,
                                                       'onBeforeUpdate',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,'IPM'); 
            if(ApexPages.currentPage() != null){  
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
        Map<Id, Set<Id>> projectUsersToFollowMap = getProjectUsersMap(newProjects, null, true); 
        //system.debug('** projectUsersToFollowMap : ' + projectUsersToFollowMap);
       // IPM_ChatterFeedHelper.autoFollowProjectMembers(projectUsersToFollowMap);
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
        if(projideset != null && projideset.size()>0){
            IPM_GroupManagement.queueCreation(projideset);
            
            /*
            //for rollout projects only
            if(proj.IPM_Project_Type__c!=null && (proj.IPMProject_Span__c.Equals('Regional')||proj.IPMProject_Span__c.Equals('Local'))){
                Map<id,IPM_Project__c> projmap = new Map<id,IPM_Project__c>([select id from IPM_Project__c where IPM_Global_ProjectId__c IN: projideset]);
                if(projmap != null && projmap.size()>0){  
                   if(!system.isBatch()){
                    if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing' OR Status = 'Queued')] < 5){ 
                        Database.executeBatch(new IPM_ProjectOwnerUpdate(projmap.keyset()));
                    } else {                    
                        String hour = String.valueOf(Datetime.now().hour());
                        String min = String.valueOf(Datetime.now().minute() + 10); String ss = String.valueOf(Datetime.now().second());
                        //parse to cron expression
                        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        
                        IPM_ProjectOwnerUpdatescheduler s = new IPM_ProjectOwnerUpdatescheduler(projmap.keyset()); 
                        System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, s); 
                    } 
                   }  
                } 
            }// end of rollout project records */
             
        }
        
       
    }
            
    /**
    @Description: Trigger context of After Update
    @param1 - newProjects: New list of IPM_Project__c object records
    @param2 - oldProjectsMap: old map record of IPM_Project__c records
    **/
    public void onAfterUpdate(IPM_Project__c[] newProjects, Map<Id, IPM_Project__c> oldProjectsMap) {
        
        /** follow/unfollow fnctionality begins **/
        Map<Id, Set<Id>> projectUsersToUnFollowMap = getProjectUsersMap(newProjects, oldProjectsMap, false); //var to store ppl to unsubscribe
        //system.debug('** projectUsersToUnFollowMap : ' + projectUsersToUnFollowMap);
        IPM_ChatterFeedHelper.autoUnFollowProjectMembers(projectUsersToUnFollowMap);
        
        Map<Id, Set<Id>> projectUsersToFollowMap = getProjectUsersMap(newProjects, null, true); //variable which stores ppl to subscribe
        system.debug('** projectUsersToFollowMap : ' + projectUsersToFollowMap);
        IPM_ChatterFeedHelper.autoFollowProjectMembers(projectUsersToFollowMap);
        
        /** follow/unfollow fnctionality ends **/
        
        Map<Id, Set<String>> projectMap = new Map<Id, Set<String>>(); //project user wise map
        
        //Added by Vipul - 22/03/2015
        Set<String> setProjectIds = new Set<String>();
        Set<String> setSustainabilityPeriod = new Set<String>();
        //End (Vipul's update)
        
        
        Map<Id,Date> mapIdLaunchDate=new Map<Id,Date>();//map with records and date wise sortings.
        
        for(IPM_Project__c eachproject : newProjects) {
            IPM_Project__c oldProject = oldProjectsMap.get(eachproject.Id);
            
            //Added by Vipul - 22/03/2015
            String projectId = eachproject.Id;
            if(projectId.length() > 15)
                projectId = projectId.subString(0,15);
            setProjectIds.add(projectId);

            if(eachProject.Sustainability_Period__c != oldProject.Sustainability_Period__c){
                String sustainabilityPeriodString = projectId + '_' + eachProject.Sustainability_Period__c + '_' + oldProject.Sustainability_Period__c;
                setSustainabilityPeriod.add(sustainabilityPeriodString);
            }
            //End (Vipul's update)
            //System.debug(oldProject.IPM_Actual_Launch_Date__c != eachproject.IPM_Actual_Launch_Date__c);
            if((eachproject.IPM_Actual_Launch_Date__c != null || oldProject.IPM_Actual_Launch_Date__c != null) && 
                oldProject.IPM_Actual_Launch_Date__c != eachproject.IPM_Actual_Launch_Date__c) {
                mapIdLaunchDate.put(eachproject.Id,eachproject.IPM_Actual_Launch_Date__c);
            }
            
            //if TLD is not changed..
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
        
        if(!mapIdLaunchDate.isEmpty()){
            updateMilestone(mapIdLaunchDate);//call to update milestones.
        }
        
        Map<Id, IPM_Project__c> projectDetailsMap = IPM_Utils.getProjectDetails(projectMap.keySet());//start notification preparations
        for(Id eachProject : projectMap.keySet()) {
            if(IPM_CheckRecursive.runOnce()) {
                Set<Id> userMentionIds = new Set<Id>{projectDetailsMap.get(eachProject).IPM_Project_Leader__c};
            //    IPM_ChatterUtils.postRecordFeedWithMention(eachProject, IPM_Utils.convertSetToString(projectMap.get(eachProject)), userMentionIds);
            }
        }
        
        //Added by Vipul - 22/03/2015
        System.debug('@@@@@@@@@inside Project Trigger handler@@@@@@@@@@@');
        IPM_ProcessFinancials.processProjectFinancials(setProjectIds, setSustainabilityPeriod);
        // End (Vipul's update)
        
        //commented out for the demo 24 feb
    }
    /**
    @Description: Trigger context of Before Update
    @param1 - newProjects: New list of IPM_Project__c object records
    @param2 - oldProjectsMap: old map record of IPM_Project__c records
    **/
    public void onBeforeInsert(IPM_Project__c[] newProjects) {
        //@@Design Review - Data Sharing Change - Update group members
        /*try {
                Set<id> projideset = new Set<id>();
                Map<id,IPM_Project__c> projectmap;
                String projectidstr;
                            
                for(IPM_Project__c proj:newProjects){
                    if(proj.IPM_Project_Type__c!=null && (proj.IPMProject_Span__c.Equals('Regional')||proj.IPMProject_Span__c.Equals('Local'))){
                      projectidstr = proj.IPM_Global_ProjectId__c;
                      if(String.isNotBlank(projectidstr))
                      {
                        projectidstr = projectidstr.Substring(0,15);
                        projideset.add(projectidstr);
                      } 
                    }
                    
                }
                if(projideset != null && projideset.size()>0){
                    projectmap = new Map<id,IPM_Project__c>([select id from IPM_Project__c where IPM_Global_ProjectId__c IN: projideset]);
                    if(projectmap != null && projectmap.size()>0){  
                
                if(!system.isBatch()){

                   if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing' OR Status = 'Queued')] < 5){ 
                        Database.executeBatch(new IPM_ProjectOwnerUpdate(projectmap.keyset()));
                    } else {                    
                        String hour = String.valueOf(Datetime.now().hour());
                        String min = String.valueOf(Datetime.now().minute() + 10); String ss = String.valueOf(Datetime.now().second());
                        //parse to cron expression
                        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        
                        IPM_ProjectOwnerUpdatescheduler s = new IPM_ProjectOwnerUpdatescheduler(projectmap.keyset()); 
                        System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, s); 
                }
                    
                
                        //IPM_GroupManagement.groupmemberupdate(projectmap.keyset());  
                    }  
                }
               }  
        } catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), CLASS_NAME,
                                                       'onBeforeInsert',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,'IPM'); 
            if(ApexPages.currentPage() != null){  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage() + '\n' + ex.getStackTraceString()));
            }
        } */
        
    }
    
           /**
    @Description: Trigger context of After Update
    @param1 - newProjects: New list of IPM_Project__c object records
    @param2 - oldProjectsMap: old map record of IPM_Project__c records
    **/
    public void onAfterUpd(IPM_Project__c[] newProjects, Map<Id, IPM_Project__c> oldProjectsMap) {
        
       /* //@@ Data Sharing
        Set<string> projideset = new Set<string>();
        Map<id,IPM_Project__c> projmap;
        String projectidstr;
        
        for(IPM_Project__c proj : newProjects) {
            //if(proj.IPM_Project_Type__c!=null && (proj.IPMProject_Span__c.Equals('Regional')||proj.IPMProject_Span__c.Equals('Local')) && proj.IPM_Project_Job_Status__c == 'Completed' && proj.IPM_Project_Job_Status__c != oldProjectsMap.get(proj.id).IPM_Project_Job_Status__c){
            if(proj.IPM_Project_Type__c!=null && (proj.IPMProject_Span__c.Equals('Regional')||proj.IPMProject_Span__c.Equals('Local'))){   
              projectidstr = proj.IPM_Global_ProjectId__c;
              //projectidstr = projectidstr.Substring(0,15);
              projideset.add(projectidstr);  
            }
        }
        
        if(projideset != null && projideset.size()>0){
                    projmap = new Map<id,IPM_Project__c>([select id from IPM_Project__c where IPM_Global_ProjectId__c IN: projideset]);
                    if(projmap != null && projmap.size()>0){  
                       system.debug('initiating future method');
                      // if(!system.isBatch()){
                       IPM_GroupManagement.groupmemberupdate(projmap.keyset());                        
                            system.debug('initiating batch method');
                           if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing' OR Status = 'Queued')] < 5){ 
                                Database.executeBatch(new IPM_ProjectOwnerUpdate(projmap.keyset()));
                            } else {                    
                                String hour = String.valueOf(Datetime.now().hour());
                                String min = String.valueOf(Datetime.now().minute() + 10); String ss = String.valueOf(Datetime.now().second());
                                //parse to cron expression
                                String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
                
                                IPM_ProjectOwnerUpdatescheduler s = new IPM_ProjectOwnerUpdatescheduler(projmap.keyset()); 
                                System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, s); 
                            } 
                       //}  
                } 
    } */
    }   
}