/*************************************************************************************
Name : BET_LinkingService

Purpose : Bet to IPM project linking service class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  03-08-2015  Initial
1.1        blessy.voola@accenture.com 24-Mar-2016    Do not send notification to inactive BET owner
*************************************************************************************/
/* Service class uses without sharing due to it is used by external system*/
public without sharing class BET_LinkingService {

    public static final String FOLLOW_STATUS_NEW = 'New';
    public static final String FOLLOW_STATUS_APPROVED = 'Approved';
    public static final String FOLLOW_STATUS_REJECTED = 'Rejected';

    private BET_LinkingService() {}

    /************************************************************
        Purpose: Method sets given project as lead for given bet
        Parameters: Id Ipm project id , Id related BET record
        Returns: -
        Throws: BET_CustomBETException
    *************************************************************/
    public static void setASLead(Id ProjectId, Id BetId){
        System.debug('Entering setASLead : ' + ProjectId + ', ' + BetId);
        List<uw_Bet__c> betRecords = [select id, ownerid, Is_Archived__c, IPM_Project__c, Launch_Date__c,Inoplan_Project_Keyword_Search__c from uw_Bet__c where id =: BetId];
        IPM_BETWrapper project = IPM_BETUpdateService.ipm_Wrapper(ProjectId);
        BET_LinkingServiceValidator.validateParams(betRecords);
        try{
            updateBetRecord(betRecords.get(0),project);
            //Do not send notification if BET owner is inactive
            User betowner=[select id,isactive from user where id=:betRecords.get(0).ownerid];
                if(betowner.isactive)
                 BET_EmailNotificationService.notifyBetOwnerOfNewLeadProject(betRecords.get(0),project);
        }catch(Exception e){
            throw new BET_CustomBETException(Label.BET_SetAsLeadExceptionMessage,e);
        }
        System.debug('Exit setASLead');
    }

    /************************************************************
        Purpose: Method updates bet record based on given project
        Parameters: uw_Bet__c bet,IPM_Project__c project
        Returns: -
        Throws: -
    *************************************************************/
    public static void updateBetRecord(uw_Bet__c bet,IPM_BETWrapper project){
        updateBet(bet,project);
    }

    /************************************************************
        Purpose: Method updates bet record based on given project
        Parameters: uw_Bet__c bet,Id projectId
        Returns: -
        Throws: -
    *************************************************************/
    public static void updateBet(uw_Bet__c bet,IPM_BETWrapper projectWrapper){
        System.debug('projectWrapper ' + projectWrapper + ' , ' +bet);
        bet.Launch_Date__c = projectWrapper.targetLaunchDate;
        bet.IPM_Project__c = projectWrapper.projectId;
        bet.Category_Group__c = projectWrapper.categoryGroupName;
        bet.Product_Category__c = projectWrapper.categoryName;
        bet.Brand_Position__c = projectWrapper.brandPosition;
        bet.Inoplan_Project_Keyword_Search__c = projectWrapper.projectName;
        update bet;
    }

    /************************************************************
        Purpose: Method creates ipm project's follow request
        Parameters: Id Ipm project id , Id related BET record, list of managers
        Returns: -
        Throws: BET_CustomBETException
    *************************************************************/
    public static void Follow(Id ProjectId, Id BetId, List<Id> managersIds){
        System.debug('Entering Follow : ' + ProjectId + ', ' + BetId + ', ' + managersIds);
        Set<Id> uniqueManagerIds = new Set<Id>(managersIds);
        List<Id> managers = new List<Id>(uniqueManagerIds);
        List<uw_Bet__c> betRecords = [select id, ownerid, Is_Archived__c, IPM_Project__c,Name from uw_Bet__c where id =: BetId];
        IPM_BETWrapper project = IPM_BETUpdateService.ipm_Wrapper(ProjectId);
        BET_LinkingServiceValidator.validateFollowRequest(betRecords);
        try{
            Boolean setToAutoApprove = BET_Settings__c.getOrgDefaults().FollowRequestAutoApproved__c == null ? false : BET_Settings__c.getOrgDefaults().FollowRequestAutoApproved__c;
            Boolean shouldBeAutoApproved = checkIfFollowRequestShouldBeAutoapproved(betRecords.get(0),managers);
            BET_Follow_Request__c followRequest = createFollowRequest(project,betRecords.get(0),managers);
            createRelatedMemberRequests(followRequest,betRecords.get(0),managers);
            if(shouldBeAutoApproved || setToAutoApprove) {
                followRequest.Status__c = FOLLOW_STATUS_APPROVED;
                update followRequest;
            } else {
                if(followRequest.Is_Lead_Request__c){
              //Do not send notification if BET owner is inactive
                User betowner=[select id,isactive from user where id=:betRecords.get(0).ownerid];
                if(betowner.isactive)
                 BET_EmailNotificationService.notifyBetOwnerOfLeadProjectFollowRequest(betRecords.get(0),project);
                }
            }
        }catch(Exception e){
            throw new BET_CustomBETException(Label.BET_FollowExceptionMessage,e);
        }
        System.debug('Exit Follow');
    }

    /************************************************************
        Purpose: Method creates ipm project's follow request record
        Parameters: IPM_Project__c project , uw_Bet__c bet, list of managers, list of managers
        Returns: BET_Follow_Request__c record
        Throws: -
    *************************************************************/
    @TestVisible
    private static BET_Follow_Request__c createFollowRequest(IPM_BETWrapper project, uw_Bet__c bet, List<Id> managersIds){
        System.debug('Entering createFollowRequest : ' + project + ', ' + bet + ', ' + managersIds);
        BET_Follow_Request__c request = new BET_Follow_Request__c();
        request.Brand_Experience_Toolkit__c = bet.id;
        request.Project_Id__c = project.projectId;
        request.Status__c = FOLLOW_STATUS_NEW;
        request.Project_Name__c = project.projectName;
        request.Project_Lead__c = managersIds.get(0);
        request.Is_Lead_Request__c = shouldMarkRequestAsLeadRequest(bet);
        request.Bet_owner__c = bet.ownerId;
        insert request;
        System.debug('Exit createFollowRequest : ' + request);
        return request;
    }

    /************************************************************
        Purpose: Method checks if reuest should be marked as lead
        Parameters: uw_Bet__c bet
        Returns: Boolean indicator
        Throws: -
    *************************************************************/
    @TestVisible
    private static Boolean shouldMarkRequestAsLeadRequest(uw_Bet__c bet){
        System.debug('Entering shouldMarkRequestAsLeadRequest : ' + bet);
        Boolean indicator = true;
        if(bet.IPM_Project__c != null) {
            indicator = false;
        }
        if(indicator) {
            List<BET_Follow_Request__c> requestsForGivenBet = [select id from BET_Follow_Request__c 
                                                            where Brand_Experience_Toolkit__c =: bet.id 
                                                            and Status__c !=: FOLLOW_STATUS_REJECTED 
                                                            and Is_Lead_Request__c = true];
            if(!requestsForGivenBet.isEmpty()) {
                indicator = false;
            }
        }
        System.debug('Exit shouldMarkRequestAsLeadRequest : ' + indicator);
        return indicator;
    }

    /************************************************************
        Purpose: Method checks if request should be autoapprove
        Parameters: uw_Bet__c relatedBet, list of managers
        Returns: Boolean indicator
        Throws: -
    *************************************************************/
    @TestVisible
    private static Boolean checkIfFollowRequestShouldBeAutoapproved(uw_Bet__c relatedBet , List<Id> managersIds){
        System.debug('Entering checkIfFollowRequestShouldBeAutoapproved : ' + relatedBet + ', ' + managersIds);
        Set<Id> managersSet = new Set<Id>();
        managersSet.addAll(managersIds);
        System.debug('Exit checkIfFollowRequestShouldBeAutoapproved : ' + managersSet.contains(relatedBet.ownerId));
        return managersSet.contains(relatedBet.ownerId);
    }

    /************************************************************
        Purpose: Method created related member requests
        Parameters: BET_Follow_Request__c followRequest,uw_Bet__c relatedBet,List<Id> managersIds
        Returns: List of member requests Ids
        Throws: -
    *************************************************************/
    @TestVisible
    private static List<Id> createRelatedMemberRequests(BET_Follow_Request__c followRequest,uw_Bet__c relatedBet,List<Id> managersIds){
        System.debug('Entering crateRelatedMemberRequests : ' + followRequest + ', ' + relatedBet + ', ' + managersIds);
        List<BET_Member_Request__c> mRequestsToBeCreated = new List<BET_Member_Request__c>();
        IPM_BETWrapper projectWrapper = IPM_BETUpdateService.ipm_Wrapper(followRequest.Project_Id__c);
        Boolean projectLeadAlreadyIncluded = false;
        for(Id managerId : managersIds){
            if(projectWrapper.pLId!= null && ((Id)projectWrapper.pLId) == ((Id)managerId)){
                projectLeadAlreadyIncluded = true;
            }
            if(managerId == relatedBet.ownerId){ // if manager is bet owner there is already an member record
                continue;
            }
            mRequestsToBeCreated.add(BET_LinkingServiceHelper.createMemberRequest(followRequest,relatedBet,'Manager',managerId));
        }

        if(!projectLeadAlreadyIncluded && projectWrapper.pLId != null && projectWrapper.pLId != relatedBet.ownerId){
            mRequestsToBeCreated.add(BET_LinkingServiceHelper.createMemberRequest(followRequest,relatedBet,'Manager',projectWrapper.pLId));
        }

        insert mRequestsToBeCreated;
        List<Id> requestIds = new List<Id>();
        for(BET_Member_Request__c mrequest : mRequestsToBeCreated){
            requestIds.add(mrequest.id);
        }
        System.debug('Exit crateRelatedMemberRequests : ' + requestIds);
        return requestIds;
    }

    /************************************************************
        Purpose: Method creates ipm project's unfollow request
        Parameters: Id Ipm project id , Id related BET record
        Returns: -
        Throws: BET_CustomBETException
        4.12.
        3.5.
    *************************************************************/
    public static void UnFollow(Id ProjectId, Id BetId){ //US 23
        System.debug('Entering UnFollow : ' + ProjectId + ', ' + BetId);
        List<uw_Bet__c> betRecords = [select id, ownerid, Is_Archived__c, IPM_Project__c,name,Launch_Date__c,Brand_Position__c,Product_Category__c,Category_Group__c,Final_Release_Due_Date__c,First_Release_Due_Date__c,Inoplan_Project_Keyword_Search__c from uw_Bet__c where id =: BetId];
        IPM_BETWrapper project = IPM_BETUpdateService.ipm_Wrapper(ProjectId);
        BET_LinkingServiceValidator.validateParams(betRecords);
        Id betOwner = betRecords.get(0).ownerid;
        try{
            Boolean projectIsALead = BET_LinkingServiceHelper.isProjectALead(ProjectId,betRecords.get(0));
            if(projectIsALead){
                IPM_BETWrapper newProject = BET_LinkingServiceHelper.getOtherFollowingProject(ProjectId,BetId);         
                if(newProject == null){
                    BET_LinkingServiceHelper.archiveAndUnLeadBet(betRecords.get(0)); //US26
                    //Do not send notification if BET owner is inactive
                    User owner=[select id,isactive from user where id=:betOwner];
                if(owner.isactive)
                    BET_EmailNotificationService.notifyBetOwnerOfUnfollow(betRecords.get(0),project); //US22
                } else {
                    Id oldBetOwner = betRecords.get(0).id;
                    Id oldPL = project.pLId;
                    Id newPL = newProject.pLId;
                    uw_Bet__c bet = BET_LinkingServiceHelper.setNewLeadProjectAndOwner(betRecords.get(0),newProject,project);
                    betOwner = bet.ownerid;
                    if(betOwner != oldBetOwner){
                        BET_LinkingServiceCleaner.removeOldBetOwnerFromMembers(oldBetOwner,betRecords.get(0));
                    }
                    if(betOwner != oldPL && oldPL != newPL){
                        BET_LinkingServiceCleaner.removeOldPLFromMembers(oldPL,betRecords.get(0),project.projectId);
                    }
                    if(betOwner != newPL){
                        System.debug('need to create approved member (manager) request for new PL');
                        BET_LinkingServiceHelper.createMemberRequestForNewPL(newPL,betRecords.get(0),project);
                    }
                }
            }
            BET_LinkingServiceCleaner.removeIPMProjectFollowRequestsFromBet(ProjectId,BetId);
            BET_LinkingServiceCleaner.removeIPMProjectMembersFromBet(ProjectId,BetId,betOwner); //US25
        }catch(Exception e){
            throw new BET_CustomBETException(Label.BET_UnFollowExceptionMessage,e);
        }
        System.debug('Exit UnFollow');
    }

    /************************************************************
        Purpose: Method returns all follow request records for given bet and ipm project
        Parameters: Id betIdCtrl,Id projectIdCtrl
        Returns: List of existing follow requests
        Throws: -
    *************************************************************/
    public static List<BET_Follow_Request__c> getFollowRequestsForBetAndIpm(Id betIdCtrl,Id projectIdCtrl){
        return [SELECT id from BET_Follow_Request__c WHERE Brand_Experience_Toolkit__c =: betIdCtrl and Project_Id__c =:projectIdCtrl];
    }

}