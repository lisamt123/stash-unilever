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
       // List<uw_Brand_Link_Sections__c> LinksSections = new List<uw_Brand_Link_Sections__c>();
        List<uw_Links__c> brandlinks = new List<uw_Links__c>();
       // List<Sub_Category__c> brandsubcategory = new List<Sub_Category__c>();
        
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
        
      /**  public pagereference savesection()
    {
    string brandcentre = ApexPages.currentPage().getParameters().get('retURL');
    
    uw_Brand_Link_Sections__c linksec = new uw_Brand_Link_Sections__c (Name = name, Position__c = position, Section_Image_ID__c =SectionImage, Style_Class__c = Styleclass, Brand_Centre__c = brandcentre  );
        insert linksec;
    return new PageReference ('/' + brandcentre);
    }
    **/
    public pagereference savelink()
    {
   
    try{    
    linktype = ApexPages.currentPage().getParameters().get('type');
    }catch(exception e) {}
    string returnurl = ApexPages.currentPage().getParameters().get('returnurl');
    uw_links__c newulway;
    if(linktype<>null)
    {    
    if (linktype.contains('subcategory') == true)
    {
        try{
   
    newulway = new uw_links__c(Sub_Categorys__c = returnurl, Link_Name__c = uwlink.Link_Name__c, Link_URL__c = uwlink.Link_URL__c , Link_Description__c = uwlink.Link_Description__c ,BC_Ordinal__c = uwlink.BC_Ordinal__c , Link_Type__c = 'Vertical Link');
    insert newulway;
        }
        catch(exception e){}
    }
    
    else if (linktype.contains('sectionlink') ==  true) 
    {
        try{
                

    newulway = new uw_links__c(Link_Name__c = uwlink.Link_Name__c, Link_URL__c = uwlink.Link_URL__c , Link_Description__c = uwlink.Link_Description__c ,BC_Ordinal__c = uwlink.BC_Ordinal__c, Link_Type__c = 'Horizontal Link' ); 
    insert newulway;
        }
        catch(exception e){}
    }
        
    else if (linktype.contains('whoswho') == true) 
    {
        try{

    newulway = new uw_links__c(uw_brand__c = returnurl, Link_Name__c = uwlink.Link_Name__c, Link_URL__c = uwlink.Link_URL__c , Link_Description__c = uwlink.Link_Description__c ,BC_Ordinal__c = uwlink.BC_Ordinal__c, Link_Type__c = 'Whos Who' );  
    insert newulway;
        }
        catch(exception e){}
    }
    else
    {
        
        
    }
    }
    return new PageReference ('/' + returnurl);
    }
        
        
        public List<uw_Links__c> getwhoswholinks()
    { 
        
    whoswholinks = [select Link_Name__c, Link_Output__c, uw_brand__C from uw_Links__c where uw_brand__C = :ApexPages.currentPage().getParameters().get('id') and Link_Type__c = 'Whos Who' order by BC_Ordinal__c];
    return whoswholinks;
    }
        
    /**    
    public List<uw_Brand_Link_Sections__c> getlinksSections()
    { 
        LinksSections = [select id, Name, Brand_Centre__c, Style_Class__c, Position__c,Horizontal_Type__c,Section_Image_ID__c from uw_Brand_Link_Sections__c where Brand_Centre__c = :ApexPages.currentPage().getParameters().get('id') order by Position__c ASC, Ordinal__c ASC ];
        return LinksSections;
    }
        
    public List<uw_Links__c> getbrandlinks()
    { 
       brandlinks = [select Link_Name__c, Link_Output__c, Brand_Link_Sections__c, Sub_Category__c, Sub_Categorys__c from uw_Links__c 
                     WHERE Brand_Link_Sections__r.Brand_Centre__r.Id = :ApexPages.currentPage().getParameters().get('id') 
                     order by BC_Ordinal__c];
 
       return brandlinks;
    }
        
    public List<Sub_Category__c> getbrandsubcategory()
    { 
    brandsubcategory = [select Name, Brand_Link_Sections__c from Sub_Category__c where  Brand_Link_Sections__r.Brand_Centre__r.Id = :ApexPages.currentPage().getParameters().get('id')];
    return brandsubcategory;
    }
     **/   
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