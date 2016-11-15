/*
  Class Name: Core_IC_IdeaDetail
  Author : Mindtree
  Date: 8 July 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Idea detail page for Ideation
*/

global with sharing class Core_IC_IdeaDetail{
    
    /*******************************************************************************************************
    * @description This method gets the wrapper data and send to the baseService application.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaDetailResponse wrapper
    */     
    global static Core_IC_WrapperUtility.IdeaDetailResponse getIdeaDetail(Core_CA_ApplicationWrapper appWrapperObj) {
       Core_IC_WrapperUtility.IdeaDetailResponse objIdeaDetailResponse = new Core_IC_WrapperUtility.IdeaDetailResponse(); 
       try{
            objIdeaDetailResponse = processIdeaDetailResponse(appWrapperObj);
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_IdeaDetail : getIdeaDetail method ', ex);
       }    
       return objIdeaDetailResponse;
    }
    
    /*******************************************************************************************************
    * @description This method collate all the data and send it to getIdeaDetail method.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaDetailResponse wrapper
    */
    private static Core_IC_WrapperUtility.IdeaDetailResponse processIdeaDetailResponse(Core_CA_ApplicationWrapper appWrapperObj){
       Core_IC_WrapperUtility.IdeaDetailResponse objIdeaDetailResponse = new Core_IC_WrapperUtility.IdeaDetailResponse(); 
       try{
           /*objIdeaDetailResponse.IdeaDetails=processIdeaDetail(appWrapperObj).IdeaDetails;
           objIdeaDetailResponse.CampaignStatus=processIdeaDetail(appWrapperObj).CampaignStatus;*/
           objIdeaDetailResponse=processIdeaDetail(appWrapperObj);
           objIdeaDetailResponse.IdeaComments=processIdeaComments(appWrapperObj);
           
           objIdeaDetailResponse.message=Core_IC_AppConstants.RESPONSE_SUCCESS_MSG;
           objIdeaDetailResponse.statusCode=Core_IC_AppConstants.RESPONSE_SUCCESS_CODE;
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_IdeaDetail : processIdeaDetailResponse method ', ex);
       }   
       
       return objIdeaDetailResponse;
    }
    
    /*******************************************************************************************************
    * @description This method is used to get Idea detail based on Idea id.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaDetailResponse wrapper
    */
    private static Core_IC_WrapperUtility.IdeaDetailResponse processIdeaDetail(Core_CA_ApplicationWrapper appWrapperObj){
       Core_IC_WrapperUtility.IdeaDetailResponse ObjIdeaDetailResponse=new Core_IC_WrapperUtility.IdeaDetailResponse();
       try{
            Idea idea=[Select Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,CreatorFullPhotoUrl,Categories__c,AttachmentLength FROM Idea Where Id=:appWrapperObj.ideaDetailRequest.IdeaId Limit 1];
            IdeaTheme ideaTheme=[SELECT Status,Title,Categories__c FROM IdeaTheme WHERE Id=:idea.IdeaThemeId];
            List<Vote> vote=[SELECT CreatedById,CreatedDate,Id,IsDeleted,ParentId,SystemModstamp,Type FROM Vote WHERE CreatedById = :Userinfo.getuserId() AND Parent.Type='Idea' AND ParentId=:appWrapperObj.ideaDetailRequest.IdeaId];
           
            Core_IC_WrapperUtility.IdeaDetails ObjIdeaDetail=new Core_IC_WrapperUtility.IdeaDetails();
            ObjIdeaDetail.BackgroundImage=idea.CreatorSmallPhotoUrl;
            decimal Hours = decimal.valueOf((System.now().getTime()-idea.CreatedDate.getTime())/(1000*60*60));
            decimal decMinutes = ((System.now().getTime())/1000/60) - ((idea.CreatedDate.getTime())/1000/60);
            String strTimeFormat='';
            if(Hours>=48) strTimeFormat='on '+idea.CreatedDate.format('dd-MMM-yyyy');
            else if(Hours>=24 && Hours<48) strTimeFormat='Yesterday';
            else if(((Hours>1 ||decMinutes>59)&& Hours!=1) && Hours<24) strTimeFormat=Hours+' hours ago';
            else if((Hours==1 ||decMinutes>59) && Hours<24) strTimeFormat=Hours+' hour ago';
            else if(Hours<1 && decMinutes<=59 && decMinutes>1) strTimeFormat=decMinutes+' mins ago';
            else if(Hours<1 && decMinutes==1) strTimeFormat=decMinutes+' min ago';
            else if(decMinutes<1) strTimeFormat='just now';
            ObjIdeaDetail.CreatedDateTime=strTimeFormat;
            ObjIdeaDetail.CreatorName=idea.CreatorName;
            //String strDescription=idea.Description__c;
            //if(strDescription.length()>=Integer.valueof(Core_Ideation__c.getinstance('DescriptionLimit').Text_Value__c)) strDescription=strDescription.substring(0, Integer.valueof(Core_Ideation__c.getinstance('DescriptionLimit').Text_Value__c))+'...';
            ObjIdeaDetail.IdeaBody=idea.Description__c;
            ObjIdeaDetail.IdeaId=idea.Id;
            ObjIdeaDetail.IdeaThemeId=idea.IdeaThemeId;
            ObjIdeaDetail.IdeaTitle=idea.Title;
            ObjIdeaDetail.VoteCount=Integer.Valueof(idea.VoteTotal/10);
            String strVoted='False';
            if(!vote.isEmpty()) strVoted='True';
            ObjIdeaDetail.Voted=strVoted;
            ObjIdeaDetail.CommentCount=idea.NumComments;
            ObjIdeaDetail.Categories=idea.Categories__c;
            ObjIdeaDetail.CampaignTitle=ideaTheme.Title;
            if(idea.AttachmentLength!=null) ObjIdeaDetail.AttachmentURL=URL.getFileFieldURL(appWrapperObj.ideaDetailRequest.IdeaId,'AttachmentBody');
            ObjIdeaDetailResponse.IdeaDetails=ObjIdeaDetail;
            ObjIdeaDetailResponse.CampaignStatus=ideaTheme.Status;
            String strCategories=ideaTheme.Categories__c.ReplaceAll(', ',',');
            ObjIdeaDetailResponse.Categories=strCategories.split(',');
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_IdeaDetail : processIdeaDetail method ', ex);
       }   
       
       return ObjIdeaDetailResponse;
    }
    
    
    /*******************************************************************************************************
    * @description This method is used to get all the Leaderboard data based on Idea campaign id.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return List<Core_IC_WrapperUtility.IdeaComments> wrapper
    */
    private static List<Core_IC_WrapperUtility.IdeaComments> processIdeaComments(Core_CA_ApplicationWrapper appWrapperObj){ 
       List<Core_IC_WrapperUtility.IdeaComments> lstIdeaComments=new List<Core_IC_WrapperUtility.IdeaComments>();
       try{
            List<IdeaComment> lstComment=[SELECT CommentBody,CreatedDate,CreatorFullPhotoUrl,CreatorName,IdeaId FROM IdeaComment WHERE IdeaId=:appWrapperObj.ideaDetailRequest.IdeaId ORDER BY CreatedDate DESC];
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
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_IdeaDetail : processIdeaComments method ', ex);
       }   
       
       return lstIdeaComments;
    }
    
}