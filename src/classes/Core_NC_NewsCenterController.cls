/*
  Class Name: Core_NC_NewsCenterController
  Author : Mindtree
  Date: 21 Sept 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Common controller class for NewsApp
*/ 
 
public class Core_NC_NewsCenterController {
    
    /*******************************************************************************************************
    * @description This method get the wrapper data for Global News from helper and send to the Client.
    * @param String NewsType
    * @return List<Core_NC_NewsWrapperClass> wrapper
    */     
    @AuraEnabled
    public static List<Core_NC_NewsWrapperClass> getGlobalNewsForMostRecent(String NewsType) {
        return Core_NC_NewsCenterControllerHelper.getGlobalNewsForMostRecent(NewsType);
    }
    
    /*******************************************************************************************************
    * @description This method get the wrapper data for Trending News from helper and send to the Client.
    * @param String NewsType,String SortType
    * @return List<Core_NC_NewsWrapperClass> wrapper
    */  
    @AuraEnabled
    public static List<Core_NC_NewsWrapperClass> getTrendingNews(String NewsType,String SortType) {
        return Core_NC_NewsCenterControllerHelper.getTrendingNews(NewsType,SortType);
    }
    
    /*******************************************************************************************************
    * @description This method get the wrapper data for News Detail from helper and send to the Client.
    * @param String NewsId
    * @return List<Core_NC_NewsWrapperClass> wrapper
    */    
    @AuraEnabled
    public static Core_NC_NewsDetailWrapperClass getNewsDetail(String NewsId) {
        return Core_NC_NewsCenterControllerHelper.getNewsDetail(NewsId);
    }
    
    /*******************************************************************************************************
    * @description This method insert like to NewsArticleLike Object
    * @param String NewsId
    * @return Boolean
    */  
    @AuraEnabled   
    public static Integer putLikeForNews(String NewsId) {
        return Core_NC_NewsCenterControllerHelper.putLikeForNews(NewsId);
    }
    
    /*******************************************************************************************************
    * @description This method post feed to Group on click of share
    * @param String NewsTitle,String NewsLink,String FeedBody,String FeedTo,String GroupNames
    * @return String
    */  
    @AuraEnabled   
    public static Boolean postNewsToChatter(String NewsTitle,String NewsLink,String FeedBody,String FeedTo,String GroupNames) {
        system.debug('~~~~'+GroupNames+','+FeedTo);
        return Core_NC_NewsCenterControllerHelper.postNewsToChatter(NewsTitle,NewsLink,FeedBody,FeedTo,GroupNames);
    }
    
    /*******************************************************************************************************
    * @description This method used to get Group names based on User inputted Text
    * @param String GroupName
    * @return List<String>
    */ 
    @AuraEnabled 
    public static String getGroupNames() {//String GroupName
        return Core_NC_NewsCenterControllerHelper.getGroupNames();//GroupName
    }
    
    /*******************************************************************************************************
    * @description This method used to get information needed for GA
    * @param 
    * @return Core_NC_NewsGAWrapperClass 
    */ 
    @AuraEnabled 
    public static Core_NC_NewsGAWrapperClass getGAInfo() {//String GroupName
        return Core_NC_NewsCenterControllerHelper.getGAInfo();
    }
    
    /*******************************************************************************************************
    * @description This method get the wrapper data for News Detail from helper and send to the Client.
    * @param Core_NC_NewsWrapperClass NewsType
    * @return List<Core_NC_NewsWrapperClass> wrapper
    */      
    /*@AuraEnabled
    public static List<Core_NC_NewsWrapperClass> getNewsDetail(Core_NC_NewsWrapperClass NewsType) {
        return Core_NC_NewsCenterControllerHelper.getNewsDetail(NewsType);
    } */  
}