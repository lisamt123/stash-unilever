/*
  Class Name: NewsArticleFeedController_NewsApp
  Author : Mindtree
  Date: 16 Oct 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: controller used for displaying News chatter feed
*/

public with sharing class NewsArticleFeedController_NewsApp{
    public Id articleId {get; set;}
    public NewsArticleFeedController_NewsApp(){
        string paramArticleId = ApexPages.currentPage().getParameters().get('articleId');
        articleId = Id.valueOf(paramArticleId);
    }
}