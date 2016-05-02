public with sharing class ArticleExtension {

  list <article__c> articlelist;
  //List<uw_Brand_Link_Sections__c> LinksSections = new List<uw_Brand_Link_Sections__c>();
  List<uw_Links__c> brandlinks = new List<uw_Links__c>();
  List<Sub_Category__c> brandsubcategory = new List<Sub_Category__c>();
  
  public ArticleExtension() {
  brandId = ApexPages.currentPage().getParameters().get('bid');        
  system.debug('ArticleExtension: bid: '+brandId );
  }


    public ApexPages.StandardController sc {get; set;}
    public String brandId {get; set;}

    public ArticleExtension(ApexPages.StandardController controller) {
    sc = controller;
    brandId = ApexPages.currentPage().getParameters().get('bid');       
    }
    
    public PageReference back() {
    system.debug('back: entry');
    PageReference pr = new PageReference('/apex/fuse_brief_3_demo_with_chatter?bid='+brandId);
    system.debug('back:'+pr);
    return pr;
    }
    
    public PageReference home() {
    PageReference pr = new PageReference('/apex/fuse_brief_3_demo_with_chatter?bid='+brandId);
    return pr;        
    }

    public list <article__c> getarticlelist()
    {
    articlelist =  [Select Picture_ID__c, Link__c, Image_Caption__c, Id, Name, Summary__c, Publish_Date__c, Ordinal__c, uw_brand__r.id From Article__c  WHERE Published__c = true and uw_brand__c = :ApexPages.currentPage().getParameters().get('bid') ORDER BY Ordinal__c];
    return articlelist;
    }
    
 /**
    public List<uw_Brand_Link_Sections__c> getlinksSections()
    { 
    LinksSections = [select id, Name, Brand_Centre__c, Style_Class__c, Position__c,Horizontal_Type__c,Section_Image_ID__c from uw_Brand_Link_Sections__c where Brand_Centre__c = :ApexPages.currentPage().getParameters().get('bid') order by Position__c ASC, Ordinal__c ASC ];      
    return LinksSections;
    }
             

    public List<uw_Links__c> getbrandlinks()
    { 
    //brandlinks = [select Link_Name__c, Link_Output__c, Brand_Link_Sections__c, Sub_Category__c, Sub_Categorys__c from uw_Links__c];
    brandlinks = [select Link_Name__c, Link_Output__c, Brand_Link_Sections__c, Sub_Category__c, Sub_Categorys__c from uw_Links__c 
                     WHERE Brand_Link_Sections__r.Brand_Centre__r.Id = :ApexPages.currentPage().getParameters().get('id') 
                     order by BC_Ordinal__c];
    return brandlinks;
    }
         
    public List<Sub_Category__c> getbrandsubcategory()
    { 
    brandsubcategory = [select Name, Brand_Link_Sections__c from Sub_Category__c where  Brand_Link_Sections__r.Brand_Centre__r.Id = :ApexPages.currentPage().getParameters().get('bid')];
    return brandsubcategory;
    }
       **/          
     }