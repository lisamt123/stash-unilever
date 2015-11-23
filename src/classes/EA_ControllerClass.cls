/*
Class Name: EA_ControllerClass.cls
Author : Mindtree
Date: 26 oct 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Controller class for Everyday action app.
*/
public class EA_ControllerClass {
    /*******************************************************************************************************
* @description This method returns record type name of sobject Everyday_Activity__c.
* @param  
* @return list of RecordType name. 
*/ 
    @AuraEnabled
    Public static List<RecordType> getThemes(){
        List<RecordType> lstRecordtype = new List<RecordType>();
        string objNamee=EA_Constants.SOBJECT_NAME;
        lstRecordtype= [SELECT RecordType.Name FROM RecordType WHERE IsActive= true AND SObjectType=:objNamee order by RecordType.Name Asc];
        boolean  result=EA_Utils.isEmpty(lstRecordtype);
        if(result !=true)
        {
            return lstRecordtype;
        }
        return null;         
    }
    
    /*******************************************************************************************************
* @description This method returns All activities.
* @param  
* @return list of Everyday_Activity__c. 
*/ 
    @AuraEnabled
    Public static List<Everyday_Activity__c> getActivities(){
        List<Everyday_Activity__c> activityList = new List<Everyday_Activity__c>();
        activityList = [SELECT Id,Name, RecordType.Name, Rating__c, Description__c,Minutes_to_Complete_Action__c,Top_Tip__c,Participants_Required__c,Activity_Points__c FROM Everyday_Activity__c Where  Active__c =true ORDER BY Rating__c desc];
        boolean result=EA_Utils.isEmpty(activityList );
        if(result !=true){
            return activityList ;
        }
        return null;
    } 
    
    /*******************************************************************************************************
* @description This method returns Activities belongs to a particular Theme.
* @param  
* @return list  Everyday_Activity__c. 
*/ 
    @AuraEnabled
    Public static List<Everyday_Activity__c> getActivitiesonfilter(string themeName){
        List<Everyday_Activity__c> lstAcivity = new List<Everyday_Activity__c>();
        boolean result=EA_Utils.isEmpty(themeName);
        if(result !=true)
        {
            lstAcivity = [SELECT Name, Rating__c, Participants_Required__c,Minutes_to_Complete_Action__c,Top_Tip__c, RecordType.Name,Description__c,Activity_Points__c  FROM Everyday_Activity__c where RecordType.Name=:themeName AND  Active__c=true order by Rating__c desc];
        }
        boolean listresult=EA_Utils.isEmpty(lstAcivity );
        if(listresult !=true)
        {
            return lstAcivity ;
        }
        return null;
    }
    @AuraEnabled
    public static List<Everyday_Activity__c> getactivitydetail(String ActivityID){
        List<Everyday_Activity__c> actvList = new List<Everyday_Activity__c>();
        if(ActivityID!=null){
            actvList = [SELECT Id,Name, RecordType.Name, Rating__c,Top_Tip__c, Description__c,Activity_Points__c,(SELECT Activity_Points__c,Everyday_Activity__c,Participant__c FROM Team_Members__r), Minutes_to_Complete_Action__c,Participants_Required__c FROM Everyday_Activity__c Where  Active__c =true AND id =: ActivityID ];
        }
        return actvList;
    } 
    @AuraEnabled
    public static void insertteamrecord(string ActivityID){
    system.debug('========='+ ActivityID);
        EA_Team_Member__c newrecord = new EA_Team_Member__c ();
        newrecord.Participant__c = UserInfo.getUserId();
        newrecord.Invited_By__c = UserInfo.getUserId();      
        newrecord.Invitation_Status__c = EA_Constants.INVITATION_STATUS_SELF;
        newrecord.Everyday_Activity__c = ActivityID;
        newrecord.Activity_Points__c=5;
        insert newrecord;
    }
    
    /*******************************************************************************************************
* @description This method returns featured content detail of a particular  Activity
* @param  recordID
* @return List of EA_Wrapper_Class.EA_FeaturedContent_Wrapper
*/
    /* @AuraEnabled
    public static List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper> getcontentdetail(String ActivityID){
        Map<string,aa_agent_app_custom_setting__c> objURL = aa_agent_app_custom_setting__c.getAll(); 
        String urlHost =  objURL.get('Salesforce Instance URL Content').Value__c; 
        String sfcURLContent =  objURL.get('SFC Content').Value__c; 
         string docurl;
        string description;
        List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper>  wrapperList=new  List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper>();
        List<Everyday_Activity__c> activityList=[Select Id, CreatedDate, CreatedBy.SmallPhotoUrl, CreatedBy.Name, CreatedById, (Select Id, ParentId, Body, RelatedRecordId From Feeds limit 1) From Everyday_Activity__c Where Active__c =true AND id =: ActivityID ];
        /* Feedcomment objFeed=new Feedcomment();
objFeed=[Select InsertedBy.SmallPhotoUrl, InsertedBy.Name, InsertedById, Id, FeedItemId, CreatedDate, CommentBody From FeedComment ];*/
     /*   for(Everyday_Activity__c activity : activityList){
            EA_Wrapper_Class.EA_FeaturedContent_Wrapper  newObj=new EA_Wrapper_Class.EA_FeaturedContent_Wrapper();
            newObj.userName=activity.CreatedBy.Name;
            newObj.uerPhotoUrl=activity.CreatedBy.SmallPhotoUrl;
            decimal Hours = decimal.valueOf((System.now().getTime()-datetime.valueof(activity.CreatedDate).getTime())/(1000*60*60));
            decimal decMinutes = ((System.now().getTime())/1000/60) - ((datetime.valueof(activity.CreatedDate).getTime())/1000/60);
            String strTimeFormat='';
            if(Hours>=48) strTimeFormat='on '+datetime.valueof(activity.CreatedDate).format('dd-MMM-yyyy');//+' at '+i.CreatedDate.format('h:mm a');
            else if(Hours>=24 && Hours<48) strTimeFormat='yesterday';
            else if(((Hours>1 ||decMinutes>59)&& Hours!=1) && Hours<24 && System.now() == activity.CreatedDate ) strTimeFormat=Hours+' hours ago';
            else if(((Hours>1 ||decMinutes>59)&& Hours!=1) && Hours<24 && System.now() != activity.CreatedDate ) {
                string  day=String.valueOf(activity.CreatedDate.day());
                string  month=activity.CreatedDate.format('MMMM');
                string  year=String.valueOf(activity.CreatedDate.year());
                strTimeFormat=day+' '+month.substring(0,3)+' '+year;
            }
            else if((Hours==1 ||decMinutes>59) && Hours<24) strTimeFormat=Hours+' hour ago';
            else if(Hours<1 && decMinutes<=59 && decMinutes>1) strTimeFormat=decMinutes+' mins ago';
            else if(Hours<1 && decMinutes==1) strTimeFormat=decMinutes+' min ago';
            else if(decMinutes<1) strTimeFormat='just now';
            newObj.createdDate=strTimeFormat;
            for(Everyday_Activity__Feed feed:activity.Feeds){
                newObj.description=feed.Body;
                string str=urlHost+sfcURLContent+feed.RelatedRecordId;
                newObj.documentUrl=str;         
            }   
            wrapperList.add(newObj);
        }
        return wrapperList;
    }*/
    @AuraEnabled
    public static void insertfeeditem(string ActivityId, string comment){
        FeedItem post = new FeedItem();
        post.ParentId = ActivityId; //Activity ID..
        post.Body = comment;
        insert post;
    }
    @AuraEnabled
    public static void chatterfeeditem(){
        FeedItem post = new FeedItem();
        post.ParentId =  UserInfo.getUserId(); //Activity ID..
        post.Body = 'commented';
        insert post;
    }
   /*******************************************************************************************************
* @description This method returns  current user information profile picture,No of points earned,badge he got
* @param  
* @return list of wrapper class. 
*/
   @AuraEnabled
    public static List<EA_Wrapper_Class.EA_UserProfile_Wrapper> getUserDetail(){
        List<User> userList=[select name,smallphotourl from User where id=:userinfo.getuserId() and isactive=true];
        integer points=0;
        string status_accepted=EA_Constants.INVITATION_STATUS_ACCEPTED;
        string status_self=EA_Constants.INVITATION_STATUS_SELF;
        string badge_newbee=EA_Constants.BADGE_NEWBEE;
        string badge_bronz=EA_Constants.BADGE_BRONZ;
        string badge_silver=EA_Constants.BADGE_SILVER;
        string badge_gold=EA_Constants.BADGE_GOLD;
        List<AggregateResult> totalpoints_count=[select sum(Activity_Points__c) total from EA_Team_Member__c Where ( Invited_By__c=:userinfo.getuserId() OR Participant__c =:userinfo.getuserId()) AND (invitation_Status__c =:status_accepted OR invitation_Status__c =:status_self) group by id ];
        List<EA_Wrapper_Class.EA_UserProfile_Wrapper> userprofileList=new List<EA_Wrapper_Class.EA_UserProfile_Wrapper>();
        EA_Wrapper_Class.EA_UserProfile_Wrapper objUser=new  EA_Wrapper_Class.EA_UserProfile_Wrapper();
        objUser.userPhotoUrl=userList[0].smallphotourl;
        objUser.userName=userList[0].name;
        for(AggregateResult ar:totalpoints_count){
            points +=integer.valueof(ar.get('total'));
        }
        objUser.activity_points=points;
        integer newbee=integer.valueof(EA_BadgeDetails__c.getInstance('Newbee').BadgeValue__c);
        integer bronz=integer.valueof(EA_BadgeDetails__c.getInstance('Bronze').BadgeValue__c);
        integer silver=integer.valueof(EA_BadgeDetails__c.getInstance('Silver').BadgeValue__c);
        integer gold=integer.valueof(EA_BadgeDetails__c.getInstance('Gold').BadgeValue__c);
        if(points == newbee){
            objUser.badgeprogress_color='newbee';
        }
        else  if(points > newbee &&  points < bronz) objUser.badgeprogress_color='newbee1';
        else  if( points == bronz )  objUser.badgeprogress_color='bronz1';
        else  if( points > bronz && points < silver  )  objUser.badgeprogress_color='bronz2';
        else if(points == silver)   objUser.badgeprogress_color='silver1'; 
        else if(points > silver  && points < gold)   objUser.badgeprogress_color='silver2';
        else if(points >= gold) objUser.badgeprogress_color='gold';
        userprofileList.add(objUser);
        return userprofileList;
    }
   
    
    /* This method returns list of user smallphotoURLs who have recently completed the Activity */
    @AuraEnabled
    public static List<EA_Wrapper_Class.EA_RecentlyCompletedUsers> getuserList(string recentactivityid){
       
        List<EA_Wrapper_Class.EA_RecentlyCompletedUsers>  wrapperList= new  List<EA_Wrapper_Class.EA_RecentlyCompletedUsers>();
        if(recentactivityid!= null){
            Set<String> photoURLs = new Set<String>();        
            List<EA_Team_Member__c> userList= new List<EA_Team_Member__c>();
            userList = [SELECT id, Everyday_Activity__c, invitation_Status__c, Invited_By__c, Invited_By__r.smallphotourl,Participant__c,Participant__r.smallphotourl
                        FROM EA_Team_Member__c 
                        WHERE ((Everyday_Activity__c=: recentactivityid) AND 
                               (invitation_Status__c =: EA_Constants.INVITATION_STATUS_ACCEPTED OR invitation_Status__c =: EA_Constants.INVITATION_STATUS_SELF)
                              ) 
                        ORDER BY CreatedDate Desc];
            for (EA_Team_Member__c  u: userList) {
                if(u.Participant__c != null)photoURLs.add(u.Participant__r.smallphotourl);
            }
            Integer limitUsers = 0;
            for(String str: photoURLs){
                if(limitUsers < 5){
                    EA_Wrapper_Class.EA_RecentlyCompletedUsers  newObj=new EA_Wrapper_Class.EA_RecentlyCompletedUsers();            
                    newObj.userPhotoUrl= str; 
                    limitUsers= limitUsers+1; 
                    wrapperList.add(newObj);
                }
            }
        } 
        
        
        return  wrapperList;
    }
    
    @AuraEnabled
    public static boolean getbooleanvalue(string actID){
        string status_accepted=EA_Constants.INVITATION_STATUS_ACCEPTED;
        string status_self=EA_Constants.INVITATION_STATUS_SELF;
        LIST<EA_Team_Member__c> team = [Select  Everyday_Activity__r.RecordTypeId,Everyday_Activity__r.Rating__c, Everyday_Activity__r.Name, Everyday_Activity__c,CreatedDate From EA_Team_Member__c  Where(Invited_By__c=:userinfo.getuserId() OR Participant__c =:userinfo.getuserId()) AND (invitation_Status__c =:status_accepted OR invitation_Status__c =:status_self) AND Everyday_Activity__c = :actID ];
        EA_Wrapper_Class.EA_FeaturedContent_Wrapper  newObj=new EA_Wrapper_Class.EA_FeaturedContent_Wrapper();
        if(team.size() > 0){
            return true;
        }
        else{
            
            return false;
        }
    }
    
    @AuraEnabled
    public static List<EA_Wrapper_Class.EA_UserProfile_Wrapper> getActivityPoints(String ActivityID){
        integer points=0;
        List<AggregateResult> totalpoints_count=[select Everyday_Activity__c , sum(Activity_Points__c) total from EA_Team_Member__c Where ( Everyday_Activity__c =:ActivityID) group by Everyday_Activity__c ];
        List<EA_Wrapper_Class.EA_UserProfile_Wrapper> userprofileList=new List<EA_Wrapper_Class.EA_UserProfile_Wrapper>();
        EA_Wrapper_Class.EA_UserProfile_Wrapper objUser=new  EA_Wrapper_Class.EA_UserProfile_Wrapper();
        for(AggregateResult ar:totalpoints_count){
            points +=integer.valueof(ar.get('total'));
            objUser.activity_points=points;
        }
        userprofileList.add(objUser);
        return userprofileList;
    }
    
    /*******************************************************************************************************
* @description This method returns   no of 
activities for current user.
* @param  
* @return list of wrapper class. 
*/  
    @AuraEnabled
    public static List<EA_Wrapper_Class.EA_UserProfile_Wrapper>  getUserActivities(){
        List<EA_Wrapper_Class.EA_UserProfile_Wrapper> userprofileList=new List<EA_Wrapper_Class.EA_UserProfile_Wrapper>();     
        List<EA_Team_Member__c> memberList=[Select id, Everyday_Activity__r.RecordTypeId, Everyday_Activity__r.Name, Everyday_Activity__c,CreatedDate From EA_Team_Member__c  Where ( Invited_By__c=:userinfo.getuserId() OR Participant__c =:userinfo.getuserId()) AND (invitation_Status__c =:EA_Constants.INVITATION_STATUS_ACCEPTED OR invitation_Status__c =:EA_Constants.INVITATION_STATUS_SELF) order by CreatedDate Desc ];
        if(memberList != null && memberList.size()>0){
            Map<string,EA_Team_Member__c> memberMap=new Map<string,EA_Team_Member__c>();
            List<EA_Team_Member__c> activityList=new List<EA_Team_Member__c>();
            for(EA_Team_Member__c item:memberList){
                if(item.Everyday_Activity__c != NULL){
                    if(!memberMap.containsKey(item.Everyday_Activity__r.Name)){
                        memberMap.put(item.Everyday_Activity__r.Name,item);
                    }
                }
            }
            activityList.addAll(memberMap.values());
            for(EA_Team_Member__c item:activityList)
            {
                EA_Wrapper_Class.EA_UserProfile_Wrapper objWrapper=new EA_Wrapper_Class.EA_UserProfile_Wrapper();
                List<Everyday_Activity__c> recordtypeList=[select id, RecordType.Name,Name from Everyday_Activity__c where Id=:item.Everyday_Activity__c];
                if(recordtypeList.size()>0)
                {
                    objWrapper.activity_name=recordtypeList[0].Name;
                    objWrapper.theme_name=recordtypeList[0].RecordType.Name;
                    objWrapper.acivityId=recordtypeList[0].id;
                }
                userprofileList.add(objWrapper);
            }
        }        
        return userprofileList;
    }    
   
   
    @AuraEnabled
    Public static Map<string,string> getThemeColors(){
        Map<string, EA_ThemesDetails__c> allRecords = EA_ThemesDetails__c.getAll();
        Map<String, String> allThemeRecords = new Map<String, String>();
        for(EA_ThemesDetails__c tcs:allRecords.values()){
            allThemeRecords.put(tcs.Name,tcs.ThemeColorCode__c); 
        }
        return allThemeRecords;   
    }   
    
}