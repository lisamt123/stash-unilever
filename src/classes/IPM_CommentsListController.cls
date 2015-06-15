/** Created By : Pratyusha Penugondla
***** Purpose  :To get the top ten recent comments related to the parent object 
***Description :This class is to store comments as FeedItems and retrieve the textPost and dipslay the 
                top five comments and on click on viewAllComments it needs to add up five more to the list. 
                we can remove the wrapper class usage if we get an alternative to query the smallphorourl
                directly from the FeedItem object.
==================================================================================****/

Global class IPM_CommentsListController {

    // Getters , setter 

    Public String ParentID {get;set;}
    public FeedItem CommentRecord {get;set;}
    Public List<FeedItem> comments{get;set;}
    Public List<FeedItem> Listcomments;
    Public List<FeedItem> innerComments = new List<FeedItem>();
    public Id CommentsID{get;set;}
    Public integer offsetVal=0;
    Public List<WrapperFeedItemPhoto> wrapperComments{get;set;}
    public integer countOfComments {get;set;}
    public IPM_Project_Document_Section__c projDocSec{get; set;}
    public boolean isMoreThanFive;
    //Constructor 
    Public IPM_CommentsListController ()
    {
        isMoreThanFive=false;
        CommentRecord = new FeedItem();
        comments = new List<FeedItem>();
        //To read the project document section Id from the URL
        if(ApexPages.currentPage().getParameters().get('Id') != null)
        {
            ParentID = ApexPages.currentPage().getParameters().get('Id');          
        }
        onLoadComments();
        countOfComments=[Select Count() from FeedItem where ParentId =: ParentID and type ='TextPost'];
     }

    //Add a new feedItem as a comment to the project document section
    public void AddComment()
    {
        system.debug(CommentRecord.Body.length()+'Body Length');
        if(CommentRecord.Body.length() > 0)
        {
            FeedItem insertComments = new FeedItem();
            insertComments.Body= CommentRecord.Body;
            insertComments.ParentId= ParentID;
            try
            {
                if((insertComments.Body).length()>5000){
                 Apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Data value too large'));
              
                }else
                insert insertComments; 
                onLoadComments();
                getCommentsWrapper();
            }
            catch(Exception ex)
            {
                string msg=ex.getmessage(); 
                if(msg.contains('data value too large')){           
                Apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Data value too large'));
                }
               // ApexPages.addMessages(msg);
            }
       Listcomments =[SELECT id, body,CreatedBy.name,CreatedDate,ParentId,InsertedById from FeedItem where ParentId =: ParentID and type ='TextPost' ORDER BY CreatedDate DESC limit 5 OFFSET :offsetVal];
        
        countOfComments=[Select Count() from FeedItem where ParentId =: ParentID and type ='TextPost'];
        
        projDocSec=[Select Id,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where Id=:ParentID];
        projDocSec.IPM_Count_of_Comments__c=countOfComments;
        
        update projDocSec;
        
         System.debug(countOfComments+'Count'+projDocSec+'Count of Comments');   
        } 
        
    }
     
    
    //It add the comments to a list which will be used in the wrapperclass to display the 
    // records on load and on click of ViewOherComments
    public void onLoadComments() 
    {     
        
        Listcomments = new List<FeedItem>();
        Listcomments =[SELECT id, body,CreatedBy.name,CreatedDate,ParentId,InsertedById from FeedItem where ParentId =: ParentID and type ='TextPost' ORDER BY CreatedDate DESC limit 5 OFFSET :offsetVal];
        
        countOfComments=Listcomments.size();
        
        for(integer i=0; i<Listcomments.size(); i++)
        {
            innerComments.add(Listcomments.get(i));
        }
        comments=innerComments;
        offsetVal =offsetVal +5; 
        
    }
    


    // On click of delete , the corresponding feedItem should get deleted, for which we are passing the 
    // FeedItem id as a param from the page.
    public void doDelete()
    {
        List<FeedItem> DelComment = new List<FeedItem>();
        if(CommentsID != null)
        {
           DelComment =[Select id from FeedItem where id=:CommentsID limit 1];
            if(DelComment.size()>0)
            {
                try
                 {
                    delete DelComment;
                    Listcomments =[SELECT id, body,CreatedBy.name,CreatedDate,ParentId,InsertedById from FeedItem where ParentId =: ParentID and type ='TextPost' ORDER BY CreatedDate DESC limit 5 OFFSET :offsetVal];
        
        countOfComments=[Select Count() from FeedItem where ParentId =: ParentID and type ='TextPost'];
        projDocSec=[Select Id,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where Id=:ParentID];
        projDocSec.IPM_Count_of_Comments__c=countOfComments;
        update projDocSec;
                 }
                 catch (Exception e)
                   {
                      
                   }
                
            }
        }
     }

    // Introduced wrapper just for the smallPhotoUrl, As we don't have an option to
    //query the smallPhotoUrl directly from the FeedItem object.
    Public List<WrapperFeedItemPhoto> getCommentsWrapper()
    {
        String uId;
        string smallphotoUrl;
        wrapperComments = new List<WrapperFeedItemPhoto>();
        For(FeedItem feed:comments)
        {
            uId = feed.InsertedById;
            User usr=[Select id,Name, SmallPhotoUrl, FullPhotoUrl From User where Id=:uId];
            smallphotoUrl =usr.SmallPhotoUrl;
            wrapperComments.add(New WrapperFeedItemPhoto(feed,smallphotoUrl)); 
        }
         return wrapperComments;
     }
     
     
    // Declaration of a wrapper class and binding the FeeItem record
    // and smallphotoUrl to wrapperclass list variable
    public class WrapperFeedItemPhoto
    {

        Public FeedItem feedItem{get;set;}
        Public String smallphotoUrl{get;set;}
        
        Public WrapperFeedItemPhoto(FeedItem f, String small)
        {
            feedItem = f;
            smallphotoUrl = small;
        }
    }

}