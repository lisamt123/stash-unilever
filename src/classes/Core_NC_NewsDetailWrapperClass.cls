/*
  Class Name: Core_NC_NewsDetailWrapperClass
  Author : Mindtree
  Date: 7 Oct 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Wrapper class for News Detail Page
*/

public class Core_NC_NewsDetailWrapperClass{
    @AuraEnabled
    public List<Core_NC_NewsWrapperClass> RelatedNewsDetail {get;set;}
     
    @AuraEnabled
    public String Name {get;set;}
    
    @AuraEnabled
    public String NewsId {get;set;}
     
    @AuraEnabled
    public String PublishedDate {get;set;}
    
    @AuraEnabled
    public String BannerURL {get;set;}
    
    @AuraEnabled
    public Integer LikeCount {get;set;}
    
    @AuraEnabled
    public Integer CommentCount {get;set;}
    
    @AuraEnabled
    public String NewsBody {get;set;}
    
    @AuraEnabled
    public Boolean Liked {get;set;}
    
    @AuraEnabled
    public String Topics {get;set;}
    
    @AuraEnabled
    public String SubTitle {get;set;}
    
    @AuraEnabled
    public String SiteName {get;set;}
        
    @AuraEnabled
    public Integer CarouselLimit {get;set;}
    
    @AuraEnabled
    public String SharepointURL {get;set;}
    
    @AuraEnabled
    public Boolean DefaultImage {get;set;}
    
    @AuraEnabled
    public String MyNewsSiteNameColorCode {get;set;}
    
}