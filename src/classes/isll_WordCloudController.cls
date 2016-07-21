/**********************************************************************
 Name:  isll_WordCloudController
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:Manages the word cloud                                                         
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     16/07/2013        INITIAL DEVELOPMENT         Story id:USLL-179      
 
***********************************************************************/

public with sharing class isll_WordCloudController {
    
    /*******************************************************************
       Purpose:  returns a list of topic wrapped objects                                                        
       Returns: List<topicWrapper> - List of wrapped topics                                                       
    ********************************************************************/
    public List<topicWrapper> getTrendingTopics(){
       
        
        List<FeedItem> feedItems  =  isll_ChatterComponentController.getGroupFeed();
        
        
        List<topicWrapper> topicsWrapped = new List<topicWrapper>();
        
        map<id, integer> topicWeights = new map<id, integer>();
        for(AggregateResult ar :    [Select     COUNT(Id)total, TopicId 
                                    From        TopicAssignment 
                                    Where       EntityId in : feedItems  
                                        And     CreatedDate >= LAST_N_DAYS:60
                                    Group By    TopicId])
        {
            topicWeights.put(String.valueOf(ar.get('TopicId')) , Integer.valueOf(ar.get('Total')));
        }
        
        //get topic details
        for(Topic tp: [select Name, Id from Topic where id IN : topicWeights.KeySet()]){
            topicsWrapped.add(new topicWrapper(tp.name, tp.id, topicWeights.get(tp.id)));
        }

        topicsWrapped.sort();

        List<topicWrapper> topicsWrappedTemp = new List<topicWrapper>();
        
        if(topicsWrapped.size() > 7){   
            for(integer i = 0; i < 7 ; i++){
                topicsWrappedTemp.add(topicsWrapped[i]);
            }
            topicsWrapped = topicsWrappedTemp;
        }
        else if(topicsWrapped.size() < 7) {
            while (topicsWrapped.size() < 7){
                topicsWrapped.add(new topicWrapper('', null, 0));
            }
        }

        return topicsWrapped;
    
    }
    
    /*******************************************************************
       Name:    this is the topic wrapper, used to create the world cloud.                                                      
    ********************************************************************/
    public class topicWrapper implements Comparable{
        public String name {get;set;}
        public Id topicId {get;set;}
        public integer weight {get;set;}
        
        public topicWrapper(String name, Id topicId, Integer weight){
            this.name = name;
            this.topicId = topicId;
            this.weight = weight;
        }

        public Integer compareTo(Object compareTo) {
            topicWrapper compareToTopic = (topicWrapper)compareTo;
            if (weight == compareToTopic.weight) return 0;
            if (weight > compareToTopic.weight) return -1;
            return 1;        
        }
    }
}