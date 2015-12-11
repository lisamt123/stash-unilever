/*===========================================================================
  Name:  WINatPOSMovePostsToInternalBatchable                                                       
  Copyright notice:                                                          
  ===========================================================================
  ===========================================================================
   Purpose: WINatPOSMovePostsToInternalBatchable class used to move all posts
   on external chatter group to internall
  -------                                                                    
  ===========================================================================
  ===========================================================================
  History                                                                   
  -------                                                                   
  VERSION  AUTHOR           DATE              DETAIL          RELEASE/CSR   
   1.0 -  Karol Szepietowski   24/11/2015      INITIAL DEVELOPMENT               
  ===========================================================================*/

global with sharing class WINatPOSMovePostsToInternalBatchable implements Database.Batchable<sObject>{

	global Database.QueryLocator start(Database.BatchableContext BC){
      WinAtPOSRemoteActions__c  remotActionConf=WinAtPOSRemoteActions__c.getValues('WinAtPOSRemoteActionConf');  
      String winAtPosGroup=remotActionConf != null ? remotActionConf.WinAtPosGroup__c :'';
      if(System.Test.isRunningTest()){
            winAtPosGroup=WinAtPOSUtil.winAtPostChatterGroupForTest;
      }
        
	  List<CollaborationGroup> colGroup=[SELECT Id From CollaborationGroup where name =: winAtPosGroup and NetworkId != null limit 1];
      Id extentalGlobalWinAtPostID = colGroup.isEmpty() ? null:	colGroup .get(0).Id;
      String visibility ='AllUsers';
      String networkScope = 'AllNetworks';  
      return Database.getQueryLocator('select Body, ContentData, ContentDescription, ContentFileName,CreatedById, CreatedDate, LinkUrl, Title,ParentID, Type,CreatedBy.Name,Id from FeedItem Where Visibility =:visibility and NetworkScope =:networkScope and CreatedDate>=Yesterday order by CreatedDate ASC');
   }
    
    /*******************************************************************
    Purpose: Processing FeedItems which should be mentioned to internal 
             WinAtPOS group
    Returns: void 
    ********************************************************************/
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('Executing execute method from batch for following list of items:'+scope);
        WinAtPOSRemoteActions__c  remotActionConf=WinAtPOSRemoteActions__c.getValues('WinAtPOSRemoteActionConf');  
      	String winAtPosGroup=remotActionConf != null ? remotActionConf.WinAtPosGroup__c :'';
      	if(System.Test.isRunningTest()){
            winAtPosGroup=WinAtPOSUtil.winAtPostChatterGroupForTest;
      	}
        
	  	List<CollaborationGroup> colGroup=[SELECT Id From CollaborationGroup where name =: winAtPosGroup and NetworkId = null limit 1];
      	Id internalGlobalWinAtPostID = colGroup.isEmpty() ? null:colGroup .get(0).Id;
        
        List<FeedItem> feedsToInsert = new List<FeedItem>();
        Map<Id,String> ogrinalPostUsersAccount = new Map<Id,String>();
        Set<String> fieldsToClone = new Set<String>{'Title', 'Type','ContentData', 'ContentDescription', 'ContentFileName','CreatedById','CreatedDate','LinkUrl'};
        for(FeedItem item : (List<FeedItem>)scope){
        	//feedsToInsert.add(item.clone(false,true));
        	/*
        	FeedItem newFeedItem = new FeedItem();
            for(String field : fieldsToClone){
                newFeedItem.put(field,item.get(field));
            }
            newFeedItem.ParentId=internalGlobalWinAtPostID;
            newFeedItem.Body = removeHtml(item.Body);
            if(!newFeedItem.Body.containsIgnoreCase('@'+winAtPosGroup)){
                //add only feeds mentioned to group
            	continue;    
            }
            
            feedsToInsert.add(newFeedItem);
			*/
            
            String elementBody = removeHtml(item.Body);
            //replace html markups
            elementBody = elementBody.unescapeHtml4();
            String orginallyPosted = ' originally posted by '+item.CreatedBy.Name;
            if(elementBody.containsIgnoreCase('@'+winAtPosGroup)){
                feedsToInsert.add(item);
                ogrinalPostUsersAccount.put(item.CreatedById,null);
            	//makeMention(elementBody,item.ParentId,internalGlobalWinAtPostID);
            }    
        }
        if(!ogrinalPostUsersAccount.isEmpty()){
            Map<Id,User> userVsContactMap = new Map<Id,User>([SELECT id,ContactId FROM User Where id in : ogrinalPostUsersAccount.keySet()]);
            //retrive contactId's
            Map<Id,Id> userVsContactId =  new Map<Id,Id>();
            for(User u : userVsContactMap.values()){
				userVsContactId.put(u.id,u.ContactId);    
            }
            
            Map<Id,String> contactVsAccountName = new Map<Id,String>();
            for(Contact c :[select AccountId,Account.Name,Id from Contact Where id in : userVsContactId.values()]){
                if(c.Account.Name != null){
                    contactVsAccountName.put(c.id,c.Account.Name);
                }else{
                    contactVsAccountName.put(c.id,'');
                }
            }
            for(FeedItem item : feedsToInsert){
            	String elementBody = removeHtml(item.Body);
                //replace html markups
                elementBody = elementBody.unescapeHtml4();
                String orginallyPosted = ' (originally posted by '+item.CreatedBy.Name;
                Id relatedContact = userVsContactId.get(item.CreatedById);
                if(relatedContact != null){
                    orginallyPosted += ', '+contactVsAccountName.get(relatedContact);
                }
                orginallyPosted +=')';
                if(elementBody.containsIgnoreCase('@'+winAtPosGroup)){
                    makeMention(elementBody+orginallyPosted,item.ParentId,internalGlobalWinAtPostID);
                }           
            }
            
        
        }
        
       // insert feedsToInsert;
        system.debug('following records where added:'+feedsToInsert);

    }
    
    /*******************************************************************
    Purpose: Removes html tags from  String
    asset group records
    Parameters: [String html]
    Returns: void 
    ********************************************************************/
    private String removeHtml(String html){
        if(html == null || html ==''){
        	return '';    
        }
         //first replace all <BR> tags with \n to support new lines
        string result = html.replaceAll('<br/>', '\n');
        result = result.replaceAll('<br />', '\n');
        
        //regular expression to match all HTML/XML tags
        string HTML_TAG_PATTERN = '<.*?>';
        
        // compile the pattern     
        pattern myPattern = pattern.compile(HTML_TAG_PATTERN);
        
        // get your matcher instance
        matcher myMatcher = myPattern.matcher(result);
        
        //remove the tags     
        result = myMatcher.replaceAll('');
        return result;
    }
    
    /*******************************************************************
    Purpose: Add mention to internal Win@POS group
    Parameters: [String html]
    Returns: [void] 
    ********************************************************************/
    private void makeMention(String body,String ParentId,String groupId){
        system.debug('***makeMention callout with params : @body'+body+'@ParentId'+ParentId+'@groupId');
        try{
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            mentionSegmentInput.id = groupId;
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            textSegmentInput.text = body;
            messageBodyInput.messageSegments.add(textSegmentInput);
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = ParentId;
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput, null);
        }catch(Exception ex){
            system.debug('***makeMention thrown an error:'+ex.getMessage());
        }    
    }
    
   global void finish(Database.BatchableContext BC){
   }


}