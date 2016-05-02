public with sharing class cp_NewsController {
  public List<cp_News__c> hotTopics{get;set;}
  public List<cp_News__c> ataGlances{get;set;}

  public Integer numHotTopics{get;set;}
  public Integer numAtaGlances{get;set;} 

  private final String HOT_TOPICS = 'Hot Topics';
  private final String AT_A_GLANCE = 'At a Glance';

  private final String ACTIVE = 'Active';

    public cp_NewsController() {
        hotTopics = [SELECT id, full_story_url__c, short_description__c, referenced_url__c
                   FROM cp_News__c WHERE news_type__c = :HOT_TOPICS 
                    AND status__c = :ACTIVE];

    numHotTopics = hotTopics.size();

    ataGlances = [SELECT id, full_story_url__c, short_description__c, referenced_url__c
                    FROM cp_News__c WHERE news_type__c = :AT_A_GLANCE 
                     AND status__c = :ACTIVE];                    

    numAtaGlances = ataGlances.size();
    }
}