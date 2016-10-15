public without sharing class isll_ChatterComponentController {
	public ID selectedGroupID {get;set;}
	public string postText {get;set;}
	public static final string CHATTER_GROUP_NAME = ISLL_Custom_Settings__c.getValues('ISLL Chatter Group').String_Value__c;
	
	public static ID isllChatterGroupID{
		get{
			
			for(CollaborationGroup grp  :  [select id, Name from CollaborationGroup where name = :CHATTER_GROUP_NAME]){
				if(grp.Name == CHATTER_GROUP_NAME){
					return grp.id;
				}
			}
			return null;
		}
		set;
	}
	
	
	public static List<FeedItem> getGroupFeed(){
		return [select id, ParentId, CreatedById, LikeCount, CommentCount, (Select Id, InsertedById From FeedComments)
				from FeedItem 
				where ParentId = :isllChatterGroupID];
	}

	public void shareFile(id contentID){
		FeedItem newFi = new FeedItem();
		newFi.Body = postText;
		newFi.Type='ContentPost';
		newFi.RelatedRecordId = contentID;
		newFi.ParentId = isllChatterGroupID;
		if(!Test.isRunningTest()){
			insert newFi;
		}
		postText = '';
		
	}
	
	public void shareNews(String link, String text){
		FeedItem newFi = new FeedItem();
		newFi.Body = postText;
		newFi.Type='LinkPost';
		newFi.Title = text;
		newFi.LinkUrl = link;
		newFi.ParentId = isllChatterGroupID;
		if(!Test.isRunningTest()){
			insert newFi;
		}
		postText = '';
		
	}
	
	//Chatter component functionality
	
	public List<String> expertsIds {get; set;}
	public String chatterId {get; set;}
	public Boolean isFiltered {get; set;}

	public List<FeedItemWrapper> getExpertsFeed(){
		Map<Id, List<FeedItem>> userId_FeedItemsMap = new Map<Id, List<FeedItem>>(); 
		List<FeedItem> feedItems = new List<FeedItem>();
		Set<Id> contentVersionIds = new Set<Id>();
		
		String eId = Apexpages.CurrentPage().getParameters().get('id');
		if(chatterId == null){
			chatterId = Apexpages.CurrentPage().getParameters().get('chatterId');
		}
		
		String query = 'select id, ParentId, CreatedById, Body, CreatedDate, RelatedRecordId, ContentFileName, ContentSize, ' +
							'(Select Id, InsertedById, InsertedBy.Name, InsertedBy.SmallPhotoUrl, CommentBody, CreatedDate, RelatedRecordId ' +
							'From FeedComments) ' +
						'from FeedItem ' + 
						'where ParentId = : chatterId ';
						
		if(isFiltered != null && isFiltered){
			expertsIds = new List<Id>();
			
			for(Event_Member__c aMember : [select id, name, User__c, User__r.Name, User__r.SmallPhotoUrl, User__r.FullPhotoUrl, User__r.LocaleSidKey, 
						Event__c, Is_Expert__c, Member_Type__c 
					from Event_Member__c where Event__c = :eId and Is_Expert__c = true]){			
				
				expertsIds.add(aMember.User__c);
			}
			
			query += ' and CreatedById IN : expertsIds ';
		}
		
		for(FeedItem fi : Database.query(query)){
			if(!userId_FeedItemsMap.containsKey(fi.CreatedById)){
				userId_FeedItemsMap.put(fi.CreatedById, new List<FeedItem>());
			}
			userId_FeedItemsMap.get(fi.CreatedById).add(fi);
			
			feedItems.add(fi);
			
			if(fi.FeedComments != null){
				for(FeedComment fc : fi.FeedComments){
					if(fc.RelatedRecordId != null){
						contentVersionIds.add(fc.RelatedRecordId);
					}
				}
			}
		}
		
		Map<Id, User> users = new Map<Id, User>([SELECT Name, SmallPhotoUrl FROM User WHERE Id IN : userId_FeedItemsMap.keySet()]);
		
		Map<Id, ContentVersion> filesMap = new Map<Id, ContentVersion>([SELECT ContentSize, Title FROM ContentVersion WHERE Id IN : contentVersionIds]);
		
		List<FeedItemWrapper> expertFeed = new List<FeedItemWrapper>();	
		
		for(FeedItem fi : feedItems){
			FeedItemWrapper fiw = new FeedItemWrapper(fi, users, filesMap);
			expertFeed.add(fiw);
		}
		
		return expertFeed;
	}

	public class FeedItemWrapper{
		public FeedItem item {get; set;}
		public User owner {get; set;}
		public List<FeedCommentWrapper> comments {get; set;}
		
		public FeedItemWrapper(FeedItem item, Map<Id, User> users, Map<Id, ContentVersion> filesMap){
			this.item = item;
			this.owner = users.get(item.CreatedById);
			comments = new List<FeedCommentWrapper>();
			
			if(item.FeedComments != null){
				for(FeedComment fc : item.FeedComments){
					comments.add(new FeedCommentWrapper(fc, filesMap));
				}
			}
		}
	}
	
	public class FeedCommentWrapper{
		public FeedComment comment {get; set;}
		public ContentVersion file {get; set;}
		
		public FeedCommentWrapper(FeedComment fc, Map<Id, ContentVersion> filesMap){
			comment = fc;
			if(fc.RelatedRecordId != null){
				file = filesMap.get(fc.RelatedRecordId);
			}
		}
	}
}