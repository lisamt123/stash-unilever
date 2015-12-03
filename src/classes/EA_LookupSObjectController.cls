/**
Apex Controller for looking up an SObject via SOSL
*/
public with sharing class EA_LookupSObjectController {
    /**
* Aura enabled method to search a specified SObject for a specific string
*/
    public EA_LookupSObjectController(){}
    @AuraEnabled
    public static Result[] lookup(String searchString, String sObjectAPIName){
        // Sanitze the input
        String sanitizedSearchString = String.escapeSingleQuotes(searchString);
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName); 
        List<Result> results = new List<Result>(); 
        // Build our SOSL query
        String searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name) Limit 50';      
        // Execute the Query
        List<List<SObject>> searchList = search.query(searchQuery); 
        // Create a list of matches to return
        for (SObject so : searchList[0]){
            if(userinfo.getUserId() != so.Id){
                results.add(new Result((String)so.get('Name'), so.Id));
            }
        }
        return results;
    }    
    /* This method returns all team member records for an Activity*/      
    @AuraEnabled
    public static List<EA_Team_Member__c> getRecentlyWorkedWithUsers(){
        List<EA_Team_Member__c> membersList = [SELECT Participant__c, Participant__r.Name FROM EA_Team_Member__c WHERE  (Invited_By__c=:userinfo.getuserId() and Participant__c !=: userinfo.getuserId()) limit 5];
        //List<EA_Team_Member__c> membersList = [SELECT Participant__c, Participant__r.Name FROM EA_Team_Member__c WHERE  (Invited_By__c=:userinfo.getuserId()) limit 5];
        return membersList;
    }     
    /* This method returns all team member records for an Activity*/      
    @AuraEnabled
    public static Result[] lookupcustom(String searchString, String sObjectAPIName){
        // Sanitze the input
        String sanitizedSearchString = String.escapeSingleQuotes(searchString);
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);       
        List<Result> results = new List<Result>();      
        List<EA_Team_Member__c> membersList = [SELECT Name, Participant__r.Id,Participant__r.Name FROM EA_Team_Member__c WHERE  Invited_By__c=:userinfo.getuserId() and Participant__r.Name like: '%'+sanitizedSearchString+'%'];             
        // Create a list of matches to return
        for (EA_Team_Member__c so : membersList){
            results.add(new Result(so.Participant__r.Name,so.Participant__r.Id));
        }
        
        return results;
    } 
    /**
* Inner class to wrap up an SObject Label and its Id
*/
    public class Result {
        @AuraEnabled public String SObjectLabel {get; set;}
        @AuraEnabled public Id SObjectId {get; set;}         
        public Result(String sObjectLabel, Id sObjectId){
            this.SObjectLabel = sObjectLabel;
            this.SObjectId = sObjectId;
        }
    }
    
}