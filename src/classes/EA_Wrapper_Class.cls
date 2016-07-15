/*
  Class Name: EA_Wrapper_Class
  Author : Mindtree
  Date: 03 NOV 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description:Wrapper class for getting data to display activities .
*/


public class EA_Wrapper_Class {

        public class EA_FeaturedContent_Wrapper {
        
            @AuraEnabled
            public string userName;
            
            @AuraEnabled
            public string uerPhotoUrl;
            
            @AuraEnabled
            public string description;
            
            @AuraEnabled
            public Boolean disabled { get;set; }
            
            @AuraEnabled
            public string documentUrl;
            
            @AuraEnabled
            public string createdDate;
            
             @AuraEnabled
            public string top_tip;
            
           
            
            
         
            
        }
        public class EA_UserProfile_Wrapper {
           
            @AuraEnabled
            public string member_Id;
            
            @AuraEnabled
            public string acivityId;
             
            @AuraEnabled
            public string userPhotoUrl;
            
            @AuraEnabled
            public string userName;
            
            @AuraEnabled
            public integer activity_points;
            
            @AuraEnabled
            public string  badgeprogress_color;
            @AuraEnabled
            public string activity_name;
            
            @AuraEnabled
            public string theme_name;
            @AuraEnabled
            public string Eaname;
            @AuraEnabled
            public string EaRecordtype;
              @AuraEnabled
            public DateTime Activity_Due_Date;
                   
            
            @AuraEnabled
            public decimal participant_rating;
            
            @AuraEnabled
            public string invitation_status;
            
            @AuraEnabled
            public boolean isActive;
            
              
        }
        
        public class EA_RecentlyCompletedUsers{
            
            @AuraEnabled
            public string activityId;
            @AuraEnabled
            public string userPhotoUrl;
            
             @AuraEnabled
            public string themeName;
            
             @AuraEnabled
            public string activityName;
            
             @AuraEnabled
             public decimal activityRating;
            
             @AuraEnabled
             public string description;
             
            
             
               @AuraEnabled
             public decimal minutestoComplete;
             
               @AuraEnabled
             public decimal  peopleRequired;
             
               @AuraEnabled
              public decimal activityPoints;
              
               @AuraEnabled
              public List<string> userPhotoUrl1;
              
               @AuraEnabled
              public string toptip;
        }

}