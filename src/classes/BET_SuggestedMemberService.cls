/*************************************************************************************
Name : BET_SuggestedMemberService

Purpose : Service for SuggestMembers functionality

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  23-07-2015  Initial
*************************************************************************************/
/* Without sharing due to this is a service class which is used indirectly by external system */
public without sharing class BET_SuggestedMemberService {

    public static final String APPROVED = 'Approved';
    public static final String REJECTED = 'Rejected';
    
    private BET_SuggestedMemberService(){}


    /************************************************************
        Purpose: Method responsible for createing new internal Bet Member Requests record
        Parameters: ID userId,Id betFollowRequestId,Boolean isBetOwnerOrManager,Id betOwnerId
        Returns: BET_Member_Request__c
        Throws: -
    *************************************************************/
    public static BET_Member_Request__c addInternalMemberRecord(ID userId,Id betFollowRequestId,Boolean isBetOwnerOrManager,Id betOwnerId,Id betIdCtrl,Id projectIdCtrl){
        BET_Member_Request__c betMemeberItem = new BET_Member_Request__c();
        betMemeberItem.Brand_Experience_Toolkit__c = betIdCtrl;
        betMemeberItem.ProjectRequest__c = betFollowRequestId;
        betMemeberItem.UserId__c = userId;
        betMemeberItem.Project_Id__c = projectIdCtrl;
        betMemeberItem.Bet_owner__c = betOwnerId;
        if(isBetOwnerOrManager){
            betMemeberItem.Status__c = Label.BETTeamMemberRequestApprovedStatus;
            betMemeberItem.Do_Not_Notify_Bet__c = true;
            betMemeberItem.Do_Not_Notify_User__c = true;
        }else{
            betMemeberItem.Status__c = Label.BETTeamMemberRequestNewStatus;
        }
        betMemeberItem.Role__c = Label.BetTeamMemberRoleMember;
        return betMemeberItem;
    }

    /************************************************************
        Purpose: Method responsible for createing new external Bet Member Requests record
        Parameters: ExternalAgencyMemberWrapper eam,Id betFollowRequestId,Boolean isBetOwnerOrManager,Id betOwnerId
        Returns: BET_Member_Request__c
        Throws: -
    *************************************************************/
    public static BET_Member_Request__c addExternalMemberRecord(BET_SuggestMembersController.ExternalAgencyMemberWrapper eam,Id betFollowRequestId,Boolean isBetOwnerOrManager,Id betOwnerId,Id betIdCtrl){
        BET_Member_Request__c betMemeberItem = new BET_Member_Request__c();
        betMemeberItem.Brand_Experience_Toolkit__c = betIdCtrl;
        betMemeberItem.ProjectRequest__c = betFollowRequestId;
        betMemeberItem.External_User_Request__c = true;
        betMemeberItem.External_User_Email__c = eam.email;
        betMemeberItem.Bet_owner__c = betOwnerId;
        betMemeberItem.UserId__c = eam.userId;
        if(isBetOwnerOrManager){
            betMemeberItem.Status__c = Label.BETTeamMemberRequestApprovedStatus;
            betMemeberItem.Do_Not_Notify_Bet__c = true;
            betMemeberItem.Do_Not_Notify_User__c = true;
        }else{
            betMemeberItem.Status__c = Label.BETTeamMemberRequestNewStatus;
        }
        betMemeberItem.Role__c = Label.BetTeamMemberRoleMember;
        return betMemeberItem;
    }

    /************************************************************
        Purpose: Method responsible for converting List<ID> collection to Map
        Parameters: List<Id> suggested_managersCtrl
        Returns: Map<Id,Id>
        Throws: -
    *************************************************************/
    public static Map<Id,Id> convertSuggestedManagersToMap(List<Id> sugmanagersCtrl){
        System.debug('Entering method convertSuggestedManagersToMap for list suggested_managersCtrl'+sugmanagersCtrl);
        Map<Id,Id> suggestedManagersMap = new Map<Id,Id>();
        if(sugmanagersCtrl != null && !sugmanagersCtrl.isEmpty()){
            for(Id managerId : sugmanagersCtrl){
                suggestedManagersMap.put(managerId,managerId);
            }
        }
        System.debug('Exiting method convertSuggestedManagersToMap list was conveted to following map:'+sugmanagersCtrl);
        return suggestedManagersMap;
    }


    /************************************************************
        Purpose: Method responsible removing Id element from list
        Parameters: -
        Returns: List<Id>
        Throws: -
    *************************************************************/
    public static List<Id> removeElementFromList(List<id> currentLst, Id elementToRemove){
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
    public static Map<String,Map<Id,Id>> convertUserBucketToMap(List<BET_MemberBucketWrapper> bucket){
        System.debug('Entering method convertUserBucketToMap with following param @bucket:'+bucket);
        Map<String,Map<Id,Id>> userBucketMap = new Map<String,Map<Id,Id>>();
        for(BET_MemberBucketWrapper member : bucket){
            if(member.GroupUserIds == null || member.GroupUserIds.isEmpty()){
                userBucketMap.put(member.GroupName,new Map<Id,Id>());
            } else {
                for(Id memberItem : member.GroupUserIds){
                    if(userBucketMap.containsKey(member.GroupName)){
                        userBucketMap.get(member.GroupName).put(memberItem,memberItem);
                    }else{
                        userBucketMap.put(member.GroupName, new Map<Id,Id>{memberItem => memberItem});
                    }
                }
            }
        }
        System.debug('Exiting method convertUserBucketToMap following map was returned: '+userBucketMap);
        return userBucketMap;
    }

    /************************************************************
        Purpose: Method responsible for is Bet Owner or Manager for list of users
        Parameters: Id betId, List<Id> users)
        Returns: Map<Id,Boolean>
        Throws: -
    *************************************************************/
    public static Map<Id,Boolean> checkIfUsersAreManagerOrOwnerOfBet(Id betId, List<Id> users){
        Map<Id,Boolean> usersMap = new Map<Id,Boolean>();
        List<uw_BET__c> betInfo = [SELECT OwnerId FROM uw_BET__c where id =: betId];
        for(Id userid : users){
            if(userid == betInfo.get(0).ownerId){
                usersMap.put(userId,true);
            } else {
                usersMap.put(userId,false);
            }
        }
        for(uw_BET_Team_Member__c manager : [SELECT Team_Member__c FROM uw_BET_Team_Member__c WHERE Team_Member__c in: users and Role__c =: Label.BETManagerRole and BET__c =: betId]){
            if(usersMap.get(manager.Team_Member__c) == null || !usersMap.get(manager.Team_Member__c)){
                usersMap.put(manager.Team_Member__c,true);
            }
        }
        return usersMap;
    }

    
    /************************************************************
        Purpose: Method responsible for is Bet Owner or Manager
        Parameters: -
        Returns: Boolean
        Throws: -
    *************************************************************/
    public static Boolean checkIfUserIsManagerOrOwnerOfBet(Id betId, Id currentUser){
        if(betId ==  null){
            return false;
        }else{
            List<uw_BET__c> betInfo = [SELECT OwnerId,id FROM uw_BET__c where id =: betId];
            if(betInfo.isEmpty()){
                return false;
            }else{
                //check if current user is onwer
                if(betInfo.get(0).OwnerId == currentUser){
                    return true;
                }
                //check if current user is manger
                List<uw_BET_Team_Member__c> managerMember = [SELECT Id FROM uw_BET_Team_Member__c WHERE Team_Member__c =: currentUser and Role__c =: Label.BETManagerRole and BET__c =: betId];
                if(!managerMember.isEmpty()){
                    return true;
                }
            }
        }
        return false;
    }
    
    /************************************************************
        Purpose: Method responsible removing duplicated records before memer request insert
        Parameters: -
        Returns: List<BET_Member_Request__c>
        Throws: -
    *************************************************************/
    public static List<BET_Member_Request__c> removeMemberRequestDuplicatesWhileInsert(List<BET_Member_Request__c> memberRequestToInsert){
    	System.debug('Entering method removeMemberRequestDuplicatesWhileInsert with param @memberRequestToInsert: '+memberRequestToInsert);
    	Map<String,BET_Member_Request__c> recordsToInsertMap = new Map<String,BET_Member_Request__c>();
    	Set<String> uniqRecords = new Set<String>();
        for(BET_Member_Request__c request : memberRequestToInsert){
            String uniqItem = '';
            if(request.Brand_Experience_Toolkit__c != null){
                String convertedIdTo15 = request.Brand_Experience_Toolkit__c;
                uniqItem += convertedIdTo15.substring(0,15);
                
            }
            if(request.ProjectRequest__c != null){
                String convertedIdTo15 = request.ProjectRequest__c;
                uniqItem += convertedIdTo15.substring(0,15);
            }
            
            if(request.UserId__c != null){
                String convertedIdTo15 = request.UserId__c;
                uniqItem += convertedIdTo15.substring(0,15);
            }
            
            if(request.Project_Id__c != null && request.Project_Id__c != ''){
                try{
                    uniqItem += request.Project_Id__c.substring(0,15);
                }catch(Exception ex){
                    system.debug('Method removeMemberRequestDuplicatesWhileInsert throw an error : '+ex.getMessage());
                    Throw new BET_CustomBETException(Label.BetMemberRequestInvailidProjectIDError,ex);
                    
                }
            }
            
            if(request.Status__c != null){
                if(request.Status__c == Label.BETTeamMemberRequestNewStatus){
                    String recordForApproved = uniqItem+Label.BETTeamMemberRequestApprovedStatus;
                    uniqRecords.add(recordForApproved);
                    
                }
                uniqItem += request.Status__c;
            }
            //check also if there not exist already approved record
            
            uniqRecords.add(uniqItem);
            recordsToInsertMap.put(uniqItem,request);   
        }
        List<BET_Member_Request__c> records = retrieveRecordsFromDatabase(recordsToInsertMap,uniqRecords);
        System.debug('Exiting method removeMemberRequestDuplicatesWhileInsert with value: '+ records);
        return records;   
    }

    private static List<BET_Member_Request__c> retrieveRecordsFromDatabase(Map<String,BET_Member_Request__c> recordsToInsertMap, Set<String> uniqRecords){
        System.debug('Entereing method retrieveRecordsFromDatabase with value: ' + recordsToInsertMap + ', ' + uniqRecords);
        for(BET_Member_Request__c existingRequest : [SELECT ConcatenatedField__c FROM BET_Member_Request__c WHERE ConcatenatedField__c in : uniqRecords]){
            
            if(recordsToInsertMap.containsKey(existingRequest.ConcatenatedField__c)){
                recordsToInsertMap.remove(existingRequest.ConcatenatedField__c);
            }else{
               
                if(existingRequest.ConcatenatedField__c.endsWithIgnoreCase(Label.BETTeamMemberRequestApprovedStatus)){
                    String convertedToNew = existingRequest.ConcatenatedField__c.replace(Label.BETTeamMemberRequestApprovedStatus,Label.BETTeamMemberRequestNewStatus);
                    
                    //removed record from insert if similar request is already approved
                    if(recordsToInsertMap.containsKey(convertedToNew)){
           
                        recordsToInsertMap.remove(convertedToNew);
                    }
                }
            }
        }
        System.debug('Exiting method retrieveRecordsFromDatabase with value: '+recordsToInsertMap.values());
        return recordsToInsertMap.values();
    }

    public static void insertMemberRequests(List<BET_Member_Request__c> membersToInsert){
        insert membersToInsert;
    }
}