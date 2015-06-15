/* ---------------------------------------------------------------------------------------------------------------------
   Name:        BC_updateEmbedURL.trigger 
   Description: 1) Trigger on the Brand Centre content to build the embed url for video link to display on the carousel 
                   -  only for youtube or vimeo.
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   November 2013    1.0    Vanessa Barros        Initial Release 

------------------------------------------------------------------------------------------------------------------------ */


trigger BC_updateEmbedURL on Brand_Centre_Content__c (before insert, before update) {
// we only need this trigger for the Video Link record type and link URL is not null

    for(Brand_Centre_Content__c b : trigger.new){
        
        if(b.rt_name__c == 'Video Link' && b.Link_URL__c <> ''){
            if(b.source__c == 'YouTube'){
                    string id = b.Link_URL__c.substringAfter('v=');
                    b.Embeb_URL__c = '//www.youtube.com/embed/'+id;
                    
                    
            }
            if(b.source__c == 'Vimeo'){
                string id = b.Link_URL__c.substringAfter('com/');
              
                b.Embeb_URL__c ='//player.vimeo.com/video/'+ id;  
                // //player.vimeo.com/video/81382908  
            }
        }    
    }
}