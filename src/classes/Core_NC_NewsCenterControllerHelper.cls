/*
  Class Name: Core_NC_NewsCenterControllerHelper
  Author : Mindtree
  Date: 1 Oct 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Helper class for NewsApp
*/
public with sharing class Core_NC_NewsCenterControllerHelper {
    
    /*******************************************************************************************************
    * @description This method get the wrapper data for Global News
    * @param String NewsType
    * @return List<Core_NC_NewsWrapperClass> wrapper
    */     
    public static List<Core_NC_NewsWrapperClass> getGlobalNewsForMostRecent(String NewsType) {
        List<News_Article__c > lstNews=new List<News_Article__c>();
        DateTime dt;
            dt=System.now().addDays(-Integer.valueof(CORE_NEWS_ARTICLE__c.getinstance('GlobalNewsDaysNumber').Text_Value__c));
        if(NewsType=='GlobalNews'){
            lstNews=[SELECT Id,Comment_Count__c,CreatedDate,Like_Count_RSF__c,Name,Title__c,News_Article_Topics__c,News_Body__c,Sub_Title__c,Site_Name__c,News_Publish_Date__c FROM News_Article__c Where News_Publish_Date__c >:dt and News_Publish_Date__c<=:System.now() and Site_Type__c='News Centre' and Archived__c=false and Hidden__c=false and Video_Article__c=false ORDER BY News_Publish_Date__c DESC];
        }else if(NewsType=='PaulsBlog'){
            lstNews=[SELECT Id,Comment_Count__c,CreatedDate,Like_Count_RSF__c,Name,Title__c,News_Article_Topics__c,News_Body__c,Sub_Title__c,Site_Name__c,News_Publish_Date__c FROM News_Article__c Where News_Publish_Date__c >:dt and News_Publish_Date__c<=:System.now() and Site_Type__c='Paul\'s Blog' and Archived__c=false and Hidden__c=false and Video_Article__c=false ORDER BY News_Publish_Date__c DESC];
        } else if(NewsType=='MyNews'){
            User usr=[SELECT Function__c,MCO__c FROM User where id=:Userinfo.getuserId()];    
            lstNews=[SELECT Id,Comment_Count__c,CreatedDate,Like_Count_RSF__c,Name,Title__c,News_Article_Topics__c,News_Body__c,Sub_Title__c,Site_Name__c,News_Publish_Date__c FROM News_Article__c Where News_Publish_Date__c >:dt and News_Publish_Date__c<=:System.now() and (Site_Name__c =: usr.Function__c or Site_Name__c =: usr.MCO__c) and Archived__c=false and Hidden__c=false and Video_Article__c=false ORDER BY News_Publish_Date__c DESC];
        }
        return getWrapperData(lstNews);
    }
   
    /*******************************************************************************************************
    * @description This method get the wrapper data for Trending News
    * @param String NewsType
    * @return List<Core_NC_NewsWrapperClass> wrapper
    */     
    public static List<Core_NC_NewsWrapperClass> getTrendingNews(String NewsType,String SortType) {
        List<Core_NC_NewsWrapperClass> lstwrapper =new List<Core_NC_NewsWrapperClass>();
        List<News_Article__c > lstNews=new List<News_Article__c>();
        DateTime dt;
            dt=System.now().addDays(-Integer.valueof(CORE_NEWS_ARTICLE__c.getinstance('TrendingNewsDaysNumber').Text_Value__c));
        if(NewsType=='GlobalNews'){
            if(SortType=='View'){ lstNews=[SELECT Id,Comment_Count__c,CreatedDate,Like_Count_RSF__c,Name,Title__c,News_Article_Topics__c,News_Body__c,Sub_Title__c,Site_Name__c,News_Publish_Date__c FROM News_Article__c Where News_Publish_Date__c >:dt and News_Publish_Date__c<=:System.now() and Site_Type__c='News Centre' and View_Count__c>0 and Archived__c=false and Hidden__c=false and Video_Article__c=false ORDER BY View_Count__c DESC,News_Publish_Date__c DESC];
            } else if(SortType=='Like'){ lstNews=[SELECT Id,Comment_Count__c,CreatedDate,Like_Count_RSF__c,Name,Title__c,News_Article_Topics__c,News_Body__c,Sub_Title__c,Site_Name__c,News_Publish_Date__c FROM News_Article__c Where News_Publish_Date__c >:dt and News_Publish_Date__c<=:System.now() and Site_Type__c='News Centre' and Like_Count_RSF__c>0 and Archived__c=false and Hidden__c=false and Video_Article__c=false ORDER BY Like_Count_RSF__c DESC,News_Publish_Date__c DESC];
            }else if(SortType=='Comment') lstNews=[SELECT Id,Comment_Count__c,CreatedDate,Like_Count_RSF__c,Name,Title__c,News_Article_Topics__c,News_Body__c,Sub_Title__c,Site_Name__c,News_Publish_Date__c FROM News_Article__c Where News_Publish_Date__c >:dt and News_Publish_Date__c<=:System.now() and Site_Type__c='News Centre' and Comment_Count__c>0 and Archived__c=false and Hidden__c=false and Video_Article__c=false ORDER BY Comment_Count__c DESC,News_Publish_Date__c DESC];
        }
        else if(NewsType=='MyNews'){
            User usr=[SELECT Function__c,MCO__c FROM User where id=:Userinfo.getuserId()];
        if(SortType=='View') {lstNews=[SELECT Id,Comment_Count__c,CreatedDate,Like_Count_RSF__c,Name,Title__c,News_Article_Topics__c,News_Body__c,Sub_Title__c,Site_Name__c,News_Publish_Date__c FROM News_Article__c Where News_Publish_Date__c >:dt and News_Publish_Date__c<=:System.now() and (Site_Name__c =: usr.Function__c or Site_Name__c =: usr.MCO__c) and View_Count__c>0 and Archived__c=false and Hidden__c=false and Video_Article__c=false ORDER BY View_Count__c DESC,News_Publish_Date__c DESC];
        } else if(SortType=='Like'){ lstNews=[SELECT Id,Comment_Count__c,CreatedDate,Like_Count_RSF__c,Name,Title__c,News_Article_Topics__c,News_Body__c,Sub_Title__c,Site_Name__c,News_Publish_Date__c FROM News_Article__c Where News_Publish_Date__c >:dt and News_Publish_Date__c<=:System.now() and (Site_Name__c =: usr.Function__c or Site_Name__c =: usr.MCO__c) and Like_Count_RSF__c>0 and Archived__c=false and Hidden__c=false and Video_Article__c=false ORDER BY Like_Count_RSF__c DESC,News_Publish_Date__c DESC];
        }else if(SortType=='Comment') {lstNews=[SELECT Id,Comment_Count__c,CreatedDate,Like_Count_RSF__c,Name,Title__c,News_Article_Topics__c,News_Body__c,Sub_Title__c,Site_Name__c,News_Publish_Date__c FROM News_Article__c Where News_Publish_Date__c >:dt and News_Publish_Date__c<=:System.now() and (Site_Name__c =: usr.Function__c or Site_Name__c =: usr.MCO__c) and Comment_Count__c>0 and Archived__c=false and Hidden__c=false and Video_Article__c=false ORDER BY Comment_Count__c DESC,News_Publish_Date__c DESC];
          }
        }
        return getWrapperData(lstNews);
    }
    
    /*******************************************************************************************************
    * @description This method get the wrapper data for News Detail
    * @param String NewsId
    * @return List<Core_NC_NewsWrapperClass> wrapper
    */     
    public static Core_NC_NewsDetailWrapperClass getNewsDetail(String NewsId) {
        Core_NC_NewsDetailWrapperClass wrapper=new Core_NC_NewsDetailWrapperClass ();
        News_Article__c  News=[SELECT Id,Comment_Count__c,CreatedDate,Like_Count_RSF__c,Name,Title__c,News_Body__c,News_Article_Topics__c,Sub_Title__c,Site_Name__c,Related_News_Article__c,Sharepoint_URL__c,News_Publish_Date__c,View_Count__c FROM News_Article__c Where Id=:NewsId];
        List<NewsArticleLike__c> NewsLike=new List<NewsArticleLike__c>();
        NewsLike=[Select Id FROM NewsArticleLike__c WHERE News_Article__c =:NewsId AND CreatedById =: Userinfo.getUserId()];
        wrapper=getWrapperData(News);
        wrapper.Liked=false;
        if(!NewsLike.isEmpty()){ wrapper.Liked=true;}
        Decimal ViewCounter=News.View_Count__c;
        if(ViewCounter!=null) {ViewCounter=ViewCounter+1;}
        else {ViewCounter=1;}
        News.View_Count__c=ViewCounter;
        update News; 
        return wrapper;
    }
    
    /*******************************************************************************************************
    * @description This method insert like to NewsArticleLike Object
    * @param String NewsId
    * @return Boolean
    */     
    public static Integer putLikeForNews(String NewsId) {
        NewsArticleLike__c newsLike=new NewsArticleLike__c();
        newsLike.News_Article__c=NewsId;
        //newsLike.CreatedById=Userinfo.getUserId();
        insert newsLike;
        Integer LikeCount=[SELECT count() FROM NewsArticleLike__c WHERE News_Article__c = :NewsId];
        return LikeCount;
    }
    
    /*******************************************************************************************************
    * @description This method get the wrapper data from List<News_Article__c>
    * @param List<News_Article__c>
    * @return List<Core_NC_NewsWrapperClass> wrapper
    */ 
    public static List<Core_NC_NewsWrapperClass> getWrapperData(List<News_Article__c> lstNews){
        List<Core_NC_NewsWrapperClass> lstwrapper =new List<Core_NC_NewsWrapperClass>();
        List<Document> lstDocument=[SELECT Id FROM Document where Name=:'NewsDefault'];
        Set<Id> setNewsId=new Set<Id>();
        for(News_Article__c news:lstNews){
            setNewsId.add(news.Id);
        }
        List<Attachment> lstAttachment=[SELECT Id,parentId FROM Attachment where parentId in :setNewsId];
        Map<Id,List<Id>> mapAttachment=new Map<Id,List<Id>>(); 
        for(Attachment attach: lstAttachment){
            if(!mapAttachment.containsKey(attach.parentId))
               mapAttachment.put(attach.parentId,new List<Id>());            
            mapAttachment.get(attach.parentId).add(attach.Id);
        }
        for(News_Article__c news:lstNews){
            Core_NC_NewsWrapperClass wrapper=new Core_NC_NewsWrapperClass();
            String strNewsBanner='';
            wrapper.Name=news.Title__c;
            wrapper.PublishedDate=news.News_Publish_Date__c.format('d MMM yyyy');
            Id attachid;
            if(mapAttachment.get(news.Id)!=null) {attachid=mapAttachment.get(news.Id)[0];
            } else {attachid=lstDocument[0].Id;
              } String imageURL ='/servlet/servlet.FileDownload?file=';
            String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm() + imageURL + attachid;
            wrapper.BannerURL=fullFileURL;
            wrapper.CommentCount=integer.valueof(news.Comment_Count__c);
            wrapper.LikeCount=integer.valueof(news.Like_Count_RSF__c);
            wrapper.NewsId=news.Id;
            wrapper.Topics=news.News_Article_Topics__c;
            wrapper.SubTitle=news.Sub_Title__c;
            wrapper.SiteName=news.Site_Name__c;
               wrapper.LoadMoreLimit=Integer.valueOf(CORE_NEWS_ARTICLE__c.getInstance('RecordCounNumber').Text_Value__c);
               wrapper.MyNewsSiteNameColorCode=CORE_NEWS_ARTICLE__c.getInstance('MyNewsSiteNameColorCode').Text_Value__c;
            lstwrapper.add(wrapper);
        }
        return lstwrapper;
    }
    
    /*******************************************************************************************************
    * @description This method get the wrapper data from News_Article__c
    * @param News_Article__c
    * @return Core_NC_NewsDetailWrapperClass wrapper
    */ 
    public static Core_NC_NewsDetailWrapperClass getWrapperData(News_Article__c news){
        Core_NC_NewsDetailWrapperClass wrapper=new Core_NC_NewsDetailWrapperClass();
        String strNewsBanner='';
        Boolean bolDefaultImage=false;
        wrapper.Name=news.Title__c;
        wrapper.PublishedDate=news.News_Publish_Date__c.format('d MMM yyyy');
        List<Attachment> lstAttachment=[SELECT Id FROM Attachment where parentId=:news.Id];
        List<Document> lstDocument;
        Id attachid;
        if(lstAttachment.isEmpty()){
            lstDocument=[SELECT Id FROM Document where Name=:'NewsDefault'];
            attachid=lstDocument[0].Id;
            bolDefaultImage=true;
        }
        else {attachid=lstAttachment[0].Id;
        } String imageURL ='/servlet/servlet.FileDownload?file=';
        String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm() + imageURL + attachid;
        wrapper.BannerURL=fullFileURL;
        wrapper.CommentCount=integer.valueof(news.Comment_Count__c);
        wrapper.LikeCount=integer.valueof(news.Like_Count_RSF__c);
        wrapper.NewsId=news.Id;
        wrapper.NewsBody=news.News_Body__c;
        wrapper.Topics=news.News_Article_Topics__c;
        wrapper.SubTitle=news.Sub_Title__c;
        wrapper.SiteName=news.Site_Name__c;
        Set<Id> setNewsId=new Set<Id>();
        if(news.Related_News_Article__c!=null){
            List<String> RelatedNewsArticle=new List<String>();
            String strRelatedNews=news.Related_News_Article__c.ReplaceAll(', ',',');
            RelatedNewsArticle=strRelatedNews.split(',');
            for(string strId:RelatedNewsArticle) setNewsId.add(Id.valueof(strId));
        }
        List<News_Article__c> lstNews=[SELECT Id,Comment_Count__c,CreatedDate,Like_Count_RSF__c,Name,Title__c,News_Body__c,News_Article_Topics__c,Sub_Title__c,Site_Name__c,Related_News_Article__c,News_Publish_Date__c FROM News_Article__c Where Id in:setNewsId and Archived__c=false and Hidden__c=false and Video_Article__c=false ];
        wrapper.RelatedNewsDetail=getWrapperData(lstNews);
           wrapper.CarouselLimit=Integer.valueOf(CORE_NEWS_ARTICLE__c.getInstance('CarouselLimit').Text_Value__c);
        wrapper.SharepointURL=news.Sharepoint_URL__c;
        wrapper.DefaultImage=bolDefaultImage;
            wrapper.MyNewsSiteNameColorCode=CORE_NEWS_ARTICLE__c.getInstance('MyNewsSiteNameColorCode').Text_Value__c;

        return wrapper;
    }
    
    /*******************************************************************************************************
    * @description This method post feed to Group on click of share
    * @param String NewsTitle,String NewsLink,String FeedBody,String FeedTo,String GroupNames
    * @return String
    */  
    public static Boolean postNewsToChatter(String NewsTitle,String NewsLink,String FeedBody,String FeedTo,String GroupNames) {
        system.debug('~~~~'+GroupNames);
        Boolean Success=false;
        List<string> lstGroup=new List<string>();
        Set<Id> setGroup=new Set<Id>();
        List<CollaborationGroup> lstCollGroup=new List<CollaborationGroup>();
        List<FeedItem> feedItemsToInsert=new List<FeedItem>();
        if(FeedTo=='Group'){
            lstGroup=GroupNames.split(',');
            lstCollGroup=[SELECT Id FROM CollaborationGroup where Name in:lstGroup];
            for(CollaborationGroup grp:lstCollGroup){
                setGroup.add(grp.Id);
            }
            for(Id grpId:setGroup){
                 feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body = FeedBody, ParentId =grpId,
                                LinkURL = NewsLink, Title = NewsTitle));
            }
        }
        else{
            feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body = FeedBody, ParentId =Userinfo.getUserId(),
                                LinkURL = NewsLink, Title = NewsTitle));
        }
        //Insert FeedItem.
        if(!feedItemsToInsert.isEmpty()){
            Database.insert(feedItemsToInsert, false);
        }Success=true;
        return Success;
    }
    
    /*******************************************************************************************************
    * @description This method used to get Group names based on User inputted Text
    * @param String GroupName
    * @return List<String>
    */  
    public static String getGroupNames() {//String GroupName
       
        List<CollaborationGroup> lstGroup=[SELECT Name FROM CollaborationGroup WHERE IsArchived = false];//Name LIKE :strGroupName and 
        String strGrp='';
        for(CollaborationGroup grp : lstGroup){  
            strGrp=strGrp+grp.Name+',';
        }
        if(strGrp!=''&&strGrp!=null){ strGrp=strGrp.substring(0,strGrp.length()-1); //thestring.substring(0,thestring.length()-1);
        }return strGrp;
    }
    
    /*******************************************************************************************************
    * @description This method used to get information needed for GA
    * @param 
    * @return Core_NC_NewsGAWrapperClass 
    */ 
    public static Core_NC_NewsGAWrapperClass getGAInfo() {//String GroupName
        Core_NC_NewsGAWrapperClass wrapper=new Core_NC_NewsGAWrapperClass();
        wrapper.UserId=Userinfo.getUserId();
            wrapper.GAId=CORE_NEWS_ARTICLE__c.getInstance('GoogleAnalyticsId').Text_Value__c;
        return wrapper;
    }
    
     /*******************************************************************************************************
    * @description This method used to get list of news article topic names
    * @param 
    * @return List<CORE_NEWS_ARTICLE__c>
    */ 
    public static List<String> getTopicNames() {//String TopicName
        Set<String> newsArticleSet=new Set<String>();
        newsArticleSet.add('Show All');
        for(News_Article__c newsArticle: [SELECT News_Article_Topics__c FROM News_Article__c WHERE Archived__c=false and Hidden__c=false and Video_Article__c=false]){
            newsArticleSet.add(newsArticle.News_Article_Topics__c);
        }
        return new List<String>(newsArticleSet);
    }
}