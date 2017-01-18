/*
  Class Name: Core_IC_PostCommentForAnIdea
  Author : Mindtree
  Date: 16 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: post comment for an Idea 
*/
global with sharing class Core_IC_PostCommentForAnIdea {

    /*******************************************************************************************************
    * @description This method get the wrapper data and send to the baseService application.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaCommentResponse wrapper
    */     
    global static Core_IC_WrapperUtility.IdeaCommentResponse postCommentForIdeas(Core_CA_ApplicationWrapper appWrapperObj) {
       Core_IC_WrapperUtility.IdeaCommentResponse objCommentForIdeas = new Core_IC_WrapperUtility.IdeaCommentResponse();
       try{
            objCommentForIdeas = processCommentForIdeas(appWrapperObj);
       }
  /*     catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }*/
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_PostVoteForIdeas : postVoteForIdeas method ', ex);
       }    
       return objCommentForIdeas;
    }
    
    /*******************************************************************************************************
    * @description This method insert comment into database and get the response wrapper data.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaCommentResponse wrapper
    */  
    private static Core_IC_WrapperUtility.IdeaCommentResponse processCommentForIdeas(Core_CA_ApplicationWrapper appWrapperObj){
       Core_IC_WrapperUtility.IdeaCommentResponse objCommentForIdeas = new Core_IC_WrapperUtility.IdeaCommentResponse(); 
       try{
           IdeaComment ideaComment=new IdeaComment();
           ideaComment.CommentBody=appWrapperObj.ideaCommentRequest.CommentBody;
           ideaComment.IdeaId=appWrapperObj.ideaCommentRequest.IdeaId;
           insert ideaComment;
           
           objCommentForIdeas.IdeaComments=getIdeaCommentsList(appWrapperObj);
           objCommentForIdeas.CommentCount=objCommentForIdeas.IdeaComments.size();
           
           objCommentForIdeas.message=Core_IC_AppConstants.RESPONSE_SUCCESS_MSG;
           objCommentForIdeas.statusCode=Core_IC_AppConstants.RESPONSE_SUCCESS_CODE;
           
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_PostVoteForIdeas : processVoteForIdeas method ', ex);
       }   
       
       return objCommentForIdeas;
    }
    
    
    /*******************************************************************************************************
    * @description This method is used to get all the comments for an Idea.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return List<Core_IC_WrapperUtility.IdeaComments> wrapper
    */
    private static List<Core_IC_WrapperUtility.IdeaComments> getIdeaCommentsList(Core_CA_ApplicationWrapper appWrapperObj){ 
       List<Core_IC_WrapperUtility.IdeaComments> lstIdeaComments=new List<Core_IC_WrapperUtility.IdeaComments>();
       try{
            List<IdeaComment> lstComment=[SELECT CommentBody,CreatedDate,CreatorFullPhotoUrl,CreatorName,IdeaId FROM IdeaComment WHERE IdeaId=:appWrapperObj.ideaCommentRequest.IdeaId ORDER BY CreatedDate DESC];
            for(IdeaComment ic : lstComment){
                Core_IC_WrapperUtility.IdeaComments ideaComment=new Core_IC_WrapperUtility.IdeaComments();
                ideaComment.BackgroundImage=ic.CreatorFullPhotoUrl;
                String strComment=ic.CommentBody;
                if(strComment!=null && strComment!='') strComment = strComment.replaceAll('<[^>]+>',' ');//replaceAll('<[/a-zAZ0-9]*>','');
                ideaComment.CommentBody=strComment;//ic.CommentBody;
                ideaComment.CreatorName=ic.CreatorName;
                decimal Hours = decimal.valueOf((System.now().getTime()-ic.CreatedDate.getTime())/(1000*60*60));
                decimal decMinutes = ((System.now().getTime())/1000/60) - ((ic.CreatedDate.getTime())/1000/60);
                String strTimeFormat='';
                if(Hours>=48) strTimeFormat='on '+ic.CreatedDate.format('dd-MMM-yyyy');
                else if(Hours>=24 && Hours<48) strTimeFormat='Yesterday';
                else if(((Hours>1 ||decMinutes>59)&& Hours!=1) && Hours<24) strTimeFormat=Hours+' hours ago';
                else if((Hours==1 ||decMinutes>59) && Hours<24) strTimeFormat=Hours+' hour ago';
                else if(Hours<1 && decMinutes<=59 && decMinutes>1) strTimeFormat=decMinutes+' mins ago';
                else if(Hours<1 && decMinutes==1) strTimeFormat=decMinutes+' min ago';
                else if(decMinutes<1) strTimeFormat='just now';
                ideaComment.CreatedDateTime=strTimeFormat;
                lstIdeaComments.add(ideaComment);
            }
       }
      /* catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }*/
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_IdeaDetail : processIdeaComments method ', ex);
       }   
       
       return lstIdeaComments;
    }
    
}