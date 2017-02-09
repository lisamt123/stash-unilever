public class Core_LA_BaseController {
    
    @AuraEnabled
    public static boolean insertFeedback(String ParticipantId, String rating, String comment) {
        boolean flag = false;
        CORE_LA_Participant__c participant = [SELECT Id, Feedback__c, Rating__c FROM CORE_LA_Participant__c WHERE Id = :ParticipantId];
        participant.Feedback__c = comment;
        participant.Rating__c = decimal.valueOf(rating);
        if(participant != null)
        {
            Database.SaveResult SR = Database.update(participant);
            if(sr.isSuccess())
            {
                flag = true;
            }
        }
        
        return flag;
    } 
    
    @AuraEnabled
    public static boolean register(String ParticipantId, String question1, String question2, String comment1, String comment2) {
        boolean flag = false;
        CORE_LA_Participant__c participant = [SELECT Id, Status__c, Dietary_Plan__c, Accessibility_needs__c, Dietary_Ans__c, Accessibility_Ans__c FROM CORE_LA_Participant__c WHERE Id = :ParticipantId];
        participant.Status__c = 'Registered';
        participant.Dietary_Plan__c = comment1;
        participant.Dietary_Ans__c = question1;
        participant.Accessibility_needs__c = comment2;
        participant.Accessibility_Ans__c = question2;
        if(participant != null)
        {
            Database.SaveResult SR = Database.update(participant);
            if(sr.isSuccess())
            {
                flag = true;
            }
        }
        
        return flag;
    } 
       
    @AuraEnabled
    public static boolean Unregister(String ParticipantId) {
        boolean flag = false;
        CORE_LA_Participant__c participant = [SELECT Id, Status__c, Dietary_Plan__c, Accessibility_needs__c, Dietary_Ans__c, Accessibility_Ans__c  FROM CORE_LA_Participant__c WHERE Id = :ParticipantId];
        participant.Status__c = 'Invited';
        participant.Dietary_Plan__c = '';
        participant.Dietary_Ans__c = '';
        participant.Accessibility_needs__c = '';
        participant.Accessibility_Ans__c = '';
        if(participant != null)
        {
            Database.SaveResult SR = Database.update(participant);
            if(sr.isSuccess())
            {
                flag = true;
            }
        }
        
        return flag;
    } 
    
    @AuraEnabled
    public static boolean saveEvent(String ParticipantId) {
        boolean flag = false;
        CORE_LA_Participant__c participant = [SELECT Id, Status__c FROM CORE_LA_Participant__c WHERE Id = :ParticipantId];
        participant.Status__c = 'Saved';
        System.debug('@@@###@@@' + participant);
        if(participant != null)
        {
            Database.SaveResult SR = Database.update(participant);
            if(sr.isSuccess())
            {
                flag = true;
            }
        }
        
        return flag;
    } 
    
    @AuraEnabled
    public static boolean unSaveEvent(String ParticipantId) {
        boolean flag = false;
        CORE_LA_Participant__c participant = [SELECT Id, Status__c FROM CORE_LA_Participant__c WHERE Id = :ParticipantId];
        participant.Status__c = 'Invited';
        if(participant != null)
        {
            Database.SaveResult SR = Database.update(participant);
            if(sr.isSuccess())
            {
                flag = true;
            }
        }
        
        return flag;
    } 
    
}