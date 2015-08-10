/*************************************************************************************
Name : BET_SuggestedMemberService

Purpose : Service for SuggestMembers functionality

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  23-07-2015  Initial
*************************************************************************************/

public with sharing class BET_SuggestedMemberService {

    public static final String APPROVED = 'Approved';
    public static final String REJECTED = 'Rejected';
    
    private BET_SuggestedMemberService(){}
    
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
    
   

}