public class AIWJSONParser {

    public class CategoryDetails {
        public String id;
        public String name;
        public String parentId;
        public String parentName;
    }

    public Integer resultsTotal;
    public Integer resultsPage;
    public Integer resultsPageSize;
    public List<Results> results;
    public Long maximumId;
    public Long maximumIdInResult;
    public String startDate;
    public String endDate;

    public class Results {
        public String accountType;
        public String assignment;
        public String author;
        public String authorCity;
        public String authorCityCode;
        public String authorContinent;
        public String authorContinentCode;
        public String authorCountry;
        public String authorCountryCode;
        public String authorCounty;
        public String authorCountyCode;
        public String authorLocation;
      public String authorState;
       public String authorStateCode;
       public String avatarUrl;
       public Integer averageDurationOfVisit;
       public Integer averageVisits;
        public Integer backlinks;
       public Integer blogComments;
       public List<Integer> categories;
     public List<CategoryDetails> categoryDetails;
        public Boolean checked;
        public String city;
        public String cityCode;
        public String continent;
        public String continentCode;
       public String country;
        public String countryCode;
        public String county;
        public String countyCode;
        public Date sociodate;
        public String displayUrls;
        public String domain;
        public Integer editorialValueEUR;
        public Integer editorialValueGBP;
        public Integer editorialValueUSD;
        public Double engagement;
        public String expandedUrls;
        public String facebookAuthorId;
        public Integer facebookComments;
        public Integer facebookLikes;
        public String facebookRole;
       public Integer facebookShares;
        public String facebookSubtype;
        public Integer forumPosts;
        public Integer forumViews;
       public String fullname;
        public String gender;
        public Long id;
        public Integer impact;
        public Integer importanceAmplification;
        public Integer importanceReach;
       public Integer impressions;
        public Integer influence;
        public List<String> insightsHashtag;
       public List<String> insightsMentioned;
        public List<String> interest;
        public String language;
       public String lastAssignmentDate;
        public Double latitude;
        public Double longitude;
        public List<MatchPositions> matchPositions;
        public String mediaUrls;
        public Long monthlyVisitors;
        public Double mozRank;
        public List<NoteIds> noteIds;
        public Integer outreach;
        public String pageType;
        public Integer pagesPerVisit;
        public Integer percentFemaleVisitors;
        public Integer percentMaleVisitors;
        public String priority;
        public List<NoteIds> professions;
        public Integer queryId;
        public String queryName;
        public Integer reach;
        public String replyTo;
        public Long resourceId;
        public String resourceType;
        public String retweetOf;
        public String sentiment;
        public String shortUrls;
       public String snippet;
        public Boolean starred;
        public String state;
        public String stateCode;
        public String status;
        public List<String> tags;
        public String threadAuthor;
        public String threadCreated;
        public String threadEntryType;
       public String threadId;
        public String threadURL;
        public String title;
       public Integer trackedLinkClicks;
        public String trackedLinks;
        public String twitterAuthorId;
        public Integer twitterFollowers;
        public Integer twitterFollowing;
        public Integer twitterPostCount;
        public Integer twitterReplyCount;
        public Integer twitterRetweets;
       public String twitterRole;
        public Boolean twitterVerified;
       public String url;
        public String wordCount;
    }

    public class MatchPositions {
        public Integer start;
        public String text;
        public Integer length;
    }

    public class NoteIds {
    }

    
    public static AIWJSONParser parse(String json) {
        return (AIWJSONParser) System.JSON.deserialize(json, AIWJSONParser.class);
    }
}