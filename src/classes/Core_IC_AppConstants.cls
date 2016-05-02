/*
  Class Name: Core_IC_AppConstants
  Author : Mindtree
  Date: 08 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: class to store constants for Ideation App
*/
public with sharing class Core_IC_AppConstants {

	/* Service response error messages */
    public static final String ERROR_MSG_UNEXPECTED_ERROR_OCCURED = 'Unexcepted exception encountered, please try again later';
    public static final String SVC_RESP_MESSAGE_INVALID_SVCNAME = 'Invalid service requested, please check the service name requested for';
    public static final Integer RESPONSE_SUCCESS_CODE = 200;
    public static final Integer RESPONSE_FAILURE_ERROR_CODE = 400;
    public static final String RESPONSE_SUCCESS_MSG = 'SUCCESS';


    /*  Service name constants */
    public static final String SVC_GET_Landing_Page_Data = 'GetLandingPageData';
    public static final String SVC_POST_Vote_Ideas = 'PostVoteIdeas';
    public static final String SVC_GET_Campaign_Detail_Data = 'GetCampaignDetailData';
    public static final String SVC_GET_Idea_Detail_Data = 'GetIdeaDetailData';
    public static final String SVC_POST_Comment_Ideas = 'PostCommentIdeas';
    public static final String SVC_POST_Submit_Ideas = 'PostSubmitIdeas';
    //public static final String SVC_GET_Category_Values = 'GetCategoryValues';
    //public static final String SVC_GET_Attachment_Id = 'GetAttachmentId';
    public static final String SVC_GET_FAQ_Values = 'GetFAQValues';
    
}