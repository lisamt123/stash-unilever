/* -----------------------------------------------------------------------------------------------------------------------
   Name:        BC_article_template.cls 
   Description: 1) Class which handles the logic to fill the article template (single)
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   November 2013     1.0    Vanessa Barros        Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */
  

public with sharing class BC_article_template {

    public string css {get;set;}
    public string css_url;
    public string dynamicCss;
    private final Brand_centre_content__c article;
    public string backgroundImage;
    public string footer;
    public string static_resource;
    
    public BC_article_template(ApexPages.StandardController controller) {
        //getting Article record
       this.article = (Brand_centre_content__c)controller.getRecord();
       brand_centre_new__c b =[select   static_resource_name__c, CSS_Article_Template__c from brand_centre_new__c where id = :article.Brand_Centre__c];
       css_url = b.CSS_Article_Template__c;
       static_resource = b.static_resource_name__c;
       
    }
    
     //Dynamic CSS - Method  that discover what css to use. this fetch the css parameter from the url and build the css url to upload the correct
    //css for each brand centre article
    public string getDynamicCss (){
        try{
            StaticResource resource = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :static_resource LIMIT 1];
            system.debug('static_resource'+ static_resource);
                  
            system.debug('css_url' + css_url);
            
            if(resource!=null){
            
                String namespace = resource.NamespacePrefix;
                
                dynamicCss = URL.getSalesforceBaseUrl().toExternalForm() + '/resource/' + resource.SystemModStamp.getTime() + '/' + 
                  (namespace != null && namespace != '' ? namespace + '__' : '') + static_resource+'/'+ css_url+'.css';
                
                system.debug('dynamicCss'+ dynamicCss);
            
            }else{
                dynamicCss = '';
            }
                  
            return dynamicCss;
        }catch(Exception ex){
            return null;
        } 
        return null;
    }
    
    public Pagereference editLink(){
        PageReference page = new ApexPages.StandardController(article).edit();
        return page;
    
    }
    
    //getting background Image
    public string getBackgroundImage (){
        Brand_centre_new__c b = [select background_image__c from brand_centre_new__c where id=:article.Brand_Centre__c]; 
        if(b.background_image__c <> null){
            backgroundImage = b.background_image__c.substringAfter('src="').substringBefore('"');
            if(backgroundImage.contains ('&amp;')){
               backgroundImage = backgroundImage.replace('&amp;','&'); 
            }
        }
        return backgroundImage;
    }
    
    //getting footer image
    public string getFooter (){
        Brand_centre_new__c b = [select footer__c from brand_centre_new__c where id=:article.Brand_Centre__c]; 
        if(b.footer__c <> null){
            footer = b.footer__c.substringAfter('src="').substringBefore('"');
            if(footer .contains ('&amp;')){
               footer = footer .replace('&amp;','&'); 
            }
        }
        return footer ;
    }

}