/*Controller Class for ChatterGroupFeed VF page*/
/*Created on 2-Feb-2014*/

public  with sharing class ChatterGroupFeedController {
  
   public boolean bol_grp_member_message {get; set;} //This stores the boolean if user is member of group or now
   public string announcementBody {get; set;}        //mindtree added on 3/7/2014 descrption:This stores the Announcementpost body  
   public boolean longAncmtBody {get;set;}           //mindtree added on 3/7/2014 descrption:This stores the Announcementpost body(long length)
   public string groupId {get;set;}                  //mindtree added on 3/7/2014 descrption:This stores the Group Id of any Collaboration group.
   public String strAncmtCreatedDate{get;set;}       //mindtree added on 3/7/2014 descrption:This stores the created date of the Announcement. 
   public boolean isAnnouncement {get; set;}         //mindtree added on 3/7/2014 descrption: Boolean value to decide to display announcement or not.
   public integer commentCount{get;set;}             //mindtree added on 3/7/2014 descrption:This stores the Comment count of the Announcement. 
   public Id feedItemId {get;set;}                   //mindtree added on 3/7/2014 
   
   
   /*Author:Mindtree
    Date:3/7/2014
    Description: Display The announcement post on Visualforce Page. */ 
    
    public ChatterGroupFeedController (ApexPages.StandardController controller) {
        groupId = ApexPages.currentPage().getParameters().get('groupId'); 
        announcementDetail();      
    }
    
    
    //Retrive Announcment Details  
    public Void announcementDetail(){ 
        
        longAncmtBody = false; 
        isAnnouncement=false;
        
        List<CollaborationGroup> list_ColGroup=new List<CollaborationGroup> ([SELECT AnnouncementId FROM CollaborationGroup WHERE Id =:GroupId]);
        
        if(list_ColGroup.size()>0)
        if( list_ColGroup[0].AnnouncementId  != null ){
            Announcement list_announcement=[SELECT ExpirationDate,FeedItemId,CreatedDate FROM Announcement WHERE Id =: list_ColGroup[0].AnnouncementId ];
            
            if(list_announcement.ExpirationDate.AddDays(1) > DateTime.Now() ){
                //Format Announcement Body.       
                isAnnouncement=true;
                feedItemId =list_announcement.FeedItemId;
                FeedItem list_feeditem=[SELECT Body,CommentCount FROM FeedItem WHERE id =: list_announcement.FeedItemId];           
                announcementBody =list_feeditem.Body;
                
                if(announcementBody.length()>140){
                    announcementBody = announcementBody.Substring(0, 137)+'...';
                    longAncmtBody = true; 
                }
                
                //Format Announcement Created date 
                strAncmtCreatedDate=list_announcement.CreatedDate.format('dd MMMM yyyy \'at\' '+'HH:mm');     
                
                commentCount=list_feeditem.CommentCount;
            }
        }
    }
    
    /* ------------- end------------ */
    
   
    public void displayMessages() {
        
        bol_grp_member_message=true;
        
        String strGroupId=ApexPages.currentPage().getParameters().get('groupId');
        List<CollaborationGroup> list_group=new List<CollaborationGroup>([SELECT Id, CollaborationType, Name FROM CollaborationGroup WHERE Id =:strGroupId]);
        if(list_group.size()>0)
        If (list_group[0].CollaborationType != 'Public') {
            List<CollaborationGroupMember> objMemberIds=new List<CollaborationGroupMember>([SELECT MemberId FROM CollaborationGroupMember WHERE CollaborationGroupId =:strGroupId AND MemberId=:Userinfo.getuserid()]);
            if(objMemberIds.size()==0){
                bol_grp_member_message=false;
                isAnnouncement=false;
                string Url_Group = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+strGroupId;               
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, '<b>' +list_group[0].name+ '</b> is a Private Chatter Group. To view the news feed, kindly join the group on<font size="2.5"><b><a href="'+Url_Group+'">Chatter.</a></b></font>' ));
            }
        }
    }  
}