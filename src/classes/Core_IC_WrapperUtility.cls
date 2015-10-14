/*
  Class Name: Core_IC_WrapperUtility
  Author : Mindtree
  Date: 08 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Wrapper class for Ideation App
*/


global with sharing class Core_IC_WrapperUtility {
   
   global class IdeaLandingPageResponse extends Core_CA_BaseApplicationWrapper{
       public Boolean SeeAllLinkForFeaturedCampaigns;
       public String CampaignTypeForFeaturedCampaigns;
       public List<FeaturedCampaigns> FeaturedCampaigns;
       public Boolean SeeAllLinkForIdeasOfTheWeek;
       public String CampaignTypeForIdeasOfTheWeek;
       public List<IdeasOfTheWeek> IdeasOfTheWeek;
       public Boolean SeeAllLinkForMyUpdates;
       public String CampaignTypeForMyUpdates;
       public List<MyUpdates> MyUpdates;
       public Boolean ActiveStatus;
   }
   
   global class IdeaLandingPageRequest{
   	   public String FeaturedCampaignsLimit;
   	   public String IdeasOfTheWeekLimit;
   	   public String MyUpdatesLimit;
   }
   
   global class VoteForIdeasOfTheWeekRequest{
        public String IdeaId;
   }
   
   global class VoteForIdeasOfTheWeekResponse extends Core_CA_BaseApplicationWrapper{
        public Integer VoteCount;
   }
   
   global class IdeaCampaignDetailRequest{
   	   public String IdeaCampaignId;
   	   public String LatestIdeasLimit;
   }
   
   global class IdeaCampaignDetailResponse extends Core_CA_BaseApplicationWrapper{
   	   public FeaturedCampaigns FeaturedCampaigns;
   	   public List<IdeasOfTheWeek> IdeasOfTheWeek;
   	   public Boolean SeeAllLinkForLatestIdeas;
       public String CampaignTypeForLatestIdeas;
   	   public List<LeaderBoard> LeaderBoard;
   	   public String CampaignStatus;
   	   public Boolean ActiveStatus;
   	   public List<String> Categories;
   }
   
   global class IdeaDetailRequest{
   	   public String IdeaId;
   }
   
   global class IdeaDetailResponse extends Core_CA_BaseApplicationWrapper{
   	   public IdeaDetails IdeaDetails;
   	   public List<IdeaComments> IdeaComments;
   	   public String CampaignStatus;
   	   public List<String> Categories;
   }
   
   global class IdeaCommentRequest{
   	   public String IdeaId;
   	   public String CommentBody;
   }
   
   global class IdeaCommentResponse extends Core_CA_BaseApplicationWrapper{
   	   public List<IdeaComments> IdeaComments;
   	   public Integer CommentCount;
   }
   
   global class SubmitIdeaRequest{
   	   public String IdeaCampaignId;
   	   public String IdeaTitle;
   	   public String IdeaDescription;
   	   public List<String> IdeaCategories;
   	   public List<String> Users;
   	   public String AttachmentId;
   	   public String AttachmentBody;
   	   public String AttachmentName;
   	   //public Integer AttachmentLength;
   	   public String AttachmentContentType;
   }
   
   global class SubmitIdeaResponse extends Core_CA_BaseApplicationWrapper{
   	   public Boolean SuccessFlag;
   }
   
   global class FAQResponse extends Core_CA_BaseApplicationWrapper{
   	   public List<FAQ> FAQ; 
   }
   
   /*
   global class CategoryValuesResponse extends Core_CA_BaseApplicationWrapper{
   	   public List<String> Categories;
   }*/
   
   /*global class AttachmentIdRetrievalResponse extends Core_CA_BaseApplicationWrapper{
   	   public String AttachmentId;
   }*/
   
   public class FeaturedCampaigns{
        public String Banner;
        public String EndDate;
        public String CampaignTitle;
        public String Description;
        public Integer IdeaCount;
        public Boolean Promoted;
        public String IdeaThemeId;
        public String StatusType;
        public Integer DaysBetween;
        public List<String> Categories;
   }
   
   public class IdeasOfTheWeek{
        public String BackgroundImage;
        public String CreatorName;
        public String CreatedDateTime;
        public String IdeaTitle;
        public String IdeaBody;
        public String Voted;
        public Integer VoteCount;
        public Integer CommentCount;
        public String IdeaThemeId;
        public String IdeaId;
        public String CampaignStatus;
        public String Categories;
        public Integer DaysBetween;
        public String CampaignTitle;
        public Decimal MinutesBetween;
   }
   
   global class MyUpdates implements Comparable{
        public String BackgroundImage;
        public String CreatorName;
        public String CreatedDateTime;
        public String MyUpdatesType;
        public String IdeaId;
        
		global Integer compareTo(Object objToCompare) {
	        MyUpdates compareToMyUpdates = (MyUpdates)objToCompare;
	        if (CreatedDateTime == compareToMyUpdates.CreatedDateTime) return 0;
	        if (CreatedDateTime < compareToMyUpdates.CreatedDateTime) return 1;
	        return -1;
		}
   }
   
   public class LeaderBoard{
        public String BackgroundImage;
        public String CreatorName;
        public String IdeaId;
        public String IdeaTitle;
        public Integer VoteCount;
   }
   
   public class IdeaDetails{
   		public String BackgroundImage;
        public String CreatorName;
        public String CreatedDateTime;
        public String IdeaTitle;
        public String IdeaBody;
        public String Voted;
        public Integer VoteCount;
        public Integer CommentCount;
        public String IdeaThemeId;
        public String IdeaId;
        public String Categories;
        public String CampaignTitle;
        public String AttachmentURL;
   }
   
   public class IdeaComments{
   		public String BackgroundImage;
        public String CreatorName;
        public String CreatedDateTime;
        public String CommentBody;
   }
   
   public class FAQ{
   		public string Question{get;set;}
		public string Answer{get;set;}
   }
    
}