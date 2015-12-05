/*
  Class Name: Core_NC_NewsWrapperClass
  Author : Mindtree
  Date: 1 Oct 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Wrapper class for NewsApp Landing Page
*/

public class Core_NC_NewsWrapperClass{
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
    public String Topics {get;set;}
    
    @AuraEnabled
    public String SubTitle {get;set;}
    
    @AuraEnabled
    public String SiteName {get;set;}
    
    @AuraEnabled
    public Integer LoadMoreLimit {get;set;}
    
    @AuraEnabled
    public String MyNewsSiteNameColorCode {get;set;}
 
}