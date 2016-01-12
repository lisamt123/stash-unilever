/*************************************************************************************
Name : BET_SuggestMembersController

Purpose : Controller for BET_SuggestMembers component

History

VERSION  AUTHOR                         DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com   20-07-2015  Initial
*************************************************************************************/

public with sharing class BET_SuggestMembersController {
    
    public Id betIdCtrl{get;set;}
    public Id projectIdCtrl{get;set;}
    public String callbackCtrl{get;set;}
    
    public List<BET_MemberBucketWrapper> user_bucketsCtrl{get;set;}
    public List<Id> suggested_managersCtrl{get;set;}
    public Id memberToDelete{get;set;}
    public User betOwnerInfo{get;set;}
    public User managerInfo{get;set;}
    public String searchUserName{get;set;}
    public List<User> freeAddMembers{get;set;}
    public String newlyAddedUsers{get;set;}
    public String externalMemberEmail{get;set;}
    public String externalMemberEmailBet{get;set;}
    public String emailToDelete {get;set;}

    public List<ExternalAgencyMemberWrapper> externalMembers {
        get{
            if(externalMembers == null){
                externalMembers = new List<ExternalAgencyMemberWrapper>();
            }
                return externalMembers;
            }
        set {
            if(value != null){
                externalMembers = value;
            } 
        }
    }
    
    public List<Id> suggested_MembersCtrl{
        get{
            if(suggested_MembersCtrl == null){
                suggested_MembersCtrl = new List<Id>();
                return suggested_MembersCtrl;
            }else{
                return suggested_MembersCtrl;
            }
            
        }
        
        set{
            if(value != null){
                suggested_MembersCtrl = value;
            }
             
        }
    }	
        
    public BET_SuggestMembersController() {
		freeAddMembers = new List<User>();
        
        if(suggested_MembersCtrl == null){
            suggested_MembersCtrl = new List<Id>();
        }
        
        if(user_bucketsCtrl == null){
            user_bucketsCtrl = new List<BET_MemberBucketWrapper>();
        }
        
        if(suggested_managersCtrl == null){
            suggested_managersCtrl = new List<Id>();
        }
        
	}
    
    /************************************************************
        Purpose: Wrapper class is a placeholder for displayed suggested members
    *************************************************************/
    public class SuggestedMembersWrapper{
        public SuggestedMembersWrapper(){}
        public String groupName{get;set;}
        public List<SuggestedMemberItemWrapper> groupUsers{get;set;}
        
    }
    
    /************************************************************
        Purpose: Wrapper class is a placeholder for displayed suggested members
    *************************************************************/
    public class SuggestedMemberItemWrapper{
        public SuggestedMemberItemWrapper(){}
        public User userInfo{get;set;}
        public Boolean isManager{get;set;}
    }

    /************************************************************
        Purpose: Wrapper class for external agency members
    *************************************************************/
    public class ExternalAgencyMemberWrapper{
        public ExternalAgencyMemberWrapper(){}
        public String email {get;set;}
        public String photo;
        public Id userId {get;set;}
        public String getPhoto(){
            return '/profilephoto/005/F';
        }
    }

    /************************************************************
        Purpose: Wrapper class for managers
    *************************************************************/
    public class ManagerWrapper {
        public String FullPhotoUrl {get;set;}
        public String Name {get;set;}

        public ManagerWrapper(){}
        public ManagerWrapper(BET_Member_Request__c managerMember){
            this.Name = managerMember.UserId__r.FirstName + ' ' + managerMember.UserId__r.LastName;
            this.FullPhotoUrl = managerMember.UserId__r.FullPhotoUrl;
        }
    }

    /************************************************************
        Purpose: Wrapper class for managers
        Parameters: -
        Returns: List<ManagerWrapper> 
        Throws: -
    *************************************************************/
    public List<ManagerWrapper> getManagers(){
        List<ManagerWrapper> managersList = new List<ManagerWrapper>();
        Set<Id> uniqueUsers = new Set<Id>();
        
        if(!String.isBlank(projectIdCtrl)) {
            IPM_BETWrapper project;
            Boolean isIPMProject = true;
            try{
                project = IPM_BETUpdateService.ipm_Wrapper(projectIdCtrl);
            }catch(Exception e){
                isIPMProject = false;
            }
            if(isIPMProject && project.pLId != null && project.pLId == UserInfo.getUserId()){
                for(BET_Member_Request__c managerMember : [SELECT Id,UserId__c,UserId__r.FirstName,UserId__r.LastName,UserId__r.FullPhotoUrl FROM BET_Member_Request__c WHERE ProjectRequest__c in (select id FROM BET_Follow_Request__c WHERE Status__c =: 'New' and Brand_Experience_Toolkit__c =: betIdCtrl and Project_Id__c =: projectIdCtrl)]){
                    if(!uniqueUsers.contains(managerMember.UserId__c)){
                        managersList.add(new ManagerWrapper(managerMember));
                        uniqueUsers.add(managerMember.UserId__c);
                    }
                }
            }
        }

        for(BET_Member_Request__c managerMember : [SELECT Id,UserId__c,UserId__r.FirstName,UserId__r.LastName,UserId__r.FullPhotoUrl FROM BET_Member_Request__c WHERE  Role__c =: Label.BETManagerRole and Status__c = 'Approved' and Project_Id__c =: projectIdCtrl and Brand_Experience_Toolkit__c =: betIdCtrl]){
            if(!uniqueUsers.contains(managerMember.UserId__c)){
                managersList.add(new ManagerWrapper(managerMember));
                uniqueUsers.add(managerMember.UserId__c);
            }
        }
        return managersList;
    }
	
    /************************************************************
        Purpose: Method responsible for displaying suggested member list
        Parameters: -
        Returns: List<SuggestedMembersWrapper>
        Throws: -
    *************************************************************/
    public List<SuggestedMembersWrapper> getSuggestedMembers(){
        System.debug('Entering method getSuggestedMembers');
        List<SuggestedMembersWrapper> membersToDisplay = new List<SuggestedMembersWrapper>();
        
        if(user_bucketsCtrl == null){
            user_bucketsCtrl = new List<BET_MemberBucketWrapper>();
        }
        
        Map<Id,User> suggestedUsers = new Map<Id,User>();
       
        suggestedUsers = new Map<Id,User>([SELECT Id,Name,FullPhotoUrl from USER where id in : suggested_MembersCtrl]);
        
        
        List<id> otherMemebers = suggested_MembersCtrl.clone();
        
        
        Map<String,Map<Id,Id>> convertedBacketToMap = BET_SuggestedMemberService.convertUserBucketToMap(user_bucketsCtrl);
        
        Map<Id,Id> managersMap = BET_SuggestedMemberService.convertSuggestedManagersToMap(suggested_managersCtrl);
        
        system.debug(convertedBacketToMap);
        for(BET_MemberBucketWrapper memberItem :  user_bucketsCtrl){
            
            SuggestedMembersWrapper memberWrapperItem = new SuggestedMembersWrapper();
            memberWrapperItem.groupName = memberItem.GroupName;
            memberWrapperItem.groupUsers = new List<SuggestedMemberItemWrapper>();
            for(Id suggestedId : suggested_MembersCtrl){
                if(convertedBacketToMap.containsKey(memberItem.GroupName) && 
                   convertedBacketToMap.get(memberItem.GroupName).containsKey(suggestedId)
                   && suggestedUsers.containsKey(suggestedId)
                  ){
                    SuggestedMemberItemWrapper memberItemWrap = new SuggestedMemberItemWrapper();
                    memberItemWrap.userInfo =   suggestedUsers.get(suggestedId);
                   
                    //check if user is manager  
                    if(managersMap.containsKey(suggestedId)){
                     	memberItemWrap.isManager = true;     
                    }else{
                        memberItemWrap.isManager = false;
                    }
                    memberWrapperItem.groupUsers.add(memberItemWrap);    
                    otherMemebers = BET_SuggestedMemberService.removeElementFromList(otherMemebers,suggestedId);  
                }
            }
            
            if(!memberWrapperItem.groupUsers.isEmpty()){
                membersToDisplay.add(memberWrapperItem);
            }
            
        }
        //add Other Members to bucket by default
        SuggestedMembersWrapper otherMemebersWrapper = new SuggestedMembersWrapper();
        otherMemebersWrapper.groupName = Label.BET_SuggestedMemberOtherMembers;
        otherMemebersWrapper.groupUsers = new List<SuggestedMemberItemWrapper>();
        otherMemebersWrapper = getWrapper(otherMemebersWrapper,otherMemebers,suggestedUsers,managersMap);
        membersToDisplay.add(otherMemebersWrapper);

        System.debug('Exiting method getSuggestedMembers with following result:'+JSON.serialize(membersToDisplay));
        return membersToDisplay;
	}

    @TestVisible
    private SuggestedMembersWrapper getWrapper(SuggestedMembersWrapper otherMemebersWrapper,List<Id> otherMemebers,Map<Id,User> suggestedUsers,Map<Id,Id> managersMap){
        if(!otherMemebers.isEmpty()){
            for(Id otherMemberId : otherMemebers){
                if(suggestedUsers.containsKey(otherMemberId)){
                    SuggestedMemberItemWrapper memberItemWrap = new SuggestedMemberItemWrapper();
                    memberItemWrap.userInfo = suggestedUsers.get(otherMemberId);
                   
                    //check if user is manager  
                    if(managersMap.containsKey(otherMemberId)){
                        memberItemWrap.isManager = true;     
                    }else{
                        memberItemWrap.isManager = false;
                    }
                    
                    otherMemebersWrapper.groupUsers.add(memberItemWrap);
                }
            }
        }
        return otherMemebersWrapper;
    }
    
    /************************************************************
        Purpose: Method adding newly added members to suggested_MembersCtrl property from 
			     newlyAddedUsers		
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public void addNewMembers(){
        System.debug('Entering method addNewMembers following users will be added:'+newlyAddedUsers);
        Set<Id> membersSet = new Set<Id>();
        membersSet.addAll(suggested_MembersCtrl);
        if(newlyAddedUsers != null){
            for(String userToAdd : newlyAddedUsers.split(',')){
                if(userToAdd != null && userToAdd.trim() != ''){
                    if(!membersSet.contains(Id.valueOf(userToAdd))) {
                        suggested_MembersCtrl.add(Id.valueOf(userToAdd));
                    } 
                }
            }
        }

        System.debug('add new members ' + suggested_MembersCtrl);

        newlyAddedUsers = '';
        freeAddMembers = new List<User>();
        searchUserName = '';
        System.debug('Exiting method addNewMembers current list of users:'+suggested_MembersCtrl);
    }
    
    /************************************************************
        Purpose: Method search users by name 
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public void  searchUsers(){
        System.debug('Entering method searchUsers : ' + betIdCtrl);
        Id betOwnerId = BET_CommonService.getOwnerIdOfGivenBet(betIdCtrl);
        System.debug('Preparing searchUsers query : ' + searchUserName  +', ' + betOwnerId);
        String query = 'SELECT Id,Name,SmallPhotoUrl,Title from User where   name like \'%'+searchUserName+'%\'  '
         + ' and isActive = true {0} and Id !=: betOwnerId ' 
         + ' and (Profile.UserLicense.Name = \'Salesforce Platform\' or Profile.UserLicense.Name = \'Salesforce\') Limit 50';
        
        if(suggested_MembersCtrl == null){
            query = query.replace('{0}','');
        } else {
            query = query.replace('{0}','and id not in : suggested_MembersCtrl');
        }
        
        freeAddMembers = Database.query(query);
        System.debug('Exiting method searchUsers controller property freeAddMembers was set to: '+JSON.serialize(freeAddMembers));
        
    }
    
    /************************************************************
        Purpose: Method responsible removin user from suggested memebers method called from UI and 
		removing user id from suggested_MembersCtrl list
        Parameters: -
        Returns: List<Id>
        Throws: -
    *************************************************************/
    public void deleteMember(){
        System.debug('Entering method deleteMember for following user: '+memberToDelete);
        List<Id> clonedCollection = suggested_MembersCtrl.clone();
        Integer index = 0;
        system.debug(suggested_MembersCtrl.size());
        for(id idItem : clonedCollection){
            if(idItem == memberToDelete){
                suggested_MembersCtrl.remove(index);
                break;
            }
            index++;
        }
    }

    /************************************************************
        Purpose: Method responsible removing user from external members called from UI
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
    public void delExternalMemeber(){
        Integer index = 0;
        Integer indexToBeRemoved = 0;
        for(ExternalAgencyMemberWrapper wrap : externalMembers){
            if(wrap.email == emailToDelete){
                indexToBeRemoved = index;
            }
            index++;
        }
        externalMembers.remove(indexToBeRemoved);
    }
    
    /************************************************************
        Purpose: Method responsible for createing new Bet Member Requests records in db
        Parameters: -
        Returns: List<Id>
        Throws: -
    *************************************************************/
    public PageReference addMembers(){
        System.debug('Entering method addMembers for following user: '+suggested_MembersCtrl);
        List<BET_Follow_Request__c> betFollowRequest = new List<BET_Follow_Request__c>();
        if(betIdCtrl != null && projectIdCtrl != null){
            betFollowRequest = BET_LinkingService.getFollowRequestsForBetAndIpm(betIdCtrl,projectIdCtrl);
        }
        Id betFollowRequestId = betFollowRequest.isEmpty() ? null : betFollowRequest.get(0).id;
        Id betOwnerId = BET_CommonService.getOwnerIdOfGivenBet(betIdCtrl);

		insertMemberRequestsRecords(betFollowRequestId,betOwnerId);

        System.debug('Exiting method addMembers method processes with success');
        if(callbackCtrl != null){
            return goToCallback(callbackCtrl);
        }        
        
        return null;
	}

    public PageReference goToCallback(String callback){
        PageReference pr = new PageReference(callback);
        pr.setRedirect(true);
        return pr;
    }
	
	public void insertMemberRequestsRecords(Id betFollowRequestId,Id betOwnerId){
		List<BET_Member_Request__c> betMembersToInsert = new List<BET_Member_Request__c>();
        Boolean isBetOwnerOrManager = BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(betIdCtrl, UserInfo.getUserId());
		if(suggested_MembersCtrl != null && !suggested_MembersCtrl.isEmpty()){
            for(ID userId : suggested_MembersCtrl){
                betMembersToInsert.add(BET_SuggestedMemberService.addInternalMemberRecord(userId,betFollowRequestId,isBetOwnerOrManager,betOwnerId,betIdCtrl,projectIdCtrl));
            }
            betMembersToInsert = BET_SuggestedMemberService.removeMemberRequestDuplicatesWhileInsert(betMembersToInsert);
        }

        if(!externalMembers.isEmpty()){
            for(ExternalAgencyMemberWrapper eam : externalMembers){
                betMembersToInsert.add(BET_SuggestedMemberService.addExternalMemberRecord(eam,betFollowRequestId,isBetOwnerOrManager,betOwnerId,betIdCtrl));
            }
        }

        if(!betMembersToInsert.isEmpty()){
            BET_SuggestedMemberService.insertMemberRequests(betMembersToInsert);
            IPM_BETUpdateService.updateBETMemberRequest(new Set<Id> {projectIdCtrl});
        }
	}
    
    /************************************************************
        Purpose: Method redirecting to next page defined in component callback attribute
        Parameters: -
        Returns: List<Id>
        Throws: -
    *************************************************************/
    public PageReference skipPage(){
        System.debug('Entering method skipPage user will be redirected to following page:'+callbackCtrl);
        if(callbackCtrl != null){
            PageReference pr = new PageReference(callbackCtrl);
            pr.setRedirect(true);
            return pr;
        }        
        
        return null;
    }
    
    /************************************************************
        Purpose: Property retriving Bet Owner Photo and populate information for
		betOwnerInfo
        Parameters: -
        Returns: List<Id>
        Throws: -
    *************************************************************/
    public String getOnwerPhoto(){
        System.debug('Entering method getOnwerPhoto get BetOwner for following BET: '+betIdCtrl);
        List<uw_BET__c> betRecord = [SELECT OwnerId from uw_BET__c where id =: betIdCtrl LIMIT 1];
        if(betRecord.isEmpty()){
            //set new instance for user to not trigger an error
            betOwnerInfo = new User();
            System.debug('Exiting method getOnwerPhoto no bet record found with such returned empty string');
            return '';
        }else{
            betOwnerInfo = [SELECT FullPhotoUrl,id,Name from user where id =: betRecord.get(0).OwnerId Limit 1];
            System.debug('Exiting method getOnwerPhoto with following photoUrl: '+betOwnerInfo.FullPhotoUrl);
            return betOwnerInfo.FullPhotoUrl;
        }
        
    }
    
     /************************************************************
        Purpose: Property retriving Bet Manager and populate information for
		managerInfo
        Parameters: -
        Returns: List<Id>
        Throws: -
    *************************************************************/
    public String getManagerPhoto(){
        System.debug('Entering method getManagerPhoto get BetOwner for following BET: '+betIdCtrl);
        List<uw_BET_Team_Member__c> managerMember = [SELECT Id,Team_Member__c FROM uw_BET_Team_Member__c WHERE  Role__c =: Label.BETManagerRole and BET__c =: betIdCtrl and IsOwner__c = false];
        if(!managerMember.isEmpty()){
            managerInfo = [SELECT FullPhotoUrl,id,Name from user where id =: managerMember.get(0).Team_Member__c Limit 1];
            System.debug('Exiting method getManagerPhoto retunred followin photo url: '+managerInfo.FullPhotoUrl);
            return managerInfo.FullPhotoUrl;
        }
        System.debug('Exiting method getManagerPhoto retunred followin photo url: ');
        return '';
    }

    /************************************************************
        Purpose: Method adds new external member record
        Parameters: -
        Returns:-
        Throws: -
    *************************************************************/
    public void addExternalMember(){
        if(!String.isBlank(externalMemberEmail) || !String.isBlank(externalMemberEmailBet)){
            ExternalAgencyMemberWrapper member = new ExternalAgencyMemberWrapper();
            member.email = String.isBlank(externalMemberEmail) ? externalMemberEmailBet : externalMemberEmail;
            Boolean canBeAdded = true;
            for(ExternalAgencyMemberWrapper wrap : externalMembers){
                if(wrap.email == externalMemberEmail){
                    canBeAdded = false;
                }
            }
            if(canBeAdded) {
                Id externalUserSalesforceId = null;
                List<User> userList = BET_AccessService.isExistingExternalUser(member.email);
                if(!userList.isEmpty()) {
                    if(userList[0].isActive){
                        externalUserSalesforceId = userList[0].Id;
                    }else{
                        canBeAdded = false;
                        Apexpages.Message m = new apexpages.Message(ApexPages.Severity.ERROR, member.email + ' is an existing user (External Agent) but inactive at the moment. Please send an email to marketing@unilever.com for further clarification.');
                        Apexpages.addMessage(m); 
                    }
                }
                if(canBeAdded) {
                    member.userId = externalUserSalesforceId;
                    externalMembers.add(member);
                    externalMemberEmail = '';
                    externalMemberEmailBet = '';
                }
            }
        }
    }

}