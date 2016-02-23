public class AIWJSONParser_2 {
  
   
     public String avatarUrl;
        public String snippet;
        public Integer twitterRetweets;
        public Integer reach;
        public Integer twitterFollowing;
        public Integer influence;
        public Integer outreach;
        public String sociodate;
        public String fullname;
        
       
       

  
     public static List<AIWJSONParser_2> parse(String json) {
        return (List<AIWJSONParser_2>) System.JSON.deserialize(json, List<AIWJSONParser_2>.class);
    }      
          
}