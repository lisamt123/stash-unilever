/*************************************************************************************
Name : BET_SuggestMembersController

Purpose : Controller for BET_SuggestMembers component

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  20-07-2015  Initial
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
    
    public List<Id> suggested_MembersComponentCtrl{get;set;}
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
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public class SuggestedMembersWrapper{
        public String groupName{get;set;}
        public List<SuggestedMemberItemWrapper> groupUsers{get;set;}
        
    }
    
    /************************************************************
        Purpose: Wrapper class is a placeholder for displayed suggested members
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public class SuggestedMemberItemWrapper{
        public User userInfo{get;set;}
        public Boolean isManager{get;set;}
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
        /*
        system.debug('check current suggested members:'+suggested_MembersCtrl);
        if(suggested_MembersCtrl == null){
            suggested_MembersCtrl = new List<ID>();
        }
        */
        
        if(user_bucketsCtrl == null){
            user_bucketsCtrl = new List<BET_MemberBucketWrapper>();
        }
        
        Map<Id,User> suggestedUsers = new Map<Id,User>();
       
        suggestedUsers = new Map<Id,User>([SELECT Id,Name,FullPhotoUrl from USER where id in : suggested_MembersCtrl]);
        
        
        List<id> otherMemebers = suggested_MembersCtrl.clone();
        
        
        Map<String,Map<Id,Id>> convertedBacketToMap =  convertUserBucketToMap(user_bucketsCtrl);
        
        Map<Id,Id> managersMap = convertSuggestedManagersToMap();
        
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
                    otherMemebers = removeElementFromList(otherMemebers,suggestedId);  
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
        if(!otherMemebers.isEmpty()){
            for(Id otherMemberId : otherMemebers){
                if(suggestedUsers.containsKey(otherMemberId)){
                    SuggestedMemberItemWrapper memberItemWrap = new SuggestedMemberItemWrapper();
                    memberItemWrap.userInfo =   suggestedUsers.get(otherMemberId);
                   
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
        membersToDisplay.add(otherMemebersWrapper);

        System.debug('Exiting method getSuggestedMembers with following result:'+JSON.serialize(membersToDisplay));
        return membersToDisplay;
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
        
        
        if(newlyAddedUsers != null){
            for(String userToAdd : newlyAddedUsers.split(',')){
                if(userToAdd != null && userToAdd.trim() != ''){
                    suggested_MembersCtrl.add(Id.valueOf(userToAdd)); 
                }
            }
                
           	
        }
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
        System.debug('Entering method searchUsers');
        String query = 'SELECT Id,Name,SmallPhotoUrl from User where   name like \'%'+searchUserName+'%\' and isActive = true {0} Limit 50';
        
        if(suggested_MembersCtrl != null){
            query = query.replace('{0}','and id not in : suggested_MembersCtrl');
        }else{
            query = query.replace('{0}','');
        }
        
        freeAddMembers = Database.query(query);
        System.debug('Exiting method searchUsers controller property freeAddMembers was set to: '+JSON.serialize(freeAddMembers));
        
    }
    /************************************************************
        Purpose: Method responsible for converting List<ID> collection to Map
        Parameters: -
        Returns: Map<Id,Id>
        Throws: -
    *************************************************************/
    public Map<Id,Id> convertSuggestedManagersToMap(){
        System.debug('Entering method convertSuggestedManagersToMap for list suggested_managersCtrl'+suggested_managersCtrl);
        Map<Id,Id> suggestedManagersMap = new Map<Id,Id>();
        if(suggested_managersCtrl != null && !suggested_managersCtrl.isEmpty()){
            for(Id managerId : suggested_managersCtrl){
                suggestedManagersMap.put(managerId,managerId);
            }
        }
        System.debug('Exiting method convertSuggestedManagersToMap list was conveted to following map:'+suggestedManagersMap);
        return suggestedManagersMap;
    }
    
    /************************************************************
        Purpose: Method responsible removing Id element from list
        Parameters: -
        Returns: List<Id>
        Throws: -
    *************************************************************/
    public List<Id> removeElementFromList(List<id> currentLst, Id elementToRemove){
        System.debug('Entering method removeElementFromList with params @currentLst:'+currentLst+' @elementToRemove'+elementToRemove);
        Integer index=0;
        List<Id> initilaList = currentLst.clone();
        for(Id elem : currentLst){
            if(elem == elementToRemove){
                initilaList.remove(index);
                
                break;
            }
            index++;
        }
        System.debug('Exiting method removeElementFromList returned following list:'+initilaList);
        return initilaList;
    }
    
    /************************************************************
        Purpose: Method responsible for converting BET_MemberBucketWrapper object to Map where key is 
		grupName and value Map with all available user id's
        Parameters: -
        Returns: List<Id>
        Throws: -
    *************************************************************/
    public Map<String,Map<Id,Id>> convertUserBucketToMap(List<BET_MemberBucketWrapper> bucket){
        System.debug('Entering method convertUserBucketToMap with following param @bucket:'+bucket);
        Map<String,Map<Id,Id>> userBucketMap = new Map<String,Map<Id,Id>>();
        for(BET_MemberBucketWrapper member : bucket){
            if(member.GroupUserIds != null && !member.GroupUserIds.isEmpty()){
                
                for(Id memberItem : member.GroupUserIds){
                    if(userBucketMap.containsKey(member.GroupName)){
                        userBucketMap.get(member.GroupName).put(memberItem,memberItem);
                    }else{
                        userBucketMap.put(member.GroupName, new Map<Id,Id>{memberItem => memberItem});
                    }
                }
                
            }else{
                userBucketMap.put(member.GroupName,new Map<Id,Id>());
            }
        }
        System.debug('Exiting method convertUserBucketToMap following map was returned: '+userBucketMap);
        return userBucketMap;
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
        Purpose: Method responsible for createing new Bet Member Requests records in db
        Parameters: -
        Returns: List<Id>
        Throws: -
    *************************************************************/
    public PageReference addMembers(){
        System.debug('Entering method addMembers for following user: '+suggested_MembersCtrl);
        if(suggested_MembersCtrl != null && !suggested_MembersCtrl.isEmpty()){
             Map<Id,Id> managersMap = convertSuggestedManagersToMap();
            //check if betID and project Id was passed if yes then try to get Bet Follow Request record
            List<BET_Follow_Request__c> betFollowRequest = new List<BET_Follow_Request__c>();
            if(betIdCtrl != null && projectIdCtrl != null){
                betFollowRequest = [SELECT id from BET_Follow_Request__c WHERE Brand_Experience_Toolkit__c =: betIdCtrl and Project_Id__c =:projectIdCtrl]; 
            }
            Id betFollowRequestId = betFollowRequest.isEmpty() ? null : betFollowRequest.get(0).id;
            List<BET_Member_Request__c> betMembersToInsert = new List<BET_Member_Request__c>();
            Boolean isBetOwnerOrManager = BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(betIdCtrl, UserInfo.getUserId());
            system.debug('check if requestOnwer'+betIdCtrl+'is owner '+isBetOwnerOrManager);
            for(ID userId : suggested_MembersCtrl){
            	BET_Member_Request__c betMemeberItem = new BET_Member_Request__c();
                betMemeberItem.Brand_Experience_Toolkit__c = betIdCtrl;
                betMemeberItem.ProjectRequest__c = betFollowRequestId;
                betMemeberItem.UserId__c = userId;
                betMemeberItem.Project_Id__c = projectIdCtrl;
                if(isBetOwnerOrManager){
                    betMemeberItem.Status__c = Label.BETTeamMemberRequestApprovedStatus;
                }else{
                    betMemeberItem.Status__c = Label.BETTeamMemberRequestNewStatus;
                }
                //if(managersMap.containsKey(userId))
                betMemeberItem.Role__c = Label.BetTeamMemberRoleMember;
                betMembersToInsert.add(betMemeberItem);
            }
            betMembersToInsert = BET_SuggestedMemberService.removeMemberRequestDuplicatesWhileInsert(betMembersToInsert);
            insert betMembersToInsert;
            //delete members if memberToDelete is not empty and such records exists
           
             	
        }
        System.debug('Exiting method addMembers method processes with success');
        if(callbackCtrl != null){
            return new PageReference(callbackCtrl);
        }        
        
        return null;
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
            return new PageReference(callbackCtrl);
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
        if(!betRecord.isEmpty()){
            betOwnerInfo = [SELECT FullPhotoUrl,id,Name from user where id =: betRecord.get(0).OwnerId Limit 1];
            System.debug('Exiting method getOnwerPhoto with following photoUrl: '+betOwnerInfo.FullPhotoUrl);
        	return betOwnerInfo.FullPhotoUrl;
        }else{
            //set new instance for user to not trigger an error
            betOwnerInfo = new User();
            System.debug('Exiting method getOnwerPhoto no bet record found with such returned empty string');
            return '';
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

}