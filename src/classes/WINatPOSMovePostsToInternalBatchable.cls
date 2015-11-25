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
      return Database.getQueryLocator('select Body, ContentData, ContentDescription, ContentFileName,CreatedById, CreatedDate, LinkUrl, Title,ParentID, Type from FeedItem Where Visibility =:visibility and NetworkScope =:networkScope and CreatedDate>=Yesterday order by CreatedDate ASC');
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
        Map<Id,User> ogrinalPostUsers = new Map<Id,User>();
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
            if(elementBody.containsIgnoreCase('@'+winAtPosGroup)){
            	makeMention(elementBody,item.ParentId,internalGlobalWinAtPostID);
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