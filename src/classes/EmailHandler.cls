public class EmailHandler
{
    //To check the parent id type 
    Schema.SObjectType newsArticleType = Schema.News_Article__c.sObjectType;
    
    //List to store the mails
    List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
    
    //Get the base url of organization and appending it to UserId
    String strRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' +UserInfo.getUserId();    
    
    //method to send mails after putting post on newsarticle                 
    Public Void FeedItemEmailHandler(List<FeedItem> lstFeed) { 
        try{ 
            for(FeedItem item:lstFeed){
                
                //checkingnews article type
                if(item.ParentId.getSobjectType() == newsArticleType && item.Type!='PollPost' && item.Type!='RypplePost'){
                    List<News_Article__c> lstArticle=[SELECT Name,Sharepoint_URL__c,Site_Type__c,Admin_Chatter_Group__c FROM News_Article__c WHERE Id=:item.ParentId];
                    
                    if(lstArticle[0].Site_Type__c =='News Centre'){
                        //Null check for lstArticle
                        string strArticlename;
                        if(lstArticle.size()>0)
                        strArticlename=lstArticle[0].name;
                        
                        //cretaes mail object       
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                        //Fetch News Rover User Id based on Custom Setting FeedItem_Email
                        String[] to_Address = new String[] {lstArticle[0].Admin_Chatter_Group__c};
                        List<User> lst_News_Centre_User = [select id from User where Email =:to_Address LIMIT 1];         
                        
                        If (lst_News_Centre_User.size()>0){            
                            mail.setTargetObjectId(lst_News_Centre_User[0].Id);
                            mail.setSaveAsActivity(false);             
                        } 
                        else {
                            String[] toAddresses = new String[] {lstArticle[0].Admin_Chatter_Group__c };
                            mail.setToAddresses(toAddresses);             
                        }                      
                        mail.setSubject('Post On News Article' );
                        
                        //checking the type of post and setting email body 
                        if( item.Type=='TextPost' ){
                            mail.setHtmlBody
                            ('-------------------------------------------------------------<br/><br/>'+'A new Post has been submitted to the News Centre.<br/><br/> ' + 'The Post was posted on the following article:<br/>' +
                            '<a href='+lstArticle[0].Sharepoint_URL__c+'>'+strArticlename+'</a>'+'<br/>'+'Posted by   '+ '<a href='+strRecordURL +'>'+UserInfo.getname()+'</a>'+'<br/>'+'"'+item.body+'"'+'<br/><br/>'+'-------------------------------------------------------------');                 
                        }else if( item.Type =='LinkPost' ){
                            mail.setHtmlBody
                            ('-------------------------------------------------------------<br/><br/>'+'A new Link has been submitted to the News Centre.<br/><br/> ' + 'The Link was posted on the following article:<br/>' +
                            '<a href='+lstArticle[0].Sharepoint_URL__c+'>'+strArticlename+'</a>'+'<br/>'+'Posted by   '+ '<a href='+strRecordURL +'>'+UserInfo.getname()+'</a>'+'<br/>'+'"'+'<a href='+item.LinkUrl+'>'+item.Title +'</a>' +'"'+'<br/>'+'-------------------------------------------------------------');
                        }
                        lstMails.add(mail);
                        
                    }
                    
                    else if(lstArticle[0].Site_Type__c =='MCO'){
                        feeditem fdItem=[SELECT CreatedById,Createdby.name FROM FeedItem where id=:item.id limit 1];
                        string strBody='A new Post has been created by '+fdItem.CreatedBy.name+' with the below mentioned content:'+'\n'+'"'+item.Body+'"';
                        List<FeedItem> lstfdItm=new List<FeedItem>();
                      
                        if(lstArticle[0].Admin_Chatter_Group__c !=null && lstArticle[0].Admin_Chatter_Group__c !=''){
                            for(string strGrpId:lstArticle[0].Admin_Chatter_Group__c.split(',')){
                                if(strGrpId != '' && strGrpId != null){
                                    List<CollaborationGroup> lstColbGrp=[SELECT Id FROM CollaborationGroup WHERE Id =:strGrpId];
                                    if(!lstColbGrp.isempty()){
                                        FeedItem fdItm=new FeedItem( Type = 'LinkPost', Body = strBody, ParentId = lstColbGrp[0].Id,LinkURL = lstArticle[0].Sharepoint_URL__c, Title = lstArticle[0].Name,CreatedById = CORE_NEWS_ARTICLE__c.getInstance('NEWS_ARTICLE_AVATAR_USER').Text_Value__c);
                                        lstfdItm.add(fdItm);
                                    }
                                }   
                            }
                        }
                        
                        if(!lstfdItm.isEmpty())
                        Database.insert(lstfdItm,false);
                    }
                }
                
            }
            if(!lstMails.isempty()) Messaging.sendEmail(lstMails);
        }
        catch(Exception e){ System.debug('The following exception has occurred: ' + e.getMessage()); }
    }
    
    

    //method to send mails after comments on newsarticle
    public void FeedCommentEmailHandler(List<FeedComment> lstComment){
        try{
            for(FeedComment item:lstComment){
                if(item.ParentId!=null){
                    
                    //checkingnews article type     
                    if(item.ParentId.getSobjectType() == newsArticleType){
                        
                        //to get the article name
                        List<News_Article__c> lstArticle=[SELECT Name,Sharepoint_URL__c,Site_Type__c,Admin_Chatter_Group__c FROM News_Article__c WHERE Id=:item.ParentId];
                        if(lstArticle[0].Site_Type__c =='News Centre'){
                            //Null check for ltsArticle          
                            string strArticlename;
                            if(lstArticle.size()>0)
                            strArticlename=lstArticle[0].name;

                            //To send the  Email
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            
                            //Fetch News Rover User Id based on Custom Setting FeedItem_Email
                            String[] to_Address = new String[] {lstArticle[0].Admin_Chatter_Group__c};
                            List<User> lst_News_Centre_User = [select id from User where Email =:to_Address LIMIT 1];   
                            
                            //setting to address and Bcc Address  from custom setting value
                            If (lst_News_Centre_User.size()>0){            
                                mail.setTargetObjectId(lst_News_Centre_User[0].Id);
                                mail.setSaveAsActivity(false);             
                            } 
                            else {
                                String[] toAddresses = new String[] {lstArticle[0].Admin_Chatter_Group__c };
                                mail.setToAddresses(toAddresses);             
                            }                      
                            mail.setSubject('Comments On News Article' );
                            mail.setHtmlBody
                            ('-------------------------------------------------------------<br/><br/>'+'A new Post has been submitted to the News Centre.<br/><br/> ' + 'The comment was posted on the following article:<br/>' +
                            '<a href='+lstArticle[0].Sharepoint_URL__c+'>'+strArticlename+'</a>'+'<br/>'+'Posted by   '+ '<a href='+strRecordURL+'>'+UserInfo.getName()+'</a>'+'<br/>'+'"'+item.commentbody+'"'+'<br/><br/>'+'-------------------------------------------------------------');
                            
                            lstMails.add(mail);
                        }
                        else if(lstArticle[0].Site_Type__c =='MCO'){
                            feedcomment fdItem=[SELECT CreatedById,Createdby.name FROM Feedcomment where id=:item.id limit 1];
                            string strBody='A new Comment has been created by '+fdItem.CreatedBy.name+' with the below mentioned content:'+'\n'+'"'+item.CommentBody+'"' ;
                            List<FeedItem> lstfdItm=new List<FeedItem>();
                         
                            if(lstArticle[0].Admin_Chatter_Group__c !=null && lstArticle[0].Admin_Chatter_Group__c!=''){
                                for(string strGrpId:lstArticle[0].Admin_Chatter_Group__c.split(',')){
                                    if(strGrpId != '' && strGrpId != null){
                                        List<CollaborationGroup> lstColbGrp=[SELECT Id FROM CollaborationGroup WHERE Id =:strGrpId];
                                        if(!lstColbGrp.isempty()){
                                            FeedItem fdItm=new FeedItem( Type = 'LinkPost', Body = strBody, ParentId = lstColbGrp[0].Id,LinkURL = lstArticle[0].Sharepoint_URL__c, Title = lstArticle[0].Name,CreatedById = CORE_NEWS_ARTICLE__c.getInstance('NEWS_ARTICLE_AVATAR_USER').Text_Value__c);
                                            lstfdItm.add(fdItm);
                                        }
                                    }   
                                }
                            }
                            
                            if(!lstfdItm.isEmpty())
                            Database.insert(lstfdItm,false);
                        }
                    }
                }
            }
            if(!lstMails.isempty()) Messaging.sendEmail(lstMails);
        } 
        catch(Exception e){ System.debug('The following exception has occurred: ' + e.getMessage()); }  
    }
    
}