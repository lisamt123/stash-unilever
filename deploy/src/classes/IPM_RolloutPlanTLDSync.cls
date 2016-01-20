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
	        List<IPM_Project_Rollout__c> listToUpdateRolloutProject = new List<IPM_Project_Rollout__c>{};
	        List<IPM_Project__c> listToUpdateLocalProject = new List<IPM_Project__c>{};
	        Map<Id,Id> projIdRolloutIdMapRegional = new Map<Id,Id>{};
	        Map<Id,Id> projIdRolloutIdMapGlobal = new Map<Id,Id>{};            
            Map<ID,IPM_Project__c> origProjectMap = new Map<ID,IPM_Project__c> {};
            if(null != updatedRollouts){
                // Get Rollouts of updated project
                for(IPM_Project_Rollout__c rolloutProj :[Select Id, Target_Launch_Date__c,Local_Project_Target_Launch_Date__c from IPM_Project_Rollout__c where Id = : updatedRollouts.keySet() And  isActive__c=true limit 50000]){
                    IPM_Project__c ipmProj = updatedRollouts.get(rolloutProj.Id);
                    Boolean isUpdated = false;
                    // Handle accept from local
                    if(rolloutProj.Target_Launch_Date__c != ipmProj.Rollout_Plan_Target_Launch_Date__c){
                        rolloutProj.Target_Launch_Date__c = ipmProj.Rollout_Plan_Target_Launch_Date__c;
                        isUpdated = true;
                    }
                    // Handle accept from regional
                    if(rolloutProj.Local_Project_Target_Launch_Date__c != ipmProj.IPM_Target_Launch_Dates__c){
                        rolloutProj.Local_Project_Target_Launch_Date__c = ipmProj.IPM_Target_Launch_Dates__c;
                        isUpdated = true;
                    }
                    if(isUpdated){
                        listToUpdateRolloutProject.add(rolloutProj);
                    }                    
                }
                //This is to calculate earliest Target Launch Date of the Regional projects to update Global project 
                
                Set<ID> globalProjIds = new Set<ID>();
                Set<ID> regionalProjIds = new Set<ID>();
                // Filter regional project's global projects
                for (IPM_Project__c ipmProject: updatedRollouts.values()) {
                	regionalProjIds.add(ipmProject.id);
                	if(ipmProject.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL) {
			            globalProjIds.add(ipmProject.IPM_Parent_Project__c);
	                }
                }
                if(!globalProjIds.isEmpty()) {
                	// Get all regional projects of global project order by TLD. 
                	// This is required to update Global project's TLD with earliest regional project.
                	Map<ID,IPM_Project__c> globalProjsMap = new Map<ID,IPM_Project__c>([Select ID, (Select ID, IPM_Target_Launch_Dates__c From IPM_Projects__r ORDER BY IPM_Target_Launch_Dates__c ASC NULLS LAST ) From IPM_Project__c where  id in :globalProjIds ]);
                	for (IPM_Project__c ipmProject: globalProjsMap.values()) {
                		if(!ipmProject.IPM_Projects__r.isEmpty()) {
                			IPM_Project__c updateProj = new IPM_Project__c(ID=ipmProject.id,IPM_Target_Launch_Dates__c=ipmProject.IPM_Projects__r[0].IPM_Target_Launch_Dates__c);
							// collect the project which need update on TLD
							if(origProjectMap.isEmpty() || !origProjectMap.keySet().contains(updateProj.id)){
								origProjectMap.put(updateProj.id,updateProj);
							} 
                		}
                	}
                }
            } else if(null != updatedLocalProjects){
                //Get all the projects related to updated rollouts
                for(IPM_Project__c localRolloutProj :[Select Id, IPM_Project_Rollout__c, Rollout_Plan_Target_Launch_Date__c from IPM_Project__c where IPM_Project_Rollout__c = : updatedLocalProjects.keySet() limit 50000]){
                    IPM_Project_Rollout__c rollOutProj = updatedLocalProjects.get(localRolloutProj.IPM_Project_Rollout__c);
                    // Handle accept from local
                    if(rolloutProj.Target_Launch_Date__c != localRolloutProj.Rollout_Plan_Target_Launch_Date__c){
                        localRolloutProj.Rollout_Plan_Target_Launch_Date__c = rolloutProj.Target_Launch_Date__c;
                        listToUpdateLocalProject.add(localRolloutProj);
                    }
                }
                for(IPM_Project_Rollout__c rollOutProject: updatedLocalProjects.values()){                                                           
                    // collect regional project ids
                    if(rollOutProject.Regional_Project__c != null){
                        projIdRolloutIdMapRegional.put(rollOutProject.Regional_Project__c,rollOutProject.Id);
                    }
                    // collect global project ids
                    if(rollOutProject.IPM_Project__c != null){
                        projIdRolloutIdMapGlobal.put(rollOutProject.IPM_Project__c,rollOutProject.Id);
                    }
                }
            }
            if(!projIdRolloutIdMapRegional.isEmpty() || !projIdRolloutIdMapGlobal.isEmpty()){
                Map<Id,Date> regionalProjRollOutMap = new Map<Id,Date> {};
                Map<Id,Date> globalProjRollOutMap = new Map<Id,Date> {};                
                List<IPM_Project_Rollout__c> regionalRollouts = new List<IPM_Project_Rollout__c>();
                List<IPM_Project_Rollout__c> localRollouts = new List<IPM_Project_Rollout__c>();
                // Get all rollouts of global projects order by TLD. 
                // This is required to update Global project's TLD with earliest regional rollout.
                for(IPM_Project_Rollout__c rolloutGlobal : [Select Id, IPM_Rollout_Span__c, Local_Project__c, IPM_Project__c, Target_Launch_Date__c from IPM_Project_Rollout__c where IPM_Project__c =:projIdRolloutIdMapGlobal.KeySet() and  isActive__c=true ORDER BY Target_Launch_Date__c ASC NULLS LAST limit 50000]){
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
                    // collect retional projects
                    if(rolloutGlobal.IPM_Rollout_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL) {
                    	regionalRollouts.add(rolloutGlobal);
                    }
                    
                }
				if(!regionalRollouts.isEmpty()) {
       				IPM_Project__c updateProj = new IPM_Project__c(ID=regionalRollouts[0].IPM_Project__c,IPM_Target_Launch_Dates__c=regionalRollouts[0].Target_Launch_Date__c);
					// collect the project which need update on TLD
					if(origProjectMap.isEmpty() || !origProjectMap.keySet().contains(updateProj.id)){
						origProjectMap.put(updateProj.id,updateProj);
					
       				}
                }
                // Get all rollouts of retional projects order by TLD. 
                // This is required to update regional project's TLD with earliest regional rollout.
                for(IPM_Project_Rollout__c rolloutRegional : [Select Id, IPM_Rollout_Span__c, IPM_Project__c,Regional_Project__c, Target_Launch_Date__c from IPM_Project_Rollout__c where Regional_Project__c =:projIdRolloutIdMapRegional.KeySet() and  isActive__c=true ORDER BY Target_Launch_Date__c ASC NULLS LAST limit 50000]){
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
                    // collect retional projects
                   	if(rolloutRegional.IPM_Rollout_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL) {
                    	localRollouts.add(rolloutRegional);
                    }
                }  
				            if(!localRollouts.isEmpty()) {
       				IPM_Project__c updateProj = new IPM_Project__c(ID=localRollouts[0].Regional_Project__c,IPM_Target_Launch_Dates__c=localRollouts[0].Target_Launch_Date__c);
					// collect the project which need update on TLD
					if(origProjectMap.isEmpty() || !origProjectMap.keySet().contains(updateProj.id)){
						origProjectMap.put(updateProj.id,updateProj);
					
       				}
                }
                // Get all regional and global projects
                for(IPM_Project__c ipmProject : [Select Id, IPM_Project_Type__c,IPMProject_Span__c, IPM_Phase__c,IPM_Target_Launch_Dates__c from IPM_Project__c where id = :projIdRolloutIdMapRegional.keyset() or id = :projIdRolloutIdMapGlobal.keyset() limit 50000]){
                    // hendle for retional projects only
                    if(ipmProject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                        if(updatedLocalProjects.get(projIdRolloutIdMapRegional.get(ipmProject.Id)) != null) {
                            Date newTLDDate = updatedLocalProjects.get(projIdRolloutIdMapRegional.get(ipmProject.Id)).Target_Launch_Date__c;
							// handle Ideas Orininal project
                            if(ipmProject.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && ipmProject.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS){ 
                                if(newTLDDate < regionalProjRollOutMap.get(ipmProject.Id)){
                                    ipmProject.IPM_Target_Launch_Dates__c = newTLDDate;
       								// collect the project which need update on TLD
									if(origProjectMap.isEmpty() || !origProjectMap.keySet().contains(ipmProject.id)){
										origProjectMap.put(ipmProject.id,ipmProject);
       								}
                                } else if(regionalProjRollOutMap.get(ipmProject.Id) != ipmProject.IPM_Target_Launch_Dates__c){
                                    ipmProject.IPM_Target_Launch_Dates__c = regionalProjRollOutMap.get(ipmProject.Id);
       								// collect the project which need update on TLD
									if(origProjectMap.isEmpty() || !origProjectMap.keySet().contains(ipmProject.id)){
										origProjectMap.put(ipmProject.id,ipmProject);
       								
       								}
                                }
                                
                            } 
                            // handle Original Non-Ideas or Rollout Non-Ideas projects
                            else if((ipmProject.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT || ipmProject.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL )&& ipmProject.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS){
                                if(newTLDDate < regionalProjRollOutMap.get(ipmProject.Id)){
                                    ipmProject.IPM_Target_Launch_Dates__c = newTLDDate;
       								// collect the project which need update on TLD
									if(origProjectMap.isEmpty() || !origProjectMap.keySet().contains(ipmProject.id)){
										origProjectMap.put(ipmProject.id,ipmProject);
       								
       								}
                                } else if(regionalProjRollOutMap.get(ipmProject.Id) != ipmProject.IPM_Target_Launch_Dates__c){
                                    ipmProject.IPM_Target_Launch_Dates__c = regionalProjRollOutMap.get(ipmProject.Id);
       								// collect the project which need update on TLD
									if(origProjectMap.isEmpty() || !origProjectMap.keySet().contains(ipmProject.id)){
										origProjectMap.put(ipmProject.id,ipmProject);
       								
       								}
                                }
                            }
                        }
                    }               
                }
            }
            // update rollouts
            if(!listToUpdateRolloutProject.isEmpty()){
                update listToUpdateRolloutProject;
            }
            // update local projects
            if (!listToUpdateLocalProject.isEmpty()){
                update listToUpdateLocalProject;
            }
            // update non-local projects
            if(!origProjectMap.isEmpty()){
                update origProjectMap.values();
            } 
    }
    /*******************************************************************************************************
    * @description  Method to update TLD on milestone
    * @param        List IPM_Project
    * @return       NONE
    */
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
        // removed exception handling as any exceptions/Messages  would be handled at controller 
        if(!emailOut.isEmpty()){
            insert emailOut;
        }
    }
}