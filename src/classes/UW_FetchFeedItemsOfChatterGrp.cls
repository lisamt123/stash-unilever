/*********************************************************************************************************
Class Name      :       uw_FetchFeedItemsOfChatterGrp 
Class Desc.     :       Controller class which is called in class 'uw_BrandExperienceController'
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
                                                       
**********************************************************************************************************/
public without sharing class UW_FetchFeedItemsOfChatterGrp {


    /**Below method fetches the feed items of a chatter group based on the chatter group id **/ //**T0** Added comments
    public static List<FeedItem> getFeedItems(Id parentId){
    List<Feeditem> listOfFi= new List<Feeditem>();
    
    try{                            //***T0** Added try catch block
    listOfFi=[select id,RelatedRecordId from Feeditem where ParentId=:parentId limit 1000];    
    }
    catch(Exception e){}
    return listOfFi;
    }
}