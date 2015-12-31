/*************************************************************************************************************
* @author:Cognizant
* @date: 17/11/2015
* @description: To Sync Target Launch Date of Rollout Project and Local Project with eachOther
*/
public with sharing class IPM_RolloutPlanTLDSync {

    public static final String IPM_ROLLOUTPLANTLDSYNC_STR = IPM_RolloutPlanTLDSync.class.getName();
    /*******************************************************************************************************
    * @description  This method is used to sync target launch date between rollout and projects. It also updates parent project TLD will least TLD of child projects.
                    NPath Complexity is high because syncing TLD and updating parent project TLD involves for all three span i.e. Global, Regional and Local and different project phases
    * @param        Map Id IPM_Project
    * @param        Map Id IPM_Project_Rollout
    * @return       NONE
    */    
    public void syncTLDDates( Map<Id, IPM_Project__c> updatedRollouts,Map<Id, IPM_Project_Rollout__c> updatedLocalProjects ) {    
        try{
            List<IPM_Project_Rollout__c> listToUpdateRolloutProject = new List<IPM_Project_Rollout__c>{};
            List<IPM_Project__c> listToUpdateLocalProject = new List<IPM_Project__c>{};
            Map<Id,Id> projIdRolloutIdMapRegional = new Map<Id,Id>{};
            Map<Id,Id> projIdRolloutIdMapGlobal = new Map<Id,Id>{};            
            
            if(null != updatedRollouts){
                for(IPM_Project_Rollout__c rolloutProj :[Select Id, Target_Launch_Date__c,Local_Project_Target_Launch_Date__c from IPM_Project_Rollout__c where Id = : updatedRollouts.keySet() And  isActive__c=true limit 50000]){
                    IPM_Project__c ipmProj = updatedRollouts.get(rolloutProj.Id);
                    Boolean isUpdated = false;
                    if(rolloutProj.Target_Launch_Date__c != ipmProj.Rollout_Plan_Target_Launch_Date__c){
                        rolloutProj.Target_Launch_Date__c = ipmProj.Rollout_Plan_Target_Launch_Date__c;
                        isUpdated = true;
                    }
                    if(rolloutProj.Local_Project_Target_Launch_Date__c != ipmProj.IPM_Target_Launch_Dates__c){
                        rolloutProj.Local_Project_Target_Launch_Date__c = ipmProj.IPM_Target_Launch_Dates__c;
                        isUpdated = true;
                    }
                    if(isUpdated){
                        listToUpdateRolloutProject.add(rolloutProj);
                    }                    
                }
            } else if(null != updatedLocalProjects){
                for(IPM_Project__c localRolloutProj :[Select Id, IPM_Project_Rollout__c, Rollout_Plan_Target_Launch_Date__c from IPM_Project__c where IPM_Project_Rollout__c = : updatedLocalProjects.keySet() limit 50000]){
                    IPM_Project_Rollout__c rollOutProj = updatedLocalProjects.get(localRolloutProj.IPM_Project_Rollout__c);
                    if(rolloutProj.Target_Launch_Date__c != localRolloutProj.Rollout_Plan_Target_Launch_Date__c){
                        localRolloutProj.Rollout_Plan_Target_Launch_Date__c = rolloutProj.Target_Launch_Date__c;
                        listToUpdateLocalProject.add(localRolloutProj);
                    }
                }
                for(IPM_Project_Rollout__c rollOutProject: updatedLocalProjects.values()){                                                           
                    if(rollOutProject.Regional_Project__c != null){
                        projIdRolloutIdMapRegional.put(rollOutProject.Regional_Project__c,rollOutProject.Id);
                    }
                    if(rollOutProject.IPM_Project__c != null){
                        projIdRolloutIdMapGlobal.put(rollOutProject.IPM_Project__c,rollOutProject.Id);
                    }
                }
            }
            List<IPM_Project__c> origProjectList = new List<IPM_Project__c> {};
            if(!projIdRolloutIdMapRegional.isEmpty() || !projIdRolloutIdMapGlobal.isEmpty()){
                Map<Id,Date> regionalProjRollOutMap = new Map<Id,Date> {};
                Map<Id,Date> globalProjRollOutMap = new Map<Id,Date> {};                
                
                for(IPM_Project_Rollout__c rolloutGlobal : [Select Id, IPM_Project__c, Target_Launch_Date__c from IPM_Project_Rollout__c where IPM_Project__c =:projIdRolloutIdMapGlobal.KeySet() and  isActive__c=true limit 50000]){
                    if(!updatedLocalProjects.containskey(rolloutGlobal.Id)){
                        if(globalProjRollOutMap.containskey(rolloutGlobal.IPM_Project__c)){
                            if(globalProjRollOutMap.get(rolloutGlobal.IPM_Project__c) > rolloutGlobal.Target_Launch_Date__c){
                                globalProjRollOutMap.put(rolloutGlobal.IPM_Project__c, rolloutGlobal.Target_Launch_Date__c);
                            }
                        }else{
                            globalProjRollOutMap.put(rolloutGlobal.IPM_Project__c, rolloutGlobal.Target_Launch_Date__c);
                        }
                    }else{
                            globalProjRollOutMap.put(rolloutGlobal.IPM_Project__c, rolloutGlobal.Target_Launch_Date__c);
                    }
                }
                for(IPM_Project_Rollout__c rolloutRegional : [Select Id, IPM_Project__c,Regional_Project__c, Target_Launch_Date__c from IPM_Project_Rollout__c where Regional_Project__c =:projIdRolloutIdMapRegional.KeySet() and  isActive__c=true limit 50000]){
                    if(!updatedLocalProjects.containskey(rolloutRegional.Id)){
                        if(regionalProjRollOutMap.containskey(rolloutRegional.Regional_Project__c)){
                            if(regionalProjRollOutMap.get(rolloutRegional.Regional_Project__c) > rolloutRegional.Target_Launch_Date__c){
                                regionalProjRollOutMap.put(rolloutRegional.Regional_Project__c, rolloutRegional.Target_Launch_Date__c);
                            }
                        }else{
                            regionalProjRollOutMap.put(rolloutRegional.Regional_Project__c, rolloutRegional.Target_Launch_Date__c);
                        }
                    } else {
                        regionalProjRollOutMap.put(rolloutRegional.Regional_Project__c, rolloutRegional.Target_Launch_Date__c);
                    }
                }  
                
                for(IPM_Project__c ipmProject : [Select Id, IPM_Project_Type__c,IPMProject_Span__c, IPM_Phase__c,IPM_Target_Launch_Dates__c from IPM_Project__c where id = :projIdRolloutIdMapRegional.keyset() or id = :projIdRolloutIdMapGlobal.keyset() limit 50000]){
                    if(ipmProject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                        if(updatedLocalProjects.get(projIdRolloutIdMapRegional.get(ipmProject.Id)) != null) {
                            Date newTLDDate = updatedLocalProjects.get(projIdRolloutIdMapRegional.get(ipmProject.Id)).Target_Launch_Date__c;

                            if(ipmProject.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && ipmProject.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS){ 
                                if(newTLDDate < regionalProjRollOutMap.get(ipmProject.Id)){
                                    ipmProject.IPM_Target_Launch_Dates__c = newTLDDate;
                                    origProjectList.add(ipmProject);
                                } else if(regionalProjRollOutMap.get(ipmProject.Id) != ipmProject.IPM_Target_Launch_Dates__c){
                                    ipmProject.IPM_Target_Launch_Dates__c = regionalProjRollOutMap.get(ipmProject.Id);
                                    origProjectList.add(ipmProject);    
                                }
                                
                            } else if((ipmProject.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT || ipmProject.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL )&& ipmProject.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS){
                                if(newTLDDate < regionalProjRollOutMap.get(ipmProject.Id)){
                                    ipmProject.IPM_Target_Launch_Dates__c = newTLDDate;
                                    origProjectList.add(ipmProject);
                                } else if(regionalProjRollOutMap.get(ipmProject.Id) != ipmProject.IPM_Target_Launch_Dates__c){
                                    ipmProject.IPM_Target_Launch_Dates__c = regionalProjRollOutMap.get(ipmProject.Id);
                                    origProjectList.add(ipmProject);    
                                }
                            }
                        }
                    }               
                }
            }
            
            if(!listToUpdateRolloutProject.isEmpty()){
                update listToUpdateRolloutProject;
            } 
            if (!listToUpdateLocalProject.isEmpty()){
                update listToUpdateLocalProject;
            }
            if(!origProjectList.isEmpty()){
                update origProjectList;
            } 
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ROLLOUTPLANTLDSYNC_STR,'syncTLDDates',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }      
    }
    /*******************************************************************************************************
    * @description  Method to update TLD on milestone
    * @param        List IPM_Project
    * @return       NONE
    */
    public void updatedMilestoneTLD( List<IPM_Project__c> projects) {    
        try{
            Map<Id,IPM_Project__c> projIdProjectMap = new Map<Id,IPM_Project__c> {};
            for(IPM_Project__c project :projects){
                projIdProjectMap.put(project.id, project);
            }
            List<IPM_Milestone__c> updatedMilestoneList = new List<IPM_Milestone__c> {};
            for(IPM_Milestone__c ipmMileStone :[Select Id, IPM_Due_Date__c, IPM_Planned_Date__c, IPM_Project__c from IPM_Milestone__c where IPM_Project__c =: projIdProjectMap.keyset() and IPM_Name__c = :IPM_Utils.TargetLaunchDateShiptoTrade]){
                ipmMileStone.IPM_Planned_Date__c =projIdProjectMap.get(ipmMileStone.IPM_Project__c).IPM_Target_Launch_Dates__c;
                updatedMilestoneList.add(ipmMileStone);
            }
            if(!updatedMilestoneList.isEmpty()){
                update updatedMilestoneList;
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ROLLOUTPLANTLDSYNC_STR,'updatedMilestoneTLD',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }      
    /*******************************************************************************************************
    * @description  Method to notify Global Finance leader about TLD Date Changes
    * @param        Map projectId,projectRollout
    * @return       NONE
    */    
    public void notifyGlobalProjectFinanceLeader(Map<Id, IPM_Project_Rollout__c> globalProjIdRollout ){
        List<Id> projIdList = new List<Id>{};
        for(IPM_Project__c ipmProj : [Select Id,IPMProject_Span__c, IPM_Project_Type__c, IPM_Phase__c from IPM_Project__c where Id in : globalProjIdRollout.keySet() limit 50000]){
            if(ipmProj.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && ipmProj.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS){ 
                projIdList.add(ipmProj.Id);
            } else if (ipmProj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && ipmProj.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS){
                projIdList.add(ipmProj.Id);
            }
        }
        
        Map<Id,IPM_Project_Resource__c>  projIdFinanceLeaderMap = new Map<Id,IPM_Project_Resource__c>{};
        for(IPM_Project_Resource__c ipr : [Select Id, IPM_User__c,IPM_User__r.Email,IPM_Project__c from IPM_Project_Resource__c where IPM_Role_Type__c = :IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE and IPM_Project_Role_Owner__c = true and IPM_Project__c in: projIdList limit 50000]){
            projIdFinanceLeaderMap.put(ipr.IPM_Project__c, ipr);
        }       
        List<IPM_EmailOut_Notification__c> emailOut = new List<IPM_EmailOut_Notification__c>{};
        for(Id projId: projIdFinanceLeaderMap.keySet()){
            IPM_EmailOut_Notification__c emailOutNotification = new IPM_EmailOut_Notification__c();    
            emailOutNotification.To_Address__c = projIdFinanceLeaderMap.get(projId).IPM_User__r.Email;
            emailOutNotification.Project_Name__c = globalProjIdRollout.get(projId).Name;
            emailOutNotification.Previous_Target_Launch_Date__c =  globalProjIdRollout.get(projId).previous_Target_Launch_Date__c.format();
            emailOutNotification.Target_Launch_Date__c = globalProjIdRollout.get(projId).Target_Launch_Date__c.format();
            emailOut.add(emailOutNotification);       
        }
        
        try{
            if(!emailOut.isEmpty()){
                insert emailOut;
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ROLLOUTPLANTLDSYNC_STR,'notifyGlobalProjectFinanceLeader',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
}