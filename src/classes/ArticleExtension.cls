public with sharing class ArticleExtension {

  list <article__c> articlelist;
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
    articlelist =  [Select Picture_ID__c, Link__c, Image_Caption__c, Id, Name, Summary__c, Publish_Date__c, uw_brand__r.id From Article__c  WHERE Published__c = true and uw_brand__c = :ApexPages.currentPage().getParameters().get('bid') ];
    return articlelist;
    }
            
                
     }