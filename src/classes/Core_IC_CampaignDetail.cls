/*
  Class Name: Core_IC_CampaignDetail
  Author : Mindtree
  Date: 23 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Campaign detail page for Ideation
*/

global with sharing class Core_IC_CampaignDetail{
    
    /*******************************************************************************************************
    * @description This method gets the wrapper data and send to the baseService application.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaCampaignDetailResponse wrapper
    */     
    global static Core_IC_WrapperUtility.IdeaCampaignDetailResponse getCampaignDetail(Core_CA_ApplicationWrapper appWrapperObj) {
       Core_IC_WrapperUtility.IdeaCampaignDetailResponse objIdeaCampaignDetailResponse = new Core_IC_WrapperUtility.IdeaCampaignDetailResponse(); 
       try{
            objIdeaCampaignDetailResponse = processCampaignDetailResponse(appWrapperObj);
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_CampaignDetail : getCampaignDetail method ', ex);
       }    
       return objIdeaCampaignDetailResponse;
    }
    
    /*******************************************************************************************************
    * @description This method collate all the data and send it to getCampaignDetail method.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaCampaignDetailResponse wrapper
    */
    private static Core_IC_WrapperUtility.IdeaCampaignDetailResponse processCampaignDetailResponse(Core_CA_ApplicationWrapper appWrapperObj){
       Core_IC_WrapperUtility.IdeaCampaignDetailResponse objIdeaCampaignDetailResponse = new Core_IC_WrapperUtility.IdeaCampaignDetailResponse(); 
       try{
           if(appWrapperObj.ideaCampaignDetailRequest.LatestIdeasLimit!='All'){
               objIdeaCampaignDetailResponse.FeaturedCampaigns=processFeaturedCampaign(appWrapperObj);
               /*objIdeaCampaignDetailResponse.LatestIdeas=processLatestIdeas(appWrapperObj).LatestIdeas;
               objIdeaCampaignDetailResponse.CampaignTypeForLatestIdeas=processLatestIdeas(appWrapperObj).CampaignTypeForLatestIdeas;
               objIdeaCampaignDetailResponse.SeeAllLinkForLatestIdeas=processLatestIdeas(appWrapperObj).SeeAllLinkForLatestIdeas;
               objIdeaCampaignDetailResponse.CampaignStatus=processLatestIdeas(appWrapperObj).CampaignStatus;*/
               Core_IC_WrapperUtility.IdeaCampaignDetailResponse objIdeaCampaignDetailResponseTemp=processLatestIdeas(appWrapperObj);
               objIdeaCampaignDetailResponse.IdeasOfTheWeek=objIdeaCampaignDetailResponseTemp.IdeasOfTheWeek;
               objIdeaCampaignDetailResponse.CampaignTypeForLatestIdeas=objIdeaCampaignDetailResponseTemp.CampaignTypeForLatestIdeas;
               objIdeaCampaignDetailResponse.SeeAllLinkForLatestIdeas=objIdeaCampaignDetailResponseTemp.SeeAllLinkForLatestIdeas;
               objIdeaCampaignDetailResponse.CampaignStatus=objIdeaCampaignDetailResponseTemp.CampaignStatus;
               objIdeaCampaignDetailResponse.ActiveStatus=objIdeaCampaignDetailResponseTemp.ActiveStatus;
               objIdeaCampaignDetailResponse.LeaderBoard=processLeaderBoard(appWrapperObj);
               
           }
           else{ 
                /*objIdeaCampaignDetailResponse.LatestIdeas=processLatestIdeas(appWrapperObj).LatestIdeas;
                objIdeaCampaignDetailResponse.CampaignStatus=processLatestIdeas(appWrapperObj).CampaignStatus;*/
                objIdeaCampaignDetailResponse=processLatestIdeas(appWrapperObj);
                objIdeaCampaignDetailResponse.Categories=processCategories(appWrapperObj.ideaCampaignDetailRequest.IdeaCampaignId);
           }
           objIdeaCampaignDetailResponse.message=Core_IC_AppConstants.RESPONSE_SUCCESS_MSG;
           objIdeaCampaignDetailResponse.statusCode=Core_IC_AppConstants.RESPONSE_SUCCESS_CODE;
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_CampaignDetail : processCampaignDetailResponse method ', ex);
       }   
       
       return objIdeaCampaignDetailResponse;
    }
    
    /*******************************************************************************************************
    * @description This method is used to get featured campaign data based on id.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.FeaturedCampaigns wrapper
    */
    private static Core_IC_WrapperUtility.FeaturedCampaigns processFeaturedCampaign(Core_CA_ApplicationWrapper appWrapperObj){
       Core_IC_WrapperUtility.FeaturedCampaigns ObjFeaturedCampaign=new Core_IC_WrapperUtility.FeaturedCampaigns(); 
       try{
           IdeaTheme ideaTheme=getideaCampaigndata(Id.valueof(appWrapperObj.ideaCampaignDetailRequest.IdeaCampaignId));//=[SELECT Description,EndDate,Idea_Themes_Banner__c,Title,Promoted__c,Id,Description__c,CreatedDate,Status FROM IdeaTheme WHERE Id=:appWrapperObj.ideaCampaignDetailRequest.IdeaCampaignId Limit 1];
           
           AggregateResult[] groupedResults=[SELECT Count(Id) cnt,IdeaThemeId FROM Idea where IdeaThemeId =:appWrapperObj.ideaCampaignDetailRequest.IdeaCampaignId Group by IdeaThemeId];
           
            String strIdeaThemeBanner=ideaTheme.Idea_Themes_Banner__c;
            strIdeaThemeBanner=strIdeaThemeBanner.substringBetween('src="','"');
            ObjFeaturedCampaign.Banner=strIdeaThemeBanner.remove('amp;');
            Integer DaysBetween=System.now().date().daysBetween(ideaTheme.EndDate.date());
            String strDaysFormat='';
            String dt=ideaTheme.EndDate.format('dd-MMM-yyyy');
            if(DaysBetween<0) strDaysFormat='Ended on '+dt;
            if(DaysBetween==0) strDaysFormat='Ends Today';
            else if(DaysBetween==1) strDaysFormat='Ends in '+DaysBetween+' day';
            else if(DaysBetween>1 && DaysBetween<=90) strDaysFormat='Ends in '+DaysBetween+' days';
            else if(DaysBetween>90) strDaysFormat='Ends on '+dt;
            ObjFeaturedCampaign.EndDate=strDaysFormat;
            ObjFeaturedCampaign.CampaignTitle=ideaTheme.Title;
            ObjFeaturedCampaign.Description=ideaTheme.Description__c;
            Integer intIdeaCount=0;
            if(!groupedResults.isEmpty()) intIdeaCount=Integer.valueof(groupedResults[0].get('cnt'));
            ObjFeaturedCampaign.IdeaCount=intIdeaCount;
            ObjFeaturedCampaign.Promoted=ideaTheme.Promoted__c;
            ObjFeaturedCampaign.IdeaThemeId=ideaTheme.Id;
            ObjFeaturedCampaign.StatusType=ideaTheme.Status;
            ObjFeaturedCampaign.DaysBetween=DaysBetween;
            String strCategories=ideaTheme.Categories__c.ReplaceAll(', ',',');
            ObjFeaturedCampaign.Categories=strCategories.split(',');
            
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_CampaignDetail : processFeaturedCampaign method ', ex);
       }   
       
       return ObjFeaturedCampaign;
    }
    
    /*******************************************************************************************************
    * @description This method is used to get all latest ideas based on Idea Campaign id.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaCampaignDetailResponse wrapper
    */
    private static Core_IC_WrapperUtility.IdeaCampaignDetailResponse processLatestIdeas(Core_CA_ApplicationWrapper appWrapperObj){
       Core_IC_WrapperUtility.IdeaCampaignDetailResponse ObjIdeaCampaignDetailResponse=new Core_IC_WrapperUtility.IdeaCampaignDetailResponse();
       List<Core_IC_WrapperUtility.IdeasOfTheWeek> lstLatestIdeas=new List<Core_IC_WrapperUtility.IdeasOfTheWeek>(); 
       List<Idea> lstIdea=new List<Idea>(); 
       try{
           IdeaTheme ideaTheme=getideaCampaigndata(Id.valueof(appWrapperObj.ideaCampaignDetailRequest.IdeaCampaignId));
           ObjIdeaCampaignDetailResponse.ActiveStatus=False;
           ObjIdeaCampaignDetailResponse.CampaignStatus=ideaTheme.Status;
           if(ideaTheme.Status=='Active') ObjIdeaCampaignDetailResponse.ActiveStatus=True;
           if(appWrapperObj.ideaCampaignDetailRequest.LatestIdeasLimit!='All') lstIdea=[SELECT Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,CreatorFullPhotoUrl,Categories__c FROM Idea Where IdeaThemeId=:appWrapperObj.ideaCampaignDetailRequest.IdeaCampaignId ORDER BY VoteTotal DESC,CreatedDate DESC Limit 5];
           else lstIdea=[SELECT Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,CreatorFullPhotoUrl,Categories__c FROM Idea Where IdeaThemeId=:appWrapperObj.ideaCampaignDetailRequest.IdeaCampaignId ORDER BY CreatedDate DESC];
           if(!lstIdea.isEmpty()){
                ObjIdeaCampaignDetailResponse.SeeAllLinkForLatestIdeas=True;
                ObjIdeaCampaignDetailResponse.CampaignTypeForLatestIdeas='None';
            }
            else{
                ObjIdeaCampaignDetailResponse.SeeAllLinkForLatestIdeas=False;
                ObjIdeaCampaignDetailResponse.CampaignTypeForLatestIdeas='NoIdeas';
            }
            if(ObjIdeaCampaignDetailResponse.SeeAllLinkForLatestIdeas==True){
                Set<Id> setIdeasId=new Set<Id>();
                for(Idea i:lstIdea){
                    setIdeasId.add(i.Id);
                }
                List<Vote> lstVote=[SELECT CreatedById,CreatedDate,Id,IsDeleted,ParentId,SystemModstamp,Type FROM Vote WHERE CreatedById = :Userinfo.getuserId() AND Parent.Type='Idea'];
                
                Map<Id,String> mapVoteId=new Map<Id,String>();
                for(Vote v:lstVote){
                    mapVoteId.put(v.ParentId,v.Type);
                }
                for(Idea i : lstIdea){
                        Core_IC_WrapperUtility.IdeasOfTheWeek ObjIdeasOfTheWeek=new Core_IC_WrapperUtility.IdeasOfTheWeek();
                        ObjIdeasOfTheWeek.BackgroundImage=i.CreatorSmallPhotoUrl;
                        decimal Hours = decimal.valueOf((System.now().getTime()-i.CreatedDate.getTime())/(1000*60*60));
                        decimal decMinutes = ((System.now().getTime())/1000/60) - ((i.CreatedDate.getTime())/1000/60);
                        String strTimeFormat='';
                        if(Hours>=48) strTimeFormat='on '+i.CreatedDate.format('dd-MMM-yyyy');
                        else if(Hours>=24 && Hours<48) strTimeFormat='Yesterday';
                        else if(((Hours>1 ||decMinutes>59)&& Hours!=1) && Hours<24) strTimeFormat=Hours+' hours ago';
                        else if((Hours==1 ||decMinutes>59) && Hours<24) strTimeFormat=Hours+' hour ago';
                        else if(Hours<1 && decMinutes<=59 && decMinutes>1) strTimeFormat=decMinutes+' mins ago';
                        else if(Hours<1 && decMinutes==1) strTimeFormat=decMinutes+' min ago';
                        else if(decMinutes<1) strTimeFormat='just now';
                        ObjIdeasOfTheWeek.CreatedDateTime=strTimeFormat;
                        ObjIdeasOfTheWeek.CreatorName=i.CreatorName;
                        String strDescription=i.Description__c;
                        if(strDescription.length()>=Integer.valueof(Core_Ideation__c.getinstance('DescriptionLimit').Text_Value__c)) strDescription=strDescription.substring(0, Integer.valueof(Core_Ideation__c.getinstance('DescriptionLimit').Text_Value__c))+'...';
                        ObjIdeasOfTheWeek.IdeaBody=strDescription;
                        ObjIdeasOfTheWeek.IdeaId=i.Id;
                        ObjIdeasOfTheWeek.IdeaThemeId=i.IdeaThemeId;
                        ObjIdeasOfTheWeek.IdeaTitle=i.Title;
                        ObjIdeasOfTheWeek.VoteCount=Integer.Valueof(i.VoteTotal/10);
                        String strVoted='False';
                        if(mapVoteId.get(i.Id)!=null) strVoted='True';
                        ObjIdeasOfTheWeek.Voted=strVoted;
                        ObjIdeasOfTheWeek.CommentCount=i.NumComments;
                        ObjIdeasOfTheWeek.CampaignStatus=ideaTheme.Status;
                        ObjIdeasOfTheWeek.Categories=i.Categories__c;
                        ObjIdeasOfTheWeek.DaysBetween=i.CreatedDate.date().daysBetween(System.now().date());
                        ObjIdeasOfTheWeek.CampaignTitle=ideaTheme.Title;
                        ObjIdeasOfTheWeek.MinutesBetween=decMinutes/1000;
                        lstLatestIdeas.add(ObjIdeasOfTheWeek);
                   }
            }
            ObjIdeaCampaignDetailResponse.IdeasOfTheWeek=lstLatestIdeas;
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_CampaignDetail : processLatestIdeas method ', ex);
       }   
       
       return ObjIdeaCampaignDetailResponse;
    }
    
    
    /*******************************************************************************************************
    * @description This method is used to get all the Leaderboard data based on Idea campaign id.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.LeaderBoard wrapper
    */
    private static List<Core_IC_WrapperUtility.LeaderBoard> processLeaderBoard(Core_CA_ApplicationWrapper appWrapperObj){ 
       List<Core_IC_WrapperUtility.LeaderBoard> lstLeaderBoard=new List<Core_IC_WrapperUtility.LeaderBoard>();
       try{
            List<Idea> lstIdea=[SELECT Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,CreatorFullPhotoUrl FROM Idea Where IdeaThemeId=:appWrapperObj.ideaCampaignDetailRequest.IdeaCampaignId ORDER BY VoteTotal DESC,CreatedDate DESC Limit 5];
            for(Idea i:lstIdea){
                Core_IC_WrapperUtility.LeaderBoard leaderBoard=new Core_IC_WrapperUtility.LeaderBoard();
                leaderBoard.BackgroundImage=i.CreatorFullPhotoUrl;
                leaderBoard.CreatorName=i.CreatorName;
                leaderBoard.IdeaId=i.Id;
                leaderBoard.IdeaTitle=i.Title;
                leaderBoard.VoteCount=Integer.Valueof(i.VoteTotal/10);
                lstLeaderBoard.add(leaderBoard);
            }
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_CampaignDetail : processLeaderBoard method ', ex);
       }   
       
       return lstLeaderBoard;
    }
    
    /*******************************************************************************************************
    * @description This method is used to get categories for specific campaign id.
    * @param Campaign Id 
    * @return List<String> Categories 
    */
    private static List<String> processCategories(Id CampaignId){ 
       List<String> lstCategories=new List<String>();
       try{
            IdeaTheme ideaTheme=getideaCampaigndata(CampaignId);
            String strCategories=ideaTheme.Categories__c.ReplaceAll(', ',',');
            lstCategories=strCategories.split(',');
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_CampaignDetail : processLeaderBoard method ', ex);
       }   
       
       return lstCategories;
    }
    
    /*******************************************************************************************************
    * @description This method is used to get campaign details data for specific campaign id.
    * @param Campaign Id 
    * @return IdeaTheme record 
    */
    private static IdeaTheme getideaCampaigndata(Id id){ 
       IdeaTheme ideaTheme=new IdeaTheme(); 
       try{
            ideaTheme=[SELECT Description,EndDate,Idea_Themes_Banner__c,Title,Promoted__c,Id,Description__c,CreatedDate,Status,Categories__c FROM IdeaTheme WHERE Id=:id Limit 1];
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_CampaignDetail : getideaCampaigndata method ', ex);
       }   
       
       return ideaTheme;
    }
    
}