/*********************************************************************************************************
Class Name      :       uw_FetchFeedItems
Class Desc.     :       Controller class which is called in class 'uw_BrandExperienceController & uw_ModifyAssetController'
Author          :       Accenture India

Change History
********************************************************************************************************
Date          Author       version             Description                       Requested By       Tag
---------------------------------------------------------------------------------------------------------
04-Apr-2014    IDC          1.00               This is the controller written      Unilever          NA
                                               to fetch feed items of a Chatter 
                                               group based its id     
                                     
12-May-2014    IDC          1.01               Changes done as fix to issues                         T0
                                               raised by Novasuit run                                    
                                               
21-May-2014    IDC          1.02               Changes done as fix to issues                         T0
                                               related to uw_ModifyAssetController                                                                                      
**********************************************************************************************************/
public without sharing class uw_FetchFeedItems{
     public id value{get;set;}

/**Method Name  : getFeedItemsOfChatterGroup
   Description  : Below method fetches the feed items of a chatter group based on the chatter group id 
   Exception    : Exception e
   ReturnType   : List<FeedItem>
   Parameter    : Id parentId
   T0 Added comments */
   
    public static List<FeedItem> getFeedItemsOfChatterGroup(Id parentId){
        List<Feeditem> listOfFi= new List<Feeditem>();
        try{                //T0 Added try catch block
            listOfFi=[select id,RelatedRecordId from Feeditem where ParentId=:parentId limit 1000];    
           }
        catch(Exception e){}
    return listOfFi;
    }
    
/**Method Name  : fetchFeedOfBet
   Description  : Below method fetches the feed items of a bet based on the bet id 
   Exception    : Exception e
   ReturnType   : List<FeedItem>
   Parameter    : id value
   T1 Added comments */
   
    public static list<FeedItem> fetchFeedOfBet(id value){
        List<FeedItem> feedsOfBet = new List<FeedItem>();
        try{
            feedsOfBet = [Select Id,ParentId,RelatedRecordId from FeedItem where ParentId=:value];
           }
        catch(Exception e){
           }
        return feedsOfBet;
    }
} // **********T1*************