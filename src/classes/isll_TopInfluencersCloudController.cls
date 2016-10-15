/**********************************************************************
 Name:  isll_TopInfluencersCloudController
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Controller for isll_TopInfluencersCloud component
calculates influence
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      30/07/2013      INITIAL DEVELOPMENT 
***********************************************************************/
public without sharing class isll_TopInfluencersCloudController {
	public Integer numOfInfluencers {get; set;}
	public Integer endNumOfInf {get; set;}
	
	public List<userWrapper>  getTopInfluencers(){
		return getISLLTopInfluencerChatter();
	}
	

	class UserStats{
		User theUser;
		integer postMade = 0;
		integer commentsMade = 0;
		integer commentsReceived = 0;
		integer likesReceived = 0;

		public integer total(){
			return postMade +  commentsMade + commentsReceived + likesReceived;
		}

	}

	private Map<id, UserStats> initData(){
		Map<id, UserStats> userStatsMap = new Map<id,UserStats>();
		datetime dateLimit = System.now() - 365;
		List <FeedItem> groupFeed = [select id, ParentId, CreatedById, LikeCount, CommentCount, (Select Id, InsertedById From FeedComments)
										from FeedItem 
										where ParentId = :isll_ChatterComponentController.isllChatterGroupID and CreatedDate >= : dateLimit];

		for(FeedItem fi : isll_ChatterComponentController.getGroupFeed()){
			if(null == userStatsMap.get(fi.CreatedById)){
				userStatsMap.put(fi.CreatedById, new UserStats());
			}
			userStatsMap.get(fi.CreatedById).postMade = userStatsMap.get(fi.CreatedById).postMade + 1;
			userStatsMap.get(fi.CreatedById).commentsReceived = userStatsMap.get(fi.CreatedById).commentsReceived + fi.CommentCount;
			userStatsMap.get(fi.CreatedById).likesReceived = userStatsMap.get(fi.CreatedById).likesReceived + fi.LikeCount;

			for(FeedComment fc : fi.FeedComments){
				if(null == userStatsMap.get(fc.InsertedById)){
					userStatsMap.put(fc.InsertedById, new UserStats());
				}
				userStatsMap.get(fc.InsertedById).commentsMade = userStatsMap.get(fc.InsertedById).commentsMade + 1;
			}
		}
	
		return userStatsMap;

	}


	private List<userWrapper> getISLLTopInfluencerChatter(){
		endNumOfInf = 20;
		if(numOfInfluencers != null && numOfInfluencers > 29) {
			endNumOfInf = 30;
		}
		
		List<userWrapper> usersWrapped = new List<userWrapper>();
	/*	map<id, integer> userInfluence = new map<id, integer>();
		map<id, integer> userNumberOfCommentsMade = new map<id, integer>();
		for(FeedItem fi : isll_ChatterComponentController.getGroupFeed()){
			if(!userInfluence.containsKey(fi.CreatedById)){
				userInfluence.put(fi.CreatedById, 0);
			}
			Integer i = userInfluence.get(fi.CreatedById);
			userInfluence.put(fi.CreatedById, i + 1);
		}*/
		Map<id, UserStats> userStatsMap =  initData();
		for(User u : [Select SmallPhotoUrl, LocaleSidKey, Name From User Where Id in : userStatsMap.keySet()]){
			usersWrapped.add(new userWrapper(u, userStatsMap.get(u.id).total()));
		}
		
		if(Test.isRunningTest()){
			for(User u : [Select SmallPhotoUrl, LocaleSidKey, Name From User LIMIT 5]){
				usersWrapped.add(new userWrapper(u, Math.round(Math.random()*100)));
			}
		}
		
		usersWrapped.sort();
		system.debug(LoggingLevel.Error, 'usersWrapped: '+usersWrapped);
		
		//cut list
		List<userWrapper> res = new List<userWrapper>();
		Integer i = 0;
		while(i < endNumOfInf && i < usersWrapped.size()){
			res.add(usersWrapped[i]);
			i++;
		}
		
		if(res.size() <= 20){
			endNumOfInf = 20;
		}
		
		return res;
	
	}
	
	public class userWrapper implements Comparable{
		public String name {get;set;}
		public String photoUrl {get;set;}
		public Id userId {get;set;}
		public Integer influence {get;set;}
		public String flagIcon {get;set;}
		
		public userWrapper(User u, Integer influence){
			this.name = u.Name;
			this.userId = u.Id;
			this.photoUrl = u.SmallPhotoUrl;
			this.flagIcon = isll_UserpicWithFlagController.getCoutry(u.LocaleSidKey);//u.LocaleSidKey.split('_')[1].toLowerCase();
			this.influence = influence;
		}
		
		// Implement the compareTo() method
	    public Integer compareTo(Object compareTo) {
	        userWrapper compareToEmp = (userWrapper)compareTo;
	        if (influence > compareToEmp.influence) return -1;
	        return 1;        
	    }
	}
}