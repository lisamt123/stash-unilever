/*
  Class Name: Core_IC_IdeaController 
  Author : Mindtree
  Date: 27 April 2016  
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Common controller class for IdeasApp
*/ 
public class Core_IC_IdeaController {
    
    /*******************************************************************************************************
    * @description This method get the wrapper data
    * @param 
    * @return 
    */     
    @AuraEnabled
    public static Core_CA_BaseApplicationWrapper getCampaignList(String campaignLimit) {
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();       
        Core_IC_WrapperUtility.ideaLandingPageRequest wrapperUtilityObject = new Core_IC_WrapperUtility.ideaLandingPageRequest();
        wrapperUtilityObject.FeaturedCampaignsLimit = campaignLimit;        
        appWrapperObj.ideaLandingPageRequest = wrapperUtilityObject ;
        return  (Core_CA_BaseApplicationWrapper)Core_IC_LandingPage.getLandingPageDetail(appWrapperObj);
    } 
    
    /**** Get Ideas List Page data****/
    @AuraEnabled
    public static Core_CA_BaseApplicationWrapper getIdeaList(String ideaLimit) {
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();       
        Core_IC_WrapperUtility.ideaLandingPageRequest wrapperUtilityObject = new Core_IC_WrapperUtility.ideaLandingPageRequest();
        wrapperUtilityObject.IdeasOfTheWeekLimit = ideaLimit;        
        appWrapperObj.ideaLandingPageRequest = wrapperUtilityObject ;
        return (Core_CA_BaseApplicationWrapper)Core_IC_LandingPage.getLandingPageDetail(appWrapperObj);
    }            
    
    /**** Get My Updates List Data****/
    @AuraEnabled
    public static Core_CA_BaseApplicationWrapper getMyUpdatesList(String myUpdatesLimit) {
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();       
        Core_IC_WrapperUtility.ideaLandingPageRequest wrapperUtilityObject = new Core_IC_WrapperUtility.ideaLandingPageRequest();
        wrapperUtilityObject.MyUpdatesLimit= myUpdatesLimit;        
        appWrapperObj.ideaLandingPageRequest = wrapperUtilityObject ;
        return (Core_CA_BaseApplicationWrapper)Core_IC_LandingPage.getLandingPageDetail(appWrapperObj);
    } 
    
    /**** Get Idea Campaign detail data****/  
    @AuraEnabled
    public static Core_CA_BaseApplicationWrapper getCampaignDetail(String ideaThemeId,String latestIdeasLimit) {
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();       
        Core_IC_WrapperUtility.ideaCampaignDetailRequest featuredCampaignsObject = new Core_IC_WrapperUtility.ideaCampaignDetailRequest ();
        featuredCampaignsObject.IdeaCampaignId = ideaThemeId;
        featuredCampaignsObject.LatestIdeasLimit = latestIdeasLimit;
        appWrapperObj.ideaCampaignDetailRequest = featuredCampaignsObject;
        return (Core_CA_BaseApplicationWrapper)Core_IC_CampaignDetail.getCampaignDetail(appWrapperObj);  
    }
    
    /**** Get Idea detail data****/
    @AuraEnabled
    public static Core_CA_BaseApplicationWrapper getIdeaDetail(String ideaId) {
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();       
        Core_IC_WrapperUtility.ideaDetailRequest featuredCampaignsObject = new Core_IC_WrapperUtility.ideaDetailRequest();
        featuredCampaignsObject.IdeaId = ideaId;
        appWrapperObj.ideaDetailRequest = featuredCampaignsObject;
        return (Core_CA_BaseApplicationWrapper)Core_IC_IdeaDetail.getIdeaDetail(appWrapperObj);
    }
       
    /**** Post Comment for Idea****/
    @AuraEnabled
    public static Core_CA_BaseApplicationWrapper postCommentAnIdea(String ideaId,String commentBody) {
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();       
        Core_IC_WrapperUtility.ideaCommentRequest ideaCommentRequestData = new Core_IC_WrapperUtility.ideaCommentRequest();
        ideaCommentRequestData.IdeaId= ideaId;
        ideaCommentRequestData.CommentBody= commentBody;
        appWrapperObj.ideaCommentRequest = ideaCommentRequestData;
        return (Core_CA_BaseApplicationWrapper)Core_IC_PostCommentForAnIdea.postCommentForIdeas(appWrapperObj);
    }
    
    /**** Post Vote for Idea****/
    @AuraEnabled
    public static Core_CA_BaseApplicationWrapper postVoteForIdea(String ideaId) {
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();       
        Core_IC_WrapperUtility.voteForIdeasOfTheWeekRequest voteForIdeaObject = new Core_IC_WrapperUtility.voteForIdeasOfTheWeekRequest();
        voteForIdeaObject.IdeaId= ideaId;
        appWrapperObj.voteForIdeasOfTheWeekRequest = voteForIdeaObject;
        return (Core_CA_BaseApplicationWrapper)Core_IC_PostVoteForIdeas.postVoteForIdeas(appWrapperObj);
    }            
    
    /**** Post Submit an Idea****/
    @AuraEnabled
    public static Core_CA_BaseApplicationWrapper postSubmitAnIdea(String IdeaCampaignId,String IdeaTitle,String IdeaDescription,List<String> IdeaCategories,String AttachmentName,String AttachmentBody,String AttachmentContentType) {
        system.debug(IdeaCampaignId+'----------anki-----------'+IdeaTitle);
        system.debug(IdeaDescription+'----------anki-----------'+IdeaCategories);
        system.debug(AttachmentName+'---------anki------------'+AttachmentContentType);
        system.debug('---------anki------------'+AttachmentBody);
        
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();       
        Core_IC_WrapperUtility.submitIdeaRequest submitIdeaObject = new Core_IC_WrapperUtility.submitIdeaRequest();
        submitIdeaObject.IdeaCampaignId = IdeaCampaignId;
        submitIdeaObject.IdeaTitle = IdeaTitle;
        submitIdeaObject.IdeaDescription = IdeaDescription;
        submitIdeaObject.IdeaCategories = IdeaCategories;
        submitIdeaObject.AttachmentName = AttachmentName;
        submitIdeaObject.AttachmentBody = AttachmentBody;
        submitIdeaObject.AttachmentContentType = AttachmentContentType;
        appWrapperObj.submitIdeaRequest = submitIdeaObject;
        return (Core_CA_BaseApplicationWrapper)Core_IC_PostSubmitIdea.postSubmitAnIdea(appWrapperObj);
    }  
    //(Core_CA_BaseApplicationWrapper)Core_IC_PostSubmitIdea.postSubmitAnIdea(appWrapperObj);
    
    /**** Get FAQ Values****/
    @AuraEnabled
    public static Core_CA_BaseApplicationWrapper getFaqList() {
        return (Core_CA_BaseApplicationWrapper)Core_IC_FAQData.GetFAQValues();
    } 
}