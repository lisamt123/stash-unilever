global without sharing class uw_PinnovateController {
    

    
    public String Comm{get;set;}
    public String CommId{get;set;}
    public String strFeedItemID{get;set;}
    public String strPreviewID  {get;set;}
    
    //This method is used insert comment to the feeditem
    public void insrtComt() {
        String strFeedItemID = ApexPages.currentPage().getParameters().get('cid');
        if(Comm!=null&&Comm!=''&&Comm!='Write a comment...'){
        feedcomment fd=new feedcomment();
        fd.feeditemid=CommId;
        fd.CommentBody=Comm;
        fd.CommentType='TextComment';
        fd.CreatedById=UserInfo.getUserId();
        insert fd;
        refCommentDetails(); 
        Comm='';
        }
   }



    public Boolean bolShowPopupLik { get; set; }

    public Boolean bolShowPopupCom { get; set; }
    public Boolean bolShowPopupPreview { get; set; }
    public Boolean bolAllowComment {get; set;}
    public Boolean bolCommentDetail {get;set;}
    
    
  private List<String> colourWheel = null;
  private Integer colourIndex = null;
  private CollaborationGroup collabGroup = null;
  private List<CollaborationGroupFeed> collabGroupFeed = null;
  private Map<Id,User> feedItemCreatedByUserMap = null;
  //private Map<Id,User> feedItemCreatedByUserMapAll = null;
  //private Map<Id,User> feedItemCreatedByUserMap1 = null;
  //private Map<Id,User> feedItemCreatedByUserMap2 = null;
  //private List<CollaborationGroupFeed> collabGroupFeed1 = null;
  
  public Map<String, List<Id>> topicAssignments = new Map<String, List<Id>>();
  public String topicName {get; set;}
  public Pinnovate_Preference__c settings {get; set; }
  
  public List<FeedComment> lstFeedComt    {get;set;}
  public List<ClsCommentDet> lstFeecComtWrap    {get;set;}
  
  //public List<FeedLike> lstFeedlik    {get;set;}
  public List<ClsCommentDet> lstFeeclikWrap {get;set;}
  //public List<User> user_info;
  //public boolean bolShowPopup    {get;set;}
  
  public uw_PinnovateController ()
  {
    init();
    bolShowPopupCom = false;
    bolShowPopupLik = false;
    bolShowPopupPreview=false;
    bolAllowComment=true;
    bolCommentDetail=false;
    lstFeecComtWrap = new List<ClsCommentDet>();
    lstFeeclikWrap = new List<ClsCommentDet>();
    //Liked=false;
    //Unliked=true;
    //edItemCreatedByUserMap2 = new Map<ID, User>([select id, name from User where IsActive=true]);
    //user_info=[select id, SmallPhotoUrl from user];
  }
  
  public PageReference backToGroup()
  {
    return new PageReference('/'+getCollaborationGroupId());
  }
  
  public CollaborationGroup getCollaborationGroup()
  {
    if (null == collabGroup)
    {
      collabGroup = [select Name from CollaborationGroup where id = :getCollaborationGroupId()];
    }
    
    return collabGroup;
  }
  
  public String getCollaborationGroupId()
  {
    String cgId = ApexPages.currentPage().getParameters().get('id');
    
    return cgId;
  }
  
  public List<CollaborationGroupFeed> getCollaborationGroupFeed()
  {
    // TODO - do we need to put any limit on this?
    if (null == collabGroupFeed)
    {
      collabGroupFeed = [Select Type, Title, RelatedRecordId, ParentId, LinkUrl, LikeCount, ContentType, ContentSize, ContentFileName
      , ContentDescription, CommentCount, Body,CreatedById, CreatedDate
      ,  (Select Id, FeedItemId, ParentId, CreatedById, CreatedDate, CommentBody, IsDeleted, InsertedById From FeedComments)
      , (Select InsertedById, CreatedDate From FeedLikes) 
      From CollaborationGroupFeed where ParentId =: getCollaborationGroup().Id];
      System.debug('******'+collabGroupFeed );
    }
    
    return collabGroupFeed;
  }
  
  public Map<Id,User> getFeedItemCreatedByUserMap()
  {
  
    if (feedItemCreatedByUserMap == null)
    {
      Set<Id> createdByUserIdSet = new Set<Id>();
      
      for (CollaborationGroupFeed cgf: getCollaborationGroupFeed())
      {
         
        createdByUserIdSet.add(cgf.CreatedById);
      }
      System.debug('**** in method ' + createdByUserIdSet);
      feedItemCreatedByUserMap = new Map<Id,User>([Select SmallPhotoUrl, Name, Id From User where Id in : createdByUserIdSet]);
    }
     
    return feedItemCreatedByUserMap;
  }
  //Added By Prashant
  /*public Map<Id,User> getFeedItemCreatedByUserMapAlll()
  {
  
    if (feedItemCreatedByUserMapAll== null)
    {
      feedItemCreatedByUserMapAll= new Map<Id,User>([Select SmallPhotoUrl, Name, Id From User]);
    }
     
    return feedItemCreatedByUserMapAll;
  }*/
  
  public void init()
  {
    colourWheel = new List<String>();
    colourWheel.add('#AC4FC6');
    colourWheel.add('#3C1053');
    colourWheel.add('#702F8A');
    colourWheel.add('#B288B9');

    colourWheel.add('#71C5E8');
    colourWheel.add('#005EB8');
    colourWheel.add('#00A9E0');
    colourWheel.add('#004976');

    colourWheel.add('#00B2A9');
    colourWheel.add('#008264');
    colourWheel.add('#00A3AD');
    colourWheel.add('#007367');

    colourWheel.add('#78BE20');
    colourWheel.add('#00573F');
    colourWheel.add('#4488E3');
    colourWheel.add('#84BD00');

    colourWheel.add('#BBB323');
    colourWheel.add('#949300');
    colourWheel.add('#B7BF10');
    colourWheel.add('#E1E000');

    colourWheel.add('#F1B434');
    colourWheel.add('#FFC72C');
    colourWheel.add('#E5F200');
    colourWheel.add('#FFD100');

    colourWheel.add('#BF0D3E');
    colourWheel.add('#DC6B2F');
    colourWheel.add('#9B2743');
    colourWheel.add('#E4002B');

    colourWheel.add('#E56DB1');
    colourWheel.add('#DF1995');
    colourWheel.add('#722257');
    colourWheel.add('#AF1685');

    // - inner circle
    colourWheel.add('#8A1B61'); 
    colourWheel.add('#0085CA');
    colourWheel.add('#00B388');
    colourWheel.add('#6BA539');
    colourWheel.add('#CEDC00');
    colourWheel.add('#ED8B00');
    colourWheel.add('#DA291C');
    colourWheel.add('#D0006F');
    // Middle
    colourWheel.add('#0E0E9A');
    
    try{
        settings = [select Background_Color__c, Background_Image__c, Header_Banner__c from Pinnovate_Preference__c where Name = :getCollaborationGroupId() limit 1];
    }
    catch(Exception ex){
         settings = [select Background_Color__c, Background_Image__c, Header_Banner__c from Pinnovate_Preference__c where Name = :'DEFAULT' limit 1];
    }
  }
  
  public String getNextColour()
  {
    // Need to pick a random number between 0 and 40 (41 Items)
    // Then keep adding 4 to it to go around the wheel
    
    // Set back to null if want ramdom choice each time 
    if (colourIndex == null)
    {
      colourIndex = Crypto.getRandomInteger();
      System.debug('initial value is '+colourIndex);  
      // colourIndex = Math.getRandomInteger();
      colourIndex = Math.abs(colourIndex);
    }
    else
    {
      // Then keep adding 4 to it to go around the wheel
      // 1/2/4/5/6/10/11?
      colourIndex += 4;
    }
    
    colourIndex = Math.mod(colourIndex, colourWheel.size());
    
    System.debug('index is '+colourIndex);
    
    return colourWheel.get(colourIndex);
  }
  
  public class PinnovateRow
  {
    public List<PinnovateTableData> tableData = new List<PinnovateTableData>();
    public PinnovateRow()
    {
      
    }
    
    public List<PinnovateTableData> getTableData()
    {
      return tableData;
    }
  }
  
  public class PinnovateTableData
  {
    public Boolean isEmpty {get; set;}
    public String title {get; set;}
    public String titleColour {get; set;}
    public String contentURL {get; set;}
    public Datetime createdDate {get; set;}
    public String description  {get; set;}
    public Integer likeCount {get; set;}
    public Integer commentCount {get; set;}
    public String createdDateString; 
    public User creator {get; set;}
    public CollaborationGroupFeed feedItem {get; set;}
    public String sortableDate {get; set;}
    public Boolean hasLikedPost {get; set; }
    public Id likedUserId {get;set;}                   //Mindtree added on 27/06/2014
    public string likedUserName {get;set;}             //Mindtree added on 27/06/2014
    public Boolean hasLoginUserLikedPost {get; set; }  //Mindtree added on 27/06/2014
    
    //public String strRecordID    {get;set;}
    
    public PinnovateTableData()
    {
      isEmpty = true;
      sortableDate = '0000';
    }
    
    public String getCreatedDateString()
    {
      // Today at /Yesterday at /Two days ago at/Three days ago at// then date
      // Format for user date and time...
      
      Date thisDay = Date.today();
      
      Integer daysBetween = createdDate.date().daysBetween(thisDay);
      // HH:mm is 24 hour
      // hh:mm a is 12 hour am/pm
      String timeFormat = 'HH:mm'; 
      if (true)
      {
        // TEST CODE 
        // return   createdDate.format('MMMM dd, yyyy \'at\' hh:mm a');
      }
      
      if (daysBetween == 0)
      {
        return 'Today at '+  createdDate.format(timeFormat);
      } 
      else if (daysBetween == 1)
      {
        return 'Yesterday at '+ createdDate.format(timeFormat);
      }
      else if (daysBetween == 2)
      {
        return 'Two days ago at '+ createdDate.format(timeFormat);
      }
      else if (daysBetween == 3)
      {
        return 'Three days ago at '+ createdDate.format(timeFormat);
      }
      
      return   createdDate.format('MMMM dd, yyyy \'at\' '+timeFormat);
    }
    
    /* Author: Mindtree
      Date: 27/06/2014
      Description:Format a string of names who liked the feed recently */ 
    public String getLikeString()
    {
      integer intlikecount=likeCount-1;
      integer intlikecount2=intlikecount-1;
          
      if(hasLoginUserLikedPost ==true  && likeCount == 1  )
        return 'You ';
      
      else if(hasLoginUserLikedPost ==true && likeCount == 2 )
        return 'You and '+likedUserName+' ';
      
      else if(hasLoginUserLikedPost ==true && likeCount ==3 )
        return 'You,'+likedUserName+' and '+intlikecount2+' other ';
      
      else if(hasLoginUserLikedPost ==true && likeCount >3 )
        return 'You,'+likedUserName+' and '+intlikecount2+' others ';
      
      else if(likedUserName != null && likeCount== 1  )
        return likedUserName+' ';
      
      else if(likedUserName != null && likeCount ==2 )
         return likedUserName+' and '+intlikecount+' other  ';
      
      else if(likedUserName != null && likeCount >2  )
         return likedUserName+' and '+intlikecount+' others  ';
      
      else
       return '';
    }
    /*---------- end of formating string method---------- */
    
  }
  
  public List<PinnovateTableData> getPinnovateTableData()
  {
    List<PinnovateTableData> tableDataList = new List<PinnovateTableData>();
    
    
    for (PinnovateRow pr: getPinnotaveRows())
    {
      for (PinnovateTableData ptd: pr.getTableData())
      {
        if (!ptd.isEmpty)
        {
          tableDataList.add(ptd);
        }
      }
    }
    
    return tableDataList;
  }
  
  /*public List<PinnovateTableData> getSearchResults()
  {
    // TODO - Cache
    List<PinnovateTableData> allTableData = getPinnotaveDataOrderedFirst();
    
    return null;  
  }*/
  
  public List<PinnovateTableData> getPinnotaveDataOrderedFirst()
  {
    Map<String,List<PinnovateTableData>> mapOfTableData = new Map<String,List<PinnovateTableData>>();
    
    List<uw_Links__c> wallLinks = [Select Related_Feed_Item__c, Related_Collaboration_Group__c, RecordTypeId, Id From uw_Links__c where Related_Collaboration_Group__c = : getCollaborationGroup().Id];
    
    List<String> feedItemIds = new List<String>();
    for (uw_Links__c link: wallLinks)
    {
      feedItemIds.add(link.Related_Feed_Item__c);
    }
    
    compileTopicAssignments(feedItemIds);
        
    if(topicName != null && topicName != 'All')
        feedItemIds = topicAssignments.get(topicName);
    
    collabGroupFeed = [Select Type, Title, RelatedRecordId, ParentId, LinkUrl, LikeCount, ContentType, ContentSize, ContentFileName
      , ContentDescription, CommentCount, Body,CreatedById, CreatedDate
      ,  (Select Id, FeedItemId, ParentId, CreatedById, CreatedDate, CommentBody, IsDeleted, InsertedById From FeedComments)
      , (Select InsertedById, CreatedDate,InsertedBy.Name From FeedLikes) 
      From CollaborationGroupFeed where ParentId =: getCollaborationGroup().Id and Id in : feedItemIds];
      
        
    for (CollaborationGroupFeed feedItem: collabGroupFeed)
    {
        System.debug('*** line 290 ' + feedItem);
        
      PinnovateTableData ptd = new PinnovateTableData();
      ptd.feedItem = feedItem;
      ptd.titleColour = getNextColour();
      // TODO - Crop Title 
      ptd.title = feedItem.Title;
      ptd.createdDate = feedItem.CreatedDate;
      // TODO - change this - it queries all the feed items in the group?
      ptd.creator = getFeedItemCreatedByUserMap().get(feedItem.CreatedById);
      ptd.description = feedItem.Body;
      
      //Added by Prashanth
      //ptd.strRecordID = feedItem.id;
      /*
      if (ptd.description.length() > 130)
      {
        ptd.description = ptd.description.substring(0,130);
        ptd.description += '...';
      }*/
      
      ptd.likeCount = feedItem.LikeCount;
      ptd.commentCount = feedItem.CommentCount;
      
      if (feedItem.Type == 'LinkPost')
      {
        String videoId = uw_HelperMethods.parseYouTubeVideoIdPr(feedItem.LinkURL);
        
        if (!uw_HelperMethods.valueIsNull(videoId))
        {
          String embed = 'https://www.youtube.com/embed/'+videoId +'?feature=player_detailpage&showinfo=0';
          ptd.contentURL = embed;
        }
        else
        {
          // Not much we can do but put in the origional one :(
          ptd.contentURL = feedItem.LinkURL + '&showinfo=0';
        }
      }
      else if (feedItem.Type == 'ContentPost')
      {
       ptd.contentURL = feedItem.RelatedRecordId; 
         
      }
      ptd.isEmpty = false;
      
      ptd.sortableDate = feedItem.CreatedDate.format('yyyyMMddHHmmss');
      // Need to find the latest like and comment
      for (FeedComment comment: feedItem.FeedComments)
      {
        String commentDateStr = comment.CreatedDate.format('yyyyMMddHHmmss');
        if (ptd.sortableDate < commentDateStr)
        {
          ptd.sortableDate = commentDateStr;
          ptd.createdDate = comment.CreatedDate;
        }
      }
      
      for (FeedLike fLike: feedItem.FeedLikes)
      {
        String likeDateStr = fLike.CreatedDate.format('yyyyMMddHHmmss');
        
        if (ptd.sortableDate < likeDateStr)
        {
          ptd.sortableDate = likeDateStr;
          ptd.createdDate = fLike.CreatedDate;
        }
        if(fLike.InsertedById == UserInfo.getUserId())
            ptd.hasLikedPost = true;
      }
      
       /* Author: Mindtree
        Date: 27/06/2014
        Description:Sort the feedlike dates to get the Recent feedlikes for particular feed item. */
      
      String strrefDate = feedItem.CreatedDate.format('yyyyMMddHHmmss');
      for (FeedLike fLike: feedItem.FeedLikes){
        String strLikeDate = fLike.CreatedDate.format('yyyyMMddHHmmss');
        
        if (strrefDate  < strLikeDate && fLike.InsertedById != UserInfo.getUserId() ){
          strrefDate  =  strLikeDate ;
          ptd.likedUserId=fLike.InsertedById;
          ptd.likedUserName =fLike.InsertedBy.Name;
        }
        if(fLike.InsertedById == UserInfo.getUserId())
            ptd.hasLoginUserLikedPost = true;
      }
     /*------------ End of sort method -----------------*/
      
      if (mapOfTableData.get(ptd.sortableDate) == null)
            {
              mapOfTableData.put(ptd.sortableDate,new List<PinnovateTableData>());
            }
            
            mapOfTableData.get(ptd.sortableDate).add(ptd);
    }
    
    List<String> sortList = new List<String>();
    sortList.addAll(mapOfTableData.keySet());
    sortList.sort();
    
    sortList = reverseList(sortList);
        
    List<PinnovateTableData> tableData = new List<PinnovateTableData>();
    
    for (String s: sortList)
    {
      tableData.addAll(mapOfTableData.get(s));
    }
    
    return tableData;
  }
  
  private List<String> reverseList(List<String> sList)
    {
      List<String> retList = new List<String>();
      
      for (Integer i = sList.size()-1; i >= 0; i--)
      {
        retList.add(sList.get(i));
      }
      
      return retList;
    }
  
  public List<PinnovateRow> getPinnotaveRows()
  {
    List<PinnovateRow> rows = new List<PinnovateRow>();
    PinnovateRow row = new PinnovateRow();
    rows.add(row);
    
    // What about other style youtube links! e.g with embed?
    Pattern myPattern = Pattern.compile('http\\:\\/\\/www\\.youtube\\.com\\/watch\\?v=(\\w{11}).*');
      
      System.debug('Got feed item count :'+getCollaborationGroupFeed().size());
    for (CollaborationGroupFeed cgf: getCollaborationGroupFeed())
    {
      System.debug('Url is '+cgf.LinkURL);
      // TODO- what other youtube url formats are there? .co.uk youtu.be?
      if (!uw_HelperMethods.valueIsNull(cgf.LinkURL) && cgf.LinkURL.toLowerCase().contains('youtube') )
      {
        PinnovateTableData ptd = new PinnovateTableData();
        ptd.feedItem = cgf;
        ptd.titleColour = getNextColour();
        // TODO - Crop Title 
        ptd.title = cgf.Title;
        ptd.createdDate = cgf.CreatedDate;
        ptd.creator = getFeedItemCreatedByUserMap().get(cgf.CreatedById);
        ptd.description = cgf.Body;
        /*
        if (ptd.description.length() > 130)
        {
          ptd.description = ptd.description.substring(0,130);
          ptd.description += '...';
        }*/
        
        ptd.likeCount = cgf.LikeCount;
        ptd.commentCount = cgf.CommentCount;
                
        matcher myMatcher = myPattern.matcher(cgf.LinkURL);
        if (myMatcher.matches() && myMatcher.groupCount() == 1)
        {
          // ORIG String embed = 'http://www.youtube.com/embed/'+ myMatcher.group(1) +'?rel=0';
          String embed = 'https://www.youtube.com/embed/'+ myMatcher.group(1) +'?feature=player_detailpage&showinfo=0';
          ptd.contentURL = embed;
        }
        else
        {
          ptd.contentURL = cgf.LinkURL+'&showinfo=0';
        }
        
        ptd.isEmpty = false;
        
        System.debug('Added Table Data URL ' +ptd.contentURL);
        row.getTableData().add(ptd);
        
        if (row.getTableData().size() == 5)
        {
          row = new PinnovateRow();
          rows.add(row);  
        }
      }
    }
    
    for (PinnovateRow pr: rows)
    {
      if (pr.getTableData().size() < 5)
      {
        while(pr.getTableData().size() < 5)
        {
          // Add empty table cells
          pr.getTableData().add(new PinnovateTableData());
        }
      }
    }
    
    return rows;
  }
  
  private void compileTopicAssignments(List<Id> feedItemIds){
        
        if(topicAssignments == null || topicAssignments.isEmpty()) 
        for(TopicAssignment topicAssign : [Select Id, TopicId, Topic.Name, EntityId from TopicAssignment 
                                                where EntityId in :feedItemIds]){
                                                
            if(topicAssignments.get(topicAssign.Topic.Name) == null)
                topicAssignments.put(topicAssign.Topic.Name, new List<Id>());
             
            topicAssignments.get(topicAssign.Topic.Name).add(topicAssign.EntityId);
        }                                      
    }
    
        public PageReference setTopicFilter() {
            return null;
        }
            
        public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('All','All'));
            for(String topicName : topicAssignments.keySet())
                options.add(new SelectOption(topicName, topicName));
           
            return options;
        }
        
       @RemoteAction
       global static Integer likeFeedItem(String feedItemId) {
           ConnectApi.ChatterFeeds.likeFeedItem(null, feedItemId);
           return ConnectApi.ChatterFeeds.getLikesForFeedItem(null, feedItemId).total;
           
      }
      
      //This method is used to populate the data on Comment Popup
      public void refCommentDetails(){
          
          if(Comm!=null&&Comm!=''&&Comm!='Write a comment...'){
          strFeedItemID=CommId;
          }
          else
          {
              strFeedItemID = ApexPages.currentPage().getParameters().get('feeditemIdForComment');
              CommId=strFeedItemID;
          }
          
          //Get all the user ID's
          List<FeedComment> lstFeedComtUserID = [SELECT CreatedById,CommentBody,CreatedBy.name,CommentType,FeedItemId,Id,ParentId,RelatedRecordId FROM FeedComment WHERE FeedItemId =:strFeedItemID];
          set<id> setUserID = new set<id>();
          for(FeedComment fc:lstFeedComtUserID){
              setUserID.add(fc.CreatedById);
          }
          System.debug('~~~date=' + (System.now()).date().format());
          Map<id,User> mapuserInfo = new Map<id,User>([select SmallPhotoUrl from user where id IN:setUserID]);
          
          if(strFeedItemID!=null){
              lstFeecComtWrap.clear();
              lstFeedComt = [SELECT CreatedById,CommentBody,CreatedBy.name,CommentType,FeedItemId,Id,ParentId,RelatedRecordId FROM FeedComment WHERE FeedItemId =:strFeedItemID];
              for(FeedComment objFC :lstFeedComt ){
                      ClsCommentDet pbkCd = new ClsCommentDet();
                      pbkCd.strFeedCmmt = objFC.CommentBody;
                      pbkCd.strUserName = objFC.CreatedBy.Name;
                      pbkCd.createdidby= objFC.CreatedById;
                      //pbkCd.objPhotoURL=[select SmallPhotoUrl from user where id=:objFC.CreatedById];//getFeedItemCreatedByUserMap1().get(objFC.CreatedById);
                      pbkCd.objPhotoURL=mapuserInfo.get(objFC.CreatedById);
                      lstFeecComtWrap.add(pbkCd);
              }
              
              if(lstFeedComt.size()>0)
              { 
              bolShowPopupCom = true;    
              bolCommentDetail=true;        
              }
              else
              {
               bolShowPopupCom = true; 
              }
              
          }
          
      }
      
      //This method is used to populate the data on like Popup
       public void refLikeDetails(){
       
       
          String strFeedItemIDForLike = ApexPages.currentPage().getParameters().get('feeditemIdForLike');
           
          //Get all the user ID's
          CollaborationGroupFeed collabGroupFeed2 = [Select Type, Title, RelatedRecordId, ParentId, LinkUrl, LikeCount, ContentType, ContentSize, ContentFileName
                                                          , ContentDescription, CommentCount, Body,CreatedById, CreatedDate
                                                          ,  (Select Id, FeedItemId, ParentId, CreatedById, CreatedDate, CommentBody, IsDeleted, InsertedById From FeedComments)
                                                          , (Select InsertedById,InsertedBy.name, CreatedDate From FeedLikes) 
                                                          From CollaborationGroupFeed where ParentId =: getCollaborationGroup().Id and Id =: strFeedItemIDForLike];
          set<id> setUserID = new set<id>();
          for(FeedLike objFL :collabGroupFeed2.FeedLikes){
              setUserID.add(objFL.InsertedById);
          }
          
          Map<id,User> mapuserInfo = new Map<id,User>([select SmallPhotoUrl from user where id IN:setUserID]);
          
          if(strFeedItemIDForLike!=null){
              lstFeeclikWrap.clear();
              
              CollaborationGroupFeed collabGroupFeed1 = [Select Type, Title, RelatedRecordId, ParentId, LinkUrl, LikeCount, ContentType, ContentSize, ContentFileName
                                                          , ContentDescription, CommentCount, Body,CreatedById, CreatedDate
                                                          ,  (Select Id, FeedItemId, ParentId, CreatedById, CreatedDate, CommentBody, IsDeleted, InsertedById From FeedComments)
                                                          , (Select InsertedById,InsertedBy.name, CreatedDate From FeedLikes) 
                                                          From CollaborationGroupFeed where ParentId =: getCollaborationGroup().Id and Id =: strFeedItemIDForLike];
              
              for(FeedLike objFCL :collabGroupFeed1.FeedLikes){
                      ClsCommentDet pbklk = new ClsCommentDet();
                      pbklk.strUserName = objFCL.InsertedBy.name;
                      pbklk.createdidby=objFCL.InsertedById;
                      pbklk.objPhotoURL=mapuserInfo.get(objFCL.InsertedById);
                      lstFeeclikWrap.add(pbklk);
                   
              }
              if(lstFeeclikWrap.size()>0) bolShowPopupLik = true;
              
          }
      }
      //Wrapper class for Comment and Like Popup
      public class ClsCommentDet{
          public String strFeedCmmt {get;set;}
          public user objPhotoURL    {get;set;}
          public String strUserName    {get;set;}
          public String createdidby {get;set;}
      }
          //This method is used to unlike the feeditem
    public void ClickUnLike() {
    
        string strFeedItemIDForLikeClick = ApexPages.currentPage().getParameters().get('unlikeId');
        if(strFeedItemIDForLikeClick!=null&&strFeedItemIDForLikeClick!=''){
        feeditem likefd=[SELECT Body,(Select InsertedById,InsertedBy.name, CreatedDate From FeedLikes),CreatedById,Id,InsertedById,LikeCount,ParentId,Title,Type FROM FeedItem where id=:strFeedItemIDForLikeClick ];
        
        for(FeedLike objFCL :likefd.FeedLikes){
            if(UserInfo.getUserId()==objFCL.InsertedById){
                delete objFCL;
                }
        }
       } 
    }

    //This method is used to like the feeditem
    public void ClickLike() {
        string strFeedItemIDForUnLikeClick = ApexPages.currentPage().getParameters().get('likeId');
        if(strFeedItemIDForUnLikeClick!=null&&strFeedItemIDForUnLikeClick!=''){
        feedlike fdLike=new feedlike ();
        fdLike.feeditemid=strFeedItemIDForUnLikeClick;
        insert fdLike; 
        }
    }

    
    //This method is used to close the Like popup
    public PageReference closePopupLik() {
        bolShowPopupLik = false;
        return null;
    }

    //This method is used to close the Comment popup
    public PageReference closePopupCom() {
        bolShowPopupCom = false;
        return null;
    }
    
    //This method is used to close the Comment popup
    public PageReference closePopupPreview() {
        bolShowPopupPreview = false;
        return null;
    }
    
    //This method is used to close the Comment popup
    public PageReference showPopupPreview() {
        bolShowPopupPreview = true;
        return null;
    }
}