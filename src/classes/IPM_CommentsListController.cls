/*****************************************************************
@Description :This class is to store comments as FeedItems and retrieve the textPost and dipslay the 
             top five comments and on click on viewAllComments it needs to add up five more to the list. 
             
@Created Date: 12/03/2015
@Author: Cognizant
@Justification: Without Shairing required as this is a Feed Object Class used for Posting Deleting Viewing Feed Items
@Referenced: IPMCommentsPage page
******************************************************************/

global without sharing class IPM_CommentsListController {
        
    public String parentID {get;set;}//used to store current page id
    public FeedItem commentRecord {get;set;}//used to store feedItem's comment record
    public List<FeedItem> comments{get;set;}//used to store feedItem's comment
    public List<FeedItem> listComments;//used to store list of feed items comment
    public List<FeedItem> innerComments = new List<FeedItem>();//used to store feed item's inner comment list
    public Id commentsID{get;set;}//used to store commments id
    public integer offsetVal=0;//used to store offset value
    public List<WrapperFeedItemPhoto> wrapperComments{get;set;}//used to store wrapper comments list from WrapperFeedItemPhoto class 
    public integer countOfComments {get;set;}//used to store count of comments
    public IPM_Project_Document_Section__c projDocSec{get; set;}//used to store query result from IPM_Project_Document_Section__c object
    public boolean isMoreThanFive;//boolean variable
    public boolean isCommentEditable{get;set;}//boolean variable to set comment input text readonly 
    private static final String CLASS_NAME = IPM_CommentsListController.class.getName(); //Class Name for Exception Logging
    private static final string ADD_COMMENT = 'AddComment';
    
    /*****************************************************************
    @Description :This is the constructor for this class
    @Created Date: 12/03/2015
    @Author: Cognizant
    @Referenced: IPMCommentsPage page
    ******************************************************************/
         
    public IPM_CommentsListController (){
        isMoreThanFive=false;// this is used in the IPMCommentsPage VF page to handle UI requirements
        isCommentEditable = true;
        commentRecord = new FeedItem();
        comments = new List<FeedItem>();
        //To read the project document section Id from the URL
        if(ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID) != null){ 
            parentID = ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);  
            projDocSec=[SELECT Id,IPM_Project_Document__r.IPM_Project__r.IPM_PrepareForArchival__c , IPM_Project_Document__r.IPM_Project__r.Is_Archieved__c   FROM IPM_Project_Document_Section__c WHERE Id=:parentID];
            if(projDocSec.IPM_Project_Document__r.IPM_Project__r.IPM_PrepareForArchival__c ||projDocSec.IPM_Project_Document__r.IPM_Project__r.Is_Archieved__c )   
            { 	
            	isCommentEditable = false;
            }     
        	onLoadComments();
        }
        
        if(parentID!=null && IPM_ConstantUtils.EMPTY_STRING_INITIAL != parentID){
                countOfComments=[Select Count() from FeedItem where ParentId =: parentID and type =:IPM_ConstantUtils.COMMENT_TYPE];
        }
     }
    /*****************************************************************
    @Description :Add a new feedItem as a comment to the project document section
    @Created Date: 12/03/2015
    @Author: Cognizant
    @Referenced: IPMCommentsPage page
    ******************************************************************/ 
        
    public void AddComment(){
        
        if(commentRecord.Body.length() > 0){
            List<FeedItem> insertCommentsList=new List<FeedItem>();
            FeedItem insertComments = new FeedItem();
            insertComments.Body= commentRecord.Body;
            insertComments.ParentId= parentID;
            insertCommentsList.add(insertComments);
            try{
                if((insertComments.Body).length()>5000){
                    Apexpages.addmessage(new apexpages.message(apexpages.severity.info,System.Label.IPM_Data_Value_Too_Large));
                }
                else{
                        if(insertCommentsList != null && !insertCommentsList.isEmpty()){
                        	insert insertCommentsList;
                        }
                } 
                onLoadComments();
                getCommentsWrapper();
            }
            catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,ADD_COMMENT,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
                string msg=ex.getmessage(); 
                if(msg.contains(System.Label.IPM_Data_Value_Too_Large)){           
                    Apexpages.addmessage(new apexpages.message(apexpages.severity.info,System.Label.IPM_Data_Value_Too_Large));
                }
            }
                               
                countOfComments=[SELECT Count() FROM FeedItem WHERE ParentId =: parentID and type =:IPM_ConstantUtils.COMMENT_TYPE];
                projDocSec=[SELECT Id,IPM_Count_of_Comments__c FROM IPM_Project_Document_Section__c WHERE Id=:parentID];
                projDocSec.IPM_Count_of_Comments__c=countOfComments;
                
                try{
                        update projDocSec;// update the project documetn section record for the counts of commens
                 }
                 catch(Exception ex){
                     Apexpages.addmessage(new apexpages.message(apexpages.severity.error,ex.getmessage()));
                     
                     ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,ADD_COMMENT,ex.getMessage(),ex, 'Error', null, null, null,null);
                 }
        } 
    }
    
    /*****************************************************************
    @Description :It add the comments to a list which will be used in the wrapperclass to display the 
    records on load and on click of ViewOherComments
    @Created Date: 12/03/2015
    @Author: Cognizant
    @Referenced: IPMCommentsPage page
    ******************************************************************/   
          
    public void onLoadComments(){     
        listComments = new List<FeedItem>();
        listComments =[SELECT id, body,CreatedBy.name,CreatedDate,ParentId,InsertedById 
        						  FROM FeedItem 
        						  WHERE ParentId =: parentID 
        						  AND type =:IPM_ConstantUtils.COMMENT_TYPE 
                       			  ORDER BY CreatedDate DESC 
                       			  LIMIT 5 OFFSET :offsetVal];
        countOfComments=listComments.size();
        for(integer i=0; i<listComments.size(); i++){
            innerComments.add(listComments.get(i));
        }
        comments=innerComments;
        offsetVal =offsetVal +5; 
    }
    
    /*****************************************************************
    @Description :On click of delete , the corresponding feedItem should get deleted, for which we are passing the
    FeedItem id as a param from the page
    @Created Date: 12/03/2015
    @Author: Cognizant
    @Referenced: IPMCommentsPage page
    ******************************************************************/   

    public void doDelete(){
        List<FeedItem> DelComment = new List<FeedItem>();
        if(commentsID != null){
            DelComment =[Select id from FeedItem where id=:commentsID limit 1];            
            if(DelComment != null && !DelComment.isEmpty()){
                try{
                    delete DelComment;
                    countOfComments=[SELECT Count() FROM FeedItem WHERE ParentId =: parentID and type =:IPM_ConstantUtils.COMMENT_TYPE];
                    projDocSec=[SELECT Id,IPM_Count_of_Comments__c FROM IPM_Project_Document_Section__c WHERE Id=:parentID];
                    projDocSec.IPM_Count_of_Comments__c=countOfComments;
                    update projDocSec;
                }
                catch (Exception ex){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.IPM_Generic_ErrorMessage )); 
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,'doDelete',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
                }
           }
        }
     }
     
    /*****************************************************************
    @Description :Introduced wrapper just for the smallPhotoUrl, As we don't have an option to
    query the smallPhotoUrl directly from the FeedItem object
    @Created Date: 12/03/2015
    @Author: Cognizant
    @param: Not Applicable
    @return:list of WrapperFeedItemPhoto
    @Referenced: IPMCommentsPage page
    ******************************************************************/  

    public List<WrapperFeedItemPhoto> getCommentsWrapper(){
        
        String smallphotoUrl=null;
        wrapperComments = new List<WrapperFeedItemPhoto>();
        Set<Id> setUserId = new Set<Id>();
        for(FeedItem feed:comments){
                setUserId.add(feed.InsertedById);
        }
        //SOQL moved outside for loop which will be fired only once. 
        Map<Id, User> mapIdWithUser = new Map<Id, User>([SELECT id,Name,SmallPhotoUrl,FullPhotoUrl FROM User WHERE Id IN : setUserId]);
        for(FeedItem feed:comments){
            User usr=mapIdWithUser.get(feed.InsertedById);
            if( usr!= null){
                smallphotoUrl =usr.SmallPhotoUrl;
            }
            wrapperComments.add(New WrapperFeedItemPhoto(feed,smallphotoUrl)); 
        }
        return wrapperComments;
    }
     
    /*****************************************************************
    @Description :Declaration of a inner wrapper class and binding the FeeItem record
    and smallphotoUrl to wrapperclass list variable
    @Created Date: 12/03/2015
    @Author: Cognizant
    @Referenced: IPMCommentsPage page
    ******************************************************************/      
 
    public class WrapperFeedItemPhoto{
        
        public FeedItem feedItem{get;set;}
        public String smallphotoUrl{get;set;}
        
        public WrapperFeedItemPhoto(FeedItem f, String small){
            
            feedItem = f;
            smallphotoUrl = small;
        }
    }
}