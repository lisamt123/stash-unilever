/* -----------------------------------------------------------------------------------------------------------------------
   Name:        BC_all_stories.cls 
   Description: 1) Class which handles the logic to fill the all stories template
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   November 2013     1.0   Vanessa Barros      Initial Release 
   January 2014    1.1     Vanessa Barros        Change the getAllStories Method
   March 2014    1.2       Vanessa Barros        Order by published date
  ------------------------------------------------------------------------------------------------------------------------ */
  

public with sharing class BC_all_stories {

    public string css {get;set;}
    public string css_url;
    public string dynamicCss;
    public string bc_id{get;set;}
    public string bc_logo {get;set;}
    public string bc_bcolour {get;set;}
    public list<brand_centre_content__c> AllStories;
    public string backgroundImage;
    public string footer;
    public string static_resource;
    
    public BC_all_stories() {
        //getting Brand Centre id
        bc_id = System.currentPageReference().getParameters().get('bc');
        //getting css for all stories related to brand centre record
        brand_centre_new__c b =[select static_resource_name__c,logo__c,background_colour__c, CSS_All_Stories_Template__c from brand_centre_new__c where id = :bc_id];
        css_url = b.CSS_All_Stories_Template__c;
        bc_bcolour = b.background_colour__c;
        bc_logo = b.logo__c;
        static_resource = b.static_resource_name__c;
    
        
    }
    
    
    //Dynamic CSS - Method  that discover what css to use. this fetch the css parameter from the url and build the css url to upload the correct
    //css for each brand centre article
    public string getDynamicCss (){
        try{
            system.debug('css'+css_url);
            StaticResource resource = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :static_resource LIMIT 1];
                  
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
        }catch(exception ex){
            return null;
        }
    }

    //getting background Image
    public string getBackgroundImage (){
        Brand_centre_new__c b = [select background_image__c from brand_centre_new__c where id=:bc_id]; 
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
        Brand_centre_new__c b = [select footer__c from brand_centre_new__c where id=:bc_id]; 
        if(b.footer__c <> null){
            footer = b.footer__c.substringAfter('src="').substringBefore('"');
            if(footer .contains ('&amp;')){
               footer = footer .replace('&amp;','&'); 
            }
        }
        return footer ;
    }
    //getting all stories (articles, videos or non videos)
    //Vanessa Barros 18/03/2014 Order by Published date change 
    public List<brand_centre_content__c> getAllStories(){
        try{
        AllStories = [select id,name,brand_centre__r.id,Published_Date__c,Summary__c,preview_image_id__c, preview_image2__c,
            Front_End_link__c,Target__c from brand_centre_content__c where brand_centre__c = :bc_id and header_section__r.position__c = 'Latest News'
            and display__c =true order by  Published_Date__c DESC  ];
        }catch(Exception ex){
        
        }
        system.debug('AllStories'+AllStories);
        return  AllStories;
    }
    
 
}