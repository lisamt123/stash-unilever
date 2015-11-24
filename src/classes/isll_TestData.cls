/**
*
* Author:       Carmine Barbuto
* Date:         07/03/2014
* Description:  ISLL Project - Utility Class for Test Data.
* Version:      1.0
*
* --------------------------
* Copyright © 2014  Unilever
* --------------------------
**/
@isTest
public class isll_TestData {
    
    //******************* CONSTANT VALUES
    
    public static String CHATTER_GROUP          = 'ISLL Chatter Group';
    public static String FILE_INDICATOR         = 'New File Indicator';
    public static String ISLL_NAME              = 'Internal Sustainable Living Lab';
    public static String PARAM_CONTENTVERSIONID = 'contentVersionID';
    public static String PARAM_LIBRARYPAGESIZE  = 'fullLibrariesPageSize';
    public static String PARAM_OFFSETMAX        = 'offsetMaxLimit';         

    //******************* CMS Article

    public static CMS_Article__c createCMSArticle() {
        CMS_Article__c art  = new CMS_Article__c();
        art.Name            = 'Test Article';
        art.Title__c        = 'Test Title';
        art.Body__c         = 'Test Body';
        
        return art;
    }
    
    public static CMS_Page_Article__c createCMSPageArticle(String pageName, Id articleId) {
        CMS_Page_Article__c pge     = new CMS_Page_Article__c();
        pge.Page_Name__c            = pageName;
        pge.CMS_Article__c          = articleId;
        pge.Order__c                = 0;
        
        return pge;
    }

    public static CMS_Content__c createCMSContent(String cType) {
        CMS_Content__c cnt  = new CMS_Content__c();
        cnt.Name            = 'Content';
        cnt.Content__c      = 'Test Content';
        cnt.Type__c         = cType;

        return cnt;
    }

    public static CMS_Article_Link__c createCMSArticleLink(Id articleId, Id contentId) {
        CMS_Article_Link__c alk = new CMS_Article_Link__c();
        alk.CMS_Article__c      = articleId;
        alk.CMS_Link__c         = contentId;

        return alk;
    }

    //******************* EVENT

    public static Event__c createEvent() {
        Event__c evt                = createEvent(Datetime.now(), Datetime.now());

        return evt;
    }
    public static Event__c createEvent(DateTime startDate, DateTime endDate) {
        Event__c evt                = new Event__c();
        evt.Name                    = 'Test Event';
        evt.Event_Description__c    = 'Test Description';
        evt.Start_Date_Time__c      = startDate;
        evt.End_Date_Time__c        = endDate;

        // Create a group with random name - errors were caused for a group name that is used in repeated tests.
        CollaborationGroup testGroup = createChatterGroup(
            (string.valueOf(system.now()) + Math.random()).left(40)
        );
        insert testGroup;

        evt.Chatter_Group_Name__c   = testGroup.Id;

        return evt;
    }

    public static Event_Member__c createEventMember(Id userId, Id eventId, String memberName) {
        Event_Member__c evm = new Event_Member__c();
        evm.Name            = memberName;  
        evm.User__c         = userId; 
        evm.Event__c        = eventId;

        return evm;
    }

    //******************* CAROUSEL

    public static Carousel__c createCarousel(String name) {
        Carousel__c crs = new Carousel__c();
        crs.Name        = name;

        return crs;
    }

    public static CMS_ContentToCarousel__c createCMSContentCarousel(Id contentId, Id carouselId) {
        CMS_ContentToCarousel__c ctc    = new CMS_ContentToCarousel__c();
        ctc.Carousel__c                 = carouselId;
        ctc.CMS_Content__c              = contentId;

        return ctc;
    }

    //******************* BRAND

    public static Brand_USLP_Progress__c createBrandProgress(String name, Decimal orderNumber) {
        Brand_USLP_Progress__c bup  = new Brand_USLP_Progress__c();
        bup.Name                    = name;
        bup.Order_Number__c         = orderNumber;

        return bup;
    }

    //******************* CUSTOM SETTINGS

    public static isllBrainResultsSettings__c createBrainResultSetting(String name, Integer value) {
        isllBrainResultsSettings__c brs = new isllBrainResultsSettings__c();
        brs.Name                        = name;
        brs.NumericValue__c             = value;

        return brs;
    }

    public static ISLL_Custom_Settings__c createISLLCustomSetting(String name) {
        ISLL_Custom_Settings__c stg = new ISLL_Custom_Settings__c();
        stg.Name                    = name;
        
        return stg;
    }

    //******************* CHATTER

    public static Chatter_History__c createChatterHistory() {
        Chatter_History__c cht      = new Chatter_History__c();
        cht.Feed_Contents__c        = 'Content'; 
        cht.Feed_Owner__c           = System.Userinfo.getUserId();
        cht.Deleting_Moderator__c   = System.Userinfo.getUserId();

        return cht;
    }

    public static CollaborationGroup createChatterGroup(String groupName) {
        CollaborationGroup cgr  = new CollaborationGroup();
        cgr.Name                = groupName;   
        cgr.CollaborationType   = 'Public';  

        return cgr; 
    }

    public static CollaborationGroupMember createCollaborationGroupMember(Id memberId, Id groupId) {
        CollaborationGroupMember cgm    = new CollaborationGroupMember();
        cgm.Memberid                    = memberId;
        cgm.CollaborationGroupId        = groupId;

        return cgm;
    }

    public static FeedItem createFeedItem(Id groupId, String body) {
        FeedItem fdi    = new FeedItem();
        fdi.ParentId    = groupId;
        fdi.Type        = 'TextPost';
        fdi.Body        = body;

        return fdi;
    }

    public static FeedComment createFeedComment(Id feedId) {
        FeedComment fdc = new FeedComment();
        fdc.CommentBody = 'Test Comment';
        fdc.FeedItemId  = feedId;
        
        return fdc;
    }

    //******************* DOCUMENTS

    public static ContentVersion createContentVersion() {
        ContentVersion cnv  = createContentVersion('Test File');

        return cnv;
    }
    public static ContentVersion createContentVersion(String title) {
        ContentVersion cnv  = new ContentVersion();
        cnv.VersionData     = Blob.valueof(title);
        cnv.Title           = title;
        cnv.PathOnClient    = 'filePath';
        
        return cnv;
    }

    public static Attachment createAttachment(Id parentId) {
        Attachment att  = new Attachment();
        att.OwnerId     = UserInfo.getUserId();
        att.ParentId    = parentId;
        att.Name        = 'Attachment Test';
        att.Body        =  Blob.valueOf('Attachment Body');

        return att;
    }

    //******************* USER

    public static User createUser(Id profileId) {
        User usr                        = new User();
        usr.Username                    = 'name.name@company.com' + Datetime.now().millisecond();
        usr.Email                       = 'name.name@company.com';
        usr.Lastname                    = 'LastName';
        usr.Firstname                   = 'FirstName';
        usr.Alias                       = 'test';
        usr.CommunityNickname           = 'nickname';
        usr.ProfileId                   = profileId;
        usr.TimeZoneSidKey              = 'GMT';
        usr.LocaleSidKey                = 'en_US';
        usr.EmailEncodingKey            = 'ISO-8859-1';
        usr.LanguageLocaleKey           = 'en_US';
        usr.UserPermissionsMobileUser   = false;

        return usr;
    }

    public static List<User> createBulkUser(Id profileId, Integer maxNumber) {
        List<User> userList = new List<User>();
        for(integer i = 0; i < maxNumber; i++){ 
            User usr                        = new User();
            usr.Username                    = 'name.name@company.com' + Datetime.now().millisecond() + i;
            usr.Email                       = 'name.name@company.com' + i;
            usr.Lastname                    = 'LastName' + i;
            usr.Firstname                   = 'FirstName' + i;
            usr.Alias                       = 'test' + i;
            usr.CommunityNickname           = 'nickname' + i;
            usr.ProfileId                   = profileId;
            usr.TimeZoneSidKey              = 'GMT';
            usr.LocaleSidKey                = 'en_US';
            usr.EmailEncodingKey            = 'ISO-8859-1';
            usr.LanguageLocaleKey           = 'en_US';
            usr.UserPermissionsMobileUser   = false;
            userList.add(usr);
        }

        return userList;
    }


}