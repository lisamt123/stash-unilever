public class ChatterAuraFeedComment {

    @AuraEnabled
    public string id {get; set;}
    
    @AuraEnabled
    public string text {get; set;} 
    
    @AuraEnabled
    public string userDisplayName {get; set;} 
    
    @AuraEnabled
    public string userId {get; set;}
    
    @AuraEnabled
    public string userSmallPhotoUrl {get; set;}
    
    @AuraEnabled
    public string relativeCreatedDate {get; set;} 
    
    @AuraEnabled
    public string myLikeId {get; set;} 
    
    
}