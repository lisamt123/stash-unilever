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
			public string commentuserName;
			
			@AuraEnabled
			public string commentuserPhotoUrl;
			
			@AuraEnabled
			public string commentdescription;
			
			@AuraEnabled
			public string commentcreatedDate;
			
		}
		public class EA_UserProfile_Wrapper {
			
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
		}
		
		public class EA_RecentlyCompletedUsers{
			
			@AuraEnabled
			public string userPhotoUrl;
		}

}