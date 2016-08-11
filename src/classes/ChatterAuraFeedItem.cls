public class ChatterAuraFeedItem {
	/* At the time of writing this code The attributes of connectApi classes are not Aura enabled and could not be used with lightning components */
    /* This class is wrapper class that contains feedItem attributes with the auraenabled tag */
    
    @AuraEnabled
    public Id elementId {get; set;}
    
    @AuraEnabled
    public List<ChatterAuraMessageSegment> messageSegments {get; set;} 
    
    @AuraEnabled
    public String bodyText {get; set;}
    
    @AuraEnabled
    public Boolean isRichText {get; set;}
    
    @AuraEnabled
    public List<ChatterRichTextSegment> richBodyText {get; set;}
    
    @AuraEnabled
    public String actorDisplayName {get; set;}
    
    @AuraEnabled
    public String actorSmallPhotoUrl {get; set;}
    
    @AuraEnabled
    public String createdDate {get; set;}
    
    @AuraEnabled
    public List<String> topics {get; set;}
    
    @AuraEnabled
    public boolean isEmptyTopics {get; set;}
    
    @AuraEnabled
    public boolean isLink {get; set;}
    
    @AuraEnabled
    public String linkUrl {get; set;}
    
    @AuraEnabled
    public String linkUrlName {get; set;}
    
    @AuraEnabled
    public boolean isFile {get; set;}
    
    @AuraEnabled
    public List<ChatterAuraContent> files  {get; set;} 
    
    @AuraEnabled
    public integer numberOfLikes  {get; set;} 
    
    @AuraEnabled
    public List<ChatterAuraLiker> likers  {get; set;} 
    
    @AuraEnabled
    public boolean hasComments {get; set;}
    
    @AuraEnabled
    public boolean isLikedByCurrentUser {get; set;}
    
    @AuraEnabled
    public List<ChatterAuraFeedComment> comments {get; set;} 
    
    
    public class ChatterRichTextSegment {
        
        @AuraEnabled
    	public String segmentType {get; set;}
        
        @AuraEnabled
    	public String segmentBody {get; set;}
        
        @AuraEnabled
    	public String refId {get; set;}
        
        @AuraEnabled
    	public String refName {get; set;}
    }    
     

}