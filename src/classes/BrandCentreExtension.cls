public class BrandCentreExtension {
        
        public string position {get;set;}
    public string Ordinal {get;set;}
    public string SectionImage {get;set;}
    public string Styleclass {get;set;}
    public string name {get;set;}
    public string Photolink{get;set;}
    public string Profilename{get;set;} 
     public string Profileid{get;set;}
    public string recordtypename{get;set;}
    public string linktype{get;set;}
        List<uw_Links__c> whoswholinks = new List<uw_Links__c>();
        List<uw_Links__c> brandlinks = new List<uw_Links__c>();
        List<Sub_Category__c> brandsubcategory = new List<Sub_Category__c>();
        
        uw_Links__c uwlink = new uw_Links__c();
    public uw_Links__c getUWLink() { return uwlink; }
        
        public BrandCentreExtension(ApexPages.StandardController controller) {
    
    ApexPages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=EmulateIE8');  
     articleImageCounter = 0;         
    recordtypename = ApexPages.currentPage().getParameters().get('retURL');
    linktype = ApexPages.currentPage().getParameters().get('type');
    User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl, u.FirstName, u.LastName, u.id From User u where u.id=:Userinfo.getUserid()];
    Photolink = u.smallPhotoUrl;
    Profilename = u.FirstName + ' ' + u.LastName;
    Profileid = u.id;
    }
          
        private static Integer articleImageCounter {get {
    if (articleImageCounter == null) {
    articleImageCounter = 0;
    }
    return articleImageCounter;
    } set;}
    
    private static final Integer ARTICLE_POSITIONS = 3;

    private void advancePosition() {
    }
    public Integer articleImagePosition {get {
    advancePosition();
    return articleImagePosition;
    } private set;
    }
        
    public Boolean pos0 {get {
    articleImagePosition = math.mod(articleImageCounter,ARTICLE_POSITIONS);
    pos0 = (articleImagePosition == 0);
        return pos0;
        } private set;
        }
        public Boolean pos1 {get {
                    
        articleImagePosition = math.mod(articleImageCounter,ARTICLE_POSITIONS);
        pos1 = (articleImagePosition == 1);
        return pos1;
        } private set;
        }
        public Boolean pos2 {get {
        articleImagePosition = math.mod(articleImageCounter,ARTICLE_POSITIONS);
        pos2 = (articleImagePosition == 2);
        articleImageCounter++;          
        return pos2;
        } private set;
        }
    
        
        
        public List<Article__c> articles {get {
    if (articles == null) {
    articles = new List<Article__c>();
    }
    return articles;
    } private set;
    }
    
    
    
    list <article__c> articlelist;
    
    public list <article__c> getarticlelist()
    {        
    articlelist =  [Select Picture_ID__c, Link__c, Image_Caption__c, Id, Name, Summary__c, Publish_Date__c, Ordinal__c From Article__c  WHERE Published__c = true and uw_brand__c = :ApexPages.currentPage().getParameters().get('id') ORDER BY Ordinal__c];
    return articlelist;
    }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

}