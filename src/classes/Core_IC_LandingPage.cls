/*
  Class Name: Core_IC_LandingPage
  Author : Mindtree
  Date: 1 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Landing Page used for Ideation
*/ 

global with sharing class Core_IC_LandingPage{
    
    /*******************************************************************************************************
    * @description This method get the wrapper data and send to the baseService application.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaLandingPageResponse wrapper
    */     
    global static Core_IC_WrapperUtility.IdeaLandingPageResponse getLandingPageDetail(Core_CA_ApplicationWrapper appWrapperObj) {
       Core_IC_WrapperUtility.IdeaLandingPageResponse objIdeaLandingPageResponse = new Core_IC_WrapperUtility.IdeaLandingPageResponse(); 
       try{
            objIdeaLandingPageResponse = processIdeaLandingPageResponse(appWrapperObj);
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_LandingPage : getLandingPageDetail method ', ex);
       }    
       return objIdeaLandingPageResponse;
    }
    
    /*******************************************************************************************************
    * @description This method collate all the data and send it to getLandingPageDetail method.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaLandingPageResponse wrapper
    */
    private static Core_IC_WrapperUtility.IdeaLandingPageResponse processIdeaLandingPageResponse(Core_CA_ApplicationWrapper appWrapperObj){
       Core_IC_WrapperUtility.IdeaLandingPageResponse objIdeaLandingPageResponse = new Core_IC_WrapperUtility.IdeaLandingPageResponse(); 
       try{
           Core_IC_WrapperUtility.IdeaLandingPageResponse objIdeaLandingPageResponseTemp=new Core_IC_WrapperUtility.IdeaLandingPageResponse();
           objIdeaLandingPageResponse.ActiveStatus=false;
           if(appWrapperObj.ideaLandingPageRequest.FeaturedCampaignsLimit=='4' || appWrapperObj.ideaLandingPageRequest.FeaturedCampaignsLimit=='All'){
               objIdeaLandingPageResponseTemp=processFeaturedCampaigns(appWrapperObj);
               objIdeaLandingPageResponse.FeaturedCampaigns=objIdeaLandingPageResponseTemp.FeaturedCampaigns;
               objIdeaLandingPageResponse.CampaignTypeForFeaturedCampaigns=objIdeaLandingPageResponseTemp.CampaignTypeForFeaturedCampaigns;
               objIdeaLandingPageResponse.SeeAllLinkForFeaturedCampaigns=objIdeaLandingPageResponseTemp.SeeAllLinkForFeaturedCampaigns;
               objIdeaLandingPageResponse.ActiveStatus=objIdeaLandingPageResponseTemp.ActiveStatus;
           }
           
           if(appWrapperObj.ideaLandingPageRequest.IdeasOfTheWeekLimit=='4' || appWrapperObj.ideaLandingPageRequest.IdeasOfTheWeekLimit=='All'){
               objIdeaLandingPageResponseTemp=processIdeasOfTheWeek(appWrapperObj);
               objIdeaLandingPageResponse.IdeasOfTheWeek=objIdeaLandingPageResponseTemp.IdeasOfTheWeek;
               objIdeaLandingPageResponse.CampaignTypeForIdeasOfTheWeek=objIdeaLandingPageResponseTemp.CampaignTypeForIdeasOfTheWeek;
               objIdeaLandingPageResponse.SeeAllLinkForIdeasOfTheWeek=objIdeaLandingPageResponseTemp.SeeAllLinkForIdeasOfTheWeek;
               if(!objIdeaLandingPageResponse.ActiveStatus) objIdeaLandingPageResponse.ActiveStatus=objIdeaLandingPageResponseTemp.ActiveStatus;
           }
           
           if(appWrapperObj.ideaLandingPageRequest.MyUpdatesLimit=='4' || appWrapperObj.ideaLandingPageRequest.MyUpdatesLimit=='5' || appWrapperObj.ideaLandingPageRequest.MyUpdatesLimit=='All'){
               objIdeaLandingPageResponseTemp=processMyUpdates(appWrapperObj);
               objIdeaLandingPageResponse.MyUpdates=objIdeaLandingPageResponseTemp.MyUpdates;
               objIdeaLandingPageResponse.CampaignTypeForMyUpdates=objIdeaLandingPageResponseTemp.CampaignTypeForMyUpdates;
               objIdeaLandingPageResponse.SeeAllLinkForMyUpdates=objIdeaLandingPageResponseTemp.SeeAllLinkForMyUpdates;
               if(!objIdeaLandingPageResponse.ActiveStatus) objIdeaLandingPageResponse.ActiveStatus=objIdeaLandingPageResponseTemp.ActiveStatus;
               if(appWrapperObj.ideaLandingPageRequest.MyUpdatesLimit=='All') objIdeaLandingPageResponse.IdeasOfTheWeek=objIdeaLandingPageResponseTemp.IdeasOfTheWeek;
           }
           objIdeaLandingPageResponse.message=Core_IC_AppConstants.RESPONSE_SUCCESS_MSG;
           objIdeaLandingPageResponse.statusCode=Core_IC_AppConstants.RESPONSE_SUCCESS_CODE;
           ObjIdeaLandingPageResponse.ShowMoreLimit=(Integer)Core_Ideation_heirarchical__c.getInstance().Record_Display_Limit__c;
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_LandingPage : processIdeaLandingPageResponse method ', ex);
       }   
       
       return objIdeaLandingPageResponse;
    }
    
    /*******************************************************************************************************
    * @description This method is used to get all the featured campaigns data.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaLandingPageResponse wrapper
    */
    private static Core_IC_WrapperUtility.IdeaLandingPageResponse processFeaturedCampaigns(Core_CA_ApplicationWrapper appWrapperObj){
       Core_IC_WrapperUtility.IdeaLandingPageResponse ObjIdeaLandingPageResponse=new Core_IC_WrapperUtility.IdeaLandingPageResponse(); 
       List<Core_IC_WrapperUtility.FeaturedCampaigns> lstFeaturedCampaigns = new List<Core_IC_WrapperUtility.FeaturedCampaigns>(); 
       try{
           List<IdeaTheme> lstIdeaTheme=new List<IdeaTheme>();
           List<IdeaTheme> lstActiveIdeaTheme=new List<IdeaTheme>(); 
           ObjIdeaLandingPageResponse.ActiveStatus=False;
           if(appWrapperObj.ideaLandingPageRequest.FeaturedCampaignsLimit!='All') lstActiveIdeaTheme=[SELECT Description,EndDate,Idea_Themes_Banner__c,Title,Promoted__c,Id,Description__c,CreatedDate,Status,Categories__c FROM IdeaTheme WHERE Status=:'Active' ORDER BY Promoted__c DESC,CreatedDate DESC Limit 4];//StartDate <=: System.now() AND EndDate >= :System.now()
           else lstActiveIdeaTheme=[SELECT Description,EndDate,Idea_Themes_Banner__c,Title,Promoted__c,Id,Description__c,CreatedDate,Status,Categories__c FROM IdeaTheme WHERE Status=:'Active' ORDER BY Promoted__c DESC,CreatedDate DESC];
           List<IdeaTheme> lstClosedIdeaTheme=[SELECT Description,EndDate,Idea_Themes_Banner__c,Title,Promoted__c,Description__c,CreatedDate,Status,Categories__c FROM IdeaTheme WHERE Status=:'Closed' ORDER BY EndDate DESC];
           if(!lstActiveIdeaTheme.isEmpty()){
                lstIdeaTheme=lstActiveIdeaTheme;
                //ObjIdeaLandingPageResponse.CampaignTypeForFeaturedCampaigns='Active';
                ObjIdeaLandingPageResponse.SeeAllLinkForFeaturedCampaigns=True;
                ObjIdeaLandingPageResponse.ActiveStatus=True;
           }
           else if(!lstClosedIdeaTheme.isEmpty()){
                //lstIdeaTheme=lstClosedIdeaTheme;
                //ObjIdeaLandingPageResponse.CampaignTypeForFeaturedCampaigns='Closed';
                ObjIdeaLandingPageResponse.SeeAllLinkForFeaturedCampaigns=True;
           }
           else{
                //ObjIdeaLandingPageResponse.CampaignTypeForFeaturedCampaigns='None';
                ObjIdeaLandingPageResponse.SeeAllLinkForFeaturedCampaigns=False;
           }

           ObjIdeaLandingPageResponse.CampaignTypeForFeaturedCampaigns='None';
           if(lstActiveIdeaTheme.isEmpty() && !lstClosedIdeaTheme.isEmpty()){
                ObjIdeaLandingPageResponse.CampaignTypeForFeaturedCampaigns='NoActive';
           }
           else if(lstClosedIdeaTheme.isEmpty()){
                ObjIdeaLandingPageResponse.CampaignTypeForFeaturedCampaigns='NoClosed';
           }
           
           if(appWrapperObj.ideaLandingPageRequest.FeaturedCampaignsLimit=='All'){
                if(!lstActiveIdeaTheme.isempty())
                    lstIdeaTheme=[SELECT Description,EndDate,Idea_Themes_Banner__c,Title,Promoted__c,Description__c,CreatedDate,Status,Categories__c FROM IdeaTheme WHERE Status=:'Active' OR Status=:'Closed'  ORDER BY Status ASC,EndDate ASC];
                else lstIdeaTheme=lstClosedIdeaTheme;
           }
           
           if(ObjIdeaLandingPageResponse.SeeAllLinkForFeaturedCampaigns){
               Set<Id> setId=new Set<Id>();
               for(IdeaTheme i:lstIdeaTheme){
                   setId.add(i.Id);
               }
               AggregateResult[] groupedResults=[SELECT Count(Id) cnt,IdeaThemeId FROM Idea where IdeaThemeId in:setId Group by IdeaThemeId];
               Map<String,String> mapIdeaCount=new Map<String,String>();
               for(AggregateResult c:groupedResults){
                   mapIdeaCount.put(String.valueof(c.get('IdeaThemeId')),String.Valueof(c.get('cnt')));
               }
               for(IdeaTheme i : lstIdeaTheme){
                    Core_IC_WrapperUtility.FeaturedCampaigns ObjFeaturedCampaigns=new Core_IC_WrapperUtility.FeaturedCampaigns();
                    String strIdeaThemeBanner=i.Idea_Themes_Banner__c;
                    strIdeaThemeBanner=strIdeaThemeBanner.substringBetween('src="','"');//substringAfter('src="').substringBefore('" style');
                    ObjFeaturedCampaigns.Banner=strIdeaThemeBanner.remove('amp;');
                    Integer DaysBetween=System.now().date().daysBetween(i.EndDate.date());
                    String strDaysFormat='';
                    String dt=i.EndDate.format('dd-MMM-yyyy');
                    if(DaysBetween<0) strDaysFormat='Ended on '+dt;
                    if(DaysBetween==0) strDaysFormat='Ends Today';
                    else if(DaysBetween==1) strDaysFormat='Ends in '+DaysBetween+' day';
                    else if(DaysBetween>1 && DaysBetween<=90) strDaysFormat='Ends in '+DaysBetween+' days';
                    else if(DaysBetween>90) strDaysFormat='Ends on '+dt;
                    ObjFeaturedCampaigns.EndDate=strDaysFormat;
                    ObjFeaturedCampaigns.CampaignTitle=i.Title;
                    String strDescription=i.Description__c;
                    if(strDescription.length()>=Integer.valueof(Core_Ideation__c.getinstance('DescriptionLimit').Text_Value__c)) strDescription=strDescription.substring(0, Integer.valueof(Core_Ideation__c.getinstance('DescriptionLimit').Text_Value__c))+'...';
                    ObjFeaturedCampaigns.Description=strDescription;
                    Integer Count=0;
                    if(mapIdeaCount.get(String.valueof(i.Id))!=null) Count=Integer.valueof(mapIdeaCount.get(String.valueof(i.Id)));
                    ObjFeaturedCampaigns.IdeaCount=Count;
                    ObjFeaturedCampaigns.Promoted=i.Promoted__c;
                    ObjFeaturedCampaigns.IdeaThemeId=i.Id;
                    ObjFeaturedCampaigns.StatusType=i.Status;
                    String strDaysBetween=String.Valueof(DaysBetween);
                    strDaysBetween=strDaysBetween.replace('-', '10000');
                    if(i.Status=='Closed') DaysBetween=Integer.valueof(strDaysBetween);
                    ObjFeaturedCampaigns.DaysBetween=DaysBetween;
                    String strCategories=i.Categories__c.ReplaceAll(', ',',');
                    ObjFeaturedCampaigns.Categories=strCategories.split(',');
                    lstFeaturedCampaigns.add(ObjFeaturedCampaigns);
               }
               ObjIdeaLandingPageResponse.FeaturedCampaigns=lstFeaturedCampaigns;
           }
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_LandingPage : processFeaturedCampaigns method ', ex);
       }   
       
       return ObjIdeaLandingPageResponse;
    }
    
    
    /*******************************************************************************************************
    * @description This method is used to get all the ideas of the week data.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaLandingPageResponse wrapper
    */
    private static Core_IC_WrapperUtility.IdeaLandingPageResponse processIdeasOfTheWeek(Core_CA_ApplicationWrapper appWrapperObj){ 
       Core_IC_WrapperUtility.IdeaLandingPageResponse ObjIdeaLandingPageResponse=new Core_IC_WrapperUtility.IdeaLandingPageResponse(); 
       List<Core_IC_WrapperUtility.IdeasOfTheWeek> lstIdeasOfTheWeek = new List<Core_IC_WrapperUtility.IdeasOfTheWeek>();
       List<IdeaTheme> lstIdeaTheme=new List<IdeaTheme>();
       try{
            List<IdeaTheme> lstActiveIdeaTheme=[SELECT Description,EndDate,Idea_Themes_Banner__c,Title,Promoted__c,Id FROM IdeaTheme WHERE Status=:'Active' ORDER BY Promoted__c DESC,CreatedDate DESC];
            List<IdeaTheme> lstClosedIdeaTheme=[SELECT Description,EndDate,Idea_Themes_Banner__c,Title,Promoted__c FROM IdeaTheme WHERE Status=:'Closed' ORDER BY Promoted__c DESC,CreatedDate DESC];
            List<Idea> lstIdea=new List<Idea>(); 
            Set<Id> setActiveId=new Set<Id>();
            for(IdeaTheme i:lstActiveIdeaTheme){
                setActiveId.add(i.Id);
            }
            Set<Id> setClosedId=new Set<Id>();
            for(IdeaTheme i:lstClosedIdeaTheme){
                setClosedId.add(i.Id);
            }
            List<Idea> lstActiveIdea=new List<Idea>();
            List<Idea> lstActiveWeekIdea=new List<Idea>();
            DateTime dt=System.now().addDays(-6);
            //if(appWrapperObj.ideaLandingPageRequest.IdeasOfTheWeekLimit!='All'){
                //lstActiveWeekIdea=[SELECT Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,Categories__c FROM Idea Where IdeaThemeId in :setActiveId and CreatedDate>:dt and CreatedDate< :System.now()  ORDER BY VoteTotal DESC,CreatedDate DESC Limit 4];
                //lstActiveWeekIdea=[SELECT Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,Categories__c FROM Idea Where IdeaThemeId in :setActiveId and CreatedDate>:dt and CreatedDate< :System.now()  ORDER BY VoteTotal DESC,CreatedDate DESC Limit 4];
                lstActiveWeekIdea=[SELECT Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,Categories__c FROM Idea Where IdeaThemeId in :setActiveId and CreatedDate>:dt and CreatedDate< :System.now()  ORDER BY VoteTotal DESC,CreatedDate DESC];
                //lstActiveWeekIdea=lstActiveIdea;
            /*}            
            else*/             
            lstActiveIdea=[SELECT Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,Categories__c FROM Idea Where IdeaThemeId in :setActiveId ORDER BY VoteTotal DESC,CreatedDate DESC Limit 4];
            List<Idea> lstClosedIdea=[SELECT Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,Categories__c FROM Idea Where IdeaThemeId in :setClosedId ORDER BY VoteTotal DESC,CreatedDate DESC];
            
            /*if(lstActiveWeekIdea.isempty() && !lstActiveIdea.isempty() && appWrapperObj.ideaLandingPageRequest.IdeasOfTheWeekLimit!='All'){
                List<Idea> lstTempIdea=new List<Idea>();
                Integer Count=0;
                for(Idea i:lstActiveIdea){
                    lstTempIdea.add(i);
                    Count++;
                    if(Count>=3) break;
                }
                lstActiveIdea=lstTempIdea;
            }*/
           ObjIdeaLandingPageResponse.ActiveStatus=False;
           if(!lstActiveWeekIdea.isEmpty() && appWrapperObj.ideaLandingPageRequest.IdeasOfTheWeekLimit!='All'){
                lstIdea=lstActiveWeekIdea;
                //ObjIdeaLandingPageResponse.CampaignTypeForIdeasOfTheWeek='Active';
                ObjIdeaLandingPageResponse.SeeAllLinkForIdeasOfTheWeek=True;
                ObjIdeaLandingPageResponse.ActiveStatus=True;
           }
           else if(!lstActiveIdea.isEmpty() && appWrapperObj.ideaLandingPageRequest.IdeasOfTheWeekLimit!='All'){
                lstIdea=lstActiveIdea;
                //ObjIdeaLandingPageResponse.CampaignTypeForIdeasOfTheWeek='Active';
                ObjIdeaLandingPageResponse.SeeAllLinkForIdeasOfTheWeek=True;
                ObjIdeaLandingPageResponse.ActiveStatus=True;
           }
           else if(!lstClosedIdea.isEmpty() && appWrapperObj.ideaLandingPageRequest.IdeasOfTheWeekLimit!='All'){
                //lstIdea=lstClosedIdea;
                //ObjIdeaLandingPageResponse.CampaignTypeForIdeasOfTheWeek='Closed';
                ObjIdeaLandingPageResponse.SeeAllLinkForIdeasOfTheWeek=True;
           }
           else{
                //ObjIdeaLandingPageResponse.CampaignTypeForIdeasOfTheWeek='None';
                ObjIdeaLandingPageResponse.SeeAllLinkForIdeasOfTheWeek=False;
           }
           
           if(!lstActiveWeekIdea.isEmpty() && appWrapperObj.ideaLandingPageRequest.IdeasOfTheWeekLimit!='All' && lstActiveWeekIdea.size()<4){
           //if(!lstActiveWeekIdea.isEmpty() && appWrapperObj.ideaLandingPageRequest.IdeasOfTheWeekLimit!='All' && appWrapperObj.ideaLandingPageRequest.IdeasOfTheWeekLimit=='4'){     
                //setTempIdea.addAll(lstIdea);
                lstIdea.addAll(lstActiveIdea);
                Set<Idea> setTempIdea=new Set<Idea>(lstIdea);
                lstIdea.clear();
                for(Idea i:setTempIdea){
                    lstIdea.add(i);
                    if(lstIdea.Size()>=4) break;
                }
                //lstIdea.addAll(setTempIdea);
           }
           
           
           ObjIdeaLandingPageResponse.CampaignTypeForIdeasOfTheWeek='None';
           /*if(lstActiveWeekIdea.isEmpty() &&(!lstActiveIdea.isEmpty() || !lstClosedIdea.isEmpty())){
                ObjIdeaLandingPageResponse.CampaignTypeForIdeasOfTheWeek='NoWeek';
           }
           else */
           if(lstActiveIdea.isEmpty()){
                ObjIdeaLandingPageResponse.CampaignTypeForIdeasOfTheWeek='NoActive';
           }
           else if(lstClosedIdea.isEmpty()){
                ObjIdeaLandingPageResponse.CampaignTypeForIdeasOfTheWeek='NoClosed';
           }
           
           if(appWrapperObj.ideaLandingPageRequest.IdeasOfTheWeekLimit=='All'){
                if(!lstActiveIdea.isEmpty()) ObjIdeaLandingPageResponse.ActiveStatus=True;
                lstIdea=[SELECT Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,Categories__c FROM Idea Where IdeaThemeId IN (Select Id FROM IdeaTheme WHERE Status IN ('Closed','Active')) ORDER BY CreatedDate DESC];
                if(!lstIdea.isEmpty()) ObjIdeaLandingPageResponse.SeeAllLinkForIdeasOfTheWeek=True;
           }
           
           if(ObjIdeaLandingPageResponse.SeeAllLinkForIdeasOfTheWeek){
                ObjIdeaLandingPageResponse.IdeasOfTheWeek=getIdeasList(lstIdea);
           }
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_LandingPage : processIdeasOfTheWeek method ', ex);
       } 
       
       return ObjIdeaLandingPageResponse;
    }
    
    /*******************************************************************************************************
    * @description This method is used to get all my updates data.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_IC_WrapperUtility.IdeaLandingPageResponse wrapper
    */
    private static Core_IC_WrapperUtility.IdeaLandingPageResponse processMyUpdates(Core_CA_ApplicationWrapper appWrapperObj){
       Core_IC_WrapperUtility.IdeaLandingPageResponse ObjIdeaLandingPageResponse=new Core_IC_WrapperUtility.IdeaLandingPageResponse(); 
       List<Core_IC_WrapperUtility.MyUpdates> lstMyUpdates = new List<Core_IC_WrapperUtility.MyUpdates>(); 
       List<IdeaTheme> lstIdeaTheme=new List<IdeaTheme>();
       try{
           
            List<IdeaTheme> lstActiveIdeaTheme=[SELECT Description,EndDate,Idea_Themes_Banner__c,Title,Promoted__c,Id FROM IdeaTheme WHERE Status=:'Active' ORDER BY Promoted__c DESC,CreatedDate DESC];
            List<IdeaTheme> lstClosedIdeaTheme=[SELECT Description,EndDate,Idea_Themes_Banner__c,Title,Promoted__c FROM IdeaTheme WHERE Status=:'Closed' ORDER BY Promoted__c DESC,CreatedDate DESC];
            List<Idea> lstIdea=new List<Idea>(); 
            
            Set<Id> setActiveId=new Set<Id>();
            for(IdeaTheme i:lstActiveIdeaTheme){
                setActiveId.add(i.Id);
            }
            Set<Id> setClosedId=new Set<Id>();
            for(IdeaTheme i:lstClosedIdeaTheme){
                setClosedId.add(i.Id);
            }
            List<Idea> lstActiveIdea=[SELECT Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,Categories__c FROM Idea Where CreatedById = :Userinfo.getuserId() and IdeaThemeId in :setActiveId];
            List<Idea> lstClosedIdea=[SELECT Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,Categories__c FROM Idea Where CreatedById = :Userinfo.getuserId() and IdeaThemeId in :setClosedId];
            ObjIdeaLandingPageResponse.SeeAllLinkForMyUpdates=False;
            if(!lstActiveIdea.isEmpty() || !lstClosedIdea.isEmpty()){
                ObjIdeaLandingPageResponse.SeeAllLinkForMyUpdates=True;
            }
            ObjIdeaLandingPageResponse.ActiveStatus=False;
            if(!lstActiveIdea.isEmpty()){
                //lstIdea=lstActiveIdea;
                //ObjIdeaLandingPageResponse.CampaignTypeForIdeasOfTheWeek='Active';
                ObjIdeaLandingPageResponse.SeeAllLinkForIdeasOfTheWeek=True;
                ObjIdeaLandingPageResponse.ActiveStatus=True;
            }
            else if(!lstClosedIdea.isEmpty()){
                //lstIdea=lstClosedIdea;
                //ObjIdeaLandingPageResponse.CampaignTypeForIdeasOfTheWeek='Closed';
                ObjIdeaLandingPageResponse.SeeAllLinkForIdeasOfTheWeek=True;
            }
            else{
                //ObjIdeaLandingPageResponse.CampaignTypeForIdeasOfTheWeek='None';
                ObjIdeaLandingPageResponse.SeeAllLinkForIdeasOfTheWeek=False;
            }
            
            //if(ObjIdeaLandingPageResponse.SeeAllLinkForIdeasOfTheWeek==True){
                if(appWrapperObj.ideaLandingPageRequest.MyUpdatesLimit!='All'){
                    Set<Id> setIdeaId=new Set<Id>();
                    for(Idea i:lstActiveIdea){
                        setIdeaId.add(i.Id);
                    }
                    List<Vote> lstVote=[SELECT CreatedById,CreatedDate,Id,IsDeleted,ParentId,SystemModstamp,Type FROM Vote WHERE CreatedById != :Userinfo.getuserId() AND Parent.Type='Idea' ORDER BY CreatedDate];
                    List<IdeaComment> lstComment=[SELECT CommentBody,CreatedDate,CreatorFullPhotoUrl,CreatorName,IdeaId FROM IdeaComment WHERE IdeaId in:setIdeaId and CreatedById != :Userinfo.getuserId() ORDER BY CreatedDate DESC Limit 5];
                    
                    Set<Id> setUserId=new Set<Id>();
                    for(Vote i:lstVote){
                        setUserId.add(i.CreatedById);
                    }
                    Map<Id,User> mapUserId=new Map<id,User>([SELECT Id,FullPhotoUrl,Name FROM User where Id in:setUserId]);
                    
                    List<Core_IC_WrapperUtility.MyUpdates> lstCombinedMyUpdates = new List<Core_IC_WrapperUtility.MyUpdates>();
                    
                    for(IdeaComment c:lstComment){
                        Core_IC_WrapperUtility.MyUpdates ObjSingleMyUpdates=new Core_IC_WrapperUtility.MyUpdates();
                        ObjSingleMyUpdates.BackgroundImage=c.CreatorFullPhotoUrl;
                        ObjSingleMyUpdates.CreatorName=c.CreatorName;
                        ObjSingleMyUpdates.CreatedDateTime=String.ValueOf(c.CreatedDate);
                        ObjSingleMyUpdates.IdeaId=c.IdeaId;
                        ObjSingleMyUpdates.MyUpdatesType='Comment';
                        lstCombinedMyUpdates.add(ObjSingleMyUpdates);
                    }
                    
                    for(Idea i : lstActiveIdea){
                        for(Vote v:lstVote){
                            if(v.ParentId==i.Id){
                                Core_IC_WrapperUtility.MyUpdates ObjSingleMyUpdates=new Core_IC_WrapperUtility.MyUpdates();
                                ObjSingleMyUpdates.BackgroundImage=mapUserId.get(v.CreatedById).FullPhotoUrl;
                                ObjSingleMyUpdates.CreatorName=mapUserId.get(v.CreatedById).Name;
                                ObjSingleMyUpdates.CreatedDateTime=String.Valueof(v.CreatedDate);
                                ObjSingleMyUpdates.IdeaId=i.Id;
                                ObjSingleMyUpdates.MyUpdatesType='Vote';
                                lstCombinedMyUpdates.add(ObjSingleMyUpdates);
                            }
                        }
                        
                    }
                    //if(!lstCombinedMyUpdates.isempty()) lstCombinedMyUpdates.sort(CreatedDateTime,true);
                    
                    ObjIdeaLandingPageResponse.CampaignTypeForMyUpdates='None';
                    if(lstActiveIdeaTheme.isempty()){
                        ObjIdeaLandingPageResponse.CampaignTypeForMyUpdates='NoActive';
                    }
                    if(!lstActiveIdeaTheme.isEmpty() && lstActiveIdea.isempty()){
                        //lstIdea=lstWeekIdea;
                        ObjIdeaLandingPageResponse.CampaignTypeForMyUpdates='NoIdeas';
                        //ObjIdeaLandingPageResponse.SeeAllLinkForMyUpdates='True';
                   }
                   else if(!lstActiveIdea.isempty() && lstCombinedMyUpdates.isempty()){
                        ObjIdeaLandingPageResponse.CampaignTypeForMyUpdates='NoUpdates';
                        //ObjIdeaLandingPageResponse.SeeAllLinkForMyUpdates='True';
                   }
                   
                   if(!lstCombinedMyUpdates.isempty()) lstCombinedMyUpdates.sort();
                   List<Core_IC_WrapperUtility.MyUpdates> lstFinalCombinedMyUpdates = new List<Core_IC_WrapperUtility.MyUpdates>();
                   for(Core_IC_WrapperUtility.MyUpdates myUpdates:lstCombinedMyUpdates){
                            Core_IC_WrapperUtility.MyUpdates ObjSingleMyUpdates=new Core_IC_WrapperUtility.MyUpdates();
                            ObjSingleMyUpdates.BackgroundImage=myUpdates.BackgroundImage;
                            ObjSingleMyUpdates.CreatorName=myUpdates.CreatorName;
                            decimal Hours = decimal.valueOf((System.now().getTime()-datetime.valueof(myUpdates.CreatedDateTime).getTime())/(1000*60*60));
                            decimal decMinutes = ((System.now().getTime())/1000/60) - ((datetime.valueof(myUpdates.CreatedDateTime).getTime())/1000/60);
                            String strTimeFormat='';
                            if(Hours>=48) strTimeFormat='on '+datetime.valueof(myUpdates.CreatedDateTime).format('dd-MMM-yyyy');//+' at '+i.CreatedDate.format('h:mm a');
                            else if(Hours>=24 && Hours<48) strTimeFormat='yesterday';
                            else if(((Hours>1 ||decMinutes>59)&& Hours!=1) && Hours<24) strTimeFormat=Hours+' hours ago';
                            else if((Hours==1 ||decMinutes>59) && Hours<24) strTimeFormat=Hours+' hour ago';
                            else if(Hours<1 && decMinutes<=59 && decMinutes>1) strTimeFormat=decMinutes+' mins ago';
                            else if(Hours<1 && decMinutes==1) strTimeFormat=decMinutes+' min ago';
                            else if(decMinutes<1) strTimeFormat='just now';
                            ObjSingleMyUpdates.CreatedDateTime=strTimeFormat;
                            ObjSingleMyUpdates.IdeaId=myUpdates.IdeaId;
                            ObjSingleMyUpdates.MyUpdatesType=myUpdates.MyUpdatesType;
                            lstFinalCombinedMyUpdates.add(ObjSingleMyUpdates);
                            if(lstFinalCombinedMyUpdates.size()>=4) break;
                   }
                   ObjIdeaLandingPageResponse.MyUpdates=lstFinalCombinedMyUpdates;
               }
               else if(appWrapperObj.ideaLandingPageRequest.MyUpdatesLimit=='All'){
                    List<Idea> lstIdeaForCurrentUser=[SELECT Body,CreatedDate,CreatorName,CreatorSmallPhotoUrl,Id,IdeaThemeId,Title,VoteTotal,Description__c,NumComments,Categories__c FROM Idea Where CreatedById = :Userinfo.getuserId() AND  IdeaThemeId IN (Select Id FROM IdeaTheme WHERE Status IN ('Closed','Active')) ORDER BY CreatedDate DESC];
                    //system.debug('~~~~'+lstIdea);
                    if(!lstActiveIdea.isEmpty()) ObjIdeaLandingPageResponse.ActiveStatus=True;
                    ObjIdeaLandingPageResponse.IdeasOfTheWeek=getIdeasList(lstIdeaForCurrentUser);
                    //system.debug('@@@@'+ObjIdeaLandingPageResponse);
               }
           //}
       }
       catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_LandingPage : processMyUpdates method ', ex);
       }   
       
       return ObjIdeaLandingPageResponse;
    }
    
    /*******************************************************************************************************
    * @description This method is used to get list of Idea in Wrapper format.
    * @param List<Idea> 
    * @return List<Core_IC_WrapperUtility.IdeasOfTheWeek>
    */
    private static List<Core_IC_WrapperUtility.IdeasOfTheWeek> getIdeasList(List<Idea> ideas){
        List<Core_IC_WrapperUtility.IdeasOfTheWeek> lstIdeasOfTheWeek = new List<Core_IC_WrapperUtility.IdeasOfTheWeek>();
        try{
            Set<Id> setIdeaThemeId=new Set<Id>();
            for(Idea i:ideas){
                setIdeaThemeId.add(i.IdeaThemeId);
            }
            Map<Id,IdeaTheme> mapIdeaTheme=new Map<Id,IdeaTheme>([SELECT Status,Title FROM IdeaTheme WHERE Id in:setIdeaThemeId]);
            Set<Id> setIdeasId=new Set<Id>();
            for(Idea i:ideas){
                setIdeasId.add(i.Id);
            }
            List<Vote> lstVote=[SELECT CreatedById,CreatedDate,Id,IsDeleted,ParentId,SystemModstamp,Type FROM Vote WHERE CreatedById = :Userinfo.getuserId() AND Parent.Type='Idea'];
            
            Map<Id,String> mapVoteId=new Map<Id,String>();
            for(Vote v:lstVote){
                mapVoteId.put(v.ParentId,v.Type);
            }
            for(Idea i : ideas){
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
                    ObjIdeasOfTheWeek.CampaignStatus=mapIdeaTheme.get(i.IdeaThemeId).Status;//i.IdeaTheme.Status;
                    ObjIdeasOfTheWeek.Categories=i.Categories__c;
                    ObjIdeasOfTheWeek.DaysBetween=i.CreatedDate.date().daysBetween(System.now().date());
                    ObjIdeasOfTheWeek.CampaignTitle=mapIdeaTheme.get(i.IdeaThemeId).Title;//i.IdeaTheme.Title;
                    ObjIdeasOfTheWeek.MinutesBetween=decMinutes/1000;
                    lstIdeasOfTheWeek.add(ObjIdeasOfTheWeek);
            }
        }
        catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_IC_LandingPage : getIdeasList method', ex);
        }
        return lstIdeasOfTheWeek;
    }
    
}