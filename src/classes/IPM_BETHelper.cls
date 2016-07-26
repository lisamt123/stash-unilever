/**
    @Description: Helper class to implement all methods needed for IPM BET module
    @Author: Cognizant Technology
    @Date: 12/9/2015
**/

/*
     This class has been defined as Without Sharing as the methods are invoked via BET Integration service methods which needs 
     to access all related IPM and MDO data irrespective of sharing.
*/
public without sharing class IPM_BETHelper {

    // Method to Update BET Milestones DueDate after BET is associated/updated to IPM Project    
    public static void updateBETmilestones(map < string, ipm_project__c > mapProjBET) {
        list < IPM_Milestone__c > lstMS = new list < IPM_Milestone__c > ();
        map < id, date > mapPidBETFinalReleaseDate = new map < id, date > ();
        map < id, BET_BETwrapper > mapbetIdWrapper = new map < id, BET_BETwrapper > ();
        map < id, string > mapPidProjectPhase = new map < id, string > ();
        // Get all relevant BETs in a map so as to avoid multiple queries to BET services
        for (id pid: mapProjBET.keySet()) {
            if (String.isNotBlank(mapProjBET.get(pid).BET__c) && !mapProjBET.containskey(mapProjBET.get(pid).BET__c)) {
                mapbetIdWrapper.put(mapProjBET.get(pid).BET__c, (BET_BETwrapper) BET_BETService.getBet(mapProjBET.get(pid).BET__c));
                if (mapbetIdWrapper.get(mapProjBET.get(pid).BET__c).status == IPM_ConstantUtils.BET_FINAL_RELEASE && mapbetIdWrapper.get(mapProjBET.get(pid).BET__c).finalReleaseDate != null) {
                    mapPidBETFinalReleaseDate.put(pid, mapbetIdWrapper.get(mapProjBET.get(pid).BET__c).finalReleaseDate);
                }
            }
        }
        // Get BET FInal Release Date's corresponding Project Phase
        if (!mapPidBETFinalReleaseDate.isEmpty()) {
            for (IPM_Project__History pHist: [select createddate, NewValue, ParentId FROM IPM_Project__History where field = : IPM_ConstantUtils.STRING_PROJECT_PHASE_API and parentid in : mapPidBETFinalReleaseDate.keySet() order by parentId, createddate desc limit 10000]) {
                if (!mapPidProjectPhase.containskey(pHist.ParentId) && mapPidBETFinalReleaseDate.get(pHist.ParentId) != null && pHist.createddate < mapPidBETFinalReleaseDate.get(pHist.ParentId)) {
                    mapPidProjectPhase.put(pHist.ParentId, string.valueOf(pHist.NewValue));
                }
            }
        }
        // Get Phase for BET's which released prior to Ideas Phase
        if (!mapPidBETFinalReleaseDate.isEmpty()) {
            for (id pid: mapPidBETFinalReleaseDate.keySet()) {
                if (!mapPidProjectPhase.isEmpty() && !mapPidProjectPhase.containskey(pid)) {
                    mapPidProjectPhase.put(pid, IPM_ConstantUtils.PHASE_IDEAS);
                }
            }
        }

        for (string pid: mapProjBET.keySet()) {
            if (String.isNotBlank(mapProjBET.get(pid).BET__c)) {
                lstMS.add(new IPM_Milestone__c(Name = IPM_ConstantUtils.BET_MS_FIRST_RELEASE, IPM_Name__c = IPM_ConstantUtils.BET_MS_FIRST_RELEASE, IPM_Project__c = pid, IPM_Type_of_Milestone__c = IPM_ConstantUtils.STRING_BET, RecordTypeId = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.milePMRecordType).getRecordTypeId(), IPM_Due_Date__c = mapbetIdWrapper.get(mapProjBET.get(pid).BET__c).firstReleaseDueDate, IPM_Completed_On__c = mapbetIdWrapper.get(mapProjBET.get(pid).BET__c).firstReleaseDate, IPM_Completed__c = mapbetIdWrapper.get(mapProjBET.get(pid).BET__c).firstReleaseDate!=null?true:false, ExternalField__c = pid + IPM_ConstantUtils.BET_MS_FIRST_RELEASE, IPM_Active__c = true));
                lstMS.add(new IPM_Milestone__c(Name = IPM_ConstantUtils.BET_MS_FINAL_RELEASE, IPM_Name__c = IPM_ConstantUtils.BET_MS_FINAL_RELEASE, IPM_Project__c = pid, IPM_Type_of_Milestone__c = IPM_ConstantUtils.STRING_BET, RecordTypeId = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.milePMRecordType).getRecordTypeId(), IPM_Due_Date__c = mapbetIdWrapper.get(mapProjBET.get(pid).BET__c).finalReleaseDueDate, IPM_Completed_On__c = mapbetIdWrapper.get(mapProjBET.get(pid).BET__c).finalReleaseDate, IPM_Completed__c = mapbetIdWrapper.get(mapProjBET.get(pid).BET__c).finalReleaseDate!=null?true:false ,IPM_Phase__c = (!mapPidProjectPhase.isEmpty() && mapPidProjectPhase.containsKey(pid)) ? mapPidProjectPhase.get(pid) : null, ExternalField__c = pid + IPM_ConstantUtils.BET_MS_FINAL_RELEASE, IPM_Active__c = true));
            } else {
                lstMS.add(new IPM_Milestone__c(Name = IPM_ConstantUtils.BET_MS_FIRST_RELEASE, IPM_Name__c = IPM_ConstantUtils.BET_MS_FIRST_RELEASE, IPM_Project__c = pid, IPM_Type_of_Milestone__c = IPM_ConstantUtils.STRING_BET, RecordTypeId = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.milePMRecordType).getRecordTypeId(), IPM_Due_Date__c = BET_BETService.getFirstReleaseDueDate(mapProjBET.get(pid).IPM_Target_Launch_Dates__c), IPM_Completed_On__c = null, ExternalField__c = pid + IPM_ConstantUtils.BET_MS_FIRST_RELEASE, IPM_Active__c = true));
                lstMS.add(new IPM_Milestone__c(Name = IPM_ConstantUtils.BET_MS_FINAL_RELEASE, IPM_Name__c = IPM_ConstantUtils.BET_MS_FINAL_RELEASE, IPM_Project__c = pid, IPM_Type_of_Milestone__c = IPM_ConstantUtils.STRING_BET, RecordTypeId = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.milePMRecordType).getRecordTypeId(), IPM_Due_Date__c = BET_BETService.getFinalReleaseDueDate(mapProjBET.get(pid).IPM_Target_Launch_Dates__c), IPM_Completed_On__c = null, ExternalField__c = pid + IPM_ConstantUtils.BET_MS_FINAL_RELEASE, IPM_Active__c = true));
            }
        }

        upsert lstMS ExternalField__c;

    }

    //Method to Update BET Milestone passed checkbox on IPM Project
    public static void updateBETMilestoneMissOnProject(map < id, list < IPM_Milestone__c >> mapProjectBETMS) {
        list < IPM_project__c > lstProjects = new list < IPM_Project__c > ();

        lstProjects = [select id, BET__c from IPM_Project__c where id in : mapProjectBETMS.keyset() limit 10000];

        if (!lstProjects.isEmpty()) {
            for (IPM_Project__c proj: lstProjects) {
                for (IPM_Milestone__c ms: mapProjectBETMS.get(proj.id)) {
                    // Check for BET First Release Milestone
                    if (String.isNotBlank(proj.BET__c) && ((BET_BETwrapper) BET_BETService.getBet(proj.BET__c)).status == IPM_ConstantUtils.BET_UNRELEASED && ms.IPM_Due_Date__c < date.today() && ms.IPM_Name__c.indexOf(IPM_ConstantUtils.BET_MS_FIRST_RELEASE) != -1) {
                        proj.BET_First_Release_Missed__c = true;
                    }
                    // Check for BET Final Release Milestone
                    if (String.isNotBlank(proj.BET__c) && ((BET_BETwrapper) BET_BETService.getBet(proj.BET__c)).status != IPM_ConstantUtils.BET_FINAL_RELEASE && ms.IPM_Due_Date__c < date.today() && ms.IPM_Name__c.indexOf(IPM_ConstantUtils.BET_MS_FINAL_RELEASE) != -1) {
                        proj.BET_Final_Release_Missed__c = true;
                    }
                }
            }

            update lstProjects;
        }

    }
	// Update the BET current status on Project Object When BET statuus changed
	public static void updateCurrentBETStatusOnProject(BET_BETWrapper BET,list<IPM_Project__c> associatedProjectList)
	{
		for(IPM_Project__c project : associatedProjectList)
		{
			project.BETCurrentStatus__c = BET.status;
		} 
		 
		IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
		update associatedProjectList;
		IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
	}
	
    //Method to reset BET Milestone date missed alert 
    public static void resetMilestoneMissedFlag(Id BETId, BET_BETWrapper BET) {
        list < IPM_Project__c > lstPRoject = new list < IPM_Project__c > ();
        lstPRoject = [select id, BET_First_Release_Missed__c, BET_Final_Release_Missed__c from IPM_Project__c where bet__c = : BET.betid limit 50000]; 
        for (IPM_Project__c proj: lstPRoject) {
            if (BET.status == IPM_ConstantUtils.BET_FINAL_RELEASE) {
                proj.BET_First_Release_Missed__c = false;
                proj.BET_Final_Release_Missed__c = false;
            } else if (BET.status == IPM_ConstantUtils.BET_FIRST_RELEASE) {
                proj.BET_First_Release_Missed__c = false;
            }
        }

        update lstPRoject;
    }

    //Method to update Phase of BET Final Release Milestone
    public static void updatePhaseBETMSFinalRelease(id betId) {
        list < IPM_Milestone__c > lstMS = new list < IPM_Milestone__c > ();
        BET_BETWrapper bwrap = new BET_BETWrapper();
        bwrap = BET_BETService.getBet(betId);
        for (IPM_Project__c prj: [select id, IPM_Phase__c, bet__c, (select id, IPM_Phase__c from IPM_Milestones__r where IPM_Type_of_Milestone__c = : IPM_ConstantUtils.STRING_BET and IPM_Name__c like: (IPM_ConstantUtils.SYMBOL_PERCENTAGE + IPM_ConstantUtils.BET_MS_FINAL_RELEASE + IPM_ConstantUtils.SYMBOL_PERCENTAGE)) from IPM_Project__c where bet__c = : betId limit 50000]) {
            for (IPM_Milestone__c betMSFL: prj.IPM_Milestones__r) {
                if (string.isBlank(betMSFL.IPM_Phase__c)) {
                    betMSFL.IPM_Phase__c = prj.IPM_Phase__c;
                    if(bwrap!=null){
                        betMSFL.IPM_Completed__c = true;
                        betMSFL.IPM_Completed_On__c = bwrap.finalReleaseDate;
                    }
                    lstMS.add(betMSFL);
                }
            }
        } 
        if (!lstMS.isEmpty()) {

            update lstMS;
        }
    }

    //Method to send updates to BET on Project update in IPM
    public static void sendIPMupdatetoBET(list < IPM_Project__c > lstTriggerNew, list < IPM_Project__c > lstTriggerOld) {
        integer i = 0;
        List < Schema.FieldSetMember > projectFields = SObjectType.IPM_Project__c.FieldSets.IPM_BETProjectFieldsUpdated.getFields();
        for (IPM_Project__c proj: lstTriggerNew) {
            for (Schema.FieldSetMember f: projectFields) {
                if (String.isNotBlank(Proj.bet__c) && proj.get(f.getFieldPath()) != lstTriggerOld.get(i).get(f.getFieldPath())) {
                    Id BetId = proj.bet__c;
                    IPM_BETWrapper IPMProject = new IPM_BETWrapper(proj);
                    BET_BETService.updateBet(BetId, IPMProject);
                    break;
                }
            }

            i++;
        }
    }

    //Method to send Regional/Local Rollout Leaders' Access Request to BET after BET First Release
    public static void sendBETAccessRequestonFirstRelease(id betId) {
        //Call helper method to send Access Request per project
        for (IPM_Project__c proj: [select id from IPM_Project__c where bet__c = : betId limit 50000]) {
            sendBETAccessRequestonFirstReleasePerProject(betId, proj.Id);
        }
        //Update related BET First Release Milestone
        BET_BETWrapper bwrap = new BET_BETWrapper();
        bwrap = BET_BETService.getBet(betId);
        list <IPM_Milestone__c> lstMS = new list <IPM_Milestone__c> ();
        for(IPM_Milestone__c betMS: [select id from IPM_Milestone__c where IPM_Type_of_Milestone__c = : IPM_ConstantUtils.STRING_BET and IPM_Name__c like: (IPM_ConstantUtils.SYMBOL_PERCENTAGE + IPM_ConstantUtils.BET_MS_FIRST_RELEASE + IPM_ConstantUtils.SYMBOL_PERCENTAGE) and IPM_Project__r.BET__c=:betid]){
            betMS.IPM_Completed__c = true;
            betMS.IPM_Completed_On__c = bwrap.firstReleaseDate;
            lstMS.add(betMS);
        }
        //Update BET First release Milestone with Completed date
        if(!lstMS.isEmpty()){
            update lstMS;
        }
    }
    //Method to send Access request to BET per project
    public static void sendBETAccessRequestonFirstReleasePerProject(id betId, id projectId) {
        list < BET_BETWrapper.MemberRequest > lstMemberRequests = new list < BET_BETWrapper.MemberRequest > ();
        set < string > setRegionalRoles = new set < string > ();
        set < string > setLocalRoles = new set < string > ();
        setRegionalRoles.addAll(IPM_ConstantUtils.STRING_REGIONAL_ROLES.SPLIT(';'));
        setLocalRoles.addALl(IPM_ConstantUtils.STRING_LOCAL_ROLES.SPLIT(';'));
        
        set<id> setIds = new set<id>();
        //Get All users to be given access
        for (IPM_Project__c proj: [select IPM_Project_Leader__c, Deputy_Project_Leader__c, (select IPM_User__c from IPM_Project_Resources__r where ((IPM_Project__r.IPMProject_Span__c = : IPM_ConstantUtils.PROJECT_SPAN_REGIONAL and IPM_Role_Type__c in : setRegionalRoles) OR(IPM_Project__r.IPMProject_Span__c = : IPM_ConstantUtils.PROJECT_SPAN_LOCAL and IPM_Role_Type__c in : setLocalRoles))) from IPM_Project__c where (IPM_Parent_Project__c = : projectId OR IPM_Parent_Project__r.BET__c = : betId) OR (IPM_Parent_Project__r.IPM_Parent_Project__c = : projectId OR IPM_Parent_Project__r.IPM_Parent_Project__r.BET__c = : betId) limit 10000]) {
            if(setIds.isEmpty() || (!setIds.isEmpty() && !setIds.contains(proj.IPM_Project_Leader__c))){
                lstMemberRequests.add(generateBETMember(proj.IPM_Project_Leader__c, IPM_ConstantUtils.BET_MANAGER_ACCESS));
                setIds.add(proj.IPM_Project_Leader__c);
            }
            if(setIds.isEmpty() || (!setIds.isEmpty() && !setIds.contains(proj.Deputy_Project_Leader__c))){
                lstMemberRequests.add(generateBETMember(proj.Deputy_Project_Leader__c, IPM_ConstantUtils.BET_MANAGER_ACCESS));
                setIds.add(proj.Deputy_Project_Leader__c);
            }
            for (IPM_Project_Resource__c proMember: proj.IPM_Project_Resources__r) {
                if(setIds.isEmpty() || (!setIds.isEmpty() && !setIds.contains(proMember.IPM_User__c))){
                    lstMemberRequests.add(generateBETMember(proMember.IPM_User__c, IPM_ConstantUtils.BET_MANAGER_ACCESS));
                    setIds.add(proMember.IPM_User__c);
                }
            }
        }
        if (!lstMemberRequests.isEmpty()) {
            BET_AccessService.RequestAccess(lstMemberRequests, betId, projectId);
        }
    }

    //Method to Request BET access for eligible new members in IPM
    public static void sendBETAccessRequest(list < id > lstUserId, id betId, id projectId) {
        list < BET_BETWrapper.MemberRequest > lstMemberRequests = new list < BET_BETWrapper.MemberRequest > ();
        set<id> setIds = new set<Id>();
        for (id usrId: lstUserId) {
            if(setIds.isEmpty() || (!setIds.isEmpty() && !setIds.contains(usrId))){
                lstMemberRequests.add(generateBETMember(usrId, IPM_ConstantUtils.BET_MANAGER_ACCESS));
                setIds.add(usrId);
            }
        }
        //Call BET service to send access request
        if (!lstMemberRequests.isEmpty()) {
            BET_AccessService.RequestAccess(lstMemberRequests, betId, projectId);
        }
    }

    public static BET_BETWrapper.MemberRequest generateBETMember(id userId, string role) {
        BET_BETWrapper.MemberRequest member = new BET_BETWrapper.MemberRequest();
        member.UserId = userId;
        member.AccessLevel = role;
        return member;
    }
                        
    public static void sendRolloutMemberBETAccessRequest(map < id, set < IPM_Project_Resource__c >> mapProjResources) {
        map < id, set < id >> mapBETsetProjId = new map < id, set < id >> ();
        map < id, set < id >> mapProjRollouts = new map < id, set < id >> ();
        set < id > setRegionalRollouts = new set < id > ();
        set < id > setLocalRollouts = new set < id > ();

        if (mapProjResources != null && !mapProjResources.isEmpty()) {
            for (IPM_Project__c proj: [select id, IPM_Project_Type__c, IPMProject_Span__c, IPM_Parent_Project__c, IPM_Parent_Project__r.IPM_Parent_Project__c, IPM_Parent_Project__r.bet__c, IPM_Parent_Project__r.IPM_Parent_Project__r.bet__c from IPM_Project__c where id in : mapProjResources.keySet() AND IPM_Project_Type__c = : IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT AND(IPMProject_Span__c = : IPM_ConstantUtils.PROJECT_SPAN_REGIONAL OR IPMProject_Span__c = : IPM_ConstantUtils.PROJECT_SPAN_LOCAL) limit 50000]) {
                if (proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && string.isNotBlank(proj.IPM_Parent_Project__r.bet__c)) {
                    setRegionalRollouts.add(proj.id);
                    if (mapBETsetProjId.isEmpty() || !mapBETsetProjId.containsKey(proj.IPM_Parent_Project__r.bet__c)) {
                        set < id > temp = new set < id > ();
                        temp.add(proj.IPM_Parent_Project__c);
                        mapBETsetProjId.put(proj.IPM_Parent_Project__r.bet__c, temp);
                    } else if (!mapBETsetProjId.isEmpty() && mapBETsetProjId.containsKey(proj.IPM_Parent_Project__r.bet__c)) {
                        mapBETsetProjId.get(proj.IPM_Parent_Project__r.bet__c).add(proj.IPM_Parent_Project__c);
                    }
                    if (mapProjRollouts.isEmpty() || !mapProjRollouts.containskey(proj.IPM_Parent_Project__c)) {
                        set < id > temp = new set < id > ();
                        temp.add(proj.id);
                        mapProjRollouts.put(proj.IPM_Parent_Project__c, temp);
                    } else if (!mapProjRollouts.isEmpty() && mapProjRollouts.containskey(proj.IPM_Parent_Project__c)) {
                        mapProjRollouts.get(proj.IPM_Parent_Project__c).add(proj.id);
                    }
                } else if (proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && (string.isNotBlank(proj.IPM_Parent_Project__r.bet__c) || string.isNotBlank(proj.IPM_Parent_Project__r.IPM_Parent_Project__r.bet__c)))
                 { 
                    setLocalRollouts.add(proj.id);
                    if (string.isNotBlank(proj.IPM_Parent_Project__r.bet__c)) { 
                        if (mapBETsetProjId.isEmpty() || !mapBETsetProjId.containsKey(proj.IPM_Parent_Project__r.bet__c)) {
                            set < id > temp = new set < id > ();
                            temp.add(proj.IPM_Parent_Project__c);
                            mapBETsetProjId.put(proj.IPM_Parent_Project__r.bet__c, temp);
                        } else if (!mapBETsetProjId.isEmpty() && mapBETsetProjId.containsKey(proj.IPM_Parent_Project__r.bet__c)) {
                            mapBETsetProjId.get(proj.IPM_Parent_Project__r.bet__c).add(proj.IPM_Parent_Project__c);
                        }
                        if (mapProjRollouts.isEmpty() || !mapProjRollouts.containskey(proj.IPM_Parent_Project__c)) {
                            set < id > temp = new set < id > ();
                            temp.add(proj.id);
                            mapProjRollouts.put(proj.IPM_Parent_Project__c, temp);
                        } else if (!mapProjRollouts.isEmpty() && mapProjRollouts.containskey(proj.IPM_Parent_Project__c)) {
                            mapProjRollouts.get(proj.IPM_Parent_Project__c).add(proj.id);
                        }
                    } else if (string.isNotBlank(proj.IPM_Parent_Project__r.IPM_Parent_Project__r.bet__c)) { 
                        if (mapBETsetProjId.isEmpty() || !mapBETsetProjId.containsKey(proj.IPM_Parent_Project__r.IPM_Parent_Project__r.bet__c)) {
                            set < id > temp = new set < id > ();
                            temp.add(proj.IPM_Parent_Project__r.IPM_Parent_Project__c);
                            mapBETsetProjId.put(proj.IPM_Parent_Project__r.IPM_Parent_Project__r.bet__c, temp);
                        } else if (!mapBETsetProjId.isEmpty() && mapBETsetProjId.containsKey(proj.IPM_Parent_Project__r.IPM_Parent_Project__r.bet__c)) {
                            mapBETsetProjId.get(proj.IPM_Parent_Project__r.IPM_Parent_Project__r.bet__c).add(proj.IPM_Parent_Project__r.IPM_Parent_Project__c);
                        }

                        if (mapProjRollouts.isEmpty() || !mapProjRollouts.containskey(proj.IPM_Parent_Project__r.IPM_Parent_Project__c)) {
                            set < id > temp = new set < id > ();
                            temp.add(proj.id);
                            mapProjRollouts.put(proj.IPM_Parent_Project__r.IPM_Parent_Project__c, temp);
                        } else if (!mapProjRollouts.isEmpty() && mapProjRollouts.containskey(proj.IPM_Parent_Project__r.IPM_Parent_Project__c)) {
                            mapProjRollouts.get(proj.IPM_Parent_Project__r.IPM_Parent_Project__c).add(proj.id);
                        }
                    }
                }
            }
            if (!mapBETsetProjId.isEmpty()) {
                for (id betId: mapBETsetProjId.keySet()) {
                    BET_BETwrapper iBET = (BET_BETwrapper) BET_BETService.getBet(betId);
                    if (iBET.status == IPM_ConstantUtils.BET_FIRST_RELEASE || iBET.status == IPM_ConstantUtils.BET_FINAL_RELEASE) {
                        for (id projectId: mapBETsetProjId.get(betId)) {
                            if (mapProjResources.containsKey(projectId)) {
                                set < id > setUserId = new set < id > ();
                                for (IPM_Project_Resource__c pr: mapProjResources.get(projectId)) {
                                    if (projectId != null) {
                                        if (!setRegionalRollouts.isEmpty() && setRegionalRollouts.contains(pr.IPM_Project__c) && IPM_ConstantUtils.STRING_REGIONAL_ROLES.indexOf(pr.IPM_Role_Type__c) != -1) {
                                            setUserId.add(pr.IPM_User__c);
                                        } else if (!setLocalRollouts.isEmpty() && setLocalRollouts.contains(pr.IPM_Project__c) && IPM_ConstantUtils.STRING_LOCAL_ROLES.indexOf(pr.IPM_Role_Type__c) != -1) {
                                            setUserId.add(pr.IPM_User__c);
                                        }
                                    }
                                }
                                if (!setUserId.isEmpty()) {
                                    list < id > temp = new list < id > ();
                                    temp.addAll(setUserId);
                                    sendBETAccessRequest(temp, betId, projectId);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //Method to update Archived BET details on Project.
	public static void setArchiveBET_IPM(BET_BETWrapper BET) {
        list < IPM_Project__c > lstIPM = new list < IPM_Project__c > ();
        for (IPM_Project__c ipm: [select id from IPM_Project__c where bet__c = : BET.betid limit 50000]) {
            ipm.BET_Archived_BET__c = BET.betid;
            ipm.BET_Archived_Date__c = system.today();
            ipm.BET_Archived_BET_Text__c = BET.betName;
            ipm.BET_Archive_Status__c = BET.status;
            lstIPM.add(ipm);
        }
        if (!lstIPM.isEmpty()) {
            update lstIPM;
        }
    }
	//Method to update BET details on IPM
	@future
	public static void updateBETlinktoProject(id betId, id projectId){
		IPM_Project__c proj = new IPM_Project__c();
		try{
			proj = [select bet__c,id from IPM_Project__c where id = :projectId  LIMIT 1  FOR UPDATE];
			if(betId!=null){
				proj.BET__c = betId;
				update proj;
			}
		}catch(exception ex){
			ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BETHelper.class.getName(),'updateBETlinktoProject',ex.getMessage(), Ex,IPM_ConstantUtils.ERROR, null, ex.getStackTraceString(), null, null) ;	
		}
	}
	
}
