/*
  Class Name: Core_IC_WrapperUtility
  Author : Mindtree
  Date: 08 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Wrapper class for Ideation App
*/


global with sharing class Core_IC_WrapperUtility {
   
   global class IdeaLandingPageResponse extends Core_CA_BaseApplicationWrapper{
       @AuraEnabled
       public Boolean SeeAllLinkForFeaturedCampaigns;
       @AuraEnabled
       public String CampaignTypeForFeaturedCampaigns;
       @AuraEnabled
       public List<FeaturedCampaigns> FeaturedCampaigns;
       @AuraEnabled
       public Boolean SeeAllLinkForIdeasOfTheWeek;
       @AuraEnabled
       public String CampaignTypeForIdeasOfTheWeek;
       @AuraEnabled
       public List<IdeasOfTheWeek> IdeasOfTheWeek;
       @AuraEnabled
       public Boolean SeeAllLinkForMyUpdates;
       @AuraEnabled
       public String CampaignTypeForMyUpdates;
       @AuraEnabled
       public List<MyUpdates> MyUpdates;
       @AuraEnabled
       public Boolean ActiveStatus;
       @AuraEnabled
       public Integer ShowMoreLimit;
   }
   
   global class IdeaLandingPageRequest{
       @AuraEnabled
       public String FeaturedCampaignsLimit;
       @AuraEnabled
       public String IdeasOfTheWeekLimit;
       @AuraEnabled
       public String MyUpdatesLimit;
   }
   
   global class VoteForIdeasOfTheWeekRequest{
       @AuraEnabled
        public String IdeaId;
   }
   
   global class VoteForIdeasOfTheWeekResponse extends Core_CA_BaseApplicationWrapper{
       @AuraEnabled
        public Integer VoteCount;
   }
   
   global class IdeaCampaignDetailRequest{
       @AuraEnabled
       public String IdeaCampaignId;
       @AuraEnabled
       public String LatestIdeasLimit;
   }
   
   global class IdeaCampaignDetailResponse extends Core_CA_BaseApplicationWrapper{
       @AuraEnabled
       public FeaturedCampaigns FeaturedCampaigns;
       @AuraEnabled
       public List<IdeasOfTheWeek> IdeasOfTheWeek;
       @AuraEnabled
       public Boolean SeeAllLinkForLatestIdeas;
       @AuraEnabled
       public String CampaignTypeForLatestIdeas;
       @AuraEnabled
       public List<LeaderBoard> LeaderBoard;
       @AuraEnabled
       public String CampaignStatus;
       @AuraEnabled
       public Boolean ActiveStatus;
       @AuraEnabled
       public List<String> Categories;
   }
   
   global class IdeaDetailRequest{
       @AuraEnabled
       public String IdeaId;
   }
   
   global class IdeaDetailResponse extends Core_CA_BaseApplicationWrapper{
       @AuraEnabled
       public IdeaDetails IdeaDetails;
       @AuraEnabled
       public List<IdeaComments> IdeaComments;
       @AuraEnabled
       public String CampaignStatus;
       @AuraEnabled
       public List<String> Categories;
   }
   
   global class IdeaCommentRequest{
       @AuraEnabled
       public String IdeaId;
       @AuraEnabled
       public String CommentBody;
   }
   
   global class IdeaCommentResponse extends Core_CA_BaseApplicationWrapper{
       @AuraEnabled
       public List<IdeaComments> IdeaComments;
       @AuraEnabled
       public Integer CommentCount;
   }
   
   global class SubmitIdeaRequest{
       @AuraEnabled
       public String IdeaCampaignId;
       @AuraEnabled
       public String IdeaTitle;
       @AuraEnabled
       public String IdeaDescription;
       @AuraEnabled
       public List<String> IdeaCategories;
       @AuraEnabled
       public List<String> Users;
       @AuraEnabled
       public String AttachmentId;
       @AuraEnabled
       public String AttachmentBody;
       @AuraEnabled
       public String AttachmentName;
       //public Integer AttachmentLength;
       @AuraEnabled
       public String AttachmentContentType;
   }
   
   global class SubmitIdeaResponse extends Core_CA_BaseApplicationWrapper{
       @AuraEnabled
       public Boolean SuccessFlag;
   }
   
   global class FAQResponse extends Core_CA_BaseApplicationWrapper{
       @AuraEnabled
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
        @AuraEnabled
        public String Banner;
        @AuraEnabled
        public String EndDate;
        @AuraEnabled
        public String CampaignTitle;
        @AuraEnabled
        public String Description;
        @AuraEnabled
        public Integer IdeaCount;
        @AuraEnabled
        public Boolean Promoted;
        @AuraEnabled
        public String IdeaThemeId;
        @AuraEnabled
        public String StatusType;
        @AuraEnabled
        public Integer DaysBetween;
        @AuraEnabled
        public List<String> Categories;
   }
   
   public class IdeasOfTheWeek{
        @AuraEnabled
        public String BackgroundImage;
        @AuraEnabled
        public String CreatorName;
        @AuraEnabled
        public String CreatedDateTime;
        @AuraEnabled
        public String IdeaTitle;
        @AuraEnabled
        public String IdeaBody;
        @AuraEnabled
        public String Voted;
        @AuraEnabled
        public Integer VoteCount;
        @AuraEnabled
        public Integer CommentCount;
        @AuraEnabled
        public String IdeaThemeId;
        @AuraEnabled
        public String IdeaId;
        @AuraEnabled
        public String CampaignStatus;
        @AuraEnabled
        public String Categories;
        @AuraEnabled
        public Integer DaysBetween;
        @AuraEnabled
        public String CampaignTitle;
        @AuraEnabled
        public Decimal MinutesBetween;
   }
   
   global class MyUpdates implements Comparable{
        @AuraEnabled
        public String BackgroundImage;
        @AuraEnabled
        public String CreatorName;
        @AuraEnabled
        public String CreatedDateTime;
        @AuraEnabled
        public String MyUpdatesType;
        @AuraEnabled
        public String IdeaId;
        
        global Integer compareTo(Object objToCompare) {
            MyUpdates compareToMyUpdates = (MyUpdates)objToCompare;
            if (CreatedDateTime == compareToMyUpdates.CreatedDateTime) return 0;
            if (CreatedDateTime < compareToMyUpdates.CreatedDateTime) return 1;
            return -1;
        }
   }
   
   public class LeaderBoard{
        @AuraEnabled
        public String BackgroundImage;
        @AuraEnabled
        public String CreatorName;
        @AuraEnabled
        public String IdeaId;
        @AuraEnabled
        public String IdeaTitle;
        @AuraEnabled
        public Integer VoteCount;
   }
   
   public class IdeaDetails{
        @AuraEnabled
        public String BackgroundImage;
        @AuraEnabled
        public String CreatorName;
        @AuraEnabled
        public String CreatedDateTime;
        @AuraEnabled
        public String IdeaTitle;
        @AuraEnabled
        public String IdeaBody;
        @AuraEnabled
        public String Voted;
        @AuraEnabled
        public Integer VoteCount;
        @AuraEnabled
        public Integer CommentCount;
        @AuraEnabled
        public String IdeaThemeId;
        @AuraEnabled
        public String IdeaId;
        @AuraEnabled
        public String Categories;
        @AuraEnabled
        public String CampaignTitle;
        @AuraEnabled
        public String AttachmentURL;
   }
   
   public class IdeaComments{
        @AuraEnabled
        public String BackgroundImage;
        @AuraEnabled
        public String CreatorName;
        @AuraEnabled
        public String CreatedDateTime;
        @AuraEnabled
        public String CommentBody;
   }
   
   public class FAQ{
        @AuraEnabled
        public string Question{get;set;}
        @AuraEnabled
        public string Answer{get;set;}
   }
    
}