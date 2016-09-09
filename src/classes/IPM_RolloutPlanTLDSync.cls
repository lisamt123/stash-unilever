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
<<<<<<< HEAD
    public void updatedMilestoneTLD( List<IPM_Project__c> projects) {    
		// removed exception handling as any exceptions/Messages  would be handled at controller 
        Map<Id,IPM_Project__c> projIdProjectMap = new Map<Id,IPM_Project__c> {};
        for(IPM_Project__c project :projects){
            projIdProjectMap.put(project.id, project);
        }
        List<IPM_Milestone__c> updatedMilestoneList = new List<IPM_Milestone__c> {};
        for(IPM_Milestone__c ipmMileStone :[Select Id, IPM_Due_Date__c, IPM_Planned_Date__c, IPM_Project__c from IPM_Milestone__c where IPM_Project__c =: projIdProjectMap.keyset() and (IPM_Name__c = :IPM_Utils.TargetLaunchDateShiptoTrade or IPM_Name__c = :IPM_ConstantUtils.SHIPTO_TRADE_TLD)]){
            ipmMileStone.IPM_Planned_Date__c =projIdProjectMap.get(ipmMileStone.IPM_Project__c).IPM_Target_Launch_Dates__c;
            updatedMilestoneList.add(ipmMileStone);
        }
        if(!updatedMilestoneList.isEmpty()){
            update updatedMilestoneList;
        }
    }      
=======

>>>>>>> e7762774510a0def457f22eaa4caec8bb9c29733
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
            emailOutNotification.Previous_Target_Launch_Date__c =  globalProjIdRollout.get(projId).previous_Target_Launch_Date__c != null ? globalProjIdRollout.get(projId).previous_Target_Launch_Date__c.format() : null;
            emailOutNotification.Target_Launch_Date__c = globalProjIdRollout.get(projId).Target_Launch_Date__c != null ? globalProjIdRollout.get(projId).Target_Launch_Date__c.format() : null;
            emailOut.add(emailOutNotification);       
        }
        // removed exception handling as any exceptions/Messages  would be handled at controller 
        if(!emailOut.isEmpty()){
            insert emailOut;
        }
    }
}