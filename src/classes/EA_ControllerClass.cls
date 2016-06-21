/*
Saved succesfully
Class Name: EA_ControllerClass.cls
Author : Mindtree
Date: 26 oct 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Controller class for Everyday action app.
*/
public with sharing class EA_ControllerClass {
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
        return lstRecordtype;         
    }
    
    /*******************************************************************************************************
* @description This method returns All activities.
* @param  
* @return list of Everyday_Activity__c. 
*/ 
   @AuraEnabled
    Public static List<EA_Wrapper_Class.EA_RecentlyCompletedUsers> getActivities(){
    
        //List<Everyday_Activity__c> activityList = new List<Everyday_Activity__c>();
        //activityList = [SELECT Id,Name, RecordType.Name, Rating__c, Description__c,Minutes_to_Complete_Action__c,Top_Tip__c,Participants_Required__c,Activity_Points__c FROM Everyday_Activity__c Where  Active__c =true ORDER BY Rating__c desc Nulls last];      
        List<Everyday_Activity__c> lstAcivity = new List<Everyday_Activity__c>(); 
          
        lstAcivity = [SELECT Id,Name, Rating__c, Participants_Required__c,Minutes_to_Complete_Action__c,Top_Tip__c, RecordType.Name,Description__c,Activity_Points__c  FROM Everyday_Activity__c where  Active__c=true order by Rating__c desc Nulls last];   
       
       List<EA_Team_Member__c> teamList=[Select Id,Everyday_Activity__c,Everyday_Activity__r.Name, Everyday_Activity__r.RecordType.Name , Everyday_Activity__r.Rating__c,
                                          Everyday_Activity__r.Description__c, Everyday_Activity__r.Minutes_to_Complete_Action__c, Activity_Due_Date__c,
                                          Everyday_Activity__r.Top_Tip__c, Everyday_Activity__r.Participants_Required__c, Everyday_Activity__r.Activity_Points__c , 
                                          Participant__c,Participant__r.Name, Participant_small_photourl__c 
                                          FROM EA_Team_Member__c WHERE Activity_Due_Date__c <=: system.now() order by createdDate Desc ];
                                          
        Map<Id,Set<string>> recentuserMap=new Map<Id,Set<string>>();
       
        for(Everyday_Activity__c act:lstAcivity){
         Set<string> photourlsSet=new Set<string>();
          for(EA_Team_Member__c item:teamList){
          
            if(act.Id == item.Everyday_Activity__c && photourlsSet.size()<6)
            {
              photourlsSet.add(item.Participant_small_photourl__c);
            
            }
           
          }
          
          recentuserMap.put(act.Id,photourlsSet);
            
            
        }
   
        
        //List<string> photourlList=recentuserMap.addAll(recentuserMap.values());
        
        List<EA_Wrapper_Class.EA_RecentlyCompletedUsers> distinctmemberList=new List<EA_Wrapper_Class.EA_RecentlyCompletedUsers>();
        
        Set<string> distinctuserSet=new Set<string>();
        
         for(Everyday_Activity__c act:lstAcivity )
         {
           EA_Wrapper_Class.EA_RecentlyCompletedUsers newObj=new EA_Wrapper_Class.EA_RecentlyCompletedUsers();
           newObj.activityId=act.Id;
           newObj.themeName=act.RecordType.Name;
           newObj.activityName=act.Name;
           newObj.activityRating=act.Rating__c;
           newObj.description=act.Description__c;
           newObj.minutestoComplete=act.Minutes_to_Complete_Action__c;
           newObj.peopleRequired=act.Participants_Required__c;
           newObj.activityPoints=act.Activity_Points__c;
           List<string> phtoUrl=new List<string>();
           
            // set<string> strSet=new set<string>();
            // strSet=recentuserMap.get(act.id);
             List<string> photoList=new List<string>(recentuserMap.get(act.id));
             newObj.userPhotoUrl1=photoList;
             system.debug('&&&&'+ newObj.userPhotoUrl1);
             distinctmemberList.add(newObj);
           }
        
        
       // distinctmemberList.addAll(recentuserMap.values());
        
    
        return distinctmemberList;
    
    } 
    
    /*******************************************************************************************************
* @description This method returns Activities belongs to a particular Theme.
* @param  
* @return list  Everyday_Activity__c. 
*/ 
    @AuraEnabled
    Public static List<EA_Wrapper_Class.EA_RecentlyCompletedUsers> getActivitiesonfilter(string themeName){
        List<Everyday_Activity__c> lstAcivity = new List<Everyday_Activity__c>();    
        lstAcivity = [SELECT Name, Rating__c, Participants_Required__c,Minutes_to_Complete_Action__c,Top_Tip__c, RecordType.Name,Description__c,Activity_Points__c  FROM Everyday_Activity__c where RecordType.Name=:themeName AND  Active__c=true order by Rating__c desc Nulls last];   
        
         List<EA_Team_Member__c> teamList=[Select Id,Everyday_Activity__c,Everyday_Activity__r.Name, Everyday_Activity__r.RecordType.Name , Everyday_Activity__r.Rating__c,
                                          Everyday_Activity__r.Description__c, Everyday_Activity__r.Minutes_to_Complete_Action__c, Activity_Due_Date__c,
                                          Everyday_Activity__r.Top_Tip__c, Everyday_Activity__r.Participants_Required__c, Everyday_Activity__r.Activity_Points__c , 
                                          Participant__c,Participant__r.Name, Participant_small_photourl__c 
                                          FROM EA_Team_Member__c WHERE Activity_Due_Date__c <=: system.now() order by createdDate Desc ];
                                          
        Map<Id,Set<string>> recentuserMap=new Map<Id,Set<string>>();
       
        for(Everyday_Activity__c act:lstAcivity){
         Set<string> photourlsSet=new Set<string>();
          for(EA_Team_Member__c item:teamList){
          
            if(act.Id == item.Everyday_Activity__c && photourlsSet.size()<6)
            {
               photourlsSet.add(item.Participant_small_photourl__c);
            }
           
          }
          
          recentuserMap.put(act.Id,photourlsSet);
          
        }
   
        
        List<EA_Wrapper_Class.EA_RecentlyCompletedUsers> distinctmemberList=new List<EA_Wrapper_Class.EA_RecentlyCompletedUsers>();
        
        Set<string> distinctuserSet=new Set<string>();
        
         for(Everyday_Activity__c act:lstAcivity )
         {
           EA_Wrapper_Class.EA_RecentlyCompletedUsers newObj=new EA_Wrapper_Class.EA_RecentlyCompletedUsers();
           newObj.activityId=act.Id;
           newObj.themeName=act.RecordType.Name;
           newObj.activityName=act.Name;
           newObj.activityRating=act.Rating__c;
           newObj.description=act.Description__c;
           newObj.minutestoComplete=act.Minutes_to_Complete_Action__c;
           newObj.peopleRequired=act.Participants_Required__c;
           newObj.activityPoints=act.Activity_Points__c;
           newObj.toptip=act.Top_Tip__c;
           List<string> phtoUrl=new List<string>();
           List<string> photoList=new List<string>(recentuserMap.get(act.id));
           newObj.userPhotoUrl1=photoList;
            
             distinctmemberList.add(newObj);
           }
        
          
        

        
    
        return distinctmemberList;
         
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
        Decimal points = [select Activity_Points__c from Everyday_Activity__c where id =:ActivityID].Activity_Points__c ;
        if(points!=null){
            EA_Team_Member__c newrecord = new EA_Team_Member__c ();
            newrecord.Participant__c = UserInfo.getUserId();
            newrecord.Invited_By__c = UserInfo.getUserId();      
            newrecord.Invitation_Status__c = EA_Constants.INVITATION_STATUS_SELF;
            newrecord.Everyday_Activity__c = ActivityID;
            newrecord.Activity_Points__c=points;
            insert newrecord;
        }
    }   
  
    @AuraEnabled
    public static void insertfeeditem(string ActivityId, string comment){
        FeedItem post = new FeedItem();
        post.ParentId = ActivityId; //Activity ID..
        post.Body = comment;
        insert post;
    }
    @AuraEnabled
    public static void chatterfeeditem(string postbody){
        FeedItem post = new FeedItem();
        post.ParentId =  UserInfo.getUserId(); //Activity ID..
        post.Body = postbody;
        insert post;
    }
    @AuraEnabled
    Public static List<EA_Team_Member__c > getinvitelist(string Activityid){
        List<EA_Team_Member__c > invitelist= new List<EA_Team_Member__c >();
        if(EA_Utils.isEmpty(Activityid)){                    
            invitelist= [SELECT id, Everyday_Activity__c, invitation_Status__c, Invited_By__c, Invited_By__r.smallphotourl,Participant__c,Participant__r.smallphotourl
                         FROM EA_Team_Member__c 
                         WHERE ((Everyday_Activity__c=: Activityid ) AND 
                                (invitation_Status__c =: EA_Constants.INVITATION_STATUS_INVITED) AND (Participant__c=:userinfo.getuserId()))];
        }        
        return invitelist;
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
        List<EA_Wrapper_Class.EA_UserProfile_Wrapper> userprofileList=new List<EA_Wrapper_Class.EA_UserProfile_Wrapper>();
        EA_Wrapper_Class.EA_UserProfile_Wrapper objUser=new  EA_Wrapper_Class.EA_UserProfile_Wrapper();       
        List<AggregateResult> totalpoints_count=[select sum(Activity_Points__c) total from EA_Team_Member__c Where ( Invited_By__c=:userinfo.getuserId() OR Participant__c =:userinfo.getuserId()) AND (invitation_Status__c =:status_accepted OR invitation_Status__c =:status_self) group by id ];               
        objUser.userPhotoUrl=userList[0].smallphotourl;
        objUser.userName=userList[0].name;
        for(AggregateResult ar:totalpoints_count){
            points +=integer.valueof(ar.get('total'));
        } 
        objUser.activity_points=points;
        system.debug('Points Earned-->'+points );
        integer newbee=integer.valueof(EA_BadgeDetails__c.getInstance('Newbee').BadgeValue__c);
        integer bronz=integer.valueof(EA_BadgeDetails__c.getInstance('Bronze').BadgeValue__c);
        integer silver=integer.valueof(EA_BadgeDetails__c.getInstance('Silver').BadgeValue__c);
        integer gold=integer.valueof(EA_BadgeDetails__c.getInstance('Gold').BadgeValue__c);
        if(points == newbee){
            objUser.badgeprogress_color='newbee';
        }
        else  if(points > newbee &&  points < bronz) {
            objUser.badgeprogress_color='newbee1';
        }
        else  if( points == bronz ) {
            objUser.badgeprogress_color='bronz1';
        }
        else  if( points > bronz && points < silver  ) {
            objUser.badgeprogress_color='bronz2';
        }
        else if(points == silver) {
            objUser.badgeprogress_color='silver1'; 
        }
        else if(points > silver  && points < gold) {
            objUser.badgeprogress_color='silver2';
        }
        else if(points >= gold) {
            objUser.badgeprogress_color='gold';
        }
        userprofileList.add(objUser);
                return userprofileList;
                
                
        
    }    
    /* This method returns list of user smallphotoURLs who have recently completed the Activity */
    @AuraEnabled
    public static List<EA_Wrapper_Class.EA_RecentlyCompletedUsers> getuserList(string recentactivityid){      
        List<EA_Wrapper_Class.EA_RecentlyCompletedUsers>  wrapperList= new  List<EA_Wrapper_Class.EA_RecentlyCompletedUsers>();
        if(EA_Utils.isEmpty(recentactivityid)){
            Set<String> photoURLs = new Set<String>();        
            List<EA_Team_Member__c> userList= new List<EA_Team_Member__c>();
            userList = [SELECT id, Everyday_Activity__c, invitation_Status__c, Invited_By__c, Invited_By__r.smallphotourl,Participant__c,Participant__r.smallphotourl
                        FROM EA_Team_Member__c 
                        WHERE ((Everyday_Activity__c=: recentactivityid) AND 
                               (invitation_Status__c =: EA_Constants.INVITATION_STATUS_ACCEPTED OR invitation_Status__c =: EA_Constants.INVITATION_STATUS_SELF)
                              ) 
                        ORDER BY CreatedDate Desc Limit 6];
            for (EA_Team_Member__c  u: userList) {
                if(u.Participant__c != null) {
                    photoURLs.add(u.Participant__r.smallphotourl);                   
                }
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
    public static List<Id> getbooleanvalue(){
        string status_accepted=EA_Constants.INVITATION_STATUS_ACCEPTED;
        string status_self=EA_Constants.INVITATION_STATUS_SELF;
        //LIST<EA_Team_Member__c> team = [Select  Everyday_Activity__r.RecordTypeId,Everyday_Activity__r.Rating__c, Everyday_Activity__r.Name, Everyday_Activity__c,CreatedDate From EA_Team_Member__c  Where(Invited_By__c=:userinfo.getuserId() OR Participant__c =:userinfo.getuserId()) AND (invitation_Status__c =:status_accepted OR invitation_Status__c =:status_self) AND Everyday_Activity__c = :actID ];        
         LIST<EA_Team_Member__c> team = [Select  Everyday_Activity__r.RecordTypeId,Everyday_Activity__r.Rating__c, Everyday_Activity__r.Name, Everyday_Activity__c,CreatedDate From EA_Team_Member__c  Where(Invited_By__c=:userinfo.getuserId() OR Participant__c =:userinfo.getuserId()) AND (invitation_Status__c =:status_accepted OR invitation_Status__c =:status_self) ];        
        Map<string ,boolean> memberMap=new Map<string,boolean>();
        List<Id> idList=new List<Id>();
        for(EA_Team_Member__c member:team )
        {
          idList.add(Id.valueOf( member.Everyday_Activity__c));
           
        
        }              
        return idList;       
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
        List<EA_Team_Member__c> memberList=[Select id,Activity_Due_Date__c, Everyday_Activity__r.RecordTypeId, Everyday_Activity__r.Name, Everyday_Activity__c, Everyday_Activity__r.Active__c,CreatedDate,Rating_By_Participant__c,invitation_Status__c  From EA_Team_Member__c  Where ( Participant__c =:userinfo.getuserId()) AND (invitation_Status__c =:EA_Constants.INVITATION_STATUS_ACCEPTED OR invitation_Status__c =:EA_Constants.INVITATION_STATUS_SELF OR invitation_Status__c =:EA_Constants.INVITATION_STATUS_INVITED ) order by CreatedDate Desc ];      
        if(memberList != null){           
            //SOQL query inside for loop - Fix
            Map<id ,String> tmIdToEANameMap = new Map<id ,String>();                
            Map<id ,String> eaIdToThemeNameMap = new Map<id ,String>();               
            Set<ID> eaIds = new Set<ID>();
            List<Everyday_Activity__c> eaList = new List<Everyday_Activity__c>();              
                           
                for(EA_Team_Member__c teamObj : memberList){                      
                    tmIdToEANameMap.put(teamObj.id,teamObj.Everyday_Activity__r.Name);
                    eaIds.add(teamObj.Everyday_Activity__c);
                }                   
                if(eaIds != null){                        
                    eaList=[select id, RecordType.Name,Name from Everyday_Activity__c where Id IN: eaIds];                       
                    if(eaList != null){                          
                        for(Everyday_Activity__c ea : eaList){                                
                            eaIdToThemeNameMap.put(ea.id,ea.RecordType.Name);
                        }
                    }
                }
                          
            //SOQL query inside for loop - Fix
            Map<string,EA_Team_Member__c> memberMap=new Map<string,EA_Team_Member__c>();
            List<EA_Team_Member__c> activityList=new List<EA_Team_Member__c>();
        
             for(EA_Team_Member__c item:memberList){
                if(item.Everyday_Activity__c != NULL && (!memberMap.containsKey(item.Everyday_Activity__r.Name+'Self')) ){ 
                                     
                    memberMap.put(item.Everyday_Activity__r.Name+'Self',item);
              }
            }
            activityList.addAll(memberMap.values()); 
          
             for(integer i=0;i<memberList.size();i++){
                if(memberList[i].Invitation_Status__c == EA_Constants.INVITATION_STATUS_INVITED &&  System.today() > memberList[i].Activity_Due_Date__c) {
                    memberList.remove(i);
                    
                }
            } 
           
            
                      
            for(EA_Team_Member__c item:memberList){
                EA_Wrapper_Class.EA_UserProfile_Wrapper objWrapper=new EA_Wrapper_Class.EA_UserProfile_Wrapper();               
                DateTime tomorrow=(item.Activity_Due_Date__c).addDays(1);
                objWrapper.activity_name= tmIdToEANameMap.get(item.id);
                objWrapper.theme_name= eaIdToThemeNameMap.get(item.Everyday_Activity__c);
                objWrapper.acivityId=item.Everyday_Activity__c;
                objWrapper.member_Id=item.id;
                objWrapper.participant_rating=item.Rating_By_Participant__c ;
                objWrapper.invitation_status=item.Invitation_Status__c ;
                //objWrapper.Activity_Due_Date=item.Activity_Due_Date__c;
                objWrapper.Activity_Due_Date=tomorrow; 
                objWrapper.isActive=item.Everyday_Activity__r.Active__c;             
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
    
    /* @description This method returns   no of activities for current user.
* @param  
* @return list of wrapper class. 
*/  
    @AuraEnabled
    public static List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper> getcommentDetail(String ActivityID){         
        ID actID = Id.valueOf(ActivityID);        
        List<Everyday_Activity__Feed> feedList=[SELECT id, Body,CreatedById,CreatedDate,InsertedById,ParentId,RelatedRecordId FROM Everyday_Activity__Feed WHERE ParentId =:actID Limit 5];       
        List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper> wrapperList=new List<EA_Wrapper_Class.EA_FeaturedContent_Wrapper>();         
        Set<ID> userIds = new Set<ID>();
        Map<ID,String> idToUSerNameMap = new Map<ID,String>();
        Map<ID,String> idToUSerPhotoURLMap = new Map<ID,String>();       
        if(feedList != null && feedList.size()>0){           
            for(Everyday_Activity__Feed fiObj : feedList){               
                userIds.add(fiObj.InsertedById);
            }           
            if(userIds != null && userIds.size()>0){               
                List<User> users = [SELECT id, Name, smallphotourl FROM User WHERE id IN : userIds];                
                if(users != null && users.size()>0){                    
                    for(User u: users){                       
                        idToUSerNameMap.put(u.id , u.name);
                        idToUSerPhotoURLMap.put(u.id , u.smallphotourl);
                    }
                }
            }           
            for(Everyday_Activity__Feed feedObj :feedList){
                EA_Wrapper_Class.EA_FeaturedContent_Wrapper objwrapper=new EA_Wrapper_Class.EA_FeaturedContent_Wrapper();
                objwrapper.description=feedObj.Body;               
                objwrapper.userName= idToUSerNameMap.get(feedObj.InsertedById);
                objwrapper.uerPhotoUrl=idToUSerPhotoURLMap.get(feedObj.InsertedById);     
                decimal Hours = decimal.valueOf((System.now().getTime()-datetime.valueof(feedObj.CreatedDate).getTime())/(1000*60*60));
                decimal decMinutes = ((System.now().getTime())/1000/60) - ((datetime.valueof(feedObj.CreatedDate).getTime())/1000/60);
                String strTimeFormat='';
                if(Hours>=48) {
                    strTimeFormat='on '+datetime.valueof(feedObj.CreatedDate).format('dd-MMM-yyyy');//+' at '+i.CreatedDate.format('h:mm a');
                }
                else if (Hours>=24 && Hours<48)  {
                    strTimeFormat='yesterday';
                }
                else if(((Hours>1 ||decMinutes>59)&& Hours!=1) && Hours<24 && System.now() == feedObj.CreatedDate ) {
                    strTimeFormat=Hours+' hours ago';
                }
                else if(((Hours>1 ||decMinutes>59)&& Hours!=1) && Hours<24 && System.now() != feedObj.CreatedDate ) {
                    string  day=String.valueOf(feedObj.CreatedDate.day());
                    string  month=feedObj.CreatedDate.format('MMMM');
                    string  year=String.valueOf(feedObj.CreatedDate.year());
                    strTimeFormat=day+' '+month.substring(0,3)+' '+year;
                }
                else if((Hours==1 ||decMinutes>59) && Hours<24) {
                    strTimeFormat=Hours+' hour ago';
                }
                else if(Hours<1 && decMinutes<=59 && decMinutes>1) {
                    strTimeFormat=decMinutes+' mins ago';
                }
                else if(Hours<1 && decMinutes==1) {
                    strTimeFormat=decMinutes+' min ago';
                }
                else if(decMinutes<1) {
                    strTimeFormat='just now';
                }
                objwrapper.createdDate=strTimeFormat;           
                wrapperList.add(objwrapper);      
            }
        } 
        return wrapperList; 
    }
    @AuraEnabled
    public static List<SelectOption> getToDoTimeline(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  EA_Team_Member__c.Activity_Due_Day__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();       
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }    
    public class SelectOption{
        @AuraEnabled public String Label {get; set;}
        @AuraEnabled public String Value {get; set;}       
        public SelectOption(String optionLabel, String optionValue){
            this.Label = optionLabel;
            this.Value = optionValue;
        }      
    } 
    @AuraEnabled
    public static string callSubmitToDoAction(String activityId, String json, String activityTime) {
        try {           
            List<String> lstUser= new List<String>();
            Object[] values = (Object[])System.JSON.deserializeUntyped(json);
            if(values.size()>0){         
                for (Object id : values) {
                    lstUser.add(string.valueof(id) );
                }
            } 
                                         
            List<Everyday_Activity__c> acts = getactivitydetail(activityId);
            String actvityName = acts[0].Name;
            Decimal points = acts[0].Activity_Points__c;           
            Date activityDate = Date.today();
            if(activityTime=='Today'){      
                activityDate = Date.today();
            }else if(activityTime== 'Tomorrow'){
                DateTime dT=Date.today().addDays(1);
                activityDate = Date.newinstance(dT.year(), dT.month(), dT.day()); 
            }else if(activityTime== 'Next Week' ){
                DateTime dT= Date.today().addDays(7);
                activityDate = Date.newinstance(dT.year(), dT.month(), dT.day());
            }else if(activityTime== 'Two Weeks' ){
                DateTime dT=Date.today().addDays(14);
                activityDate =Date.newinstance(dT.year(), dT.month(), dT.day()); 
            }else if(activityTime == 'One Month'){
                DateTime dT= Date.today().addDays(30);
                activityDate =Date.newinstance(dT.year(), dT.month(), dT.day());
            }            
            // Create team member record for current user
            User objUser=[select smallphotourl,id from User where id=:userinfo.getuserid()];
            
            EA_Team_Member__c newrecord = new EA_Team_Member__c();
            newrecord.Participant__c = UserInfo.getUserId();
            newrecord.Invited_By__c = UserInfo.getUserId();   
            newrecord.Invitation_Status__c = EA_Constants.INVITATION_STATUS_SELF;
            newrecord.Everyday_Activity__c = activityId;
            newrecord.Activity_Due_Day__c = activityTime;
            newrecord.Activity_Points__c= points;
            newrecord.Activity_Due_Date__c= activityDate;
            newrecord.Participant_small_photourl__c=objUser.smallphotourl;
            insert newrecord;
            
            List<EA_Team_Member__c> memberList = new List<EA_Team_Member__c>();
            Map<ID, string> usersMap = new Map<ID, string>();
            
            List<User> users=[select smallphotourl,id from User where id IN: lstUser];
             
            for(User uObj : users){
            
                usersMap.put(uObj.id,uObj.smallphotourl);
            }
                      
            for (User uObj : users) {
                EA_Team_Member__c m   = new EA_Team_Member__c();                
                m.Participant__c   = uObj.id;
                system.debug('First userid-->'+uObj.id);
                m.Invited_By__c  = UserInfo.getUserId();
                m.Invitation_Status__c = EA_Constants.INVITATION_STATUS_INVITED;
                m.Everyday_Activity__c = activityId;
                m.Activity_Due_Day__c = activityTime;
                m.Activity_Points__c= points;
                m.Activity_Due_Date__c= activityDate;
               // User objUser1=[select smallphotourl,id from User where id=:uObj.id];
                string participantUserRec =usersMap.get(uObj.id);
                system.debug('!!!'+participantUserRec );
                m.Participant_small_photourl__c=participantUserRec ;
                memberList.add(m);
            }
            insert memberList;            
            
               
            String dateMsgStr = string.valueOf(activityDate);               
            dateMsgStr = dateMsgStr.substring(0,10);               
            dateMsgStr = getProperDate(dateMsgStr);               
               
            String msgLabel = UserInfo.getName() + ' has invited you to do "'+ actvityName +'"'+ ' activity together on '+dateMsgStr+'. Please respond to the request from Everyday Actions on Salesforce1 app.'+ ' ' + Label.EA_ShareEmail6;
              
            //Need to work on removing for loop
            if(lstUser.size() > 0 && lstUser != null){                   
                for(String userID : lstUser){                                      
                    
                    EA_Utils.postOnChatter(userID, msgLabel);
                }
            }   
                   
            
            return activityId;           
            // This doesn't execute since insert causes an exception
            System.debug('Statement after insert.');
        } catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return activityId;
    }   
    /*public static string getParticipantName(List<User> uList){
        String uName = '';
        for (User u : uList) {
            uName += '@'+u.Name+',';
        }       
        return uName; 
    } */  
    //param : 2015-12-05
    //Return : 05-Dec-2015
    public static string getProperDate(String expectedStr){    
        String finalStr = '';        
        if(String.isNotEmpty(expectedStr)){           
            Map<String,String> monthToMonth = new Map<String,String>();        
            monthToMonth.put('01', 'Jan');
            monthToMonth.put('02', 'Feb');
            monthToMonth.put('03', 'Mar');
            monthToMonth.put('04', 'Apr');
            monthToMonth.put('05', 'May');
            monthToMonth.put('06', 'Jun');
            monthToMonth.put('07', 'Jul');
            monthToMonth.put('08', 'Aug');
            monthToMonth.put('09', 'Sep');
            monthToMonth.put('10', 'Oct');
            monthToMonth.put('11', 'Nov');
            monthToMonth.put('12', 'Dec');           
            String dateForm = expectedStr.trim();            
            String dateStr = dateForm.substring(8,10);      
            String monthStr = dateForm.substring(5,7);                      
            monthStr = monthToMonth.get(monthStr);            
            String yearStr = dateForm.substring(0,4);           
            finalStr = dateStr+'-'+monthStr+'-'+yearStr;
        }        
        return finalStr;  
    }      
    @AuraEnabled
    Public static Integer getActivityParticipantCount(string Activityid){
        if(Activityid!= null){        
            AggregateResult results = [SELECT count(id) total FROM EA_Team_Member__c WHERE ((Invited_By__c=:userinfo.getUserId()) AND (Everyday_Activity__c =: Activityid ) AND (invitation_Status__c =: EA_Constants.INVITATION_STATUS_SELF OR invitation_Status__c =: EA_Constants.INVITATION_STATUS_ACCEPTED ))];
            return (Integer) results.get('total');
        }
        return 0;
    } 
    @AuraEnabled
    public static string getGAID(){      
        string strgaid = EA_ReportingGA__c.getinstance('GA_Id').Text_value__c;
        return strgaid;      
    }
}