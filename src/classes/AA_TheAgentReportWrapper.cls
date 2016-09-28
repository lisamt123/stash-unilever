public with sharing class AA_TheAgentReportWrapper {

    @RemoteAction @AuraEnabled
    public aa_Agent_Report__c agent_report { get; set; }
    @RemoteAction @AuraEnabled
    public String pic_url { get; set; }
    @RemoteAction @AuraEnabled
    public String report_display { get; set; }
    @RemoteAction @AuraEnabled
    public String user_photo_url { get; set; }
    @RemoteAction @AuraEnabled
    public Integer number_of_likes { get; set; }
    @RemoteAction @AuraEnabled
    public String formattedDate { get; set; }
    
    List<TopicAssignment> topics { get;set; }
    public static String IMAGE_PREFIX = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=';
    public static Integer REPORT_LIMIT = 220;
    public static String PLACEHOLDER_RESOURCE_NAME = 'agent_placeholder';
    public static String PLACEHOLDER_UNILEVER_NAME = 'agent_unilever_placeholder';
    public static String COMPETITIVE_RECORD_TYPE = 'Competitor Review/Publish Report';
    
    public AA_TheAgentReportWrapper(){
        agent_report = new aa_Agent_Report__c();
        pic_url = '';
        report_display = '';
        user_photo_url = '';
        number_of_likes = 0;
        formattedDate = '';
    }
    
    public AA_TheAgentReportWrapper(aa_Agent_Report__c report){
        System.debug('1');
        agent_report = report;
//        pic_url = get_first_chatter_pic_url(report);
 //       System.debug('2 '+pic_url);
        report_display = display_report_summary(report);
        System.debug('3 '+report_display);
     //   number_of_likes = get_number_of_likes(report);
   //     System.debug('4 '+number_of_likes);
       // topics = get_topics(report);
     //   System.debug('5 '+topics);
        //formattedDate = report.CreatedDate.format();
    }
    
    public String display_report_summary(aa_Agent_Report__c report) {
    
        if (report.Report__c == null)
            return '';
    
        if (report.Report__c.length() > REPORT_LIMIT) {
            return report.Report__c.substring(0, REPORT_LIMIT) + '...';
        } else {
            return report.Report__c;
        }
    }
    
    public String first_chatter_pic_id(aa_Agent_Report__c report) {
        String pic_id = null;
        List<ContentDocumentLink> documentList = new List<ContentDocumentLink>();
        documentList = [SELECT ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :report.Id ORDER BY ContentDocument.ContentModifiedDate ASC LIMIT 1];
        System.debug('6 '+documentList);
        if(documentList.size()>0) {
            pic_id  = documentList[0].ContentDocument.LatestPublishedVersionId;
        }
        System.debug('7 '+pic_id);
        return pic_id;
    }
    
    public String first_chatter_pic_content_id(aa_Agent_Report__c report) {
        String pic_id = null;
        System.debug('**8 ');
        system.debug('report_id==>'+report.Id);
        List<ContentDocumentLink> documentList = new List<ContentDocumentLink>();
        system.debug('report.id'+report.Id);   
         ID reportId=report.Id;                                         //ORDER BY ContentDocument.ContentModifiedDate ASC
      //  documentList = [SELECT ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId =:reportId  LIMIT 1];
       // documentList = [SELECT ContentDocument.id FROM ContentDocumentLink WHERE LinkedEntityId =:reportId  LIMIT 1];
        documentList = [SELECT ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId =:reportId  LIMIT 1];
        system.debug('report_id==>'+report.Id);
         system.debug('contentDocument========>'+documentList);
        if(documentList.size()>0) {
            system.debug('**contentDocument========>'+documentList[0].ContentDocument.id);
            pic_id  = documentList[0].ContentDocument.id;
            
        }
        system.debug('pic_id==>'+pic_id);
        //pic_id = '069c0000000F02M';
        System.debug('**9 ');
        return pic_id;
    }
    
  /*  public String get_first_chatter_pic_url(aa_Agent_Report__c report) {
        List<ContentDocumentLink> documentList = new List<ContentDocumentLink>();
        String pic_url = '';
        System.debug('**10 ');
        documentList = [SELECT ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :report.Id ORDER BY ContentDocument.ContentModifiedDate ASC LIMIT 1];
                
        if(first_chatter_pic_id(report) != null) {
        System.debug('**11 ');  
            pic_url = IMAGE_PREFIX + first_chatter_pic_id(report);
        } else {
        System.debug('**12 ');    
            if(report.RecordType.Name == COMPETITIVE_RECORD_TYPE) {
                System.debug('**13 ');
                pic_url = GetResourceURL(PLACEHOLDER_UNILEVER_NAME);
            } else {
                System.debug('**14 ');
                pic_url = GetResourceURL(PLACEHOLDER_RESOURCE_NAME);
            }
        }
    System.debug('**15 ');
        return pic_url;
    }*/
    
   /* @AuraEnabled
    public String getFormattedCreationDate(){
        return agent_report.CreatedDate.format();
    }*/
    
    public static String GetResourceURL(String resourceName) {
        List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName LIMIT 1];
System.debug('**16 ');
        if (resourceList.size() == 1) {
           System.debug('**17 ');
            String namespace = resourceList[0].NamespacePrefix;
           return '/resource/'
              + resourceList[0].SystemModStamp.getTime() + '/'
              + (namespace != null && namespace != '' ? namespace + '__' : '')
              + resourceName;
        } else return '';
 
    }
    
   /* public Integer get_number_of_likes(aa_Agent_Report__c report) {
        Integer number_of_likes = 0;

        List<FeedItem> feedList = new List<FeedItem>();

        feedList = [SELECT LikeCount FROM FeedItem WHERE Id = :report.Chatter_Post_ID__c LIMIT 1];
        
        if(feedList.size()>0) {
            number_of_likes = feedList[0].LikeCount;
        }

        return number_of_likes;

    }*/
  /*  public List<TopicAssignment> get_topics(aa_Agent_Report__c report) {

        List<TopicAssignment> topics = new List<TopicAssignment>();

        topics = [SELECT Topic.Name FROM TopicAssignment WHERE EntityId = :report.Chatter_Post_ID__c];

        return topics;

    }*/
}