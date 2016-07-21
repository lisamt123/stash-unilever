/*
  Class Name: Core_IC_PostSubmitAnIdea
  Author : Mindtree
  Date: 16 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: post new Idea
*/
global with sharing class Core_IC_PostSubmitIdea {

	/*******************************************************************************************************
    * @description This method get the wrapper data and send to the baseService application.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.SubmitIdeaResponse wrapper
    */     
    global static Core_IC_WrapperUtility.SubmitIdeaResponse postSubmitAnIdea(Core_CA_ApplicationWrapper appWrapperObj) {
       Core_IC_WrapperUtility.SubmitIdeaResponse objSubmitIdeaResponse = new Core_IC_WrapperUtility.SubmitIdeaResponse();
       try{
            objSubmitIdeaResponse = processSubmitAnIdea(appWrapperObj);
            
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_PostSubmitIdea : postSubmitAnIdea method ', ex);
       }    
       return objSubmitIdeaResponse;
    }
    
    /*******************************************************************************************************
    * @description This method insert idea object record into database and get the response wrapper data.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.SubmitIdeaResponse wrapper
    */  
    private static Core_IC_WrapperUtility.SubmitIdeaResponse processSubmitAnIdea(Core_CA_ApplicationWrapper appWrapperObj){
       Core_IC_WrapperUtility.SubmitIdeaResponse objSubmitIdeaResponse = new Core_IC_WrapperUtility.SubmitIdeaResponse(); 
       try{
       	   IdeaTheme objIdeaTheme=[SELECT CommunityId FROM IdeaTheme WHERE Id = :appWrapperObj.submitIdeaRequest.IdeaCampaignId limit 1];
       	   Idea idea=new Idea();
       	   idea.CommunityId=objIdeaTheme.CommunityId;
       	   idea.IdeaThemeId=appWrapperObj.submitIdeaRequest.IdeaCampaignId;
       	   idea.Title=appWrapperObj.submitIdeaRequest.IdeaTitle;
       	   
       	   if(appWrapperObj.submitIdeaRequest.AttachmentName!=null&&appWrapperObj.submitIdeaRequest.AttachmentName!=''){
	       	   idea.AttachmentBody=EncodingUtil.Base64Decode(appWrapperObj.submitIdeaRequest.AttachmentBody);
	       	   idea.AttachmentContentType=appWrapperObj.submitIdeaRequest.AttachmentContentType;
	       	   idea.AttachmentName=appWrapperObj.submitIdeaRequest.AttachmentName;
       	   }
       	   String strCategories='';
       	   for(String categories : appWrapperObj.submitIdeaRequest.IdeaCategories){
       	   		strCategories=strCategories+categories+', ';
       	   }
       	   strCategories=strCategories.Substring(0,strCategories.length()-2);
       	   idea.Categories__c=strCategories;
       	   idea.Description__c=appWrapperObj.submitIdeaRequest.IdeaDescription;
       	   idea.Body=appWrapperObj.submitIdeaRequest.IdeaDescription;
       	   
       	   //To get Picklist values for Categories
       	   Schema.sObjectType sobject_type = Idea.getSObjectType(); //grab the sobject that was passed
		   Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
		   Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
		   List<Schema.PicklistEntry> pick_list_values = field_map.get('Categories').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
       	   
       	   idea.Categories=pick_list_values[0].getValue();
       	   insert idea;
       	   
       	   objSubmitIdeaResponse.SuccessFlag=True;
           objSubmitIdeaResponse.message=Core_IC_AppConstants.RESPONSE_SUCCESS_MSG;
           objSubmitIdeaResponse.statusCode=Core_IC_AppConstants.RESPONSE_SUCCESS_CODE;
       	   
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_PostSubmitIdea : processSubmitAnIdea method ', ex);
       }   
       
       return objSubmitIdeaResponse;
    }
    
}