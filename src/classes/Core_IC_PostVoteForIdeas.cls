/*
  Class Name: Core_IC_PostVoteForIdeas
  Author : Mindtree
  Date: 16 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: insert vote object data when user clicks on vote 
*/ 
global with sharing class Core_IC_PostVoteForIdeas {

	/*******************************************************************************************************
    * @description This method get the wrapper data and send to the baseService application.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.VoteForIdeasOfTheWeekResponse wrapper
    */     
    global static Core_IC_WrapperUtility.VoteForIdeasOfTheWeekResponse postVoteForIdeas(Core_CA_ApplicationWrapper appWrapperObj) {
       Core_IC_WrapperUtility.VoteForIdeasOfTheWeekResponse objVoteForIdeas = new Core_IC_WrapperUtility.VoteForIdeasOfTheWeekResponse(); 
       try{
            objVoteForIdeas = processVoteForIdeas(appWrapperObj);
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_PostVoteForIdeas : postVoteForIdeas method ', ex);
       }    
       return objVoteForIdeas;
    }
    
    /*******************************************************************************************************
    * @description This method to insert vote object data.
    * @param Core_CA_ApplicationWrapper wrapper
    * @return Core_IC_WrapperUtility.VoteForIdeasOfTheWeekResponse wrapper
    */
    private static Core_IC_WrapperUtility.VoteForIdeasOfTheWeekResponse processVoteForIdeas(Core_CA_ApplicationWrapper appWrapperObj){
       Core_IC_WrapperUtility.VoteForIdeasOfTheWeekResponse objVoteForIdeas = new Core_IC_WrapperUtility.VoteForIdeasOfTheWeekResponse(); 
       try{
       	   Vote vote=new Vote();
       	   vote.ParentId=appWrapperObj.voteForIdeasOfTheWeekRequest.IdeaId;
       	   vote.Type='Up';
       	   insert vote;
       	   
       	   Idea idea=[SELECT VoteTotal FROM Idea WHERE Id =:appWrapperObj.voteForIdeasOfTheWeekRequest.IdeaId limit 1];
       	   objVoteForIdeas.VoteCount=Integer.Valueof(idea.VoteTotal/10);
       	   
           objVoteForIdeas.message=Core_IC_AppConstants.RESPONSE_SUCCESS_MSG;
           objVoteForIdeas.statusCode=Core_IC_AppConstants.RESPONSE_SUCCESS_CODE;
       	   
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_PostVoteForIdeas : processVoteForIdeas method ', ex);
       }   
       
       return objVoteForIdeas;
    }
}