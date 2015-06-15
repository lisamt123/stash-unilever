/* -----------------------------------------------------------------------------------------------------------------------
   Name:        BC_embebVideo.cls 
   Description: 1) Class which handles the logic to display the video on the carousel
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   November 2013     1.0    Vanessa Barros        Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */
  
public class BC_embebVideo{
    
    public string bc_id;
    public string b;
    public string css_url;
    public string dynamicCss;
    public string backgroundImage;
    public string footer;
    public string backgroundColour;
    private final Brand_centre_content__c video;
    public string embedUrl{get;set;}
    public string static_resource;
    
    public BC_embebVideo(ApexPages.StandardController controller) {
        //getting the brand content id from the url parameter
        bc_id = System.currentPageReference().getParameters().get('bc_id');
        //getting the brand centre id from the url parameter
        b=System.currentPageReference().getParameters().get('b');
        //getting the embed URL from brand content
        Brand_centre_content__c video = [select embeb_url__c from Brand_centre_content__c where id =: bc_id];
        embedUrl = video.embeb_url__c;
    }
    
    //Dynamic CSS - Method  that discover what css to use. this fetch the css parameter from the url and build the css url to upload the correct
    //css for each brand centre page
    public string getDynamicCss (){
    
        
           //getting css name    
           Brand_centre_new__c b = [select static_resource_name__c,css_name__c from brand_centre_new__c where id=:b];  
           css_url = b.css_name__c;
           static_resource = b.static_resource_name__c;
            Try{           
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
            } catch(Exception ex){
                return null;
            } 
       return null; 
    }
    //getting background Image
    public string getBackgroundImage (){
        Brand_centre_new__c b = [select background_image__c from brand_centre_new__c where id=:b]; 
        if(b.background_image__c <> null){
            backgroundImage = b.background_image__c.substringAfter('src="').substringBefore('"');
            if(backgroundImage.contains ('&amp;')){
               backgroundImage = backgroundImage.replace('&amp;','&'); 
            }
            system.debug(' backgroundImage'+ backgroundImage);
        }
        return backgroundImage;
    }
    
    //getting footer image
    public string getFooter (){
        Brand_centre_new__c b = [select footer__c from brand_centre_new__c where id=:b];
        if(b.footer__c <> null){ 
            footer = b.footer__c.substringAfter('src="').substringBefore('"');
            if(footer .contains ('&amp;')){
               footer = footer .replace('&amp;','&'); 
            }
            system.debug(' footer'+ footer);
        }
        return footer ;
    }
    //getting background colour
    public string getBackgroundColour(){
        Brand_centre_new__c b = [select background_colour__c from brand_centre_new__c where id=:b];
        if(b.background_colour__c <> null){ 
            backgroundColour = b.background_colour__c;
            system.debug(' backgroundColour'+ backgroundColour);
        }
        return backgroundColour ;
    }
    
    
    

}