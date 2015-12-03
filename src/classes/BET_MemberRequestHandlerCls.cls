/*****************************************************************************************************************************
Name: BET_Member_RequestHandler
Copyright © 2015 Unilever. 

Purpose: BET_MemberRequestHandlerCls. contains logic used in BET_Member_RequestHandler class

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   k.szepietowski@polsource.com            23/07/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
public with sharing class BET_MemberRequestHandlerCls {
    

    private static final String MANAGERROLE = 'Manager';
    private static final String MEMBERROLE = 'Member';

    private BET_MemberRequestHandlerCls(){}
    /************************************************************
        Purpose: Method responsible for preventing adding duplacted records for object BET_Member_Request__c
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    
    public static void preventMemberRequestDuplicatesWhileInsert(List<BET_Member_Request__c> memberRequestToInsert){
    	/*System.debug('Entring preventMemberRequestDuplicatesWhileInsert  with param @memberRequestToInsert:'+memberRequestToInsert);
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
                uniqItem += request.Status__c;
            }
            
            uniqRecords.add(uniqItem);
            recordsToInsertMap.put(uniqItem,request);
            
        }
       
        for(BET_Member_Request__c existingRequest : [SELECT ConcatenatedField__c,UserId__r.Name FROM 
        											BET_Member_Request__c WHERE ConcatenatedField__c in : uniqRecords]){
            
            if(recordsToInsertMap.containsKey(existingRequest.ConcatenatedField__c)){
                recordsToInsertMap.get(existingRequest.ConcatenatedField__c).
                addError(String.format(Label.BET_SuggestedMemberDuplicateError,new List<String>{existingRequest.UserId__r.Name}));
            }
        }
        System.debug('Exiting BET_MemberRequestHandlerCls.preventMemberRequestDuplicatesWhileInsert method did not found any duplicated records');
        */
        
    }

    /*public static void informIPMOfProjectMemberRequest(List<BET_Member_Request__c> memberRequestLst){
        System.debug('Entering informIPMOfProjectMemberRequest : ' + memberRequestLst);
        Set<Id> projects = new Set<Id>();
        for(BET_Member_Request__c mreq : memberRequestLst) {
            if(!String.isBlank(mreq.Project_Id__c)){
                projects.add(Id.valueOf(mreq.Project_Id__c));
            }
        }
        IPM_BETUpdateService.updateBETMemberRequest(projects);
        System.debug('Exit informIPMOfProjectMemberRequest');
    }*/
    
    /************************************************************
        Purpose: Method responsible for creating Team Members record for Approved Team Member Request record
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public static void createTeamMemberForApprovedRequest(List<BET_Member_Request__c> memberRequestLst,Map<Id,BET_Member_Request__c> oldMap){
        System.debug('Entring createTeamMemberForApprovedRequest  with param @memberRequestLst:'+memberRequestLst+
                    ' @memberRequestLst: '+oldMap);

        Map<Id,Set<Id>> betTeamMembersMap = new Map<Id,Set<Id>>();
        Map<String,uw_BET_Team_Member__c> teamMemberExistingMap = new Map<String,uw_BET_Team_Member__c>();

        Map<Id,Set<String>> betexternalTeamMembersMap = new Map<Id,Set<String>>();
        Map<String,uw_BET_Team_Member__c> teamexternalMemberExistingMap = new Map<String,uw_BET_Team_Member__c>();


        Set<Id> bets = new Set<Id>();
        for(BET_Member_Request__c mRequest : memberRequestLst){
            bets.add(mRequest.Brand_Experience_Toolkit__c);
        }

        for(uw_BET_Team_Member__c tMember : [select id , Team_Member__c, BET__c, Role__c,email__c from uw_BET_Team_Member__c where BET__c in: bets and Team_Member__c != null]){
            if(betTeamMembersMap.keySet().contains(tMember.BET__c)){
                betTeamMembersMap.get(tMember.BET__c).add(tMember.Team_Member__c);
            } else {
                betTeamMembersMap.put(tMember.BET__c,new Set<Id> {tMember.Team_Member__c});
            }
            teamMemberExistingMap.put(''+tMember.BET__c+tMember.Team_Member__c,tMember);
        }

       for(uw_BET_Team_Member__c tMember : [select id , Team_Member__c, BET__c, Role__c,email__c from uw_BET_Team_Member__c where BET__c in: bets and Team_Member__c = null and email__c != null]){
            if(betexternalTeamMembersMap.keySet().contains(tMember.BET__c)){
                betexternalTeamMembersMap.get(tMember.BET__c).add(tMember.email__c);
            } else {
                betexternalTeamMembersMap.put(tMember.BET__c,new Set<String> {tMember.email__c});
            }
            teamexternalMemberExistingMap.put(''+tMember.BET__c+tMember.email__c,tMember);
        }

        List<uw_BET_Team_Member__c> teamMembersToUpsert = new List<uw_BET_Team_Member__c>();
        for(BET_Member_Request__c memberRequest : memberRequestLst){
            if(memberRequest.External_User_Request__c){
                externalMembersForUpsert(memberRequest,teamMembersToUpsert,betexternalTeamMembersMap,oldMap);
            } else if (!memberRequest.External_User_Request__c) {
                internalMembersForUpsert(memberRequest,teamMembersToUpsert,betTeamMembersMap,teamMemberExistingMap,oldMap);
            }
        }
        System.debug('Exiting createTeamMemberForApprovedRequest  following Team Members will be created: '+teamMembersToUpsert);
        upsert teamMembersToUpsert;
    }

    private static void externalMembersForUpsert(BET_Member_Request__c memberRequest,List<uw_BET_Team_Member__c> teamMembersToUpsert,Map<Id,Set<String>> betexternalTeamMembersMap,Map<Id,BET_Member_Request__c> oldMap){
        if(oldMap == null && memberRequest.Status__c == Label.BETTeamMemberRequestApprovedStatus){
            if(betexternalTeamMembersMap.get(memberRequest.Brand_Experience_Toolkit__c) == null || (betexternalTeamMembersMap.get(memberRequest.Brand_Experience_Toolkit__c) != null && !betexternalTeamMembersMap.get(memberRequest.Brand_Experience_Toolkit__c).contains(memberRequest.External_User_Email__c))){
                teamMembersToUpsert.add(createTeamMemberFromRequest(memberRequest));
            } 
        }else if(oldMap != null){
            String OldMapStatus = oldMap.containsKey(memberRequest.id)  ? oldMap.get(memberRequest.id).Status__c : null;
            if(memberRequest.Status__c == Label.BETTeamMemberRequestApprovedStatus 
                && memberRequest.Status__c != OldMapStatus
                && betexternalTeamMembersMap.get(memberRequest.Brand_Experience_Toolkit__c) == null || (betexternalTeamMembersMap.get(memberRequest.Brand_Experience_Toolkit__c) != null && !betexternalTeamMembersMap.get(memberRequest.Brand_Experience_Toolkit__c).contains(memberRequest.External_User_Email__c))){
                teamMembersToUpsert.add(createTeamMemberFromRequest(memberRequest));
            }
        }
    }

    private static void internalMembersForUpsert(BET_Member_Request__c memberRequest,List<uw_BET_Team_Member__c> teamMembersToUpsert,Map<Id,Set<Id>> betTeamMembersMap,Map<String,uw_BET_Team_Member__c> teamMemberExistingMap,Map<Id,BET_Member_Request__c> oldMap){
        if(oldMap == null && memberRequest.Status__c == Label.BETTeamMemberRequestApprovedStatus){
            if(betTeamMembersMap.get(memberRequest.Brand_Experience_Toolkit__c) == null ||(betTeamMembersMap.get(memberRequest.Brand_Experience_Toolkit__c) != null && !betTeamMembersMap.get(memberRequest.Brand_Experience_Toolkit__c).contains(memberRequest.UserId__c))){
                teamMembersToUpsert.add(createTeamMemberFromRequest(memberRequest));
            } else {
                uw_BET_Team_Member__c member = teamMemberExistingMap.get(''+memberRequest.Brand_Experience_Toolkit__c+memberRequest.UserId__c);
                if(member!=null && member.Role__c == MEMBERROLE && memberRequest.Role__c == MANAGERROLE){
                    member.Role__c = MANAGERROLE;
                    teamMembersToUpsert.add(member);
                }
            }
        }else if(oldMap != null){
            String OldMapStatus = oldMap.containsKey(memberRequest.id)  ? oldMap.get(memberRequest.id).Status__c : null;
            if(memberRequest.Status__c == Label.BETTeamMemberRequestApprovedStatus &&  memberRequest.Status__c != OldMapStatus){
                if(betTeamMembersMap.get(memberRequest.Brand_Experience_Toolkit__c) == null || (betTeamMembersMap.get(memberRequest.Brand_Experience_Toolkit__c) != null && !betTeamMembersMap.get(memberRequest.Brand_Experience_Toolkit__c).contains(memberRequest.UserId__c))){
                    teamMembersToUpsert.add(createTeamMemberFromRequest(memberRequest));
                } else {
                    uw_BET_Team_Member__c member = teamMemberExistingMap.get(''+memberRequest.Brand_Experience_Toolkit__c+memberRequest.UserId__c);
                    if(member!=null && member.Role__c == MEMBERROLE && memberRequest.Role__c == MANAGERROLE){
                        member.Role__c = MANAGERROLE;
                        teamMembersToUpsert.add(member);
                    }
                }
            }
        }
    }
    
    /************************************************************
        Purpose: Method responsible for creating Team Members record from Team Member Request record
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public static uw_BET_Team_Member__c createTeamMemberFromRequest(BET_Member_Request__c memberRequest){
        System.debug('Entring method createTeamMemberFromRequest with param @memberRequest: '+memberRequest);
        uw_BET_Team_Member__c memberRequestToInsert = new uw_BET_Team_Member__c();
        memberRequestToInsert.Access_Level__c = 'Toolkit Experience (Toolkit only)';
        memberRequestToInsert.BETEnabled__c = true;
        memberRequestToInsert.BET__c = memberRequest.Brand_Experience_Toolkit__c;
        memberRequestToInsert.Editing__c = false;
        memberRequestToInsert.Invite_Pending__c = false;
        memberRequestToInsert.Role__c = memberRequest.Role__c;
        memberRequestToInsert.StudioEnabled__c = true;
        memberRequestToInsert.Team_Member__c = memberRequest.UserId__c;
        
        if(memberRequest.External_User_Request__c) {
            memberRequestToInsert.Role__c = 'External Agency User';
            memberRequestToInsert.Access_Level__c = 'External View (Chatter group only)';
        }

        memberRequestToInsert.email__c = memberRequest.External_User_Request__c ? memberRequest.External_User_Email__c : null;
        System.debug('Exiting method createTeamMemberFromRequest following Memeber Request returned:'+memberRequestToInsert);
        return memberRequestToInsert;
    }
    
    
    
   

}