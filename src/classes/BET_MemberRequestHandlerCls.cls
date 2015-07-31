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
    
    private BET_MemberRequestHandlerCls(){}
    /************************************************************
        Purpose: Method responsible for preventing adding duplacted records for object BET_Member_Request__c
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    
    public static void preventMemberRequestDuplicatesWhileInsert(List<BET_Member_Request__c> memberRequestToInsert){
    	System.debug('Entring preventMemberRequestDuplicatesWhileInsert  with param @memberRequestToInsert:'+memberRequestToInsert);
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
            //check also if there not exist already approved record
            
            uniqRecords.add(uniqItem);
            recordsToInsertMap.put(uniqItem,request);
            
        }
       
        //retrive records from database
        for(BET_Member_Request__c existingRequest : [SELECT ConcatenatedField__c,UserId__r.Name FROM BET_Member_Request__c WHERE ConcatenatedField__c in : uniqRecords]){
            
            if(recordsToInsertMap.containsKey(existingRequest.ConcatenatedField__c)){
                //add error for already existing record in db
                System.debug('Exiting BET_MemberRequestHandlerCls.preventMemberRequestDuplicatesWhileInsert method found duplicated record :'+recordsToInsertMap.get(existingRequest.ConcatenatedField__c));
                recordsToInsertMap.get(existingRequest.ConcatenatedField__c).addError(String.format(Label.BET_SuggestedMemberDuplicateError,new List<String>{existingRequest.UserId__r.Name}));
            }
        }
        System.debug('Exiting BET_MemberRequestHandlerCls.preventMemberRequestDuplicatesWhileInsert method did not found any duplicated records');
        
        
        
    }
    
    /************************************************************
        Purpose: Method responsible for creating Team Members record for Approved Team Member Request record
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public static void createTeamMemberForApprovedRequest(List<BET_Member_Request__c> memberRequestLst,Map<Id,BET_Member_Request__c> oldMap){
        System.debug('Entring createTeamMemberForApprovedRequest  with param @memberRequestLst:'+memberRequestLst+
                    ' @memberRequestLst: '+oldMap);
        List<uw_BET_Team_Member__c> teamMembersToInsert = new List<uw_BET_Team_Member__c>();
        for(BET_Member_Request__c memberRequest : memberRequestLst){
            //if old map null then it's a newly created record check if status if apporved
            if(oldMap == null && memberRequest.Status__c == Label.BETTeamMemberRequestApprovedStatus){
                //create new Tem Member 
                teamMembersToInsert.add(createTeamMemberFromRequest(memberRequest));
            }else if(oldMap != null){
                //record already exist in db it's update operation
                String OldMapStatus = oldMap.containsKey(memberRequest.id)  ? oldMap.get(memberRequest.id).Status__c : null;
                if(memberRequest.Status__c == Label.BETTeamMemberRequestApprovedStatus &&  memberRequest.Status__c != OldMapStatus){
                    teamMembersToInsert.add(createTeamMemberFromRequest(memberRequest));
                }
            }
        }
        System.debug('Exiting createTeamMemberForApprovedRequest  following Team Members will be created: '+teamMembersToInsert);
        insert teamMembersToInsert;
        //return memberRequestToInsert;
        
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
        System.debug('Exiting method createTeamMemberFromRequest following Memeber Request returned:'+memberRequestToInsert);
        return memberRequestToInsert;
    }
    
    
    
   

}